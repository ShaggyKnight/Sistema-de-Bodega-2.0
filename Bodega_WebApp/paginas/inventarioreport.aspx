<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="inventarioreport.aspx.vb" Inherits="Bodega_WebApp.WebForm2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.inventarioR%>

    <style>
        .btnStyle
        {
            position: relative;
            margin-top: 60px;
            left: 30px;
            width: 235px;
        }
        
        .btnStyle2
        {
            position: relative;
            margin-top: 22px;
            left: 30px;
            width: 235px;
        }
        .btnStyle3
        {
            position: relative;
            margin-top: 22px;
            left: 30px;
            width: 235px;
        }
        .btnStyle4
        {
            position: relative;
            margin-top: 22px;
            left: 30px;
            width: 235px;
        }
      
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <button type="button" class="btn btn-lg btn-primary btnStyle">Inventario Actualizado X Item</button>
    </div>
    <div class="row">
        <button type="button" class="btn btn-lg btn-primary btnStyle2">Inventario Actualizado X Bodega</button>
    </div>
    <div class="row">
        <button type="button" class="btn btn-lg btn-primary btnStyle3">Inventario Actualizado X Familia</button>
    </div>
    <div class="row">
        <button type="button" class="btn btn-lg btn-primary btnStyle4">Inventario Real en Existencia</button>
    </div>
        
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
</asp:Content>
