namespace bluesky.Services.IA
{
    /// <summary>
    /// Parámetros de generación para IA (reserva para futuras mejoras).
    /// </summary>
    public class IaParams
    {
        public int CantidadPreguntas { get; set; } = 10;
        public string Nivel { get; set; } = "intermedio";
        public string ContextoCurso { get; set; } = string.Empty;
    }
}
