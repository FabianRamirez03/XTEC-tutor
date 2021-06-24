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
using XtecTutor_API;

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
                var file = Request.Form.Files[0];
                var folderName = Path.Combine("Resources");
                var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);

                if (file.Length > 0)
                {
                    var fileName = ContentDispositionHeaderValue.Parse(file.ContentDisposition).FileName.Trim('"');
                    var fullPath = Path.Combine(pathToSave, fileName);
                    var dbPath = Path.Combine(folderName, fileName);
                    using (var ms = new MemoryStream())
                    {
                        file.CopyTo(ms);
                        var fileBytes = ms.ToArray();
                        string base64File = Convert.ToBase64String(fileBytes);

                        SqlConnection conn = new SqlConnection(serverKey);
                        conn.Open();
                        string insertQuery = "crearEntradaConocimiento";
                        SqlCommand cmd = new SqlCommand(insertQuery, conn);

                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@descripcion", "descripcion de prueba");
                        cmd.Parameters.AddWithValue("@carnet", "2018319178");
                        cmd.Parameters.AddWithValue("@titulo", "Prueba de que sirva");
                        cmd.Parameters.AddWithValue("@cuerpoArticulo", "Hola! Este articulo esta funcionando, creo");
                        cmd.Parameters.AddWithValue("@visible", 1);
                        cmd.Parameters.AddWithValue("@nombreArchivo", fileName);
                        cmd.Parameters.AddWithValue("@extension", ".pdf");
                        cmd.Parameters.AddWithValue("@archivo", base64File);
                        cmd.Parameters.AddWithValue("@carrera", "computadores");
                        cmd.Parameters.AddWithValue("@curso", "intro y taller");
                        cmd.Parameters.AddWithValue("@tema", "recursividad");
                        cmd.ExecuteNonQuery();
                        conn.Close();


                        return Ok(new { dbPath });
                    }

                }
                else
                {
                    return BadRequest();
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
        [Route("download2")]
        public async Task<IActionResult> Download2([FromQuery] string fileUrl)
        {
            var filePath = Path.Combine(Directory.GetCurrentDirectory(), fileUrl);
            if (!System.IO.File.Exists(filePath))
                return NotFound();
            var memory = new MemoryStream();
            using (var stream = new FileStream(filePath, FileMode.Open))
            {
                await stream.CopyToAsync(memory);
            }
            memory.Position = 0;
            return File(memory, GetContentType(filePath), filePath);
        }
        private string GetContentType(string path)
        {
            var provider = new FileExtensionContentTypeProvider();
            string contentType;

            if (!provider.TryGetContentType(path, out contentType))
            {
                contentType = "application/octet-stream";
            }

            return contentType;
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
