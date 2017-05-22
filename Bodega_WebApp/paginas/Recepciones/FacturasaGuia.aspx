<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master"
    CodeBehind="FacturasaGuia.aspx.vb" Inherits="Bodega_WebApp.WebForm5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Aviso al padre de la pagina en la que se encuentra -->
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.recepFacturasaGuia%>
    <style>
        .margen
        {
            margin-top: 28px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Nombre del Proveedor -->
    <div class="form-group margen">
        <label for="inputEmail1" class="col-lg-4 control-label" style="color: #1E7EBE; font-size: 17px;">
            Nombre del Proveedor</label>
        <div class="col-lg-2">
            <select name="selectProveedor" class="form-control" style="margin-left: -116%; margin-top: -4%;
                height: 33px;">
            </select>
        </div>
        <div class="col-lg-1">
            <span class="glyphicon glyphicon-check" style="zoom: 154%; left: -122px; margin-top: -1px;
                position: absolute;"></span>
        </div>
    </div>
    <!-- Rut del Proveedor -->
    <div class="row">
        <div class="col-12" style="margin-top: 1%;">
            <div class="form-group ">
                <label for="inputEmail1" class="col-lg-4 control-label" style="color: #1E7EBE; font-size: 17px;">
                    Rut del Proveedor</label>
                <div class="col-lg-2">
                    <select name="selectProveedor" class="form-control" style="margin-left: -116%; margin-top: -4%;
                        height: 33px;">
                    </select>
                </div>
                <div class="col-lg-1">
                    <span class="glyphicon glyphicon-unchecked" style="zoom: 154%; left: -122px; margin-top: -1px;
                        position: absolute;"></span>
                </div>
            </div>
        </div>
    </div>
    <!-- 2º parte -->
    <div class="col-12">
        <div class="form-horizontal" role="form" style="position: relative; border-bottom: 1px solid #00468C;
            margin-top: 1%;">
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="col-4" style="margin-top: 30px;">
                <div class="form-group">
                    <!-- Periodo -->
                    <label for="inputEmail1" class="col-lg-1 control-label" style="color: #1E7EBE; font-size: 15px;
                        font-size: 18px;">
                        Periodo:</label>
                    <div class="col-lg-3">
                        <label for="inputEmail1" style="color: #1E7EBE; font-size: 15px; margin-top: 4px;
                            margin-left: 68px;">
                            2013</label>
                    </div>
                </div>
                <div class="col-4" style="margin-top: 4%; margin-left: -37%;">
                    <div class="form-group">
                        <!-- Guia -->
                        <label for="inputEmail1" class="col-lg-1 control-label" style="color: #1E7EBE; font-size: 15px;
                            font-size: 18px;">
                            Guia:</label>
                        <div class="col-lg-3">
                            <label for="inputEmail1" style="color: #1E7EBE; font-size: 15px; margin-top: 4px;
                                margin-left: 68px;">
                                00000</label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-2">
                <!-- Buscar Todas -->
                <div class="col-6">
                    <div class="form-group" style="text-align: center;">
                        <input type="submit" name="ctl00$MainContent$cmd_enviar" value="Buscar Todas" id="MainContent_cmd_enviar"
                            class="btnEntrar" style="background: url(/assets/imagenes/general/buscar.png)no-repeat;
                            padding-top: 20px; text-align: center; background-position: 50% 0; font-weight: bold;
                            border: 0; margin-top: 36px; margin-left: -202px;">
                    </div>
                </div>
            </div>
            <div class="col-2">
                <!-- Buscar sin Factura -->
                <div class="col-6">
                    <div class="form-group" style="text-align: center;">
                        <input type="submit" name="ctl00$MainContent$cmd_enviar" value="Buscar sin Factura"
                            id="Submit1" class="btnEntrar" style="background: url(/assets/imagenes/general/buscar.png)no-repeat;
                            padding-top: 20px; text-align: center; background-position: 50% 0; font-weight: bold;
                            border: 0; margin-top: 36px; margin-left: -118px;">
                    </div>
                </div>
            </div>
            <div class="col-2" style="margin-top: 10px;">
                <!-- Buscar con Factura -->
                <div class="col-4">
                    <div class="form-group" style="text-align: center;">
                        <input type="submit" name="ctl00$MainContent$cmd_enviar" value="Buscar con Factura"
                            id="Submit2" class="btnEntrar" style="background: url(/assets/imagenes/general/buscar.png)no-repeat;
                            padding-top: 20px; text-align: center; background-position: 50% 0; font-weight: bold;
                            border: 0; margin-top: 14px; margin-left: -66px;">
                    </div>
                </div>
                <!-- Campo de texto -->
                <div class="col-12">
                    <input type="email" class="form-control" id="Email1" placeholder="    NºFactura "
                        style="height: 24px; margin-top: -7px; margin-left: -57px;">
                </div>
            </div>
            <div class="col-2">
                <label for="inputEmail1" class="col-lg-12 control-label" style="color: #1E7EBE; font-size: 15px;
                    text-align: right; margin-top: 6%;">
                    26- agosto - 2013</label>
            </div>
        </div>
    </div>
    <!-- fin row -->
    <!-- 3º parte -->
    <div class="col-12">
        <div class="form-horizontal" role="form" style="position: relative; border-bottom: 1px solid #00468C;
            margin-top: 1%;">
        </div>
    </div>
    <!-- vacio -->
    <div class="col-12" style="height: 184px;">
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
    <div class="row">
        <div class="col-12" style="margin-top: -174px;">
            <div class="form-horizontal margen" role="form" style="position: relative; border-bottom: 1px solid #00468C;">
                <!-- vacio -->
                <div class="col-10">
                </div>
                <!-- footer / guardar, volver, imprimir -->
                <div class="col-2">
                    <div class="form-vertical" role="form" style="margin-top: 10px; border-left: 1px solid #00468C;
                        height: 70px; margin-left: -38%;">
                        <!-- Guardar -->
                        <input type="submit" name="ctl00$MainContent$cmd_enviar" value="Grabar" id="Submit3"
                            class="btnEntrar" style="background: url(/assets/imagenes/general/grabar.png)no-repeat;
                            padding-top: 20px; text-align: center; background-position: 50% 0; font-weight: bold;
                            border: 0; margin-top: 18px; margin-left: 22px;">
                        <!-- limpiar -->
                        <input type="submit" name="ctl00$MainContent$cmd_enviar" value="Limpiar" id="Submit4"
                            class="btnEntrar" style="background: url(/assets/imagenes/general/limpiar.png)no-repeat;
                            padding-top: 20px; text-align: center; background-position: 50% 0; font-weight: bold;
                            border: 0;">
                        <!-- exel -->
                        <input type="submit" name="ctl00$MainContent$cmd_enviar" value="Exel" id="Submit5"
                            class="btnEntrar" style="background: url(/assets/imagenes/general/exel.png)no-repeat;
                            padding-top: 20px; text-align: center; background-position: 50% 0; font-weight: bold;
                            border: 0; margin-left: 10px;">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- fin row -->
</asp:Content>
