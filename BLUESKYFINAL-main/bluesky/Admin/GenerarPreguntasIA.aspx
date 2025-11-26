<%@ Page Title="Generar Preguntas con IA" Language="C#" 
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" 
    CodeBehind="GenerarPreguntasIA.aspx.cs" 
    Inherits="bluesky.Admin.GenerarPreguntasIA"
    Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 mx-auto">

                <h2 class="mb-3">
                    <i class="fa fa-magic"></i> Generar preguntas con IA
                </h2>
                <p class="text-muted">
                    Selecciona un curso, adjunta un PDF con el contenido del curso y genera
                    preguntas de alternativa múltiple que se guardarán en la base de datos
                    (<code>pregunta</code> y <code>alternativa</code>).
                </p>

                <div class="card mb-3">
                    <div class="card-body">

                        <div class="mb-3">
                            <label for="ddlCurso" class="form-label">Curso</label>
                            <asp:DropDownList ID="ddlCurso" runat="server" CssClass="form-select" />
                        </div>

                        <div class="mb-3">
                            <label for="ddlCantidad" class="form-label">Cantidad de preguntas</label>
                            <asp:DropDownList ID="ddlCantidad" runat="server" CssClass="form-select">
                                <asp:ListItem Text="5" Value="5" />
                                <asp:ListItem Text="10" Value="10" Selected="True" />
                                <asp:ListItem Text="15" Value="15" />
                                <asp:ListItem Text="20" Value="20" />
                            </asp:DropDownList>
                        </div>

                        <div class="mb-3">
                            <label for="fuPdf" class="form-label">Contenido del curso (PDF obligatorio)</label>
                            <asp:FileUpload ID="fuPdf" runat="server" CssClass="form-control" />
                            <small class="text-muted">
                                Sube un archivo PDF con el material del curso. La IA generará preguntas
                                basadas en este contenido. Campo obligatorio.
                            </small>
                        </div>

                        <asp:Button ID="btnGenerar" runat="server" 
                            Text="Generar y guardar en BD" 
                            CssClass="btn btn-primary"
                            OnClick="btnGenerar_Click" />

                        <asp:Label ID="lblEstado" runat="server"
                            CssClass="d-block mt-3 fw-bold text-primary"></asp:Label>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        Vista previa de preguntas generadas
                    </div>
                    <div class="card-body">
                        <asp:Literal ID="litPreview" runat="server" />
                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>
