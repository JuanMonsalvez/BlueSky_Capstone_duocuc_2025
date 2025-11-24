using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace bluesky.models
{
    public class Evaluacion
    {
        public class RespuestaAlumno
        {
            public int questionId { get; set; }
            public string letter { get; set; }
        }

        public class Respuesta
        {
            public int questionId { get; set; }
            public string letter { get; set; }
        }
    }
}