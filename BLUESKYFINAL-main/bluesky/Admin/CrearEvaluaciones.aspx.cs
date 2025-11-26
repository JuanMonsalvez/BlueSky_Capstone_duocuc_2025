using RestSharp;
using System;
using System.IO;
using System.Web.UI;
using Newtonsoft.Json.Linq; // Necesario para parsear JSON dinámico

namespace bluesky.Admin
{
    public partial class CrearEvaluaciones : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var username = Session["Username"] as string;
            if (string.IsNullOrEmpty(username))
            {
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
        }

        protected void btnGenerar_Click(object sender, EventArgs e)
        {
            if (pdfUpload.HasFile)
            {
                string filePath = Server.MapPath("~/Uploads/" + pdfUpload.FileName);
                pdfUpload.SaveAs(filePath);

                string resultado = GenerarEvaluacionDesdePDF(filePath);
                litResultado.Text = $"<pre style='white-space: pre-wrap; font-family:Segoe UI; font-size:14px;'>{resultado}</pre>";
            }
            else
            {
                litResultado.Text = "<p class='text-danger'>Por favor selecciona un archivo PDF.</p>";
            }
        }

        private string GenerarEvaluacionDesdePDF(string pdfPath)
        {
            // ⚠️ Guardar la API key en Web.config
            string apiKey = System.Configuration.ConfigurationManager.AppSettings["GeminiApiKey"];
            string endpoint = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={apiKey}";

            byte[] fileBytes = File.ReadAllBytes(pdfPath);
            string base64Pdf = Convert.ToBase64String(fileBytes);

            var client = new RestClient(endpoint);
            var request = new RestRequest();
            request.Method = Method.Post;
            request.AddHeader("Content-Type", "application/json");

            var body = new
            {
                contents = new object[]
                {
                    new {
                        parts = new object[]
                        {
                            new {
                                inline_data = new {
                                    mime_type = "application/pdf",
                                    data = base64Pdf
                                }
                            }
                        }
                    },
                    new {
                        parts = new object[]
                        {
                            new {
                                text = "Analiza este archivo PDF y genera una evaluación de 15 preguntas con 4 alternativas (A, B, C, D) sobre el contenido del curso. No incluyas las respuestas correctas y dame las respuesta al final."
                            }
                        }
                    }
                }
            };

            request.AddJsonBody(body);

            var response = client.Execute(request);

            if (response.IsSuccessful && !string.IsNullOrEmpty(response.Content))
            {
                try
                {
                    var jsonResponse = JObject.Parse(response.Content);
                    string text = (string)jsonResponse["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];
                    return !string.IsNullOrEmpty(text) ? text : "⚠️ No se encontró texto en la respuesta.";
                }
                catch (Exception ex)
                {
                    return $"⚠️ Error al interpretar la respuesta del modelo: {ex.Message}";
                }
            }
            else
            {
                return $"❌ Error al conectarse con Gemini API: {response.StatusCode} - {response.ErrorMessage}";
            }
        }
    }
}
