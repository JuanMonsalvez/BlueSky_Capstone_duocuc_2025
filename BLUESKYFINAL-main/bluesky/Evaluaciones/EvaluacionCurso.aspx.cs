using System;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

// iText7
using iText.Kernel.Colors;
using iText.Kernel.Geom;
using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using iText.Layout.Properties;
using iText.Kernel.Pdf.Canvas;
using iText.IO.Image;
using Image = iText.Layout.Element.Image;
using iText.Kernel.Pdf.Extgstate;

namespace bluesky.StartCursos
{
    public partial class EvaluacionCurso : System.Web.UI.Page
    {
        // conexión a la BD
        private readonly string cs = ConfigurationManager
            .ConnectionStrings["MySqlConn"].ConnectionString;

        // tiempo máximo de evaluación (minutos) -> si quieres, luego lo puedes sacar de la BD
        private const int DURACION_MINUTOS = 20;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Opcional: comportamiento de tu MasterPage
            var master = this.Master as bluesky.SiteMaster;
            if (master != null)
            {
                master.UsarMenuBasico = true;
                master.OcultarMenus = true;
            }

            if (IsPostBack) return;

            // Validar login
            string usuarioId = Convert.ToString(Session["USUARIO_ID"]);
            if (string.IsNullOrEmpty(usuarioId))
            {
                Response.Redirect("~/IniciarSesion.aspx");
                return;
            }

            // Obtener cursoId desde querystring
            int cursoId;
            if (!int.TryParse(Request.QueryString["cursoId"], out cursoId) || cursoId <= 0)
            {
                ltlMensajeIntentos.Text =
                    "<div class='alert alert-danger text-center'>Curso no especificado o inválido.</div>";
                pnlEvaluacion.Visible = false;
                pnlResultado.Visible = false;
                return;
            }

            // Título del curso
            string nombreCurso = ObtenerNombreCurso(cursoId);
            if (string.IsNullOrEmpty(nombreCurso))
            {
                ltlMensajeIntentos.Text =
                    "<div class='alert alert-danger text-center'>No se encontró información para el curso seleccionado.</div>";
                pnlEvaluacion.Visible = false;
                pnlResultado.Visible = false;
                return;
            }
            ltlTituloCurso.Text = "Evaluación: " + nombreCurso;

            // 1) Validar máximo 3 intentos por curso
            if (TieneMaxIntentos(usuarioId, cursoId))
            {
                ltlMensajeIntentos.Text =
                    "<div class='alert alert-danger text-center'>" +
                    "Ya has utilizado tus 3 intentos para este curso." +
                    "</div>";
                pnlEvaluacion.Visible = false;
                pnlResultado.Visible = false;
                return;
            }

            // 2) Control de tiempo: guardar inicio en sesión la primera vez
            string sessionKey = "InicioEval_" + cursoId;
            if (Session[sessionKey] == null)
            {
                Session[sessionKey] = DateTime.Now;
            }

            DateTime inicio = (DateTime)Session[sessionKey];
            double minutosTranscurridos = (DateTime.Now - inicio).TotalMinutes;

            if (minutosTranscurridos >= DURACION_MINUTOS)
            {
                ltlMensajeIntentos.Text =
                    "<div class='alert alert-warning text-center'>" +
                    "El tiempo para esta evaluación ha expirado. Vuelve a intentarlo en otro momento (si te quedan intentos)." +
                    "</div>";
                pnlEvaluacion.Visible = false;
                pnlResultado.Visible = false;
                return;
            }

            double minutosRestantes = DURACION_MINUTOS - minutosTranscurridos;
            if (minutosRestantes < 0) minutosRestantes = 0;
            hfTiempoLimiteMin.Value = Math.Ceiling(minutosRestantes).ToString(CultureInfo.InvariantCulture);

            // 3) Cargar preguntas + alternativas del curso
            CargarPreguntasYAlternativas(cursoId);
            pnlEvaluacion.Visible = true;
        }

