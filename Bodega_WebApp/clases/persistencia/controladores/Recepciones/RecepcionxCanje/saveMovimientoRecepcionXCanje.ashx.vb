Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class saveMovimientoRecepcionXCanje
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"


        Dim codigo As String = context.Request("codigo")
        Dim fecha As String = context.Request("fecha")
        Dim NRecepcionXCanje As String = context.Request("NRecepcionXCanje")
        Dim fechaCompleta As String = context.Request("fechaCompleta")
        Dim usuario As UsuarioLogeado = context.Session("usuarioLogeado")
        Dim descripcion As String = context.Request("descripcion")
        Dim NDespachoCanje As String = context.Request("NDespachoCanje")

        Dim respuesta As New Dictionary(Of String, String)

        ControladorPersistencia.saveMovimientoRecepcionXCanje(codigo, fecha, NRecepcionXCanje, fechaCompleta, usuario.username, descripcion, NDespachoCanje)

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