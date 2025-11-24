<%@ Page Title="SOPORTE - SOLICITUDES" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Soporte.aspx.cs" Inherits="bluesky.Admin.Soporte" %>

<%@ MasterType VirtualPath="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .gvPager {
            padding-top: 0 !important;
            padding-bottom: 0 !important;
        }

            .gvPager table {
                margin: 10px auto;
            }

            .gvPager a,
            .gvPager span {
                padding: 6px 10px !important;
                border-radius: 6px;
            }

                .gvPager a:hover {
                    background-color: #f1f1f1;
                }

            .gvPager span {
                background-color: #0d6efd;
                color: #fff;
            }

        .premium-footer {
            background: linear-gradient(to right, #f8f9fa, #ffffff);
            border-top: 1px solid #e3e6ea;
            padding: 18px 25px !important;
        }

        .btn-mostrar {
            padding: 0.25rem 1rem;
            min-width: 120px;
            white-space: nowrap;
        }

        .header-toolbar {
            max-width: 420px;
        }

        /* ===============================
           BADGES DE ESTADO (Visual PRO)
           =============================== */

        .badge-estado-pendiente {
            background: #ffe79b; /* amarillo pastel */
            color: #000; /* texto negro */
            border: 1px solid #d4b441; /* borde dorado */
            padding: 4px 10px;
            font-weight: 600;
            border-radius: 50px !important;
            font-size: 12px;
            display: inline-block;
        }

        .badge-estado-atendida {
            background: #1FA463; /* verde profesional */
            color: white;
            padding: 4px 10px;
            font-weight: 600;
            border-radius: 50px !important;
            font-size: 12px;
            display: inline-block;
        }

        /* ===============================
           BOTONES DE ACCIONES
           =============================== */

        .btn-pendiente {
            background: #fff8dc !important; /* amarillo muy claro */
            color: #8a6d00 !important; /* texto dorado oscuro */
            border: 2px solid #f5c542 !important; /* borde dorado */
            padding: 4px 12px;
            font-weight: 600;
            border-radius: 50px;
            font-size: 13px;
            transition: 0.2s;
        }

            .btn-pendiente:hover {
                background: #ffe08a !important;
                border-color: #d2a200 !important;
                color: #5c4a00 !important;
            }

        .btn-atendida {
            background: #1FA463 !important; /* verde profesional */
            color: #ffffff !important;
            border: none;
            padding: 4px 12px;
            font-weight: 600;
            border-radius: 50px;
            font-size: 13px;
            transition: 0.2s;
        }

            .btn-atendida:hover {
                background: #16844e !important;
            }

        /* ===============================
           BOTÓN EXCEL ESTILO UIVERSE
           =============================== */
        .container-btn-file {
            display: flex;
            position: relative;
            justify-content: center;
            align-items: center;
            background-color: #307750;
            color: #fff;
            border-style: none;
            padding: 0.55rem 1.2rem;
            border-radius: 0.5em;
            overflow: hidden;
            z-index: 1;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            box-shadow: 4px 8px 10px -3px rgba(0, 0, 0, 0.356);
            transition: all 250ms;
            text-decoration: none !important;
        }

            .container-btn-file > svg {
                margin-right: 0.6em;
            }

            .container-btn-file::before {
                content: "";
                position: absolute;
                height: 100%;
                width: 0;
                border-radius: 0.5em;
                background-color: #469b61;
                z-index: -1;
                transition: all 350ms;
            }

            .container-btn-file:hover::before {
                width: 100%;
            }
    </style>


    <div class="container-fluid my-5">
        <div class="row justify-content-center">
            <div class="col-12" style="max-width: 85%; margin: 0 auto;">

                <div class="card shadow-lg border-0 rounded-3 overflow-hidden">

                    <!-- HEADER -->
                    <div class="card-header bg-primary text-white py-3">
                        <div class="d-flex align-items-center justify-content-between gap-3 flex-wrap">

                            <!-- BOTÓN EXCEL A LA IZQUIERDA -->
                            <asp:LinkButton ID="btnExportarExcel" runat="server"
                                CssClass="container-btn-file"
                                OnClick="btnExportarExcel_Click">
                                <svg fill="#fff" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 50 50">
                                    <path d="M28.8125 .03125L.8125 5.34375C.339844 
                                    5.433594 0 5.863281 0 6.34375L0 43.65625C0 
                                    44.136719 .339844 44.566406 .8125 44.65625L28.8125 
                                    49.96875C28.875 49.980469 28.9375 50 29 50C29.230469 
                                    50 29.445313 49.929688 29.625 49.78125C29.855469 49.589844 
                                    30 49.296875 30 49L30 1C30 .703125 29.855469 .410156 29.625 
                                    .21875C29.394531 .0273438 29.105469 -.0234375 28.8125 .03125ZM32 
                                    6L32 13L34 13L34 15L32 15L32 20L34 20L34 22L32 22L32 27L34 27L34 
                                    29L32 29L32 35L34 35L34 37L32 37L32 44L47 44C48.101563 44 49 
                                    43.101563 49 42L49 8C49 6.898438 48.101563 6 47 6ZM36 13L44 
                                    13L44 15L36 15ZM6.6875 15.6875L11.8125 15.6875L14.5 21.28125C14.710938 
                                    21.722656 14.898438 22.265625 15.0625 22.875L15.09375 22.875C15.199219 
                                    22.511719 15.402344 21.941406 15.6875 21.21875L18.65625 15.6875L23.34375 
                                    15.6875L17.75 24.9375L23.5 34.375L18.53125 34.375L15.28125 
                                    28.28125C15.160156 28.054688 15.035156 27.636719 14.90625 
                                    27.03125L14.875 27.03125C14.8125 27.316406 14.664063 27.761719 
                                    14.4375 28.34375L11.1875 34.375L6.1875 34.375L12.15625 25.03125ZM36 
                                    20L44 20L44 22L36 22ZM36 27L44 27L44 29L36 29ZM36 35L44 35L44 37L36 37Z"/>
                                </svg>
                                Descargar Excel
                            </asp:LinkButton>

                            <!-- TÍTULO CENTRADO -->
                            <div class="flex-grow-1 text-center">
                                <h5 class="mb-0">
                                    <i class='bx bx-support'></i>SOPORTE - SOLICITUDES
                                </h5>
                            </div>

                            <!-- BUSCADOR + MOSTRAR TODO -->
                            <div class="d-flex align-items-center gap-2 header-toolbar">
                                <asp:TextBox ID="txtBuscar" runat="server"
                                    CssClass="form-control form-control-sm"
                                    placeholder="Buscar por RUT, nombre o problema..." />

                                <asp:LinkButton ID="btnBuscar" runat="server"
                                    CssClass="btn btn-light btn-sm"
                                    OnClick="btnBuscar_Click"
                                    ToolTip="Buscar">
                                    <i class='bx bx-search'></i>
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnMostrarTodo" runat="server"
                                    CssClass="btn btn-outline-light btn-sm btn-mostrar"
                                    OnClick="btnMostrarTodo_Click">
                                    Mostrar todo
                                </asp:LinkButton>
                            </div>

                        </div>
                    </div>

                    <!-- CUERPO -->
                    <asp:UpdatePanel ID="updSoporte" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>

                            <div class="card-body px-4 py-3">
                                <div class="table-responsive" style="max-height: 500px; overflow-y: auto;">

                                    <asp:GridView ID="gvCustomers" runat="server"
                                        AutoGenerateColumns="false"
                                        CssClass="table table-striped table-hover table-bordered mb-0 text-center align-middle"
                                        AllowPaging="true"
                                        PageSize="10"
                                        DataKeyNames="contacto_id"
                                        OnPageIndexChanging="gvCustomers_PageIndexChanging"
                                        OnRowCommand="gvCustomers_RowCommand"
                                        OnRowDataBound="gvCustomers_RowDataBound"
                                        Font-Size="13px"
                                        HeaderStyle-Font-Size="14px">

                                        <HeaderStyle CssClass="table-primary sticky-top" />
                                        <PagerStyle CssClass="gvPager" HorizontalAlign="Center" />

                                        <Columns>
                                            <asp:BoundField DataField="contacto_id" HeaderText="ID" />
                                            <asp:BoundField DataField="rut" HeaderText="RUT" />
                                            <asp:BoundField DataField="nombre" HeaderText="NOMBRE" />
                                            <asp:BoundField DataField="apellido_paterno" HeaderText="AP. PATERNO" />
                                            <asp:BoundField DataField="apellido_materno" HeaderText="AP. MATERNO" />
                                            <asp:BoundField DataField="email" HeaderText="EMAIL" />
                                            <asp:BoundField DataField="persfono" HeaderText="TELÉFONO" />
                                            <asp:BoundField DataField="problema" HeaderText="PROBLEMA" />
                                            <asp:BoundField DataField="fecha" HeaderText="FECHA"
                                                DataFormatString="{0:dd-MM-yyyy HH:mm}" HtmlEncode="false" />

                                            <asp:TemplateField HeaderText="ESTADO">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblEstado" runat="server"
                                                        Text='<%# (Eval("estado").ToString() == "0" ? "Pendiente" : "Atendida") %>'
                                                        CssClass='<%# (Eval("estado").ToString() == "0"
                    ? "badge-estado-pendiente"
                    : "badge-estado-atendida") %>'>
                                                    </asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="ACCIONES">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btnPendiente" runat="server"
                                                        CommandName="CambiarEstado"
                                                        CommandArgument='<%# Eval("contacto_id") + "|0" %>'
                                                        CssClass="btn btn-pendiente me-1">
                Pendiente
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="btnAtendida" runat="server"
                                                        CommandName="CambiarEstado"
                                                        CommandArgument='<%# Eval("contacto_id") + "|1" %>'
                                                        CssClass="btn btn-atendida">
                Atendida
                                                    </asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>

                            <!-- FOOTER -->
                            <div class="card-footer premium-footer small">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="footer-center">Mostrando solicitudes de soporte recibidas desde el portal.
                                    </span>
                                    <asp:Label ID="lblResumen" runat="server" CssClass="footer-range"></asp:Label>
                                </div>
                            </div>

                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="gvCustomers" EventName="PageIndexChanging" />
                            <asp:AsyncPostBackTrigger ControlID="btnBuscar" EventName="Click" />
                            <asp:AsyncPostBackTrigger ControlID="btnMostrarTodo" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>

                </div>

            </div>
        </div>
    </div>

</asp:Content>
