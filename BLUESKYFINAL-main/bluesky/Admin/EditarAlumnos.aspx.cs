using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Web.UI;

namespace bluesky.Admin
{
    public partial class EditarAlumnos : System.Web.UI.Page
    {
        private readonly string constr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            var username = Session["Username"] as string;
            if (string.IsNullOrEmpty(username))
            {
                // No autenticado → ir a iniciar sesión
                Response.Redirect("~/IniciarSesion.aspx");
                return;
            }

            int rol;
            bool esAdmin = Session["Rol"] != null
                           && int.TryParse(Session["Rol"].ToString(), out rol)
                           && rol == 1;

            if (!esAdmin)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            var master = this.Master as bluesky.SiteMaster;
            if (master != null)
            {
                master.UsarMenuBasico = true;
                master.OcultarMenus = true;
            }

            if (!IsPostBack)
            {
                CargarAlumno();
            }
        }

        private void CargarAlumno()
        {
            string rut = Request.QueryString["rut"];
            if (string.IsNullOrEmpty(rut))
                return;

            string query = @"
                SELECT persrut, persnombre, perspatern, persmatern, perssexo,
                       persemail, persdireccion, persfono, persnacimiento,
                       estado
                FROM usuario
                WHERE persrut = @rut;";

            using (MySqlConnection con = new MySqlConnection(constr))
            using (MySqlCommand cmd = new MySqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@rut", rut);
                con.Open();
                MySqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    txtRut.Text = dr["persrut"].ToString();
                    txtNombre.Text = dr["persnombre"].ToString();
                    txtPaterno.Text = dr["perspatern"].ToString();
                    txtMaterno.Text = dr["persmatern"].ToString();
                    ddlSexo.SelectedValue = dr["perssexo"].ToString();
                    txtEmail.Text = dr["persemail"].ToString();
                    txtDireccion.Text = dr["persdireccion"].ToString();
                    txtFono.Text = dr["persfono"].ToString();

                    if (!dr.IsDBNull(dr.GetOrdinal("persnacimiento")))
                        txtFechaNac.Text = Convert.ToDateTime(dr["persnacimiento"]).ToString("yyyy-MM-dd");

                    // ESTADO
                    int estado = dr.IsDBNull(dr.GetOrdinal("estado"))
                        ? 1
                        : Convert.ToInt32(dr["estado"]);

                    ddlEstado.SelectedValue = estado.ToString();
                }
            }

