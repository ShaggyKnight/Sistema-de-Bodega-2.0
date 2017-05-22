Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class CheckRecepcionxCanje
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "texto/json"
        Dim codigo As String = context.Request("codigo")
        Dim fecha As String = context.Request("Periodo")
        Dim NDespacho As String = context.Request("Numero")

        Dim json As New JavaScriptSerializer
        Dim retorno As ListaCheckRecepcionxCanje
        retorno = ControladorPersistencia.CheckRecepcionxCanje(codigo, fecha, NDespacho)
        Dim respuesta As String
        respuesta = json.Serialize(retorno)
        context.Response.Write(respuesta)

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class