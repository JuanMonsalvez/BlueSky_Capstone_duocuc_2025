using System;
using System.Linq;

namespace bluesky.Services.IA
{
    public static class Validadores
    {
        public static void ValidaEstructura(EvalResult eval)
        {
            if (eval == null)
                throw new InvalidOperationException("El objeto EvalResult es nulo.");

            if (eval.Preguntas == null || !eval.Preguntas.Any())
                throw new InvalidOperationException("La IA no generó ninguna pregunta.");

            foreach (var p in eval.Preguntas)
            {
                if (string.IsNullOrWhiteSpace(p.Enunciado))
                    throw new InvalidOperationException("Se encontró una pregunta sin enunciado.");

                if (p.Alternativas == null || !p.Alternativas.Any())
                    throw new InvalidOperationException($"La pregunta '{p.Enunciado}' no tiene alternativas.");

                int correctas = p.Alternativas.Count(a => a.EsCorrecta);
                if (correctas == 0)
                    throw new InvalidOperationException($"La pregunta '{p.Enunciado}' no tiene alternativa correcta.");
            }
        }
    }
}
