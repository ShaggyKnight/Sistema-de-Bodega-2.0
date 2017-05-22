<%@ Page Title="Acerca de nosotros" Language="vb" MasterPageFile="~/Site.Master" AutoEventWireup="false"
    CodeBehind="About.aspx.vb" Inherits="Bodega_WebApp.About" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
<%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.SobreNosotros%>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <h2>
        Browser soportados
    </h2>
    <p>
        <ul>
            <li>Chrome
                <ul>
                    <li>MAC</li>
                    <li>WINDOWS</li>
                    <li>IOS</li>
                    <li>ANDROID</li>
                </ul>
            </li>
            <li>SAFARI
                <ul>
                    <li>MAC</li>
                    <li>IOS</li>
                </ul>
            </li>
            <li>FIREFOX
                <ul>
                    <li>MAC</li>
                    <li>WINDOWS</li>
                </ul>
            </li>
            <li>INTERNET EXPLORER*</li>
            <li>OPERA
                <ul>
                    <li>MAC</li>
                    <li>WINDOWS</li>
                </ul>
            </li>
        </ul>

        <span>*Compatible 100% con internet explorer 10. Tendrá problemas de visualización menores con Internet Explorer 8 y 9.</span><br />
        <span>Revisar Licencia en el siguiente <a href="http://getbootstrap.com/getting-started/#license-faqs" title="Licencia">link</a></span>
    </p>
</asp:Content>