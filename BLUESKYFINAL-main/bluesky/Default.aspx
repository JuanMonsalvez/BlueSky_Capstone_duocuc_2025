<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="bluesky.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .pro-tst-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 26px 22px 22px;
            box-shadow: 0 15px 35px rgba(15, 23, 42, 0.10);
            border-top: 3px solid #2563eb;
            max-width: 360px;
            width: 100%;
            transition: transform .25s ease, box-shadow .25s ease;
        }

            .pro-tst-card:hover {
                transform: translateY(-6px);
                box-shadow: 0 22px 45px rgba(15, 23, 42, 0.16);
            }

        .tst-avatar-wrap {
            position: relative;
            display: inline-block;
        }

        .tst-avatar-img {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #e0ecff;
            box-shadow: 0 0 0 4px #f5f7ff;
        }

        .tst-quote {
            position: absolute;
            top: -8px;
            left: 50%;
            transform: translateX(-50%);
            background: #2563eb;
            color: #fff;
            width: 26px;
            height: 26px;
            border-radius: 999px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }

        .tst-name {
            font-size: 16px;
            font-weight: 600;
        }

        .tst-meta {
            font-size: 13px;
            color: #9ca3af;
        }

        .tst-text {
            font-size: 13px;
            color: #4b5563;
            min-height: 48px;
        }
    </style>


    <!-- HOME/CARROUSEL -->
    <section id="home">
        <div class="row">
            <div class="owl-carousel owl-theme home-slider">
                <div class="item item-first">
                    <div class="caption">
                        <div class="container">
                            <div class="col-md-6 col-sm-12">
                                <h1>Capacítate desde cualquier lugar</h1>
                                <h3>Accede a cursos en línea creados especialmente para conocer los procesos y políticas de BlueSky Financial.</h3>
                                <a href="#feature" class="section-btn btn btn-default smoothScroll">Ver beneficios</a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="item item-second">
                    <div class="caption">
                        <div class="container">
                            <div class="col-md-6 col-sm-12">
                                <h1>Avanza a tu ritmo</h1>
                                <h3>Realiza las capacitaciones obligatorias según tu rol, rinde evaluaciones y obtén tu certificado.</h3>
                                <a href="#feature" class="section-btn btn btn-default smoothScroll">Explorar Cursos</a>

                            </div>
                        </div>
                    </div>
                </div>

                <div class="item item-third">
                    <div class="caption">
                        <div class="container">
                            <div class="col-md-6 col-sm-12">
                                <h1>Formación simple y efectiva</h1>
                                <h3>Diseñamos esta plataforma para facilitar tu integración y crecimiento dentro de BlueSky.</h3>
                                <a href="#contact" class="section-btn btn btn-default smoothScroll">Contáctanos</a>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- FEATURE PRO / TU RUTA DE CAPACITACION-->
    <section id="feature" class="feature-pro-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-12 text-center mb-5" data-aos="fade-up">
                    <h3 class="feature-title">Tu ruta de capacitación</h3>
                </div>
                <br />
                <!-- CARD1 -->
                <div class="col-md-4 col-sm-6 mb-4" data-aos="fade-up" data-aos-delay="0">
                    <div class="feature-card" id="cardPaso1" data-tilt>
                        <div class="step-badge">01</div>
                        <i class='bx bxs-graduation icon'></i>
                        <h3>Capacitación obligatoria</h3>
                        <p class="fs-150 lh-17 c-333">Cursos asignados según tu rol para cumplir estándares internos y normativas.</p>
                        <div class="chip">Asignado por RR.HH.</div>
                        <div class="chip">Onboarding</div>
                    </div>
                </div>
                <!-- CARD2 -->
                <div class="col-md-4 col-sm-6 mb-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="feature-card" id="cardPaso2" data-tilt>
                        <div class="step-badge">02</div>
                        <i class='bx bxs-edit icon'></i>
                        <h3>Evaluación en línea</h3>
                        <p class="fs-150 lh-17 c-333">Rinde una prueba por curso para validar tu aprendizaje con feedback inmediato.</p>
                        <div class="chip">Tiempo estimado: 10–15 min</div>
                        <div class="chip">Intentos controlados</div>
                    </div>
                </div>

                <!-- CARD3 -->
                <div class="col-md-4 col-sm-6 mb-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="feature-card" id="cardPaso3" data-tilt>
                        <div class="step-badge">03</div>
                        <i class='bx bxs-badge-check icon'></i>
                        <h3>Certificación automática</h3>
                        <p class="fs-150 lh-17 c-333">Al aprobar, descarga tu certificado digital validado por BlueSky y compártelo.</p>
                        <div class="chip">PDF con folio</div>
                        <div class="chip">Validez interna</div>
                    </div>
                </div>
            </div>

            <!-- Línea de progreso (decorativa) -->
            <div class="progress-line d-none d-md-flex" aria-hidden="false">
                <span id="dotPaso1"
                    class="dot dot-1"
                    title="Capacitación"
                    tabindex="0"
                    data-target="cardPaso1"
                    aria-controls="cardPaso1"
                    aria-label="Ver: Capacitación obligatoria"></span>

                <span id="dotPaso2"
                    class="dot dot-2"
                    title="Evaluación"
                    tabindex="0"
                    data-target="cardPaso2"
                    aria-controls="cardPaso2"
                    aria-label="Ver: Evaluación en línea"></span>

                <span id="dotPaso3"
                    class="dot dot-3"
                    title="Certificación"
                    tabindex="0"
                    data-target="cardPaso3"
                    aria-controls="cardPaso3"
                    aria-label="Ver: Certificación automática"></span>
            </div>
        </div>
    </section>
    <!-- CARD TU RUTA DE CAPACITACION -->
    <div class="modal fade" id="modalPaso1" tabindex="-1"
        aria-labelledby="modalPaso1Label" aria-hidden="true"
        data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog" role="document">
            <div class="modal-content">

                <div class="modal-header text-center">
                    <h4 class="modal-title" id="modalPaso1Label">01 · Capacitación obligatoria</h4>
                    <button type="button" class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Cerrar">
                    </button>
                </div>

                <div class="modal-body">
                    <p>Cursos asignados según tu rol para cumplir estándares internos y normativas.</p>
                    <div class="chip">Asignado por RR.HH.</div>
                    <div class="chip">Onboarding</div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default"
                        data-bs-dismiss="modal">
                        Cerrar
                    </button>
                </div>

            </div>
        </div>
    </div>

    <div class="modal fade" id="modalPaso2" tabindex="-1"
        aria-labelledby="modalPaso2Label" aria-hidden="true"
        data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog" role="document">
            <div class="modal-content">

                <div class="modal-header text-center">
                    <h4 class="modal-title" id="modalPaso2Label">02 · Evaluación en línea</h4>
                    <button type="button" class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Cerrar">
                    </button>
                </div>

                <div class="modal-body">
                    <p>Rinde una prueba por curso para validar tu aprendizaje con feedback inmediato.</p>
                    <div class="chip">Tiempo estimado: 10–15 min</div>
                    <div class="chip">Intentos controlados</div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default"
                        data-bs-dismiss="modal">
                        Cerrar
                    </button>
                </div>

            </div>
        </div>
    </div>

    <div class="modal fade" id="modalPaso3" tabindex="-1"
        aria-labelledby="modalPaso3Label" aria-hidden="true"
        data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog" role="document">
            <div class="modal-content">

                <div class="modal-header text-center">
                    <h4 class="modal-title" id="modalPaso3Label">03 · Certificación automática</h4>
                    <button type="button" class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Cerrar">
                    </button>
                </div>

                <div class="modal-body">
                    <p>Al aprobar, descarga tu certificado digital validado por BlueSky y compártelo.</p>
                    <div class="chip">PDF con folio</div>
                    <div class="chip">Validez interna</div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default"
                        data-bs-dismiss="modal">
                        Cerrar
                    </button>
                </div>

            </div>
        </div>
    </div>

    <!-- ABOUT -->
    <section id="about" class="about-pro">
        <div class="container">

            <!-- Título arriba y centrado -->
            <div class="row">
                <div class="col-12 text-center" data-aos="fade-up">
                    <h4 class="feature-title">Impulsa tu desarrollo con nuestra plataforma de capacitación</h4>
                </div>
            </div>
            <br />
            <!-- Layout 2 columnas: cards (izq) + visual interactivo (der) -->
            <div class="row about-row">

                <!-- IZQUIERDA: Información / Cards -->
                <div class="col-md-6 col-sm-12 about-info-col">
                    <div class="about-info-pro" data-aos="fade-right">
                        <div class="about-list">

                            <!-- Item 1 -->
                            <div class="about-item"
                                data-aos="fade-up"
                                data-aos-delay="50"
                                role="button" tabindex="0"
                                aria-label="Capacitación para nuevos ingresos"
                                title="Capacitación para nuevos ingresos"
                                onmouseenter="this.classList.add('card-wiggle-once');"
                                onanimationend="this.classList.remove('card-wiggle-once');"
                                onfocus="this.classList.add('card-wiggle-once');"
                                onblur="this.classList.remove('card-wiggle-once');">
                                <div class="about-item-inner"
                                    data-tilt data-tilt-max="8" data-tilt-speed="500"
                                    data-tilt-perspective="900" data-tilt-scale="1.03">
                                    <div class="about-icon" aria-hidden="true">
                                        <i class="fa fa-users"></i>
                                    </div>
                                    <div class="about-text">
                                        <h3>Capacitación para nuevos ingresos</h3>
                                        <p>Todos los nuevos integrantes completan cursos clave para conocer procesos y valores de BlueSky.</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Item 2 -->
                            <div class="about-item"
                                data-aos="fade-up"
                                data-aos-delay="100"
                                role="button" tabindex="0"
                                aria-label="Evaluación y certificación"
                                title="Evaluación y certificación"
                                onmouseenter="this.classList.add('card-wiggle-once');"
                                onanimationend="this.classList.remove('card-wiggle-once');"
                                onfocus="this.classList.add('card-wiggle-once');"
                                onblur="this.classList.remove('card-wiggle-once');">
                                <div class="about-item-inner"
                                    data-tilt data-tilt-max="8" data-tilt-speed="500"
                                    data-tilt-perspective="900" data-tilt-scale="1.03">
                                    <div class="about-icon" aria-hidden="true">
                                        <i class="fa fa-certificate"></i>
                                    </div>
                                    <div class="about-text">
                                        <h3>Evaluación y certificación</h3>
                                        <p>Cada curso incluye evaluación. Al aprobar, obtienes un certificado descargable de forma automática.</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Item 3 -->
                            <div class="about-item"
                                data-aos="fade-up"
                                data-aos-delay="150"
                                role="button" tabindex="0"
                                aria-label="Seguimiento de progreso"
                                title="Seguimiento de progreso"
                                onmouseenter="this.classList.add('card-wiggle-once');"
                                onanimationend="this.classList.remove('card-wiggle-once');"
                                onfocus="this.classList.add('card-wiggle-once');"
                                onblur="this.classList.remove('card-wiggle-once');">
                                <div class="about-item-inner"
                                    data-tilt data-tilt-max="8" data-tilt-speed="500"
                                    data-tilt-perspective="900" data-tilt-scale="1.03">
                                    <div class="about-icon" aria-hidden="true">
                                        <i class="fa fa-bar-chart-o"></i>
                                    </div>
                                    <div class="about-text">
                                        <h3>Seguimiento de progreso</h3>
                                        <p>La plataforma registra tu avance para que RRHH valide cumplimiento y desempeño.</p>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- DERECHA: Visual interactivo al lado de las cards (sin modal/zoom) -->
                <div class="col-md-6 col-sm-12 about-visual-col">
                    <figure class="about-visual pro-visual" data-aos="fade-left">
                        <div class="pro-frame is-interactive"
                            data-tilt data-tilt-max="8" data-tilt-speed="600" data-tilt-perspective="900">

                            <!-- Borde degradado animado -->
                            <span class="pro-gradient-border" aria-hidden="true"></span>

                            <!-- Imagen principal -->
                            <img
                                src="<%: ResolveUrl("~/images/portal-bluesky.png") %>"
                                alt="Portal de Capacitaciones - BlueSky"
                                class="pro-img"
                                loading="lazy"
                                width="1600"
                                height="1067" />

                            <!-- Overlay sin botón -->
                            <figcaption class="pro-overlay">
                                <div class="pro-caption">
                                    <!-- Puedes agregar un badge si quieres -->
                                    <!-- <span class="pro-badge">Vista del Portal</span> -->
                                </div>
                            </figcaption>

                            <!-- Efectos visuales -->
                            <span class="pro-sheen" aria-hidden="true"></span>
                            <span class="pro-shadow" aria-hidden="true"></span>
                        </div>
                    </figure>
                </div>

            </div>
        </div>
    </section>



    <!-- TEAM -->
    <section id="team" class="team-section py-80">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-12">
                    <div class="section-title text-center mb-40" data-aos="fade-up">
                        <h4 style="font-size: 40px; text-align: center;"><strong>Quiénes forman parte de Bluesky</strong></h4>
                        <small style="font-size: 22px; text-align: center; display: block;">Conoce a nuestro equipo de <strong>BlueSky Financial</strong>
                        </small>


                    </div>
                </div>

                <!-- LORENZO -->
                <div class="col-sm-6 col-md-6 col-lg-3 mb-24" data-aos="fade-up" data-aos-delay="0">
                    <article class="team-card" role="region" aria-labelledby="member-lorenzo-name">
                        <div class="team-media">
                            <img
                                src="<%: ResolveUrl("~/images/equipo/lorenzo.png") %>"
                                class="img-fluid"
                                alt="Foto de Lorenzo Araya"
                                loading="lazy"
                                width="480" height="560" />
                            <div class="media-overlay"></div>
                            <button type="button" class="btn btn-light btn-view"
                                data-bs-toggle="modal" data-bs-target="#modalLorenzo"
                                aria-label="Ver más sobre Lorenzo Araya">
                                Conoce más
                            </button>
                        </div>
                        <div class="team-body text-center">
                            <h3 id="member-lorenzo-name" class="member-name">Lorenzo Araya</h3>
                            <span class="badge-role">Desarrollador Full Stack</span>
                        </div>
                    </article>
                </div>

                <!-- JUAN -->
                <div class="col-sm-6 col-md-6 col-lg-3 mb-24" data-aos="fade-up" data-aos-delay="80">
                    <article class="team-card" role="region" aria-labelledby="member-juan-name">
                        <div class="team-media">
                            <img
                                src="<%: ResolveUrl("~/images/equipo/juan.png") %>"
                                class="img-fluid"
                                alt="Foto de Juan Monsalvez"
                                loading="lazy"
                                width="480" height="560" />
                            <div class="media-overlay"></div>
                            <button type="button"
                                class="btn btn-light btn-view"
                                data-bs-toggle="modal"
                                data-bs-target="#modalJuan"
                                aria-label="Ver más sobre Juan Monsalvez">
                                Conoce más
                            </button>
                        </div>
                        <div class="team-body text-center">
                            <h3 id="member-juan-name" class="member-name">Juan Monsalvez</h3>
                            <span class="badge-role">AI/Integration Developer</span>
                        </div>
                    </article>
                </div>

                <!-- MATIAS -->
                <div class="col-sm-6 col-md-6 col-lg-3 mb-24" data-aos="fade-up" data-aos-delay="160">
                    <article class="team-card" role="region" aria-labelledby="member-matias-name">
                        <div class="team-media">
                            <img
                                src="<%: ResolveUrl("~/images/equipo/matias.png") %>"
                                class="img-fluid"
                                alt="Foto de Matias Padilla"
                                loading="lazy"
                                width="480" height="560" />
                            <div class="media-overlay"></div>
                            <button type="button"
                                class="btn btn-light btn-view"
                                data-bs-toggle="modal"
                                data-bs-target="#modalMatias"
                                aria-label="Ver más sobre Matias Padilla">
                                Conoce más
                            </button>
                        </div>
                        <div class="team-body text-center">
                            <h3 id="member-matias-name" class="member-name">Matias Padilla</h3>
                            <span class="badge-role">Database Developer</span>
                        </div>
                    </article>
                </div>

                <!-- DAVID -->
                <div class="col-sm-6 col-md-6 col-lg-3 mb-24" data-aos="fade-up" data-aos-delay="240">
                    <article class="team-card" role="region" aria-labelledby="member-david-name">
                        <div class="team-media">
                            <img
                                src="<%: ResolveUrl("~/images/equipo/david.png") %>"
                                class="img-fluid"
                                alt="Foto de David Murillo"
                                loading="lazy"
                                width="480" height="560" />
                            <div class="media-overlay"></div>
                            <button type="button"
                                class="btn btn-light btn-view"
                                data-bs-toggle="modal"
                                data-bs-target="#modalDavid"
                                aria-label="Ver más sobre David Murillo">
                                Conoce más
                            </button>
                        </div>
                        <div class="team-body text-center">
                            <h3 id="member-david-name" class="member-name">David Murillo</h3>
                            <span class="badge-role">QA/Project Coordinator</span>
                        </div>
                    </article>
                </div>
            </div>
        </div>
    </section>

    <!-- MODAL / EXPERIENCIAS -->
    <div class="modal fade modal-pro" id="modalLorenzo" tabindex="-1"
        aria-labelledby="modalLorenzoLabel" aria-hidden="true"
        data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-md modal-dialog-centered" role="document">
            <div class="modal-content">

                <!-- ENCABEZADO -->
                <div class="modal-header flex-column text-center" style="position: relative; padding-top: 10px;">
                    <!-- Botón de cierre alineado a la derecha -->
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"
                        style="position: absolute; top: 10px; right: 10px;">
                    </button>

                    <div class="avatar-wrap mt-3">
                        <img src="<%: ResolveUrl("~/images/equipo/lorenzo.png") %>"
                            alt="Lorenzo Araya"
                            class="avatar img-responsive mb-3" />
                        <h4 class="title mb-1" id="modalLorenzoLabel" style="font-size: 18px;">Lorenzo Araya</h4>
                        <span class="role-badge" style="font-size: 14px;">Desarrollador Full Stack</span>
                    </div>
                </div>

                <!-- CUERPO -->
                <div class="modal-body" style="font-size: 14px; line-height: 1.5;">
                    <p><strong>Resumen:</strong> 6+ años construyendo aplicaciones web con ASP.NET (Web Forms y MVC), Web API y SQL Server.</p>
                    <p><strong>Experiencia relevante:</strong></p>
                    <ul class="list-check" style="padding-left: 18px; margin-bottom: 10px;">
                        <li>Migración de Web Forms a ASP.NET Core con autenticación Identity y JWT.</li>
                        <li>Integración de pagos (Transbank/API REST) y generación de certificados PDF con iText7.</li>
                        <li>Front-end con Bootstrap, jQuery y componentes reutilizables.</li>
                    </ul>
                    <p><strong>Stack:</strong></p>
                    <div class="chip-group" style="font-size: 13px;">
                        <span class="chip">C#</span>
                        <span class="chip">ASP.NET</span>
                        <span class="chip">EF</span>
                        <span class="chip">SQL Server</span>
                        <span class="chip">Azure DevOps</span>
                    </div>
                </div>

                <!-- PIE -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-bs-dismiss="modal" aria-label="Cerrar" style="font-size: 13px;">Cerrar</button>
                </div>

            </div>
        </div>
    </div>



    <!-- Modal juan -->
    <div class="modal fade modal-pro" id="modalJuan" tabindex="-1"
        aria-labelledby="modalJuanLabel" aria-hidden="true"
        data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-md modal-dialog-centered" role="document">
            <div class="modal-content">

                <!-- ENCABEZADO -->
                <div class="modal-header flex-column text-center" style="position: relative; padding-top: 10px;">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"
                        style="position: absolute; top: 10px; right: 10px;">
                    </button>
                    <div class="avatar-wrap mt-3">
                        <img src="<%: ResolveUrl("~/images/equipo/juan.png") %>"
                            alt="Juan Monsalvez"
                            class="avatar img-responsive mb-3" />
                        <h4 class="title mb-1" id="modalJuanLabel" style="font-size: 18px;">Juan Monsalvez</h4>
                        <span class="role-badge" style="font-size: 14px;">AI/Integration Developer</span>
                    </div>
                </div>

                <!-- CUERPO -->
                <div class="modal-body" style="font-size: 14px; line-height: 1.5;">
                    <p><strong>Resumen:</strong> Desarrollador especializado en inteligencia artificial y en la integración de sistemas empresariales.</p>
                    <p><strong>Experiencia relevante:</strong></p>
                    <ul class="list-check" style="padding-left: 18px; margin-bottom: 10px;">
                        <li>Diseño y despliegue de modelos de IA para análisis de datos y automatización de procesos.</li>
                        <li>Integración de APIs RESTful y microservicios entre plataformas corporativas.</li>
                        <li>Optimización de pipelines de datos y servicios backend para soluciones escalables.</li>
                    </ul>
                    <p><strong>Stack:</strong></p>
                    <div class="chip-group" style="font-size: 13px;">
                        <span class="chip">Python</span>
                        <span class="chip">C#</span>
                        <span class="chip">ASP.NET</span>
                        <span class="chip">TensorFlow</span>
                        <span class="chip">Azure</span>
                    </div>
                </div>

                <!-- PIE -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-bs-dismiss="modal" style="font-size: 13px;">Cerrar</button>
                </div>

            </div>
        </div>
    </div>

    <!-- Modal MATIAS -->
    <div class="modal fade modal-pro" id="modalMatias" tabindex="-1"
        aria-labelledby="modalMatiasLabel" aria-hidden="true"
        data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-md modal-dialog-centered" role="document">
            <div class="modal-content">

                <!-- ENCABEZADO -->
                <div class="modal-header flex-column text-center" style="position: relative; padding-top: 10px;">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"
                        style="position: absolute; top: 10px; right: 10px;">
                    </button>
                    <div class="avatar-wrap mt-3">
                        <img src="<%: ResolveUrl("~/images/equipo/matias.png") %>"
                            alt="Matias Padilla"
                            class="avatar img-responsive mb-3" />
                        <h4 class="title mb-1" id="modalMatiasLabel" style="font-size: 18px;">Matias Padilla</h4>
                        <span class="role-badge" style="font-size: 14px;">Database Developer</span>
                    </div>
                </div>

                <!-- CUERPO -->
                <div class="modal-body" style="font-size: 14px; line-height: 1.5;">
                    <p><strong>Resumen:</strong> Desarrollador especializado en el diseño, administración y optimización de bases de datos.</p>
                    <p><strong>Experiencia relevante:</strong></p>
                    <ul class="list-check" style="padding-left: 18px; margin-bottom: 10px;">
                        <li>Diseño de modelos de datos relacionales y normalización de esquemas.</li>
                        <li>Creación de procedimientos almacenados, vistas y triggers en SQL Server y Oracle.</li>
                        <li>Optimización de consultas y monitoreo de rendimiento de bases de datos.</li>
                    </ul>
                    <p><strong>Stack:</strong></p>
                    <div class="chip-group" style="font-size: 13px;">
                        <span class="chip">SQL Server</span>
                        <span class="chip">Oracle</span>
                        <span class="chip">PostgreSQL</span>
                        <span class="chip">SSIS</span>
                        <span class="chip">Azure Data Studio</span>
                    </div>
                </div>

                <!-- PIE -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-bs-dismiss="modal" style="font-size: 13px;">Cerrar</button>
                </div>

            </div>
        </div>
    </div>

    <!-- MODAL DAVID -->
    <div class="modal fade modal-pro" id="modalDavid" tabindex="-1"
        aria-labelledby="modalDavidLabel" aria-hidden="true"
        data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-md modal-dialog-centered" role="document">
            <div class="modal-content">

                <!-- ENCABEZADO -->
                <div class="modal-header flex-column text-center" style="position: relative; padding-top: 10px;">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"
                        style="position: absolute; top: 10px; right: 10px;">
                    </button>
                    <div class="avatar-wrap mt-3">
                        <img src="<%: ResolveUrl("~/images/equipo/david.png") %>"
                            alt="David Murillo"
                            class="avatar img-responsive mb-3" />
                        <h4 class="title mb-1" id="modalDavidLabel" style="font-size: 18px;">David Murillo</h4>
                        <span class="role-badge" style="font-size: 14px;">QA/Project Coordinator</span>
                    </div>
                </div>

                <!-- CUERPO -->
                <div class="modal-body" style="font-size: 14px; line-height: 1.5;">
                    <p><strong>Resumen:</strong> Coordinador de proyectos con experiencia en control de calidad, planificación ágil y gestión de entregas.</p>
                    <p><strong>Experiencia relevante:</strong></p>
                    <ul class="list-check" style="padding-left: 18px; margin-bottom: 10px;">
                        <li>Supervisión de QA funcional y automatizado en entornos web y móviles.</li>
                        <li>Gestión de cronogramas, dependencias y seguimiento de entregables.</li>
                        <li>Comunicación entre equipos de desarrollo, QA y stakeholders bajo metodologías ágiles.</li>
                    </ul>
                    <p><strong>Stack:</strong></p>
                    <div class="chip-group" style="font-size: 13px;">
                        <span class="chip">Jira</span>
                        <span class="chip">Azure DevOps</span>
                        <span class="chip">Postman</span>
                        <span class="chip">Scrum</span>
                        <span class="chip">Confluence</span>
                    </div>
                </div>

                <!-- PIE -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-bs-dismiss="modal" style="font-size: 13px;">Cerrar</button>
                </div>

            </div>
        </div>
    </div>



    <!-- CURSOS -->
    <section id="courses">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12">
                    <div class="feature-title">
                        <h4 style="font-size: 40px; text-align: center;"><strong>Cursos disponibles</strong></h4>
                        <small style="font-size: 22px; text-align: center; display: block;">Comienza tu formación en <strong>BlueSky Financial</strong>
                        </small>

                        <!-- Botón centrado -->
                        <div class="text-center" style="margin-top: 10px;">
                            <asp:UpdatePanel ID="updCursos" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>

                                    <asp:Button ID="btnExplorarCursos"
                                        runat="server"
                                        Text="Explorar más cursos"
                                        CssClass="section-btn section-btn--alt btn btn-default"
                                        BackColor="#FFD400"
                                        ForeColor="Black"
                                        UseSubmitBehavior="false"
                                        OnClick="btnExplorarCursos_Click"
                                        Style="font-size: 18px; padding: 6px 14px;" />

                                </ContentTemplate>

                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="btnExplorarCursos" EventName="Click" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </div>
                    </div>

                    <div class="owl-carousel owl-theme owl-courses">
                        <div class="item">
                            <div class="courses-thumb">
                                <div class="courses-top">
                                    <div class="courses-image">
                                        <img src="images/ciberseguridad.jpeg" class="img-responsive" alt="">
                                    </div>
                                </div>
                                <div class="courses-detail">
                                    <h3><a href="#">Ciberseguridad</a></h3>
                                    <p>Aprende los fundamentos, objetivos y alcances de la ciberseguridad para integrarte eficazmente en la protección de la información y los sistemas digitales.</p>
                                </div>

                                <div class="courses-info" style="display: flex; justify-content: center;">
                                    <div class="courses-author">
                                        <span style="text-align: center;"><strong>Equipo BlueSky</strong></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="item">
                            <div class="courses-thumb">
                                <div class="courses-top">
                                    <div class="courses-image">
                                        <img src="images/compliance.jpeg" class="img-responsive" alt="">
                                    </div>
                                </div>

                                <div class="courses-detail">
                                    <h3><a href="#">Compliance y Ética Corporativa</a></h3>
                                    <p>
                                        Conoce los principios, objetivos y alcances del Compliance y la Ética Corporativa para integrarte eficazmente en la 
                                        promoción de la integridad y el cumplimiento normativo en la organización.
                                    </p>
                                </div>

                                <div class="courses-info" style="display: flex; justify-content: center;">
                                    <div class="courses-author">
                                        <span style="text-align: center;"><strong>Equipo BlueSky</strong></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="item">
                            <div class="courses-thumb">
                                <div class="courses-top">
                                    <div class="courses-image">
                                        <img src="images/MARKETING DIGITAL.jpeg" class="img-responsive" alt="">
                                    </div>
                                </div>

                                <div class="courses-detail">
                                    <h3><a href="#">Marketing Digital</a></h3>
                                    <p>Conoce las estrategias, herramientas y fundamentos del Marketing Digital para integrarte eficazmente en la promoción y posicionamiento de marcas en entornos online.</p>
                                </div>

                                <div class="courses-info" style="display: flex; justify-content: center;">
                                    <div class="courses-author">
                                        <span style="text-align: center;"><strong>Equipo BlueSky</strong></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="item">
                            <div class="courses-thumb">
                                <div class="courses-top">
                                    <div class="courses-image">
                                        <img src="images/metodologia agil.jpeg" class="img-responsive" alt="">
                                    </div>
                                </div>

                                <div class="courses-detail">
                                    <h3><a href="#">Introduccion a Scrum y Metologías Ágiles</a></h3>
                                    <p>
                                        Conoce los principios, roles y prácticas de Scrum y las Metodologías Ágiles para integrarte eficazmente en equipos de 
                                        trabajo orientados a la colaboración y la mejora continua.
                                    </p>
                                </div>

                                <div class="courses-info" style="display: flex; justify-content: center;">
                                    <div class="courses-author">
                                        <span style="text-align: center;"><strong>Equipo BlueSky</strong></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="item">
                            <div class="courses-thumb">
                                <div class="courses-top">
                                    <div class="courses-image">
                                        <img src="images/excel intermedio.jpg" class="img-responsive" alt="">
                                    </div>
                                </div>

                                <div class="courses-detail">
                                    <h3><a href="#">Herramientas de Excel Intermedio</a></h3>
                                    <p>
                                        Conoce las funciones, herramientas y técnicas de Excel Intermedio para integrarte eficazmente en el análisis, organización
                                        y presentación de información en el entorno laboral..
                                    </p>
                                </div>

                                <div class="courses-info" style="display: flex; justify-content: center;">
                                    <div class="courses-author">
                                        <span style="text-align: center;"><strong>Equipo BlueSky</strong></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </div>
    </section>




    <!-- TESTIMONIAL -->
    <section id="testimonial" class="testimonial-section" style="padding: 60px 0; background: #f7f9fc;">
        <div class="container">

            <asp:UpdatePanel ID="updTestimonial" runat="server" UpdateMode="Conditional">
                <ContentTemplate>

                    <!-- Título -->
                    <div class="row mb-4">
                        <div class="col-12 text-center">
                            <h4 style="font-size: 28px; margin-bottom: 5px;"><strong>Experiencias de nuestros estudiantes</strong></h4>
                            <small style="font-size: 16px; color: #777;">Así evalúan la plataforma quienes ya la han usado.</small>
                        </div>
                    </div>

                    <!-- LISTA DE RESEÑAS -->
                    <div class="row justify-content-center">
                        <div class="col-12 text-center">
                            <div class="row justify-content-center g-4">
                                <asp:Repeater ID="rptResenas" runat="server">
                                    <ItemTemplate>
                                        <div class="col-lg-4 col-md-6 col-sm-12 d-flex justify-content-center">
                                            <article class="tst-card pro-tst-card text-center">
                                                <div class="tst-avatar-wrap mb-2">
                                                    <img src='<%# GetAvatar(Eval("perssexo")) %>'
                                                        alt="Avatar estudiante"
                                                        class="tst-avatar-img" />
                                                </div>

                                                <h5 class="tst-name mb-1">
                                                    <%# Eval("nombre_publico") %>
                                                </h5>

                                                <span class="tst-meta d-block mb-2">
                                                    <%# Eval("fecha", "Creada el {0:dd-MM-yyyy HH:mm}") %>
                                                </span>

                                                <p class="tst-text mb-3">
                                                    <%# Eval("texto") %>
                                                </p>

                                                <div class="tst-stars">
                                                    <%# RenderStars(Eval("puntaje")) %>
                                                </div>
                                            </article>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>

                    <!-- BOTÓN CENTRADO PARA ESCRIBIR RESEÑA -->
                    <div class="row mt-3">
                        <div class="col-12 text-center">
                            <button type="button"
                                class="btn btn-primary"
                                style="padding: 10px 22px; border-radius: 999px; font-weight: 600;"
                                data-bs-toggle="modal"
                                data-bs-target="#modalResena">
                                Escribir una reseña
                            </button>
                        </div>
                    </div>

                    <!-- MODAL PARA CREAR RESEÑA -->
                    <div class="modal fade" id="modalResena" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-lg">
                            <div class="modal-content shadow-lg rounded">

                                <div class="modal-header bg-warning text-dark">
                                    <h5 class="modal-title w-100 text-center">Comparte tu experiencia</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>

                                <div class="modal-body px-4 py-3 text-start">
                                    <p class="text-muted mb-4">Cuéntanos tu experiencia con nuestros cursos. Tu opinión ayuda a mejorar.</p>

                                    <div class="form-group mt-3">
                                        <label class="text-start"><strong>Calificación *</strong></label>
                                        <asp:DropDownList ID="ddlPuntaje" runat="server" CssClass="form-control">
                                            <asp:ListItem Value="">Selecciona una calificación</asp:ListItem>
                                            <asp:ListItem Value="5">★★★★★ - Excelente</asp:ListItem>
                                            <asp:ListItem Value="4">★★★★☆ - Muy bueno</asp:ListItem>
                                            <asp:ListItem Value="3">★★★☆☆ - Bueno</asp:ListItem>
                                            <asp:ListItem Value="2">★★☆☆☆ - Regular</asp:ListItem>
                                            <asp:ListItem Value="1">★☆☆☆☆ - Malo</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>

                                    <div class="form-group mt-3">
                                        <label class="text-start"><strong>Tu reseña *</strong></label>
                                        <asp:TextBox ID="txtTextoResena" runat="server"
                                            CssClass="form-control"
                                            TextMode="MultiLine"
                                            Rows="4"
                                            MaxLength="100"
                                            onkeyup="actualizarContadorResena(this);"
                                            oninput="actualizarContadorResena(this);"
                                            placeholder="Escribe aquí tu experiencia..." />
                                        <small id="contadorResena" class="text-muted">0 / 100 caracteres</small>
                                    </div>

                                </div>

                                <div class="modal-footer px-4 py-3">
                                    <asp:Button ID="btnPublicarResena"
                                        runat="server"
                                        Text="Publicar reseña"
                                        CssClass="btn btn-success"
                                        UseSubmitBehavior="false"
                                        OnClick="btnPublicarResena_Click" />

                                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                                        Cancelar
                                    </button>
                                </div>

                            </div>
                        </div>
                    </div>

                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnPublicarResena" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>

        </div>
    </section>

    <!-- CONTACT -->
