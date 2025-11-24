using System;
using System.Web;
using System.Web.UI;

namespace bluesky
{
    public partial class ExcelCurso : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                string returnUrl = Server.UrlEncode(Request.RawUrl);
                Response.Redirect("~/IniciarSesion.aspx?ReturnUrl=" + returnUrl);
                return;
            }

            if (!IsPostBack)
            {
                Master.UsarMenuBasico = true;
            }
        }

        protected void btnIniciar_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/StartCursos/ExcelBasico.aspx");
        }

        protected void btnPrograma_Click(object sender, EventArgs e)
        {
            string filePath = Server.MapPath("~/docs/programa-excel-basico.pdf");

            if (System.IO.File.Exists(filePath))
            {
                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("Content-Disposition", "attachment; filename=programa-excel-basico.pdf");
                Response.TransmitFile(filePath);
                Response.Flush();
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
            else
            {
                ClientScript.RegisterStartupScript(
                    this.GetType(),
                    "NoPdf",
                    "alert('El archivo no se encontró.');",
                    true
                );
            }
        }
    }
}
