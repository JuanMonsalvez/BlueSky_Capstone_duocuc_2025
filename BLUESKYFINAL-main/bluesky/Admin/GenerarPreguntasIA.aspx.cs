using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using bluesky.Services.IA;

namespace bluesky.Admin
{
    public partial class GenerarPreguntasIA : Page
    {
        private readonly GeminiClient _geminiClient = new GeminiClient();

        protected void Page_Load(object sender, EventArgs e)
        {
            // 🔐 1) Verificar que haya sesión y que el usuario sea ADMIN
            if (!VerificarAdmin())
            {
                // VerificarAdmin ya redirige donde corresponda
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    CargarCursos();
                }
                catch (Exception ex)
                {
                    lblEstado.Text = "Error al cargar cursos: " + ex.Message;
                }
            }
        }

        /// <summary>
        /// Verifica que el usuario esté logueado y tenga rol de administrador.
        /// Asume que el rut está en Session["USUARIO_ID"] y que rol_id = 1 es Admin.
        /// </summary>
        private bool VerificarAdmin()
        {
            string rut = Convert.ToString(Session["USUARIO_ID"]);

            // No está logueado → al login
            if (string.IsNullOrEmpty(rut))
            {
                Response.Redirect("~/IniciarSesion.aspx");
                return false;
            }

            // Revisar en BD el rol del usuario
            var csSetting = ConfigurationManager.ConnectionStrings["MySqlConn"];
            if (csSetting == null)
                throw new InvalidOperationException("No se encontró un connectionString llamado 'MySqlConn' en Web.config.");

            string cs = csSetting.ConnectionString;

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

            // Ajusta el número según tu tabla rol (por ejemplo, 1 = Admin)
            if (rolId != 1)
            {
                // No es admin → lo mandamos a la página principal o a una de "No autorizado"
                Response.Redirect("~/Default.aspx");
                return false;
            }

            return true;
        }

