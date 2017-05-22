<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master"
    CodeBehind="Transferencias.aspx.vb" Inherits="plantilla2013vbasic.Transferencias" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Aviso al padre de la pagina en la que se encuentra -->
    <%  CType(Me.Page.Master, plantilla2013vbasic.Site).idePagina = plantilla2013vbasic.Pagina.despaTransferencias%>
    <style>
        .margen
        {
            margin-top: 14px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- top -->
    <div class="form-horizontal margen" role="form" style="position: relative; border-bottom: 1px solid #00468C;">
        <div class="form-group" style="margin-top: 12px; margin-left: -40px;">
            <!-- Buscar Orden de Compra -->
            <label for="inputEmail1" class="col-lg-3 control-label" style="color: #1E7EBE; font-size: 15px;">
                NÚMERO DE PERIODO:</label>
            <div class="col-lg-2">
                <input type="email" class="form-control" id="Email1" placeholder="Nº Pedido" style="height: 24px;
                    margin-top: 6px; margin-left: -22px;">
            </div>
            <div class="col-lg-1">
                <span class="glyphicon glyphicon-share" style="zoom: 144%; left: -20px; margin-top: 5px;
                    position: absolute;"></span>
            </div>
        </div>
    </div>
    <!-- mid -->
    <div class="row">
        <div class="col-12">
            <!-- 1 -->
            <div class="col-4 margen">
                <div class="col-12">
                    <!-- Estado Despacho -->
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-1 control-label" style="color: #1E7EBE; font-size: 18px;
                            margin-top: 32px;">
                            Estado:</label>
                        <div class="col-lg-10" style="margin-top: 32px;">
                            <label for="inputEmail1" style="color: #1E7EBE; font-size: 16px; margin-top: 3px;
                                margin-left: 68px;">
                                Estado Despacho</label>
                        </div>
                    </div>
                </div>
                <div class="col-12" style="margin-top: 36px;">
                    <!-- Nombre Bodega -->
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-1 control-label" style="color: #1E7EBE; font-size: 18px;">
                            Bodega:</label>
                        <div class="col-lg-10">
                            <label for="inputEmail1" style="color: #1E7EBE; font-size: 16px; margin-top: 4px;
                                margin-left: 68px;">
                                Nombre Bedega</label>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 2 -->
            <div class="col-4">
                <!-- Observaciones -->
                <div class="col-12 margen">
                    <label for="inputEmail1" class="col-lg-12 control-label" style="color: #213AA2; font-size: 16px;
                        text-align: center;">
                        Observaciones de Despacho</label>
                </div>
                <!-- Text area -->
                <div class="col-12 margen">
                    <textarea class="form-control" rows="5" style="width: 438px; margin-left: -14%; margin-top: -18px;"></textarea>
                </div>
            </div>
            <!-- 3 -->
            <div class="col-4">
                <div class="col-1" style="position: absolute; top: 53px; left: 158px;">
                    <div style="position: relative; margin-top: 10px; margin-left: -48px;">
                        <!-- Icono -->
                        <span class="glyphicons filter" style="zoom: 100%; left: 77px; position: absolute;
                            color: black; margin-top: -4px;"></span><span style="position: absolute; margin-top: 20px;
                                left: 50px; color: black; font-size: 16px; text-align: center;">Filtrar<br>
                                Pendientes</span>
                        <!-- boton -->
                        <input type="submit" name="ctl00$MainContent$Button1" value="" id="Submit4" class="btnCambioClave"
                            style="position: absolute; left: 26px; top: -7px; border: 0; background-color: transparent;
                            height: 50px; width: 64px; z-index: 2;">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- bot -->
    <!-- vacio -->
    <div class="col-12" style="height: 184px;">
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
    <div class="row">
        <div class="col-12" style="margin-top: -170px;">
            <div class="form-horizontal margen" role="form" style="position: relative; border-bottom: 1px solid #00468C;">
                <div class="col-8">
                    <!-- Total -->
                    <div class="form-group">
                        <label for="inputEmail1" class="col-lg-1 control-label" style="color: #2A2C2E; font-size: 18px;
                            margin-top: 24px; margin-left: 30px;">
                            Total:</label>
                        <div class="col-lg-10">
                            <label for="inputEmail1" style="color: #2A2C2E; font-size: 16px; margin-top: 36px;
                                margin-left: 14px;">
                                $</label>
                            <label for="inputEmail1" style="color: #1E7EBE; font-size: 16px; margin-top: 4px;
                                margin-left: 6px;">
                                0000.0</label>
                        </div>
                    </div>
                </div>
                <!-- Guardar, limpiar -->
                <div class="col-2">
                    <div class="form-vertical" role="form" style="margin-top: 10px; border-left: 1px solid #00468C;
                        height: 70px; margin-left: -44%;">
                        <!-- guardar -->
                        <div class="row">
                            <div style="position: relative; top: 18px; left: 8px;">
                                <!-- Icono -->
                                <span class="glyphicons floppy_saved" style="zoom: 88%; left: 54px; top: 0%; position: absolute;
                                    color: black;"></span><span style="position: absolute; margin-top: 20px; left: 36px;
                                        color: black; font-size: 18px;">Grabar</span>
                                <!-- boton -->
                                <input type="submit" name="ctl00$MainContent$Button1" value="" id="Submit2" class="btnCambioClave"
                                    style="position: absolute; left: 26px; top: -7px; border: 0; background-color: transparent;
                                    height: 50px; width: 64px; z-index: 2;">
                            </div>
                        </div>
                        <!-- limpiar -->
                        <div class="row">
                            <div style="position: relative; margin-top: 18px; margin-left: 88px;">
                                <!-- Icono -->
                                <span class="glyphicons restart" style="zoom: 88%; left: 60px; top: 0%; position: absolute;
                                    color: black;"></span><span style="position: absolute; margin-top: 20px; left: 36px;
                                        color: black; font-size: 18px;">Limpiar</span>
                                <!-- boton -->
                                <input type="submit" name="ctl00$MainContent$Button1" value="" id="Submit1" class="btnCambioClave"
                                    style="position: absolute; left: 26px; top: -7px; border: 0; background-color: transparent;
                                    height: 50px; width: 64px; z-index: 2;">
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Imprimir -->
                <div class="col-2">
                    <div class="form-vertical" role="form" style="margin-top: 10px; border-left: 1px solid #00468C;
                        height: 70px; margin-left: -46%;">
                        <!-- imprimir traspaso -->
                        <div class="row">
                            <div class="col-12" style="position: absolute; top: 53px; left: 142px;">
                                <div style="position: relative; margin-top: -44px; margin-left: -248px;">
                                    <!-- Icono -->
                                    <span class="glyphicons print" style="zoom: 116%; left: 81px; position: absolute;
                                        color: black; margin-top: -4px;"></span><span style="position: absolute; margin-top: 24px;
                                            left: 50px; color: black; font-size: 14px; text-align: center;">Imprimir Traspaso<br>
                                            con Fecha de<br>
                                            Vencimiento</span>
                                    <!-- boton -->
                                    <input type="submit" name="ctl00$MainContent$Button1" value="" id="Submit3" class="btnCambioClave"
                                        style="position: absolute; left: 26px; top: -7px; border: 0; background-color: transparent;
                                        height: 50px; width: 64px; z-index: 2;">
                                </div>
                            </div>
                        </div>
                        <!-- imprimir despacho-->
                        <div class="row">
                            <div class="col-12" style="position: absolute; top: 53px; left: 278px;">
                                <div style="position: relative; margin-top: -44px; margin-left: -248px;">
                                    <!-- Icono -->
                                    <span class="glyphicons print" style="zoom: 116%; left: 64px; position: absolute;
                                        color: black; margin-top: -4px;"></span><span style="position: absolute; margin-top: 24px;
                                            left: 50px; color: black; font-size: 14px; text-align: center;">Imprimir<br>
                                            Despacho<br>
                                            Vencimiento</span>
                                    <!-- boton -->
                                    <input type="submit" name="ctl00$MainContent$Button1" value="" id="Submit5" class="btnCambioClave"
                                        style="position: absolute; left: 26px; top: -7px; border: 0; background-color: transparent;
                                        height: 50px; width: 64px; z-index: 2;">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- fin row -->
</asp:Content>
