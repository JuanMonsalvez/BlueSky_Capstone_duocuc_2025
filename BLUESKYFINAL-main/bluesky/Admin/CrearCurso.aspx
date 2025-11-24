<%@ Page Title="Crear Curso" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="CrearCurso.aspx.cs"
    Inherits="bluesky.Admin.CrearCurso" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .curso-wrapper {
            max-width: 720px;
            margin: 40px auto;
        }

        .curso-card {
            border: 0;
            border-radius: 18px;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.16);
            overflow: hidden;
            background: #ffffff;
        }

        .curso-header {
            background: radial-gradient(circle at top left, #38bdf8, #0d6efd);
            color: #ffffff;
            padding: 18px 22px;
        }

        .curso-title {
            margin: 0;
            font-size: 1.4rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

            .curso-title i {
                font-size: 1.8rem;
            }

        .curso-subtitle {
            margin: 4px 0 0;
            font-size: 0.9rem;
            opacity: .9;
        }

        .curso-body {
            padding: 22px 22px 10px;
        }

        .curso-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 16px 18px;
        }

        @media (min-width: 768px) {
            .curso-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        .curso-field-full {
            grid-column: 1 / -1;
        }

        .curso-label {
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 4px;
        }

        .curso-help {
            font-size: 0.78rem;
            color: #6b7280;
        }

        .curso-footer {
            padding: 14px 22px 18px;
            border-top: 1px solid #e5e7eb;
            background: #f9fafb;
        }

        .btn-crear-curso {
            border-radius: 999px;
            font-weight: 600;
            padding: 10px 22px;
            font-size: 0.95rem;
        }

        .curso-msg {
            font-size: 0.9rem;
            margin-top: 6px;
            display: inline-block;
        }
    </style>

    <!-- PANEL PRINCIPAL -->
    <asp:UpdatePanel ID="upCrearCurso" runat="server" UpdateMode="Conditional">
        <ContentTemplate>

            <div class="curso-wrapper">
                <div class="card curso-card">

                    <!-- HEADER -->
                    <div class="curso-header">
                        <h2 class="curso-title">
                            <i class='bx bxs-book-add'></i>
                            Crear nuevo curso
                        </h2>
                        <p class="curso-subtitle">
                            Completa la información para registrar un nuevo curso en el portal de capacitaciones.
                        </p>
                    </div>

                    <!-- BODY -->
                    <div class="curso-body">
                        <div class="curso-grid">

                            <!-- Nombre (full width) -->
                            <div class="curso-field-full">
                                <asp:Label ID="lblNombre" runat="server"
                                    Text="Nombre del curso"
                                    CssClass="curso-label"
                                    AssociatedControlID="txtNombreCurso"></asp:Label>

                                <asp:TextBox ID="txtNombreCurso" runat="server"
                                    CssClass="form-control"
                                    MaxLength="150"
                                    placeholder="Ej: Excel Intermedio" />
                            </div>

                            <!-- Fecha inicio -->
                            <div>
                                <asp:Label ID="lblFecha" runat="server"
                                    Text="Fecha de inicio"
                                    CssClass="curso-label"
                                    AssociatedControlID="txtFechaInicio"></asp:Label>

                                <asp:TextBox ID="txtFechaInicio" runat="server"
                                    CssClass="form-control"
                                    TextMode="Date" />
                                <span class="curso-help">Opcional. Puedes dejarla en blanco si aún no está definida.</span>
                            </div>

                            <!-- Duración -->
                            <div>
                                <asp:Label ID="lblDuracion" runat="server"
                                    Text="Duración (horas)"
                                    CssClass="curso-label"
                                    AssociatedControlID="txtDuracionHoras"></asp:Label>

                                <asp:TextBox ID="txtDuracionHoras" runat="server"
                                    CssClass="form-control"
                                    TextMode="Number"
                                    placeholder="Ej: 2" />
                                <span class="curso-help">Número de horas estimadas de dedicación.</span>
                            </div>

                            <!-- Modalidad -->
                            <div>
                                <asp:Label ID="lblModalidad" runat="server"
                                    Text="Modalidad"
                                    CssClass="curso-label"></asp:Label>

                                <asp:TextBox ID="txtModalidad" runat="server"
                                    CssClass="form-control"
                                    Text="Online"
                                    ReadOnly="true"
                                    Enabled="false" />
                            </div>

                            <!-- Imagen (full width) -->
                            <div class="curso-field-full">
                                <asp:Label ID="lblImagen" runat="server"
                                    Text="Imagen del curso"
                                    CssClass="curso-label"
                                    AssociatedControlID="fuImagen"></asp:Label>

                                <asp:FileUpload ID="fuImagen" runat="server"
                                    CssClass="form-control" />

                                <span class="curso-help d-block mt-1">Formatos permitidos: JPG, JPEG, PNG. Se mostrará como portada del curso.
                                </span>
                            </div>

                        </div>
                    </div>

                    <!-- FOOTER -->
                    <div class="curso-footer d-flex justify-content-end align-items-center flex-wrap gap-2">
                        <div class="ms-auto">
                            <asp:Button ID="btnCrearCurso" runat="server"
                                Text="Crear curso"
                                CssClass="btn btn-primary btn-crear-curso"
                                OnClick="btnCrearCurso_Click"
                                OnClientClick="mostrarProcesando();" />
                        </div>
                    </div>

                </div>
            </div>

        </ContentTemplate>

        <Triggers>
            <asp:PostBackTrigger ControlID="btnCrearCurso" />
        </Triggers>
    </asp:UpdatePanel>

    <!-- OVERLAY PROCESANDO CURSO (SE MUESTRA CON JS) -->
    <div id="overlayProcesando" style="position: fixed; inset: 0; background: rgba(0,0,0,0.45); backdrop-filter: blur(3px); display: none; /* oculto por defecto */
        align-items: center; justify-content: center; z-index: 2000;">

        <div style="text-align: center; color: #fff;">
            <div class="spinner-border text-light" style="width: 3rem; height: 3rem;" role="status"></div>
            <p class="mt-3" style="font-size: 1.1rem; font-weight: 600;">Procesando curso…</p>
        </div>
    </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


    <script type="text/javascript">
        function mostrarProcesando() {
            var overlay = document.getElementById('overlayProcesando');
            if (overlay) {
                overlay.style.display = 'flex';
            }
        }
    </script>
</asp:Content>
