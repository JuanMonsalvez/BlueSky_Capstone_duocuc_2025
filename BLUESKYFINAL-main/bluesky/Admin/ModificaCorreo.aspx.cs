using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace bluesky.Admin
{
    public partial class AdminDashboards : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 🔐 1) Verificar que el usuario esté logueado
            var username = Session["Username"] as string;
            if (string.IsNullOrEmpty(username))
            {
                // No autenticado → ir a iniciar sesión
                Response.Redirect("~/IniciarSesion.aspx");
                return;
            }

            // 🔐 2) Verificar que tenga rol ADMIN (rol_id = 1)
            int rol;
            bool esAdmin = Session["Rol"] != null
                           && int.TryParse(Session["Rol"].ToString(), out rol)
                           && rol == 1;

            if (!esAdmin)
            {
                // Logueado pero sin rol de admin → bloquear acceso a /Admin
                Response.Redirect("~/Default.aspx");
                return;
            }

            // 🎨 3) Mantener comportamiento de tu MasterPage
            var master = this.Master as bluesky.SiteMaster;
            if (master != null)
            {
                master.UsarMenuBasico = true;
                master.OcultarMenus = true;
            }

            // (Opcional) lógica inicial
            // if (!IsPostBack) { ... }
        }

        protected void gvCustomers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCustomers.PageIndex = e.NewPageIndex;
            /* VerDatos(); */
        }


    }
}