            // NUEVO: cargar si está suscrito al boletín
            chkBoletin.Checked = EstaSuscritoABoletin(txtRut.Text.Trim());
        }

        // NUEVO: consulta si el alumno está suscrito al boletín (activo = 1)
        private bool EstaSuscritoABoletin(string rut)
        {
            if (string.IsNullOrEmpty(rut))
                return false;

            const string sql = @"
                SELECT activo
                FROM boletin_suscripcion
                WHERE rut = @Rut
                LIMIT 1;";

            using (var con = new MySqlConnection(constr))
            using (var cmd = new MySqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@Rut", rut);
                con.Open();

                object result = cmd.ExecuteScalar();
                if (result == null || result == DBNull.Value)
                    return false;

                int activo = Convert.ToInt32(result);
                return activo == 1;
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // ============================
            // VALIDACIONES BACKEND
            // ============================

            // Nombre
            if (string.IsNullOrWhiteSpace(txtNombre.Text))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errNombre",
                    "Swal.fire('Error', 'El nombre es obligatorio.', 'error');",
                    true
                );
                return;
            }

            // Apellido paterno
            if (string.IsNullOrWhiteSpace(txtPaterno.Text))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errPaterno",
                    "Swal.fire('Error', 'El apellido paterno es obligatorio.', 'error');",
                    true
                );
                return;
            }

            // Apellido materno
            if (string.IsNullOrWhiteSpace(txtMaterno.Text))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errMaterno",
                    "Swal.fire('Error', 'El apellido materno es obligatorio.', 'error');",
                    true
                );
                return;
            }

            // Sexo
            if (string.IsNullOrEmpty(ddlSexo.SelectedValue))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errSexo",
                    "Swal.fire('Error', 'Debe seleccionar un sexo.', 'error');",
                    true
                );
                return;
            }

            // Correo
            try
            {
                var mail = new MailAddress(txtEmail.Text);
            }
            catch
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errEmail",
                    "Swal.fire('Error', 'Debe ingresar un correo electrónico válido.', 'error');",
                    true
                );
                return;
            }

            // Dirección
            if (string.IsNullOrWhiteSpace(txtDireccion.Text))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errDireccion",
                    "Swal.fire('Error', 'La dirección es obligatoria.', 'error');",
                    true
                );
                return;
            }

            // Celular: exactamente 9 dígitos
            if (txtFono.Text.Length != 9 || !txtFono.Text.All(char.IsDigit))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errFono",
                    "Swal.fire('Error', 'El número de celular debe tener exactamente 9 dígitos.', 'error');",
                    true
                );
                return;
            }

            // Fecha nacimiento: al menos 5 años antes de hoy
            DateTime hoy = DateTime.Today;
            DateTime limite = hoy.AddYears(-5);

            if (!DateTime.TryParse(txtFechaNac.Text, out DateTime fechaNac))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errFecha",
                    "Swal.fire('Error', 'Debe ingresar una fecha de nacimiento válida.', 'error');",
                    true
                );
                return;
            }

            if (fechaNac > limite)
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errFechaRange",
                    "Swal.fire('Error', 'La fecha de nacimiento debe ser de al menos 5 años atrás.', 'error');",
                    true
                );
                return;
            }

            // ============================
            // SI TODO OK → ACTUALIZAR BD
            // ============================
            string rut = txtRut.Text.Trim();
            string nombre = txtNombre.Text.Trim();
            string paterno = txtPaterno.Text.Trim();
            string materno = txtMaterno.Text.Trim();
            string sexo = ddlSexo.SelectedValue;
            string email = txtEmail.Text.Trim();
            string direccion = txtDireccion.Text.Trim();
            string fono = txtFono.Text.Trim();
            int estado = Convert.ToInt32(ddlEstado.SelectedValue);

            string update = @"
                UPDATE usuario SET
                    persnombre     = @Nombre,
                    perspatern     = @Paterno,
                    persmatern     = @Materno,
                    perssexo       = @Sexo,
                    persemail      = @Email,
                    persdireccion  = @Direccion,
                    persfono       = @Fono,
                    persnacimiento = @Nacimiento,
                    estado         = @Estado
                WHERE persrut    = @Rut;
            ";

            using (MySqlConnection con = new MySqlConnection(constr))
            using (MySqlCommand cmd = new MySqlCommand(update, con))
            {
                cmd.Parameters.AddWithValue("@Nombre", nombre);
                cmd.Parameters.AddWithValue("@Paterno", paterno);
                cmd.Parameters.AddWithValue("@Materno", materno);
                cmd.Parameters.AddWithValue("@Sexo", sexo);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Direccion", direccion);
                cmd.Parameters.AddWithValue("@Fono", fono);
                cmd.Parameters.AddWithValue("@Nacimiento", fechaNac);
                cmd.Parameters.AddWithValue("@Estado", estado);
                cmd.Parameters.AddWithValue("@Rut", rut);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            // NUEVO: actualizar suscripción al boletín según el checkbox
            ActualizarBoletin(rut, email, chkBoletin.Checked);

            // ============================
            // ALERTA DE ÉXITO
            // ============================
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "alertaOk",
                "Swal.fire({title: 'Actualizado', text: 'Datos actualizados correctamente.', icon: 'success', confirmButtonText: 'OK'}).then(function(){ window.location='DatosAlumnos.aspx'; });",
                true
            );
        }

        // NUEVO: inserta/actualiza o desactiva la suscripción en boletin_suscripcion
        private void ActualizarBoletin(string rut, string email, bool suscrito)
        {
            using (var con = new MySqlConnection(constr))
            using (var cmd = con.CreateCommand())
            {
                if (suscrito)
                {
                    cmd.CommandText = @"
                        INSERT INTO boletin_suscripcion (rut, email, activo, fecha_suscripcion)
                        VALUES (@Rut, @Email, 1, CURRENT_TIMESTAMP)
                        ON DUPLICATE KEY UPDATE
                            email = VALUES(email),
                            activo = 1,
                            fecha_suscripcion = CURRENT_TIMESTAMP;
                    ";
                }
                else
                {
                    cmd.CommandText = @"
                        UPDATE boletin_suscripcion
                        SET activo = 0
                        WHERE rut = @Rut;
                    ";
                }

                cmd.Parameters.AddWithValue("@Rut", rut);
                cmd.Parameters.AddWithValue("@Email", email);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}
