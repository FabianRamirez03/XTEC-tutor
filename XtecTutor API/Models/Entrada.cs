using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace XtecTutorAPI.Models
{
    public class Entrada
    {
        public string carrera { get; set; }
        public string curso { get; set; }
        public string tema { get; set; }
        public int idEntrada { get; set; }
        public string titulo { get; set; }
        public int vistas { get; set; }
        public decimal puntuacion { get; set; }
        public string descripcion { get; set; }
        public string cuerpoArticulo { get; set; }
        public string archivo { get; set; }
        public string extension { get; set; }
        public string carnet { get; set; }
        public string primerNombre { get; set; }
        public string apellido { get; set; }
        public string nombreArchivo { get; set; }
        public DateTime fechaCreacion { get; set; }
        public int idCatalogo { get; set; }
        public Boolean visible { get; set; }
        public Boolean existeArchivo { get; set; }
    }
}
