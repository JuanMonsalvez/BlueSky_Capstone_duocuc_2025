using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Web.UI;

namespace bluesky
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Mantiene compatibilidad con cualquier página que use PersRut
                var userId = Session["USUARIO_ID"] as string;
                if (userId != null && Session["PersRut"] == null)
                    Session["PersRut"] = userId;

                CargarResenas();
            }
        }

        private readonly string constr = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;


        private void CargarResenas()
        {
            List<dynamic> lista = new List<dynamic>();

            string query = @"
        SELECT 
            r.resena_id,
            r.persrut,
            CONCAT(u.persnombre, ' ', LEFT(u.perspatern, 1), '.') AS nombre_publico,
            r.texto,
            r.puntaje,
            r.fecha,
            u.perssexo
        FROM resena r
        JOIN usuario u ON u.persrut = r.persrut
        ORDER BY r.fecha DESC
        LIMIT 3;";

            using (var cn = new MySqlConnection(constr))
            using (var cmd = new MySqlCommand(query, cn))
            {
                cn.Open();

                using (var rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        lista.Add(new
                        {
                            resena_id = rd.GetInt32("resena_id"),
                            persrut = rd.GetString("persrut"),
                            nombre_publico = rd.GetString("nombre_publico"),
                            texto = rd.GetString("texto"),
                            puntaje = rd.GetInt32("puntaje"),
                            fecha = rd.GetDateTime("fecha"),
                            perssexo = rd.GetString("perssexo")
                        });
                    }
                }
            }

            rptResenas.DataSource = lista;
            rptResenas.DataBind();
        }


        protected string GetAvatar(object sexoObj)
        {
            string sexo = (sexoObj ?? "").ToString().Trim().ToUpperInvariant();

            if (sexo == "F")
                return ResolveUrl("~/images/resenas/avatarFemenino.png");

            if (sexo == "M")
                return ResolveUrl("~/images/resenas/avatarMasculino.jfif");

            return ""; // Si no es M o F, no retorna avatar
        }

        private bool UsuarioTieneIntento(string persrut)
        {
            string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

            using (var cn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand(
                "SELECT 1 FROM intento_evaluacion WHERE persrut = @rut LIMIT 1", cn))
            {
                cmd.Parameters.AddWithValue("@rut", persrut);
                cn.Open();
                var res = cmd.ExecuteScalar();
                return res != null;
            }
        }
        protected void btnExplorarCursos_Click(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                string script = @"
            Swal.fire({
                title: 'Inicia sesión',
                text: 'Debes iniciar sesión para acceder a los cursos.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Iniciar sesión',
                cancelButtonText: 'Cancelar'
            }).then(function(result) {
                if (result.isConfirmed) {
                    window.location.href = 'IniciarSesion.aspx';
                }
            });
        ";

                ScriptManager.RegisterStartupScript(
                    this,
                    GetType(),
                    "loginRequired",
                    script,
                    true
                );

                return;
            }

            Response.Redirect("~/Cursos.aspx");
        }





        protected void btnPublicarResena_Click(object sender, EventArgs e)
        {
            // 1️⃣ Validar sesión
            string rut = Session["USUARIO_ID"] as string;
            if (string.IsNullOrEmpty(rut))
                rut = Session["PersRut"] as string;

            if (string.IsNullOrEmpty(rut))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "noSesion",
                    "Swal.fire({ icon:'warning', title:'Inicia sesión', text:'Debes iniciar sesión para publicar una reseña.' });",
                    true
                );
                return;
            }

            // 2️⃣ Validar que tenga al menos un intento en algún curso
            if (!UsuarioTieneIntento(rut))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "sinIntentos",
                    "Swal.fire({ icon:'info', title:'Sin intentos', text:'Debes tener al menos un intento en un curso antes de publicar una reseña.' });",
                    true
                );
                return;
            }

            // 3️⃣ Tomar campos del formulario (ya SIN nombre público)
            string texto = (txtTextoResena.Text ?? string.Empty).Trim();
            string puntajeStr = ddlPuntaje.SelectedValue;

            // 4️⃣ VALIDACIONES (reabriendo modal en cada error)

            // Calificación no seleccionada
            if (string.IsNullOrEmpty(puntajeStr))
            {
                ReabrirModalResena("Falta la calificación", "Selecciona una calificación para tu reseña.");
                return;
            }

            // Texto reseña vacío
            if (string.IsNullOrWhiteSpace(texto))
            {
                ReabrirModalResena("Falta tu reseña", "Escribe un breve comentario sobre tu experiencia.");
                return;
            }

            const int MAX_LEN = 100;
            if (texto.Length > MAX_LEN)
            {
                ReabrirModalResena("Texto demasiado largo", "La reseña no puede superar los 100 caracteres.");
                return;
            }

            if (!int.TryParse(puntajeStr, out int puntaje) || puntaje < 1 || puntaje > 5)
            {
                ReabrirModalResena("Puntaje inválido", "La calificación seleccionada no es válida.");
                return;
            }

            // 5️⃣ Insertar reseña (ya SIN nombre_publico en la tabla)
            string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

            using (var cn = new MySqlConnection(cs))
            using (var cmd = new MySqlCommand(
                @"INSERT INTO resena (persrut, texto, puntaje) 
          VALUES (@rut, @texto, @puntaje);", cn))
            {
                cmd.Parameters.AddWithValue("@rut", rut);
                cmd.Parameters.AddWithValue("@texto", texto);
                cmd.Parameters.AddWithValue("@puntaje", puntaje);

                cn.Open();
                cmd.ExecuteNonQuery();
            }

            // Limpiar campos
            txtTextoResena.Text = string.Empty;
            ddlPuntaje.ClearSelection();

            // 6️⃣ Mensaje de éxito
            ScriptManager.RegisterStartupScript(
                this, GetType(), "okResena",
                "Swal.fire({ icon:'success', title:'¡Gracias!', text:'¡Gracias por tu reseña!' });",
                true
            );

            CargarResenas();
        }



        protected string RenderStars(object value)
        {
            int n = Convert.ToInt32(value);
            string s = "";

            for (int i = 0; i < n; i++) s += "<i class='fa fa-star'></i>";
            for (int i = n; i < 5; i++) s += "<i class='fa fa-star-o'></i>";

            return s;
        }

        private void ReabrirModalResena(string titulo, string texto)
        {
            ScriptManager.RegisterStartupScript(
                this, GetType(), "reopenModalResena",
                "Swal.fire({ icon:'warning', title: '" + titulo + "', text: '" + texto + @"' })
          .then(function(){ 
              var el = document.getElementById('modalResena'); 
              if (el) { 
                  var m = bootstrap.Modal.getOrCreateInstance(el); 
                  m.show(); 
              } 
          });",
                true
            );
        }

        protected void btnContact_Click(object sender, EventArgs e)
        {
            string rut = (txtRut.Text ?? "").Trim();
            string problema = (txtMotivo.Text ?? "").Trim();

            // 1️⃣ VALIDAR RUT VACÍO
            if (string.IsNullOrWhiteSpace(rut))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "rutVacio",
                    "Swal.fire({ icon:'warning', title:'Completa el RUT', text:'Por favor ingresa tu RUT.' });",
                    true
                );
                return;
            }

            // 2️⃣ VALIDAR FORMATO RUT (SOLO NÚMEROS)
            if (!System.Text.RegularExpressions.Regex.IsMatch(rut, @"^[0-9]+$"))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "rutInvalido",
                    "Swal.fire({ icon:'warning', title:'RUT inválido', text:'El RUT debe contener solo números, sin guion ni dígito verificador.' });",
                    true
                );
                return;
            }

            // 3️⃣ VALIDAR MOTIVO VACÍO
            if (string.IsNullOrWhiteSpace(problema))
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "motivoVacio",
                    "Swal.fire({ icon:'warning', title:'Completa tu mensaje', text:'Describe brevemente tu consulta o problema.' });",
                    true
                );
                return;
            }

            // 4️⃣ INSERTAR EN BD SOLO RUT + PROBLEMA + ESTADO
            string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

            try
            {
                using (var cn = new MySqlConnection(cs))
                using (var cmd = new MySqlCommand(
                    @"INSERT INTO contacto_soporte (rut, problema, estado)
              VALUES (@rut, @problema, 0);", cn))  // 0 = Pendiente
                {
                    cmd.Parameters.AddWithValue("@rut", rut);
                    cmd.Parameters.AddWithValue("@problema", problema);

                    cn.Open();
                    cmd.ExecuteNonQuery();
                }

                // LIMPIAR CAMPOS
                txtRut.Text = "";
                txtMotivo.Text = "";

                ScriptManager.RegisterStartupScript(
                    this, GetType(), "okContacto",
                    "Swal.fire({ icon:'success', title:'Mensaje enviado', text:'Tu mensaje fue enviado correctamente.' });",
                    true
                );
            }
            catch
            {
                ScriptManager.RegisterStartupScript(
                    this, GetType(), "errContacto",
                    "Swal.fire({ icon:'error', title:'Error', text:'No se pudo enviar tu mensaje. Intenta nuevamente.' });",
                    true
                );
            }
        }

    }
}