<section id="contact">
    <div class="container">

        <asp:UpdatePanel ID="updContact" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <div class="row">
                    <!-- FORMULARIO -->
                    <div class="col-md-6 col-sm-12">
                        <div id="contactForm" role="form">
                            <div class="feature-title" style="position: relative;">
                                <h4 style="color: white;">Contáctanos<br>
                                    <small>Estamos aquí para ayudarte, ¿tienes algún problema?</small>
                                </h4>
                                <div style="position: absolute; bottom: 0; left: 0; right: 0; height: 0 !important; background: none !important;"></div>
                            </div>

                            <div class="col-md-12 col-sm-12">
                                <!-- RUT -->
                                <asp:TextBox ID="txtRut"
                                    runat="server"
                                    ClientIDMode="Static"
                                    CssClass="form-control"
                                    placeholder="Ingresa tu RUT" />
                                <br />
                                <!-- MOTIVO -->
                                <asp:TextBox ID="txtMotivo"
                                    runat="server"
                                    ClientIDMode="Static"
                                    CssClass="form-control"
                                    TextMode="MultiLine"
                                    placeholder="Describe brevemente tu consulta o mensaje" />
                            </div>

                            <br /><br /><br />
                            <div class="col-md-4 col-sm-12">
                                <asp:Button ID="btnContact"
                                    runat="server"
                                    ClientIDMode="Static"
                                    Text="Enviar Mensaje"
                                    UseSubmitBehavior="false"
                                    OnClick="btnContact_Click"
                                    Style="background-color: #1a1a1a; color: #ffffff; border: 2px solid #333; padding: 12px 25px; font-size: 16px; font-weight: 600; border-radius: 8px; transition: 0.3s ease; cursor: pointer;" />
                            </div>
                        </div>
                    </div>

                    <!-- IMAGEN DERECHA -->
                    <div class="col-md-6 col-sm-12">
                        <figure class="contact-image-pro"
                            aria-label="Imagen de BlueSky"
                            style="display: flex; justify-content: center; align-items: center; padding: 20px;">

                            <button type="button"
                                class="img-frame-min"
                                id="blueskyFrame"
                                aria-label="Imagen BlueSky"
                                data-tilt
                                data-tilt-max="10"
                                data-tilt-scale="1.05"
                                style="padding: 0; border: none; background: none; max-width: 100%;">

                                <img src="<%: ResolveUrl("~/images/BLUESKYYYY.png") %>"
                                    alt="BlueSky Financial"
                                    id="blueskyImg"
                                    loading="lazy"
                                    style="width: 100%; max-width: 480px; height: auto; border-radius: 10px; object-fit: contain;" />

                            </button>
                        </figure>
                    </div>
                </div>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnContact" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>

    </div>
