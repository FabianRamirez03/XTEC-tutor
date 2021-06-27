using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using XtecTutorAPI.Models;
using XtecTutor_API;

namespace XtecTutorAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CatalogosController : ControllerBase
    {
        private string serverKey = Startup.getKey();
        [HttpGet]
        [Route("getCarreras")]
        public List<Object> getCarreras()
        {
            List<Object> carreras = new List<Object>();
            SqlConnection conn = new SqlConnection(serverKey);
            conn.Open();
            SqlCommand cmd;
            string insertQuery = "verCarreras";
            cmd = new SqlCommand(insertQuery, conn);
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var car = new { carrera = dr[0].ToString() };
                carreras.Add(car);
            }
            return carreras;
        }

        [HttpGet]
        [Route("getCursos")]
        public List<Object> getCursos([FromQuery] string carrera)
        {
            List<Object> cursos = new List<Object>();
            try {
                SqlConnection conn = new SqlConnection(serverKey);
                conn.Open();
                SqlCommand cmd;
                string insertQuery = "verCursos";
                cmd = new SqlCommand(insertQuery, conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@carrera", carrera);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    var car = new { curso = dr[0].ToString() };
                    cursos.Add(car);
                }
            }
            catch (Exception ex){ }
            return cursos;
        } 

        [HttpGet]
        [Route("getTemas")]
        public List<Object> getTemas([FromQuery] string curso)
        {
            List<Object> temas = new List<Object>();
            try
            {
                SqlConnection conn = new SqlConnection(serverKey);
                conn.Open();
                SqlCommand cmd;
                string insertQuery = "verTemas";
                cmd = new SqlCommand(insertQuery, conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@curso", curso);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    var car = new { tema = dr[0].ToString() };
                    temas.Add(car);
                }
            }
            catch(Exception ex)
            {}
           
            
            return temas;
        }

        [HttpPost]
        [Route("crearCatalogo")]
        public void crearCatalogo(Catalogo catalogo)
        {
            List<Object> carreras = new List<Object>();
            SqlConnection conn = new SqlConnection(serverKey);
            conn.Open();
            SqlCommand cmd;
            string insertQuery = "crearCatalogo";
            cmd = new SqlCommand(insertQuery, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@usuarioAdmin", catalogo.usuarioAdmin);
            cmd.Parameters.AddWithValue("@carrera", catalogo.carrera);
            cmd.Parameters.AddWithValue("@curso", catalogo.curso);
            cmd.Parameters.AddWithValue("@tema", catalogo.tema);
            cmd.ExecuteNonQuery();
            conn.Close();
        }


    }
}
