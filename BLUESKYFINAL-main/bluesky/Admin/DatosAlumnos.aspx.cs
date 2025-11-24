using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Text;
using static bluesky.models.DatosAlumnos;

namespace bluesky.Admin
{
    public partial class DatosAlumnos : System.Web.UI.Page
    {
        private readonly string constr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;
        public List<Datos1> consult = new List<Datos1>();

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
                // Logueado pero sin rol de admin → sacar del área /Admin
                Response.Redirect("~/Default.aspx");
                return;
            }

            Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));

            var master = this.Master as bluesky.SiteMaster;
            if (master != null)
            {
                master.UsarMenuBasico = true;
                master.OcultarMenus = true;
            }

            if (!IsPostBack)
                VerDatos(); // sin filtro al cargar
        }

        private bool VerDatos(string filtro = "")
        {
            consult = new List<Datos1>();

            string queryString = @"
        SELECT DISTINCT persrut, persnombre, perspatern, persmatern, perssexo, 
                        persemail, persdireccion, persfono, persnacimiento, estado 
        FROM usuario
        WHERE (@filtro = '' 
               OR persrut      LIKE CONCAT('%', @filtro, '%')
               OR persnombre   LIKE CONCAT('%', @filtro, '%')
               OR perspatern   LIKE CONCAT('%', @filtro, '%')
               OR persmatern   LIKE CONCAT('%', @filtro, '%')
               OR persemail    LIKE CONCAT('%', @filtro, '%')
               OR persdireccion LIKE CONCAT('%', @filtro, '%')
               OR persfono     LIKE CONCAT('%', @filtro, '%'))
        ORDER BY perspatern;";

            using (MySqlConnection connection = new MySqlConnection(constr))
            {
                MySqlCommand command = new MySqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@filtro", filtro ?? string.Empty);

                connection.Open();
                MySqlDataReader reader = command.ExecuteReader();

                while (reader.Read())
                {
                    Datos1 a = new Datos1();
                    a.persrut = reader.IsDBNull(0) ? "" : reader.GetString(0);
                    a.persnombre = reader.IsDBNull(1) ? "" : reader.GetString(1);
                    a.perspatern = reader.IsDBNull(2) ? "" : reader.GetString(2);
                    a.persmatern = reader.IsDBNull(3) ? "" : reader.GetString(3);

                    string sexoRaw = reader.IsDBNull(4) ? "" : reader.GetString(4).Trim();
                    a.perssexo = sexoRaw == "M" ? "Masculino" :
                                 sexoRaw == "F" ? "Femenino" : sexoRaw;

                    a.persemail = reader.IsDBNull(5) ? "" : reader.GetString(5);
                    a.persdireccion = reader.IsDBNull(6) ? "" : reader.GetString(6);
                    a.persfono = reader.IsDBNull(7) ? "" : reader.GetString(7);
                    a.persnacimiento = reader.IsDBNull(8) ? (DateTime?)null : reader.GetDateTime(8);
                    int estadoVal = reader.IsDBNull(9) ? 1 : reader.GetInt32(9);
                    a.estado = estadoVal == 1 ? "ACTIVO" : "INACTIVO";

                    consult.Add(a);
                }

                gvCustomers.DataSource = consult;
                gvCustomers.DataBind();

                ActualizarResumen();

                return consult.Count > 0;
            }
        }

        private void ActualizarResumen()
        {
            int total = consult.Count;
            if (total == 0)
            {
                lblResumen.Text = "No hay alumnos.";
                return;
            }

            int pageSize = gvCustomers.PageSize;
            int pageIndex = gvCustomers.PageIndex;

            int inicio = pageIndex * pageSize + 1;
            int fin = Math.Min(inicio + pageSize - 1, total);

            lblResumen.Text = $"Mostrando {inicio}-{fin} de {total} alumnos.";
        }

        protected void gvCustomers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCustomers.PageIndex = e.NewPageIndex;

            string filtro = ViewState["FiltroAlumnos"] as string ?? string.Empty;
            VerDatos(filtro);
        }

        protected void gvCustomers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Editar")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                string rut = gvCustomers.DataKeys[rowIndex].Value.ToString();

                // REDIRIGIR AL NUEVO ARCHIVO
                Response.Redirect($"EditarAlumnos.aspx?rut={rut}");
            }
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            string filtro = txtBuscar.Text.Trim();

            ViewState["FiltroAlumnos"] = filtro;
            gvCustomers.PageIndex = 0;

            VerDatos(filtro);
        }

        protected void btnMostrarTodo_Click(object sender, EventArgs e)
        {
            txtBuscar.Text = string.Empty;
            ViewState["FiltroAlumnos"] = string.Empty;
            gvCustomers.PageIndex = 0;   // Volver a la primera página
            VerDatos();                  // Sin filtro = todos los alumnos
        }

        protected void gvCustomers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // La columna ESTADO es la 9 (0-based: 0..9 datos, 10 = ACCIONES)
                string estado = e.Row.Cells[9].Text.Trim().ToUpperInvariant();

                if (estado == "INACTIVO")
                {
                    // Aplicar estilo SOLO a las columnas de datos (0 a 9)
                    for (int i = 0; i <= 9; i++)
                    {
                        e.Row.Cells[i].CssClass = (e.Row.Cells[i].CssClass + " inactivo-cell").Trim();
                    }

                    // Si quieres que el botón "Editar" se vea más de alerta también:
                    Button btnEditar = e.Row.FindControl("btnEditar") as Button;
                    if (btnEditar != null)
                    {
                        btnEditar.CssClass = "btn btn-sm btn-outline-danger";
                    }
                }
            }
        }


        protected void btnExportarExcel_Click(object sender, EventArgs e)
        {
            ExportarAlumnosACsv();
        }

        private string EscaparCsv(string valor)
        {
            if (string.IsNullOrEmpty(valor))
                return "";

            // Reemplaza comillas por comillas dobles
            valor = valor.Replace("\"", "\"\"");

            // Si contiene separador, comillas o saltos de línea, se encierra entre comillas
            if (valor.Contains(";") || valor.Contains("\"") || valor.Contains("\r") || valor.Contains("\n"))
            {
                return $"\"{valor}\"";
            }

            return valor;
        }

        private void ExportarAlumnosACsv()
        {
            // Usamos el filtro actual guardado en ViewState
            string filtro = ViewState["FiltroAlumnos"] as string ?? string.Empty;

            // Recargamos la lista completa según el filtro (toda la data, no solo la página)
            VerDatos(filtro);

            // Construimos el CSV en memoria
            StringBuilder sb = new StringBuilder();

            // Encabezados de columnas (mismos que el GridView)
            sb.AppendLine(string.Join(";", new string[]
            {
        "RUT",
        "NOMBRES",
        "APELLIDO PATERNO",
        "APELLIDO MATERNO",
        "SEXO",
        "CORREO ELECTRONICO",
        "DIRECCION",
        "CELULAR",
        "FECHA DE NACIMIENTO",
        "ESTADO"
            }));

            // Filas de datos
            foreach (var a in consult)
            {
                string fechaNac = a.persnacimiento.HasValue
                    ? a.persnacimiento.Value.ToString("dd-MM-yyyy")
                    : "";

                string[] campos = new string[]
                {
            EscaparCsv(a.persrut),
            EscaparCsv(a.persnombre),
            EscaparCsv(a.perspatern),
            EscaparCsv(a.persmatern),
            EscaparCsv(a.perssexo),
            EscaparCsv(a.persemail),
            EscaparCsv(a.persdireccion),
            EscaparCsv(a.persfono),
            EscaparCsv(fechaNac),
            EscaparCsv(a.estado)
                };

                sb.AppendLine(string.Join(";", campos));
            }

            // Enviar al navegador
            Response.Clear();
            Response.Buffer = true;

            // Para que Excel reconozca bien acentos/ñ
            Response.ContentEncoding = Encoding.UTF8;
            Response.Charset = "utf-8";

            // Nombre del archivo
            string fileName = "DatosAlumnos_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".csv";

            Response.AddHeader("content-disposition", "attachment;filename=" + fileName);
            Response.ContentType = "text/csv";

            // BOM para UTF-8 (Excel)
            Response.Write('\uFEFF');

            Response.Write(sb.ToString());
            Response.Flush();

            // Terminar la respuesta
            Response.End();
        }

    }
}
