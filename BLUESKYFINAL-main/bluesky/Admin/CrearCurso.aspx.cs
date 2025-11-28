using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Net.Mail;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace bluesky.Admin
{
    public partial class CrearCurso : System.Web.UI.Page
    {
        private readonly string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            var username = Session["Username"] as string;
            if (string.IsNullOrEmpty(username))
            {
                Response.Redirect("~/IniciarSesion.aspx");
                return;
            }

            int rol;
            bool esAdmin = Session["Rol"] != null
                           && int.TryParse(Session["Rol"].ToString(), out rol)
                           && rol == 1;

            if (!esAdmin)
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            var master = this.Master as bluesky.SiteMaster;
            if (master != null)
            {
                master.UsarMenuBasico = true;
                master.OcultarMenus = true;
            }

            if (!IsPostBack)
            {
                ViewState["FiltroNombre"] = string.Empty;
                CargarCursos();
                InicializarFormulario();
            }
        }

        #region Helpers de UI

        private void InicializarFormulario()
        {
            hdnCursoId.Value = string.Empty;
            txtNombreCurso.Text = string.Empty;
            txtFechaInicio.Text = string.Empty;
            txtDuracionHoras.Text = string.Empty;
            ddlModalidad.SelectedValue = "Online";
            litImagenActual.Text = string.Empty;
            ViewState["ImagenActual"] = null;
            btnCrearCurso.Text = "Crear curso";
            lblFormularioTitulo.InnerText = "Crear nuevo curso";
        }

        protected void btnLimpiarFormulario_Click(object sender, EventArgs e)
        {
            InicializarFormulario();
            MostrarModalCurso(); // mantenemos el modal abierto
        }

        protected void btnNuevoCurso_Click(object sender, EventArgs e)
        {
            InicializarFormulario();
            MostrarModalCurso();
        }

        private void MostrarModalCurso()
        {
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "ShowCursoModal",
                "showCursoModal();",
                true
            );
        }

        private void OcultarModalCurso()
        {
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "HideCursoModal",
                "hideCursoModal();",
                true
            );
        }

        private void MostrarAlerta(string titulo, string mensaje, string tipo)
        {
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                Guid.NewGuid().ToString(),
                $"Swal.fire('{titulo}', '{mensaje}', '{tipo}');",
                true
            );
        }

        #endregion

        #region Listado de cursos + buscador

        private void CargarCursos()
        {
            string filtro = (ViewState["FiltroNombre"] as string ?? string.Empty).Trim();

            using (var conn = new MySqlConnection(cs))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = @"
            SELECT 
    curso_id, 
    nombre, 
    DATE_FORMAT(fecha_inicio, '%d-%m-%Y') AS fecha_inicio,
    duracion_horas, 
    modalidad, 
    imagen_url
FROM curso
WHERE 1 = 1";

                if (!string.IsNullOrEmpty(filtro))
                {
                    cmd.CommandText += " AND nombre LIKE @Nombre";
                    cmd.Parameters.AddWithValue("@Nombre", "%" + filtro + "%");
                }

                // Orden correcto
                cmd.CommandText += " ORDER BY curso_id DESC;";

                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    var tabla = new DataTable();
                    tabla.Load(reader);

                    gvCursos.DataSource = tabla;
                    gvCursos.DataBind();
                }
            }
        }

        protected void gvCursos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCursos.PageIndex = e.NewPageIndex;
            CargarCursos();
        }

        protected void gvCursos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Editar")
            {
                int cursoId = Convert.ToInt32(e.CommandArgument);
                CargarCursoEnFormulario(cursoId);
                MostrarModalCurso();
            }
            else if (e.CommandName == "Eliminar")
            {
                int cursoId = Convert.ToInt32(e.CommandArgument);
                EliminarCurso(cursoId);
                CargarCursos();
            }
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            string filtro = txtBuscar.Text.Trim();
            ViewState["FiltroNombre"] = filtro;
            gvCursos.PageIndex = 0;
            CargarCursos();
        }

        protected void btnLimpiarBusqueda_Click(object sender, EventArgs e)
        {
            txtBuscar.Text = string.Empty;
            ViewState["FiltroNombre"] = string.Empty;
            gvCursos.PageIndex = 0;
            CargarCursos();
        }

        private void CargarCursoEnFormulario(int cursoId)
        {
            using (var conn = new MySqlConnection(cs))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = @"
                    SELECT curso_id, nombre, fecha_inicio, duracion_horas, modalidad, imagen_url
                    FROM curso
                    WHERE curso_id = @Id;";
                cmd.Parameters.AddWithValue("@Id", cursoId);

                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        hdnCursoId.Value = reader.GetInt32("curso_id").ToString();
                        txtNombreCurso.Text = reader.GetString("nombre");

                        if (!reader.IsDBNull(reader.GetOrdinal("fecha_inicio")))
                        {
                            DateTime fecha = reader.GetDateTime("fecha_inicio");
                            txtFechaInicio.Text = fecha.ToString("yyyy-MM-dd");
                        }
                        else
                        {
                            txtFechaInicio.Text = string.Empty;
                        }

                        if (!reader.IsDBNull(reader.GetOrdinal("duracion_horas")))
                        {
                            txtDuracionHoras.Text = reader.GetInt32("duracion_horas").ToString();
                        }
                        else
                        {
                            txtDuracionHoras.Text = string.Empty;
                        }

                        string modalidad = reader.IsDBNull(reader.GetOrdinal("modalidad"))
                            ? "Online"
                            : reader.GetString("modalidad");

                        if (ddlModalidad.Items.FindByValue(modalidad) != null)
                            ddlModalidad.SelectedValue = modalidad;
                        else
                            ddlModalidad.SelectedValue = "Online";

                        string imagenUrl = reader.IsDBNull(reader.GetOrdinal("imagen_url"))
                            ? string.Empty
                            : reader.GetString("imagen_url");

                        ViewState["ImagenActual"] = imagenUrl;

                        if (!string.IsNullOrEmpty(imagenUrl))
                        {
                            string urlCompleta = ResolveUrl("~/" + imagenUrl.TrimStart('/'));
                            litImagenActual.Text = $"<div class='mt-2 form-text'>Imagen actual: <a href='{urlCompleta}' target='_blank'>ver imagen</a></div>";
                        }
                        else
                        {
                            litImagenActual.Text = string.Empty;
                        }

                        btnCrearCurso.Text = "Actualizar curso";
                        lblFormularioTitulo.InnerText = "Editar curso";
                    }
                }
            }
        }

        #endregion

        #region Crear / actualizar curso

        protected void btnCrearCurso_Click(object sender, EventArgs e)
        {
            string nombreCurso = txtNombreCurso.Text.Trim();
            if (string.IsNullOrWhiteSpace(nombreCurso))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errNombreCurso",
                    "Swal.fire('Error', 'El nombre del curso es obligatorio.', 'error');",
                    true
                );
                MostrarModalCurso();
                return;
            }

            DateTime? fechaInicio = null;
            if (DateTime.TryParse(txtFechaInicio.Text, out DateTime fechaParsed))
                fechaInicio = fechaParsed;

            int? duracionHoras = null;
            if (int.TryParse(txtDuracionHoras.Text, out int duracionParsed))
                duracionHoras = duracionParsed;

            string modalidad = ddlModalidad.SelectedValue ?? "Online";

            int cursoId;
            bool esEdicion = int.TryParse(hdnCursoId.Value, out cursoId) && cursoId > 0;

            string imagenActual = ViewState["ImagenActual"] as string ?? string.Empty;
            string nuevaRutaImagenBD = imagenActual;
            string nuevaRutaFisica = null;

            try
            {
                // Manejo de imagen (obligatoria solo al crear)
                if (!esEdicion || fuImagen.HasFile)
                {
                    if (!fuImagen.HasFile)
                    {
                        ScriptManager.RegisterStartupScript(
                            this, GetType(), "errImgRequerida",
                            "Swal.fire('Error', 'Debes subir una imagen para el curso.', 'error');",
                            true
                        );
                        MostrarModalCurso();
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
                        MostrarModalCurso();
                        return;
                    }

                    string nombreUnico = "curso_" + Guid.NewGuid().ToString("N") + ext;
                    nuevaRutaFisica = Server.MapPath("~/images/" + nombreUnico);
                    fuImagen.SaveAs(nuevaRutaFisica);
                    nuevaRutaImagenBD = "images/" + nombreUnico;
                }

                using (var conn = new MySqlConnection(cs))
                using (var cmd = conn.CreateCommand())
                {
                    conn.Open();

                    if (esEdicion)
                    {
                        cmd.CommandText = @"
                            UPDATE curso
                            SET nombre = @Nombre,
                                fecha_inicio = @FechaInicio,
                                duracion_horas = @DuracionHoras,
                                modalidad = @Modalidad,
                                imagen_url = @Imagen
                            WHERE curso_id = @Id;";

                        cmd.Parameters.AddWithValue("@Id", cursoId);
                        cmd.Parameters.AddWithValue("@Nombre", nombreCurso);
                        cmd.Parameters.AddWithValue("@FechaInicio", (object)fechaInicio ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@DuracionHoras", (object)duracionHoras ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Modalidad", modalidad);
                        cmd.Parameters.AddWithValue("@Imagen", nuevaRutaImagenBD);

                        cmd.ExecuteNonQuery();

                        if (!string.IsNullOrEmpty(imagenActual) && nuevaRutaImagenBD != imagenActual)
                        {
                            string rutaFisicaAnterior = Server.MapPath("~/" + imagenActual.TrimStart('/'));
                            try
                            {
                                if (File.Exists(rutaFisicaAnterior))
                                    File.Delete(rutaFisicaAnterior);
                            }
                            catch { }
                        }

                        ScriptManager.RegisterStartupScript(
                            this, GetType(), "okCursoActualizado",
                            "Swal.fire('Actualizado', 'El curso se actualizó correctamente.', 'success');",
                            true
                        );
                    }
                    else
                    {
                        cmd.CommandText = @"
                            INSERT INTO curso (nombre, fecha_inicio, duracion_horas, modalidad, imagen_url)
                            VALUES (@Nombre, @FechaInicio, @DuracionHoras, @Modalidad, @Imagen);
                            SELECT LAST_INSERT_ID();";

                        cmd.Parameters.AddWithValue("@Nombre", nombreCurso);
                        cmd.Parameters.AddWithValue("@FechaInicio", (object)fechaInicio ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@DuracionHoras", (object)duracionHoras ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Modalidad", modalidad);
                        cmd.Parameters.AddWithValue("@Imagen", nuevaRutaImagenBD);

                        int nuevoCursoId = Convert.ToInt32(cmd.ExecuteScalar());

                        NotificarNuevoCursoATodos(nuevoCursoId, nombreCurso);

                        ScriptManager.RegisterStartupScript(
                            this, GetType(), "okCursoCreado",
                            "Swal.fire('Éxito', 'El curso se creó correctamente.', 'success');",
                            true
                        );
                    }
                }

                InicializarFormulario();
                CargarCursos();
                OcultarModalCurso();
            }
            catch (Exception)
            {
                try
                {
                    if (!string.IsNullOrEmpty(nuevaRutaFisica) && File.Exists(nuevaRutaFisica))
                        File.Delete(nuevaRutaFisica);
                }
                catch { }

                ScriptManager.RegisterStartupScript(
    this, GetType(), "errGuardarCurso",
    "Swal.fire('Error', 'Ocurrió un problema al guardar el curso. Intenta nuevamente.', 'error');",
    true
);
                MostrarModalCurso();
            }
        }

        #endregion

        #region Eliminación de curso

        private void EliminarCurso(int cursoId)
        {
            string imagenUrl = null;

            using (var conn = new MySqlConnection(cs))
            using (var cmd = conn.CreateCommand())
            {
                conn.Open();
                using (var tx = conn.BeginTransaction())
                {
                    cmd.Transaction = tx;

                    try
                    {
                        cmd.CommandText = "SELECT COUNT(*) FROM pregunta WHERE curso_id = @Id;";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@Id", cursoId);

                        long cantPreguntas = Convert.ToInt64(cmd.ExecuteScalar() ?? 0);

                        if (cantPreguntas > 0)
                        {
                            tx.Rollback();
                            ScriptManager.RegisterStartupScript(
                                this, GetType(), "warnNoEliminar",
                                "Swal.fire('No permitido', 'No se puede eliminar el curso porque tiene evaluaciones asociadas. Primero elimina o reasigna esas evaluaciones.', 'warning');",
                                true
                            );
                            return;
                        }

                        cmd.CommandText = "SELECT imagen_url FROM curso WHERE curso_id = @Id;";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@Id", cursoId);

                        object imgObj = cmd.ExecuteScalar();
                        if (imgObj != null && imgObj != DBNull.Value)
                            imagenUrl = imgObj.ToString();

                        cmd.CommandText = "DELETE FROM curso WHERE curso_id = @Id;";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@Id", cursoId);

                        cmd.ExecuteNonQuery();

                        tx.Commit();

                        if (!string.IsNullOrEmpty(imagenUrl))
                        {
                            string rutaFisica = Server.MapPath("~/" + imagenUrl.TrimStart('/'));
                            try
                            {
                                if (File.Exists(rutaFisica))
                                    File.Delete(rutaFisica);
                            }
                            catch { }
                        }

                        ScriptManager.RegisterStartupScript(
                            this, GetType(), "okCursoEliminado",
                            "Swal.fire('Eliminado', 'El curso se eliminó correctamente.', 'success');",
                            true
                        );
                    }
                    catch
                    {
                        tx.Rollback();
                        ScriptManager.RegisterStartupScript(
    this, GetType(), "errEliminarCurso",
    "Swal.fire('Error', 'No se pudo eliminar el curso. Es posible que existan otros datos relacionados.', 'error');",
    true
);
                    }
                }
            }
        }

        #endregion

        #region Notificación por correo

        private void NotificarNuevoCursoATodos(int cursoId, string nombreCurso)
        {
            var emails = new List<string>();

            using (var conn = new MySqlConnection(cs))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = @"
                    SELECT email
                    FROM boletin_suscripcion
                    WHERE activo = 1;";

                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string email = reader.GetString("email");
                        if (!string.IsNullOrWhiteSpace(email))
                            emails.Add(email);
                    }
                }
            }

            foreach (var email in emails)
            {
                try
                {
                    EnviarCorreoNuevoCurso(email, nombreCurso, cursoId);
                }
                catch
                {
                    // log opcional
                }
            }
        }

        private void EnviarCorreoNuevoCurso(string destinatario, string nombreCurso, int cursoId)
        {
            string baseUrl = Request.Url.GetLeftPart(UriPartial.Authority);
            string urlCursos = ResolveUrl("~/Cursos.aspx");
            string urlCurso = baseUrl + urlCursos;

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
                </p>";

            var mensaje = new MailMessage
            {
                From = new MailAddress(
                    ConfigurationManager.AppSettings["SmtpFromEmail"],
                    ConfigurationManager.AppSettings["SmtpFromName"]
                ),
                Subject = asunto,
                Body = cuerpoHtml,
                IsBodyHtml = true
            };

            mensaje.To.Add(destinatario);

            var smtp = new SmtpClient
            {
                Host = ConfigurationManager.AppSettings["SmtpHost"],
                Port = int.Parse(ConfigurationManager.AppSettings["SmtpPort"]),
                EnableSsl = true,
                Credentials = new System.Net.NetworkCredential(
                    ConfigurationManager.AppSettings["SmtpUser"],
                    ConfigurationManager.AppSettings["SmtpPassword"]
                )
            };

            smtp.Send(mensaje);
        }

        #endregion
    }
}
