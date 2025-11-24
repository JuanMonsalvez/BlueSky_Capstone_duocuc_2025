<%@ Page Title="Curso: Introduccion a SQL" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IntroduccionSQL.aspx.cs" Inherits="bluesky.IntroduccionSQL" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- =========================== ESTILOS ESPECÍFICOS DE LA PÁGINA =========================== -->
    <style>
        /* ---------- HERO DEL CURSO ---------- */
        .hero.hero--curso {
            position: relative;
            min-height: 320px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: #fff;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .hero__overlay {
            position: absolute;
            inset: 0;
            background: rgba(0, 0, 0, 0.55);
            z-index: 0;
        }

        .hero__inner {
            position: relative;
            z-index: 1;
            padding: 40px 16px 48px;
            max-width: 960px;
            margin: 0 auto;
        }

        .hero__title {
            font-weight: 800;
            font-size: clamp(2rem, 1.4vw + 1.8rem, 2.6rem);
            margin: 0;
            color: #ffffff;
        }

        .btn-row.hero-btns {
            margin-top: 10px;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 12px;
        }

        .btn.btn-hero {
            border-radius: 999px;
            padding: 10px 22px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            border: 1px solid transparent;
        }

        .btn.btn-hero.btn-left {
            background: #facc15;
            color: #111827;
            border-color: #eab308;
        }

        .btn.btn-hero.btn-right.btn-primary {
            background: #2563eb;
            color: #ffffff;
            border-color: #2563eb;
        }

        .btn.btn-hero:hover {
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .hero.hero--curso {
                min-height: 260px;
            }
        }

        /* ---------- SECCIÓN META (4 CARDS) ---------- */
        .course-meta {
            padding: 40px 0;
            background: #f9fafb;
        }

        .course-meta .container {
            max-width: 1100px;
            margin: 0 auto;
        }

        .course-meta .meta-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .meta-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 18px;
            padding: 18px 18px 20px;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06);
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .meta-topbar {
            height: 3px;
            border-radius: 999px;
            background: #e5e7eb;
        }

        .meta-body {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .meta-icon {
            font-size: 24px;
            color: #111827;
        }

        .meta-title {
            font-weight: 700;
            font-size: 1.05rem;
            color: #0f172a;
            margin: 0;
        }

        .meta-value {
            font-size: 0.98rem;
            color: #4b5563;
            margin: 0;
        }

        /* ---------- SECCIONES GENERALES ---------- */
        .course-target,
        .course-reqs,
        .course-mods {
            padding: 40px 0;
        }

        .course-target .container,
        .course-reqs .container,
        .course-mods .container,
        #methodology .container {
            max-width: 1100px;
            margin: 0 auto;
        }

        .course-target__title,
        .course-reqs__title,
        .course-mods__title {
            font-weight: 800;
            font-size: clamp(1.6rem, 1.1vw + 1.3rem, 2.1rem);
            margin-bottom: 12px;
            color: #0f172a;
        }

        .course-target__text,
        .course-reqs__block,
        .course-reqs__block ul {
            font-size: 0.98rem;
            color: #4b5563;
        }

        .course-reqs__subtitle {
            font-weight: 700;
            margin-top: 16px;
            margin-bottom: 6px;
            color: #0f172a;
        }

        .course-reqs__list {
            padding-left: 20px;
        }

        /* ---------- MÓDULOS DEL CURSO (CARDS) ---------- */
        .mods-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
        }

        .mod-card,
        .method-card {
            background: #ffffff;
            border-radius: 18px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06);
            padding: 18px 18px 20px;
        }

        .mod-card {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .mod-card__title {
            font-weight: 800;
            font-size: 1.08rem;
            margin: 0;
            color: #0f172a;
        }

        .mod-card__subtitle {
            margin: 0;
            font-size: 0.96rem;
            color: #4b5563;
        }

        .mod-card__list {
            margin: 8px 0 0 18px;
            padding: 0;
            font-size: 0.94rem;
            color: #4b5563;
        }

        .mod-card__actions {
            margin-top: auto;
            text-align: center;
        }

        .btn.btn-mod-see,
        .btn.method-more {
            border-radius: 999px;
            border: 1px solid #2563eb;
            padding: 7px 14px;
            font-weight: 600;
            font-size: 0.92rem;
            background: #2563eb;
            color: #ffffff;
            cursor: pointer;
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.35);
        }

        .btn.btn-mod-see:hover,
        .btn.method-more:hover {
            opacity: 0.9;
        }

        /* ---------- METODOLOGÍA / CERTIFICACIÓN (CARDS) ---------- */
        .methodology-grid {
            list-style: none;
            margin: 24px 0 0;
            padding: 0;
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
        }

        @media (max-width: 992px) {
            .methodology-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 640px) {
            .methodology-grid {
                grid-template-columns: 1fr;
            }
        }

        .method-card {
            display: flex;
            gap: 14px;
            align-items: flex-start;
        }

        .method-visual {
            flex: 0 0 96px;
            height: 96px;
            border-radius: 14px;
            display: grid;
            place-items: center;
            background: linear-gradient(135deg, #eef4ff, #ffffff);
            color: #1E66F5;
            box-shadow: inset 0 0 0 1px #e7edf8, 0 6px 16px rgba(16, 24, 40, .05);
        }

        .method-body {
            flex: 1;
        }

        .method-title {
            margin: 2px 0 6px;
            font-weight: 800;
            font-size: 1.05rem;
            color: #0f172a;
        }

        .method-text {
            margin: 0 0 8px;
            color: #4b5563;
            font-size: 0.95rem;
            line-height: 1.55;
        }

        .method-actions {
            margin-top: 8px;
        }

        /* ---------- MODALES (FORMATO UNIFICADO) ---------- */
        .modal-mods .modal-header {
            border-bottom: 1px solid #e5e7eb;
        }

        .modal-mods .modal-title {
            font-weight: 700;
            font-size: 1.1rem;
            color: #0f172a;
        }

        .modal-mods .modal-body {
            color: #0f172a;
            font-size: 0.95rem;
        }
    </style>

    <!-- HERO del curso -->
    <section class="hero hero--curso"
             style="background-image: url('<%: ResolveUrl("~/images/sql1.jpg") %>');"
             aria-labelledby="curso-title">
        <div class="hero__overlay" aria-hidden="true"></div>
        <div class="hero__inner text-center">
            <h1 id="curso-title" class="hero__title">Introducción a SQL para análisis de datos</h1>
            <br />
            <div class="btn-row hero-btns">
                <asp:Button ID="btnPrograma" runat="server"
                    CssClass="btn btn-hero btn-left"
                    Text="Descargar programa"
                    OnClick="btnPrograma_Click" />

                <asp:Button ID="btnIniciar" runat="server"
                    CssClass="btn btn-hero btn-right btn-primary"
                    Text="Iniciar curso"
                    OnClick="btnIniciar_Click" />
            </div>
        </div>
    </section>

    <!-- META DEL CURSO -->
    <section class="course-meta" aria-label="Información del curso">
        <div class="container">
            <ul class="meta-grid" role="list">
                <li class="meta-card" role="listitem">
                    <div class="meta-topbar"></div>
                    <div class="meta-body">
                        <div class="meta-icon" aria-hidden="true"><i class="fa fa-calendar-o"></i></div>
                        <h3 class="meta-title">Fecha de inicio</h3>
                        <p class="meta-value">
                            <asp:Label ID="lblFechaInicio" runat="server" Text="29-05-2025"></asp:Label>
                        </p>
                    </div>
                </li>
                <li class="meta-card" role="listitem">
                    <div class="meta-topbar"></div>
                    <div class="meta-body">
                        <div class="meta-icon" aria-hidden="true"><i class="fa fa-chalkboard-teacher"></i></div>
                        <h3 class="meta-title">Modalidad</h3>
                        <p class="meta-value">
                            <asp:Label ID="lblModalidad" runat="server" Text="Online"></asp:Label>
                        </p>
                    </div>
                </li>
                <li class="meta-card" role="listitem">
                    <div class="meta-topbar"></div>
                    <div class="meta-body">
                        <div class="meta-icon" aria-hidden="true"><i class="fa fa-signal"></i></div>
                        <h3 class="meta-title">Nivel</h3>
                        <p class="meta-value">
                            <asp:Label ID="lblNivel" runat="server" Text="Básico"></asp:Label>
                        </p>
                    </div>
                </li>
                <li class="meta-card" role="listitem">
                    <div class="meta-topbar"></div>
                    <div class="meta-body">
                        <div class="meta-icon" aria-hidden="true"><i class="fa fa-clock-o"></i></div>
                        <h3 class="meta-title">Duración</h3>
                        <p class="meta-value">
                            <asp:Label ID="lblDuracion" runat="server" Text="2 horas"></asp:Label>
                        </p>
                    </div>
                </li>
            </ul>
        </div>
    </section>

    <!-- DIRIGIDO A -->
    <section class="course-target" aria-labelledby="target-title">
        <div class="container">
            <h2 id="target-title" class="course-target__title">Dirigido a</h2>
            <p class="course-target__text">
                Personas que trabajan con datos (Excel/BI) y necesitan consultar bases relacionales para obtener,
                limpiar y combinar información con SQL de forma confiable y reproducible.
            </p>
        </div>
    </section>

    <!-- REQUISITOS -->
    <section class="course-reqs" aria-labelledby="reqs-title">
        <div class="container">
            <h2 id="reqs-title" class="course-reqs__title">Requisitos</h2>

            <div class="course-reqs__block">
                <h3 class="course-reqs__subtitle">Conocimientos previos recomendados:</h3>
                <ul class="course-reqs__list">
                    <li>Manejo básico de datos (Excel/Sheets) y conceptos de tablas/campos.</li>
                    <li>Lógica booleana simple y operaciones aritméticas básicas.</li>
                </ul>
            </div>

            <div class="course-reqs__block">
                <h3 class="course-reqs__subtitle">Requerimientos técnicos sugeridos:</h3>
                <ul class="course-reqs__list">
                    <li>Motor SQL (PostgreSQL, MySQL, SQL Server o SQLite).</li>
                    <li>Cliente SQL (DBeaver, pgAdmin, SSMS) o VS Code con extensión SQL.</li>
                    <li>Conexión estable a Internet y navegador actualizado.</li>
                </ul>
            </div>
        </div>
    </section>

    <!-- MÓDULOS -->
    <section id="mods" class="course-mods" aria-labelledby="mods-title">
        <div class="container">
            <h2 id="mods-title" class="course-mods__title">Módulos del curso</h2>

            <div class="mods-grid">
                <article class="mod-card" aria-labelledby="mod1-title">
                    <h3 id="mod1-title" class="mod-card__title">Módulo 1: Fundamentos y consultas básicas</h3>
                    <p class="mod-card__subtitle">Modelo relacional y SELECT</p>
                    <ul class="mod-card__list">
                        <li>Tablas, filas, columnas y claves (PK/FK).</li>
                        <li>SELECT · FROM · WHERE · ORDER BY · LIMIT.</li>
                        <li>Alias, expresiones y funciones básicas (texto, numéricas, fechas).</li>
                    </ul>
                    <div class="mod-card__actions">
                        <button type="button" class="btn btn-mod-see"
                                data-bs-toggle="modal" data-bs-target="#modsModal1"
                                aria-controls="modsModal1">
                            Ver más
                        </button>
                    </div>
                </article>

                <article class="mod-card" aria-labelledby="mod2-title">
                    <h3 id="mod2-title" class="mod-card__title">Módulo 2: Agregación y combinaciones</h3>
                    <p class="mod-card__subtitle">GROUP BY, HAVING y JOINs</p>
                    <ul class="mod-card__list">
                        <li>Funciones agregadas: COUNT, SUM, AVG, MIN, MAX.</li>
                        <li>GROUP BY y HAVING para KPIs y resúmenes.</li>
                        <li>JOINs: INNER, LEFT, RIGHT, FULL; casos típicos y prevención de duplicados.</li>
                    </ul>
                    <div class="mod-card__actions">
                        <button type="button" class="btn btn-mod-see"
                                data-bs-toggle="modal" data-bs-target="#modsModal2"
                                aria-controls="modsModal2">
                            Ver más
                        </button>
                    </div>
                </article>

                <article class="mod-card" aria-labelledby="mod3-title">
                    <h3 id="mod3-title" class="mod-card__title">Módulo 3: Subconsultas, CTE y ventanas</h3>
                    <p class="mod-card__subtitle">WITH y análisis avanzado</p>
                    <ul class="mod-card__list">
                        <li>Subconsultas en SELECT/WHERE/FROM.</li>
                        <li>CTE (WITH) para consultas legibles y reutilizables.</li>
                        <li>Funciones ventana: PARTITION BY, ORDER BY, ROW_NUMBER, RANK, LAG/LEAD.</li>
                    </ul>
                    <div class="mod-card__actions">
                        <button type="button" class="btn btn-mod-see"
                                data-bs-toggle="modal" data-bs-target="#modsModal3"
                                aria-controls="modsModal3">
                            Ver más
                        </button>
                    </div>
                </article>

                <article class="mod-card" aria-labelledby="mod4-title">
                    <h3 id="mod4-title" class="mod-card__title">Módulo 4: Buenas prácticas y performance</h3>
                    <p class="mod-card__subtitle">Índices, EXPLAIN y reporting</p>
                    <ul class="mod-card__list">
                        <li>Manejo de NULL, COALESCE y CASE para limpieza.</li>
                        <li>Índices, claves y lectura de EXPLAIN/EXPLAIN ANALYZE.</li>
                        <li>Exportar resultados y conexión a BI (Power BI/Looker Studio).</li>
                    </ul>
                    <div class="mod-card__actions">
                        <button type="button" class="btn btn-mod-see"
                                data-bs-toggle="modal" data-bs-target="#modsModal4"
                                aria-controls="modsModal4">
                            Ver más
                        </button>
                    </div>
                </article>
            </div>
        </div>
    </section>

    <!-- MODALES 1–4 -->
    <div class="modal fade modal-mods" id="modsModal1" tabindex="-1" role="dialog" aria-labelledby="modsModalLabel1" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" aria-modal="true">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modsModalLabel1" class="modal-title">Módulo 1: Fundamentos y consultas básicas</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <ul class="mod-detail-list">
                        <li>Tipos de datos comunes y conversión (CAST/CONVERT).</li>
                        <li>Filtrado con operadores (=, &lt;&gt;, BETWEEN, IN, LIKE).</li>
                        <li>Buenas prácticas de nomenclatura y legibilidad.</li>
                        <li>Ejercicio guiado: primeros SELECT contra un dataset ejemplo.</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade modal-mods" id="modsModal2" tabindex="-1" role="dialog" aria-labelledby="modsModalLabel2" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" aria-modal="true">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modsModalLabel2" class="modal-title">Módulo 2: Agregación y combinaciones</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <ul class="mod-detail-list">
                        <li>Trampas frecuentes en GROUP BY y HAVING.</li>
                        <li>Joins correctos y controles de duplicidad (DISTINCT, claves).</li>
                        <li>Uniones verticales: UNION vs UNION ALL.</li>
                        <li>Ejercicio: KPI mensuales con JOINs y agregaciones.</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade modal-mods" id="modsModal3" tabindex="-1" role="dialog" aria-labelledby="modsModalLabel3" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" aria-modal="true">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modsModalLabel3" class="modal-title">Módulo 3: Subconsultas, CTE y ventanas</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <ul class="mod-detail-list">
                        <li>Subconsultas correlacionadas vs no correlacionadas.</li>
                        <li>CTE encadenadas y reutilización de lógica.</li>
                        <li>Ventanas para comparativos y acumulados (running totals).</li>
                        <li>Ejercicio: ranking y variación con RANK/LAG.</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade modal-mods" id="modsModal4" tabindex="-1" role="dialog" aria-labelledby="modsModalLabel4" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" aria-modal="true">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modsModalLabel4" class="modal-title">Módulo 4: Buenas prácticas y performance</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <ul class="mod-detail-list">
                        <li>Normalización vs. vistas/denormalización ligera para reporting.</li>
                        <li>Índices: cuándo ayudan y cuándo no; columnas selectivas.</li>
                        <li>Lectura básica de planes (EXPLAIN) y anti-patrones comunes.</li>
                        <li>Exportación a CSV y conexión a herramientas BI.</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- METODOLOGÍA Y CERTIFICACIÓN -->
    <section id="methodology" class="methodology-pro v2" aria-labelledby="methodology-title" style="padding: 56px 0 72px; background: #fff;">
        <div class="container" style="max-width: 1100px;">
            <header class="text-center" style="margin-bottom: 18px;">
                <h2 id="methodology-title" class="methodology-title" style="font-weight: 900; letter-spacing: .2px; line-height: 1.15; font-size: clamp(2rem,1.2vw + 1.7rem,2.6rem); margin: 0; color: #0f172a;">
                    Metodología y certificación
                </h2>
                <div class="methodology-accent" aria-hidden="true" style="width: 120px; height: 6px; margin: 12px auto 0; border-radius: 999px; background: #f7b500; box-shadow: 0 6px 14px rgba(247,181,0,.35);"></div>
            </header>

            <ul class="methodology-grid" role="list">
                <li class="method-card" role="listitem" tabindex="0" data-step="1" aria-labelledby="m1-title">
                    <div class="method-visual" aria-hidden="true">
                        <svg viewBox="0 0 64 64" width="64" height="64" class="ico">
                            <g fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="8" y="36" width="48" height="14" rx="3" />
                                <path d="M12 36v-6a4 4 0 0 1 4-4h32a4 4 0 0 1 4 4v6" />
                                <path d="M27 18l13 7-13 7-13-7 13-7z" />
                                <path d="M40 25v6" />
                                <circle cx="40" cy="34" r="3" />
                            </g>
                        </svg>
                    </div>
                    <div class="method-body">
                        <h3 id="m1-title" class="method-title">Metodología</h3>
                        <p class="method-text">
                            Curso 100% online con sesiones guiadas, micro-demostraciones y práctica autónoma con feedback.
                        </p>
                        <div class="method-actions">
                            <button type="button" class="btn method-more js-open-method-modal">
                                Más detalles
                            </button>
                        </div>
                        <div class="method-modal-content" hidden>
                            <p>La metodología combina aprendizaje activo con recursos breves y aplicados:</p>
                            <ul class="method-list">
                                <li>Clases en vivo + cápsulas on-demand.</li>
                                <li>Material descargable por módulo y guías paso a paso.</li>
                                <li>Actividades con checklist de logro y feedback personalizado.</li>
                                <li>Foro y resolución de dudas en 24–48 h.</li>
                            </ul>
                        </div>
                    </div>
                </li>

                <li class="method-card" role="listitem" tabindex="0" data-step="2" aria-labelledby="m2-title">
                    <div class="method-visual" aria-hidden="true">
                        <svg viewBox="0 0 64 64" width="64" height="64" class="ico">
                            <g fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="10" y="12" width="36" height="40" rx="4" />
                                <path d="M18 22h18M18 30h10M18 38h18" />
                                <path d="M52 14l2 4-14 30-6 2 2-6 14-30z" />
                            </g>
                        </svg>
                    </div>
                    <div class="method-body">
                        <h3 id="m2-title" class="method-title">Evaluación</h3>
                        <p class="method-text">
                            Al final de cada módulo: cuestionario online y tarea aplicada breve con rúbrica clara.
                        </p>
                        <div class="method-actions">
                            <button type="button" class="btn method-more js-open-method-modal">
                                Más detalles
                            </button>
                        </div>
                        <div class="method-modal-content" hidden>
                            <p>Evaluamos el progreso con foco en evidencias:</p>
                            <ul>
                                <li>Cuestionarios con retroalimentación inmediata.</li>
                                <li>Tarea por módulo con rúbrica visible desde el inicio.</li>
                                <li>Calificaciones ponderadas y tablero de avance.</li>
                            </ul>
                        </div>
                    </div>
                </li>

                <li class="method-card" role="listitem" tabindex="0" data-step="3" aria-labelledby="m3-title">
                    <div class="method-visual" aria-hidden="true">
                        <svg viewBox="0 0 64 64" width="64" height="64" class="ico">
                            <g fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="10" y="10" width="44" height="30" rx="3" />
                                <path d="M18 22h16M18 28h10" />
                                <circle cx="44" cy="28" r="6" />
                                <path d="M40 40l4-6 4 6" />
                            </g>
                        </svg>
                    </div>
                    <div class="method-body">
                        <h3 id="m3-title" class="method-title">Certificación</h3>
                        <p class="method-text">
                            Certificado digital validable para quienes cumplan los requisitos de aprobación. Ideal para CV y LinkedIn.
                        </p>
                        <div class="method-actions">
                            <button type="button" class="btn method-more js-open-method-modal">
                                Más detalles
                            </button>
                        </div>
                        <div class="method-modal-content" hidden>
                            <p>Al aprobar el programa obtendrás:</p>
                            <ul>
                                <li>Certificado PDF con código de verificación.</li>
                                <li>Guía para añadir la credencial a LinkedIn.</li>
                                <li>Emisión dentro de 72 h posteriores a la aprobación final.</li>
                            </ul>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </section>

    <!-- Modal genérico (Metodología / Evaluación / Certificación) -->
    <div id="methodModal" class="modal fade modal-mods" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered" role="document" aria-modal="true">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title m-0">Detalles</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <!-- contenido dinámico -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Entendido</button>
                </div>
            </div>
        </div>
    </div>

    <!-- SCRIPTS: MODAL METODOLOGÍA -->
    <script>
        (function () {
            if (window.__BSK_methodScriptsBound) return;  // evita doble binding si se inyecta 2 veces
            window.__BSK_methodScriptsBound = true;

            function getBootstrapVersion() {
                if (window.bootstrap && typeof bootstrap.Modal === 'function') return 5;
                if (window.$ && typeof $.fn.modal === 'function') return 4; // aplica para BS3/4
                return 0; // sin Bootstrap JS
            }

            function openModal(el) {
                var v = getBootstrapVersion();
                if (v === 5) {
                    bootstrap.Modal.getOrCreateInstance(el, { backdrop: 'static', keyboard: true }).show();
                } else if (v === 4) {
                    $(el).modal({ backdrop: 'static', keyboard: true, show: true });
                } else {
                    // Fallback mínimo
                    el.style.display = 'block';
                    el.removeAttribute('aria-hidden');
                    el.classList.add('show');
                    document.body.style.overflow = 'hidden';
                }
            }

            function closeModal(el) {
                var v = getBootstrapVersion();
                if (v === 5) {
                    bootstrap.Modal.getOrCreateInstance(el).hide();
                } else if (v === 4) {
                    $(el).modal('hide');
                } else {
                    el.style.display = 'none';
                    el.setAttribute('aria-hidden', 'true');
                    el.classList.remove('show');
                    document.body.style.overflow = '';
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                var methodModalEl = document.getElementById('methodModal');
                if (!methodModalEl) return;

                var bodyEl = methodModalEl.querySelector('.modal-body');
                var titleEl = methodModalEl.querySelector('.modal-title');

                // Delegación: abre el modal cuando hacen click en cualquier .js-open-method-modal
                document.addEventListener('click', function (e) {
                    var btn = e.target.closest('.js-open-method-modal');
                    if (!btn) return;

                    e.preventDefault();
                    e.stopPropagation();

                    var card = btn.closest('.method-card');
                    var title = (card && card.querySelector('.method-title')) ? card.querySelector('.method-title').textContent.trim() : 'Detalles';
                    var content = (card && card.querySelector('.method-modal-content')) ? card.querySelector('.method-modal-content').innerHTML : '<p>Sin contenido.</p>';

                    // Inyecta contenido
                    titleEl.textContent = title;
                    bodyEl.innerHTML = content;

                    // Abre modal
                    openModal(methodModalEl);
                });

                // Cierres (funciona en BS5/BS4 y fallback)
                methodModalEl.querySelectorAll('[data-bs-dismiss="modal"],[data-dismiss="modal"],.btn-close,.close')
                    .forEach(function (btn) {
                        btn.addEventListener('click', function () {
                            closeModal(methodModalEl);
                        });
                    });

                // Fallback: cerrar al click fuera del contenido
                methodModalEl.addEventListener('click', function (ev) {
                    if (getBootstrapVersion() !== 0) return;
                    var dlg = methodModalEl.querySelector('.modal-dialog');
                    if (dlg && !dlg.contains(ev.target)) closeModal(methodModalEl);
                });

                // Fallback: ESC para cerrar
                document.addEventListener('keydown', function (ev) {
                    if (ev.key === 'Escape' && methodModalEl.classList.contains('show') && getBootstrapVersion() === 0) {
                        closeModal(methodModalEl);
                    }
                });
            });
        })();
    </script>

    <!-- =========================================
     MODALES: Módulos del curso (modsModal1..4)
     – Funcionan con data-bs-toggle/data-bs-target.
     – Añadimos fallback por si no está Bootstrap JS.
     ========================================= -->
    <script>
        (function () {
            if (window.__BSK_moduleScriptsBound) return;
            window.__BSK_moduleScriptsBound = true;

            function getBootstrapVersion() {
                if (window.bootstrap && typeof bootstrap.Modal === 'function') return 5;
                if (window.$ && typeof $.fn.modal === 'function') return 4; // BS3/4
                return 0;
            }

            function openById(id) {
                var el = document.getElementById(id);
                if (!el) return;

                var v = getBootstrapVersion();
                if (v === 5) {
                    bootstrap.Modal.getOrCreateInstance(el, { backdrop: true, keyboard: true }).show();
                } else if (v === 4) {
                    $(el).modal('show');
                } else {
                    el.style.display = 'block';
                    el.removeAttribute('aria-hidden');
                    el.classList.add('show');
                    document.body.style.overflow = 'hidden';
                }
            }

            function closeEl(el) {
                var v = getBootstrapVersion();
                if (v === 5) {
                    bootstrap.Modal.getOrCreateInstance(el).hide();
                } else if (v === 4) {
                    $(el).modal('hide');
                } else {
                    el.style.display = 'none';
                    el.setAttribute('aria-hidden', 'true');
                    el.classList.remove('show');
                    document.body.style.overflow = '';
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                // Delegación para cualquier botón .btn-mod-see que traiga data target
                document.addEventListener('click', function (e) {
                    var btn = e.target.closest('.btn-mod-see');
                    if (!btn) return;

                    // lee target (BS5 -> data-bs-target, BS3/4 -> data-target)
                    var sel = btn.getAttribute('data-bs-target') || btn.getAttribute('data-target') || '';
                    if (!sel || sel.charAt(0) !== '#') return;

                    var id = sel.slice(1);
                    // Si hay Bootstrap JS, el data-* ya hará su trabajo.
                    // Para seguridad (y para fallback), prevenimos y abrimos nosotros.
                    e.preventDefault();
                    e.stopPropagation();
                    openById(id);
                });

                // Cierre de TODOS los modales con clase .modal-mods (incluye módulos y methodModal) en fallback
                document.querySelectorAll('.modal-mods').forEach(function (modalEl) {
                    // Cerrar con X o botón que tenga atributos estándar
                    modalEl.querySelectorAll('[data-bs-dismiss="modal"],[data-dismiss="modal"],.btn-close,.close')
                        .forEach(function (btn) {
                            btn.addEventListener('click', function () { closeEl(modalEl); });
                        });

                    // Cerrar al click fuera del cuadro (fallback)
                    modalEl.addEventListener('click', function (ev) {
                        if (getBootstrapVersion() !== 0) return;
                        var dlg = modalEl.querySelector('.modal-dialog');
                        if (dlg && !dlg.contains(ev.target)) closeEl(modalEl);
                    });
                });
            });
        })();
    </script>

    <!-- =========================================
     Accesibilidad extra: navegación con teclado
     ========================================= -->
    <script>
        (function () {
            if (window.__BSK_cardsA11yBound) return;
            window.__BSK_cardsA11yBound = true;

            document.addEventListener('DOMContentLoaded', function () {
                var cards = Array.prototype.slice.call(document.querySelectorAll('.method-card'));
                cards.forEach(function (card, i) {
                    card.addEventListener('keydown', function (ev) {
                        if (ev.key === 'ArrowRight' || ev.key === 'ArrowLeft') {
                            ev.preventDefault();
                            var nextIndex = (ev.key === 'ArrowRight') ? Math.min(i + 1, cards.length - 1) : Math.max(i - 1, 0);
                            cards[nextIndex].focus();
                        }
                    });
                });
            });
        })();
    </script>

</asp:Content>
