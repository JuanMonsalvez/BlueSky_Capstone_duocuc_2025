using System;
using System.Configuration;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace bluesky.Services.IA
{
    /// <summary>
    /// Cliente para consumir la API de Google Gemini.
    /// </summary>
    public class GeminiClient
    {
        private readonly string _apiKey;
        private readonly string _model;
        private readonly string _endpoint;

        private static readonly HttpClient _httpClient = new HttpClient();

        public GeminiClient()
        {
            _apiKey = ConfigurationManager.AppSettings["GEMINI_API_KEY"];
            _model = ConfigurationManager.AppSettings["GEMINI_MODEL"] ?? "gemini-2.5-flash";
            _endpoint = ConfigurationManager.AppSettings["GEMINI_ENDPOINT"]?.TrimEnd('/')
                        ?? "https://generativelanguage.googleapis.com";

            if (string.IsNullOrWhiteSpace(_apiKey))
                throw new InvalidOperationException("No se encontró GEMINI_API_KEY en appSettings.");

            _httpClient.Timeout = TimeSpan.FromSeconds(30);
        }

        /// <summary>
        /// Envía un prompt a Gemini y devuelve el texto de la primera respuesta.
        /// </summary>
        public async Task<string> GenerateTextAsync(string prompt)
        {
            if (string.IsNullOrWhiteSpace(prompt))
                throw new ArgumentException("El prompt no puede estar vacío.", nameof(prompt));

            string url = $"{_endpoint}/v1beta/models/{_model}:generateContent?key={_apiKey}";

            var requestBody = new
            {
                contents = new[]
                {
                    new
                    {
                        parts = new[]
                        {
                            new { text = prompt }
                        }
                    }
                }
            };

            string json = JsonConvert.SerializeObject(requestBody);
            var content = new StringContent(json, Encoding.UTF8, "application/json");

            using (var response = await _httpClient.PostAsync(url, content).ConfigureAwait(false))
            {
                string responseJson = await response.Content.ReadAsStringAsync().ConfigureAwait(false);

                if (!response.IsSuccessStatusCode)
                {
                    throw new InvalidOperationException(
                        $"Error en la llamada a Gemini ({response.StatusCode}): {responseJson}");
                }

                // Modelo de respuesta simplificado para extraer el primer texto
                dynamic obj = JsonConvert.DeserializeObject(responseJson);
                try
                {
                    string text = obj.candidates[0].content.parts[0].text;
                    return text;
                }
                catch
                {
                    // Si el formato cambia, devolvemos el JSON completo para que el parser se haga cargo
                    return responseJson;
                }
            }
        }
    }
}
