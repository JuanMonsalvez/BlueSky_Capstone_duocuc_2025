using System;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;
using MySql.Data.MySqlClient;

namespace bluesky.Admin
{
    public partial class Reportes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var username = Session["Username"] as string;
            if (string.IsNullOrEmpty(username))
            {
                // No autenticado → enviar a iniciar sesión
                Response.Redirect("~/IniciarSesion.aspx");
                return;
            }

            int rol;
            bool esAdmin = Session["Rol"] != null
                           && int.TryParse(Session["Rol"].ToString(), out rol)
                           && rol == 1;

            if (!esAdmin)
            {
                // Logueado pero sin rol de administrador → prohibir acceso
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
                CargarEstadisticasDashboard();
            }
        }

        private void CargarEstadisticasDashboard()
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["MySqlConn"].ConnectionString;

                using (var cn = new MySqlConnection(cs))
                {
                    cn.Open();

                    int totalAlumnos = 0;
                    int totalCursos = 0;
                    int totalIntentos = 0;
                    decimal promedioGlobal = 0m;
                    decimal tasaAprobacion = 0m;

                    // ---------- 1) Total alumnos ----------
                    using (var cmdAlumnos = new MySqlCommand(
                        "SELECT COUNT(*) FROM usuario;", cn))
                    {
                        totalAlumnos = Convert.ToInt32(cmdAlumnos.ExecuteScalar());
                        ltTotalAlumnos.Text = totalAlumnos.ToString();
                    }

                    // ---------- 2) Total cursos ----------
                    using (var cmdCursos = new MySqlCommand(
                        "SELECT COUNT(*) FROM curso;", cn))
                    {
                        totalCursos = Convert.ToInt32(cmdCursos.ExecuteScalar());
                        ltTotalCursos.Text = totalCursos.ToString();
                    }

                    // ---------- 3) Intentos + promedio + tasa aprobación ----------
                    using (var cmdIntentos = new MySqlCommand(@"
                SELECT 
                    COUNT(*) AS total_intentos,
                    ROUND(AVG(puntaje), 2) AS promedio_global,
                    ROUND(
                        AVG(
                            CASE 
                                WHEN puntaje >= 60 THEN 1 
                                ELSE 0 
                            END
                        ) * 100, 1
                    ) AS tasa_aprobacion
                FROM intento_evaluacion;
            ", cn))
                    using (var dr = cmdIntentos.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            totalIntentos = dr["total_intentos"] != DBNull.Value
                                ? Convert.ToInt32(dr["total_intentos"])
                                : 0;

                            promedioGlobal = dr["promedio_global"] != DBNull.Value
                                ? Convert.ToDecimal(dr["promedio_global"])
                                : 0m;

                            tasaAprobacion = dr["tasa_aprobacion"] != DBNull.Value
                                ? Convert.ToDecimal(dr["tasa_aprobacion"])
                                : 0m;
                        }
                    }

                    ltTotalIntentos.Text = totalIntentos.ToString();
                    ltTotalIntentosKpi.Text = totalIntentos.ToString();
                    ltPromedioGlobal.Text = promedioGlobal.ToString("N1") + " %";
                    ltTasaAprobacion.Text = tasaAprobacion.ToString("N1") + " %";

                    // ---------- 4) Intentos por alumno ----------
                    decimal intentosPorAlumno = (totalAlumnos > 0)
                        ? (decimal)totalIntentos / totalAlumnos
                        : 0m;
                    ltIntentosPorAlumno.Text = intentosPorAlumno.ToString("N1");

                    // Si no hay intentos, no armamos gráficos
                    if (totalIntentos == 0)
                    {
                        rptTopCursos.DataSource = null;
                        rptTopCursos.DataBind();
                        return;
                    }

                    var scriptBuilder = new StringBuilder();

                    // ---------- 5) Top cursos (para gráfico y lista) ----------
                    DataTable dtTopCursos = new DataTable();
                    using (var cmdTop = new MySqlCommand(@"
                SELECT 
                    c.nombre,
                    COUNT(i.intento_id) AS total_intentos,
                    ROUND(AVG(i.puntaje), 2) AS puntaje_promedio,
                    COUNT(DISTINCT i.persrut) AS alumnos_realizaron,
                    ROUND(COUNT(i.intento_id) * 100.0 / @totalIntentos, 1) AS porcentaje_intentos
                FROM curso c
                JOIN intento_evaluacion i ON c.curso_id = i.curso_id
                GROUP BY c.curso_id, c.nombre
                ORDER BY total_intentos DESC
                LIMIT 6;
            ", cn))
                    {
                        cmdTop.Parameters.AddWithValue("@totalIntentos", totalIntentos);

                        using (var drTop = cmdTop.ExecuteReader())
                        {
                            dtTopCursos.Load(drTop);
                        }
                    }

                    rptTopCursos.DataSource = dtTopCursos;
                    rptTopCursos.DataBind();

                    if (dtTopCursos.Rows.Count > 0)
                    {
                        var labels = string.Join(",",
                            dtTopCursos.AsEnumerable().Select(r =>
                                "'" + r["nombre"].ToString().Replace("'", "\\'") + "'"));

                        var dataIntentos = string.Join(",",
                            dtTopCursos.AsEnumerable().Select(r => r["total_intentos"].ToString()));

                        scriptBuilder.AppendLine($@"
                    window.topCursosLabels = [{labels}];
                    window.topCursosIntentos = [{dataIntentos}];
                ");
                    }

                    // ---------- 6) Intentos por día ----------
                    DataTable dtIntentosDia = new DataTable();
                    using (var cmdDia = new MySqlCommand(@"
                SELECT 
                    DATE(fecha) AS dia,
                    COUNT(*)    AS total
                FROM intento_evaluacion
                GROUP BY DATE(fecha)
                ORDER BY DATE(fecha) ASC
                LIMIT 15;
            ", cn))
                    using (var drDia = cmdDia.ExecuteReader())
                    {
                        dtIntentosDia.Load(drDia);
                    }

                    if (dtIntentosDia.Rows.Count > 0)
                    {
                        var labelsDias = string.Join(",",
                            dtIntentosDia.AsEnumerable().Select(r =>
                                "'" + ((DateTime)r["dia"]).ToString("dd-MM") + "'"));

                        var dataDias = string.Join(",",
                            dtIntentosDia.AsEnumerable().Select(r => r["total"].ToString()));

                        scriptBuilder.AppendLine($@"
                    window.intentosDiasLabels = [{labelsDias}];
                    window.intentosDiasData = [{dataDias}];
                ");
                    }

                    // ---------- 7) Distribución de puntajes ----------
                    DataTable dtDistribucion = new DataTable();
                    using (var cmdDistrib = new MySqlCommand(@"
                SELECT 
                    CASE 
                        WHEN puntaje < 50 THEN '0 - 49'
                        WHEN puntaje < 70 THEN '50 - 69'
                        WHEN puntaje < 85 THEN '70 - 84'
                        ELSE '85 - 100'
                    END AS tramo,
                    COUNT(*) AS total
                FROM intento_evaluacion
                GROUP BY tramo
                ORDER BY MIN(puntaje);
            ", cn))
                    using (var drDist = cmdDistrib.ExecuteReader())
                    {
                        dtDistribucion.Load(drDist);
                    }

                    if (dtDistribucion.Rows.Count > 0)
                    {
                        var labelsTramos = string.Join(",",
                            dtDistribucion.AsEnumerable().Select(r =>
                                "'" + r["tramo"].ToString().Replace("'", "\\'") + "'"));

                        var dataTramos = string.Join(",",
                            dtDistribucion.AsEnumerable().Select(r => r["total"].ToString()));

                        scriptBuilder.AppendLine($@"
                    window.tramosLabels = [{labelsTramos}];
                    window.tramosData = [{dataTramos}];
                ");
                    }

                    // ---------- 8) Script para crear los gráficos ----------
                    scriptBuilder.AppendLine(@"
                window.addEventListener('load', function () {
                    try {
                        // Top cursos
                        var ctx1 = document.getElementById('chartTopCursos');
                        if (ctx1 && window.topCursosLabels && window.topCursosIntentos) {
                            new Chart(ctx1, {
                                type: 'bar',
                                data: {
                                    labels: window.topCursosLabels,
                                    datasets: [{
                                        label: 'Intentos',
                                        data: window.topCursosIntentos,
                                        borderWidth: 1
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: {
                                        legend: { display: false },
                                        tooltip: {
                                            callbacks: {
                                                label: function (ctx) {
                                                    var v = ctx.parsed.y || 0;
                                                    return ' ' + v + ' intento(s)';
                                                }
                                            }
                                        }
                                    },
                                    scales: {
                                        x: { ticks: { font: { size: 11 } } },
                                        y: {
                                            beginAtZero: true,
                                            ticks: { precision: 0 }
                                        }
                                    }
                                }
                            });
                        }

                        // Intentos por día
                        var ctx2 = document.getElementById('chartIntentosDia');
                        if (ctx2 && window.intentosDiasLabels && window.intentosDiasData) {
                            new Chart(ctx2, {
                                type: 'line',
                                data: {
                                    labels: window.intentosDiasLabels,
                                    datasets: [{
                                        label: 'Intentos',
                                        data: window.intentosDiasData,
                                        tension: 0.3,
                                        pointRadius: 3,
                                        borderWidth: 2,
                                        fill: false
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: { legend: { display: false } },
                                    scales: {
                                        x: { ticks: { font: { size: 11 } } },
                                        y: {
                                            beginAtZero: true,
                                            ticks: { precision: 0 }
                                        }
                                    }
                                }
                            });
                        }

                        // Distribución de puntajes
                        var ctx3 = document.getElementById('chartDistribucion');
                        if (ctx3 && window.tramosLabels && window.tramosData) {
                            new Chart(ctx3, {
                                type: 'doughnut',
                                data: {
                                    labels: window.tramosLabels,
                                    datasets: [{
                                        data: window.tramosData
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: {
                                        legend: { position: 'bottom' }
                                    }
                                }
                            });
                        }
                    } catch (e) {
                        if (window.console) console.error(e);
                    }
                });
            ");

                    // ---------- 9) Registrar script ----------
                    if (scriptBuilder.Length > 0)
                    {
                        ClientScript.RegisterStartupScript(
                            this.GetType(),
                            "dashboardData",
                            scriptBuilder.ToString(),
                            true
                        );
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex);
            }
        }
    }
}
