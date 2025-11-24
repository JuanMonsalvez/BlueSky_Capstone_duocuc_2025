using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace bluesky
{
    public partial class VerificacionCodigo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Si no hay 2FA pendiente, vuelve al login
                if (Session["2FA_Pending_Rut"] == null ||
                    Session["2FA_Code"] == null ||
                    Session["2FA_Expires"] == null)
                {
                    Response.Redirect("~/IniciarSesion.aspx");
                }
            }
        }

        protected void btnConfirmar_Click(object sender, EventArgs e)
        {
            if (Session["2FA_Pending_Rut"] == null ||
                Session["2FA_Code"] == null ||
                Session["2FA_Expires"] == null)
            {
                lblError.Text = "La sesión de verificación ha expirado. Vuelve a iniciar sesión.";
                return;
            }

            string codeIngresado = txtCodigo.Text.Trim();
            string codeCorrecto = Session["2FA_Code"].ToString();
            DateTime expires = (DateTime)Session["2FA_Expires"];

            if (DateTime.Now > expires)
            {
                LimpiarSesion2FA();
                lblError.Text = "El código ha expirado. Vuelve a iniciar sesión.";
                return;
            }

            if (codeIngresado != codeCorrecto)
            {
                lblError.Text = "El código ingresado no es correcto.";
                return;
            }

            // Recuperar datos temporales para armar la sesión "real"
            string rut = Session["2FA_Pending_Rut"].ToString();
            string nombre = Session["2FA_Pending_Nombre"].ToString();
            int rol = (int)Session["2FA_Pending_Rol"];

            // === Sesión final (igual que tu login original) ===
            Session["USUARIO_ID"] = rut;
            Session["PersRut"] = rut;
            Session["Username"] = nombre;
            Session["Rol"] = rol;
            Session["TEST"] = "OK_SESSION";

            LimpiarSesion2FA();

            Response.Redirect("~/Default.aspx");
        }

        private void LimpiarSesion2FA()
        {
            Session.Remove("2FA_Pending_Rut");
            Session.Remove("2FA_Pending_Nombre");
            Session.Remove("2FA_Pending_Rol");
            Session.Remove("2FA_Pending_Email");
            Session.Remove("2FA_Code");
            Session.Remove("2FA_Expires");
        }
    }
}
