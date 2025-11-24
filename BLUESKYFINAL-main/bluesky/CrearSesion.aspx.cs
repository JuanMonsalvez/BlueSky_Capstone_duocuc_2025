using System;
using System.Configuration;
using System.Web.UI;
using MySql.Data.MySqlClient;
using BCrypt.Net;

namespace bluesky
{
    public partial class CrearSesion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // =======================
            // VALIDACIONES BÁSICAS
            // =======================

            if (string.IsNullOrWhiteSpace(txtRut.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "rutReq",
                    "swal('Advertencia','Favor completar campo RUT.','warning');", true);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtDv.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "dvReq",
                    "swal('Advertencia','Favor completar dígito verificador.','warning');", true);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtUsuario.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "nombresReq",
                    "swal('Advertencia','Favor completar campo Nombres.','warning');", true);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtApellidoPaterno.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "apPatReq",
                    "swal('Advertencia','Favor completar campo Apellido Paterno.','warning');", true);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtApellidoMaterno.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "apPatReq",
                    "swal('Advertencia','Favor completar campo Apellido Paterno.','warning');", true);
                return;
            }

            if (ltSexo.SelectedValue == "#" || string.IsNullOrEmpty(ltSexo.SelectedValue))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "sexoReq",
                    "swal('Advertencia','Favor seleccionar el campo Sexo.','warning');", true);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "mailReq",
                    "swal('Advertencia','Favor completar campo Email.','warning');", true);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtDireccion.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "dirReq",
                    "swal('Advertencia','Favor completar campo Dirección.','warning');", true);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtCelular.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "fonoReq",
                    "swal('Advertencia','Favor completar campo Celular.','warning');", true);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtFechaNaci.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "nacReq",
                    "swal('Advertencia','Favor completar campo Fecha de Nacimiento.','warning');", true);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtUsuclave.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "passReq",
                    "swal('Advertencia','Favor ingresar una contraseña.','warning');", true);
                return;
            }

            if (!chkTerms.Checked)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "termsReq",
                    "swal('Advertencia','Debes aceptar los términos y condiciones.','warning');", true);
                return;
            }


            if (!int.TryParse(txtRut.Text.Trim(), out int rut))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "rutNum",
                    "swal('Advertencia','El RUT debe contener solo números (sin puntos).','warning');", true);
                return;
            }

            // Validar mínimo 5 dígitos
            if (txtRut.Text.Trim().Length < 5)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "rutMin",
                    "swal('Advertencia','El RUT debe tener al menos 5 dígitos.','warning');", true);
                return;
            }

            if (!DateTime.TryParse(txtFechaNaci.Text, out DateTime nac))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "nacFormato",
                    "swal('Advertencia','Ingresa una fecha de nacimiento válida.','warning');", true);
                return;
            }

            // =======================
            // PREPARAR DATOS
            // =======================

            string dv = txtDv.Text.Trim().ToUpper();
            string nombres = txtUsuario.Text.Trim().ToUpper();
            string apPat = txtApellidoPaterno.Text.Trim().ToUpper();
            string apMat = string.IsNullOrWhiteSpace(txtApellidoMaterno.Text)
                ? null
                : txtApellidoMaterno.Text.Trim().ToUpper();
            string sexo = ltSexo.SelectedValue;
            string mail = txtEmail.Text.Trim().ToUpper();
            string dir = txtDireccion.Text.Trim().ToUpper(); // ahora requerido
            string fono = txtCelular.Text.Trim();
            string hash = BCrypt.Net.BCrypt.HashPassword(txtUsuclave.Text.Trim(), workFactor: 12);

            string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

            string sql = @"
INSERT INTO usuario
  (persrut, persdv, persnombre, perspatern, persmatern,
   perssexo, persemail, persdireccion, persfono, persnacimiento,
   usuclave, rol_id)
VALUES
  (@rut, @dv, @nombres, @apPat, @apMat,
   @sexo, @mail, @dir, @fono, @nac,
   @hash, 2);";

            try
            {
                using (var cn = new MySqlConnection(cs))
                using (var cmd = new MySqlCommand(sql, cn))
                {
                    cn.Open();
                    cmd.Parameters.AddWithValue("@rut", rut);
                    cmd.Parameters.AddWithValue("@dv", dv);
                    cmd.Parameters.AddWithValue("@nombres", nombres);
                    cmd.Parameters.AddWithValue("@apPat", apPat);
                    cmd.Parameters.AddWithValue("@apMat", (object)apMat ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@sexo", sexo);
                    cmd.Parameters.AddWithValue("@mail", mail);
                    cmd.Parameters.AddWithValue("@dir", dir);
                    cmd.Parameters.AddWithValue("@fono", fono);
                    cmd.Parameters.AddWithValue("@nac", nac);
                    cmd.Parameters.AddWithValue("@hash", hash);

                    cmd.ExecuteNonQuery();

                    Session["Username"] = nombres;
                    Session["USUARIO_ID"] = rut.ToString();
                    Session["PersRut"] = rut.ToString();
                    Session["Rol"] = 2;

                    string safeName = System.Web.HttpUtility.JavaScriptStringEncode(nombres);

                    string script =
                        $"swal('Cuenta creada','¡Bienvenido/a, {safeName}!','success')" +
                        ".then(function(){ window.location='Default.aspx'; });";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "signupOk", script, true);
                }
            }
            catch (MySqlException ex)
            {
                string msg = System.Web.HttpUtility.JavaScriptStringEncode(ex.Message);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "sqlError",
                    $"swal('Error','Error al registrar: {msg}','error');", true);
            }
            catch (Exception ex)
            {
                string msg = System.Web.HttpUtility.JavaScriptStringEncode(ex.Message);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "genError",
                    $"swal('Error','Error general: {msg}','error');", true);
            }
        }

        protected void btnVolverInicio_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Default.aspx");
        }
    }
}
