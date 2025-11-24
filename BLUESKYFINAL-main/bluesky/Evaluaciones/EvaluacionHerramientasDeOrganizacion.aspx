<%@ Page Title="Evaluación: Herramientas para Organización Efectiva del Trabajo" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="EvaluacionHerramientasDeOrganizacion.aspx.cs"
    Inherits="bluesky.Evaluaciones.EvaluacionHerramientasDeOrganizacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        body {
            background-color: #f4f6fb;
        }

        .eval-card {
            max-width: 960px;
            margin: 30px auto;
            border-radius: 12px;
            border: 1px solid #e3e7f0;
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.08);
            background-color: #ffffff;
        }

        .eval-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 24px;
            border-bottom: 1px solid #e5e7eb;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff;
            border-radius: 12px 12px 0 0;
        }

        .eval-title {
            font-size: 1.4rem;
            margin: 0;
            font-weight: 600;
        }

        .eval-timer {
            font-size: 0.95rem;
            background-color: rgba(15, 23, 42, 0.2);
            padding: 6px 14px;
            border-radius: 999px;
            display: flex;
            gap: 6px;
            align-items: center;
        }

            .eval-timer span#lblTiempo {
                font-weight: 600;
            }

        .card-body {
            padding: 24px;
        }

        .q-card {
            border-radius: 10px;
            border: 1px solid #e5e7eb;
            padding: 16px 18px;
            margin-bottom: 16px;
            background-color: #f9fafb;
            transition: box-shadow 0.2s ease, transform 0.1s ease, border-color 0.2s ease;
        }

            .q-card:hover {
                box-shadow: 0 6px 16px rgba(15, 23, 42, 0.06);
                transform: translateY(-1px);
                border-color: #cbd5f5;
            }

        .q-head {
            font-weight: 500;
            margin-bottom: 10px;
            display: flex;
            gap: 8px;
            align-items: baseline;
            color: #111827;
        }

        .q-num {
            font-size: 0.85rem;
            background-color: #e0edff;
            color: #1d4ed8;
            padding: 3px 10px;
            border-radius: 999px;
        }

        .q-choices {
            margin-left: 4px;
        }

            .q-choices .aspNetDisabled {
                opacity: 0.7;
            }

            .q-choices input[type="radio"] {
                margin-right: 8px;
            }

            .q-choices label {
                display: block;
                padding: 6px 10px;
                border-radius: 8px;
                cursor: pointer;
                transition: background-color 0.15s ease, color 0.15s ease;
                font-size: 0.95rem;
            }

                .q-choices label:hover {
                    background-color: #e5efff;
                }

            .q-choices input[type="radio"]:checked + label {
                background-color: #2563eb;
                color: #ffffff;
            }

        .eval-footer {
            margin-top: 22px;
            display: flex;
            justify-content: center;
        }

        .btn.btn-success {
            padding: 10px 26px;
            font-size: 1rem;
            border-radius: 999px;
            border: none;
            font-weight: 600;
        }

        #pnlResultado .card {
            max-width: 500px;
            margin: 40px auto;
            border-radius: 12px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
        }

        #pnlResultado .card-header {
            border-radius: 12px 12px 0 0;
            background: linear-gradient(135deg, #22c55e, #16a34a);
            color: #ffffff;
        }

        #pnlResultado .card-body {
            padding: 24px 28px;
        }

            #pnlResultado .card-body p {
                margin-bottom: 8px;
                font-size: 0.98rem;
            }

        #btnVolverCursos {
            border-radius: 999px;
            padding: 8px 20px;
            font-weight: 500;
        }

        #ltlMensajeIntentos .alert {
            max-width: 720px;
            margin: 20px auto;
        }
    </style>

    <asp:Literal ID="ltlMensajeIntentos" runat="server"></asp:Literal>

    <asp:Panel ID="pnlEvaluacion" runat="server" Visible="false">
        <div class="card eval-card">
            <div class="eval-header">
                <h2 class="eval-title">Evaluación — Herramientas para Organización Efectiva del Trabajo</h2>
                <div class="eval-timer">
                    Tiempo restante: <span id="lblTiempo"></span>
                </div>
            </div>

            <div class="card-body">
                <asp:Repeater ID="rptPreguntas" runat="server" OnItemDataBound="rptPreguntas_ItemDataBound">
                    <ItemTemplate>
                        <div class="q-card">
                            <div class="q-head">
                                <span class="q-num">Pregunta <%# Container.ItemIndex + 1 %>:</span>
                                <%# Eval("texto_pregunta") %>
                            </div>
                            <div class="q-choices">
                                <asp:RadioButtonList ID="rblAlternativas" runat="server"
                                    RepeatDirection="Vertical">
                                </asp:RadioButtonList>
                                <asp:HiddenField ID="hfPreguntaId" runat="server"
                                    Value='<%# Eval("pregunta_id") %>' />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div class="eval-footer">
                    <asp:Button ID="btnFinalizar" runat="server"
                        Text="Finalizar evaluación"
                        CssClass="btn btn-success"
                        OnClick="btnFinalizar_Click" />
                </div>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlResultado" runat="server" Visible="false">
        <div class="card">
            <div class="card-header">
                <h3 class="h5 m-0 text-center">Resultado de la evaluación</h3>
            </div>
            <div class="card-body text-center">
                <asp:Literal ID="ltlResultado" runat="server"></asp:Literal>
                <br /><br />
                <asp:Button ID="btnVolverCursos" runat="server"
                    Text="Volver a cursos"
                    CssClass="btn btn-secondary"
                    OnClick="btnVolverCursos_Click" />

                <asp:Button ID="btnCertificado" runat="server"
                    Text="Descargar Certificado"
                    CssClass="btn btn-primary ms-2"
                    Visible="false"
                    CausesValidation="false"
                    OnClick="btnCertificado_Click" />
            </div>
        </div>
    </asp:Panel>

    <!-- Timer 45 minutos -->
    <script type="text/javascript">
        var totalSeconds = 2700; // 45 * 60

        function startTimer() {
            var lbl = document.getElementById('lblTiempo');
            if (!lbl) return;

            var interval = setInterval(function () {
                var min = Math.floor(totalSeconds / 60);
                var sec = totalSeconds % 60;
                lbl.textContent = min + "m " + (sec < 10 ? "0" + sec : sec) + "s";

                if (totalSeconds <= 0) {
                    clearInterval(interval);
                    alert('Tiempo finalizado. Se enviará la evaluación.');
                    document.getElementById('<%= btnFinalizar.ClientID %>').click();
                }
                totalSeconds--;
            }, 1000);
        }

        window.onload = startTimer;
    </script>

</asp:Content>
