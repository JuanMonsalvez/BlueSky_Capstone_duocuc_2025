<%@ Page Title="Crear Cuenta" Language="C#" MasterPageFile="~/Auth.Master"
    AutoEventWireup="true" CodeBehind="CrearSesion.aspx.cs" Inherits="bluesky.CrearSesion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* ==========================
           LAYOUT GENERAL AUTH PAGE
           ========================== */
        .auth-page {
            width: 100%;
            min-height: calc(100vh - 80px);
            background: #f7f7fb;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 15px;
        }

        .auth-card {
            width: 100%;
            max-width: 560px;
            border: 0;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 12px 30px rgba(20,20,40,.08);
            margin: 0 auto;
        }

        .auth-card .panel-body {
            padding: 32px;
        }

        @media (max-width: 575.98px) {
            .auth-page {
                padding: 24px 10px;
            }

            .auth-card .panel-body {
                padding: 22px 16px;
            }

            .auth-title {
                font-size: 20px !important;
            }

            .auth-subtitle {
                font-size: 14px !important;
            }
        }

        /* ==========================
           TIPOGRAFÍA Y FORM
           ========================== */
        .auth-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            font-size: 18px;
            color: #4f4f6b;
            margin-bottom: 6px;
        }

        .auth-title {
            margin: 0 0 6px 0;
            font-size: 22px;
            font-weight: 600;
            color: #3b3b55;
        }

        .auth-subtitle {
            margin: 0 0 18px 0;
            color: #7a7a90;
        }

        .form-group {
            margin-bottom: 14px;
        }

        .form-control {
            height: 44px;
            border-radius: 8px;
        }

        .auth-btn {
            border-radius: 8px;
            height: 44px;
            font-weight: 600;
        }

        .auth-register {
            text-align: center;
            margin: 14px 0 0;
        }

        .auth-sep {
            position: relative;
            text-align: center;
            margin: 18px 0 10px;
        }

        .auth-sep:before {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            top: 50%;
            height: 1px;
            background: #ececf4;
        }

        .auth-sep span {
            position: relative;
            background: #fff;
            padding: 0 10px;
            color: #9a9ab3;
            font-size: 12px;
        }

        .auth-back {
            margin-top: 14px;
        }

        .auth-back .btn {
            border-radius: 8px;
            height: 42px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .help-block {
            margin-top: 4px;
            font-size: 13px;
            color: #555;
            font-weight: 500;
        }

        .text-danger {
            color: #dc3545 !important;
        }

        /* ==========================
           RUT (CUERPO + DV)
           ========================== */
        .rut-group {
            display: flex;
            align-items: stretch;
            width: 100%;
        }

        .rut-group .rut-cuerpo {
            flex: 1 1 auto;
            min-width: 0;
            border-radius: 8px 0 0 8px;
            border: 1px solid #ced4da;
            border-right: none;
            height: 44px;
        }

        .rut-group .rut-sep {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            min-width: 40px;
            font-weight: bold;
            color: #555;
            background: #f9f9fb;
            border-top: 1px solid #ced4da;
            border-bottom: 1px solid #ced4da;
            border-left: none;
            border-right: none;
            height: 44px;
        }

        .rut-group .rut-dv {
            flex: 0 0 70px;
            max-width: 80px;
            text-align: center;
            text-transform: uppercase;
            border-radius: 0 8px 8px 0;
            border: 1px solid #ced4da;
            border-left: none;
            height: 44px;
        }

        .rut-group .form-control:focus,
        .rut-group .rut-cuerpo:focus,
        .rut-group .rut-dv:focus {
            border-color: #86b7fe;
            outline: none;
            box-shadow: 0 0 0 0.15rem rgba(13,110,253,.25);
        }

        @media (max-width: 400px) {
            .rut-group .rut-dv {
                flex: 0 0 55px;
                max-width: 60px;
            }
        }

        /* CELULAR prefix + input */
        .input-group.input-group-merge {
            display: flex;
            align-items: stretch;
            width: 100%;
        }

        .input-group.input-group-merge .input-group-text {
            flex: 0 0 auto;
            height: 44px;
            line-height: 44px;
            padding: 0 12px;
            white-space: nowrap;
            text-align: center;
            background: #f5f5f8;
            border: 1px solid #ced4da;
            color: #555;
        }

        .input-group.input-group-merge .form-control {
            height: 44px;
        }

        .celu-prefix {
            border-radius: 8px 0 0 8px;
            border: 1px solid #ced4da;
            background: #f5f5f8;
            color: #555;
            min-width: 90px;
        }

        .celu-input {
            border-radius: 0 8px 8px 0;
            border: 1px solid #ced4da;
            border-left: 0;
        }

    </style>

    <div class="auth-page">
        <div class="auth-card panel panel-default">
            <div class="panel-body">

                <div class="auth-brand">
                    <i class="fa fa-user-plus"></i>
                    <span>BlueSky</span>
                </div>

                <h3 class="auth-title">Crea tu cuenta 🚀</h3>
                <p class="auth-subtitle">Únete y comienza tu experiencia en BlueSky</p>

                <asp:Panel ID="pnlRegister" runat="server" DefaultButton="btnRegister">

                    <!-- RUT (cuerpo + DV) -->
                    <div class="form-group">
                        <label class="auth-label">RUT</label>
                        <div class="rut-group" id="grpRut">
                            <asp:TextBox
                                ID="txtRut"
                                runat="server"
                                ClientIDMode="Static"
                                CssClass="form-control input-lg rut-cuerpo"
                                MaxLength="8"
                                autocomplete="off"
                                placeholder="12345678">
                            </asp:TextBox>

                            <div class="rut-sep">-</div>

                            <asp:TextBox
                                ID="txtDv"
                                runat="server"
                                ClientIDMode="Static"
                                CssClass="form-control input-lg rut-dv"
                                MaxLength="1"
                                autocomplete="off"
                                placeholder="K">
                            </asp:TextBox>
                        </div>
                        <small id="ayudaRut" class="help-block">
                            Ingresa el cuerpo (hasta 8 dígitos); el DV se puede sugerir automáticamente.
                        </small>
                    </div>

                    <!-- Campo oculto para compatibilidad con backend existente -->
                    <asp:TextBox ID="txtPersrut" runat="server" ClientIDMode="Static" Style="display: none;"></asp:TextBox>

                    <!-- NOMBRES -->
                    <div class="form-group">
                        <label class="auth-label">Nombres</label>
                        <asp:TextBox ID="txtUsuario" runat="server" Style="text-transform: uppercase;"
                            autocomplete="off" CssClass="form-control input-lg"></asp:TextBox>
                    </div>

                    <!-- APELLIDOS -->
                    <div class="form-group">
                        <label class="auth-label">Apellido Paterno</label>
                        <asp:TextBox ID="txtApellidoPaterno" runat="server" Style="text-transform: uppercase;"
                            autocomplete="off" CssClass="form-control input-lg"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label class="auth-label">Apellido Materno</label>
                        <asp:TextBox ID="txtApellidoMaterno" runat="server" Style="text-transform: uppercase;"
                            autocomplete="off" CssClass="form-control input-lg"></asp:TextBox>
                    </div>

                    <!-- SEXO -->
                    <div class="form-group">
                        <label class="form-label">Sexo</label>
                        <asp:DropDownList AppendDataBoundItems="true" ID="ltSexo" runat="server"
                            CssClass="form-control input-lg">
                            <asp:ListItem Text="Seleccionar..." Value="#" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="FEMENINO" Value="F"></asp:ListItem>
                            <asp:ListItem Text="MASCULINO" Value="M"></asp:ListItem>
                            <asp:ListItem Text="OTRO/A" Value="O"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- EMAIL -->
                    <div class="form-group">
                        <label class="auth-label">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" Style="text-transform: uppercase;"
                            type="email" autocomplete="off" CssClass="form-control input-lg"></asp:TextBox>
                    </div>

                    <!-- DIRECCIÓN -->
                    <div class="form-group">
                        <label class="auth-label">Dirección</label>
                        <asp:TextBox ID="txtDireccion" runat="server" Style="text-transform: uppercase;"
                            autocomplete="off" CssClass="form-control input-lg"></asp:TextBox>
                    </div>

                    <!-- CELULAR -->
                    <div class="form-group">
                        <label class="auth-label">Celular</label>
                        <div class="input-group input-group-merge">
                            <span class="input-group-text celu-prefix">(+56 9)</span>
                            <asp:TextBox
                                ID="txtCelular"
                                runat="server"
                                ClientIDMode="Static"
                                CssClass="form-control input-lg celu-input"
                                MaxLength="8"
                                autocomplete="off"
                                TextMode="SingleLine">
                            </asp:TextBox>
                        </div>
                        <p id="mensaje_ayudaCelu" class="help-block">8 caracteres restantes</p>
                    </div>

                    <!-- FECHA NACIMIENTO -->
                    <div class="form-group">
                        <label class="auth-label">Fecha Nacimiento</label>
                        <asp:TextBox ID="txtFechaNaci" type="date" runat="server"
                            CssClass="form-control"></asp:TextBox>
                    </div>

                    <!-- PASSWORD -->
                    <div class="form-group">
                        <label class="auth-label">Contraseña</label>
                        <asp:TextBox ID="txtUsuclave" runat="server" TextMode="Password"
                            autocomplete="off" CssClass="form-control input-lg"></asp:TextBox>
                        <ul id="passwordRequisitos"
                            style="list-style: none; padding-left: 0; margin-top: 8px; font-size: 14px; color: #555;">
                            <li id="reqMayus">• Al menos una letra mayúscula</li>
                            <li id="reqNum">• Al menos un número</li>
                            <li id="reqLongitud">• Mínimo 8 caracteres</li>
                        </ul>
                    </div>

                    <!-- Términos -->
                    <div class="form-group auth-actions">
                        <label class="checkbox-inline">
                            <asp:CheckBox ID="chkTerms" runat="server" />
                            Acepto los <a href="#">términos y condiciones</a>
                        </label>
                    </div>

                    <!-- Botón Registrar -->
                    <asp:Button ID="btnRegister" runat="server"
                        Text="Crear cuenta"
                        CssClass="btn btn-primary btn-lg btn-block auth-btn"
                        OnClick="btnRegister_Click" />

                </asp:Panel>

                <p class="auth-register">
                    ¿Ya tienes una cuenta?
                    <a href="IniciarSesion.aspx" class="auth-link">Inicia sesión</a>
                </p>

                <div class="auth-sep"><span>o</span></div>

                <div class="auth-back">
                    <asp:Button ID="btnVolverInicio" runat="server"
                        Text="← Volver al inicio"
                        CssClass="btn btn-outline-secondary btn-block auth-btn"
                        OnClick="btnVolverInicio_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- ================= SCRIPTS ================= -->

    <script src="../assets/assets/vendor/libs/jquery/jquery.js"></script>
    <script src="../assets/assets/js/forms-selects.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.8/js/select2.min.js" defer></script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {

            // ==== Celular (contador y limpieza) ====
            const inputCelu = document.getElementById('txtCelular');
            const helpCelu = document.getElementById('mensaje_ayudaCelu');
            const maxCelu = 8;

            if (inputCelu && helpCelu) {
                function updateCelu() {
                    let v = (inputCelu.value || '').replace(/\D/g, '');
                    if (v.length > maxCelu) v = v.slice(0, maxCelu);
                    inputCelu.value = v;
                    const remaining = maxCelu - v.length;
                    helpCelu.textContent = remaining + ' caracteres restantes';
                    helpCelu.classList.remove('text-danger');
                    inputCelu.classList.remove('text-danger');
                }
                inputCelu.addEventListener('input', updateCelu);
                inputCelu.addEventListener('blur', updateCelu);
                updateCelu();
            }

            // ==== Contraseña (feedback visual) ====
            const pwInput = document.getElementById('<%= txtUsuclave.ClientID %>');
            const reqMayus = document.getElementById('reqMayus');
            const reqNum = document.getElementById('reqNum');
            const reqLong = document.getElementById('reqLongitud');

            function actualizarRequisitos() {
                if (!pwInput) return;
                const v = pwInput.value || '';
                if (reqMayus) reqMayus.style.color = /[A-Z]/.test(v) ? 'green' : '#555';
                if (reqNum) reqNum.style.color = /\d/.test(v) ? 'green' : '#555';
                if (reqLong) reqLong.style.color = v.length >= 8 ? 'green' : '#555';
            }
            if (pwInput) {
                pwInput.addEventListener('input', actualizarRequisitos);
                pwInput.addEventListener('blur', actualizarRequisitos);
                actualizarRequisitos();
            }

            // ==== RUT con DV (sugerencia automática, sin bloquear front) ====
            const txtRut = document.getElementById('txtRut');
            const txtDv = document.getElementById('txtDv');
            const txtPersrutCompat = document.getElementById('txtPersrut');
            const ayudaRut = document.getElementById('ayudaRut');

            function calcularDV(cuerpoNumStr) {
                if (!cuerpoNumStr) return '';
                let suma = 0, mul = 2;
                for (let i = cuerpoNumStr.length - 1; i >= 0; i--) {
                    suma += parseInt(cuerpoNumStr[i], 10) * mul;
                    mul = (mul === 7) ? 2 : (mul + 1);
                }
                const resto = suma % 11;
                const dvCalc = 11 - resto;
                if (dvCalc === 11) return '0';
                if (dvCalc === 10) return 'K';
                return String(dvCalc);
            }

            function limpiarCuerpo(v) {
                return (v || '').replace(/\D/g, '').slice(0, 8);
            }

            function limpiarDV(v) {
                v = (v || '').toUpperCase();
                return /^[0-9K]$/.test(v) ? v : '';
            }

            function milesPuntos(str) {
                return str.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
            }

            function actualizarRUT() {
                if (!txtRut || !txtDv) return;

                const cuerpo = limpiarCuerpo(txtRut.value);
                txtRut.value = cuerpo;

                let dvValor = limpiarDV(txtDv.value);
                if (cuerpo && !dvValor) {
                    dvValor = calcularDV(cuerpo);
                }
                txtDv.value = dvValor;

                if (ayudaRut) {
                    ayudaRut.textContent = 'Ingresa el cuerpo (hasta 8 dígitos); el DV se sugiere automáticamente.';
                    ayudaRut.classList.remove('text-danger');
                }

                if (txtPersrutCompat) {
                    const formateado = (cuerpo ? milesPuntos(cuerpo) : '') + (dvValor ? '-' + dvValor : '');
                    txtPersrutCompat.value = formateado;
                }
            }

            if (txtRut && txtDv) {
                txtRut.addEventListener('input', actualizarRUT);
                txtDv.addEventListener('input', function () {
                    txtDv.value = limpiarDV(txtDv.value);
                    actualizarRUT();
                });
                txtRut.addEventListener('blur', actualizarRUT);
                txtDv.addEventListener('blur', actualizarRUT);
                actualizarRUT();
            }
        });
    </script>

</asp:Content>
