using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using bluesky.Services;
using MySql.Data.MySqlClient;

namespace bluesky
{
    public partial class IniciarSesion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string user = (txtUser.Text ?? "").Trim();
            string pass = (txtPass.Text ?? "").Trim();

            if (string.IsNullOrEmpty(user) || string.IsNullOrEmpty(pass))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Debes ingresar usuario y contraseña.');", true);
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

            // Normaliza posible RUT: solo dígitos (sin puntos/guión)
            string rutDigits = Regex.Replace(user, @"\D", ""); // "12.345.678-9" -> "123456789"

            // Consulta: login por email exacto O por RUT normalizado
            string sql = @"
    SELECT
        persrut,
        persnombre,
        perspatern,
        persmatern,
        persemail,
        rol_id,
        usuclave
    FROM usuario
    WHERE persemail = @mail
       OR REPLACE(REPLACE(persrut, '.', ''), '-', '') = @rutDigits
    LIMIT 1;";

            try
            {
                using (var cn = new MySqlConnection(cs))
                using (var cmd = new MySqlCommand(sql, cn))
                {
                    cmd.Parameters.Add("@mail", MySqlDbType.VarChar).Value = user;
                    cmd.Parameters.Add("@rutDigits", MySqlDbType.VarChar).Value = rutDigits;

                    cn.Open();

                    using (var rd = cmd.ExecuteReader())
                    {
                        if (!rd.Read())
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Usuario no encontrado.');", true);
                            return;
                        }

                        // Datos
                        string persrut = rd["persrut"]?.ToString() ?? "";
                        string nombre = rd["persnombre"]?.ToString() ?? "";
                        string patern = rd["perspatern"]?.ToString() ?? "";
                        string matern = rd["persmatern"]?.ToString() ?? "";
                        string email = rd["persemail"]?.ToString() ?? "";
                        string hash = rd["usuclave"]?.ToString() ?? "";

                        int rol = rd["rol_id"] != DBNull.Value ? Convert.ToInt32(rd["rol_id"]) : 0;

                        // Verificación de contraseña (BCrypt)
                        bool ok = !string.IsNullOrEmpty(hash) && BCrypt.Net.BCrypt.Verify(pass, hash);
                        if (!ok)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Contraseña incorrecta.');", true);
                            return;
                        }

                        if (string.IsNullOrWhiteSpace(email))
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('El usuario no tiene correo asociado. Contacta al administrador.');", true);
                            return;
                        }

                        // ========== 2FA: generar código y guardar en sesión ==========
                        var random = new Random();
                        string code = random.Next(100000, 999999).ToString(); // 6 dígitos
                        DateTime expires = DateTime.Now.AddMinutes(5);

                        string nombreCompleto = $"{nombre} {patern}".Trim();

                        Session["2FA_Pending_Rut"] = persrut;
                        Session["2FA_Pending_Nombre"] = nombreCompleto;
                        Session["2FA_Pending_Rol"] = rol;
                        Session["2FA_Pending_Email"] = email;
                        Session["2FA_Code"] = code;
                        Session["2FA_Expires"] = expires;

                        // Enviar correo con el código
                        try
                        {
                            var emailService = new EmailService();
                            string subject = "Código de verificación - BlueSky";
                            string body = $@"
                                Hola {nombreCompleto},<br/><br/>
                                Tu código de verificación para ingresar a BlueSky es:<br/>
                                <h2>{code}</h2>
                                Este código expira en 5 minutos.<br/><br/>
                                Si no fuiste tú, ignora este mensaje.
                            ";

                            emailService.SendEmail(email, subject, body);
                        }
                        catch (Exception)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                                "alert('No se pudo enviar el correo de verificación. Inténtalo nuevamente más tarde.');", true);
                            LimpiarSesion2FA();
                            return;
                        }

                        // Redirigir a la página de verificación
                        Response.Redirect("~/VerificacionCodigo.aspx");
                    }
                }
            }
            catch (MySqlException)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Ocurrió un error al iniciar sesión. Inténtalo nuevamente.');", true);
            }
        }

        private void LimpiarSesion2FA()
        {
            Session.Remove("2FA_Pending_Rut");
            Session.Remove("2FA_Pending_Nombre");
            Session.Remove("2FA_Pending_Rol");
            Session.Remove("2FA_Pending_Email");
            Session.Remove("2FA_Code");
            Session.Remove("2FA_Expires");
        }

        protected void btnVolverInicio_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Default.aspx");
        }
    }
}
