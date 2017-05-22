<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master"
    CodeBehind="DevolucionxNPedido.aspx.vb" Inherits="plantilla2013vbasic.DevolucionxNPedido" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, plantilla2013vbasic.Site).idePagina = plantilla2013vbasic.Pagina.recepDevolucionxNPedido%>
    <style>
        .margen
        {
            margin-top: 14px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row" style="margin-top: 26px; margin-left: 34px;">
        <div class="col-4">
            <div class="form-group">
                <!-- numero -->
                <label for="inputEmail1" class="col-lg-3 control-label" style="color: #1E7EBE; font-size: 16px;">
                    Número:</label>
                <div class="col-lg-2">
                    <label for="inputEmail1" class="col-lg-3 control-label" style="color: #646B70; font-size: 16px;">
                        0000</label>
                </div>
            </div>
        </div>
        <div class="col-4">
            <!-- periodo -->
            <label for="inputEmail1" class="col-lg-3 control-label" style="color: #1E7EBE; font-size: 16px;
                left: -89px;">
                Periodo:</label>
            <div class="col-lg-2">
                <label for="inputEmail1" class="col-lg-3 control-label" style="color: #646B70; font-size: 16px;
                    margin-left: -88px;">
                    0000</label>
            </div>
        </div>
    </div>
    <!-- fin row -->
    <!-- 2º parte -->
    <div class="row">
        <div class="col-12">
            <div class="form-horizontal margen" role="form" style="position: relative; border-bottom: 1px solid #00468C;">
            </div>
        </div>
        <div class="col-12 margen">
            <label for="inputEmail1" class="col-lg-12 control-label" style="color: #213AA2; font-size: 16px;
                left: -89px; text-align: center;">
                Observaciones de Despacho</label>
            <label for="inputEmail1" class="col-lg-12 control-label" style="color: #213AA2; font-size: 15px;
                text-align: right; margin-top: -26px;">
                26- agosto - 2013</label>
        </div>
        <div class="col-12 margen">
            <textarea class="form-control" rows="5" style="width: 740px; margin-left: 10%;"></textarea>
        </div>
        <!-- 3º parte -->
        <div class="col-12">
            <div class="form-horizontal margen" role="form" style="position: relative; border-bottom: 1px solid #00468C;">
            </div>
        </div>
    </div>
    <!-- fin row -->
    <!-- vacio -->
    <div class="col-12" style="height: 200px;">
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
    <div class="row">
        <div class="col-12" style="margin-top: -160px;">
            <div class="form-horizontal margen" role="form" style="position: relative; border-bottom: 1px solid #00468C;">
                <!-- vacio -->
                <div class="col-10">
                </div>
                <!-- footer / guardar, volver, imprimir -->
                <div class="col-2">
                    <div class="form-vertical" role="form" style="margin-top: 10px; border-left: 1px solid #00468C;
                        height: 70px; margin-left: -38%;">
                        <!-- Guardar -->
                        <input type="submit" name="ctl00$MainContent$cmd_enviar" value="Grabar" id="MainContent_cmd_enviar"
                            class="btnEntrar" style="background: url(/assets/imagenes/general/grabar.png)no-repeat;
                            padding-top: 20px; text-align: center; background-position: 50% 0; font-weight: bold;
                            border: 0; margin-top: 18px; margin-left: 22px;">
                        <!-- volver -->
                        <input type="submit" name="ctl00$MainContent$cmd_enviar" value="Volver" id="Submit1"
                            class="btnEntrar" style="background: url(/assets/imagenes/general/volver.png)no-repeat;
                            padding-top: 20px; text-align: center; background-position: 50% 0; font-weight: bold;
                            border: 0;">
                        <!-- imprimir -->
                        <input type="submit" name="ctl00$MainContent$cmd_enviar" value="Imprimir" id="Submit2"
                            class="btnEntrar" style="background: url(/assets/imagenes/general/imprimir.png)no-repeat;
                            padding-top: 20px; text-align: center; background-position: 50% 0; font-weight: bold;
                            border: 0;">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- fin row -->
</asp:Content>
