<%@ Page Title="Página principal" Language="vb" MasterPageFile="~/Site.Master" AutoEventWireup="false"
    CodeBehind="Default.aspx.vb" Inherits="Bodega_WebApp._Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.inicio%>
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
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div id="contenedorGrilla">
        <asp:DataGrid ID="detalleMaterialGrid" HeaderStyle-CssClass="cabeceraGrilla" runat="server"
            AutoGenerateColumns="False" CssClass="estiloGrilla">
            <Columns>
                <%--cantidad--%>
                <asp:TemplateColumn HeaderText="Cantidad" HeaderStyle-CssClass="cabeceraRecepciones"
                    ItemStyle-CssClass="contenidoGrillaInput">
                    <ItemTemplate>
                        <input id="cantidadDetalleMat" class="Input" onkeypress="sinpostback()" value="000"
                            runat="server" onchange="checkrate();" />
                    </ItemTemplate>
                </asp:TemplateColumn>
                <%--nro Serie--%>
                <asp:TemplateColumn HeaderText="Nro Serie" HeaderStyle-CssClass="cabeceraRecepciones"
                    ItemStyle-CssClass="contenidoGrillaInput">
                    <ItemTemplate>
                        <input id="nroSerieDetalleMat" class="Input" onkeypress="sinpostback()" value="00000"
                            runat="server" onchange="checkrate();" />
                    </ItemTemplate>
                </asp:TemplateColumn>
                <%--nro Lote--%>
                <asp:TemplateColumn HeaderText="Nro Lote" HeaderStyle-CssClass="cabeceraRecepciones"
                    ItemStyle-CssClass="contenidoGrillaInput">
                    <ItemTemplate>
                        <input id="nroLoteDetalleMat" class="Input" onkeypress="sinpostback()" value="00000"
                            runat="server" onchange="checkrate();" />
                    </ItemTemplate>
                </asp:TemplateColumn>
                <%--Fecha vencimiento--%>
                <asp:TemplateColumn HeaderText="Fecha de Vencimiento" HeaderStyle-CssClass="cabeceraRecepciones"
                    ItemStyle-CssClass="contenidoGrillaInput">
                    <ItemTemplate>
                        <input class="datepicker" />
                    </ItemTemplate>
                </asp:TemplateColumn>
            </Columns>
        </asp:DataGrid>
    </div>
</asp:Content>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="contenedorJavascript">
    <script type="text/javascript">
        function sinpostback() {
            if ((event.keyCode < 48 || event.keyCode > 57) && event.keyCode != 46 && event.keyCode != 45) {
                event.returnValue = false;
            }

        }
        $(function () {
            $(".datepicker").datepicker({ dateFormat: 'dd-mm-yy' });
        });
    </script>
</asp:Content>
