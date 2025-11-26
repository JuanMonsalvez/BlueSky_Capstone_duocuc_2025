<%@ Page Title="Verificación de código" Language="C#" 
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true" 
    CodeBehind="VerificacionCodigo.aspx.cs" 
    Inherits="bluesky.VerificacionCodigo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .verify-wrapper {
            min-height: calc(100vh - 120px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px 15px;
        }

        .verify-card {
            max-width: 420px;
            width: 100%;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.18);
            border: 1px solid rgba(148, 163, 184, 0.35);
            background: #ffffff;
        }

        .verify-card-header {
            padding: 20px 24px 10px 24px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.25);
        }

        .verify-card-body {
            padding: 20px 24px 24px 24px;
        }

        .verify-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .verify-subtitle {
            font-size: 0.9rem;
            color: #6b7280;
            margin: 0;
        }

        .code-inputs {
            display: flex;
            justify-content: space-between;
            gap: 8px;
            margin: 16px 0 8px 0;
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

        .verify-actions {
            margin-top: 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        .btn-primary-soft {
            background: #2563eb;
            border-color: #2563eb;
            border-radius: 999px;
            padding-inline: 28px;
            font-weight: 500;
        }

        .btn-primary-soft:hover {
            background: #1d4ed8;
            border-color: #1d4ed8;
        }

        .btn-link-muted {
            border: none;
            background: transparent;
            color: #6b7280;
            padding: 0;
            font-size: 0.85rem;
            text-decoration: underline;
        }

        .verify-error {
            font-size: 0.85rem;
        }

        @media (max-width: 480px) {
            .code-box {
                width: 42px;
                height: 52px;
                font-size: 1.3rem;
            }
        }
    </style>

    <div class="verify-wrapper">
        <div class="verify-card">
            <div class="verify-card-header">
                <h1 class="verify-title">
                    <i class="fa fa-shield"></i> Verificación de código
                </h1>
                <p class="verify-subtitle">
                    Ingresa el código de 6 dígitos que enviamos a tu correo para completar el inicio de sesión.
                </p>
            </div>

            <div class="verify-card-body">
                <!-- Código en 6 casillas visuales -->
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
                        Puedes escribir dígito por dígito o pegar el código completo; se rellenará automáticamente.
                    </div>
                </div>

                <!-- TextBox real que usa el backend (oculto) -->
                <asp:TextBox ID="txtCodigo" runat="server" CssClass="d-none"></asp:TextBox>

                <!-- Mensaje de error del servidor -->
                <asp:Label ID="lblError" runat="server" CssClass="text-danger verify-error d-block mt-2"></asp:Label>

                <div class="verify-actions">
                    <asp:Button ID="btnConfirmar" runat="server"
                        Text="Confirmar"
                        CssClass="btn btn-primary btn-primary-soft"
                        OnClick="btnConfirmar_Click"
                        OnClientClick="return syncVerificationCode();" />

                    <!-- Si después quieres implementar reenvío, puedes activar este botón -->
                    <%-- 
                    <button type="button" class="btn-link-muted">
                        Reenviar código
                    </button>
                    --%>
                </div>

                <div class="mt-3 text-center" style="font-size:0.8rem;color:#9ca3af;">
                    Por seguridad, este código tiene una duración limitada.  
                    Si expira, vuelve a iniciar sesión para generar uno nuevo.
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
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

            // Foco inicial en la primera caja
            boxes[0].focus();
        })();

        // Copia el código de las cajas visuales al TextBox real antes de enviar el formulario
        function syncVerificationCode() {
            var boxes = document.querySelectorAll('.code-box');
            if (!boxes || boxes.length === 0) return true;

            var code = '';
            boxes.forEach(function (box) {
                code += (box.value || '').trim();
            });

            // 6 dígitos obligatorios (ajusta si usas otro largo)
            if (code.length !== 6) {
                // Pequeña validación visual (sin romper lblError del servidor)
                alert('Debes ingresar el código de 6 dígitos.');
                return false; // no hace postback
            }

            var hiddenInput = document.getElementById('<%= txtCodigo.ClientID %>');
            if (hiddenInput) {
                hiddenInput.value = code;
            }

            return true; // permite el postback y tu backend sigue como está
        }
    </script>

</asp:Content>
