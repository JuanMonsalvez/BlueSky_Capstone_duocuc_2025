<%@ Page Title="Curso: Herramientas básicas MS OFICCE" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="HerramientasMsOficce.aspx.cs" Inherits="bluesky.HerramientasMsOficce" %>

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

        /* Botones "Ver más" y "Más detalles" */
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
            flex: 0 0 64px;
            height: 64px;
            border-radius: 12px;
            display: grid;
            place-items: center;
            background: #f3f4f6;
            color: #111827;
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
        style="background-image: url('<%: ResolveUrl("~/images/HerramientasMS.jpeg") %>');"
        aria-labelledby="curso-title">
        <div class="hero__overlay" aria-hidden="true"></div>

        <div class="hero__inner text-center">
            <h1 id="curso-title" class="hero__title">Herramientas MS Office</h1>
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

    <!-- META DEL CURSO (4 tarjetas) -->
    <section class="course-meta" aria-label="Información del curso">
        <div class="container">
            <ul class="meta-grid" role="list">
                <li class="meta-card" role="listitem">
                    <div class="meta-topbar"></div>
                    <div class="meta-body">
                        <div class="meta-icon" aria-hidden="true"><i class="fa fa-calendar-o"></i></div>
                        <h3 class="meta-title">Fecha de inicio</h3>
                        <p class="meta-value">
                            <asp:Label ID="lblFechaInicio" runat="server" Text="25-09-2025"></asp:Label>
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

    <!-- SECCIÓN: Dirigido a -->
    <section class="course-target" aria-labelledby="target-title">
        <div class="container">
            <h2 id="target-title" class="course-target__title">Dirigido a</h2>
            <p class="course-target__text">
                Usuarios que buscan dominar tareas cotidianas con Word, Excel, PowerPoint y herramientas de productividad
                (Outlook/Teams/OneDrive) para mejorar su eficiencia en el trabajo o estudios.
            </p>
        </div>
    </section>

    <!-- SECCIÓN: Requisitos -->
    <section class="course-reqs" aria-labelledby="reqs-title">
        <div class="container">
            <h2 id="reqs-title" class="course-reqs__title">Requisitos</h2>

            <div class="course-reqs__block">
                <h3 class="course-reqs__subtitle">Conocimientos previos recomendados:</h3>
                <ul class="course-reqs__list">
                    <li>Manejo básico de PC y navegación web.</li>
                    <li>No se requieren conocimientos previos de Office.</li>
                </ul>
            </div>

            <div class="course-reqs__block">
                <h3 class="course-reqs__subtitle">Requerimientos técnicos sugeridos:</h3>
                <ul class="course-reqs__list">
                    <li>Microsoft 365 actualizado (Word, Excel, PowerPoint y Outlook).</li>
                    <li>Acceso a OneDrive y Teams para prácticas colaborativas.</li>
                    <li>Conexión estable a Internet y navegador actualizado.</li>
                </ul>
            </div>
        </div>
    </section>

    <!-- SECCIÓN: Módulos -->
    <section id="mods" class="course-mods" aria-labelledby="mods-title">
        <div class="container">
            <h2 id="mods-title" class="course-mods__title">Módulos del curso</h2>

            <div class="mods-grid">
                <!-- Módulo 1: Word -->
                <article class="mod-card" aria-labelledby="mod1-title">
                    <h3 id="mod1-title" class="mod-card__title">Módulo 1: Word esencial</h3>
                    <p class="mod-card__subtitle">Formato, estilos y organización</p>
                    <ul class="mod-card__list">
                        <li>Interfaz, plantillas y guardado en OneDrive</li>
                        <li>Formato de texto y párrafo; estilos y títulos</li>
                        <li>Listas, tablas simples e imágenes</li>
                    </ul>
                    <div class="mod-card__actions">
                        <button type="button" class="btn btn-mod-see"
                            data-bs-toggle="modal" data-bs-target="#modsModal1"
                            aria-controls="modsModal1">
                            Ver más
                        </button>
                    </div>
                </article>

                <!-- Módulo 2: Excel -->
                <article class="mod-card" aria-labelledby="mod2-title">
                    <h3 id="mod2-title" class="mod-card__title">Módulo 2: Excel básico</h3>
                    <p class="mod-card__subtitle">Fórmulas, tablas y gráficos</p>
                    <ul class="mod-card__list">
                        <li>Referencias, funciones básicas (SUMA, PROMEDIO, SI)</li>
                        <li>Tablas, filtros y formato condicional</li>
                        <li>Gráficos rápidos y compartir en OneDrive</li>
                    </ul>
                    <div class="mod-card__actions">
                        <button type="button" class="btn btn-mod-see"
                            data-bs-toggle="modal" data-bs-target="#modsModal2"
                            aria-controls="modsModal2">
                            Ver más
                        </button>
                    </div>
                </article>

                <!-- Módulo 3: PowerPoint -->
                <article class="mod-card" aria-labelledby="mod3-title">
                    <h3 id="mod3-title" class="mod-card__title">Módulo 3: PowerPoint efectivo</h3>
                    <p class="mod-card__subtitle">Diseño claro y presentaciones</p>
                    <ul class="mod-card__list">
                        <li>Diseños, temas y tipografías</li>
                        <li>Imágenes, iconos, SmartArt y transiciones</li>
                        <li>Modo presentador y exportación a PDF</li>
                    </ul>
                    <div class="mod-card__actions">
                        <button type="button" class="btn btn-mod-see"
                            data-bs-toggle="modal" data-bs-target="#modsModal3"
                            aria-controls="modsModal3">
                            Ver más
                        </button>
                    </div>
                </article>

                <!-- Módulo 4: Outlook/Teams/OneDrive -->
                <article class="mod-card" aria-labelledby="mod4-title">
                    <h3 id="mod4-title" class="mod-card__title">Módulo 4: Productividad con Outlook, Teams y OneDrive</h3>
                    <p class="mod-card__subtitle">Comunicación y trabajo colaborativo</p>
                    <ul class="mod-card__list">
                        <li>Outlook: correo, calendarios y reglas</li>
                        <li>Teams: equipos, reuniones y chat</li>
                        <li>OneDrive: carpetas, compartir y control de versiones</li>
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

    <!-- MODAL 1 -->
    <div class="modal fade modal-mods" id="modsModal1" tabindex="-1" role="dialog"
        aria-labelledby="modsModalLabel1" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" aria-modal="true">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modsModalLabel1" class="modal-title">Módulo 1: Word esencial</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <ul class="mod-detail-list">
                        <li>Buenas prácticas de formato y estilos; navegación por títulos.</li>
                        <li>Tablas, imágenes y encabezado/pie; numeración de páginas.</li>
                        <li>Revisión: control de cambios y comentarios.</li>
                        <li>Guardado en OneDrive y coautoría básica.</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL 2 -->
    <div class="modal fade modal-mods" id="modsModal2" tabindex="-1" role="dialog"
        aria-labelledby="modsModalLabel2" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" aria-modal="true">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modsModalLabel2" class="modal-title">Módulo 2: Excel básico</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <ul class="mod-detail-list">
                        <li>Fórmulas y funciones clave (SUMA, PROMEDIO, CONTAR.SI, SI).</li>
                        <li>Tablas, filtros, ordenamiento y formato condicional.</li>
                        <li>Gráficos rápidos y mini gráficos.</li>
                        <li>Compartir libros en OneDrive y permisos.</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL 3 -->
    <div class="modal fade modal-mods" id="modsModal3" tabindex="-1" role="dialog"
        aria-labelledby="modsModalLabel3" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" aria-modal="true">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modsModalLabel3" class="modal-title">Módulo 3: PowerPoint efectivo</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <ul class="mod-detail-list">
                        <li>Principios de diseño: contraste, alineación y jerarquía.</li>
                        <li>Imágenes, iconos, SmartArt, transiciones y animaciones sobrias.</li>
                        <li>Modo presentador, notas y atajos para exponer.</li>
                        <li>Exportar a PDF y empaquetar para compartir.</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL 4 -->
    <div class="modal fade modal-mods" id="modsModal4" tabindex="-1" role="dialog"
        aria-labelledby="modsModalLabel4" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" aria-modal="true">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modsModalLabel4" class="modal-title">Módulo 4: Productividad con Outlook, Teams y OneDrive</h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <ul class="mod-detail-list">
                        <li>Outlook: bandeja prioritaria, reglas, firmas y calendario.</li>
                        <li>Teams: reuniones, compartir pantalla, canales y archivos.</li>
                        <li>OneDrive: estructura de carpetas, compartir, versiones y recuperación.</li>
                        <li>Buenas prácticas de colaboración y seguridad básica.</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ================================ SECCIÓN: Metodología y certificación ================================ -->
    <section id="methodology" class="methodology-pro v2" aria-labelledby="methodology-title" style="padding: 40px 0 48px; background: #ffffff;">
        <div class="container" style="max-width: 1100px;">
            <header class="text-center" style="margin-bottom: 18px;">
                <h2 id="methodology-title" class="methodology-title" style="font-weight: 900; letter-spacing: .2px; line-height: 1.15; font-size: clamp(2rem,1.2vw + 1.7rem,2.3rem); margin: 0; color: #0f172a;">
                    Metodología y certificación
                </h2>
            </header>

            <!-- Grid 3 -> 2 -> 1 -->
            <ul class="methodology-grid" role="list">
                <!-- Metodología -->
                <li class="method-card" role="listitem" tabindex="0" data-step="1" aria-labelledby="m1-title">
                    <div class="method-visual" aria-hidden="true">
                        <svg viewBox="0 0 64 64" width="40" height="40" class="ico">
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
                            Clases en vivo con demostraciones guiadas, prácticas paso a paso y material descargable por módulo.
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
                                <li>Guías y plantillas para Word, Excel y PowerPoint.</li>
                                <li>Actividades con checklist de logro y feedback personalizado.</li>
                                <li>Foro y resolución de dudas en 24–48 h.</li>
                            </ul>
                        </div>
                    </div>
                </li>

                <!-- Evaluación -->
                <li class="method-card" role="listitem" tabindex="0" data-step="2" aria-labelledby="m2-title">
                    <div class="method-visual" aria-hidden="true">
                        <svg viewBox="0 0 64 64" width="40" height="40" class="ico">
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
                            Quiz por módulo y actividades aplicadas: documentos Word, planillas con fórmulas y gráficos, presentación final.
                        </p>
                        <div class="method-actions">
                            <button type="button" class="btn method-more js-open-method-modal">
                                Más detalles
                            </button>
                        </div>

                        <div class="method-modal-content" hidden>
                            <p>Evaluamos el progreso con foco en evidencias de aprendizaje:</p>
                            <ul>
                                <li>Cuestionarios online con retroalimentación inmediata.</li>
                                <li>Entregables guiados (Word, Excel, PPT) con rúbrica.</li>
                                <li>Calificaciones ponderadas y tablero de avance.</li>
                            </ul>
                        </div>
                    </div>
                </li>

                <!-- Certificación -->
                <li class="method-card" role="listitem" tabindex="0" data-step="3" aria-labelledby="m3-title">
                    <div class="method-visual" aria-hidden="true">
                        <svg viewBox="0 0 64 64" width="40" height="40" class="ico">
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
                            Certificado digital validable para quienes cumplan los requisitos. Ideal para CV y LinkedIn.
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
                                <li>Guía para adicionar la credencial a LinkedIn.</li>
                                <li>Emisión dentro de 72 h tras la aprobación final.</li>
                            </ul>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </section>

    <!-- MODAL GENÉRICO (Metodología / Evaluación / Certificación) -->
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
            if (window.__BSK_methodScriptsBound) return;
            window.__BSK_methodScriptsBound = true;

            function getBootstrapVersion() {
                if (window.bootstrap && typeof bootstrap.Modal === 'function') return 5;
                return 0;
            }

            function openModal(el) {
                var v = getBootstrapVersion();
                if (v === 5) {
                    bootstrap.Modal.getOrCreateInstance(el, {
                        backdrop: 'static',
                        keyboard: true
                    }).show();
                } else {
                    // Fallback mínimo (también bloqueado)
                    el.style.display = 'block';
                    el.removeAttribute('aria-hidden');
                    el.classList.add('show');
                    document.body.style.overflow = 'hidden';
                }
            }

            function closeModal(el) {
                var v = getBootstrapVersion();
                if (v === 5) {
                    var instance = bootstrap.Modal.getInstance(el);
                    if (!instance) {
                        instance = bootstrap.Modal.getOrCreateInstance(el);
                    }
                    instance.hide();
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

                // Abrir al hacer click en .js-open-method-modal
                document.addEventListener('click', function (e) {
                    var btn = e.target.closest('.js-open-method-modal');
                    if (!btn) return;

                    e.preventDefault();
                    e.stopPropagation();

                    var card = btn.closest('.method-card');
                    var title = (card && card.querySelector('.method-title')) ? card.querySelector('.method-title').textContent.trim() : 'Detalles';
                    var content = (card && card.querySelector('.method-modal-content')) ? card.querySelector('.method-modal-content').innerHTML : '<p>Sin contenido.</p>';

                    titleEl.textContent = title;
                    bodyEl.innerHTML = content;

                    openModal(methodModalEl);
                });

                // Cerrar con botones estándar
                methodModalEl.querySelectorAll('[data-bs-dismiss="modal"],.btn-close')
                    .forEach(function (btn) {
                        btn.addEventListener('click', function () {
                            closeModal(methodModalEl);
                        });
                    });

                // Fallback: ESC para cerrar solo cuando NO hay Bootstrap
                document.addEventListener('keydown', function (ev) {
                    if (ev.key === 'Escape' && methodModalEl.classList.contains('show') && getBootstrapVersion() === 0) {
                        closeModal(methodModalEl);
                    }
                });
            });
        })();
    </script>

    <!-- SCRIPTS: MODALES MÓDULOS (1..4) -->
    <script>
        (function () {
            if (window.__BSK_moduleScriptsBound) return;
            window.__BSK_moduleScriptsBound = true;

            function getBootstrapVersion() {
                if (window.bootstrap && typeof bootstrap.Modal === 'function') return 5;
                return 0;
            }

            function openById(id) {
                var el = document.getElementById(id);
                if (!el) return;

                var v = getBootstrapVersion();
                if (v === 5) {
                    bootstrap.Modal.getOrCreateInstance(el, {
                        backdrop: 'static',
                        keyboard: true
                    }).show();
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
                    var instance = bootstrap.Modal.getInstance(el);
                    if (!instance) {
                        instance = bootstrap.Modal.getOrCreateInstance(el);
                    }
                    instance.hide();
                } else {
                    el.style.display = 'none';
                    el.setAttribute('aria-hidden', 'true');
                    el.classList.remove('show');
                    document.body.style.overflow = '';
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                // Abrir modales de módulos
                document.addEventListener('click', function (e) {
                    var btn = e.target.closest('.btn-mod-see');
                    if (!btn) return;

                    var sel = btn.getAttribute('data-bs-target') || '';
                    if (!sel || sel.charAt(0) !== '#') return;

                    var id = sel.slice(1);
                    e.preventDefault();
                    e.stopPropagation();
                    openById(id);
                });

                // Cierre de TODOS los modales con clase .modal-mods
                document.querySelectorAll('.modal-mods').forEach(function (modalEl) {
                    modalEl.querySelectorAll('[data-bs-dismiss="modal"],.btn-close')
                        .forEach(function (btn) {
                            btn.addEventListener('click', function () {
                                closeEl(modalEl);
                            });
                        });
                });
            });
        })();
    </script>

    <!-- Accesibilidad extra: navegación con teclado -->
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
