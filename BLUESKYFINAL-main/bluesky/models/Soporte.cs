using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace bluesky.models
{
    public class SoporteItem
    {
        public int contacto_id { get; set; }
        public string rut { get; set; }
        public string nombre { get; set; }
        public string apellido_paterno { get; set; }
        public string apellido_materno { get; set; }
        public string email { get; set; }
        public string persfono { get; set; }
        public string problema { get; set; }
        public DateTime fecha { get; set; }
        public int estado { get; set; }


    }
}
