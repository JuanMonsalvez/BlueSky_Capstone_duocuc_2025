<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ModificaCorreo.aspx.cs" Inherits="bluesky.Admin.AdminDashboards" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">


        <!-- Contenedor ancho medio (85% centrado) -->
    <div class="container-fluid my-5">
        <div class="row justify-content-center">
            <div class="col-12" style="max-width: 85%; margin: 0 auto;"> <!-- centrado con ancho reducido -->

                <!-- CARD -->
                <div class="card shadow-lg border-0 rounded-3 overflow-hidden" runat="server" data-aos="fade-up">
                    <div class="card-header bg-primary text-white text-center py-3">
                        <h5 class="mb-0"><i class='bx bx-user'></i>MODIFICA INFORMACION DE ALUMNOS</h5>
                    </div>
                    <!---
                    <div class="card-body px-4 py-3">
                        <div class="table-responsive" style="max-height: 500px; overflow-y: auto; overflow-x: auto;">
                            <asp:GridView ID="gvCustomers" runat="server"
                                AutoGenerateColumns="false"
                                CssClass="table table-striped table-hover table-bordered mb-0 text-center align-middle"
                                GridLines="None"
                                Font-Size="13px"
                                HeaderStyle-Font-Size="14px"
                                AllowPaging="true"
                                PageSize="10"
                                OnPageIndexChanging="gvCustomers_PageIndexChanging"
                                Style="min-width: 1100px; margin: 0 auto;"> 
                                
                                <HeaderStyle CssClass="table-primary sticky-top" />
                                <PagerStyle CssClass="pagination justify-content-center mt-3" HorizontalAlign="Center" />

                                <Columns>
                                    <asp:BoundField DataField="persrut" HeaderText="PERSRUT" />
                                    <asp:BoundField DataField="perspatern" HeaderText="APELLIDO PATERNO" />
                                    <asp:BoundField DataField="persmatern" HeaderText="APELLIDO MATERNO" />
                                    <asp:BoundField DataField="persnombre" HeaderText="NOMBRES" />
                                    <asp:BoundField DataField="perssexo" HeaderText="SEXO" />
                                    <asp:BoundField DataField="persdvnro" HeaderText="EMAIL" />
                                    <asp:BoundField DataField="persdirecc" HeaderText="DIRECCIÓN" />
                                    <asp:BoundField DataField="persfono2" HeaderText="CELULAR" />
                                    <asp:BoundField DataField="persfnacim" HeaderText="FECHA NACIMIENTO" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div> -->

                    <div class="card-footer text-muted text-center small">
                        Mostrando datos de alumnos registrados en el sistema BlueSky Financial.
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Scripts adicionales -->
    <script src="../assets/assets/vendor/libs/jquery/jquery.js"></script>
    <script src="../assets/assets/js/forms-selects.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.8/js/select2.min.js" defer></script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

</asp:Content>