</section>


    <div class="modal fade" id="modalLoginRequired" tabindex="-1"
        aria-labelledby="loginRequiredLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">

                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title" id="loginRequiredLabel">
                        <i class="fa fa-exclamation-triangle"></i>Iniciar Sesión Requerido
                    </h5>
                    <button type="button" class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Cerrar">
                    </button>
                </div>

                <div class="modal-body">
                    Para acceder a los cursos debes iniciar sesión.
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default"
                        data-bs-dismiss="modal">
                        Cancelar
                    </button>
                    <button type="button" class="btn btn-primary"
                        onclick="window.location='IniciarSesion.aspx'">
                        Iniciar Sesión
                    </button>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- 1) Máscaras de entrada: RUT y CELULAR -->
<script>
    // Engancha restricciones de input para RUT y teléfono
    function attachInputMasks() {
        // RUT solo números
        var rutInput = document.getElementById("txtRut");
        if (rutInput) {
            rutInput.oninput = function () {
                var value = rutInput.value || "";
                value = value.replace(/[^0-9]/g, ""); // solo dígitos
                rutInput.value = value;
            };
        }

        // TELÉFONO: solo números, máximo 9 dígitos
        var telInput = document.getElementById("txtTelefono");
        if (telInput) {
            telInput.oninput = function () {
                var value = telInput.value || "";
                value = value.replace(/[^0-9]/g, ""); // solo dígitos
                if (value.length > 9) {
                    value = value.substring(0, 9);
                }
                telInput.value = value;
            };
        }
    }

    // Al cargar la página
    document.addEventListener("DOMContentLoaded", function () {
        attachInputMasks();
    });
