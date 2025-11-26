<%@ Page Title="Gestión de cursos" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="CrearCurso.aspx.cs" Inherits="bluesky.Admin.CrearCurso" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .admin-curso-wrapper {
            padding: 30px 15px;
        }

        .admin-curso-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            gap: 10px;
            flex-wrap: wrap;
        }

        .admin-curso-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #0f172a;
            margin: 0;
        }

        .admin-curso-subtitle {
            font-size: 0.9rem;
            color: #6b7280;
            margin: 0;
        }

        .card-curso {
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.08);
            border: 1px solid rgba(148, 163, 184, 0.35);
        }

        .card-curso-header {
            padding: 14px 18px 10px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.3);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .card-curso-header h2 {
            font-size: 1rem;
            font-weight: 600;
            margin: 0;
            color: #111827;
        }

        .card-curso-body {
            padding: 16px 18px 18px;
        }

        .btn-rounded {
            border-radius: 999px;
            font-weight: 500;
        }

        .badge-modalidad {
            padding: 3px 8px;
            border-radius: 999px;
            font-size: 0.75rem;
        }

        .form-text-muted {
            font-size: 0.8rem;
            color: #6b7280;
        }

        /* --- Buscador --- */
        .search-box {
            display: flex;
            gap: 6px;
            align-items: center;
        }

        .search-box input {
            max-width: 220px;
        }

        @media (max-width: 576px) {
            .search-box {
                width: 100%;
            }

            .search-box input {
                flex: 1;
                max-width: none;
            }
        }

        /* --- Blur del fondo cuando el modal está abierto --- */
        .blur-target {
            transition: filter 0.2s ease, opacity 0.2s ease;
        }

        .modal-blur-open .blur-target {
            filter: blur(4px);
            opacity: 0.85;
            pointer-events: none; /* Evita clics detrás del modal */
        }

        /* --- Modal custom (independiente de Bootstrap JS) --- */
        .curso-modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.55);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1050;
        }

        .curso-modal-overlay.show {
            display: flex;
        }

        .curso-modal {
            background: #ffffff;
            border-radius: 16px;
            max-width: 720px;
            width: 95%;
            box-shadow: 0 24px 60px rgba(15, 23, 42, 0.35);
            animation: modalFadeIn 0.2s ease-out;
        }

        .curso-modal-header,
        .curso-modal-footer {
            padding: 14px 18px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.25);
        }

        .curso-modal-footer {
            border-top: 1px solid rgba(148, 163, 184, 0.25);
            border-bottom: none;
            display: flex;
            justify-content: flex-end;
            gap: 8px;
        }

        .curso-modal-body {
            padding: 16px 18px 18px;
        }

        .curso-modal-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin: 0;
            color: #111827;
        }

        .curso-modal-close {
            background: transparent;
            border: none;
            font-size: 1.3rem;
            line-height: 1;
            cursor: pointer;
            color: #6b7280;
        }

        .curso-modal-close:hover {
            color: #111827;
        }

        @keyframes modalFadeIn {
            from {
                opacity: 0;
                transform: translateY(-8px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>

    <!-- TODO lo que se debe ver borroso cuando el modal esté abierto -->
    <div class="admin-curso-wrapper container blur-target">

        <asp:HiddenField ID="hdnCursoId" runat="server" />

        <!-- HEADER -->
        <div class="admin-curso-header">
            <div>
                <h1 class="admin-curso-title">
                    <i class="fa fa-graduation-cap"></i> Gestión de cursos
                </h1>
                <p class="admin-curso-subtitle">
                    Administra los cursos del portal: crea nuevos, edita y elimina los existentes.
                </p>
            </div>

            <div class="d-flex align-items-center" style="gap:10px; flex-wrap: wrap;">
                <!-- Buscador -->
                <div class="search-box">
                    <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control form-control-sm"
                        placeholder="Buscar por nombre..."></asp:TextBox>
                    <asp:Button ID="btnBuscar" runat="server"
                        Text="Buscar"
                        CssClass="btn btn-outline-secondary btn-sm"
                        UseSubmitBehavior="false"
                        OnClick="btnBuscar_Click" />
                    <asp:Button ID="btnLimpiarBusqueda" runat="server"
                        Text="Limpiar"
                        CssClass="btn btn-light btn-sm"
                        UseSubmitBehavior="false"
                        OnClick="btnLimpiarBusqueda_Click" />
                </div>

                <!-- Botón nuevo curso -->
                <asp:Button ID="btnNuevoCurso" runat="server"
                    Text="Nuevo curso"
                    CssClass="btn btn-primary btn-rounded btn-sm"
                    UseSubmitBehavior="false"
                    OnClick="btnNuevoCurso_Click" />
            </div>
        </div>

        <!-- LISTADO DE CURSOS -->
        <div class="card-curso">
            <div class="card-curso-header">
                <h2>Cursos existentes</h2>
                <small class="text-muted">
                    Máximo 10 cursos por página. Usa el buscador para filtrar por nombre.
                </small>
            </div>
            <div class="card-curso-body">
                <asp:GridView ID="gvCursos" runat="server"
                    CssClass="table table-striped table-hover table-sm"
                    AutoGenerateColumns="False"
                    DataKeyNames="curso_id"
                    OnRowCommand="gvCursos_RowCommand"
                    AllowPaging="true"
                    PageSize="10"
                    OnPageIndexChanging="gvCursos_PageIndexChanging">
                    <Columns>
                        <asp:BoundField DataField="curso_id" HeaderText="ID" ItemStyle-Width="40" />
                        <asp:BoundField DataField="nombre" HeaderText="Nombre" />
                        <asp:BoundField DataField="fecha_inicio" HeaderText="Inicio" DataFormatString="{0:yyyy-MM-dd}"
                            HtmlEncode="false" />
                        <asp:BoundField DataField="duracion_horas" HeaderText="Horas" />
                        <asp:TemplateField HeaderText="Modalidad">
                            <ItemTemplate>
                                <span class="badge-modalidad bg-light text-dark">
                                    <%# Eval("modalidad") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEditar" runat="server"
                                    CommandName="Editar"
                                    CommandArgument='<%# Eval("curso_id") %>'
                                    CssClass="btn btn-sm btn-outline-primary me-1">
                                    <i class="fa fa-pencil"></i> Editar
                                </asp:LinkButton>
                                <asp:LinkButton ID="lnkEliminar" runat="server"
                                    CommandName="Eliminar"
                                    CommandArgument='<%# Eval("curso_id") %>'
                                    CssClass="btn btn-sm btn-outline-danger"
                                    OnClientClick="return confirm('¿Seguro que deseas eliminar este curso? Esta acción no se puede deshacer.');">
                                    <i class="fa fa-trash"></i> Eliminar
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="pagination-outer" HorizontalAlign="Center" />
                </asp:GridView>
            </div>
        </div>

    </div>

    <!-- MODAL CUSTOM CREAR/EDITAR CURSO (no depende de Bootstrap JS) -->
    <div id="modalCursoOverlay" class="curso-modal-overlay">
        <div class="curso-modal">
            <div class="curso-modal-header">
                <div style="display:flex; justify-content:space-between; align-items:center; gap:8px;">
                    <h5 class="curso-modal-title">
                        <span id="lblFormularioTitulo" runat="server">Crear nuevo curso</span>
                    </h5>
                    <button type="button" class="curso-modal-close" onclick="hideCursoModal()">&times;</button>
                </div>
            </div>

            <div class="curso-modal-body">
                <div class="mb-3">
                    <label for="txtNombreCurso" class="form-label">Nombre del curso</label>
                    <asp:TextBox ID="txtNombreCurso" runat="server" CssClass="form-control"
                        MaxLength="200" placeholder="Ej: Excel Básico para Finanzas"></asp:TextBox>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtFechaInicio" class="form-label">Fecha de inicio (opcional)</label>
                        <asp:TextBox ID="txtFechaInicio" runat="server" CssClass="form-control"
                            TextMode="Date"></asp:TextBox>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtDuracionHoras" class="form-label">Duración en horas (opcional)</label>
                        <asp:TextBox ID="txtDuracionHoras" runat="server" CssClass="form-control"
                            TextMode="Number" Min="1" Max="500"></asp:TextBox>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="ddlModalidad" class="form-label">Modalidad</label>
                    <asp:DropDownList ID="ddlModalidad" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Online" Value="Online" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Presencial" Value="Presencial"></asp:ListItem>
                        <asp:ListItem Text="Mixto" Value="Mixto"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="mb-3">
                    <label for="fuImagen" class="form-label">Imagen del curso</label>
                    <asp:FileUpload ID="fuImagen" runat="server" CssClass="form-control" />
                    <div class="form-text form-text-muted">
                        Formatos permitidos: JPG, JPEG, PNG. Tamaño recomendado: 1200x600 px.
                    </div>
                    <asp:Literal ID="litImagenActual" runat="server"></asp:Literal>
                </div>
            </div>

            <div class="curso-modal-footer">
                <asp:Button ID="btnLimpiarFormulario" runat="server"
                    Text="Limpiar"
                    CssClass="btn btn-light btn-sm"
                    UseSubmitBehavior="false"
                    OnClick="btnLimpiarFormulario_Click" />

                <button type="button" class="btn btn-default btn-sm" onclick="hideCursoModal()">
                    Cancelar
                </button>

                <asp:Button ID="btnCrearCurso" runat="server"
                    Text="Crear curso"
                    CssClass="btn btn-primary btn-rounded"
                    OnClick="btnCrearCurso_Click"
                    UseSubmitBehavior="false" />
            </div>
        </div>
    </div>

    <!-- JS: mostrar/ocultar modal + blur -->
    <script type="text/javascript">
        function showCursoModal() {
            var overlay = document.getElementById('modalCursoOverlay');
            if (overlay) {
                overlay.className = 'curso-modal-overlay show';
            }

            if (document.body.classList) {
                document.body.classList.add('modal-blur-open');
            } else {
                document.body.className += ' modal-blur-open';
            }
        }

        function hideCursoModal() {
            var overlay = document.getElementById('modalCursoOverlay');
            if (overlay) {
                overlay.className = 'curso-modal-overlay';
            }

            if (document.body.classList) {
                document.body.classList.remove('modal-blur-open');
            } else {
                document.body.className = document.body.className.replace('modal-blur-open', '');
            }
        }
    </script>

</asp:Content>
