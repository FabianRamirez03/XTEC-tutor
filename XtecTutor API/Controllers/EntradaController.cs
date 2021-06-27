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
    public class EntradaController : ControllerBase
    {
        private string serverKey = Startup.getKey();
        [HttpGet]
        [Route("verEntradas")]
        public List<Entrada> verEntradas([FromQuery] string carnet)
        {
            List<Entrada> entradas = new List<Entrada>();
            SqlConnection conn = new SqlConnection(serverKey);
            conn.Open();
            SqlCommand cmd;
            string insertQuery = "verEntradasAlumno";
            cmd = new SqlCommand(insertQuery, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@carnet", carnet);
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var entrada = new Entrada();
                entrada.idEntrada = (int)dr[0];
                entrada.titulo = dr[1].ToString();
                entrada.vistas = (int)dr[2];
                entrada.puntuacion = (decimal)dr[3];
                entrada.descripcion = dr[4].ToString();
                entrada.visible = (Boolean)dr[5];
                entrada.carrera = dr[6].ToString();
                entrada.curso = dr[7].ToString();
                entrada.tema = dr[8].ToString();
                entradas.Add(entrada);
            }
            return entradas;
        }

        [HttpGet]
        [Route("obtenerEntrada")]
        public Entrada obtenerEntrada([FromQuery] string idEntrada)
        {
            SqlConnection conn = new SqlConnection(serverKey);
            conn.Open();
            SqlCommand cmd;
            string insertQuery = "obtenerEntrada";
            cmd = new SqlCommand(insertQuery, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@idEntrada", idEntrada);
            SqlDataReader dr = cmd.ExecuteReader();
            var entrada = new Entrada();
            while (dr.Read())
            {            
                entrada.idEntrada = (int)dr[0];
                entrada.titulo = dr[1].ToString();
                entrada.cuerpoArticulo = dr[2].ToString();
                entrada.vistas = (int)dr[3];
                entrada.puntuacion = (decimal)dr[4];
                entrada.descripcion = dr[5].ToString();
                entrada.visible = (Boolean)dr[6];
                entrada.nombreArchivo = dr[7].ToString();
                entrada.fechaCreacion = (DateTime)dr[8];
                entrada.existeArchivo = (Boolean)dr[9];
                entrada.carnet = dr[10].ToString();
                entrada.primerNombre = dr[11].ToString();
                entrada.apellido = dr[12].ToString();
            }
            return entrada;
        }

        [HttpGet]
        [Route("cambiarVisibilidad")]
        public IActionResult cambiarVisibilidad([FromQuery] string idEntrada)
        {
            try {
                SqlConnection conn = new SqlConnection(serverKey);
                conn.Open();
                SqlCommand cmd;
                string insertQuery = "cambiarVisibilidad";
                cmd = new SqlCommand(insertQuery, conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@idEntrada", idEntrada);
                cmd.ExecuteScalar();
                return Ok();
            }
            catch(Exception ex) {
                return StatusCode(500, $"Internal server error: {ex}");
            }
        }

        [HttpGet]
        [Route("agregarVista")]
        public IActionResult agregarVista([FromQuery] string idEntrada)
        {
            try
            {
                SqlConnection conn = new SqlConnection(serverKey);
                conn.Open();
                SqlCommand cmd;
                string insertQuery = "agregarVista";
                cmd = new SqlCommand(insertQuery, conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@idEntrada", idEntrada);
                cmd.ExecuteScalar();
                return Ok();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex}");
            }
        }
    }
}
