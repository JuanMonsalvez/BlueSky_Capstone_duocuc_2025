<%@ Page Title="Editar Alumno" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditarAlumnos.aspx.cs" Inherits="bluesky.Admin.EditarAlumnos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-10 col-lg-8">

                <div class="card shadow-lg border-0 rounded-3">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="bx bx-edit-alt me-2"></i>Editar datos del alumno</h5>
                    </div>

                    <div class="card-body">

                        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>

                        <div class="row g-3">

                            <div class="col-md-4">
                                <label class="form-label">RUT</label>
                                <asp:TextBox ID="txtRut" runat="server" CssClass="form-control" ReadOnly="true" />
                            </div>

                            <div class="col-md-8">
                                <label class="form-label">Nombres</label>
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Apellido paterno</label>
                                <asp:TextBox ID="txtPaterno" runat="server" CssClass="form-control" />
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Apellido materno</label>
                                <asp:TextBox ID="txtMaterno" runat="server" CssClass="form-control" />
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Sexo</label>
                                <asp:DropDownList ID="ddlSexo" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="">Seleccione...</asp:ListItem>
                                    <asp:ListItem Value="M">Masculino</asp:ListItem>
                                    <asp:ListItem Value="F">Femenino</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Correo electrónico</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Dirección</label>
                                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" />
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Celular</label>
                                <asp:TextBox ID="txtFono" runat="server" CssClass="form-control" />
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Fecha de nacimiento</label>
                                <asp:TextBox ID="txtFechaNac" runat="server" CssClass="form-control" TextMode="Date" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Estado</label>
                                <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="1">ACTIVO</asp:ListItem>
                                    <asp:ListItem Value="2">INACTIVO</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Suscripción al boletín</label><br />
                                <asp:CheckBox ID="chkBoletin" runat="server"
                                    Text="Suscrito al boletín de cursos" />
                            </div>
                        </div>

                    </div>

                    <div class="card-footer d-flex justify-content-between">
                        <a href="DatosAlumnos.aspx" class="btn btn-secondary">Volver</a>

                        <asp:Button ID="btnGuardar" runat="server"
                            CssClass="btn btn-primary"
                            Text="Guardar cambios"
                            OnClick="btnGuardar_Click" />
                    </div>

                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


</asp:Content>
