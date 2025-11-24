using System;
using System.Configuration;
using System.Web;
using System.Web.UI;
using MySql.Data.MySqlClient;

namespace bluesky
{
    public partial class SiteMaster : MasterPage
    {
        public bool UsarMenuBasico { get; set; } = false;
        public bool OcultarMenus { get; set; } = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            // === Estado de sesión / login ===
            var username = Session["Username"] as string;
            bool logged = !string.IsNullOrEmpty(username);

            phLoggedIn.Visible = logged;
            phLoggedOut.Visible = !logged;

            // Muy importante: encodear lo que viene de sesión/BD
            litUserName.Text = logged ? (" " + HttpUtility.HtmlEncode(username)) : string.Empty;

            // === Panel de administrador: SOLO por sesión ===
            int rolValue;
            bool esAdmin = Session["Rol"] != null
                           && int.TryParse(Session["Rol"].ToString(), out rolValue)
                           && rolValue == 1;

            if (liAdminToggle != null) liAdminToggle.Visible = esAdmin;
            if (adminSidePanel != null) adminSidePanel.Visible = esAdmin;

            // === Menú principal según flags expuestos ===
            if (ulMenu != null) ulMenu.Visible = !OcultarMenus;

            if (phMenuPrincipal != null)
                phMenuPrincipal.Visible = !UsarMenuBasico && !OcultarMenus;

            if (phMenuBasico != null)
                phMenuBasico.Visible = UsarMenuBasico && !OcultarMenus;

            // === Footer: ocultar secciones específicas cuando UsarMenuBasico ===
            if (UsarMenuBasico)
            {
                if (phInfoContacto != null) phInfoContacto.Visible = false; // Información de contacto
                if (phBoletin != null) phBoletin.Visible = false;           // Suscríbete al boletín
                if (phMapa != null) phMapa.Visible = false;                 // Mapa
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Default.aspx");
        }

        protected void btnSubscribe_Click(object sender, EventArgs e)
        {
            // Limpiar por si quedó algo viejo (aunque ya no usamos labels para error)
            lblRutError.Text = string.Empty;
            lblEmailError.Text = string.Empty;

            string rut = txtNewsletterRut.Text.Trim();
            string email = txtNewsletterEmail.Text.Trim();

            // ==== VALIDACIÓN RUT VACÍO ====
            if (string.IsNullOrWhiteSpace(rut))
            {
                ScriptManager.RegisterStartupScript(
                    upNewsletter,
                    upNewsletter.GetType(),
                    "rutVacio",
                    "Swal.fire({ icon:'warning', title:'Falta tu RUT', text:'Por favor ingresa tu RUT (sin dígito verificador).' });",
                    true
                );
                return;
            }

            // ==== VALIDACIÓN RUT SOLO NÚMEROS ====
            bool rutSoloNumeros = true;
            foreach (char c in rut)
            {
                if (!char.IsDigit(c))
                {
                    rutSoloNumeros = false;
                    break;
                }
            }

            if (!rutSoloNumeros)
            {
                ScriptManager.RegisterStartupScript(
                    upNewsletter,
                    upNewsletter.GetType(),
                    "rutNoNumerico",
                    "Swal.fire({ icon:'warning', title:'RUT inválido', text:'El RUT debe contener solo números, sin dígito verificador.' });",
                    true
                );
                return;
            }

            // ==== VALIDACIÓN LARGO RUT (>5 dígitos, sin DV) ====
            if (rut.Length <= 5)
            {
                ScriptManager.RegisterStartupScript(
                    upNewsletter,
                    upNewsletter.GetType(),
                    "rutCorto",
                    "Swal.fire({ icon:'warning', title:'RUT demasiado corto', text:'El RUT debe tener más de 5 dígitos (sin dígito verificador).' });",
                    true
                );
                return;
            }

            // ==== VALIDACIÓN EMAIL VACÍO ====
            if (string.IsNullOrWhiteSpace(email))
            {
                ScriptManager.RegisterStartupScript(
                    upNewsletter,
                    upNewsletter.GetType(),
                    "emailVacio",
                    "Swal.fire({ icon:'warning', title:'Falta tu correo', text:'Por favor ingresa tu correo electrónico.' });",
                    true
                );
                return;
            }

            // ==== VALIDACIÓN FORMATO EMAIL ====
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                if (addr.Address != email)
                {
                    ScriptManager.RegisterStartupScript(
                        upNewsletter,
                        upNewsletter.GetType(),
                        "emailInvalido",
                        "Swal.fire({ icon:'warning', title:'Correo inválido', text:'El formato del correo electrónico no es válido.' });",
                        true
                    );
                    return;
                }
            }
            catch
            {
                ScriptManager.RegisterStartupScript(
                    upNewsletter,
                    upNewsletter.GetType(),
                    "emailInvalidoCatch",
                    "Swal.fire({ icon:'warning', title:'Correo inválido', text:'El formato del correo electrónico no es válido.' });",
                    true
                );
                return;
            }

            // ==== INSERTAR / ACTUALIZAR EN BD ====
            string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

            using (var conn = new MySqlConnection(cs))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = @"
            INSERT INTO boletin_suscripcion (rut, email)
            VALUES (@Rut, @Email)
            ON DUPLICATE KEY UPDATE
                email = VALUES(email),
                activo = 1,
                fecha_suscripcion = CURRENT_TIMESTAMP;
        ";

                cmd.Parameters.AddWithValue("@Rut", rut);
                cmd.Parameters.AddWithValue("@Email", email);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    // Limpiar los campos si todo salió bien
                    txtNewsletterRut.Text = string.Empty;
                    txtNewsletterEmail.Text = string.Empty;

                    // SweetAlert de éxito
                    ScriptManager.RegisterStartupScript(
                        upNewsletter,
                        upNewsletter.GetType(),
                        "BoletinOk",
                        "Swal.fire({ " +
                            "icon:'success', " +
                            "title:'¡Suscripción exitosa!', " +
                            "text:'Te has suscrito correctamente al boletín.' " +
                        "});",
                        true
                    );
                }
                catch (MySqlException)
                {
                    // SweetAlert de error
                    ScriptManager.RegisterStartupScript(
                        upNewsletter,
                        upNewsletter.GetType(),
                        "BoletinError",
                        "Swal.fire({ " +
                            "icon:'error', " +
                            "title:'Error', " +
                            "text:'Ocurrió un problema al suscribirte. Intenta nuevamente.' " +
                        "});",
                        true
                    );
                }
            }
        }

    }
}