        private void CargarCursos()
        {
            ddlCurso.Items.Clear();
            ddlCurso.Items.Add(new ListItem("-- Selecciona un curso --", ""));

            var csSetting = ConfigurationManager.ConnectionStrings["MySqlConn"];
            if (csSetting == null)
                throw new InvalidOperationException("No se encontró un connectionString llamado 'MySqlConn' en Web.config.");

            string cs = csSetting.ConnectionString;

            const string sql = @"
                SELECT curso_id, nombre
                FROM curso
                ORDER BY nombre ASC;";

            using (var conn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand(sql, conn))
            {
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        var id = rdr.GetInt32("curso_id").ToString();
                        var nombre = rdr.GetString("nombre");
                        ddlCurso.Items.Add(new ListItem(nombre, id));
                    }
                }
            }
        }

        protected async void btnGenerar_Click(object sender, EventArgs e)
        {
            // Por si alguien intenta hacer POST directo sin ser admin
            if (!VerificarAdmin())
                return;

            lblEstado.Text = string.Empty;
            lblEstado.CssClass = "d-block mt-3 fw-bold text-primary";
            litPreview.Text = string.Empty;

            if (string.IsNullOrWhiteSpace(ddlCurso.SelectedValue))
            {
                lblEstado.Text = "Selecciona un curso antes de generar preguntas.";
                return;
            }

            if (!int.TryParse(ddlCurso.SelectedValue, out int cursoId))
            {
                lblEstado.Text = "El ID de curso seleccionado no es válido.";
                return;
            }

            int cantidadPreguntas;
            if (!int.TryParse(ddlCantidad.SelectedValue, out cantidadPreguntas))
            {
                cantidadPreguntas = 10;
            }

            // VALIDAR PDF OBLIGATORIO
            if (!fuPdf.HasFile)
            {
                lblEstado.CssClass = "d-block mt-3 fw-bold text-danger";
                lblEstado.Text = "Debes seleccionar un archivo PDF con el contenido del curso.";
                return;
            }

            string extension = Path.GetExtension(fuPdf.FileName)?.ToLowerInvariant();
            if (extension != ".pdf")
            {
                lblEstado.CssClass = "d-block mt-3 fw-bold text-danger";
                lblEstado.Text = "El archivo debe ser un PDF (.pdf).";
                return;
            }

            string nombreCurso = ddlCurso.SelectedItem.Text;

            try
            {
                // 1) Guardar PDF en carpeta Uploads
                string uploadsPath = TextExtractors.GetUploadsPhysicalPath();
                if (!Directory.Exists(uploadsPath))
                {
                    Directory.CreateDirectory(uploadsPath);
                }

                string fileName = $"{Guid.NewGuid()}{extension}";
                string fullPath = Path.Combine(uploadsPath, fileName);
                fuPdf.SaveAs(fullPath);

                // 2) Extraer texto del PDF
                string contenidoPdf = TextExtractors.ExtraerTextoPdf(fullPath);

                if (string.IsNullOrWhiteSpace(contenidoPdf))
                {
                    lblEstado.CssClass = "d-block mt-3 fw-bold text-danger";
                    lblEstado.Text = "No se pudo extraer texto útil del PDF. Verifica que el archivo no sea una imagen escaneada sin OCR.";
                    return;
                }

                // Limitar tamaño del texto en el prompt
                const int maxLongitud = 8000;
                if (contenidoPdf.Length > maxLongitud)
                {
                    contenidoPdf = contenidoPdf.Substring(0, maxLongitud);
                }

                // 3) Construir prompt con nombre del curso + contenido del PDF
                string prompt = ConstruirPrompt(nombreCurso, cantidadPreguntas, contenidoPdf);

                // 4) Llamar a IA
                var preguntas = await GenerarPreguntasDesdeIAAsync(prompt);

                if (preguntas == null || preguntas.Count == 0)
                {
                    lblEstado.Text = "La IA no devolvió preguntas válidas. Revisa el contenido del PDF o el prompt.";
                    return;
                }

                // 5) Preview
                MostrarPreview(preguntas);

                // 6) Guardar en BD
                int insertadas = GuardarPreguntasEnBlueskyDb(cursoId, preguntas);

                lblEstado.CssClass = "d-block mt-3 fw-bold text-success";
                lblEstado.Text = $"Se generaron y guardaron {insertadas} preguntas para el curso \"{nombreCurso}\" basadas en el PDF.";
            }
            catch (Exception ex)
            {
                lblEstado.CssClass = "d-block mt-3 fw-bold text-danger";
                lblEstado.Text = "Error al generar o guardar las preguntas: " + ex.Message;
            }
        }

        private string ConstruirPrompt(string nombreCurso, int cantidadPreguntas, string contenidoPdf)
        {
            var sb = new StringBuilder();

            sb.AppendLine("Eres un generador de evaluaciones para un curso de capacitación corporativa.");
            sb.AppendLine("Debes generar preguntas de alternativa múltiple en español, claras, sin ambigüedades y DIRECTAMENTE basadas en el contenido que te entregaré.");
            sb.AppendLine();
            sb.AppendLine($"Nombre del curso: \"{nombreCurso}\".");
            sb.AppendLine($"Cantidad de preguntas: {cantidadPreguntas}.");
            sb.AppendLine("Cada pregunta debe tener exactamente 4 alternativas y solo UNA correcta.");
            sb.AppendLine("Nivel: mezcla preguntas básicas e intermedias, enfocadas al contexto del contenido.");
            sb.AppendLine();
            sb.AppendLine("Usa EXCLUSIVAMENTE el siguiente contenido del curso para elaborar las preguntas (no inventes temas externos):");
            sb.AppendLine("```");
            sb.AppendLine(contenidoPdf);
            sb.AppendLine("```");
            sb.AppendLine();
            sb.AppendLine("RESPONDE EXCLUSIVAMENTE en formato JSON con la siguiente estructura:");
            sb.AppendLine("{");
            sb.AppendLine("  \"preguntas\": [");
            sb.AppendLine("    {");
            sb.AppendLine("      \"enunciado\": \"texto de la pregunta\",");
            sb.AppendLine("      \"alternativas\": [");
            sb.AppendLine("        { \"texto\": \"opción A\", \"esCorrecta\": true/false },");
            sb.AppendLine("        { \"texto\": \"opción B\", \"esCorrecta\": true/false },");
            sb.AppendLine("        { \"texto\": \"opción C\", \"esCorrecta\": true/false },");
            sb.AppendLine("        { \"texto\": \"opción D\", \"esCorrecta\": true/false }");
            sb.AppendLine("      ]");
            sb.AppendLine("    }");
            sb.AppendLine("  ]");
            sb.AppendLine("}");

            return sb.ToString();
        }

        private async Task<List<EvalPregunta>> GenerarPreguntasDesdeIAAsync(string prompt)
        {
            string rawResponse = await _geminiClient.GenerateTextAsync(prompt);

            EvalResult evalResult = Parsers.ParseEvalResult(rawResponse);

            Validadores.ValidaEstructura(evalResult);

            NormalizarAlternativas(evalResult.Preguntas);

            return evalResult.Preguntas;
        }

        private void NormalizarAlternativas(List<EvalPregunta> preguntas)
        {
            if (preguntas == null) return;

            foreach (var p in preguntas)
            {
                if (p.Alternativas == null)
                    p.Alternativas = new List<EvalAlternativa>();

                p.Alternativas.RemoveAll(a => string.IsNullOrWhiteSpace(a.Texto));

                if (p.Alternativas.Count > 0 && !p.Alternativas.Exists(a => a.EsCorrecta))
                {
                    p.Alternativas[0].EsCorrecta = true;
                }

                bool yaHayCorrecta = false;
                foreach (var a in p.Alternativas)
                {
                    if (a.EsCorrecta)
                    {
                        if (!yaHayCorrecta)
                        {
                            yaHayCorrecta = true;
                        }
                        else
                        {
                            a.EsCorrecta = false;
                        }
                    }
                }

                while (p.Alternativas.Count < 4)
                {
                    p.Alternativas.Add(new EvalAlternativa
                    {
                        Texto = "Opción adicional",
                        EsCorrecta = false
                    });
                }

                if (p.Alternativas.Count > 4)
                {
                    p.Alternativas = p.Alternativas.GetRange(0, 4);
                }
            }
        }

        private int GuardarPreguntasEnBlueskyDb(int cursoId, List<EvalPregunta> preguntas)
        {
            if (preguntas == null || preguntas.Count == 0)
                return 0;

            var csSetting = ConfigurationManager.ConnectionStrings["MySqlConn"];
            if (csSetting == null)
                throw new InvalidOperationException("No se encontró un connectionString llamado 'MySqlConn' en Web.config.");

            string cs = csSetting.ConnectionString;

            const string sqlInsertPregunta = @"
                INSERT INTO pregunta (texto, curso_id)
                VALUES (@texto, @curso_id);
                SELECT LAST_INSERT_ID();";

            const string sqlInsertAlternativa = @"
                INSERT INTO alternativa (pregunta_id, texto, es_correcta)
                VALUES (@pregunta_id, @texto, @es_correcta);";

            int totalInsertadas = 0;

            using (var conn = new MySqlConnection(cs))
            {
                conn.Open();
                using (var tran = conn.BeginTransaction())
                {
                    try
                    {
                        foreach (var p in preguntas)
                        {
                            if (string.IsNullOrWhiteSpace(p.Enunciado))
                                continue;

                            long preguntaId;
                            using (var cmdPregunta = new MySqlCommand(sqlInsertPregunta, conn, tran))
                            {
                                cmdPregunta.Parameters.AddWithValue("@texto", p.Enunciado.Trim());
                                cmdPregunta.Parameters.AddWithValue("@curso_id", cursoId);
                                object result = cmdPregunta.ExecuteScalar();
                                preguntaId = Convert.ToInt64(result);
                            }

                            if (p.Alternativas != null)
                            {
                                foreach (var alt in p.Alternativas)
                                {
                                    using (var cmdAlt = new MySqlCommand(sqlInsertAlternativa, conn, tran))
                                    {
                                        cmdAlt.Parameters.AddWithValue("@pregunta_id", preguntaId);
                                        cmdAlt.Parameters.AddWithValue("@texto", (alt.Texto ?? "").Trim());
                                        cmdAlt.Parameters.AddWithValue("@es_correcta", alt.EsCorrecta ? 1 : 0);
                                        cmdAlt.ExecuteNonQuery();
                                    }
                                }
                            }

                            totalInsertadas++;
                        }

                        tran.Commit();
                    }
                    catch
                    {
                        tran.Rollback();
                        throw;
                    }
                }
            }

            return totalInsertadas;
        }

        private void MostrarPreview(List<EvalPregunta> preguntas)
        {
            if (preguntas == null || preguntas.Count == 0)
            {
                litPreview.Text = "<p>No hay preguntas para previsualizar.</p>";
                return;
            }

            var sb = new StringBuilder();
            sb.AppendLine("<ol>");

            int maxPreview = Math.Min(5, preguntas.Count);
            for (int i = 0; i < maxPreview; i++)
            {
                var p = preguntas[i];
                sb.Append("<li><strong>")
                  .Append(Server.HtmlEncode(p.Enunciado))
                  .AppendLine("</strong><br/>");

                if (p.Alternativas != null)
                {
                    sb.Append("<ul>");
                    foreach (var alt in p.Alternativas)
                    {
                        sb.Append("<li>")
                          .Append(Server.HtmlEncode(alt.Texto));

                        if (alt.EsCorrecta)
                            sb.Append(" <span style='color:green'>(correcta)</span>");

                        sb.AppendLine("</li>");
                    }
                    sb.Append("</ul>");
                }

                sb.AppendLine("</li>");
            }

            sb.AppendLine("</ol>");
            litPreview.Text = sb.ToString();
        }
    }
}
