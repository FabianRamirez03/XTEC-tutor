using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace XtecTutorAPI.Models
{
    public class Usuario
    {
        public int tipoUsuario { get; set; }
        public string primerNombre { get; set; }
        public string apellido { get; set; }
        public string descripcion { get; set; }
        public string sede { get; set; }
        public string telefono { get; set; }
        public DateTime fechaUnion { get; set; }
        public string fotografia { get; set; }
        public string correo { get; set; }
        public string carnet { get; set; }
        public string password { get; set; }


    }
}
