using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace bluesky.prueba
{
    public partial class certificado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Mantener comportamiento de tu MasterPage
            var master = this.Master as bluesky.SiteMaster;
            if (master != null)
            {
                master.UsarMenuBasico = true;
                master.OcultarMenus = true;
            }
        }

        protected void btnCrearCertificado_Click(object sender, EventArgs e)
        {

        }
    }
}