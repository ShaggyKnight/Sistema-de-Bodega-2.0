<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master"
    CodeBehind="DesdeProveedores.aspx.vb" Inherits="plantilla2013vbasic.DesdeProveedores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Aviso al padre de la pagina en la que se encuentra -->
    <%  CType(Me.Page.Master, plantilla2013vbasic.Site).idePagina = plantilla2013vbasic.Pagina.recepDesdeProveedores%>
    <style>
        .margen
        {
            margin-top: 24px;
        }
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
        .rowMateriales
        {
            border-top: 1px solid darkblue;
            display: inline-block;
        }
        .datsEstado
        {
            display: none;
        }
        #MainContent_contenedorGrilla
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
            margin-bottom: 20px;
            display: none;
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
        .btn_ordenesCompra
        {
            width: 28px;
            height: 23px;
            margin-left: -55px;
            margin-top: 7px;
            background: transparent;
            z-index: 2;
        }
        .nroOrdenCompra
        {
            margin-top: 13px;
            width: 44%;
        }
        .ivaSiNo
        {
            width: 16px;
            margin-left: 30px !important; 
            margin-top: -4px !important;
        }
        .iconDif:before
        {
            font-size: 20px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form-horizontal margen" role="form" style="position: relative; border-bottom: 1px solid #00468C;">
        <div class="form-group">
            <!-- Buscar Orden de Compra -->
            <label for="inputNroOC" class="col-lg-2 control-label" style="color: #1E7EBE; font-size: 15px;
                width: 242px;">
                NºORDEN DE COMPRA:</label>
            <div class="col-lg-2">
                <input type="text" class="form-control" id="nroOC" placeholder="Nº O.C" runat="server"
                    onkeypress="controKeyBuscar()" style="height: 24px; margin-top: 6px; margin-left: -22px;" />
            </div>
            <div class="col-lg-1">
                <span class="glyphicon glyphicon-share" style="zoom: 130%; left: -26px; margin-top: 6px;
                    position: absolute; z-index: -1;"></span>
                <asp:Button ID="buscarMats" class="buscarMats btn btn_ordenesCompra" runat="server" OnClick="buscarMats_Click" />
            </div>
        </div>
    </div>
    <div class="row">
        <div class="datsEstado" runat="server" id="datsEstado">
            <!-- 1º Parte -->
            <div class="col-12">
                <!-- lado izquierdo -->
                <div class="col-8 margen" style="margin-right: -68px; margin-left: -15px; width: 863px;">
                    <div class="col-12">
                        <div class="form-group">
                            <!-- Estado de Orden de Compra -->
                            <label for="inputEmail1" class="col-lg-1 control-label" style="color: #1E7EBE; font-size: 15px;">
                                Estado:</label>
                            <div class="col-lg-3" style="width: 334px;">
                                <asp:Label ID="estadoOC" runat="server" for="inputEmail1" Style="color: #1E7EBE;
                                    font-size: 13px; margin-top: 1px; margin-left: 56px;">----</asp:Label>
                            </div>
                            <label for="bodegaRecepcion" class="col-lg-4 control-label" style="color: #1E7EBE;
                                font-size: 16px; margin-left: 10%;">
                                Bodega Recepcion</label>
                        </div>
                    </div>
                    <div class="col-12 margen">
                        <div class="form-group">
                            <!-- Nº Recepcion -->
                            <label for="nroRecepcion" class="col-lg-2 control-label" style="color: #1E7EBE; font-size: 15px;">
                                Número de Recepcion:</label>
                            <div class="col-lg-2" style="width: 279px;">
                                <asp:Label ID="nroRecepcion" runat="server" for="nroRecepcion" Style="color: #1E7EBE;
                                    font-size: 13px; margin-top: 12px" >----</asp:Label>
                            </div>
                            <asp:DropDownList ID="selecBodegas" class="col-lg-3 form-control" runat="server"
                                Style="height: 33px; width: 313px; margin-left: 4px">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <!-- Proveedor -->
                    <div class="col-12 margen">
                        <div class="form-group">
                            <label for="proveedor" class="col-lg-2 control-label" style="color: #1E7EBE; font-size: 15px;
                                text-align: left; width: 122px;">
                                Proveedor:</label>
                            <div class="col-lg-3" style="width: 290px;">
                                <asp:Label ID="proveedor" runat="server" for="proveedor" Style="color: #1E7EBE; font-size: 13px;" >----</asp:Label>
                            </div>
                            <label for="tipoDocumento" class="col-lg-4 control-label" style="color: #1E7EBE;
                                font-size: 16px; margin-left: 8%;">
                                Tipo de Documento</label>
                        </div>
                    </div>
                    <div class="col-12 margen">
                        <div class="form-group">
                            <!-- Nº de Documento -->
                            <label for="numDocumento" class="col-lg-2 control-label" style="color: #1E7EBE; font-size: 15px;">
                                Número del Dcumento:</label>
                            <div class="col-lg-2" style="width: 251px;">
                                <asp:TextBox ID="nroDocumento" runat="server" class="form-control" placeholder="----" for="nroDocumento" Style="color: #1E7EBE;
                                    font-size: 13px; margin-left: -10px; height: 30px; margin-top: 6px;"></asp:TextBox>
                            </div>
                            <asp:DropDownList id="tipoDocumento" class="col-lg-3 form-control" runat="server" style="height: 33px; width: 176px;
                                margin-left: 102px; margin-top: -16px;">
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <!-- lado derecho -->
                <div class="col-lg-4">
                    <div class="form-vertical" role="form" style="margin-top: 9px; border-left: 1px solid #00468C;
                        height: 240px; margin-left: -7%; margin-right: -4px;">
                        <div class="col-12">
                            <!-- Fecha -->
                            <!--<div class="form-group">-->
                            <asp:Label id="fechaServidor" for="fechaServidor" runat="server" class="col-lg-12 control-label" style="color: #1E7EBE;
                                font-size: 15px; text-align: right;"></asp:Label>
                        </div>
                        <div class="col-12 margen">
                            <!-- IVA -->
                            <div class="form-group">
                                <label for="campoIva" class="col-lg-2 control-label" style="color: #1E7EBE; font-size: 18px;
                                    margin-left: 23%;">
                                    I.V.A</label>
                                <div class="col-lg-2">
                                    <div class="checkbox">
                                        <label>
                                            <input id="ivaSiNo" class="ivaSiNo" type="checkbox" checked="checked" style="zoom: 184%;">
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="form-horizontal margen" role="form" style="position: relative; border-bottom: 1px solid #00468C;">
                                <!-- Valor -->
                                <div class="form-group">
                                    <label for="precioOC" class="col-lg-4 control-label" style="color: #1E7EBE; font-size: 17px;
                                        margin-left: 8%;">
                                        Valor O/C</label>
                                    <div class="col-lg-4">
                                        <asp:label id="precioOC" for="precioOC" name="precioOC" runat="server" class="precioOC col-lg-4 control-label" style="color: #1E7EBE;
                                            font-size: 18px; margin-left: 13%;">
                                            $0000</asp:label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <!-- Total Acumulado -->
                            <div class="form-group">
                                <label for="totalAcumulado" class="col-lg-5 control-label" style="color: #1E7EBE;
                                    font-size: 18px; margin-left: 4%; margin-top: 7%;">
                                    Total Acumulado</label>
                                <div class="col-lg-4">
                                    <asp:label id="totalAcumulado" for="totalAcumulado" runat="server" class="col-lg-4 control-label" style="color: #1E7EBE;
                                        font-size: 18px; margin-left: -4%; margin-top: 25%;">$0000</asp:label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 2º parte -->
            <div class="col-12">
                <div class="form-horizontal" role="form" style="position: relative; border-bottom: 1px solid #00468C; margin-top: 10px;">
                </div>
            </div>
            <!-- Observaciones -->
            <div class="col-12">
                <!-- Observaciones Orden de Compra-->
                <div class="col-6">
                    <div class="form-group">
                        <label for="observacionOC" class="col-lg-12 control-label" style="color: #1E7EBE;
                            font-size: 16px; margin-left: 4%; margin-top: 5%; text-align: center;">
                            Observaciones de la Recepción</label>
                        <asp:Textbox id="observacionOC" mode="multiline" runat="server" class="form-control" cols="1" rows="4" style="width: 460px; margin-left: 10%;"></asp:Textbox>
                    </div>
                </div>
                <!-- Observacion de Documento-->
                <div class="col-6">
                    <div class="form-vertical" role="form" style="margin-top: 10px; border-left: 1px solid #00468C;
                        height: 200px;">
                        <div class="col-12">
                            <label for="observacionDoc" class="col-lg-12 control-label" style="color: #1E7EBE;
                                font-size: 16px; margin-left: 4%; margin-top: 3%; text-align: center;">
                                Observaciones de Orden de Compra</label>
                            <asp:label id="observacionDoc" for="observacionDoc" class="col-lg-12 control-label" runat="server" style="color: #4A4D50;
                                font-size: 16px; margin-left: 4%; margin-top: 4%; text-align: center;">
                                No hay observaciones...</asp:label>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 3º parte -->
            <div class="col-12">
                <!--<div class="form-horizontal margen" role="form" style="position: relative; border-top: 1px solid #00468C;
                top: -14px;">
            </div>-->
            </div>
        </div>
    </div>
    <!-- 4º Parte -->
    <div class="rowMateriales">
        <!--Tabla Principal de Materiales-->
        <div id="contenedorGrilla" class="contenedorGrilla" runat="server">
            <asp:DataGrid ID="DataGrid1" HeaderStyle-CssClass="cabeceraGrilla" runat="server"
                AutoGenerateColumns="False" CssClass="estiloGrilla" >
                <Columns>
                    <asp:BoundColumn DataField="Codigo" HeaderText="Codigo" HeaderStyle-CssClass="cabeceraRecepcionesCodigo"
                        ItemStyle-CssClass="codigos contenidoGrilla"></asp:BoundColumn>
                    <asp:BoundColumn DataField="NombreMaterial" HeaderText="Nombre Material" HeaderStyle-CssClass="cabeceraRecepcionesNMaterial"
                        ItemStyle-CssClass="contenidoGrilla"></asp:BoundColumn>
                    <asp:BoundColumn DataField="UnidMedida" HeaderText="Unidad" HeaderStyle-CssClass="cabeceraRecepcionesARecibir"
                        ItemStyle-CssClass="contenidoGrilla"></asp:BoundColumn>
                    <asp:BoundColumn DataField="aRecibir" HeaderText="A Recibir" HeaderStyle-CssClass="cabeceraRecepcionesARecibir"
                        ItemStyle-CssClass="cantARecibir contenidoGrilla"></asp:BoundColumn>
                    <asp:TemplateColumn HeaderText="Factor" HeaderStyle-CssClass="factor cabeceraRecepciones"
                        ItemStyle-CssClass="contenidoGrillaInput">
                        <ItemTemplate>
                            <input name="lblFactor" id="lblFactor" class="lblFactor Input" onkeypress="sinpostback()" placeholder="000"
                                runat="server" onblur="cantidadXFactor()" />
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:BoundColumn DataField="cantidad" HeaderText="Cantidad" HeaderStyle-CssClass="labelCantidad cabeceraRecepcionesCantidad"
                        ItemStyle-CssClass="labelCantidad contenidoGrilla"></asp:BoundColumn>
                    <asp:BoundColumn DataField="valor" HeaderText="Valor" HeaderStyle-CssClass="cabeceraRecepcionesValor"
                        ItemStyle-CssClass="valorNeto contenidoGrilla"></asp:BoundColumn>
                    <asp:TemplateColumn HeaderText="Recepciones por Factura" HeaderStyle-CssClass="cabeceraRecepciones"
                        ItemStyle-CssClass="contenidoGrillaInput">
                        <ItemTemplate>
                            <input id="recepXFact" class="Input" onkeypress="sinpostback()" placeholder="00000"
                                runat="server" onchange="checkrate();" />
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:BoundColumn DataField="recepcionado" HeaderText="Recepcionado" HeaderStyle-CssClass="cabeceraRecepcionesRecepcionado"
                        ItemStyle-CssClass="contenidoGrilla"></asp:BoundColumn>
                    <asp:BoundColumn DataField="total" HeaderText="Total" HeaderStyle-CssClass="cabeceraRecepcionesTotal"
                        ItemStyle-CssClass="totalMaterial contenidoGrilla"></asp:BoundColumn>
                    <asp:TemplateColumn>
                        <ItemTemplate>
                            <button id="btnDetalleMaterial" class="detalleMaterial glyphicon glyphicon-plus-sign"
                                onclick="return false;" />
                        </ItemTemplate>
                    </asp:TemplateColumn>
                </Columns>
            </asp:DataGrid>
        </div>
    </div>
    <!-- Fin contenedor Grilla -->
    <div style="height: 100px;">
    </div>
    <!-- div class row -->
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
    <div class="row">
        <div class="col-12">
            <div class="form-horizontal margen" role="form" style="position: absolute; border-top: 1px solid #00468C;
                top: -192px; margin-right: 16px;">
                <!-- lado izquierdo -->
                <div id="footIzqExterno" class="footIzq col-7" runat="server" style="float: left; width: 732px;">
                    <div id="footIzqInterno" class="footIzq col-7" runat="server" style="display:none; width: 720px;">
                        <!-- precio neto / descuento / I.V.A -->
                        <div class="col-4" style="margin-top: 2%;">
                            <div class="col-12">
                                <div class="col-12">
                                    <label for="precioNetoFoot" class=" col-lg-9 control-label" style="color: #1E7EBE; font-size: 14px;
                                        margin-top: -9px; position: absolute; left: -11%; width: 120px;">
                                        Precio Neto:
                                    </label>
                                    <asp:label id="precioNetoFoot" class="precioNetoFoot" for="precioNetoFoot" runat="server" style="color: #1E7EBE; font-size: 13px; margin-top: 21px;
                                        margin-left: 96px;">
                                        $0</asp:label>
                                </div>
                                <div class="col-12" style=" margin-top: 8px;">
                                    <label for="descuentoFoot" class="col-lg-9 control-label" style="color: #1E7EBE; font-size: 14px;
                                        margin-top: -9px; position: absolute; left: -11%;">
                                        Descuento:
                                    </label>
                                    <asp:label id="descuentoFoot" class="descuentoFoot" runat="server" for="descuentoFoot" style="color: #1E7EBE; font-size: 13px; margin-top: 8px;
                                        margin-left: 96px;">
                                        $0</asp:label>
                                </div>
                                <div class="col-12" style=" margin-top: 8px;">
                                    <label for="valorIvaFoot" class="col-lg-9 control-label" style="color: #1E7EBE; font-size: 14px;
                                        margin-top: -9px; position: absolute; left: -11%;">
                                        I.V.A:
                                    </label>
                                    <asp:label id="valorIvaFoot" class="valorIvaFoot" runat="server" for="valorIvaFoot" style="color: #1E7EBE; font-size: 13px; margin-top: 8px;
                                        margin-left: 96px;">
                                        $0</asp:label>
                                </div>
                            </div>
                        </div>
                        <!-- impuesto / total recepcion / total O/C -->
                        <div class="col-4" style="margin-top: 2%;">
                            <div class="col-12">
                                <label for="impuestoFoot" class="col-lg-9 control-label" style="color: #1E7EBE; font-size: 14px;
                                    margin-top: -9px; position: absolute; left: -11%;">
                                    Impuesto:
                                </label>
                                <asp:label id="impuestoFoot" runat="server" for="impuestoFoot" style="color: #1E7EBE; font-size: 13px; margin-top: 21px;
                                    margin-left: 102px;">
                                    $0</asp:label>
                            </div>
                            <div class="col-12" style=" margin-top: 8px;">
                                <label for="totalRecepcionFoot" class="col-lg-12 control-label" style="color: #1E7EBE; font-size: 14px;
                                    margin-top: -9px; position: absolute; left: -36%;">
                                    Total Recepcion:
                                </label>
                                <asp:label id="totalRecepcionFoot" class="totalRecepcionFoot" runat="server" for="totalRecepcionFoot" style="color: #1E7EBE; font-size: 13px; margin-top: 21px;
                                    margin-left: 102px;">
                                    $0</asp:label>
                            </div>
                            <div class="col-12" style=" margin-top: 3px;">
                                <label for="totalOCFoot" class="col-lg-9 control-label" style="color: #1E7EBE; font-size: 14px;
                                    margin-top: -9px; position: absolute; left: -11%;">
                                    Total O/C:
                                </label>
                                <asp:label id="totalOCFoot" class="totalOCFoot" runat="server" for="totalOCFoot" style="color: #1E7EBE; font-size: 13px;
                                    margin-left: 102px;">
                                    $0</asp:label>
                            </div>
                        </div>
                        <!-- diferencia de peso -->
                        <div class="col-3">
                            <div class="col-12">
                                <label for="difPesoFoot" class="col-lg-12 control-label" style="color: #1E7EBE; font-size: 14px;
                                    margin-top: 2px; left: 3%; width: 141px;">
                                    Dif. de Peso:
                                </label>
                            </div>
                            <div class="col-12">
                                <asp:label id="difPesoFoot" runat="server" for="difPesoFoot" style="color: #1E7EBE; font-size: 13px; margin-top: 48px;
                                    margin-left: 52%; margin-right: 50%;" class="difPesoFoot">$0</asp:label>
                            </div>
                            <div class="col-12">
                                <div class="col-6">
                                    <span class="glyphicons plus iconDif" style="font-size: 26px; margin-left: 22px; position: absolute;"></span>
                                    <button name="sumPeso" value="" id="sumPeso" class="sumPeso"
                                        style="position: absolute; left: 27px; top: -2px; border: 0; background-color: transparent;
                                        height: 28px; width: 36px; z-index: 2;" onClick="return false;"/>
                                </div>
                                <div class="col-6">
                                    <span class="glyphicons minus iconDif" style="font-size: 38px; position: absolute; margin-left: 26px;"></span>
                                    <button name="restPeso" value="" id="restPeso" class="restPeso"
                                        style="position: absolute; left: 29px; top: 0px; border: 0; background-color: transparent;
                                        height: 28px; width: 36px; z-index: 2;" onClick="return false;"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- lado derecho -->
                <!-- footer / Buscar, limpiar, grabar, imprimir -->
                <div class="col-5" style="float: right; width: 437px;">
                    <div class="form-vertical" role="form" style="margin-top: 10px; border-left: 1px solid #00468C;
                        height: 90px;">
                        <div class="col-12">
                            <!-- Buscar Recepcion -->
                            <div class="col-1">
                                <div style="position: relative; margin-top: 10px; margin-left: -48px;">
                                    <!-- Icono -->
                                    <span class="glyphicons search" style="zoom: 88%; left: 86px; top: 0%; position: absolute;
                                        color: black;"></span><span style="position: absolute; margin-top: 20px; left: 50px;
                                            color: black; font-size: 16px; text-align: center;">Buscar<br>
                                            Recepcion</span>
                                    <!-- boton -->
                                    <input type="submit" name="ctl00$MainContent$Button1" value="" id="Submit4" class="btnCambioClave"
                                        style="position: absolute; left: 26px; top: -7px; border: 0; background-color: transparent;
                                        height: 50px; width: 64px; z-index: 2;">
                                </div>
                            </div>
                            <!-- Buscar O/C -->
                            <div class="col-1">
                                <div style="position: relative; left: 30px; top: 10px;">
                                    <!-- Icono -->
                                    <span class="glyphicons search" style="zoom: 88%; left: 56px; top: 0%; position: absolute;
                                        color: black;"></span><span style="position: absolute; margin-top: 20px; left: 36px;
                                            color: black; font-size: 16px; text-align: center;">Buscar O/C</span>
                                    <!-- boton -->
                                    <input type="submit" name="ctl00$MainContent$Button1" value="" id="Submit2" class="btnCambioClave"
                                        style="position: absolute; left: 26px; top: -7px; border: 0; background-color: transparent;
                                        height: 50px; width: 64px; z-index: 2;">
                                </div>
                            </div>
                            <!--inicio div footer derecho-->
                            <!-- Limpiar -->
                            <div id="footDer" class="footDer" runat="server">
                                <div class="col-1">
                                    <div style="position: relative; left: 72px; top: 14px;">
                                        <!-- Icono -->
                                        <span class="glyphicons restart" style="zoom: 88%; left: 60px; top: 0%; position: absolute;
                                            color: black;"></span><span style="position: absolute; margin-top: 20px; left: 36px;
                                                color: black; font-size: 16px;">Limpiar</span>
                                        <!-- boton -->
                                        <input type="submit" name="ctl00$MainContent$Button1" value="" id="Submit3" class="btnCambioClave"
                                            style="position: absolute; left: 26px; top: -7px; border: 0; background-color: transparent;
                                            height: 50px; width: 64px; z-index: 2;">
                                    </div>
                                </div>
                                <!-- Grabar -->
                                <div class="col-1">
                                    <div style="position: relative; left: 110px; top: 15px;">
                                        <!-- Icono -->
                                        <span class="glyphicons floppy_saved" style="zoom: 88%; left: 58px; top: 0%; position: absolute;
                                            color: black;"></span><span style="position: absolute; margin-top: 20px; left: 36px;
                                                color: black; font-size: 16px;">Grabar</span>
                                        <!-- boton -->
                                        <asp:button name="guardarRecepcion" value="" id="guardarRecepcion" runat="server" class="guardarRecepcion"
                                            style="position: absolute; left: 26px; top: -7px; border: 0; background-color: transparent;
                                            height: 50px; width: 64px; z-index: 2;" OnClientClick="guardarRecepcion_Click; return false" />
                                    </div>
                                </div>
                                <!-- Imprimir -->
                                <div class="col-1">
                                    <div style="position: relative; left: 150px; top: 16px;">
                                        <!-- Icono -->
                                        <span class="glyphicons print" style="zoom: 88%; left: 60px; top: 0%; position: absolute;
                                            color: black;"></span><span style="position: absolute; margin-top: 20px; left: 36px;
                                                color: black; font-size: 16px;">Imprimir</span>
                                        <!-- boton -->
                                        <input type="submit" name="ctl00$MainContent$Button1" value="" id="Submit5" class="btnCambioClave"
                                            style="position: absolute; left: 26px; top: -7px; border: 0; background-color: transparent;
                                            height: 50px; width: 64px; z-index: 2;">
                                    </div>
                                </div>
                            </div>
                            <!--fin div footer derecho-->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- fin row -->
    <div id="dialog">
        <p>
            <span class="glyphicons circle_exclamation_mark" style="float: left; margin: 0 -2px 25px 0; margin-top: 9px;"></span>
            ¿La bodega de la recepcion no corresponde a sus permisos de usuario desea recepcionarla de todas maneras?
        </p>
    </div>
</asp:Content>
<asp:Content ID="ContentCenabastJScript" runat="server" ContentPlaceHolderID="contenedorJavascript">
    
    <script type="text/javascript">
        var $labelCantidad = null;
        var $arecibir = null;
        var $totalMaterial = null;
        var $valorNeto = null;

        $("#dialog").dialog({
            dialogClass: "no-close",
            resizable: false,
            draggable: false,
            autoOpen: false,
            height: 200,
            width: 500,
            modal: true,
            buttons: [{
                text: "Si",
                click: function () {
                    $(".datsEstado").css("display","inline-block");
                    $(".contenedorGrilla").css("display","inline-block");
                    $(".footDer").css("display","inline-block");
                    $(this).dialog("close");
                }
            }, {
                text: "Cancelar",
                click: function () {
                    $(".datsEstado").html("");
                    $(".contenedorGrilla").html("");
                    $(".footIzq").html("");
                    $(".footDer").html("");
                    $(this).dialog("close");
                }
            }]
        });

        <% If Not Me.bodegaValida Then %>
            $("#dialog").dialog("open");
        <% End If%>

        function controKeyBuscar() {
            if ((event.keyCode < 48 || event.keyCode > 57)) {
                event.returnValue = false;
                if (event.keyCode == 13) {
                    $(".buscarMats").click();
                }
            }
        }

        function sinpostback() {
            if (event.keyCode < 48 || event.keyCode > 57) {
                event.returnValue = false;
            }
        }

        function sinpostbackLote() {
            if ((event.keyCode < 48 || event.keyCode > 90) && event.keyCode != 46 && event.keyCode != 45) {
                event.returnValue = false;
            }
        }

        $(function () {

            $("#dialog-form").dialog({
                resizable: false,
                draggable: false,
                close: function (event, ui) { remove(); },
                autoOpen: false,
                height: 660,
                width: 800,
                modal: true,
                buttons: {
                    "Guardar": function () {

                        var $nuevaCantidad = document.getElementById('iframeDetalleMaterial').contentWindow.sumarCantidades();
                        var $validacion = document.getElementById('iframeDetalleMaterial').contentWindow.datosCompletados();
                        if ($validacion == true) {
                            if ($nuevaCantidad > $arecibir) {
                                alert("LOS PRODUCTOS NO PUEDEN SUPERAR LA CANTIDAD A RECIBIR");
                            } else {
                                $labelCantidad.text($nuevaCantidad);
                                var $valorDouble = $valorNeto.text().replace("$", "");
                                while($valorDouble.indexOf(".") !== -1){
                                    $valorDouble = $valorDouble.replace(".", "");
                                }
                                $ivaChecked = document.getElementById("ivaSiNo").checked;
                                if ($ivaChecked) {
                                    $valorTotal = ($valorDouble * $nuevaCantidad) * 1.19;
                                    $valorTotal.toFixed(2);
                                    $valorTotal = accounting.formatMoney($valorTotal, "$", ",", ".");
                                    alert($valorTotal);
                                    $totalMaterial.text($valorTotal);
                                    cargaFooter();
                                    
                                } else {
                                    $valorTotal = ($valorDouble * $nuevaCantidad);
                                    $valorTotal.toFixed(2);
                                    $valorTotal = accounting.formatMoney($valorTotal, "$", ",", ".");
                                    $totalMaterial.text($valorTotal);
                                    cargaFooter();
                                }
                                document.getElementById('iframeDetalleMaterial').contentWindow.postBack();
                                $(this).dialog("close");
                            }
                        } else {
                            alert("DEBE COMPLETAR TODOS LOS CAMPOS");
                        }
                        
                    },
                    Cancel: function () {
                        $(this).dialog("close");
                    }
                }
            });

            $(".detalleMaterial").bind("click", function () {
                // Get the value
                var $idProducto = $(this).parent().parent().children(".codigos").text();

                $labelCantidad = $(this).parent().parent().children(".labelCantidad");
                $totalMaterial = $(this).parent().parent().children(".totalMaterial");
                $valorNeto = $(this).parent().parent().children(".valorNeto");
                $arecibir = parseFloat($(this).parent().parent().children(".cantARecibir").text());

                // Set the value to from and force a sumbit. The submit is for reload data of iframe 'iframeDetalleMaterial'
                $("#codigoPadre").val($idProducto);
                document.getElementById('submitFormIframe').click();

                // Open dialog to open modal with iframe of 'Detalle Ingreso'
                $("#dialog-form").dialog("open");
            });

        });

        function remove() {
            var frame = document.getElementById("iframeDetalleMaterial");
            var frameDoc = frame.contentDocument || frame.contentWindow.document;
            frameDoc.removeChild(frameDoc.documentElement);
        }

        

        function cargaFooter(){
            valor = "";
            var iva = null;
            var totalIva = null;
            var cantidad = null;
            var neto = null;
            var netoTotal = null;
            var impuesto = null;
            var total = null;
            var totaloc = null;

            $rows = document.getElementById('<%=DataGrid1.ClientID%>').rows;
            $dGrid = document.getElementById('<%=DataGrid1.ClientID%>').rows.length;
            
            for (var i = 1; i < $dGrid; i++) {
                cantidad = parseInt($rows[i].cells[5].innerText);

                valor = $rows[i].cells[6].innerText;
                valor = valor.replace("$", "");

                while(valor.indexOf(".") !== -1){
                    valor = valor.replace(".", "");
                }

                neto = parseFloat(valor) * cantidad;
                netoTotal += parseFloat(valor)*cantidad;

                if(document.getElementById("ivaSiNo").checked ){

                    iva += neto * 0.19;

                }else{

                    iva = 0;
                }
                

                valor = $rows[i].cells[9].innerText;
                valor = valor.replace("$", "");

                while(valor.indexOf(".") !== -1){
                    valor = valor.replace(".", "");
                }
                total += parseFloat(valor);
            }

            if(document.getElementById("ivaSiNo").checked ){

                    totaloc = totaloc*1.19;

            }
            totaloc = netoTotal * 1.19;
            totaloc = accounting.formatMoney(totaloc, "$", ",", ".");
            netoTotal = accounting.formatMoney(netoTotal, "$", ",", ".");
            iva = accounting.formatMoney(iva, "$", ",", ".");
            total = accounting.formatMoney(total, "$", ",", ".");
            $(".footIzq").css("display","inline-block");
            $(".precioNetoFoot").text(netoTotal);
            $(".valorIvaFoot").text(iva);
            $(".totalRecepcionFoot").text(total);
            $(".totalOCFoot").text(totaloc);
        }

        function sumaDif() {
            var iva = null;
            var neto = null;
            var netoTotal = null;
            var total = null;

            var difPeso = $(".difPesoFoot").text();
            difPeso = difPeso.replace("$", "");

            while(difPeso.indexOf(".") !== -1){
                difPeso = difPeso.replace(".", "");
            }
            difPeso = parseInt(difPeso);
            if(difPeso<1000){
                difPeso += 1;
                difPeso = accounting.formatMoney(difPeso, "$", ",", ".");
                $(".difPesoFoot").text(difPeso);

                //difPeso valor Neto
                netoTotal = $(".precioNetoFoot").text();
                netoTotal = netoTotal.replace("$", "");

                while(netoTotal.indexOf(".") !== -1){
                    netoTotal = netoTotal.replace(".", "");
                }
                netoTotal = parseInt(netoTotal);

                netoTotal += 1;
            
                netoTotal = accounting.formatMoney(netoTotal, "$", ",", ".");
                $(".precioNetoFoot").text(netoTotal);
                //fin
                
                //difPeso valor IVA
                neto = $(".precioNetoFoot").text();
                neto = neto.replace("$", "");

                while(neto.indexOf(".") !== -1){
                    neto = neto.replace(".", "");
                }
                neto = parseInt(neto);
                iva = neto * 0.19;
                iva = accounting.formatMoney(iva, "$", ",", ".");
                $(".valorIvaFoot").text(iva);
                //fin IVA
                
                //difPeso Total Recepcion
                total = $(".totalRecepcionFoot").text();
                total = total.replace("$", "");

                while(total.indexOf(".") !== -1){
                    total = total.replace(".", "");
                }
                total = parseInt(total);

                total += 1;
            
                total = accounting.formatMoney(total, "$", ",", ".");
                $(".totalRecepcionFoot").text(total);
                //fin Total Recepcion
            }
        }

        var interval;
        $('.sumPeso').mousedown(function() {
            interval = setInterval(sumaDif, 60);
        }).bind('mouseup mouseleave', function() {
            clearInterval(interval);
        });

         var interval2;
        $('.restPeso').mousedown(function() {
            interval2 = setInterval(restaDif, 60);
        }).bind('mouseup mouseleave', function() {
            clearInterval(interval2);
        });
        function restaDif() {
            var difPeso = $(".difPesoFoot").text();
            difPeso = difPeso.replace("$", "");

            while(difPeso.indexOf(".") !== -1){
                difPeso = difPeso.replace(".", "");
            }
            difPeso = parseInt(difPeso);
            if(difPeso>-1000){
                difPeso -= 1;
                difPeso = accounting.formatMoney(difPeso, "$", ",", ".");
                $(".difPesoFoot").text(difPeso);

                //difPeso valor Neto
                netoTotal = $(".precioNetoFoot").text();
                netoTotal = netoTotal.replace("$", "");

                while(netoTotal.indexOf(".") !== -1){
                    netoTotal = netoTotal.replace(".", "");
                }
                netoTotal = parseInt(netoTotal);

                netoTotal -= 1;
            
                netoTotal = accounting.formatMoney(netoTotal, "$", ",", ".");
                $(".precioNetoFoot").text(netoTotal);
                //fin
                
                //difPeso valor IVA
                neto = $(".precioNetoFoot").text();
                neto = neto.replace("$", "");

                while(neto.indexOf(".") !== -1){
                    neto = neto.replace(".", "");
                }
                neto = parseInt(neto);
                iva = neto * 0.19;
                iva = accounting.formatMoney(iva, "$", ",", ".");
                $(".valorIvaFoot").text(iva);
                //fin IVA
                
                //difPeso Total Recepcion
                total = $(".totalRecepcionFoot").text();
                total = total.replace("$", "");

                while(total.indexOf(".") !== -1){
                    total = total.replace(".", "");
                }
                total = parseInt(total);

                total -= 1;
            
                total = accounting.formatMoney(total, "$", ",", ".");
                $(".totalRecepcionFoot").text(total);
                //fin Total Recepcion
            }
        }

        $(".ivaSiNo").change(function () {
            var $checkeado = this.checked;
            var $precioOC = $(".precioOC").text();
            var request = $.ajax({
                type: "POST",
                url: "../../clases/webAplication/activarIVA.ashx",
                data: ({ checkeado: $checkeado, precioOC: $precioOC })
            }).done(function (msg) {
                if (msg == 'False') {
                    var $valorTotal = 0.0;
                    var $iva = 1.19;
                    var totaloc = null;
                    var total = null;

                    var $valorDouble = $(".precioOC").text().replace("$", "");
                    while($valorDouble.indexOf(".") !== -1){
                        $valorDouble = $valorDouble.replace(".", "");
                    }
                    $valorTotal = (parseFloat($valorDouble)) / $iva;
                    $valorTotal.toFixed(2);
                    $valorTotal = accounting.formatMoney($valorTotal, "$", ",", ".");
                    $(".precioOC").text($valorTotal);

                    $rows = document.getElementById('<%=DataGrid1.ClientID%>').rows;
                    $dGrid = document.getElementById('<%=DataGrid1.ClientID%>').rows.length;
                    var $prueba = "";

                    for (var i = 1; i < $dGrid; i++) {
                        $prueba = $rows[i].cells[9].innerText;
                        $prueba = $prueba.replace("$", "");
                        $prueba = $prueba.replace(".", "");
                        $prueba = $prueba.replace(".", "");
                        $valorTotal = (parseFloat($prueba)) / $iva;
                        $valorTotal.toFixed(2);
                        $valorTotal = accounting.formatMoney($valorTotal, "$", ",", ".");
                        $rows[i].cells[9].innerText = $valorTotal;

                    }

                    totaloc = $(".totalOCFoot").text();
                    totaloc = totaloc.replace("$", "");
                    while(totaloc.indexOf(".") !== -1){
                        totaloc = totaloc.replace(".", "");
                    }
                    totaloc = parseFloat(totaloc)/1.19;
                    totaloc = accounting.formatMoney(totaloc, "$", ",", ".");

                    total = $(".totalRecepcionFoot").text();
                    total = total.replace("$", "");
                    while(total.indexOf(".") !== -1){
                        total = total.replace(".", "");
                    }
                    total = parseFloat(total)/1.19;
                    total = accounting.formatMoney(total, "$", ",", ".");

                    $(".valorIvaFoot").text("$0");
                    $(".totalOCFoot").text(totaloc);
                    $(".totalRecepcionFoot").text(total);

                } else {
                    var valor =  $(".precioNetoFoot").text();
                    var $valorTotal = 0.0;
                    var $iva = 1.19;
                    var totaloc = null;
                    var total = null;

                    var $valorDouble = $(".precioOC").text().replace("$", "");
                    $valorDouble = $valorDouble.replace(".", "");
                    $valorDouble = $valorDouble.replace(".", "");
                    $valorTotal = parseFloat($valorDouble) * $iva;
                    $valorTotal.toFixed(2);
                    $valorTotal = accounting.formatMoney($valorTotal, "$", ",", ".");
                    $(".precioOC").text($valorTotal);

                    $rows = document.getElementById('<%=DataGrid1.ClientID%>').rows;
                    $dGrid = document.getElementById('<%=DataGrid1.ClientID%>').rows.length;
                    var $prueba = "";

                    for (var i = 1; i < $dGrid; i++) {
                        $prueba = $rows[i].cells[9].innerText;
                        $prueba = $prueba.replace("$", "");
                        $prueba = $prueba.replace(".", "");
                        $prueba = $prueba.replace(".", "");
                        $valorTotal = (parseFloat($prueba)) * $iva;
                        $valorTotal.toFixed(2);
                        $valorTotal = accounting.formatMoney($valorTotal, "$", ",", ".");
                        $rows[i].cells[9].innerText = $valorTotal;
                    }

                    totaloc = $(".totalOCFoot").text();
                    totaloc = totaloc.replace("$", "");
                    while(totaloc.indexOf(".") !== -1){
                        totaloc = totaloc.replace(".", "");
                    }
                    totaloc = parseFloat(totaloc)*$iva;
                    totaloc = accounting.formatMoney(totaloc, "$", ",", ".");

                    total = $(".totalRecepcionFoot").text();
                    total = total.replace("$", "");
                    while(total.indexOf(".") !== -1){
                        total = total.replace(".", "");
                    }
                    total = parseFloat(total)*$iva;
                    total = accounting.formatMoney(total, "$", ",", ".");

                    valor = valor.replace("$", "");

                    while(valor.indexOf(".") !== -1){
                        valor = valor.replace(".", "");
                    }
                    valor = parseInt(valor);
                    valor = valor*0.19;
                    valor = accounting.formatMoney(valor, "$", ",", ".");
                    $(".valorIvaFoot").text(valor);
                    $(".totalOCFoot").text(totaloc);
                    $(".totalRecepcionFoot").text(total);
                }
            });
        });

    </script>
    <!--detalles de materiales a iFrame-->
    <!--modal Content-->
    <div id="dialog-form" title="Detalle Material">
        <div id="modalDetalle">
            <iframe id="iframeDetalleMaterial" name="iframeDetalleMaterial" src="" class="iFrameDetalle"
                height="520"></iframe>
        </div>
        <form target="iframeDetalleMaterial" method="POST" class="formDetalleMaterial" id="formDetalleMaterial"
        action="detalleMateriales.aspx" style="display: none;">
        <input type="text" class="value" size="40" value="" name="codigoPadre" id="codigoPadre" />
        <input id="submitFormIframe" type="submit" name="submit" value="Submit" />
        </form>
    </div>
</asp:Content>
