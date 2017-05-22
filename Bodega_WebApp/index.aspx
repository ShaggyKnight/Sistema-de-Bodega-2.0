    <%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="index.aspx.vb" Inherits="Bodega_WebApp.login1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .fondoLogin 
        {
            position: relative;
            background-image: url(imagenes/fondoLogin.jpg);
            background-repeat: no-repeat;
            width: 401px;
            height: 290px;
            
            color:Black;
            margin: 0 auto;
            margin-bottom:10px;
            /*margin-top: 50px;*/
        }
        #divLogin
        {
            position: absolute;
            top: 130px;
            width:100%;
            text-align: center;
        }
        
        .btnEntrar
        {
            text-align:center;
            padding-top:20px;
            background:url("assets/imagenes/general/entrar.png") no-repeat;
            background-position:50% 0;
            border:0;
            color:black;
            font-size:18px;
            font-weight:bold;
        }
        
        .btnEntrar:hover
        {
            color:red;
        }
        
        .btnCambioClave
        {
            text-align:center;
            padding-top:20px;
            background:url("assets/imagenes/general/cambiarClave.png") no-repeat;
            background-position:50% 0;
            border:0;
            color:black;
            font-size:18px;
            font-weight:bold;
        }
        
        .btnCambioClave:hover
        {
            color:red;
        }
        </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-12" style="text-align:center;margin-top:10px;">
            <div><img alt="" id="Img1" runat="server" src="~/assets/imagenes/general/logo.png" /></span></div>
            <div style="margin-top:5px;">
                <span style="color:#003366;font-size:18px;font-weight:bold;">
                    Sistema de Abastecimiento<br />Hospital Regional de Antofagasta
                </span>
            </div>
        </div>
    </div>
    <div class="fondoLogin">
        <div class="form-horizontal" role="form" style="padding-top: 50px;margin-left: 30px;margin-right: 30px;">
          <div class="form-group">
            <label for="inputEmail1" class="col-2 control-label"><img alt="" src="assets/imagenes/general/servidor.png" /></label>
            <div class="col-10">
                <asp:DropDownList ID="listaServidores" runat="server" class="form-control">
                </asp:DropDownList>
            </div>
          </div>
          <div class="form-group">
            <label for="inputEmail1" class="col-2 control-label"><img alt="" src="assets/imagenes/general/users.png" /></label>
            <div class="col-10">
              <asp:TextBox ID="inputUsuario" runat="server" placeholder="Nombre de Usuario" class="form-control"></asp:TextBox>
            </div>
          </div>
          <div class="form-group">
            <label for="inputPassword1" class="col-2 control-label"><img alt="" src="assets/imagenes/general/key.png" /></label>
            <div class="col-10">
              <asp:TextBox ID="inputPassword" runat="server" TextMode="Password" placeholder="Contraseña" class="form-control"></asp:TextBox>
            </div>
          </div>
        </div>
        <div class="row">
            <div class="col-6">
                <div class="form-group" style="text-align:center;">
                  <asp:Button ID="cmd_enviar" runat="server" Text="Ingresar" class="btnEntrar"/>
                </div>
            </div>
            <div class="col-6">
                <div class="form-group" style="text-align:center;">
                  <asp:Button ID="Button1" runat="server" Text="Cambiar&#x00A;Contraseña" class="btnCambioClave"/>
                </div>
            </div>
        </div>
    </div>
    <div style="width:401px;width: 401px;position: relative;margin: auto;">
        <div runat="server" id="contenedorMensajeError" class="row alert alert-danger">
            <div class="col-2">
                <span class="glyphicon glyphicon-remove" style="font-size:20px;"></span>
            </div>
            <div runat="server" id="mensajeError" class="col-10">
                
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="contenedorJavascript" runat="server">
    
</asp:Content>