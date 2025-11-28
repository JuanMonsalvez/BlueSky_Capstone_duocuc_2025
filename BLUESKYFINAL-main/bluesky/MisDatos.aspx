<%@ Page Title="MIS DATOS" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="MisDatos.aspx.cs"
    Inherits="bluesky.MisDatos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .premium-footer {
            background: linear-gradient(to right, #f8f9fa, #ffffff);
            border-top: 1px solid #e3e6ea;
            padding: 18px 25px !important;
        }

        /* ===========================
           BOTÓN FAQ MIS DATOS
           =========================== */
        .faq-button-misdatos {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            border: none;
            background-color: #0d6efd;
            background-image: linear-gradient(135deg, #0d6efd 0%, #6610f2 60%, #0dcaf0 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0px 8px 12px rgba(0, 0, 0, 0.18);
            position: relative;
            padding: 0;
        }

            .faq-button-misdatos svg {
                height: 1.2em;
                fill: #ffffff;
            }

            .faq-button-misdatos:hover svg {
                animation: jello-vertical-misdatos 0.7s both;
            }

        @keyframes jello-vertical-misdatos {
            0% {
                transform: scale3d(1, 1, 1);
            }

            30% {
                transform: scale3d(0.75, 1.25, 1);
            }

            40% {
                transform: scale3d(1.25, 0.75, 1);
            }

            50% {
                transform: scale3d(0.85, 1.15, 1);
            }

            65% {
                transform: scale3d(1.05, 0.95, 1);
            }

            75% {
                transform: scale3d(0.95, 1.05, 1);
            }

            100% {
                transform: scale3d(1, 1, 1);
            }
        }

        .faq-tooltip-misdatos {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            bottom: -6px; /* punto de partida, pegado al botón */
            top: auto; /* importante para que no use 'top' */
            opacity: 0;
            z-index: 10;
            background-image: linear-gradient(135deg, #0d6efd 0%, #6610f2 60%, #0dcaf0 100%);
            color: #ffffff;
            padding: 4px 8px;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition-duration: 0.2s;
            pointer-events: none;
            letter-spacing: 0.5px;
            font-size: 11px;
            white-space: nowrap;
        }


            .faq-tooltip-misdatos::before {
                position: absolute;
                content: "";
                width: 8px;
                height: 8px;
                background-color: #0d6efd;
                transform: rotate(45deg);
                top: -18%; /* ahora la “puntita” va arriba del tooltip */
                bottom: auto;
                transition-duration: 0.3s;
            }

        .faq-button-misdatos:hover .faq-tooltip-misdatos {
            bottom: -32px; /* se anima hacia abajo */
            top: auto;
            opacity: 1;
            transition-duration: 0.3s;
        }
    </style>

    <div class="container-fluid my-5">
        <div class="row justify-content-center">
            <div class="col-12" style="max-width: 85%; margin: 0 auto;">

                <div class="card shadow-lg border-0 rounded-3 overflow-hidden">

                    <div class="card-header bg-primary text-white py-3">
                        <div class="d-flex align-items-center justify-content-center gap-3">
                            <h5 class="mb-0">
                                <i class='bx bx-id-card'></i>MIS DATOS
                            </h5>

                            <!-- BOTÓN FAQ MIS DATOS -->
                            <button type="button"
                                class="faq-button-misdatos"
                                data-bs-toggle="modal"
                                data-bs-target="#modalMisDatosFaq"
                                aria-label="Información sobre modificación de datos">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" aria-hidden="true" focusable="false">
                                    <path
                                        d="M80 160c0-35.3 28.7-64 64-64h32c35.3 0 64 28.7 64 64v3.6c0 21.8-11.1 42.1-29.4 53.8l-42.2 27.1c-25.2 16.2-40.4 44.1-40.4 74V320c0 17.7 14.3 32 32 32s32-14.3 32-32v-1.4c0-8.2 4.2-15.8 11-20.2l42.2-27.1c36.6-23.6 58.8-64.1 58.8-107.7V160c0-70.7-57.3-128-128-128H144C73.3 32 16 89.3 16 160c0 17.7 14.3 32 32 32s32-14.3 32-32zm80 320a40 40 0 1 0 0-80 40 40 0 1 0 0 80z">
                                    </path>
                                </svg>
                                <span class="faq-tooltip-misdatos">Cómo actualizar mis datos</span>
                            </button>
                        </div>
                    </div>

                    <asp:UpdatePanel ID="updMisDatos" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>

                            <div class="card-body px-4 py-3">
                                <div class="table-responsive">
                                    <asp:GridView ID="gvMisDatos" runat="server"
                                        AutoGenerateColumns="false"
                                        CssClass="table table-hover table-bordered mb-0 text-center align-middle"
                                        Font-Size="13px"
                                        HeaderStyle-Font-Size="14px">
                                        <HeaderStyle CssClass="table-primary" />

                                        <Columns>
                                            <asp:BoundField DataField="RUTCompleto" HeaderText="RUT" />
                                            <asp:BoundField DataField="persnombre" HeaderText="NOMBRES" />
                                            <asp:BoundField DataField="perspatern" HeaderText="APELLIDO PATERNO" />
                                            <asp:BoundField DataField="persmatern" HeaderText="APELLIDO MATERNO" />
                                            <asp:BoundField DataField="perssexo" HeaderText="SEXO" />
                                            <asp:BoundField DataField="persemail" HeaderText="CORREO ELECTRONICO" />
                                            <asp:BoundField DataField="persdireccion" HeaderText="DIRECCION" />
                                            <asp:BoundField DataField="persfono" HeaderText="CELULAR" />
                                            <asp:BoundField DataField="persnacimiento" HeaderText="FECHA DE NACIMIENTO"
                                                DataFormatString="{0:dd-MM-yyyy}" HtmlEncode="false" />
                                        </Columns>
                                    </asp:GridView>

                                    <asp:Label ID="lblSinDatos" runat="server"
                                        CssClass="text-muted d-block mt-3 text-center"></asp:Label>
                                </div>
                            </div>

                            <div class="card-footer premium-footer small">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span>Información personal registrada en el sistema.</span>
                                    <asp:Label ID="lblResumen" runat="server"></asp:Label>
                                </div>
                            </div>

                        </ContentTemplate>
                    </asp:UpdatePanel>

                </div>

            </div>
        </div>
    </div>

    <!-- MODAL FAQ MIS DATOS -->
    <div class="modal fade" id="modalMisDatosFaq" tabindex="-1"
        aria-labelledby="modalMisDatosFaqLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title" id="modalMisDatosFaqLabel">Actualización de datos personales</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>

                <div class="modal-body">
                    <p class="mb-2">
                        Si necesitas modificar alguno de tus datos personales (dirección, correo, teléfono, etc.),
                        debes enviar una solicitud al área de soporte.
                    </p>
                    <p class="mb-0">
                        Para hacerlo, utiliza el formulario de la sección
                        <strong>Contacto</strong> del portal, indicando claramente el cambio que deseas realizar.
                    </p>
                </div>

                <div class="modal-footer justify-content-center">
                    <a href="<%: ResolveUrl("~/Default.aspx#contact") %>" class="btn btn-primary">Ir a soporte
                    </a>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cerrar
                    </button>
                </div>

            </div>
        </div>
    </div>

</asp:Content>
