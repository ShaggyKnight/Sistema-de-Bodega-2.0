<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master"
    CodeBehind="cenabast.aspx.vb" Inherits="Bodega_WebApp.cenabast" %>

<asp:Content ID="HeaderContentCenabast" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Aviso al padre de la pagina en la que se encuentra -->
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.cenabast%>
    <!-- Assets de elementos de la pagina -->
    <link href="../assets/css/ingresoCenabast.css" rel="stylesheet" type="text/css" />
    
    <style>
        button.ui-dialog-titlebar-close:after
        {
            content: "\e014";
            font-family: 'Glyphicons Halflings' !important;
            font-style: normal;
            font-weight: 400;
            line-height: 1;
            -webkit-font-smoothing: antialiased;
            color: #006dd9;
        }
        
        button.ui-dialog-titlebar-close
        {
            background-color: transparent;
            border: 0;
        }
        
        .detalleMaterial
        {
            background-color: Transparent;
            border: 0;
        }
        .ui-widget-header
        {
            border: 0;
            background: transparent;
            color: #006dd9;
            font-weight: bold;
        }
        .ui-widget-content
        {
            border: 1px solid #dddddd;
            background: #eeeeee !important;
            color: #333333;
        }
        .detalleMaterialModal
        {
            position: absolute;
            height: auto;
            width: 100%;
            top: 311px;
            left: 334px;
            display: block;
            max-width: 500px;
        }
        .iFrameDetalle
        {
            border: 0;
            width: 100%;
        }
        .estiloGrilla
        {
            width: 100%;
        }
        
        .estiloGrilla input
        {
            color: #006dd9;
            width: 100% !important;
            text-align: center;
        }
        
        .estiloGrilla select
        {
            color: #006dd9;
            width: 100%;
        }
        .cabeceraGrilla
        {
            background-color: #006dd9;
            border-color: #006dd9;
        }
        .cabeceraRecepciones
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
        }
        .cabeceraRecepcionesTotal
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
            width: 8%;
        }
        .cabeceraRecepcionesValor
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
            width: 9%;
        }
        .cabeceraRecepcionesNMaterial
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
            width: 39%;
        }
        .cabeceraRecepcionesCantidad
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
        }
        .cabeceraRecepcionesCodigo
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
            width: 11%;
        }
        .cabeceraRecepcionesARecibir
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
            width: 50px;
        }
        .cabeceraRecepcionesRecepcionado
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
        }
        .cabeceraRecepcionesRecepXFact
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
            width: 132px;
        }
        .contenidoGrilla
        {
            font-family: Arial Rounded MT bold;
            color: #006dd9;
            text-align: center;
        }
        #contenedorGrilla
        {
            overflow: hidden;
            -webkit-border-top-left-radius: 5px;
            -webkit-border-top-right-radius: 5px;
            -moz-border-radius-topleft: 5px;
            -moz-border-radius-topright: 5px;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            background-color: white;
            padding: 0;
            margin-top: 20px;
        }
        
        .btnMoreDetail
        {
            padding: 0;
            height: 30px;
            width: 30px;
            cursor: pointer;
            text-align: center;
        }
        
        .btnMoreDetail:before
        {
            text-align: center;
            color: Black;
            margin: 25%;
            font-size: 100%;
        }
        
        .btnMoreDetail:hover:before
        {
            color: Green;
        }
        .btnDetalleCss
        {
            width: 1%;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContentCenabast" runat="server" ContentPlaceHolderID="MainContent">

    <!--Tabla Principal de Materiales-->
    <div id="contenedorGrilla">
        <asp:DataGrid ID="DataGrid1" HeaderStyle-CssClass="cabeceraGrilla" runat="server"
            AutoGenerateColumns="False" CssClass="estiloGrilla">
            <Columns>
                <asp:BoundColumn DataField="Codigo" HeaderText="Codigo" HeaderStyle-CssClass="cabeceraRecepcionesCodigo"
                    ItemStyle-CssClass="codigos contenidoGrilla"></asp:BoundColumn>
                <asp:BoundColumn DataField="NombreMaterial" HeaderText="Nombre Material" HeaderStyle-CssClass="cabeceraRecepcionesNMaterial"
                    ItemStyle-CssClass="contenidoGrilla"></asp:BoundColumn>
                <asp:BoundColumn DataField="aRecibir" HeaderText="A Recibir" HeaderStyle-CssClass="cabeceraRecepcionesARecibir"
                    ItemStyle-CssClass="contenidoGrilla"></asp:BoundColumn>
                <asp:TemplateColumn HeaderText="Factor" HeaderStyle-CssClass="cabeceraRecepciones"
                    ItemStyle-CssClass="contenidoGrillaInput">
                    <ItemTemplate>
                        <input name="factor" id="fator" class="Input" onkeypress="sinpostback()" placeholder="000" runat="server"
                            onchange="checkrate();" />
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="cantidad" HeaderText="Cantidad" HeaderStyle-CssClass="cabeceraRecepcionesCantidad"
                    ItemStyle-CssClass="contenidoGrilla"></asp:BoundColumn>
                <asp:BoundColumn DataField="valor" HeaderText="Valor" HeaderStyle-CssClass="cabeceraRecepcionesValor"
                    ItemStyle-CssClass="contenidoGrilla"></asp:BoundColumn>
                <asp:TemplateColumn HeaderText="Recepciones por Factura" HeaderStyle-CssClass="cabeceraRecepciones"
                    ItemStyle-CssClass="contenidoGrillaInput">
                    <ItemTemplate>
                        <input id="recepXFact" class="Input" onkeypress="sinpostback()" placeholder="00000"
                            runat="server" onchange="checkrate();" />
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Recepcionado" HeaderStyle-CssClass="cabeceraRecepcionesRecepcionado">
                    <ItemTemplate>
                        <asp:DropDownList ID="DropDownList2" runat="server">
                        </asp:DropDownList>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="total" HeaderText="Total" HeaderStyle-CssClass="cabeceraRecepcionesTotal"
                    ItemStyle-CssClass="contenidoGrilla"></asp:BoundColumn>
                <asp:TemplateColumn>
                    <ItemTemplate>
                        <button id="btnDetalleMaterial" class="detalleMaterial glyphicon glyphicon-plus-sign" onclick="return false;" />
                    </ItemTemplate>
                </asp:TemplateColumn>
            </Columns>
        </asp:DataGrid>
    </div>
    <!-- Fin contenedor Grilla -->
</asp:Content>
<asp:Content ID="ContentCenabastIcons" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
    <div style="height: 90px; position: absolute; top: -90px; border-top: solid 2px #00468C;
        width: 100%;">
        <div style="position: absolute; top: 22px; right: 100px; cursor: pointer;" class="sobre">
            <div class="glyphicons floppy_saved" style="margin-left: 15px;">
                &nbsp;</div>
            <div style="font-size: 16px; font-weight: bold; margin-top: 6px;">
                Grabar</div>
        </div>
        <div style="position: absolute; top: 22px; right: 20px; cursor: pointer;" class="sobre">
            <div class="glyphicons print" style="margin-left: 20px;">
                &nbsp;</div>
            <div style="font-size: 16px; font-weight: bold; margin-top: 6px;">
                Imprimir</div>
        </div>
        <div style="position: absolute; top: 22px; right: 170px; cursor: pointer;" class="sobre">
            <div class="glyphicons restart" style="margin-left: 18px;">
                &nbsp;</div>
            <div style="font-size: 16px; font-weight: bold; margin-top: 6px;">
                Limpiar</div>
        </div>
        <div style="top: 3px; width: 2px; height: 80px; background-color: #00468C; position: absolute;
            right: 260px;">
        </div>
    </div>
</asp:Content>
<asp:Content ID="ContentCenabastJScript" runat="server" ContentPlaceHolderID="contenedorJavascript">
    <script type="text/javascript">
        function sinpostback() {
            if ((event.keyCode < 48 || event.keyCode > 57) && event.keyCode != 46 && event.keyCode != 45) {
                event.returnValue = false;
            }
        }
        $(function () {

            $("#dialog-form").dialog({
                close: function (event, ui) { remove(); },
                autoOpen: false,
                height: 660,
                width: 800,
                modal: true,
                buttons: {
                    "Guardar": function () {
                        document.getElementById('iframeDetalleMaterial').contentWindow.postBack();
                        $(this).dialog("close");
                    },
                    Cancel: function () {
                        $(this).dialog("close");
                    }
                }
            });


            $(".detalleMaterial").bind("click", function () {
                // Get the value
                var $idProducto = $(this).parent().parent().children(".codigos").text();

                // Set the value to from and force a sumbit. The submit is for reload data of iframe 'iframeDetalleMaterial'
                $("#codigoPadre").val($idProducto);
                document.getElementById('submitFormIframe').click()

                // Open dialog to open modal with iframe of 'Detalle Ingreso'
                $("#dialog-form").dialog("open");
            });
        });
        function remove(){
            var frame = document.getElementById("iframeDetalleMaterial");
            var frameDoc = frame.contentDocument || frame.contentWindow.document;
            frameDoc.removeChild(frameDoc.documentElement);
        }
    </script>
    <!--detalles de materiales a iFrame-->

    <!--modal Content-->
    <div id="dialog-form" title="Detalle Material">
        <div id="modalDetalle">
            <iframe id="iframeDetalleMaterial" name="iframeDetalleMaterial" src="" class="iFrameDetalle" height="520">
            </iframe>
        </div>
        <form target="iframeDetalleMaterial" method="POST" class="formDetalleMaterial" id="formDetalleMaterial" action="detalleMateriales.aspx" style="display:none;">
            <input type="text" class="value" size="40" value="" name="codigoPadre" id="codigoPadre"/>
            <input id="submitFormIframe" type="submit" name="submit" value="Submit"/>
        </form>
    </div>
</asp:Content>
