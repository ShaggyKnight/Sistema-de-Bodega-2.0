<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="index.aspx.vb" Inherits="Bodega_WebApp.index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.inicio%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="col-xs-2 col-md-4">
        <img src="../assets/imagenes/logo_gob.fw.png" style="width: 10%; float: left;"/>
        <h2 class="text-center">BIENVENIDOS AL SISTEMA DE BODEGA VERSIÓN 2.0</h2>
        <h1 class="text-center" ><small style="color: royalblue;">Este sistema le permitirá llevar la administración de los insumos médicos y/o productos recibidos en su bodega.</small></h1>
        <p style="font-size: 130%;"></p>
        <p class="text-justify" style="font-size: 130%;">Cada material y/o insumo recibido deberá tener asignada una fecha de vencimiento en el formato <mark>DD/MM/AAAA</mark>, en caso de no poseer fecha de vencimiento debera ingresar una fecha predefinida equivalente a 01/01/1900.</p>
        <p></p>
        <p class="text-justify" style="font-size: 130%;">El sistema es funcional tanto para computadores de escritorio como para cualquier dispositivo smart, sin importar su sistema operativo.</p>
        <p></p>
        <h3>EQUIPOS SOPORTADOS</h3>
        <span class="glyphicons imac" style="margin-left: 28px; color: royalblue;"></span><h3 class="text-justify" style="margin-left: 8%; margin-top: -1%; "><small style="color: dimgrey;">EQUIPOS DE ESCRITORIOS COMO MAC Y PC</small></h3>
        <span class="glyphicons macbook" style="margin-left: 28px; color: royalblue;"></span><h3 class="text-justify" style="margin-left: 8%; margin-top: -1%; "><small style="color: dimgrey;">EQUIPOS PORTATILES COMO MACBOOK Y NOTEBOOK</small></h3>
        <span class="glyphicons ipad" style="color: royalblue;"></span><span class="glyphicons iphone" style="color: royalblue;"></span><h3 class="text-justify" style="margin-left: 8%; margin-top: -1%; "><small style="color: dimgrey ;">EQUIPOS MOVILES COMO TABLETS Y CELULARES DE CUALQUIER MARCA</small></h3>
        <p style="font-size: 130%;"></p>
        <p style="font-size: 130%;">Cada equipo solo requiere poseer un navegador (<abbr title="Versión 9.0 o superior" class="initialism">Internet Explorer</abbr>, Mozilla, Chrome, etc) y estar conectado a la red privada del Hospital (RUTA5D)</p>
        
    </div>
&nbsp;
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
    
</asp:Content>