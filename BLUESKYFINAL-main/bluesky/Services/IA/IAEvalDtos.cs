using System.Collections.Generic;

namespace bluesky.Services.IA
{
    /// <summary>
    /// Resultado de la evaluación generada por IA.
    /// </summary>
    public class EvalResult
    {
        public List<EvalPregunta> Preguntas { get; set; } = new List<EvalPregunta>();
    }

    /// <summary>
    /// Representa una pregunta de la evaluación.
    /// </summary>
    public class EvalPregunta
    {
        public string Enunciado { get; set; }
        public List<EvalAlternativa> Alternativas { get; set; } = new List<EvalAlternativa>();
    }

    /// <summary>
    /// Representa una alternativa de respuesta.
    /// </summary>
    public class EvalAlternativa
    {
        public string Texto { get; set; }
        public bool EsCorrecta { get; set; }
    }
}
