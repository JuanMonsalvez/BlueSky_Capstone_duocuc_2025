using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using bluesky.models; // <-- para usar SoporteItem
using System.Text;

namespace bluesky.Admin
{
    public partial class Soporte : System.Web.UI.Page
    {
        private readonly string constr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        // Lista en memoria para el resumen y exportación
        private List<SoporteItem> listaSoporte = new List<SoporteItem>();

        protected void Page_Load(object sender, EventArgs e)
        {
            // 🔐 1) Verificar que el usuario esté logueado
            var username = Session["Username"] as string;
            if (string.IsNullOrEmpty(username))
            {
                // No autenticado → ir a iniciar sesión
                Response.Redirect("~/IniciarSesion.aspx");
                return;
            }

            // 🔐 2) Verificar que tenga rol ADMIN (rol_id = 1)
            int rol;
            bool esAdmin = Session["Rol"] != null
                           && int.TryParse(Session["Rol"].ToString(), out rol)
                           && rol == 1;

            if (!esAdmin)
            {
                // Logueado pero sin permisos de admin → expulsar del área /Admin
                Response.Redirect("~/Default.aspx");
                return;
            }

            // 🎨 3) Configurar comportamiento visual de la MasterPage
            var master = this.Master as bluesky.SiteMaster;
            if (master != null)
            {
                master.UsarMenuBasico = true;
                master.OcultarMenus = true;
            }

            // 📌 4) Cargar datos al iniciar
            if (!IsPostBack)
            {
                CargarSoporte(); // sin filtro
            }
        }

        private bool CargarSoporte(string filtro = "")
        {
            listaSoporte = new List<SoporteItem>();

            string query = @"
SELECT 
    cs.contacto_id,
    cs.rut,
    u.persnombre AS nombre,
    u.perspatern AS apellido_paterno,
    u.persmatern AS apellido_materno,
    u.persemail  AS email,
    u.persfono   AS persfono,
    cs.problema,
    cs.fecha,
    cs.estado
FROM contacto_soporte cs
LEFT JOIN usuario u ON cs.rut = u.persrut
WHERE (
        @filtro = '' 
        OR cs.rut LIKE CONCAT('%', @filtro, '%')
        OR u.persnombre LIKE CONCAT('%', @filtro, '%')
        OR u.perspatern LIKE CONCAT('%', @filtro, '%')
        OR u.persmatern LIKE CONCAT('%', @filtro, '%')
        OR u.persemail LIKE CONCAT('%', @filtro, '%')
        OR u.persfono LIKE CONCAT('%', @filtro, '%')
        OR cs.problema LIKE CONCAT('%', @filtro, '%')
)
ORDER BY cs.contacto_id DESC;";

            using (MySqlConnection cn = new MySqlConnection(constr))
            using (MySqlCommand cmd = new MySqlCommand(query, cn))
            {
                cmd.Parameters.AddWithValue("@filtro", filtro ?? string.Empty);

                cn.Open();
                using (MySqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var item = new SoporteItem
                        {
                            contacto_id = reader.IsDBNull(0) ? 0 : reader.GetInt32(0),
                            rut = reader.IsDBNull(1) ? "" : reader.GetString(1),
                            nombre = reader.IsDBNull(2) ? "" : reader.GetString(2),
                            apellido_paterno = reader.IsDBNull(3) ? "" : reader.GetString(3),
                            apellido_materno = reader.IsDBNull(4) ? "" : reader.GetString(4),
                            email = reader.IsDBNull(5) ? "" : reader.GetString(5),
                            persfono = reader.IsDBNull(6) ? "" : reader.GetString(6),
                            problema = reader.IsDBNull(7) ? "" : reader.GetString(7),
                            fecha = reader.IsDBNull(8) ? DateTime.MinValue : reader.GetDateTime(8),
                            estado = reader.IsDBNull(9) ? 0 : reader.GetInt32(9)
                        };

                        listaSoporte.Add(item);
                    }
                }
            }

            gvCustomers.DataSource = listaSoporte;
            gvCustomers.DataBind();

            ActualizarResumen();

            return listaSoporte.Count > 0;
        }


        private void ActualizarResumen()
        {
            int total = listaSoporte.Count;
            if (total == 0)
            {
                lblResumen.Text = "No hay solicitudes de soporte.";
                return;
            }

            int pageSize = gvCustomers.PageSize;
            int pageIndex = gvCustomers.PageIndex;

            int inicio = pageIndex * pageSize + 1;
            int fin = Math.Min(inicio + pageSize - 1, total);

            lblResumen.Text = $"Mostrando {inicio}-{fin} de {total} solicitudes.";
        }

        protected void gvCustomers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCustomers.PageIndex = e.NewPageIndex;

