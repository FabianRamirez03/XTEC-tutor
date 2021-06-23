using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using XtecTutorAPI.Controllers;
using XtecTutor_API;
using XtecTutorAPI.Models;
using Newtonsoft.Json;

namespace XtecTutorAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private string serverKey = Startup.getKey();
        [HttpPost, DisableRequestSizeLimit]
        [Route("login")]
        public Usuario login(Usuario usuario)
        {
            SqlConnection conn = new SqlConnection(serverKey);
            conn.Open();
            SqlCommand cmd;
            string insertQuery = "iniciarSesion";
            cmd = new SqlCommand(insertQuery, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@usuario", usuario.carnet);
            cmd.Parameters.AddWithValue("@contrasena", usuario.password);
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                usuario.tipoUsuario = (int)dr[0];
                if(usuario.tipoUsuario == 2)
                {
                    usuario.primerNombre = dr[1].ToString();
                    usuario.apellido = dr[2].ToString();
                    usuario.descripcion = dr[3].ToString();
                    usuario.sede = dr[4].ToString();
                    usuario.telefono = dr[5].ToString();
                    usuario.fechaUnion = (DateTime)dr[6];
                    usuario.fotografia = dr[7].ToString();
                    usuario.correo = dr[8].ToString();
                }


            }


            return usuario;
        }
    }
}
