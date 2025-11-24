<%@ Page Title="Reportes" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Reportes.aspx.cs"
    Inherits="bluesky.Admin.Reportes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .admin-reportes-page {
            min-height: calc(100vh - 80px);
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding: 24px 0 40px;
            background: radial-gradient(circle at top left, #eef2ff 0, #f8fafc 40%, #ffffff 100%);
        }

        .admin-reportes-container {
            max-width: 1200px;
            width: 100%;
        }

        .dashboard-card {
            border-radius: 18px;
            border: 0;
            background: rgba(255, 255, 255, 0.96);
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.10);
            backdrop-filter: blur(8px);
        }

            .dashboard-card .card-header {
                border-bottom: 0;
                padding: 16px 20px 0;
                background: transparent;
            }

            .dashboard-card .card-body {
                padding: 16px 20px 20px;
            }

        .badge-soft-primary {
            background: rgba(37, 99, 235, 0.08);
            color: #1d4ed8;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 600;
        }

        .stat-label {
            font-size: 0.78rem;
            letter-spacing: .04em;
            text-transform: uppercase;
            color: #64748b;
        }

        .stat-value {
            font-size: 1.4rem;
            font-weight: 700;
            color: #0f172a;
        }

        .text-xxs {
            font-size: 0.7rem;
        }

        .kpi-pill {
            border-radius: 14px;
            padding: 10px 8px;
            background: rgba(248, 250, 252, 0.9);
        }

        .kpi-icon {
            width: 26px;
            height: 26px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            background: rgba(37, 99, 235, 0.08);
            color: #2563eb;
        }

        .mini-card {
            border-radius: 16px;
            background: #f9fafb;
            padding: 14px 16px;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.05);
        }

        .mini-card-title {
            font-size: 0.85rem;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .mini-stat {
            font-size: 1.1rem;
            font-weight: 700;
            color: #0f172a;
        }

        .chart-card {
            border-radius: 16px;
            background: #f9fafb;
            padding: 14px 16px 16px;
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.05);
        }

        .chart-container {
            position: relative;
            height: 220px;
            width: 100%;
        }

        .course-row {
            border-radius: 12px;
            padding: 8px 10px;
            transition: all 0.16s ease;
        }

            .course-row:hover {
                background: rgba(239, 246, 255, 0.95);
                transform: translateY(-1px);
            }

        .pill-tag {
            border-radius: 999px;
            padding: 2px 8px;
            font-size: 0.7rem;
            background: rgba(15, 23, 42, 0.04);
        }

        .progress.progress-sm {
            height: 6px;
            border-radius: 999px;
            background-color: #e5e7eb;
            overflow: hidden;
        }

        .progress-sm .progress-bar {
            border-radius: 999px;
        }

        @media (max-width: 767.98px) {
            .admin-reportes-page {
                padding-top: 12px;
            }

            .dashboard-card .card-body {
                padding: 12px 12px 16px;
            }
        }
    </style>

    <section class="admin-reportes-page">
        <div class="container admin-reportes-container">
            <div class="row justify-content-center">
                <div class="col-12">

                    <div class="card dashboard-card border-0">
                        <!-- HEADER -->
                        <div class="card-header">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <p class="stat-label mb-1">
                                        Panel de reportes · Cursos y evaluaciones
                                    </p>
                                    <h5 class="card-title mb-1">Visión general de actividad
                                    </h5>
                                    <small class="d-inline-flex align-items-center text-xxs text-muted">
                                        <i class="fa fa-clock-o me-1"></i>
                                        <asp:Literal ID="ltTotalIntentos" runat="server" />
                                        &nbsp;intentos registrados
                                    </small>
                                </div>
                                <span class="badge-soft-primary px-3 py-2 d-flex align-items-center">
                                    <i class="fa fa-line-chart me-1"></i>Dashboard admin
                                </span>
                            </div>
                        </div>

                        <!-- BODY -->
                        <div class="card-body">
                            <!-- FILA 1: KPIs principales -->
                            <div class="row g-3 mb-3">
                                <div class="col-6 col-md-3">
                                    <div class="kpi-pill h-100 d-flex flex-column justify-content-between">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <span class="stat-label mb-0">Alumnos</span>
                                            <span class="kpi-icon">
                                                <i class="fa fa-users"></i>
                                            </span>
                                        </div>
                                        <div class="stat-value">
                                            <asp:Literal ID="ltTotalAlumnos" runat="server" />
                                        </div>
                                        <div class="text-xxs text-muted">Usuarios registrados</div>
                                    </div>
                                </div>

                                <div class="col-6 col-md-3">
                                    <div class="kpi-pill h-100 d-flex flex-column justify-content-between">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <span class="stat-label mb-0">Cursos</span>
                                            <span class="kpi-icon">
                                                <i class="fa fa-book"></i>
                                            </span>
                                        </div>
                                        <div class="stat-value">
                                            <asp:Literal ID="ltTotalCursos" runat="server" />
                                        </div>
                                        <div class="text-xxs text-muted">Con evaluaciones asociadas</div>
                                    </div>
                                </div>

                                <div class="col-6 col-md-3">
                                    <div class="kpi-pill h-100 d-flex flex-column justify-content-between">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <span class="stat-label mb-0">Intentos</span>
                                            <span class="kpi-icon">
                                                <i class="fa fa-bullseye"></i>
                                            </span>
                                        </div>
                                        <div class="stat-value">
                                            <asp:Literal ID="ltTotalIntentosKpi" runat="server" />
                                        </div>
                                        <div class="text-xxs text-muted">Total de intentos de evaluación</div>
                                    </div>
                                </div>

                                <div class="col-6 col-md-3">
                                    <div class="kpi-pill h-100 d-flex flex-column justify-content-between">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <span class="stat-label mb-0">Promedio global</span>
                                            <span class="kpi-icon">
                                                <i class="fa fa-trending-up"></i>
                                            </span>
                                        </div>
                                        <div class="stat-value">
                                            <asp:Literal ID="ltPromedioGlobal" runat="server" />
                                        </div>
                                        <div class="text-xxs text-muted">Puntaje promedio (%)</div>
                                    </div>
                                </div>
                            </div>

                            <!-- FILA 2: Top cursos + métricas avanzadas -->
                            <div class="row g-3 mb-3">
                                <!-- Gráfico Top cursos -->
                                <div class="col-lg-8">
                                    <div class="chart-card h-100">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <div class="mini-card-title mb-0">Actividad por curso</div>
                                                <small class="text-xxs text-muted">Intentos en los cursos con mayor uso
                                                </small>
                                            </div>
                                            <span class="pill-tag text-muted">Top cursos
                                            </span>
                                        </div>
                                        <div class="chart-container">
                                            <canvas id="chartTopCursos"></canvas>
                                        </div>
                                    </div>
                                </div>

                                <!-- Métricas derivadas -->
                                <div class="col-lg-4">
                                    <div class="mini-card h-100 d-flex flex-column">
                                        <div class="mini-card-title mb-1">
                                            Métricas avanzadas
                                        </div>
                                        <p class="text-xxs text-muted mb-2">
                                            Indicadores calculados directamente desde los intentos de evaluación.
                                        </p>

                                        <div class="mb-2">
                                            <span class="text-xxs text-muted d-block">Tasa de aprobación</span>
                                            <span class="mini-stat d-block">
                                                <asp:Literal ID="ltTasaAprobacion" runat="server" />
                                            </span>
                                            <span class="text-xxs text-muted">Porcentaje de intentos aprobados</span>
                                        </div>

                                        <hr class="my-2" />

                                        <div class="mb-2">
                                            <span class="text-xxs text-muted d-block">Intentos por alumno</span>
                                            <span class="mini-stat d-block">
                                                <asp:Literal ID="ltIntentosPorAlumno" runat="server" />
                                            </span>
                                            <span class="text-xxs text-muted">Promedio de intentos por usuario</span>
                                        </div>

                                        <div class="mt-auto pt-2">
                                            <small class="text-xxs text-muted d-flex align-items-center">
                                                <i class="fa fa-info-circle me-1"></i>
                                                Datos tomados en tiempo real desde la base de datos.
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- FILA 3: Intentos por día + distribución de puntajes -->
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <div class="chart-card h-100">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <div class="mini-card-title mb-0">Intentos por día</div>
                                                <small class="text-xxs text-muted">Tendencia de actividad en evaluaciones
                                                </small>
                                            </div>
                                            <span class="pill-tag text-muted">Últimos días
                                            </span>
                                        </div>
                                        <div class="chart-container">
                                            <canvas id="chartIntentosDia"></canvas>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="chart-card h-100">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <div class="mini-card-title mb-0">Distribución de puntajes</div>
                                                <small class="text-xxs text-muted">Tramos de nota en los intentos registrados
                                                </small>
                                            </div>
                                            <span class="pill-tag text-muted">Rango de % obtenido
                                            </span>
                                        </div>
                                        <div class="chart-container">
                                            <canvas id="chartDistribucion"></canvas>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- FILA 4: listado top cursos -->
                            <div class="mt-2">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <div>
                                        <div class="mini-card-title mb-0">Cursos con mayor actividad</div>
                                        <small class="text-xxs text-muted">Intentos, alumnos que han rendido y promedio de nota.
                                        </small>
                                    </div>
                                    <span class="pill-tag text-muted">Ranking top
                                    </span>
                                </div>

                                <ul class="list-unstyled mb-0">
                                    <asp:Repeater ID="rptTopCursos" runat="server">
                                        <ItemTemplate>
                                            <li class="course-row mb-2">
                                                <div class="row align-items-center">
                                                    <div class="col-12 col-md-5">
                                                        <div class="fw-semibold text-sm">
                                                            <%# Eval("nombre") %>
                                                        </div>
                                                        <div class="text-xxs text-muted">
                                                            <%# Eval("alumnos_realizaron") %> alumno(s) ·
                                                            <%# Eval("total_intentos") %> intento(s)
                                                        </div>
                                                    </div>

                                                    <div class="col-6 col-md-3 mt-2 mt-md-0 text-md-center">
                                                        <div class="text-xxs text-muted">Promedio curso</div>
                                                        <div class="fw-semibold">
                                                            <%# Eval("puntaje_promedio", "{0:N1}") %> %
                                                        </div>
                                                    </div>

                                                    <div class="col-6 col-md-4 mt-2 mt-md-0">
                                                        <div class="d-flex justify-content-between mb-1">
                                                            <small class="text-xxs text-muted">Participación de intentos
                                                            </small>
                                                            <small class="text-xxs text-muted">
                                                                <%# Eval("porcentaje_intentos", "{0:N1}") %> %
                                                            </small>
                                                        </div>
                                                        <div class="progress progress-sm">
                                                            <div class="progress-bar"
                                                                role="progressbar"
                                                                style='width: <%# Eval("porcentaje_intentos") %>%'>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </ul>
                            </div>
                        </div>
                        <!-- /card-body -->
                    </div>
                    <!-- /card -->

                </div>
            </div>
        </div>
    </section>

    <!-- CHART.JS + SCRIPT -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="text/javascript">
        window.addEventListener('load', function () {
            try {
                // ============= TOP CURSOS (BARRAS) =============
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

                // ============= INTENTOS POR DÍA (LÍNEA) =============
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

                // ============= DISTRIBUCIÓN DE PUNTAJES (DOUGHNUT) =============
                var ctx3 = document.getElementById('chartDistribucion');
                if (ctx3 && window.tramosLabels && window.tramosData) {

                    // total de intentos para porcentaje
                    var totalTramos = window.tramosData.reduce(function (acc, v) {
                        return acc + v;
                    }, 0);

                    // colores (opcional, solo para que se distingan mejor)
                    var bgColors = [
                        'rgba(37, 99, 235, 0.9)',   // 0-49
                        'rgba(236, 72, 153, 0.9)',  // 50-69
                        'rgba(249, 115, 22, 0.9)',  // 70-84
                        'rgba(234, 179, 8, 0.9)'    // 85-100
                    ];

                    new Chart(ctx3, {
                        type: 'doughnut',
                        data: {
                            labels: window.tramosLabels,   // ["0 - 49", "50 - 69", ...]
                            datasets: [{
                                data: window.tramosData,   // [nIntentosTramo1, ...]
                                backgroundColor: bgColors,
                                hoverOffset: 4
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            cutout: '55%', // dona más marcada
                            plugins: {
                                // LEYENDA ABAJO CON MÁS INFO
                                legend: {
                                    position: 'bottom',
                                    labels: {
                                        generateLabels: function (chart) {
                                            var data = chart.data;
                                            if (!data.labels.length) return [];

                                            return data.labels.map(function (label, i) {
                                                var value = data.datasets[0].data[i] || 0;
                                                var percent = totalTramos > 0
                                                    ? (value * 100 / totalTramos).toFixed(1)
                                                    : 0;

                                                return {
                                                    text: label + ' — ' + value +
                                                        ' intento(s) (' + percent + '%)',
                                                    fillStyle: (data.datasets[0].backgroundColor || [])[i] || '#999',
                                                    strokeStyle: '#fff',
                                                    lineWidth: 1,
                                                    hidden: value === 0,
                                                    index: i
                                                };
                                            });
                                        }
                                    }
                                },
                                // TOOLTIP DETALLADO
                                tooltip: {
                                    callbacks: {
                                        label: function (ctx) {
                                            var value = ctx.parsed || 0;
                                            var percent = totalTramos > 0
                                                ? (value * 100 / totalTramos).toFixed(1)
                                                : 0;
                                            return ctx.label + ': ' + value +
                                                ' intento(s) (' + percent + '%)';
                                        }
                                    }
                                }
                            }
                        }
                    });
                }
            } catch (e) {
                if (window.console) console.error(e);
            }
        });
    </script>



</asp:Content>
