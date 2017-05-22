Public Class AjusteMaterial
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Dim usuario As UsuarioLogeado = Context.Session("usuarioLogeado")

        'If String.Equals(usuario.username, "tgarrido") = False Then
        'If String.Equals(usuario.username, "rzamora") = False Or String.Equals(usuario.username, "tgarrido") = False Then
        'If usuario.username <> Nothing Then
        'Response.Redirect("~/index.aspx")
        'End If

        Try
            Dim usuario As UsuarioLogeado = Context.Session("usuarioLogeado")

            If String.Equals(usuario.username, "rzamora") = False And String.Equals(usuario.username, "etapia") = False Then
                Response.Redirect("~/index.aspx")
            End If

        Catch ex As Exception
            Response.Redirect("~/index.aspx")
        End Try

    End Sub

End Class