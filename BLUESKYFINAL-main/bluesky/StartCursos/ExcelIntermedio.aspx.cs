using System;
using System.Configuration;
using System.Data;
using System.IO;
using System.Web.UI;
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

namespace bluesky.StartCursos
{
    public partial class ExcelIntermedio : System.Web.UI.Page
    {
        private readonly string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            var master = this.Master as bluesky.SiteMaster;
            if (master != null)
            {
                master.UsarMenuBasico = true;
                master.OcultarMenus = true;
            }

            if (!IsPostBack)
            {
                // Si quieres mostrar el rut:
                // string rut = Convert.ToString(Session["USUARIO_ID"]);
                // lblUsuario.Text = rut;
            }
        }

        protected void btnDescargarPPT_Click(object sender, EventArgs e)
        {
            string filePath = Server.MapPath("~/ppts/Herramientas de excel intermedio.pptx");
            string fileName = "Herramientas de excel intermedio.pptx";

            Response.Clear();
            Response.ContentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
            Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
            Response.TransmitFile(filePath);
            Response.End();
        }

        protected void btnVolver_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Cursos.aspx");
        }

        // ====== LÓGICA DE INTENTOS / APROBACIÓN ======

        private bool CursoAprobado(string rut, int cursoId)
        {
            int totalPreguntas = ObtenerTotalPreguntas(cursoId);
            if (totalPreguntas == 0)
                return false;

            // mínimo de correctas para 60%
            int minCorrectas = (int)Math.Ceiling(totalPreguntas * 0.60m);

            using (var cn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand(
                @"SELECT COUNT(*) 
          FROM intento_evaluacion 
          WHERE persrut = @rut 
            AND curso_id = @curso
            AND num_correctas >= @minCorrectas;", cn))
            {
                cmd.Parameters.AddWithValue("@rut", rut);
                cmd.Parameters.AddWithValue("@curso", cursoId);
                cmd.Parameters.AddWithValue("@minCorrectas", minCorrectas);

                cn.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());
                return count > 0;
            }
        }

        private void ObtenerEstadoIntentos(string rut, int cursoId,
    out int totalIntentos, out bool ultimoFueAprobado)
        {
            totalIntentos = 0;
            ultimoFueAprobado = false;

            int totalPreguntas = ObtenerTotalPreguntas(cursoId);
            if (totalPreguntas == 0)
                return;

            int minCorrectas = (int)Math.Ceiling(totalPreguntas * 0.60m);

            using (var cn = new MySqlConnection(cs))
            {
                cn.Open();

                // Total intentos
                using (var cmdCount = new MySqlCommand(
                    @"SELECT COUNT(*) 
              FROM intento_evaluacion 
              WHERE persrut = @rut AND curso_id = @curso;", cn))
                {
                    cmdCount.Parameters.AddWithValue("@rut", rut);
                    cmdCount.Parameters.AddWithValue("@curso", cursoId);
                    totalIntentos = Convert.ToInt32(cmdCount.ExecuteScalar());
                }

                // Último intento -> num_correctas
                using (var cmdLast = new MySqlCommand(
                    @"SELECT num_correctas
              FROM intento_evaluacion 
              WHERE persrut = @rut AND curso_id = @curso
              ORDER BY fecha DESC
              LIMIT 1;", cn))
                {
                    cmdLast.Parameters.AddWithValue("@rut", rut);
                    cmdLast.Parameters.AddWithValue("@curso", cursoId);

                    object result = cmdLast.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        int numCorrectasUltimo = Convert.ToInt32(result);
                        ultimoFueAprobado = numCorrectasUltimo >= minCorrectas;
                    }
                }
            }
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

        protected void btnConfirmarInicioEval_Click(object sender, EventArgs e)
        {
            string rut = Convert.ToString(Session["USUARIO_ID"]);

            if (string.IsNullOrEmpty(rut))
            {
                Response.Redirect("~/IniciarSesion.aspx");
                return;
            }

            int cursoId = 10; // Excel Intermedio (ajusta si es otro ID)

            int totalIntentos;
            bool ultimoFueAprobado;
            ObtenerEstadoIntentos(rut, cursoId, out totalIntentos, out ultimoFueAprobado);

            bool cursoAprobado = CursoAprobado(rut, cursoId);

            if (cursoAprobado)
            {
                btnRealizarEvalIgual.Visible = true;
                ltlMensajeIntentosMax.Text = string.Empty;

                ScriptManager.RegisterStartupScript(
                    this,
                    GetType(),
                    "showAprobadoModalExcelIntermedio",
                    "_showModal('modalCursoAprobado');",
                    true
                );
                return;
            }

            Response.Redirect("~/Evaluaciones/EvaluacionExcelIntermedio.aspx");
        }

        protected void btnDescargarCertificadoAprobado_Click(object sender, EventArgs e)
        {
            string rut = Convert.ToString(Session["USUARIO_ID"]);
            if (string.IsNullOrEmpty(rut))
                return;

            string nombreCompleto = ObtenerNombreCompleto(rut);
            if (string.IsNullOrWhiteSpace(nombreCompleto))
                nombreCompleto = "Alumno";

            string nombreCurso = "Excel Intermedio";

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

                Rectangle pageSize = page.GetPageSize();
                string rutaMarcaAgua = Server.MapPath("~/images/LOGO-BLUESKY.png");

                if (File.Exists(rutaMarcaAgua))
                {
                    ImageData marcaAguaData = ImageDataFactory.Create(rutaMarcaAgua);

                    float marcaAncho = 360f;
                    float marcaAlto = 360f;

                    float centerX = pageSize.GetWidth() / 2;
                    float centerY = pageSize.GetHeight() / 2;

                    Image marcaAgua = new Image(marcaAguaData)
                        .ScaleToFit(marcaAncho, marcaAlto)
                        .SetOpacity(0.20f)
                        .SetRotationAngle(Math.PI * 35.0 / 180.0);

                    float x = centerX - (marcaAncho / 2) - 45f;
                    float y = centerY - (marcaAlto / 2);

                    marcaAgua.SetFixedPosition(x, y);

                    PdfCanvas canvasWatermark = new PdfCanvas(page.NewContentStreamBefore(), page.GetResources(), pdf);
                    new Canvas(canvasWatermark, pageSize).Add(marcaAgua);
                }

                PdfCanvas canvas = new PdfCanvas(page);
                float margin = 30;

                canvas.SetLineWidth(2)
                      .SetStrokeColor(colorBorde)
                      .Rectangle(
                          margin,
                          margin,
                          pageSize.GetWidth() - margin * 2,
                          pageSize.GetHeight() - margin * 2)
                      .Stroke();

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
                    new System.Globalization.CultureInfo("es-CL"));

                document.Add(
                    new Paragraph("Santiago de Chile, " + fecha)
                        .SetTextAlignment(TextAlignment.CENTER)
                        .SetFontSize(11)
                        .SetFontColor(colorTexto)
                );

                document.Add(new Paragraph("\n"));

                string rutaFirma = Server.MapPath("~/images/Firma-BLUESKY.jfif");
                if (File.Exists(rutaFirma))
                {
                    var imgData = ImageDataFactory.Create(rutaFirma);
                    var firmaImg = new Image(imgData)
                        .ScaleToFit(320, 160)
                        .SetHorizontalAlignment(HorizontalAlignment.CENTER)
                        .SetMarginBottom(5);

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
                Response.AddHeader("content-disposition", "attachment; filename=Certificado_ExcelIntermedio.pdf");
                Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
                Response.BinaryWrite(bytes);
                Response.End();
            }
        }

        protected void btnRealizarEvalIgual_Click(object sender, EventArgs e)
        {
            string rut = Convert.ToString(Session["USUARIO_ID"]);
            if (string.IsNullOrEmpty(rut))
            {
                Response.Redirect("~/IniciarSesion.aspx");
                return;
            }

            int cursoId = 10; // Excel Intermedio (ajusta si es otro ID)
            int totalIntentos;
            bool ultimoFueAprobado;
            ObtenerEstadoIntentos(rut, cursoId, out totalIntentos, out ultimoFueAprobado);

            if (totalIntentos >= 3)
            {
                ltlMensajeIntentosMax.Text =
                    "<div class='alert alert-danger text-center mt-3'>" +
                    "Ya has utilizado tus 3 oportunidades para este curso. No puedes volver a rendir la evaluación." +
                    "</div>";

                ScriptManager.RegisterStartupScript(
                    this,
                    GetType(),
                    "hideAprobadoModalExcelIntermedio",
                    "_hideModal('modalCursoAprobado');",
                    true
                );

                return;
            }

            Response.Redirect("~/Evaluaciones/EvaluacionExcelIntermedio.aspx");
        }

        private int ObtenerTotalPreguntas(int cursoId)
        {
            using (var cn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand(
                @"SELECT COUNT(*)
          FROM pregunta
          WHERE curso_id = @curso;", cn))
            {
                cmd.Parameters.AddWithValue("@curso", cursoId);
                cn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }
    }
}
