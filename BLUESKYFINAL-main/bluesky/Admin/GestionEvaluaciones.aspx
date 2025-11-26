<%@ Page Title="Gestión de Evaluaciones" Language="C#" 
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" 
    CodeBehind="GestionEvaluaciones.aspx.cs" 
    Inherits="bluesky.Admin.GestionEvaluaciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4 mb-4">
        <div class="row">
            <div class="col-md-11 mx-auto">

                <h2 class="mb-3">
                    <i class="fa fa-list-alt"></i> Gestión de Evaluaciones
                </h2>
                <p class="text-muted">
                    Administra las preguntas de las evaluaciones por curso. 
                    Puedes crear nuevas preguntas, editarlas o eliminarlas.
                </p>

                <asp:Literal ID="ltlMensaje" runat="server"></asp:Literal>

                <div class="card mb-3">
                    <div class="card-body">
                        <div class="row g-2 align-items-end">
                            <div class="col-md-4">
                                <label for="ddlCursoFiltro" class="form-label">Curso</label>
                                <asp:DropDownList ID="ddlCursoFiltro" runat="server" CssClass="form-select" />
                            </div>
                            <div class="col-md-4">
                                <label for="txtBuscarTexto" class="form-label">Texto de la pregunta</label>
                                <asp:TextBox ID="txtBuscarTexto" runat="server" CssClass="form-control" 
                                    placeholder="Buscar por texto..." />
                            </div>
                            <div class="col-md-4 text-md-end mt-2 mt-md-0">
                                <asp:Button ID="btnBuscar" runat="server"
                                    Text="Buscar"
                                    CssClass="btn btn-primary me-2"
                                    OnClick="btnBuscar_Click" />
                                <asp:Button ID="btnLimpiar" runat="server"
                                    Text="Limpiar filtros"
                                    CssClass="btn btn-outline-secondary"
                                    OnClick="btnLimpiar_Click" />
                            </div>
                        </div>

                        <div class="mt-3 text-end">
                            <asp:Button ID="btnNuevaPregunta" runat="server"
                                Text="Nueva pregunta"
                                CssClass="btn btn-success"
                                OnClick="btnNuevaPregunta_Click" />
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        Preguntas registradas
                    </div>
                    <div class="card-body">
                        <asp:Repeater ID="rptPreguntas" runat="server" OnItemCommand="rptPreguntas_ItemCommand">
                            <HeaderTemplate>
                                <table class="table table-striped table-hover align-middle">
                                    <thead>
                                        <tr>
                                            <th style="width: 80px;">ID</th>
                                            <th>Curso</th>
                                            <th>Pregunta</th>
                                            <th style="width: 120px;" class="text-center">Alternativas</th>
                                            <th style="width: 180px;" class="text-end">Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("pregunta_id") %></td>
                                    <td><%# Eval("nombre_curso") %></td>
                                    <td><%# Eval("texto_corto") %></td>
                                    <td class="text-center"><%# Eval("cantidad_alternativas") %></td>
                                    <td class="text-end">
                                        <asp:LinkButton ID="lnkEditar" runat="server"
                                            CssClass="btn btn-sm btn-primary me-1"
                                            CommandName="Editar"
                                            CommandArgument='<%# Eval("pregunta_id") %>'>
                                            <i class="fa fa-pencil"></i> Editar
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="lnkEliminar" runat="server"
                                            CssClass="btn btn-sm btn-danger"
                                            CommandName="Eliminar"
                                            CommandArgument='<%# Eval("pregunta_id") %>'
                                            OnClientClick="return confirm('¿Seguro que deseas eliminar esta pregunta y sus alternativas?');">
                                            <i class="fa fa-trash"></i> Eliminar
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                    </tbody>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>

                        <asp:Panel ID="pnlSinResultados" runat="server" Visible="false">
                            <div class="alert alert-info mb-0">
                                No se encontraron preguntas con los filtros seleccionados.
                            </div>
                        </asp:Panel>
                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>
