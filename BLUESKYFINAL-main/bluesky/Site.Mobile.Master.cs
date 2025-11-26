using System;
using System.Web;
using System.Web.UI;

namespace bluesky
{
    public partial class Site_Mobile : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Siempre evaluamos sesión para pintar el menú correctamente
            ConfigurarNavbarPorSesion();
        }

        private void ConfigurarNavbarPorSesion()
        {
            // ======================
            // 1) Usuario logueado
            // ======================
            var username = Session["Username"] as string;
            bool logged = !string.IsNullOrEmpty(username);

            phLoggedIn.Visible = logged; // Muestra menú usuario
            phLoggedOut.Visible = !logged; // Muestra "Iniciar sesión" si no está logueado

            litUserName.Text = logged ? HttpUtility.HtmlEncode(username) : string.Empty;


            // =======================================================
            // 2) Administrador (rol_id = 1) → muestra dropdown ADMIN
            // =======================================================
            int rolValue = 0;
            bool esAdmin = Session["Rol"] != null
                           && int.TryParse(Session["Rol"].ToString(), out rolValue)
                           && rolValue == 1;

            // Mostrar bloque `<asp:PlaceHolder ID="phAdminMenu">`
            phAdminMenu.Visible = esAdmin;
        }


        // =======================================================
        // 🔥 LOGOUT completamente funcional para mobile
        // =======================================================
        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Default.aspx");
        }
    }
}
