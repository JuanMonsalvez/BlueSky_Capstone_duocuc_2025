using System;
using System.Configuration;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;

namespace bluesky.Admin
{
    public partial class GestionEvaluacionEditar : Page
    {
        private readonly string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!VerificarAdmin())
                return;

            if (!IsPostBack)
            {
                CargarCursos();

                string preguntaIdStr = Request.QueryString["preguntaId"];
                if (!string.IsNullOrEmpty(preguntaIdStr))
                {
                    // modo edición
                    ltlTitulo.Text = "Editar pregunta";
                    CargarPreguntaExistente(preguntaIdStr);
                }
                else
                {
                    // modo nuevo
                    ltlTitulo.Text = "Nueva pregunta";
                    hfPreguntaId.Value = string.Empty;

                    // Si viene cursoId en query, preseleccionarlo
                    string cursoIdStr = Request.QueryString["cursoId"];
                    if (!string.IsNullOrEmpty(cursoIdStr))
                    {
                        var item = ddlCurso.Items.FindByValue(cursoIdStr);
                        if (item != null)
                            ddlCurso.SelectedValue = cursoIdStr;
                    }

                    // marcar por defecto alternativa 1 como correcta
                    rbCorrecta1.Checked = true;
                }
            }
        }

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

        private void CargarCursos()
        {
            ddlCurso.Items.Clear();

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
                        ddlCurso.Items.Add(
                            new System.Web.UI.WebControls.ListItem(
                                Convert.ToString(dr["nombre"]),
                                Convert.ToString(dr["curso_id"])
                            ));
                    }
                }
            }
        }

        private void CargarPreguntaExistente(string preguntaIdStr)
        {
            int preguntaId;
            if (!int.TryParse(preguntaIdStr, out preguntaId))
            {
                ltlMensaje.Text = "<div class='alert alert-danger'>ID de pregunta inválido.</div>";
                pnlFormulario.Visible = false;
                return;
            }

            hfPreguntaId.Value = preguntaId.ToString();

            using (var cn = new MySqlConnection(cs))
            {
                cn.Open();

                // 1) Cargar pregunta
                using (var cmd = new MySqlCommand(
                    @"SELECT pregunta_id, texto, curso_id
                      FROM pregunta
                      WHERE pregunta_id = @id;", cn))
                {
                    cmd.Parameters.AddWithValue("@id", preguntaId);
                    using (var dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            txtPregunta.Text = Convert.ToString(dr["texto"]);
                            ddlCurso.SelectedValue = Convert.ToString(dr["curso_id"]);
                        }
                        else
                        {
                            ltlMensaje.Text = "<div class='alert alert-danger'>No se encontró la pregunta.</div>";
                            pnlFormulario.Visible = false;
                            return;
                        }
                    }
                }

                // 2) Cargar alternativas
                using (var cmdAlt = new MySqlCommand(
                    @"SELECT alternativa_id, texto, es_correcta
                      FROM alternativa
                      WHERE pregunta_id = @id
                      ORDER BY alternativa_id ASC;", cn))
                {
                    cmdAlt.Parameters.AddWithValue("@id", preguntaId);

                    using (var drAlt = cmdAlt.ExecuteReader())
                    {
                        // Reseteamos selección
                        rbCorrecta1.Checked = rbCorrecta2.Checked = rbCorrecta3.Checked = rbCorrecta4.Checked = false;

                        int index = 0;
                        while (drAlt.Read())
                        {
                            string textoAlt = Convert.ToString(drAlt["texto"]);
                            bool esCorrecta = Convert.ToInt32(drAlt["es_correcta"]) == 1;

                            if (index == 0)
                            {
                                txtAlt1.Text = textoAlt;
                                rbCorrecta1.Checked = esCorrecta;
                            }
                            else if (index == 1)
                            {
                                txtAlt2.Text = textoAlt;
                                rbCorrecta2.Checked = esCorrecta;
                            }
                            else if (index == 2)
                            {
                                txtAlt3.Text = textoAlt;
                                rbCorrecta3.Checked = esCorrecta;
                            }
                            else if (index == 3)
                            {
                                txtAlt4.Text = textoAlt;
                                rbCorrecta4.Checked = esCorrecta;
                            }

                            index++;
                            if (index >= 4) break;
                        }

                        // Si ninguna alternativa quedó marcada como correcta, marcamos la primera
                        if (!rbCorrecta1.Checked &&
                            !rbCorrecta2.Checked &&
                            !rbCorrecta3.Checked &&
                            !rbCorrecta4.Checked)
                        {
                            rbCorrecta1.Checked = true;
                        }
                    }
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            ltlMensaje.Text = string.Empty;

            if (string.IsNullOrWhiteSpace(txtPregunta.Text))
            {
                ltlMensaje.Text = "<div class='alert alert-danger'>Debe ingresar el texto de la pregunta.</div>";
                return;
            }

            if (string.IsNullOrEmpty(ddlCurso.SelectedValue))
            {
                ltlMensaje.Text = "<div class='alert alert-danger'>Debe seleccionar un curso.</div>";
                return;
            }

            // Validar alternativas
            string alt1 = txtAlt1.Text.Trim();
            string alt2 = txtAlt2.Text.Trim();
            string alt3 = txtAlt3.Text.Trim();
            string alt4 = txtAlt4.Text.Trim();

            if (string.IsNullOrWhiteSpace(alt1) ||
                string.IsNullOrWhiteSpace(alt2) ||
                string.IsNullOrWhiteSpace(alt3) ||
                string.IsNullOrWhiteSpace(alt4))
            {
                ltlMensaje.Text = "<div class='alert alert-danger'>Debes ingresar las 4 alternativas.</div>";
                return;
            }

            int indiceCorrecta = ObtenerIndiceCorrecta();
            if (indiceCorrecta == 0)
            {
                ltlMensaje.Text = "<div class='alert alert-danger'>Debes marcar una alternativa correcta.</div>";
                return;
            }

            int cursoId = Convert.ToInt32(ddlCurso.SelectedValue);
            string preguntaTexto = txtPregunta.Text.Trim();

            int preguntaId;
            bool esNuevo = string.IsNullOrEmpty(hfPreguntaId.Value);

            using (var cn = new MySqlConnection(cs))
            {
                cn.Open();
                using (var tx = cn.BeginTransaction())
                {
                    try
                    {
                        if (esNuevo)
                        {
                            using (var cmd = new MySqlCommand(
                                @"INSERT INTO pregunta (texto, curso_id)
                                  VALUES (@texto, @curso);
                                  SELECT LAST_INSERT_ID();", cn, tx))
                            {
                                cmd.Parameters.AddWithValue("@texto", preguntaTexto);
                                cmd.Parameters.AddWithValue("@curso", cursoId);
                                object result = cmd.ExecuteScalar();
                                preguntaId = Convert.ToInt32(result);
                                hfPreguntaId.Value = preguntaId.ToString();
                            }
                        }
                        else
                        {
                            preguntaId = Convert.ToInt32(hfPreguntaId.Value);

                            using (var cmd = new MySqlCommand(
                                @"UPDATE pregunta
                                  SET texto = @texto, curso_id = @curso
                                  WHERE pregunta_id = @id;", cn, tx))
                            {
                                cmd.Parameters.AddWithValue("@texto", preguntaTexto);
                                cmd.Parameters.AddWithValue("@curso", cursoId);
                                cmd.Parameters.AddWithValue("@id", preguntaId);
                                cmd.ExecuteNonQuery();
                            }

                            // Borramos las alternativas antiguas para recrearlas
                            using (var cmdDelAlt = new MySqlCommand(
                                @"DELETE FROM alternativa WHERE pregunta_id = @id;", cn, tx))
                            {
                                cmdDelAlt.Parameters.AddWithValue("@id", preguntaId);
                                cmdDelAlt.ExecuteNonQuery();
                            }
                        }

                        // Insertar alternativas
                        InsertarAlternativa(cn, tx, preguntaId, alt1, esCorrecta: indiceCorrecta == 1);
                        InsertarAlternativa(cn, tx, preguntaId, alt2, esCorrecta: indiceCorrecta == 2);
                        InsertarAlternativa(cn, tx, preguntaId, alt3, esCorrecta: indiceCorrecta == 3);
                        InsertarAlternativa(cn, tx, preguntaId, alt4, esCorrecta: indiceCorrecta == 4);

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }

            ltlMensaje.Text = "<div class='alert alert-success'>La pregunta se guardó correctamente.</div>";
        }

        private void InsertarAlternativa(MySqlConnection cn, MySqlTransaction tx, int preguntaId, string texto, bool esCorrecta)
        {
            using (var cmd = new MySqlCommand(
                @"INSERT INTO alternativa (pregunta_id, texto, es_correcta)
                  VALUES (@pregunta, @texto, @correcta);", cn, tx))
            {
                cmd.Parameters.AddWithValue("@pregunta", preguntaId);
                cmd.Parameters.AddWithValue("@texto", texto);
                cmd.Parameters.AddWithValue("@correcta", esCorrecta ? 1 : 0);
                cmd.ExecuteNonQuery();
            }
        }

        private int ObtenerIndiceCorrecta()
        {
            if (rbCorrecta1.Checked) return 1;
            if (rbCorrecta2.Checked) return 2;
            if (rbCorrecta3.Checked) return 3;
            if (rbCorrecta4.Checked) return 4;
            return 0;
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/GestionEvaluaciones.aspx");
        }
    }
}
