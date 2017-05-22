Public Class Site
    Inherits System.Web.UI.MasterPage
    Protected css As String
    Protected javascript As String
    Public idePagina As Integer = -1

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim paginaActual As String
        paginaActual = Page.ToString().Replace("ASP.", "").Replace("_", ".")

        If Not IsNothing(Session("usuarioLogeado")) Then            ' Si existe login
            If paginaActual.Equals("index.aspx") Then               ' Y la pagina es login
                Response.Redirect("~/paginas/index.aspx")           ' Ir a inicio de aplicación
            End If
        Else                                                        ' Si no existe login
            If Not paginaActual.Equals("index.aspx") Then           ' Y la pagina no es la de login
                Response.Redirect("~/index.aspx")                   ' Ir a pagina de login
            End If
        End If

        Me.css = Me.GetCss()
        Me.javascript = Me.GetJavascript()
    End Sub

    Private Function GetCss() As String
        Dim constructor As StringBuilder = New StringBuilder()
        ' CSS del sitio
        constructor.Append(Configuracion.cssAbsoluto(Me.Page, "Styles/Site.css"))
        ' CSS de bootstrap
        constructor.Append(Configuracion.cssAbsoluto(Me.Page, "componentes/bootstrap/css/bootstrap.css"))
        ' CSS de iconos
        constructor.Append(Configuracion.cssAbsoluto(Me.Page, "componentes/bootstrap/css/bootstrap-glyphicons.css"))
        ' CSS de Nivo Slider (Slide de fotografías)
        constructor.Append(Configuracion.cssAbsoluto(Me.Page, "componentes/nivoslider/nivo-slider.css"))
        ' Jquery UI
        constructor.Append(Configuracion.cssAbsoluto(Me.Page, "componentes/jquery.ui/css/ui-lightness/jquery-ui-1.10.3.custom.css"))
        ' glyphicons
        constructor.Append(Configuracion.cssAbsoluto(Me.Page, "componentes/glyphicons/archivos/css/filetypes.css"))
        constructor.Append(Configuracion.cssAbsoluto(Me.Page, "componentes/glyphicons/halflings/css/halflings.css"))
        constructor.Append(Configuracion.cssAbsoluto(Me.Page, "componentes/glyphicons/normal/css/glyphicons.css"))
        constructor.Append(Configuracion.cssAbsoluto(Me.Page, "componentes/glyphicons/social/css/social.css"))
        ' w2ui
        constructor.Append(Configuracion.cssAbsoluto(Me.Page, "componentes/w2ui/w2ui-1.3.2.css"))
        ' sweetalert
        constructor.Append(Configuracion.cssAbsoluto(Me.Page, "componentes/dist/sweetalert.css"))

        Return constructor.ToString()
    End Function

    Private Function GetJavascript() As String
        Dim constructor As StringBuilder = New StringBuilder()
        ' JQuery
        constructor.Append(Configuracion.javascriptAbsoluto(Me.Page, "componentes/jquery/jquery.js"))
        ' Nivo Slider (Slide de fotografías)
        constructor.Append(Configuracion.javascriptAbsoluto(Me.Page, "componentes/nivoslider/jquery.nivo.slider.pack.js"))
        ' Funciones Javascript para emular responsividad en Internet Explorer 8 y 9.
        constructor.Append(Configuracion.javascriptAbsoluto(Me.Page, "componentes/bootstrap/js/respond.min.js"))
        ' JQuery UI
        constructor.Append(Configuracion.javascriptAbsoluto(Me.Page, "componentes/jquery.ui/js/jquery-ui-1.10.3.custom.js"))
        ' BootsTrap min
        constructor.Append(Configuracion.javascriptAbsoluto(Me.Page, "componentes/bootstrap/js/bootstrap.min.js"))
        ' JQuery Form
        constructor.Append(Configuracion.javascriptAbsoluto(Me.Page, "componentes/jquery.form/jquery.form.js"))
        ' JQuery Form
        constructor.Append(Configuracion.javascriptAbsoluto(Me.Page, "componentes/accounting/accounting.js"))
        ' w2ui
        constructor.Append(Configuracion.javascriptAbsoluto(Me.Page, "componentes/w2ui/w2ui-1.3.2.js"))
        ' sweetalert
        constructor.Append(Configuracion.javascriptAbsoluto(Me.Page, "componentes/dist/sweetalert.min.js"))

        Return constructor.ToString()
    End Function

    Protected Sub btnCerrarSesion_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCerrarSesion.Click
        Session("usuarioLogeado") = Nothing
        Response.Redirect("~/index.aspx")
    End Sub
End Class