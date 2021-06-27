using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace XtecTutorAPI.Models
{
    public class Review
    {
        public string primerNombre { get; set; }
        public string apellido { get; set; }
        public string comentario { get; set; }
        public decimal nota { get; set; }
        public string fotografia { get; set; }
        public int idEntrada { get; set; }
        public string carnet { get; set; }
        public DateTime fecha { get; set; }
    }
}
