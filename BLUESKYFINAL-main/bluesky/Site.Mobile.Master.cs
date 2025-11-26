using System;
using System.Configuration;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace bluesky
{
    public partial class Site_Mobile : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Si más adelante quieres copiar la lógica de login/admin del SiteMaster,
            // la podemos agregar acá. Por ahora no es obligatorio para que compile.
        }

        // ========== LOGOUT (ya lo estabas usando en el markup) ==========
        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Default.aspx");
        }

        // ========== HELPER PARA BUSCAR CONTROLES PROFUNDOS ==========
        private Control FindControlRecursive(Control root, string id)
        {
            if (root == null) return null;
            if (root.ID == id) return root;

            foreach (Control child in root.Controls)
            {
                var found = FindControlRecursive(child, id);
                if (found != null)
                    return found;
            }

            return null;
        }

        // ========== SUSCRIPCIÓN NEWSLETTER (btnSubscribe_Click) ==========
        protected void btnSubscribe_Click(object sender, EventArgs e)
        {
            // Buscamos los controles por ID dentro del árbol de la master
            var txtRutCtrl = FindControlRecursive(this, "txtNewsletterRut") as TextBox;
            var txtEmailCtrl = FindControlRecursive(this, "txtNewsletterEmail") as TextBox;

            string rut = txtRutCtrl != null ? txtRutCtrl.Text.Trim() : string.Empty;
            string email = txtEmailCtrl != null ? txtEmailCtrl.Text.Trim() : string.Empty;

            // ==== VALIDACIÓN RUT VACÍO ====
            if (string.IsNullOrWhiteSpace(rut))
            {
                ScriptManager.RegisterStartupScript(
                    this,
                    this.GetType(),
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
                    this,
                    this.GetType(),
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
                    this,
                    this.GetType(),
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
                    this,
                    this.GetType(),
                    "emailVacio",
                    "Swal.fire({ icon:'warning', title:'Falta tu correo', text:'Por favor ingresa tu correo electrónico.' });",
                    true
                );
                return;
            }

            // ==== VALIDACIÓN FORMATO EMAIL ====
            try
            {
                var addr = new MailAddress(email);
                if (addr.Address != email)
                {
                    ScriptManager.RegisterStartupScript(
                        this,
                        this.GetType(),
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
                    this,
                    this.GetType(),
                    "emailInvalidoCatch",
                    "Swal.fire({ icon:'warning', title:'Correo inválido', text:'El formato del correo electrónico no es válido.' });",
                    true
                );
                return;
            }

            // ==== INSERTAR / ACTUALIZAR EN BD (MISMA QUERY QUE EN SiteMaster) ====
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
                    if (txtRutCtrl != null) txtRutCtrl.Text = string.Empty;
                    if (txtEmailCtrl != null) txtEmailCtrl.Text = string.Empty;

                    // SweetAlert de éxito
                    ScriptManager.RegisterStartupScript(
                        this,
                        this.GetType(),
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
                        this,
                        this.GetType(),
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
