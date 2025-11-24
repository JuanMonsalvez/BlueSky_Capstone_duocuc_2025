<%@ Page Title="Curso Word Básico" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WordBasico.aspx.cs" Inherits="bluesky.CURSOS.WordBasico" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ========= Estilos ========= -->
    <style>
        .card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            box-shadow: 0 8px 22px rgba(16,24,40,.06);
        }

        .card-header {
            padding: 14px 18px;
            border-bottom: 1px solid #e9eef5;
            background: #fff;
        }

            .card-header h1 {
                margin: 0;
                font-weight: 700;
            }

        .info-inline {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            font-size: 0.95rem;
            color: #555;
            margin-top: 6px;
            justify-content: center;
            align-items: center;
        }

            .info-inline div {
                display: flex;
                align-items: center;
                gap: 6px;
            }

        .card-body {
            padding: 18px;
        }

        /* Contenedor del visor (para overlay) */
        .pdf-container {
            position: relative;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            overflow: hidden;
            background: #fff;
        }

        /* Iframe visor PDF */
        #pdfViewer {
            width: 100%;
            height: 520px;
            border: 0;
            display: block;
        }

        @media (max-width: 767px) {
            #pdfViewer {
                height: 380px;
            }
        }

        .btn {
            border-radius: 10px;
            padding: 10px 14px;
            transition: background 0.2s ease, transform 0.06s ease;
            cursor: pointer;
        }

            .btn:active {
                transform: translateY(1px);
            }

        .btn-outline-primary:hover {
            background: rgba(37,99,235,.06);
        }

        .actions-bar {
            display: flex;
            justify-content: center;
            gap: 100px;
            flex-wrap: wrap;
            margin-top: 16px;
        }

        /* ===== Overlay de controles dentro del visor ===== */
        .pdf-overlay {
            position: absolute;
            top: 10px;
            right: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
            z-index: 5;
            pointer-events: none;
        }

        .pdf-fs-toggle {
            pointer-events: auto;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 8px;
            background: rgba(255,255,255,.95);
            border: 1px solid rgba(0,0,0,.08);
            box-shadow: 0 2px 8px rgba(16,24,40,.12);
            text-decoration: none;
            transition: transform .06s ease, background .2s ease;
        }

            .pdf-fs-toggle:hover {
                background: #fff;
            }

            .pdf-fs-toggle:active {
                transform: translateY(1px);
            }

            .pdf-fs-toggle svg {
                width: 18px;
                height: 18px;
            }

        /* Reducir espacio entre botón y card */
        .return-wrap {
            position: static;
            margin-top: 0.5rem;
        }

        #material {
            margin-top: 0 !important;
        }

        .course-eval-card {
            margin-top: 0 !important;
        }

        /* === Botón FAQ (opcional; aquí solo se usa para instrucciones) === */
        .faq-button {
            position: relative;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 38px;
            height: 38px;
            border: 1px solid #2563eb;
            border-radius: 10px;
            background: #2563eb;
            box-shadow: 0 2px 8px rgba(16,24,40,.12);
            cursor: pointer;
            transition: transform .06s ease, background .2s ease;
        }

            .faq-button:hover {
                background: #1d4ed8;
            }

            .faq-button:active {
                transform: translateY(1px);
            }

            .faq-button svg {
                width: 18px;
                height: 18px;
                fill: #fff;
            }

            .faq-button .tooltip {
                position: absolute;
                left: 50%;
                bottom: calc(100% + 8px);
                transform: translateX(-50%);
                padding: 4px 8px;
                background: #111827;
                color: #fff;
                font-size: 12px;
                border-radius: 6px;
                white-space: nowrap;
                opacity: 0;
                pointer-events: none;
                transition: opacity .15s ease;
            }

            .faq-button:hover .tooltip {
                opacity: 1;
            }
    </style>

    <!--OCULTO-->
    <asp:Label ID="lblUsuario" runat="server" CssClass="text-primary" />
    <!-- Mensaje de intentos máximos -->
    <asp:Literal ID="ltlMensajeIntentosMax" runat="server"></asp:Literal>

    <!-- Botón volver -->
    <br />
    <div class="container mt-2 mb-0 p-0 return-wrap">
        <div class="d-flex justify-content-start">
            <asp:Button ID="btnVolver" runat="server"
                CssClass="btn btn-danger btn-page-block-custom"
                Text="Volver a Cursos"
                OnClick="btnVolver_Click" />
        </div>
    </div>
    <br />

    <!-- ========= CARD: Material del curso ========= -->
    <section id="material" class="container mt-2 mb-0 p-0">
        <div class="card course-eval-card">
            <div class="card-header">
                <h1 class="h5 m-0 text-center" style="font-size: 24px;">
                    Contenido del curso & evaluación — Word Básico
                </h1>
                <br />
                <!-- Información -->
                <div class="info-inline" style="font-size: 15px;">
                    <div><i class="fa fa-file-powerpoint-o"></i><strong> Material:</strong> PPT</div>
                    <div><i class="fa fa-check-circle-o"></i><strong> Previsualización:</strong> PDF</div>
                    <div><i class="fa fa-clock-o"></i><strong> Tienes 45 min</strong> para completar la evaluación</div>
                    <div><i class="fa fa-list-ol"></i>15 preguntas</div>
                </div>

                <!-- Botones rápidos -->
                <div class="actions-bar">
                    <asp:Button
                        ID="btnDescargarPPT"
                        runat="server"
                        Text="Descargar PPT"
                        CssClass="btn btn-warning"
                        OnClick="btnDescargarPPT_Click" />

                    <asp:Button
                        ID="btnIniciarEvaluacion"
                        runat="server"
                        Text="Iniciar evaluación"
                        CssClass="btn btn-primary"
                        OnClientClick="return showConfirmStart();" />
                </div>
            </div>

            <div class="card-body">
                <!-- Visor con overlay interno -->
                <div id="pdfContainer" class="pdf-container">
                    <!-- Control incrustado (pantalla completa) -->
                    <div class="pdf-overlay">
                        <a id="pdfFsToggle"
                           href="javascript:void(0);"
                           class="pdf-fs-toggle"
                           role="button"
                           aria-label="Pantalla completa"
                           title="Pantalla completa"
                           onclick="openFullScreen()">
                            <!-- Icono entrar a fullscreen -->
                            <svg id="iconEnter" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                      d="M8 3H5a2 2 0 0 0-2 2v3M16 3h3a2 2 0 0 1 2 2v3M8 21H5a2 2 0 0 1-2-2v-3M16 21h3a2 2 0 0 0 2-2v-3" />
                                <path stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                      d="M9 9H6V6M15 9h3V6M9 15H6v3M15 15h3v3" />
                            </svg>
                        </a>
                    </div>

                    <!-- Iframe del PDF -->
                    <iframe
                        id="pdfViewer"
                        title="Vista previa del contenido (PDF)"
                        src="<%: ResolveUrl("~/pdf/WORD-BASICO.pdf") %>#page=1&view=FitH&pagemode=none"
                        allow="fullscreen"></iframe>
                </div>

            </div>
        </div>
    </section>

    <!-- ========= MODAL: Confirmación inicio evaluación ========= -->
    <div class="modal fade" id="confirmStartModal" tabindex="-1" aria-labelledby="confirmStartTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-3 shadow">
                <div class="modal-header position-relative">
                    <h5 class="modal-title mb-0" id="confirmStartTitle" style="text-align: center; font-size: 18px;">Confirmación</h5>
                    <button type="button"
                        class="close position-absolute"
                        style="top: 0; right: .75rem; margin-top: -0.25rem;"
                        data-dismiss="modal"
                        aria-label="Cerrar">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body text-center">
                    <p class="mb-3" style="font-size: 20px"><strong>¿Está seguro que desea iniciar la evaluación?</strong></p>
                    <p class="mb-3" style="font-size: 18px"><strong>Tendrás 45 minutos para realizar la prueba.</strong></p>
                    <p class="mb-0" style="color: red; font-size: 16px;">Si vuelves al menú principal después de aceptar, ocuparás 1 de tus 3 intentos disponibles.</p>
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal" data-bs-dismiss="modal" onclick="confirmStartNo()">No</button>

                    <!-- Botón servidor: inicia flujo igual que Excel -->
                    <asp:Button
                        ID="btnConfirmarInicioEval"
                        runat="server"
                        CssClass="btn btn-primary"
                        Text="Sí"
                        OnClick="btnConfirmarInicioEval_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL: Instrucciones -->
    <div class="modal fade" id="faqModal" tabindex="-1" aria-labelledby="faqTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-3 shadow">
                <div class="modal-header">
                    <h5 class="modal-title mb-0" id="faqTitle" style="text-align: center; font-size: 18px;"><strong>Instrucciones</strong></h5>
                    <button type="button"
                        class="close position-absolute"
                        style="top: 0; right: .75rem; margin-top: -0.25rem;"
                        data-dismiss="modal"
                        data-bs-dismiss="modal"
                        aria-label="Cerrar">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="font-size: 16px;">
                    <p><strong>- La prueba consta de 15 preguntas.</strong></p>
                    <p>- Cada pregunta tiene <strong>4 alternativas</strong>.</p>
                    <p>- Debes seleccionar <strong>solo una alternativa</strong>.</p>
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-primary" data-dismiss="modal" data-bs-dismiss="modal">Entendido</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL: Curso ya aprobado -->
    <div class="modal fade" id="modalCursoAprobado" tabindex="-1" aria-labelledby="aprobadoTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-3 shadow">

                <div class="modal-header">
                    <h5 class="modal-title" id="aprobadoTitle">Curso ya aprobado</h5>

                    <button type="button"
                        class="btn-close"
                        aria-label="Cerrar"
                        onclick="_hideModal('modalCursoAprobado')">
                    </button>
                </div>

                <div class="modal-body text-center">
                    <p class="mb-3" style="font-size: 18px;">
                        <strong>Ya has aprobado este curso en un intento anterior.</strong>
                    </p>
                    <p class="mb-0" style="font-size: 16px;">
                        Puedes descargar nuevamente tu certificado o realizar la evaluación otra vez (máx. 3 intentos).
                    </p>
                </div>

                <div class="modal-footer justify-content-center">
                    <!-- Botón Realizar evaluación igualmente -->
                    <asp:Button
                        ID="btnRealizarEvalIgual"
                        runat="server"
                        CssClass="btn btn-secondary"
                        Text="Realizar evaluación igualmente"
                        Visible="false"
                        OnClick="btnRealizarEvalIgual_Click" />

                    <!-- Botón Descargar certificado -->
                    <asp:Button
                        ID="btnDescargarCertificadoAprobado"
                        runat="server"
                        CssClass="btn btn-primary"
                        Text="Descargar certificado"
                        CausesValidation="false"
                        OnClick="btnDescargarCertificadoAprobado_Click" />
                </div>

            </div>
        </div>
    </div>

    <!-- ========= Scripts ========= -->
    <script type="text/javascript">
        // Mostrar modal (simple, como en Excel)
        function _showModal(id) {
            var el = document.getElementById(id);
            if (!el) return;
            el.classList.add('show');
            el.style.display = 'block';
            el.removeAttribute('aria-hidden');

            var backdrop = document.createElement('div');
            backdrop.className = 'modal-backdrop fade show custom-backdrop';
            document.body.appendChild(backdrop);
        }

        function _hideModal(id) {
            var el = document.getElementById(id);
            if (!el) return;

            el.classList.remove('show');
            el.style.display = 'none';
            el.setAttribute('aria-hidden', 'true');

            var backdrops = document.querySelectorAll('.custom-backdrop');
            backdrops.forEach(function (b) {
                if (b && b.parentNode) {
                    b.parentNode.removeChild(b);
                }
            });
        }

        function openFaq() {
            _showModal('faqModal');
        }

        function showConfirmStart() {
            _showModal('confirmStartModal');
            return false; // evita postback directo
        }

        function confirmStartNo() {
            _hideModal('confirmStartModal');
        }

        // Pantalla completa del PDF
        function openFullScreen() {
            var iframe = document.getElementById('pdfViewer');
            var base = '<%= ResolveUrl("~/pdf/WORD-BASICO.pdf") %>';
            iframe.src = base + '?v=' + Date.now() + '#page=1&view=FitH&pagemode=none';
            if (iframe.requestFullscreen) iframe.requestFullscreen();
            else if (iframe.webkitRequestFullscreen) iframe.webkitRequestFullscreen();
            else if (iframe.mozRequestFullScreen) iframe.mozRequestFullScreen();
            else if (iframe.msRequestFullscreen) iframe.msRequestFullscreen();
        }
    </script>

</asp:Content>
