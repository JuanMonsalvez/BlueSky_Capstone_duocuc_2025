<%@ Page Title="Evaluación del Curso" Language="C#" 
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" 
    CodeBehind="EvaluacionCurso.aspx.cs" 
    Inherits="bluesky.StartCursos.EvaluacionCurso"
    Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4 mb-4">
        <div class="row">
            <div class="col-md-10 mx-auto">

                <!-- Mensaje de intentos / errores -->
                <asp:Literal ID="ltlMensajeIntentos" runat="server"></asp:Literal>

                <!-- Panel de evaluación -->
                <asp:Panel ID="pnlEvaluacion" runat="server" Visible="false">

                    <div class="card shadow-sm mb-3">
                        <div class="card-body">
                            <h2 class="mb-2">
                                <i class="fa fa-file-text-o"></i>
                                <asp:Literal ID="ltlTituloCurso" runat="server" />
                            </h2>
                            <p class="text-muted mb-2">
                                Responde todas las preguntas antes de que se acabe el tiempo.
                            </p>

                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="badge bg-primary">
                                    Intento de evaluación
                                </span>
                                <div>
                                    <i class="fa fa-clock-o"></i>
                                    Tiempo restante:
                                    <span id="lblTiempoRestante" class="fw-bold"></span>
                                </div>
                            </div>

                            <!-- Preguntas -->
                            <asp:Repeater ID="rptPreguntas" runat="server" OnItemDataBound="rptPreguntas_ItemDataBound">
                                <HeaderTemplate>
                                    <ol class="list-group list-group-numbered mb-3">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <li class="list-group-item mb-2">
                                        <asp:HiddenField ID="hfPreguntaId" runat="server" 
                                            Value='<%# Eval("pregunta_id") %>' />
                                        <p class="fw-semibold mb-2">
                                            <%# Eval("texto_pregunta") %>
                                        </p>
                                        <asp:RadioButtonList ID="rblAlternativas" runat="server"
                                            CssClass="form-check"
                                            RepeatDirection="Vertical">
                                        </asp:RadioButtonList>
                                    </li>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </ol>
                                </FooterTemplate>
                            </asp:Repeater>

                            <!-- Tiempo límite en minutos para JS (opcional) -->
                            <asp:HiddenField ID="hfTiempoLimiteMin" runat="server" />

                            <div class="text-end mt-3">
                                <asp:Button ID="btnFinalizar" runat="server"
                                    Text="Finalizar evaluación"
                                    CssClass="btn btn-success"
                                    OnClick="btnFinalizar_Click" />
                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <!-- Panel de resultado -->
                <asp:Panel ID="pnlResultado" runat="server" Visible="false">
                    <div class="card shadow-sm">
                        <div class="card-body text-center">
                            <h3 class="mb-3">
                                <i class="fa fa-check-circle-o"></i> Resultado de la evaluación
                            </h3>

                            <asp:Literal ID="ltlResultado" runat="server"></asp:Literal>

                            <div class="mt-4">
                                <asp:Button ID="btnCertificado" runat="server"
                                    Text="Descargar certificado"
                                    CssClass="btn btn-primary me-2"
                                    OnClick="btnCertificado_Click"
                                    Visible="false" />

                                <asp:Button ID="btnVolverCursos" runat="server"
                                    Text="Volver a cursos"
                                    CssClass="btn btn-outline-secondary"
                                    OnClick="btnVolverCursos_Click" />
                            </div>
                        </div>
                    </div>
                </asp:Panel>

            </div>
        </div>
    </div>

    <!-- Script simple de cuenta regresiva usando hfTiempoLimiteMin -->
    <script type="text/javascript">
        (function () {
            var hf = document.getElementById('<%= hfTiempoLimiteMin.ClientID %>');
            var lbl = document.getElementById('lblTiempoRestante');
            if (!hf || !lbl || !hf.value) return;

            var minutos = parseInt(hf.value);
            if (isNaN(minutos) || minutos <= 0) return;

            var tiempoRestante = minutos * 60; // en segundos

            function actualizar() {
                var m = Math.floor(tiempoRestante / 60);
                var s = tiempoRestante % 60;
                lbl.textContent = m + " min " + (s < 10 ? "0" + s : s) + " s";

                if (tiempoRestante <= 0) {
                    // Cuando se acaba el tiempo, deshabilitamos el botón y avisamos
                    var btn = document.getElementById('<%= btnFinalizar.ClientID %>');
                    if (btn) btn.disabled = true;
                    lbl.textContent = "Tiempo agotado";
                    return;
                }

                tiempoRestante--;
                setTimeout(actualizar, 1000);
            }

            actualizar();
        })();
    </script>

</asp:Content>
