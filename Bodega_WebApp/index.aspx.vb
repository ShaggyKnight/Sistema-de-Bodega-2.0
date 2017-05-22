Public Class login1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            Me.listaServidores.DataSource = Servidores.Instancia.servidores
            Me.listaServidores.DataTextField = "nombre"
            Me.listaServidores.DataValueField = "id"
            Me.listaServidores.DataBind()
            Me.listaServidores.SelectedValue = Servidores.Instancia.idPorDefecto
            Me.inputUsuario.Focus()
            Me.contenedorMensajeError.Visible = False
        End If
    End Sub

    Protected Sub cmd_enviar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles cmd_enviar.Click
        Me.contenedorMensajeError.Visible = False

        ' Rescata el nombre de usuario y contraseña del formulario
        Dim usuario As String = inputUsuario.Text.Trim()
        Dim password As String = inputPassword.Text.Trim()

        usuario = usuario.ToLower()

        ' Variable usada para guardar el mensaje de error
        Dim textoError As String = ""

        ' Validación ingreso de log in (usuario y contraseña no pueden ser vacios)
        If usuario.Equals("") Then
            textoError += "Debe ingresar su usuario<br/>"
        End If
        If password.Equals("") Then
            textoError += "Debe ingresar su password<br/>"
        End If
        If textoError.Length > 5 Then
            textoError = textoError.Substring(0, textoError.Length - 5) ' Quita el útlimo <br/>
            Me.contenedorMensajeError.Visible = True
            Me.mensajeError.InnerHtml = textoError
            inputUsuario.Focus()
            Return
        End If

        Try
            ControladorPresentacion.setPersistencia(inputUsuario.Text, inputPassword.Text, listaServidores.SelectedValue, Context.Session)
        Catch ex As Exception
            Me.contenedorMensajeError.Visible = True
            Me.mensajeError.InnerText = ex.Message
            Return
        End Try

        Try
            Session("usuarioLogeado") = ControladorPresentacion.GetUsuario(usuario)
        Catch ex As Exception
            Me.contenedorMensajeError.Visible = True
            Me.mensajeError.InnerText = ex.Message
            Return
        End Try

        Response.Redirect("~/paginas/index.aspx")
    End Sub
End Class