</script>

<!-- 2) Postbacks parciales (UpdatePanel) + reenganchar máscaras -->
<script>
    // Cada vez que termina un postback parcial (UpdatePanel)
    if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {

            // 1) Limpiar posibles backdrops viejos de Bootstrap
            document.querySelectorAll('.modal-backdrop').forEach(function (b) {
                b.remove();
            });

            // 2) Quitar clase que bloquea scroll
            document.body.classList.remove('modal-open');

            // 3) Forzar que el body vuelva a ser scrolleable
            document.body.style.overflow = 'auto';
            document.body.style.paddingRight = '0';

            // Por si acaso, también en <html>
            document.documentElement.style.overflow = 'auto';

            // 4) Volver a enganchar máscaras de RUT y TELÉFONO
            if (typeof attachInputMasks === "function") {
                attachInputMasks();
            }
        });
    }
</script>

<!-- 3) Contador de caracteres para la reseña -->
<script>
    function actualizarContadorResena(textbox) {
        var max = 100;
        var texto = textbox.value || "";

        // Limitar realmente el máximo
        if (texto.length > max) {
            textbox.value = texto.substring(0, max);
        }

        // Actualizar contador
        var contador = document.getElementById("contadorResena");
        if (contador) {
            contador.innerText = textbox.value.length + " / " + max + " caracteres";
        }
    }
</script>

<!-- 4) Validar acceso a cursos (SweetAlert2) -->
<script type="text/javascript">
    function validarAccesoCursos() {
        // Esta variable se reemplaza en el servidor
        var isLogged = <%= Session["Username"] == null ? "false" : "true" %>;

        if (!isLogged) {
            Swal.fire({
                title: "Inicia sesión",
                text: "Debes iniciar sesión para acceder a los cursos.",
                icon: "warning",
                showCancelButton: true,
                confirmButtonText: "Iniciar sesión",
                cancelButtonText: "Cancelar"
            }).then(function (result) {
                if (result.isConfirmed) {
                    window.location.href = 'IniciarSesion.aspx';
                }
            });

            // Bloquea el postback si no está logueado
            return false;
        }

        // Si está logueado → se permite el postback
        return true;
    }
</script>



</asp:Content>