        private string ObtenerNombreCurso(int cursoId)
        {
            using (var cn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand(
                @"SELECT nombre FROM curso WHERE curso_id = @id;", cn))
            {
                cmd.Parameters.AddWithValue("@id", cursoId);
                cn.Open();
                object result = cmd.ExecuteScalar();
                return result == null ? null : Convert.ToString(result);
            }
        }

        private bool TieneMaxIntentos(string rut, int cursoId)
        {
            using (var cn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand(
                @"SELECT COUNT(*) 
                  FROM intento_evaluacion 
                  WHERE persrut = @rut AND curso_id = @curso;", cn))
            {
                cmd.Parameters.AddWithValue("@rut", rut);
                cmd.Parameters.AddWithValue("@curso", cursoId);
                cn.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());
                return count >= 3;
            }
        }

        private void CargarPreguntasYAlternativas(int cursoId)
        {
            DataTable dtAll = new DataTable();

            using (var cn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand(
                @"SELECT  p.pregunta_id,
                          p.texto        AS texto_pregunta,
                          a.alternativa_id,
                          a.texto        AS texto_alternativa,
                          a.es_correcta
                  FROM pregunta p
                  INNER JOIN alternativa a ON a.pregunta_id = p.pregunta_id
                  WHERE p.curso_id = @curso
                  ORDER BY p.pregunta_id, a.alternativa_id;", cn))
            {
                cmd.Parameters.AddWithValue("@curso", cursoId);
                cn.Open();
                using (var da = new MySqlDataAdapter(cmd))
                {
                    da.Fill(dtAll);
                }
            }

            ViewState["dtAll"] = dtAll;

            // Obtener preguntas distintas
            DataView dvPreg = new DataView(dtAll);
            DataTable dtPreguntas = dvPreg.ToTable(true, "pregunta_id", "texto_pregunta");

            // Tomar solo 15 por si agregas más en el futuro
            if (dtPreguntas.Rows.Count > 15)
            {
                DataTable dtTop15 = dtPreguntas.Clone();
                for (int i = 0; i < 15; i++)
                    dtTop15.ImportRow(dtPreguntas.Rows[i]);
                dtPreguntas = dtTop15;
            }

            rptPreguntas.DataSource = dtPreguntas;
            rptPreguntas.DataBind();
        }

        protected void rptPreguntas_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            HiddenField hfPreguntaId = (HiddenField)e.Item.FindControl("hfPreguntaId");
            RadioButtonList rblAlternativas = (RadioButtonList)e.Item.FindControl("rblAlternativas");

            DataTable dtAll = ViewState["dtAll"] as DataTable;
            if (dtAll == null || hfPreguntaId == null || rblAlternativas == null) return;

            int preguntaId = Convert.ToInt32(hfPreguntaId.Value);

            DataView dvAlt = new DataView(dtAll);
            dvAlt.RowFilter = "pregunta_id = " + preguntaId;

            rblAlternativas.DataSource = dvAlt;
            rblAlternativas.DataTextField = "texto_alternativa";
            rblAlternativas.DataValueField = "alternativa_id";
            rblAlternativas.DataBind();
        }

        protected void btnFinalizar_Click(object sender, EventArgs e)
        {
            string rut = Convert.ToString(Session["USUARIO_ID"]);
            if (string.IsNullOrEmpty(rut))
            {
                Response.Redirect("~/IniciarSesion.aspx");
                return;
            }

            int cursoId;
            if (!int.TryParse(Request.QueryString["cursoId"], out cursoId) || cursoId <= 0)
            {
                ltlResultado.Text = "<div class='alert alert-danger'>Curso no válido.</div>";
                pnlResultado.Visible = true;
                pnlEvaluacion.Visible = false;
                return;
            }

            // Verificación de tiempo en servidor
            string sessionKey = "InicioEval_" + cursoId;
            if (Session[sessionKey] is DateTime inicio)
            {
                var transcurrido = DateTime.Now - inicio;
                if (transcurrido.TotalMinutes > DURACION_MINUTOS)
                {
                    // Tiempo agotado: guardamos intento con 0 puntos opcionalmente
                    RegistrarIntentoSinRespuestas(rut, cursoId);
                    pnlEvaluacion.Visible = false;
                    pnlResultado.Visible = true;

                    ltlResultado.Text =
                        "<div class='alert alert-warning'>El tiempo para esta evaluación ha expirado. " +
                        "El intento se registró con puntaje 0%.</div>";

                    btnCertificado.Visible = false;
                    return;
                }
            }

            DataTable dtAll = ViewState["dtAll"] as DataTable;
            if (dtAll == null)
            {
                ltlResultado.Text = "<div class='alert alert-danger'>No se pudieron recuperar las preguntas.</div>";
                pnlResultado.Visible = true;
                pnlEvaluacion.Visible = false;
                return;
            }

            int totalPreguntas = rptPreguntas.Items.Count;
            int correctas = 0;

            foreach (RepeaterItem item in rptPreguntas.Items)
            {
                RadioButtonList rblAlt =
                    (RadioButtonList)item.FindControl("rblAlternativas");

                if (rblAlt == null || string.IsNullOrEmpty(rblAlt.SelectedValue))
                    continue;

                int alternativaId = Convert.ToInt32(rblAlt.SelectedValue);

                DataRow[] filas = dtAll.Select("alternativa_id = " + alternativaId);
                if (filas.Length > 0)
                {
                    bool esCorrecta = Convert.ToInt32(filas[0]["es_correcta"]) == 1;
                    if (esCorrecta) correctas++;
                }
            }

            decimal porcentaje = totalPreguntas == 0
                ? 0
                : (correctas * 100m / totalPreguntas);

            bool aprobado = porcentaje >= 60m;
            int intentoIdGenerado;

            // Guardar intento + respuestas
            using (var cn = new MySqlConnection(cs))
            {
                cn.Open();

                using (var tx = cn.BeginTransaction())
                {
                    try
                    {
                        using (var cmd = new MySqlCommand(
                            @"INSERT INTO intento_evaluacion
                              (persrut, curso_id, fecha, puntaje, num_correctas)
                              VALUES (@rut, @curso, NOW(), @puntaje, @numc);", cn, tx))
                        {
                            cmd.Parameters.AddWithValue("@rut", rut);
                            cmd.Parameters.AddWithValue("@curso", cursoId);
                            cmd.Parameters.AddWithValue("@puntaje", porcentaje);
                            cmd.Parameters.AddWithValue("@numc", correctas);

                            cmd.ExecuteNonQuery();
                            intentoIdGenerado = (int)cmd.LastInsertedId;
                        }

                        foreach (RepeaterItem item in rptPreguntas.Items)
                        {
                            HiddenField hfPreguntaId =
                                (HiddenField)item.FindControl("hfPreguntaId");
                            RadioButtonList rblAlt =
                                (RadioButtonList)item.FindControl("rblAlternativas");

                            if (hfPreguntaId == null || rblAlt == null ||
                                string.IsNullOrEmpty(rblAlt.SelectedValue))
                                continue;

                            int preguntaId = Convert.ToInt32(hfPreguntaId.Value);
                            int alternativaId = Convert.ToInt32(rblAlt.SelectedValue);

                            using (var cmdIns = new MySqlCommand(
                                @"INSERT INTO respuesta_intento
                                  (intento_id, pregunta_id, alternativa_id)
                                  VALUES (@intento, @pregunta, @alternativa);", cn, tx))
                            {
                                cmdIns.Parameters.AddWithValue("@intento", intentoIdGenerado);
                                cmdIns.Parameters.AddWithValue("@pregunta", preguntaId);
                                cmdIns.Parameters.AddWithValue("@alternativa", alternativaId);
                                cmdIns.ExecuteNonQuery();
                            }
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

            pnlEvaluacion.Visible = false;
            pnlResultado.Visible = true;

            ltlResultado.Text = string.Format(
                "<p>Respuestas correctas: <strong>{0}/{1}</strong></p>" +
                "<p>Puntaje: <strong>{2:0.00}%</strong></p>" +
                "<p>Estado: <strong style='color:{3};'>{4}</strong></p>",
                correctas, totalPreguntas, porcentaje,
                aprobado ? "green" : "red",
                aprobado ? "APROBADO" : "NO APROBADO");

            btnCertificado.Visible = aprobado;
        }

        private void RegistrarIntentoSinRespuestas(string rut, int cursoId)
        {
            using (var cn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand(
                @"INSERT INTO intento_evaluacion
                  (persrut, curso_id, fecha, puntaje, num_correctas)
                  VALUES (@rut, @curso, NOW(), 0, 0);", cn))
            {
                cmd.Parameters.AddWithValue("@rut", rut);
                cmd.Parameters.AddWithValue("@curso", cursoId);
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnVolverCursos_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Cursos.aspx");
        }

        private string ObtenerNombreCompleto(string rut)
        {
            using (var cn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand(
                @"SELECT persnombre, perspatern, persmatern
                  FROM usuario
                  WHERE persrut = @rut;", cn))
            {
                cmd.Parameters.AddWithValue("@rut", rut);
                cn.Open();
                using (var dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        string nombres = Convert.ToString(dr["persnombre"]);
                        string apPat = Convert.ToString(dr["perspatern"]);
                        string apMat = Convert.ToString(dr["persmatern"]);
                        return string.Format("{0} {1} {2}", nombres, apPat, apMat).Trim();
                    }
                }
            }
            return null;
        }

        protected void btnCertificado_Click(object sender, EventArgs e)
        {
            string rut = Convert.ToString(Session["USUARIO_ID"]);
            if (string.IsNullOrEmpty(rut))
                return;

            int cursoId;
            if (!int.TryParse(Request.QueryString["cursoId"], out cursoId))
                return;

            string nombreCompleto = ObtenerNombreCompleto(rut);
            if (string.IsNullOrWhiteSpace(nombreCompleto))
                nombreCompleto = "Alumno";

            string nombreCurso = ObtenerNombreCurso(cursoId);
            if (string.IsNullOrEmpty(nombreCurso))
                nombreCurso = "Curso";

            using (var ms = new MemoryStream())
            {
                PdfWriter writer = new PdfWriter(ms);
                PdfDocument pdf = new PdfDocument(writer);

                Color colorBorde = new DeviceRgb(13, 110, 253);
                Color colorTexto = new DeviceRgb(33, 37, 41);
                Color colorDetalle = new DeviceRgb(108, 117, 125);

                PdfPage page = pdf.AddNewPage(PageSize.A4);
                Document document = new Document(pdf, PageSize.A4);
                document.SetMargins(80, 60, 80, 60);

                // Marca de agua
                Rectangle pageSize = page.GetPageSize();
                string rutaMarcaAgua = Server.MapPath("~/images/LOGO-BLUESKY.png");

                if (File.Exists(rutaMarcaAgua))
                {
                    ImageData marcaAguaData = ImageDataFactory.Create(rutaMarcaAgua);

                    float centerX = pageSize.GetWidth() / 2;
                    float centerY = pageSize.GetHeight() / 2;

                    PdfCanvas canvasWatermark = new PdfCanvas(page.NewContentStreamBefore(), page.GetResources(), pdf);
                    canvasWatermark.SaveState();

                    PdfExtGState gs1 = new PdfExtGState().SetFillOpacity(0.10f);
                    canvasWatermark.SetExtGState(gs1);

                    float marcaAncho = 300;
                    float marcaAlto = 300;

                    canvasWatermark.AddImageWithTransformationMatrix(
                        marcaAguaData,
                        marcaAncho, 0,
                        0, marcaAlto,
                        centerX - (marcaAncho / 2),
                        centerY - (marcaAlto / 2)
                    );

                    canvasWatermark.RestoreState();
                }

                // Marco
                PdfCanvas canvas = new PdfCanvas(page);
                float margin = 30;

                canvas.SetLineWidth(2)
                      .SetStrokeColor(colorBorde);
                canvas.Rectangle(
                    margin,
                    margin,
                    pageSize.GetWidth() - margin * 2,
                    pageSize.GetHeight() - margin * 2);
                canvas.Stroke();

                // Contenido
                document.Add(
                    new Paragraph("BlueSky Financial")
                        .SetTextAlignment(TextAlignment.CENTER)
                        .SetFontSize(18)
                        .SetFontColor(colorBorde)
                );

                document.Add(new Paragraph("\n"));

                document.Add(
                    new Paragraph("CERTIFICADO DE APROBACIÓN")
                        .SetTextAlignment(TextAlignment.CENTER)
                        .SetFontSize(22)
                        .SetFontColor(colorTexto)
                );

                document.Add(new Paragraph("\n"));

                document.Add(
                    new Paragraph("Se certifica que")
                        .SetTextAlignment(TextAlignment.CENTER)
                        .SetFontSize(13)
                        .SetFontColor(colorDetalle)
                );

                document.Add(
                    new Paragraph(nombreCompleto.ToUpperInvariant())
                        .SetTextAlignment(TextAlignment.CENTER)
                        .SetFontSize(20)
                        .SetFontColor(colorTexto)
                );

                document.Add(new Paragraph("\n"));

                document.Add(
                    new Paragraph("ha aprobado satisfactoriamente el siguiente curso:")
                        .SetTextAlignment(TextAlignment.CENTER)
                        .SetFontSize(13)
                        .SetFontColor(colorDetalle)
                );

                document.Add(
                    new Paragraph(nombreCurso)
                        .SetTextAlignment(TextAlignment.CENTER)
                        .SetFontSize(18)
                        .SetFontColor(colorBorde)
                );

                document.Add(new Paragraph("\n"));

                document.Add(
                    new Paragraph("Otorgado en reconocimiento a la correcta realización y aprobación de la evaluación final del programa de formación impartido por la plataforma de capacitación de BlueSky Financial.")
                        .SetTextAlignment(TextAlignment.CENTER)
                        .SetFontSize(11)
                        .SetFontColor(colorTexto)
                );

                document.Add(new Paragraph("\n"));

                string fecha = DateTime.Now.ToString(
                    "dd 'de' MMMM 'de' yyyy",
                    new CultureInfo("es-CL"));

                document.Add(
                    new Paragraph("Santiago de Chile, " + fecha)
                        .SetTextAlignment(TextAlignment.CENTER)
                        .SetFontSize(11)
                        .SetFontColor(colorTexto)
                );

                document.Add(new Paragraph("\n\n\n"));

                string rutaFirma = Server.MapPath("~/images/Firma-BLUESKY.jfif");
                if (File.Exists(rutaFirma))
                {
                    var imgData = ImageDataFactory.Create(rutaFirma);
                    var firmaImg = new Image(imgData)
                        .ScaleToFit(120, 60)
                        .SetHorizontalAlignment(HorizontalAlignment.CENTER);

                    document.Add(firmaImg);
                }
                else
                {
                    document.Add(
                        new Paragraph("______________________________")
                            .SetTextAlignment(TextAlignment.CENTER)
                            .SetFontSize(11)
                            .SetFontColor(colorTexto)
                    );
                }

                document.Add(
                    new Paragraph("Dirección Académica\nBlueSky Financial")
                        .SetTextAlignment(TextAlignment.CENTER)
                        .SetFontSize(11)
                        .SetFontColor(colorTexto)
                );

                document.Add(new Paragraph("\n"));

                document.Add(
                    new Paragraph("Este certificado ha sido emitido digitalmente por la plataforma de capacitación de BlueSky Financial.")
                        .SetTextAlignment(TextAlignment.CENTER)
                        .SetFontSize(9)
                        .SetFontColor(colorDetalle)
                );

                document.Close();

                byte[] bytes = ms.ToArray();
                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("content-disposition", "attachment; filename=Certificado_Curso.pdf");
                Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
                Response.BinaryWrite(bytes);
                Response.End();
            }
        }
    }
}
