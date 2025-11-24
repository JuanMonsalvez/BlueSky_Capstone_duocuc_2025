<%@ Page Title="Verificación de Código" Language="C#"
    MasterPageFile="~/Auth.Master" AutoEventWireup="true"
    CodeBehind="VerificacionCodigo.aspx.cs"
    Inherits="bluesky.VerificacionCodigo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-page">
        <div class="auth-card panel panel-default">
            <div class="panel-heading text-center">
                <h3 class="panel-title">Verificación en 2 pasos</h3>
            </div>
            <div class="panel-body">
                <p>
                    Te enviamos un código de verificación a tu correo electrónico.
                    Ingrésalo a continuación para completar el inicio de sesión.
                </p>

                <div class="form-group">
                    <label for="txtCodigo">Código de verificación</label>
                    <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control" MaxLength="6"></asp:TextBox>
                </div>

                <asp:Label ID="lblError" runat="server" CssClass="text-danger"></asp:Label>

                <div class="text-right" style="margin-top: 15px;">
                    <asp:Button ID="btnConfirmar" runat="server" CssClass="btn btn-primary"
                        Text="Confirmar" OnClick="btnConfirmar_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>

