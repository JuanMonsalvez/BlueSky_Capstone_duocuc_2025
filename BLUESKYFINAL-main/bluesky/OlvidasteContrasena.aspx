<%@ Page Title="Olvidaste tu contraseña" Language="C#"
    MasterPageFile="~/Auth.Master" AutoEventWireup="true"
    CodeBehind="OlvidasteContrasena.aspx.cs"
    Inherits="bluesky.OlvidasteContrasena" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="auth-page">
        <div class="auth-card panel panel-default">
            <div class="panel-heading text-center">
                <h3 class="panel-title">Restablecer contraseña</h3>
            </div>

            <div class="panel-body">

                <!-- Mensajes generales -->
                <asp:Label ID="lblMensaje" runat="server" CssClass="text-info" EnableViewState="false"></asp:Label>
                <asp:Label ID="lblError" runat="server" CssClass="text-danger" EnableViewState="false"></asp:Label>

                <!-- PASO 1: Identificar usuario y enviar código -->
                <asp:Panel ID="panelPaso1" runat="server">
                    <p>
                        Ingresa tu <b>correo registrado</b> o tu <b>RUT con dígito verificador</b>
                        (por ejemplo: 12.345.678-9) para enviarte un código de verificación a tu email.
                    </p>

                    <div class="form-group">
                        <label for="txtUserOrEmail">Correo o RUT con DV</label>
                        <asp:TextBox ID="txtUserOrEmail" runat="server" CssClass="form-control"
                            Placeholder="correo@ejemplo.com o 12345678-9"></asp:TextBox>
                    </div>

                    <div class="text-right" style="margin-top: 15px;">
                        <asp:Button ID="btnEnviarCodigo" runat="server"
                            CssClass="btn btn-primary"
                            Text="Enviar código"
                            OnClick="btnEnviarCodigo_Click" />
                    </div>
                </asp:Panel>

                <!-- PASO 2: Verificar código (con contador de 3 minutos) -->
                <asp:Panel ID="panelPaso2" runat="server" Visible="false">
                    <p>
                        Te enviamos un código de verificación a tu correo electrónico.
                        Ingresa el código a continuación. El código es válido por
                        <b>3 minutos</b>.
                    </p>

                    <p>
                        Tiempo restante: <span class="label label-default">
                            <asp:Label ID="lblTimer" runat="server" Text="03:00"></asp:Label>
                        </span>
                    </p>

                    <div class="form-group">
                        <label for="txtCodigo">Código de verificación</label>
                        <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control" MaxLength="6"></asp:TextBox>
                    </div>

                    <div class="text-right" style="margin-top: 15px;">
                        <asp:Button ID="btnValidarCodigo" runat="server"
                            CssClass="btn btn-success"
                            Text="Validar código"
                            OnClick="btnValidarCodigo_Click" />
                    </div>
                </asp:Panel>

                <!-- PASO 3: Cambiar contraseña (solo si el código fue validado) -->
                <asp:Panel ID="panelPaso3" runat="server" Visible="false">
                    <p>
                        Código verificado correctamente. Ahora ingresa tu nueva contraseña.
                    </p>

                    <div class="form-group">
                        <label for="txtNuevaPass">Nueva contraseña</label>
                        <asp:TextBox ID="txtNuevaPass" runat="server"
                            CssClass="form-control"
                            TextMode="Password"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="txtConfirmarPass">Confirmar nueva contraseña</label>
                        <asp:TextBox ID="txtConfirmarPass" runat="server"
                            CssClass="form-control"
                            TextMode="Password"></asp:TextBox>
                    </div>

                    <div class="text-right" style="margin-top: 15px;">
                        <asp:Button ID="btnCambiarPass" runat="server"
                            CssClass="btn btn-primary"
                            Text="Cambiar contraseña"
                            OnClick="btnCambiarPass_Click" />
                    </div>
                </asp:Panel>

            </div>
        </div>
    </div>

    <!-- Script para el contador de 3 minutos -->
    <script type="text/javascript">
        function iniciarContador() {
            var labelId = '<%= lblTimer.ClientID %>';
            var label = document.getElementById(labelId);
            if (!label) return;

            var duration = 180; // 3 minutos en segundos

            var interval = setInterval(function () {
                var minutes = parseInt(duration / 60, 10);
                var seconds = parseInt(duration % 60, 10);

                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;

                label.textContent = minutes + ":" + seconds;

                if (--duration < 0) {
                    clearInterval(interval);
                    label.textContent = "00:00";
                }
            }, 1000);
        }

        // Inicializar contador cuando se cargue la página (y después de postbacks)
        if (typeof (Sys) !== "undefined" && Sys.Application) {
            Sys.Application.add_load(iniciarContador);
        } else {
            window.onload = iniciarContador;
        }
    </script>

</asp:Content>
