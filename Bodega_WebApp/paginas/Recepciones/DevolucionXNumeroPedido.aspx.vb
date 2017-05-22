Public Class DevolucionXNumeroPedido
    Inherits System.Web.UI.Page
    Public usuario As UsuarioLogeado
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.usuario = Session("usuarioLogeado")
    End Sub

End Class