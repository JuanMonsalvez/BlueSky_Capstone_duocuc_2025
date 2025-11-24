<%@ Page Title="IniciarSesion" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="IniciarSesion.aspx.cs" Inherits="bluesky.IniciarSesion" %>

<%@ MasterType VirtualPath="~/Auth.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* Fondo claro y centrado vertical absoluto del card */
        .auth-page {
            min-height: calc(100vh - 80px); /* deja espacio para tu navbar */
            background: #f7f7fb;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 15px;
        }

        /* Card */
        .auth-card {
            width: 100%;
            max-width: 480px;
            border: 0;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 12px 30px rgba(20,20,40,.08);
        }

            .auth-card .panel-body {
                padding: 32px;
            }

        /* Marca arriba */
        .auth-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            font-size: 18px;
            color: #4f4f6b;
            margin-bottom: 6px;
        }

            .auth-brand i {
                font-size: 20px;
            }

        /* Títulos y subtítulos */
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

        .auth-label {
            font-size: 11px;
            font-weight: 700;
            color: #7a7a90;
            letter-spacing: .3px;
        }

        .auth-label-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .auth-link {
            font-size: 12px;
        }

        /* Inputs grandes y redondeados */
        .form-group {
            margin-bottom: 14px;
        }

        .form-control {
            height: 44px;
            border-radius: 8px;
        }

        .input-group-lg > .form-control,
        .input-group-lg > .input-group-btn > .btn {
            height: 44px;
            border-radius: 8px;
        }

        .btn-eye {
            border-left: 0;
        }

        /* Checkbox + botón */
        .auth-actions {
            margin: 8px 0 12px;
        }

        .auth-btn {
            border-radius: 8px;
            height: 44px;
            font-weight: 600;
        }

        /* Crear cuenta */
        .auth-register {
            text-align: center;
            margin: 14px 0 0;
        }

        /* Separador "o" */
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

        /* Botones sociales */
        .auth-social {
            display: flex;
            gap: 10px;
            justify-content: center;
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
                gap: 6px; /* espacio entre icono y texto */
            }

        .auth-card .btn {
            display: block;
            margin: 0 auto; /* centra horizontalmente */
            width: auto; /* ancho automático */
            padding: 0 30px; /* para que no queden muy pequeños */
        }
    </style>

    <!-- AUTH WRAPPER -->
    <div class="auth-page">
        <div class="auth-card panel panel-default">
            <div class="panel-body">

                <!-- Marca / icono -->
                <div class="auth-brand">
                    <i class="fa fa-lock"></i>
                    <span>BlueSky</span>
                </div>

                <h3 class="auth-title">¡Bienvenido a BlueSky! <span class="wave">👋</span></h3>
                <p class="auth-subtitle">Por favor ingresa a tu cuenta y comienza la aventura</p>

                <!-- Usuario / Email -->
                <div class="form-group">
                    <label class="auth-label">EMAIL</label>
                    <asp:TextBox ID="txtUser" runat="server" CssClass="form-control input-lg" placeholder="Ingresa tu email"></asp:TextBox>
                </div>

                <!-- Password -->
                <div class="form-group">
                    <div class="auth-label-row">
                        <label class="auth-label">CONTRASEÑA</label>
                        <a href="OlvidasteContrasena.aspx" class="auth-link">¿Olvidaste tu contraseña?</a>
                    </div>

                    <div class="input-group input-group-lg">
                        <asp:TextBox ID="txtPass" runat="server" TextMode="Password" CssClass="form-control" placeholder="********"></asp:TextBox>
                        <span class="input-group-btn">
                            <button type="button" class="btn btn-default btn-eye" onclick="togglePass()">
                                <i class="fa fa-eye"></i>
                            </button>
                        </span>
                    </div>
                </div>

                <!-- Remember + botón -->
                <div class="auth-actions">
                    <label class="checkbox-inline">
                        <asp:CheckBox ID="chkRemember" runat="server" />
                        Recordarme
                    </label>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Iniciar Sesión" CssClass="btn btn-primary btn-lg btn-block auth-btn" OnClick="btnLogin_Click" />


                <!-- Crear cuenta -->
                <p class="auth-register">
                    ¿Nuevo en nuestra plataforma? <a href="CrearSesion.aspx" class="auth-link">Crear una cuenta</a>
                </p>

                <!-- separador -->
                <div class="auth-sep"><span>o</span></div>
                <!-- Botón volver al inicio -->
                <div class="auth-back">
                    <asp:Button ID="btnVolverInicio" runat="server"
                        Text="← Volver al inicio"
                        CssClass="btn btn-outline-secondary btn-block auth-btn"
                        OnClick="btnVolverInicio_Click" />
                </div>

            </div>
        </div>
    </div>



    <script type="text/javascript">
        function togglePass() {
            var i = document.getElementById('<%= txtPass.ClientID %>');
            i.type = (i.type === 'password') ? 'text' : 'password';
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


</asp:Content>
