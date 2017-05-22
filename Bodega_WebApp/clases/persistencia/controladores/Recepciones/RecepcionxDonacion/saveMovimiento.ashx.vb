Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class saveMovimiento
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim usuario As UsuarioLogeado = context.Session("usuarioLogeado")
        Dim fecha As String = context.Request("fecha")
        Dim NumeroDonacionArticulo As String = context.Request("NumeroDonacionArticulo")
        Dim NumeroCorrelativo As String = context.Request("NumeroCorrelativo")

        Dim respuesta As New Dictionary(Of String, String)

        Dim test1 As Integer = String.Compare(NumeroCorrelativo, "")
        Dim test2 As Integer = String.Compare(NumeroCorrelativo, " ")

        If test1 = 0 Or test2 = 0 Then
            respuesta.Add("item", "null")
        Else
            ControladorPersistencia.saveMovimiento(fecha, NumeroDonacionArticulo, NumeroCorrelativo, usuario.username)
            respuesta.Add("item", "done")
        End If

        ' Tamaño de salida de datos
        Dim json As New JavaScriptSerializer
        json.MaxJsonLength = 50000000
        context.Response.Write(json.Serialize(respuesta))

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class