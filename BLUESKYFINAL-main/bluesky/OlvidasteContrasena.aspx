<%@ Page Title="Olvidaste tu contraseña" Language="C#" 
    MasterPageFile="~/Auth.Master"
    AutoEventWireup="true"
    CodeBehind="OlvidasteContrasena.aspx.cs"
    Inherits="bluesky.OlvidasteContrasena" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .pwd-wrapper {
            min-height: calc(100vh - 120px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px 15px;
        }

        .pwd-card {
            max-width: 520px;
            width: 100%;
            border-radius: 18px;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.18);
            border: 1px solid rgba(148, 163, 184, 0.35);
            background: #ffffff;
        }

        .pwd-header {
            padding: 22px 26px 12px 26px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.2);
        }

        .pwd-body {
            padding: 20px 26px 24px 26px;
        }

        .pwd-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 4px;
        }

        .pwd-subtitle {
            font-size: 0.92rem;
            color: #6b7280;
            margin: 0;
        }

        .pwd-steps {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            margin-top: 16px;
            font-size: 0.78rem;
            color: #6b7280;
        }

        .pwd-step {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .pwd-step-circle {
            width: 22px;
            height: 22px;
            border-radius: 999px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.78rem;
            border: 1px solid #cbd5f5;
            background: #f9fafb;
            color: #6b7280;
        }

        .pwd-step.active .pwd-step-circle {
            background: #2563eb;
            border-color: #2563eb;
            color: #ffffff;
            font-weight: 600;
        }

        .pwd-step.done .pwd-step-circle {
            background: #22c55e;
            border-color: #22c55e;
            color: #ffffff;
        }

        .pwd-step-label {
            white-space: nowrap;
        }

        .pwd-step-line {
            flex: 1;
            height: 1px;
            background: linear-gradient(to right, #e5e7eb, #cbd5f5);
        }

        .pwd-form-section {
            margin-top: 16px;
        }

        .code-inputs {
            display: flex;
            justify-content: space-between;
            gap: 8px;
            margin: 10px 0 6px 0;
        }

        .code-box {
            width: 48px;
            height: 56px;
            text-align: center;
            font-size: 1.5rem;
            font-weight: 600;
            border-radius: 10px;
            border: 1px solid #d1d5db;
            outline: none;
            transition: all 0.18s ease-in-out;
        }

        .code-box:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.25);
        }

        .code-helper {
            font-size: 0.8rem;
            color: #6b7280;
        }

        .pwd-actions {
            margin-top: 18px;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-primary-soft {
            background: #2563eb;
            border-color: #2563eb;
            border-radius: 999px;
            padding-inline: 26px;
            font-weight: 500;
        }

        .btn-primary-soft:hover {
            background: #1d4ed8;
            border-color: #1d4ed8;
        }

        .pwd-footer-note {
            margin-top: 12px;
            font-size: 0.8rem;
            color: #9ca3af;
        }

        .pwd-error {
            font-size: 0.85rem;
        }

        .pwd-msg {
            font-size: 0.85rem;
        }

        @media (max-width: 480px) {
            .pwd-card {
                border-radius: 14px;
            }

            .code-box {
                width: 42px;
                height: 52px;
                font-size: 1.3rem;
            }

            .pwd-header,
            .pwd-body {
                padding-inline: 18px;
            }
        }
    </style>

    <div class="pwd-wrapper">
        <div class="pwd-card">
            <div class="pwd-header">
                <h1 class="pwd-title">
                    <i class="fa fa-unlock-alt"></i> Recuperar contraseña
                </h1>
                <p class="pwd-subtitle">
                    Sigue los pasos para restablecer tu contraseña de acceso al portal de BlueSky.
                </p>

                <!-- Indicador de pasos (se actualiza visualmente con CSS según panel visible) -->
                <div class="pwd-steps">
                    <div class="pwd-step" id="step1">
                        <div class="pwd-step-circle">1</div>
                        <span class="pwd-step-label">Identificación</span>
                        <div class="pwd-step-line"></div>
                    </div>
                    <div class="pwd-step" id="step2">
                        <div class="pwd-step-circle">2</div>
                        <span class="pwd-step-label">Código</span>
                        <div class="pwd-step-line"></div>
                    </div>
                    <div class="pwd-step" id="step3">
                        <div class="pwd-step-circle">3</div>
                        <span class="pwd-step-label">Nueva clave</span>
                    </div>
                </div>
            </div>

            <div class="pwd-body">
                <!-- Mensajes generales -->
                <asp:Label ID="lblMensaje" runat="server" CssClass="text-success pwd-msg d-block mb-1"></asp:Label>
                <asp:Label ID="lblError" runat="server" CssClass="text-danger pwd-error d-block mb-2"></asp:Label>

                <!-- =========================
                     PASO 1: ingresar correo o RUT
                     ========================= -->
                <asp:Panel ID="panelPaso1" runat="server" CssClass="pwd-form-section">
                    <div class="mb-3">
                        <label for="txtUserOrEmail" class="form-label">
                            Correo electrónico o RUT
                        </label>
                        <asp:TextBox ID="txtUserOrEmail" runat="server"
                            CssClass="form-control"
                            placeholder="ejemplo@correo.cl o 12.345.678-9"></asp:TextBox>
                        <small class="form-text text-muted">
                            Puedes escribir tu correo institucional o tu RUT con dígito verificador.
                        </small>
                    </div>

                    <div class="pwd-actions">
                        <asp:Button ID="btnEnviarCodigo" runat="server"
                            Text="Enviar código"
                            CssClass="btn btn-primary btn-primary-soft"
                            OnClick="btnEnviarCodigo_Click" />
                    </div>

                    <div class="pwd-footer-note">
                        Te enviaremos un código de verificación al correo asociado a tu cuenta.
                    </div>
                </asp:Panel>

                <!-- =========================
                     PASO 2: validar código (ahora con casillas)
                     ========================= -->
                <asp:Panel ID="panelPaso2" runat="server" CssClass="pwd-form-section" Visible="false">
                    <div class="mb-2">
                        <label class="form-label">Código de verificación</label>
                        <div class="code-inputs" data-length="6">
                            <input type="text" maxlength="1" class="code-box" inputmode="numeric" autocomplete="one-time-code" />
                            <input type="text" maxlength="1" class="code-box" inputmode="numeric" />
                            <input type="text" maxlength="1" class="code-box" inputmode="numeric" />
                            <input type="text" maxlength="1" class="code-box" inputmode="numeric" />
                            <input type="text" maxlength="1" class="code-box" inputmode="numeric" />
                            <input type="text" maxlength="1" class="code-box" inputmode="numeric" />
                        </div>
                        <div class="code-helper">
                            Ingresa el código de 6 dígitos que te enviamos por correo.
                            Puedes escribir uno a uno o pegar el código completo y se rellenará automáticamente.
                        </div>
                    </div>

                    <!-- TextBox real que usa el backend para validar el código -->
                    <asp:TextBox ID="txtCodigo" runat="server" CssClass="d-none"></asp:TextBox>

                    <div class="pwd-actions">
                        <asp:Button ID="btnValidarCodigo" runat="server"
                            Text="Validar código"
                            CssClass="btn btn-primary btn-primary-soft"
                            OnClick="btnValidarCodigo_Click"
                            OnClientClick="return syncResetCode();" />
                    </div>

                    <div class="pwd-footer-note">
                        El código tiene una duración limitada.  
                        Si expira, vuelve a solicitar uno nuevo desde el paso 1.
                    </div>
                </asp:Panel>

                <!-- =========================
                     PASO 3: definir nueva contraseña
                     ========================= -->
                <asp:Panel ID="panelPaso3" runat="server" CssClass="pwd-form-section" Visible="false">
                    <div class="mb-3">
                        <label for="txtNuevaPass" class="form-label">Nueva contraseña</label>
                        <asp:TextBox ID="txtNuevaPass" runat="server"
                            CssClass="form-control"
                            TextMode="Password"
                            placeholder="Ingresa tu nueva contraseña"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label for="txtConfirmarPass" class="form-label">Confirmar contraseña</label>
                        <asp:TextBox ID="txtConfirmarPass" runat="server"
                            CssClass="form-control"
                            TextMode="Password"
                            placeholder="Repite tu nueva contraseña"></asp:TextBox>
                    </div>

                    <div class="pwd-actions">
                        <asp:Button ID="btnCambiarPass" runat="server"
                            Text="Cambiar contraseña"
                            CssClass="btn btn-primary btn-primary-soft"
                            OnClick="btnCambiarPass_Click" />
                    </div>

                    <div class="pwd-footer-note">
                        Tu nueva contraseña se guardará cifrada de forma segura antes de actualizarla en la cuenta.
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // ----- Lógica visual del indicador de pasos -----
        (function () {
            try {
                var panel1 = document.getElementById('<%= panelPaso1.ClientID %>');
                var panel2 = document.getElementById('<%= panelPaso2.ClientID %>');
                var panel3 = document.getElementById('<%= panelPaso3.ClientID %>');

                var step1 = document.getElementById('step1');
                var step2 = document.getElementById('step2');
                var step3 = document.getElementById('step3');

                function setStepState(panel, step, index) {
                    if (!panel || !step) return;
                    // Limpia clases
                    step.classList.remove('active');
                    step.classList.remove('done');

                    if (panel.style.display !== 'none' && panel.style.visibility !== 'hidden' && panel.offsetParent !== null) {
                        // Este panel está visible → step activo
                        step.classList.add('active');
                        // Marcar anteriores como "done"
                        if (index === 2 && step1) step1.classList.add('done');
                        if (index === 3 && step1 && step2) {
                            step1.classList.add('done');
                            step2.classList.add('done');
                        }
                    }
                }

                // Evaluar según qué panel está visible
                setStepState(panel1, step1, 1);
                setStepState(panel2, step2, 2);
                setStepState(panel3, step3, 3);
            } catch(e) {
                // si algo falla aquí, no rompe la página
                console.warn('No se pudo inicializar el indicador de pasos', e);
            }
        })();

        // ----- Lógica de casillas de código para PASO 2 -----
        (function () {
            var boxes = document.querySelectorAll('.code-box');
            if (!boxes || boxes.length === 0) return;

            function focusNext(currentIndex) {
                if (currentIndex < boxes.length - 1) {
                    boxes[currentIndex + 1].focus();
                    boxes[currentIndex + 1].select();
                }
            }

            function focusPrev(currentIndex) {
                if (currentIndex > 0) {
                    boxes[currentIndex - 1].focus();
                    boxes[currentIndex - 1].select();
                }
            }

            boxes.forEach(function (box, index) {
                box.addEventListener('input', function (e) {
                    var val = e.target.value.replace(/\D/g, ''); // solo números
                    e.target.value = val.substring(0, 1);

                    if (val.length >= 1) {
                        focusNext(index);
                    }
                });

                box.addEventListener('keydown', function (e) {
                    if (e.key === 'Backspace' && !e.target.value) {
                        e.preventDefault();
                        focusPrev(index);
                    }
                    if (e.key === 'ArrowLeft') {
                        e.preventDefault();
                        focusPrev(index);
                    }
                    if (e.key === 'ArrowRight') {
                        e.preventDefault();
                        focusNext(index);
                    }
                });

                // Permitir pegar el código completo en la primera caja
                box.addEventListener('paste', function (e) {
                    e.preventDefault();
                    var clipData = (e.clipboardData || window.clipboardData).getData('text');
                    clipData = (clipData || '').replace(/\D/g, ''); // solo dígitos

                    if (!clipData) return;

                    for (var i = 0; i < boxes.length; i++) {
                        boxes[i].value = clipData[i] ? clipData[i] : '';
                    }

                    // Ir al final
                    var lastIndex = Math.min(clipData.length, boxes.length) - 1;
                    if (lastIndex >= 0) {
                        boxes[lastIndex].focus();
                        boxes[lastIndex].select();
                    }
                });
            });

            // Foco inicial en la primera caja del paso 2 cuando se muestra
            // (si el usuario está en paso 2)
            if (boxes[0].offsetParent !== null) {
                boxes[0].focus();
            }
        })();

        // Copia el código de las casillas al TextBox txtCodigo antes de validar (PASO 2)
        function syncResetCode() {
            var boxes = document.querySelectorAll('.code-box');
            if (!boxes || boxes.length === 0) return true;

            var code = '';
            boxes.forEach(function (box) {
                code += (box.value || '').trim();
            });

            if (code.length !== 6) {
                alert('Debes ingresar el código de 6 dígitos.');
                return false; // evita el postback
            }

            var hiddenInput = document.getElementById('<%= txtCodigo.ClientID %>');
            if (hiddenInput) {
                hiddenInput.value = code;
            }

            return true; // permite el postback → btnValidarCodigo_Click usa txtCodigo.Text
        }
    </script>

</asp:Content>
