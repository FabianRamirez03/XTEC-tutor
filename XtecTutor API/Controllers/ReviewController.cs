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
    public class ReviewController : ControllerBase
    {
        private string serverKey = Startup.getKey();
        [HttpGet]
        [Route("getReviews")]
        public List<Review> verReviews([FromQuery] string idEntrada)
        {
            List<Review> reviews = new List<Review>();
            SqlConnection conn = new SqlConnection(serverKey);
            conn.Open();
            SqlCommand cmd;
            string insertQuery = "verReviewsEntrada";
            cmd = new SqlCommand(insertQuery, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@idEntrada", idEntrada);
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                var review = new Review();
                review.primerNombre = dr[0].ToString();
                review.apellido = dr[1].ToString();
                review.comentario = dr[2].ToString();
                review.nota = (decimal)dr[3];
                review.fotografia = dr[4].ToString();
                review.fecha = (DateTime)dr[5];

                reviews.Add(review);
            }
            return reviews;
        }

        [HttpPost]
        [Route("comentarEntrada")]
        public IActionResult comentarEntrada(Review review)
        {
            try
            {
                SqlConnection conn = new SqlConnection(serverKey);
                conn.Open();
                SqlCommand cmd;
                string insertQuery = "comentarEntrada";
                cmd = new SqlCommand(insertQuery, conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@carnet", review.carnet);
                cmd.Parameters.AddWithValue("@idEntrada", review.idEntrada);
                cmd.Parameters.AddWithValue("@comentario", review.comentario);
                cmd.ExecuteScalar();
                return Ok();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex}");
            }
        }
        [HttpPost]
        [Route("puntuarEntrada")]
        public IActionResult puntuarEntrada(Review review)
        {
            try
            {
                SqlConnection conn = new SqlConnection(serverKey);
                conn.Open();
                SqlCommand cmd;
                string insertQuery = "puntuarEntrada";
                cmd = new SqlCommand(insertQuery, conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@carnet", review.carnet);
                cmd.Parameters.AddWithValue("@idEntrada", review.idEntrada);
                cmd.Parameters.AddWithValue("@nota", review.nota);
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
