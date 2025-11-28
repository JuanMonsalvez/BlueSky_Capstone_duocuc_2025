using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web.UI;

namespace bluesky
{
    public partial class MisDatos : Page
    {
        private readonly string constr =
            ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            var username = Session["Username"] as string;
            if (string.IsNullOrEmpty(username))
            {
                // No autenticado → ir a iniciar sesión
                Response.Redirect("~/IniciarSesion.aspx");
                return;
            }

            // Ajuste de layout (opcional)
            var master = this.Master as bluesky.SiteMaster;
            if (master != null)
            {
                master.UsarMenuBasico = true;
                master.OcultarMenus = false; // se ve el menú para todos los logueados
            }

            if (!IsPostBack)
            {
                CargarMisDatos();
            }
        }

        private void CargarMisDatos()
        {
            // Intentamos obtener el RUT de sesión
            string rut = Session["PersRut"] as string;
            if (string.IsNullOrEmpty(rut))
                rut = Session["USUARIO_ID"] as string;

            if (string.IsNullOrEmpty(rut))
            {
                lblSinDatos.Text = "No se encontró información del usuario.";
                gvMisDatos.DataSource = null;
                gvMisDatos.DataBind();
                lblResumen.Text = "";
                return;
            }

            var lista = new List<dynamic>();

            string query = @"
                SELECT persrut, persdv, persnombre, perspatern, persmatern,
                       perssexo, persemail, persdireccion, persfono, persnacimiento
                FROM usuario
                WHERE persrut = @rut
                LIMIT 1;
            ";

            using (var cn = new MySqlConnection(constr))
            using (var cmd = new MySqlCommand(query, cn))
            {
                cmd.Parameters.AddWithValue("@rut", rut);
                cn.Open();

                using (var rd = cmd.ExecuteReader())
                {
                    if (rd.Read())
                    {
                        string persrut = rd["persrut"] as string ?? "";
                        string persdv = rd["persdv"] as string ?? "";
                        string sexoRaw = (rd["perssexo"] as string ?? "").Trim().ToUpperInvariant();

                        string sexoDescripcion =
                            sexoRaw == "M" ? "Masculino" :
                            sexoRaw == "F" ? "Femenino" :
                            sexoRaw;

                        DateTime? fechaNac = null;
                        if (!(rd["persnacimiento"] is DBNull))
                            fechaNac = Convert.ToDateTime(rd["persnacimiento"]);

                        lista.Add(new
                        {
                            RUTCompleto = $"{persrut}-{persdv}",
                            persnombre = rd["persnombre"] as string ?? "",
                            perspatern = rd["perspatern"] as string ?? "",
                            persmatern = rd["persmatern"] as string ?? "",
                            perssexo = sexoDescripcion,
                            persemail = rd["persemail"] as string ?? "",
                            persdireccion = rd["persdireccion"] as string ?? "",
                            persfono = rd["persfono"] as string ?? "",
                            persnacimiento = fechaNac
                        });
                    }
                }
            }

            gvMisDatos.DataSource = lista;
            gvMisDatos.DataBind();

            if (lista.Count == 0)
            {
                lblSinDatos.Text = "No se encontró información del usuario.";
                lblResumen.Text = "";
            }
            else
            {
                lblSinDatos.Text = "";
                lblResumen.Text = "Mostrando 1 registro.";
            }
        }
    }
}
