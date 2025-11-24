using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace bluesky
{
    public partial class HerramientasOrganizacion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                string returnUrl = Server.UrlEncode(Request.RawUrl);
                Response.Redirect("~/IniciarSesion.aspx?ReturnUrl=" + returnUrl);
                return;
            }

            var master = this.Master as bluesky.SiteMaster;
            if (master != null)
            {
                master.UsarMenuBasico = true;
            }
        }


        protected void btnIniciar_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/StartCursos/HerramientasDeOrganizacion.aspx");
        }

        protected void btnPrograma_Click(object sender, EventArgs e)
        {
            // Ruta física del PDF dentro de la carpeta "docs"
            string filePath = Server.MapPath("~/docs/programa-organizacion-efectiva.pdf");

            if (System.IO.File.Exists(filePath))
            {
                // Limpiar la respuesta
                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("Content-Disposition", "attachment; filename=programa-organizacion-efectiva.pdf");
                Response.TransmitFile(filePath);
                Response.End();
            }
            else
            {
                // Manejo si el archivo no existe
                Response.Write("<script>alert('El archivo no se encontró.');</script>");
            }
        }
    }
}