            string filtro = ViewState["FiltroSoporte"] as string ?? string.Empty;
            CargarSoporte(filtro);
        }

        protected void gvCustomers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.TableSection = TableRowSection.TableHeader;
            }
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            string filtro = txtBuscar.Text.Trim();
            ViewState["FiltroSoporte"] = filtro;

            gvCustomers.PageIndex = 0;
            CargarSoporte(filtro);
        }

        protected void btnMostrarTodo_Click(object sender, EventArgs e)
        {
            txtBuscar.Text = string.Empty;
            ViewState["FiltroSoporte"] = string.Empty;

            gvCustomers.PageIndex = 0;
            CargarSoporte();
        }

        private void CambiarEstado(int contactoId, int nuevoEstado)
        {
            string sql = @"UPDATE contacto_soporte
                   SET estado = @estado
                   WHERE contacto_id = @id";

            using (var cn = new MySqlConnection(constr))
            using (var cmd = new MySqlCommand(sql, cn))
            {
                cmd.Parameters.AddWithValue("@estado", nuevoEstado);
                cmd.Parameters.AddWithValue("@id", contactoId);

                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void gvCustomers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "CambiarEstado")
            {
                // CommandArgument = "contactoId|nuevoEstado"
                string[] partes = e.CommandArgument.ToString().Split('|');
                if (partes.Length != 2)
                    return;

                int contactoId;
                int nuevoEstado;

                if (!int.TryParse(partes[0], out contactoId) ||
                    !int.TryParse(partes[1], out nuevoEstado))
                {
                    return;
                }

                // 1️⃣ Traer estado actual desde la BD
                int estadoActual = ObtenerEstadoActual(contactoId);

                if (estadoActual == -1)
                {
                    // No se encontró el registro
                    ScriptManager.RegisterStartupScript(
                        this, GetType(), "noExiste",
                        "Swal.fire({ icon:'error', title:'Error', text:'La solicitud ya no existe en el sistema.' });",
                        true
                    );
                    return;
                }

                // 2️⃣ Si el estado es el mismo → NO actualizar
                if (estadoActual == nuevoEstado)
                {
                    string msg = (nuevoEstado == 0)
                        ? "La solicitud ya se encuentra en estado PENDIENTE."
                        : "La solicitud ya se encuentra en estado ATENDIDA.";

                    ScriptManager.RegisterStartupScript(
                        this, GetType(), "estadoIgual",
                        $"Swal.fire({{ icon:'info', title:'Sin cambios', text:'{msg}' }});",
                        true
                    );

                    return;
                }

                // 3️⃣ Estado distinto → actualizar en BD
                CambiarEstado(contactoId, nuevoEstado);

                // Recargar la grilla con el filtro actual
                string filtro = ViewState["FiltroSoporte"] as string ?? string.Empty;
                CargarSoporte(filtro);

                // 4️⃣ Mensaje de éxito
                string mensajeOk = (nuevoEstado == 0)
                    ? "La solicitud fue marcada como Pendiente."
                    : "La solicitud fue marcada como Atendida.";

                ScriptManager.RegisterStartupScript(
                    this, GetType(), "estadoOk",
                    $"Swal.fire({{ icon:'success', title:'Estado actualizado', text:'{mensajeOk}' }});",
                    true
                );
            }
        }

        private int ObtenerEstadoActual(int contactoId)
        {
            string sql = "SELECT estado FROM contacto_soporte WHERE contacto_id = @id";

            using (var cn = new MySqlConnection(constr))
            using (var cmd = new MySqlCommand(sql, cn))
            {
                cmd.Parameters.AddWithValue("@id", contactoId);

                cn.Open();
                object result = cmd.ExecuteScalar();

                if (result == null || result == DBNull.Value)
                    return -1;

                return Convert.ToInt32(result);
            }
        }

        /* ==============================
           EXPORTAR A EXCEL (CSV)
           ============================== */

        protected void btnExportarExcel_Click(object sender, EventArgs e)
        {
            ExportarSoporteACsv();
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

        private void ExportarSoporteACsv()
        {
            // Usamos el filtro actual
            string filtro = ViewState["FiltroSoporte"] as string ?? string.Empty;

            // Recargamos toda la data segun el filtro
            CargarSoporte(filtro);

            StringBuilder sb = new StringBuilder();

            // Encabezados
            sb.AppendLine(string.Join(";", new string[]
            {
    "ID",
    "RUT",
    "NOMBRE",
    "AP. PATERNO",
    "AP. MATERNO",
    "EMAIL",
    "TELÉFONO",
    "PROBLEMA",
    "FECHA",
    "ESTADO"
            }));

            // Filas
            foreach (var item in listaSoporte)
            {
                string fechaStr = item.fecha == DateTime.MinValue
                    ? ""
                    : item.fecha.ToString("dd-MM-yyyy HH:mm");

                string estadoStr = item.estado == 0 ? "Pendiente" : "Atendida";

                string[] campos = new string[]
                {
    EscaparCsv(item.contacto_id.ToString()),
    EscaparCsv(item.rut),
    EscaparCsv(item.nombre),
    EscaparCsv(item.apellido_paterno),
    EscaparCsv(item.apellido_materno),
    EscaparCsv(item.email),
    EscaparCsv(item.persfono),
    EscaparCsv(item.problema),
    EscaparCsv(fechaStr),
    EscaparCsv(estadoStr)
                };

                sb.AppendLine(string.Join(";", campos));
            }

            // Enviar al navegador
            Response.Clear();
            Response.Buffer = true;

            Response.ContentEncoding = Encoding.UTF8;
            Response.Charset = "utf-8";

            string fileName = "SoporteSolicitudes_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".csv";
            Response.AddHeader("content-disposition", "attachment;filename=" + fileName);
            Response.ContentType = "text/csv";

            // BOM UTF-8 para que Excel respete acentos
            Response.Write('\uFEFF');

            Response.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }
    }
}
