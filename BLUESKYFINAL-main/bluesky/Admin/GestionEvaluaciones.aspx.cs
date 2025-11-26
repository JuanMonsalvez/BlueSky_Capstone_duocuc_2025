using System;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace bluesky.Admin
{
    public partial class GestionEvaluaciones : Page
    {
        private readonly string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!VerificarAdmin())
                return;

            if (!IsPostBack)
            {
                CargarCursosFiltro();
                CargarPreguntas();
            }
        }

        /// <summary>
        /// Verifica que el usuario esté logueado y sea admin.
        /// </summary>
        private bool VerificarAdmin()
        {
            string rut = Convert.ToString(Session["USUARIO_ID"]);

            if (string.IsNullOrEmpty(rut))
            {
                string urlSolicitada = Request.RawUrl;
                string returnUrl = Server.UrlEncode(urlSolicitada);
                Response.Redirect("~/IniciarSesion.aspx?returnUrl=" + returnUrl);
                return false;
            }

            int rolId = 0;
            using (var cn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand(
                @"SELECT rol_id 
                  FROM usuario 
                  WHERE persrut = @rut;", cn))
            {
                cmd.Parameters.AddWithValue("@rut", rut);
                cn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    rolId = Convert.ToInt32(result);
                }
            }

            if (rolId != 1)
            {
                Response.Redirect("~/Default.aspx");
                return false;
            }

            return true;
        }

        private void CargarCursosFiltro()
        {
            ddlCursoFiltro.Items.Clear();
            ddlCursoFiltro.Items.Add(new ListItem("Todos los cursos", ""));

            using (var cn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand(
                @"SELECT curso_id, nombre
                  FROM curso
                  ORDER BY nombre ASC;", cn))
            {
                cn.Open();
                using (var dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        ddlCursoFiltro.Items.Add(
                            new ListItem(
                                Convert.ToString(dr["nombre"]),
                                Convert.ToString(dr["curso_id"])
                            ));
                    }
                }
            }
        }

        private void CargarPreguntas()
        {
            DataTable dt = new DataTable();

            StringBuilder sql = new StringBuilder();
            sql.Append(@"
                SELECT p.pregunta_id,
                       p.texto,
                       c.nombre AS nombre_curso,
                       COUNT(a.alternativa_id) AS cantidad_alternativas
                FROM pregunta p
                INNER JOIN curso c     ON c.curso_id = p.curso_id
                LEFT JOIN alternativa a ON a.pregunta_id = p.pregunta_id
                WHERE 1=1 ");

            using (var cn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand())
            {
                cmd.Connection = cn;

                if (!string.IsNullOrEmpty(ddlCursoFiltro.SelectedValue))
                {
                    sql.Append(" AND p.curso_id = @cursoId ");
                    cmd.Parameters.AddWithValue("@cursoId", ddlCursoFiltro.SelectedValue);
                }

                if (!string.IsNullOrWhiteSpace(txtBuscarTexto.Text))
                {
                    sql.Append(" AND p.texto LIKE @texto ");
                    cmd.Parameters.AddWithValue("@texto", "%" + txtBuscarTexto.Text.Trim() + "%");
                }

                sql.Append(" GROUP BY p.pregunta_id, p.texto, c.nombre ");
                sql.Append(" ORDER BY c.nombre, p.pregunta_id; ");

                cmd.CommandText = sql.ToString();

                using (var da = new MySqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }

            // Agregar columna texto_corto para no mostrar preguntas gigantes
            if (!dt.Columns.Contains("texto_corto"))
            {
                dt.Columns.Add("texto_corto", typeof(string));
            }

            foreach (DataRow row in dt.Rows)
            {
                string texto = Convert.ToString(row["texto"]);
                if (texto.Length > 120)
                    row["texto_corto"] = texto.Substring(0, 117) + "...";
                else
                    row["texto_corto"] = texto;
            }

            rptPreguntas.DataSource = dt;
            rptPreguntas.DataBind();

            pnlSinResultados.Visible = dt.Rows.Count == 0;
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarPreguntas();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            ddlCursoFiltro.SelectedIndex = 0;
            txtBuscarTexto.Text = string.Empty;
            CargarPreguntas();
        }

        protected void btnNuevaPregunta_Click(object sender, EventArgs e)
        {
            string cursoId = ddlCursoFiltro.SelectedValue;
            if (!string.IsNullOrEmpty(cursoId))
            {
                Response.Redirect("~/Admin/GestionEvaluacionEditar.aspx?modo=nuevo&cursoId=" + cursoId);
            }
            else
            {
                Response.Redirect("~/Admin/GestionEvaluacionEditar.aspx?modo=nuevo");
            }
        }

        protected void rptPreguntas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            string preguntaId = Convert.ToString(DataBinder.Eval(e.Item.DataItem, "pregunta_id"));

            if (e.CommandName == "Editar")
            {
                Response.Redirect("~/Admin/GestionEvaluacionEditar.aspx?preguntaId=" + e.CommandArgument);
            }
            else if (e.CommandName == "Eliminar")
            {
                int id;
                if (int.TryParse(Convert.ToString(e.CommandArgument), out id))
                {
                    EliminarPregunta(id);
                    CargarPreguntas();
                    ltlMensaje.Text =
                        "<div class='alert alert-success mt-2'>La pregunta se eliminó correctamente.</div>";
                }
            }
        }

        private void EliminarPregunta(int preguntaId)
        {
            using (var cn = new MySqlConnection(cs))
            {
                cn.Open();
                using (var tx = cn.BeginTransaction())
                {
                    try
                    {
                        // 1) Borrar respuestas de intentos que usan alternativas de esta pregunta
                        using (var cmdResp = new MySqlCommand(@"
                    DELETE ri
                    FROM respuesta_intento ri
                    INNER JOIN alternativa a ON a.alternativa_id = ri.alternativa_id
                    WHERE a.pregunta_id = @id;", cn, tx))
                        {
                            cmdResp.Parameters.AddWithValue("@id", preguntaId);
                            cmdResp.ExecuteNonQuery();
                        }

                        // 2) Borrar alternativas asociadas a la pregunta
                        using (var cmdAlt = new MySqlCommand(
                            @"DELETE FROM alternativa WHERE pregunta_id = @id;", cn, tx))
                        {
                            cmdAlt.Parameters.AddWithValue("@id", preguntaId);
                            cmdAlt.ExecuteNonQuery();
                        }

                        // 3) Borrar la pregunta
                        using (var cmdPreg = new MySqlCommand(
                            @"DELETE FROM pregunta WHERE pregunta_id = @id;", cn, tx))
                        {
                            cmdPreg.Parameters.AddWithValue("@id", preguntaId);
                            cmdPreg.ExecuteNonQuery();
                        }

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }
    }
}
