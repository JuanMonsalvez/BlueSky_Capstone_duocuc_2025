using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.IO;
using System.Net.Mail;
using System.Web.UI;
using MySql.Data.MySqlClient;

namespace bluesky.Admin
{
    public partial class CrearCurso : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var username = Session["Username"] as string;
            if (string.IsNullOrEmpty(username))
            {
                // No logueado → lo mando a iniciar sesión
                Response.Redirect("~/IniciarSesion.aspx");
                return;
            }

            int rol;
            bool esAdmin = Session["Rol"] != null
                           && int.TryParse(Session["Rol"].ToString(), out rol)
                           && rol == 1;

            if (!esAdmin)
            {
                // Logueado pero SIN rol de admin → lo saco del área admin
                Response.Redirect("~/Default.aspx");
                return;
            }

            // 👇 Aquí agrego lo que pediste
            var master = this.Master as bluesky.SiteMaster;
            if (master != null)
            {
                master.UsarMenuBasico = true;
                master.OcultarMenus = true;
            }
        }

        protected void btnCrearCurso_Click(object sender, EventArgs e)
        {
            // 1) Nombre
            string nombreCurso = txtNombreCurso.Text.Trim();
            if (string.IsNullOrWhiteSpace(nombreCurso))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errNombre",
                    "Swal.fire('Error', 'El nombre es obligatorio.', 'error');",
                    true
                );
                return;
            }

            // 2) Fecha inicio (opcional)
            DateTime? fechaInicio = null;
            if (DateTime.TryParse(txtFechaInicio.Text, out DateTime fechaParsed))
                fechaInicio = fechaParsed;

            // 3) Duración (opcional)
            int? duracionHoras = null;
            if (int.TryParse(txtDuracionHoras.Text, out int duracionParsed))
                duracionHoras = duracionParsed;

            // 4) Modalidad
            string modalidad = "Online";

            // 5) Imagen (obligatoria)
            if (!fuImagen.HasFile)
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errImagen",
                    "Swal.fire('Error', 'Debes subir una imagen para el curso.', 'error');",
                    true
                );
                return;
            }

            string ext = Path.GetExtension(fuImagen.FileName).ToLower();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errFormatoImg",
                    "Swal.fire('Error', 'Formato de imagen inválido. Usa JPG, JPEG o PNG.', 'error');",
                    true
                );
                return;
            }

            // Guardar imagen en /images
            string nombreUnico = "curso_" + Guid.NewGuid().ToString("N") + ext;
            string rutaFisica = Server.MapPath("~/images/" + nombreUnico);
            fuImagen.SaveAs(rutaFisica);
            string rutaImagenBD = "images/" + nombreUnico;

            string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;
            int nuevoCursoId = 0;

            try
            {
                // 6) INSERT EN BD
                using (var conn = new MySqlConnection(cs))
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = @"
                INSERT INTO curso (nombre, fecha_inicio, duracion_horas, modalidad, imagen_url)
                VALUES (@Nombre, @FechaInicio, @DuracionHoras, @Modalidad, @Imagen);

                SELECT LAST_INSERT_ID();
            ";

                    cmd.Parameters.AddWithValue("@Nombre", nombreCurso);
                    cmd.Parameters.AddWithValue("@FechaInicio", (object)fechaInicio ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@DuracionHoras", (object)duracionHoras ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Modalidad", modalidad);
                    cmd.Parameters.AddWithValue("@Imagen", rutaImagenBD);

                    conn.Open();
                    nuevoCursoId = Convert.ToInt32(cmd.ExecuteScalar());
                }

                // 7) Notificar por correo a los suscritos
                NotificarNuevoCursoATodos(nuevoCursoId, nombreCurso);

                // 8) Limpiar campos
                txtNombreCurso.Text = string.Empty;
                txtFechaInicio.Text = string.Empty;
                txtDuracionHoras.Text = string.Empty;
                // el FileUpload se limpia al recargar

                // 9) Alerta de éxito
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "okCurso",
                    "Swal.fire('Éxito', 'El curso se creó correctamente.', 'success');",
                    true
                );
            }
            catch (Exception)
            {
                // Si quieres, intenta borrar la imagen si algo falla en BD
                try
                {
                    if (File.Exists(rutaFisica))
                        File.Delete(rutaFisica);
                }
                catch { }

                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errCurso",
                    "Swal.fire('Error', 'Ocurrió un problema al crear el curso. Intenta nuevamente.', 'error');",
                    true
                );
            }
        }

        // 2) BUSCA TODOS LOS EMAILS SUSCRITOS Y ACTIVO = 1
        private void NotificarNuevoCursoATodos(int cursoId, string nombreCurso)
        {
            string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;
            var emails = new List<string>();

            using (var conn = new MySqlConnection(cs))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = @"
                    SELECT email
                    FROM boletin_suscripcion
                    WHERE activo = 1;
                ";

                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string email = reader.GetString("email");
                        if (!string.IsNullOrWhiteSpace(email))
                        {
                            emails.Add(email);
                        }
                    }
                }
            }

            // Recorremos TODOS los correos y enviamos uno a uno
            foreach (var email in emails)
            {
                try
                {
                    EnviarCorreoNuevoCurso(email, nombreCurso, cursoId);
                }
                catch
                {
                    // Aquí podrías guardar el error en una tabla de logs si quieres
                }
            }
        }

        // 3) ARMA Y ENVÍA EL CORREO A UNA PERSONA
        private void EnviarCorreoNuevoCurso(string destinatario, string nombreCurso, int cursoId)
        {
            // Construimos la URL a la página de cursos, según tu proyecto:
            // en tu solución se ve "Cursos.aspx" en la raíz del sitio.

            // baseUrl = http://localhost:1234  ó  https://midominio.cl
            string baseUrl = Request.Url.GetLeftPart(UriPartial.Authority);

            // Ruta relativa a Cursos.aspx
            string urlCursos = ResolveUrl("~/Cursos.aspx");

            // URL completa que irá en el correo
            string urlCurso = baseUrl + urlCursos;
            // Ej: http://localhost:1234/Cursos.aspx

            string asunto = "Nuevo curso disponible: " + nombreCurso;

            string cuerpoHtml = $@"
                <p>Hola,</p>
                <p>Te informamos que se ha publicado un nuevo curso en el portal de capacitaciones de <strong>BlueSky Financial</strong>:</p>
                <p style='font-size:16px; margin-top:10px;'>
                    <strong>{nombreCurso}</strong>
                </p>
                <p style='margin-top:10px;'>
                    Puedes revisarlo en el siguiente enlace:<br/>
                    <a href='{urlCurso}' target='_blank'>Ver cursos en el portal</a>
                </p>
                <p style='font-size:12px; color:#666; margin-top:20px;'>
                    Estás recibiendo este correo porque te suscribiste a nuestro boletín de capacitaciones.<br/>
                    Si ya no deseas recibir estas notificaciones, podrás desuscribirte desde el portal.
                </p>
            ";

            var mensaje = new MailMessage();

            // From: tomamos los datos del web.config (appSettings)
            mensaje.From = new MailAddress(
                ConfigurationManager.AppSettings["SmtpFromEmail"],
                ConfigurationManager.AppSettings["SmtpFromName"]
            );

            mensaje.To.Add(destinatario);
            mensaje.Subject = asunto;
            mensaje.Body = cuerpoHtml;
            mensaje.IsBodyHtml = true;

            var smtp = new SmtpClient
            {
                Host = ConfigurationManager.AppSettings["SmtpHost"],          // smtp.gmail.com
                Port = int.Parse(ConfigurationManager.AppSettings["SmtpPort"]), // 587
                EnableSsl = true,
                Credentials = new System.Net.NetworkCredential(
                    ConfigurationManager.AppSettings["SmtpUser"],
                    ConfigurationManager.AppSettings["SmtpPassword"]
                )
            };

            smtp.Send(mensaje);
        }
    }
}
