using System;
using System.Web.UI;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.Text;

namespace bluesky
{
    public partial class Cursos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["Username"] == null)
            {
                // Guarda la URL que intentó visitar (para volver luego del login)
                string returnUrl = Server.UrlEncode(Request.RawUrl);
                Response.Redirect("~/IniciarSesion.aspx?ReturnUrl=" + returnUrl);
                return;
            }

            var master = this.Master as bluesky.SiteMaster;
            if (master != null)
            {
                master.UsarMenuBasico = true;
            }


            if (!IsPostBack)
            {
                CargarCursosDesdeBD();
            }
        }

        private void CargarCursosDesdeBD()
        {
            string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

            using (var conn = new MySqlConnection(cs))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = @"
            SELECT curso_id,
           nombre,
           fecha_inicio,
           duracion_horas,
           modalidad,
           imagen_url
    FROM curso
    ORDER BY curso_id DESC;
        ";

                conn.Open();

                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                rptCursos.DataSource = dt;
                rptCursos.DataBind();
            }
        }

        private string Normalizar(string texto)
        {
            if (string.IsNullOrWhiteSpace(texto))
                return string.Empty;

            string formD = texto.ToLowerInvariant().Normalize(NormalizationForm.FormD);
            StringBuilder sb = new StringBuilder();
            bool prevSpace = false;

            foreach (char c in formD)
            {
                var uc = CharUnicodeInfo.GetUnicodeCategory(c);
                if (uc == UnicodeCategory.NonSpacingMark)
                    continue; // quita acentos

                if (char.IsWhiteSpace(c))
                {
                    if (prevSpace) continue; // colapsa espacios múltiples
                    sb.Append(' ');
                    prevSpace = true;
                }
                else
                {
                    sb.Append(c);
                    prevSpace = false;
                }
            }

            return sb.ToString().Trim(); // sin espacios al inicio/fin
        }

        public string GetImagenCurso(string nombreCurso)
        {
            if (string.IsNullOrEmpty(nombreCurso))
                return "images/curso-generico.jpeg";

            string n = Normalizar(nombreCurso);

            // Curso de análisis de datos / SQL
            if (n.Contains("sql") || n.Contains("analisis de datos"))
                return "images/sql-introduccion.jpg";

            if (n.Contains("excel intermedio"))
                return "images/excel-intermedio.jpeg";

            if (n.Contains("excel basico") || n.Contains("excel básico"))
                return "images/EXCEL-PORTADA.jpeg";

            if (n.Contains("word"))
                return "images/WORD-PORTADA.jpeg";

            if (n.Contains("educacion financiera"))
                return "images/educacion-financiera.jpeg";

            if (n.Contains("ciberseguridad"))
                return "images/ciberseguridad.jpeg";

            if (n.Contains("gestion de proyectos"))
                return "images/gestion de proyectos.jpeg";

            if (n.Contains("ms office") || n.Contains("office"))
                return "images/MS-OFICCE.jpeg";

            if (n.Contains("organizacion efectiva del trabajo") || n.Contains("organizacion efectiva"))
                return "images/HERRAMIENTAS EFECTIVAS DEL TRABAJO.jpeg";

            if (n.Contains("marketing digital"))
                return "images/MARKETING DIGITAL.jpeg";

            if (n.Contains("gestion de procesos en la organizacion"))
                return "images/GESTION PROCESOS ORGANIZACION.jpeg";

            if (n.Contains("powerpoint intermedio") || n.Contains("powerpoint"))
                return "images/powerpoint.jpeg";

            // Imagen por defecto
            return "images/curso-generico.jpeg";
        }

        public string GetUrlDetalleCurso(string nombreCurso)
        {
            if (string.IsNullOrEmpty(nombreCurso))
                return "#";

            string n = Normalizar(nombreCurso).Trim();   // minúsculas, sin acentos, sin espacios extra

            // Excel Básico
            if (n == "excel basico" || n.Contains("excel basico"))
                return ResolveUrl("~/ExcelCurso.aspx");

            // Word Básico
            if (n == "word basico" || n.Contains("word basico"))
                return ResolveUrl("~/CursoWordBasico.aspx");

            // Educación Financiera
            if (n == "educacion financiera" || n.Contains("educacion financiera"))
                return ResolveUrl("~/EducacionFinanciera.aspx");

            // Ciberseguridad Básica
            if (n == "ciberseguridad basica" || n.Contains("ciberseguridad basica"))
                return ResolveUrl("~/Ciberseguridad.aspx");

            // Gestión de Proyectos - Herramientas Clave
            if (n == "gestion de proyectos - herramientas clave"
                || (n.Contains("gestion de proyectos") && n.Contains("herramientas clave")))
                return ResolveUrl("~/GestionProyectos.aspx");

            // Herramientas Básicas de MS Office
            if (n == "herramientas basicas de ms office"
                || (n.Contains("ms office") && n.Contains("herramientas basicas")))
                return ResolveUrl("~/HerramientasMsOficce.aspx");

            // Herramientas para Organización Efectiva del Trabajo
            if (n == "herramientas para organizacion efectiva del trabajo"
                || n.Contains("organizacion efectiva del trabajo"))
                return ResolveUrl("~/HerramientasOrganizacion.aspx");

            // Marketing Digital
            if (n == "marketing digital" || n.Contains("marketing digital"))
                return ResolveUrl("~/MarketingDigital.aspx");

            // Herramientas para la gestión de procesos en la organizacion avanzada
            if (n == "herramientas para la gestion de procesos en la organizacion avanzada"
                || (n.Contains("gestion de procesos en la organizacion avanzada")))
                return ResolveUrl("~/HerramientasGestionProcesos.aspx");

            // Herramientas de Excel Intermedio
            if (n == "herramientas de excel intermedio" || n.Contains("excel intermedio"))
                return ResolveUrl("~/CursoExcelIntermedio.aspx");

            // PowerPoint Intermedio
            if (n == "powerpoint intermedio" || n.Contains("powerpoint intermedio"))
                return ResolveUrl("~/PowerPointIntermedio.aspx");

            // Análisis de Datos Nivel Intermedio  -> asumo que es tu curso de SQL/análisis de datos
            if (n == "analisis de datos nivel intermedio" || n.Contains("analisis de datos nivel intermedio"))
                return ResolveUrl("~/IntroduccionSQL.aspx");

            // CLASES DE FIFA (aún sin página)
            if (n == "clases de fifa" || n.Contains("clases de fifa"))
                return "#"; // o la página que crees después, por ejemplo "~/ClasesFifa.aspx"

            // Si no matchea nada, no hay página de detalle
            return "#";
        }
    }
}
