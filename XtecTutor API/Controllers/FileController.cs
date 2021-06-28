using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Internal;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;
using Tweetinvi;
using XtecTutor_API;
using XtecTutorAPI.Models;

namespace XtecTutorAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FileController : ControllerBase
    {
        private string serverKey = Startup.getKey();

        [HttpPost, DisableRequestSizeLimit]
        [Route("upload")]
        public IActionResult Upload()
        {
            try
            {
                var x = Request.Form; 
                

                var dict = Request.Form.ToDictionary(x => x.Key, x => x.Value.ToString());

                SqlConnection conn = new SqlConnection(serverKey);
                conn.Open();
                string insertQuery = "crearEntradaConocimiento";
                SqlCommand cmd = new SqlCommand(insertQuery, conn);

                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@descripcion", dict["descripcion"]);
                cmd.Parameters.AddWithValue("@carnet", dict["carnet"]);
                cmd.Parameters.AddWithValue("@titulo", dict["titulo"]);
                cmd.Parameters.AddWithValue("@cuerpoArticulo", dict["cuerpoArticulo"]);
                cmd.Parameters.AddWithValue("@visible", 1);
                cmd.Parameters.AddWithValue("@carrera", dict["carrera"]);
                cmd.Parameters.AddWithValue("@curso", dict["curso"]);
                cmd.Parameters.AddWithValue("@tema", dict["tema"]);



                try
                {
                    var file = Request.Form.Files[0];
                    var folderName = Path.Combine("Resources");
                    var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);
                    var fileName = ContentDispositionHeaderValue.Parse(file.ContentDisposition).FileName.Trim('"');
                    var fullPath = Path.Combine(pathToSave, fileName);
                    var dbPath = Path.Combine(folderName, fileName);
                    using (var ms = new MemoryStream())
                    {
                        file.CopyTo(ms);
                        var fileBytes = ms.ToArray();
                        string base64File = Convert.ToBase64String(fileBytes);
                        cmd.Parameters.AddWithValue("@nombreArchivo", fileName);
                        cmd.Parameters.AddWithValue("@extension", ".pdf");
                        cmd.Parameters.AddWithValue("@archivo", base64File);
                    }

                }
                    catch (Exception ex)
            {
                    cmd.Parameters.AddWithValue("@nombreArchivo", "");
                    cmd.Parameters.AddWithValue("@extension", "");
                    cmd.Parameters.AddWithValue("@archivo", "");

                }
                cmd.ExecuteNonQuery();
                var n = "";
                conn.Close();

                SqlConnection conn2 = new SqlConnection(serverKey);
                conn2.Open();
                string insertQuery2 = "obtenerUltimaEntrada";
                SqlCommand cmd2 = new SqlCommand(insertQuery2, conn2);

                cmd2.CommandType = System.Data.CommandType.StoredProcedure;
                n = cmd2.ExecuteScalar().ToString();

                Twitter.twittear("Se ha generado la entrada: '" + dict["titulo"] + "' en el catálogo: " + dict["carrera"] + ", " + dict["curso"] + ", " + dict["tema"] + " http://localhost:4200/entrada/" + n.ToString());
                return Ok();


            }

            catch (Exception ex)
            {
           return StatusCode(500, $"Internal server error: {ex}");}

        }

        [HttpPost, DisableRequestSizeLimit]
        [Route("editarEntrada")]
        public IActionResult editarEntrada()
        {
            try
            {
                var x = Request.Form;


                var dict = Request.Form.ToDictionary(x => x.Key, x => x.Value.ToString());

                SqlConnection conn = new SqlConnection(serverKey);
                conn.Open();
                string insertQuery = "EditarEntradaConocimiento";
                SqlCommand cmd = new SqlCommand(insertQuery, conn);

                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@descripcion", dict["descripcion"]);
                cmd.Parameters.AddWithValue("@idEntrada", dict["idEntrada"]);
                cmd.Parameters.AddWithValue("@titulo", dict["titulo"]);
                cmd.Parameters.AddWithValue("@cuerpoArticulo", dict["cuerpoArticulo"]);
                cmd.Parameters.AddWithValue("@carrera", dict["carrera"]);
                cmd.Parameters.AddWithValue("@curso", dict["curso"]);
                cmd.Parameters.AddWithValue("@tema", dict["tema"]);



                try
                {
                    var file = Request.Form.Files[0];
                    var folderName = Path.Combine("Resources");
                    var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);
                    var fileName = ContentDispositionHeaderValue.Parse(file.ContentDisposition).FileName.Trim('"');
                    var fullPath = Path.Combine(pathToSave, fileName);
                    var dbPath = Path.Combine(folderName, fileName);
                    using (var ms = new MemoryStream())
                    {
                        file.CopyTo(ms);
                        var fileBytes = ms.ToArray();
                        string base64File = Convert.ToBase64String(fileBytes);
                        cmd.Parameters.AddWithValue("@nombreArchivo", fileName);
                        cmd.Parameters.AddWithValue("@extension", ".pdf");
                        cmd.Parameters.AddWithValue("@archivo", base64File);
                        cmd.ExecuteNonQuery();
                        conn.Close();

                        return Ok(new { dbPath });
                    }

                }
                catch (Exception ex)
                {
                    cmd.Parameters.AddWithValue("@nombreArchivo", "");
                    cmd.Parameters.AddWithValue("@extension", "");
                    cmd.Parameters.AddWithValue("@archivo", "");
                    cmd.ExecuteNonQuery();
                    conn.Close();
                    return Ok();
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex}");
            }

        }

        [HttpGet, DisableRequestSizeLimit]
        [Route("download")]
        public async Task<IActionResult> Download([FromQuery] string idFile)
        {
            SqlConnection conn = new SqlConnection(serverKey);
            conn.Open();
            SqlCommand cmd;
            string insertQuery = "descargarArchivo";
            cmd = new SqlCommand(insertQuery, conn);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@idEntrada", idFile);
            SqlDataReader dr = cmd.ExecuteReader();

            var fileAsBase64 = "";
            var extension = "";
            var nombreArchivo = "";
            while (dr.Read())
            {
                fileAsBase64 = dr[0].ToString();
                extension = dr[1].ToString();
                nombreArchivo = dr[2].ToString();
            }

            Byte[] bytes = Convert.FromBase64String(fileAsBase64);
            var stream = new MemoryStream(bytes);
            Response.Headers.Add("Access-Control-Expose-Headers", "Content-Disposition");
            return File(stream, "application/octet-stream", nombreArchivo);
        }


        [HttpGet, DisableRequestSizeLimit]
        [Route("getPhotos")]
        public IActionResult GetPhotos()
        {
            try
            {
                var folderName = Path.Combine("Resources");
                var pathToRead = Path.Combine(Directory.GetCurrentDirectory(), folderName);
                var photos = Directory.EnumerateFiles(pathToRead)
                    .Where(IsAPhotoFile)
                    .Select(fullPath => Path.Combine(folderName, Path.GetFileName(fullPath)));
                return Ok(new { photos });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex}");
            }
        }
        private bool IsAPhotoFile(string fileName)
        {
            return fileName.EndsWith(".jpg", StringComparison.OrdinalIgnoreCase)
                || fileName.EndsWith(".jpeg", StringComparison.OrdinalIgnoreCase)
                || fileName.EndsWith(".png", StringComparison.OrdinalIgnoreCase);
        }
    }
}
