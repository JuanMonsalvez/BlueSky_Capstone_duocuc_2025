<%@ Page Title="Editar Pregunta de Evaluación" Language="C#" 
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" 
    CodeBehind="GestionEvaluacionEditar.aspx.cs" 
    Inherits="bluesky.Admin.GestionEvaluacionEditar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4 mb-4">
        <div class="row">
            <div class="col-md-8 mx-auto">

                <h2 class="mb-3">
                    <i class="fa fa-pencil-square-o"></i> 
                    <asp:Literal ID="ltlTitulo" runat="server" />
                </h2>

                <asp:Literal ID="ltlMensaje" runat="server"></asp:Literal>

                <asp:Panel ID="pnlFormulario" runat="server">
                    <asp:HiddenField ID="hfPreguntaId" runat="server" />

                    <div class="card">
                        <div class="card-body">

                            <div class="mb-3">
                                <label for="ddlCurso" class="form-label">Curso</label>
                                <asp:DropDownList ID="ddlCurso" runat="server" CssClass="form-select" />
                            </div>

                            <div class="mb-3">
                                <label for="txtPregunta" class="form-label">Texto de la pregunta</label>
                                <asp:TextBox ID="txtPregunta" runat="server"
                                    TextMode="MultiLine"
                                    Rows="4"
                                    CssClass="form-control"
                                    placeholder="Escribe aquí el enunciado completo de la pregunta..." />
                            </div>

                            <h5 class="mt-3">Alternativas</h5>
                            <p class="text-muted">
                                Ingresa 4 alternativas. Selecciona cuál de ellas es la correcta.
                            </p>

                            <div class="mb-2">
                                <label class="form-label">Alternativa 1</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <asp:RadioButton ID="rbCorrecta1" runat="server" GroupName="correcta" />
                                    </span>
                                    <asp:TextBox ID="txtAlt1" runat="server" CssClass="form-control"
                                        placeholder="Texto de la alternativa 1..." />
                                </div>
                            </div>

                            <div class="mb-2">
                                <label class="form-label">Alternativa 2</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <asp:RadioButton ID="rbCorrecta2" runat="server" GroupName="correcta" />
                                    </span>
                                    <asp:TextBox ID="txtAlt2" runat="server" CssClass="form-control"
                                        placeholder="Texto de la alternativa 2..." />
                                </div>
                            </div>

                            <div class="mb-2">
                                <label class="form-label">Alternativa 3</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <asp:RadioButton ID="rbCorrecta3" runat="server" GroupName="correcta" />
                                    </span>
                                    <asp:TextBox ID="txtAlt3" runat="server" CssClass="form-control"
                                        placeholder="Texto de la alternativa 3..." />
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Alternativa 4</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <asp:RadioButton ID="rbCorrecta4" runat="server" GroupName="correcta" />
                                    </span>
                                    <asp:TextBox ID="txtAlt4" runat="server" CssClass="form-control"
                                        placeholder="Texto de la alternativa 4..." />
                                </div>
                            </div>

                            <div class="text-end mt-3">
                                <asp:Button ID="btnGuardar" runat="server"
                                    Text="Guardar"
                                    CssClass="btn btn-primary me-2"
                                    OnClick="btnGuardar_Click" />
                                <asp:Button ID="btnCancelar" runat="server"
                                    Text="Cancelar"
                                    CssClass="btn btn-outline-secondary"
                                    OnClick="btnCancelar_Click" CausesValidation="false" />
                            </div>

                        </div>
                    </div>
                </asp:Panel>

            </div>
        </div>
    </div>

</asp:Content>
