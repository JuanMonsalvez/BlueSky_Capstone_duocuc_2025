using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace bluesky.Services.IA
{
    public static class Parsers
    {
        /// <summary>
        /// Parsea el JSON devuelto por IA al modelo EvalResult.
        /// Espera estructura: { "preguntas": [ { "enunciado": "...", "alternativas": [ { "texto": "...", "esCorrecta": true } ] } ] }
        /// </summary>
        public static EvalResult ParseEvalResult(string json)
        {
            if (string.IsNullOrWhiteSpace(json))
                throw new ArgumentException("La respuesta de IA está vacía.", nameof(json));

            try
            {
                // Intento directo a EvalResult
                var directo = JsonConvert.DeserializeObject<EvalResult>(json);
                if (directo != null && directo.Preguntas != null && directo.Preguntas.Count > 0)
                    return directo;
            }
            catch
            {
                // Si falla, intentamos "desenvolver" un texto que contenga JSON embebido.
            }

            // A veces Gemini devuelve texto que contiene el JSON dentro de ```json ``` o similar.
            string cleaned = ExtraerJsonProbable(json);

            var result = JsonConvert.DeserializeObject<EvalResult>(cleaned);
            if (result == null)
                throw new InvalidOperationException("No se pudo parsear la respuesta de IA a EvalResult.");

            return result;
        }

        /// <summary>
        /// Intenta extraer el bloque JSON principal de un texto que puede traer ``` o texto adicional.
        /// </summary>
        private static string ExtraerJsonProbable(string raw)
        {
            raw = raw.Trim();

            // Quitar fences de código típicos: ```json ... ```
            if (raw.StartsWith("```"))
            {
                int firstBrace = raw.IndexOf('{');
                int lastBrace = raw.LastIndexOf('}');
                if (firstBrace >= 0 && lastBrace > firstBrace)
                {
                    return raw.Substring(firstBrace, lastBrace - firstBrace + 1);
                }
            }

            // Si no se detecta nada raro, devolvemos tal cual
            return raw;
        }
    }
}
