Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getCorrelativo_Bincard
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "texto/json"
        Dim fecha As String = context.Request("fecha")

        Dim json As New JavaScriptSerializer

        Dim correlativo As New Dictionary(Of String, String)

        correlativo = ControladorPersistencia.getCorrelativo_Bincard()

        Dim respuesta As String
        respuesta = json.Serialize(correlativo)
        context.Response.Write(respuesta)

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class