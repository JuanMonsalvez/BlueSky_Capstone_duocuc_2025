using System;
using System.Configuration;
using System.Text.RegularExpressions;
using System.Web.UI;
using MySql.Data.MySqlClient;
using bluesky.Services;          // EmailService
using BCrypt.Net;                // BCrypt.Net-Next

namespace bluesky
{
    public partial class OlvidasteContrasena : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ActualizarVisibilidadPasos();
            }
        }

        private void ActualizarVisibilidadPasos()
        {
            // Si no hay solicitud de reset, estamos en PASO 1
            if (Session["PWD_Reset_Rut"] == null)
            {
                panelPaso1.Visible = true;
                panelPaso2.Visible = false;
                panelPaso3.Visible = false;
                return;
            }

            // Si hay solicitud y aún no se validó el código → PASO 2
            bool codigoVerificado = Session["PWD_Code_Verificado"] != null &&
                                    (bool)Session["PWD_Code_Verificado"];

            if (!codigoVerificado)
            {
                panelPaso1.Visible = false;
                panelPaso2.Visible = true;
                panelPaso3.Visible = false;
            }
            else
            {
                // Código verificado → PASO 3
                panelPaso1.Visible = false;
                panelPaso2.Visible = false;
                panelPaso3.Visible = true;
            }
        }

        // =========================
        // PASO 1: enviar código
        // =========================
        protected void btnEnviarCodigo_Click(object sender, EventArgs e)
        {
            lblMensaje.Text = "";
            lblError.Text = "";

            string input = (txtUserOrEmail.Text ?? "").Trim();

            if (string.IsNullOrEmpty(input))
            {
                lblError.Text = "Debes ingresar tu correo o tu RUT con dígito verificador.";
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

            bool esEmail = input.Contains("@");

            // Variables para RUT + DV
            string rutDigits = "";
            string dv = "";

            if (!esEmail)
            {
                // Normalizamos: sacamos puntos, guiones y espacios, pero dejamos dígitos y K/k
                string limpio = Regex.Replace(input, @"[^0-9kK]", "");

                if (limpio.Length < 2)
                {
                    lblError.Text = "El RUT ingresado no es válido. Debe incluir número y dígito verificador.";
                    return;
                }

                dv = limpio.Substring(limpio.Length - 1, 1).ToUpper();    // último carácter = DV
                rutDigits = limpio.Substring(0, limpio.Length - 1);       // resto = parte numérica

                if (!Regex.IsMatch(rutDigits, @"^[0-9]+$"))
                {
                    lblError.Text = "El RUT ingresado no es válido.";
                    return;
                }
            }

            // Ahora buscamos por:
            // - persemail = @mail, o
            // - persrut (parte numérica) + persdv (dígito verificador)
            string sql = @"
                SELECT
                    persrut,
                    persdv,
                    persnombre,
                    perspatern,
                    persemail
                FROM usuario
                WHERE persemail = @mail
                   OR (
                        REPLACE(REPLACE(persrut, '.', ''), '-', '') = @rutDigits
                        AND UPPER(persdv) = @dv
                      )
                LIMIT 1;";

            try
            {
                using (var cn = new MySqlConnection(cs))
                using (var cmd = new MySqlCommand(sql, cn))
                {
                    cmd.Parameters.Add("@mail", MySqlDbType.VarChar).Value = esEmail ? input : "";
                    cmd.Parameters.Add("@rutDigits", MySqlDbType.VarChar).Value = rutDigits;
                    cmd.Parameters.Add("@dv", MySqlDbType.VarChar).Value = dv;

                    cn.Open();

                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read())
                        {
                            lblError.Text = "No se encontró un usuario con esos datos.";
                            return;
                        }

                        string persrut = rd["persrut"]?.ToString() ?? "";
                        string persdv = rd["persdv"]?.ToString() ?? "";
                        string nombre = rd["persnombre"]?.ToString() ?? "";
                        string patern = rd["perspatern"]?.ToString() ?? "";
                        string email = rd["persemail"]?.ToString() ?? "";

                        if (string.IsNullOrWhiteSpace(email))
                        {
                            lblError.Text = "El usuario no tiene un correo registrado. Contacta al administrador.";
                            return;
                        }

                        // Código de 6 dígitos
                        var random = new Random();
                        string code = random.Next(100000, 999999).ToString();

                        // Expira en 3 minutos
                        DateTime expires = DateTime.Now.AddMinutes(3);

                        string nombreCompleto = $"{nombre} {patern}".Trim();

                        // Guardamos datos en sesión
                        Session["PWD_Reset_Rut"] = persrut;          // parte numérica o como lo tengas guardado
                        Session["PWD_Reset_DV"] = persdv;           // opcional, por si lo quieres usar luego
                        Session["PWD_Reset_Email"] = email;
                        Session["PWD_Reset_Nombre"] = nombreCompleto;
                        Session["PWD_Reset_Code"] = code;
                        Session["PWD_Reset_Expires"] = expires;
                        Session["PWD_Code_Verificado"] = false;

                        // Enviamos correo
                        try
                        {
                            var emailService = new EmailService();
                            string subject = "Código para restablecer tu contraseña - BlueSky";
                            string body = $@"
                                Hola {nombreCompleto},<br/><br/>
                                Has solicitado restablecer tu contraseña en el portal de capacitaciones de BlueSky.<br/><br/>
                                Tu código de verificación es:<br/>
                                <h2>{code}</h2>
                                Este código expira en 3 minutos.<br/><br/>
                                Si no fuiste tú, puedes ignorar este mensaje.
                            ";

                            emailService.SendEmail(email, subject, body);
                        }
                        catch (Exception)
                        {
                            LimpiarSesionReset();
                            lblError.Text = "No se pudo enviar el correo de verificación. Intenta más tarde.";
                            ActualizarVisibilidadPasos();
                            return;
                        }

                        lblMensaje.Text = $"Te enviamos un código de verificación al correo {email}.";
                        ActualizarVisibilidadPasos();
                    }
                }
            }
            catch (MySqlException)
            {
                lblError.Text = "Ocurrió un error al buscar el usuario. Inténtalo nuevamente.";
            }
        }

        // =========================
        // PASO 2: validar código
        // =========================
        protected void btnValidarCodigo_Click(object sender, EventArgs e)
        {
            lblMensaje.Text = "";
            lblError.Text = "";

            if (Session["PWD_Reset_Rut"] == null ||
                Session["PWD_Reset_Email"] == null ||
                Session["PWD_Reset_Code"] == null ||
                Session["PWD_Reset_Expires"] == null)
            {
                lblError.Text = "La solicitud de cambio de contraseña ha expirado. Vuelve a comenzar el proceso.";
                LimpiarSesionReset();
                ActualizarVisibilidadPasos();
                return;
            }

            string codeIngresado = (txtCodigo.Text ?? "").Trim();
            string codeCorrecto = Session["PWD_Reset_Code"].ToString();
            DateTime expires = (DateTime)Session["PWD_Reset_Expires"];

            if (DateTime.Now > expires)
            {
                LimpiarSesionReset();
                lblError.Text = "El código ha expirado. Vuelve a solicitar uno nuevo.";
                ActualizarVisibilidadPasos();
                return;
            }

            if (codeIngresado != codeCorrecto)
            {
                lblError.Text = "El código ingresado no es correcto.";
                return;
            }

            // Marcar que el código fue verificado
            Session["PWD_Code_Verificado"] = true;

            lblMensaje.Text = "Código verificado correctamente. Ahora puedes definir una nueva contraseña.";
            ActualizarVisibilidadPasos();
        }

        // =========================
        // PASO 3: cambiar contraseña
        // =========================
        protected void btnCambiarPass_Click(object sender, EventArgs e)
        {
            lblMensaje.Text = "";
            lblError.Text = "";

            if (Session["PWD_Reset_Rut"] == null ||
                Session["PWD_Reset_Email"] == null ||
                Session["PWD_Reset_Expires"] == null)
            {
                lblError.Text = "La solicitud de cambio de contraseña ha expirado. Vuelve a comenzar el proceso.";
                LimpiarSesionReset();
                ActualizarVisibilidadPasos();
                return;
            }

            bool codigoVerificado = Session["PWD_Code_Verificado"] != null &&
                                    (bool)Session["PWD_Code_Verificado"];

            if (!codigoVerificado)
            {
                lblError.Text = "Debes validar el código antes de cambiar la contraseña.";
                ActualizarVisibilidadPasos();
                return;
            }

            string nuevaPass = (txtNuevaPass.Text ?? "").Trim();
            string confirmarPass = (txtConfirmarPass.Text ?? "").Trim();

            if (string.IsNullOrEmpty(nuevaPass) || string.IsNullOrEmpty(confirmarPass))
            {
                lblError.Text = "Debes ingresar la nueva contraseña y su confirmación.";
                return;
            }

            if (nuevaPass != confirmarPass)
            {
                lblError.Text = "Las contraseñas no coinciden.";
                return;
            }

            if (nuevaPass.Length < 6)
            {
                lblError.Text = "La contraseña debe tener al menos 6 caracteres.";
                return;
            }

            string rut = Session["PWD_Reset_Rut"].ToString();

            string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;
            string hash = BCrypt.Net.BCrypt.HashPassword(nuevaPass);

            string sql = @"UPDATE usuario SET usuclave = @hash WHERE persrut = @rut;";

            try
            {
                using (var cn = new MySqlConnection(cs))
                using (var cmd = new MySqlCommand(sql, cn))
                {
                    cmd.Parameters.Add("@hash", MySqlDbType.VarChar).Value = hash;
                    cmd.Parameters.Add("@rut", MySqlDbType.VarChar).Value = rut;

                    cn.Open();
                    int filas = cmd.ExecuteNonQuery();

                    if (filas == 0)
                    {
                        lblError.Text = "No se pudo actualizar la contraseña. Intenta nuevamente.";
                        return;
                    }
                }

                // ✅ Contraseña actualizada: limpiamos sesión y redirigimos a IniciarSesion
                LimpiarSesionReset();

                ScriptManager.RegisterStartupScript(
                    this,
                    GetType(),
                    "pwdOk",
                    "alert('Tu contraseña ha sido actualizada correctamente. Ahora puedes iniciar sesión con la nueva contraseña.'); window.location='IniciarSesion.aspx';",
                    true
                );
            }
            catch (MySqlException)
            {
                lblError.Text = "Ocurrió un error al actualizar la contraseña. Inténtalo nuevamente.";
            }
        }

        private void LimpiarSesionReset()
        {
            Session.Remove("PWD_Reset_Rut");
            Session.Remove("PWD_Reset_DV");
            Session.Remove("PWD_Reset_Email");
            Session.Remove("PWD_Reset_Nombre");
            Session.Remove("PWD_Reset_Code");
            Session.Remove("PWD_Reset_Expires");
            Session.Remove("PWD_Code_Verificado");
        }
    }
}
