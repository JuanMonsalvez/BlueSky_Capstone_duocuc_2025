<%@ Page Title="CREAR EVALUACIONES" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CrearEvaluaciones.aspx.cs" Inherits="bluesky.Admin.CrearEvaluaciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

      <style>
        .card {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,.1);
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.8);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .spinner-border {
            width: 3rem;
            height: 3rem;
            border: 0.35em solid #007bff;
            border-right-color: transparent;
            border-radius: 50%;
            animation: spin 0.75s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>

    <!-- Overlay de carga -->
    <div id="loading" class="loading-overlay">
        <div style="text-align:center;">
            <div class="spinner-border"></div>
            <p style="margin-top:10px; font-weight:bold;">Procesando archivo... Por favor espere.</p>
        </div>
    </div>

    <div class="container" style="padding-top: 40px;">
        <div class="panel panel-default">
            <div class="panel-body">
                <h3 class="text-primary text-center">Generar Evaluación Automática</h3>
                <br />
                <div class="row">
                    <div class="col-xs-12 col-md-6" style="float: none; margin: 0 auto;">
                        <asp:FileUpload ID="pdfUpload" runat="server" CssClass="form-control" />
                    </div>
                </div>

                <br />

                <div class="text-center">
                    <asp:Button ID="btnGenerar" runat="server" Text="Generar Evaluación"
                        CssClass="btn btn-primary" OnClick="btnGenerar_Click"
                        OnClientClick="mostrarCargando();" />
                </div>

                <hr />
                <asp:Literal ID="litResultado" runat="server" Mode="PassThrough"></asp:Literal>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function mostrarCargando() {
            // Mostrar el overlay al enviar el formulario
            document.getElementById("loading").style.display = "flex";
        }
    </script>

</asp:Content>
