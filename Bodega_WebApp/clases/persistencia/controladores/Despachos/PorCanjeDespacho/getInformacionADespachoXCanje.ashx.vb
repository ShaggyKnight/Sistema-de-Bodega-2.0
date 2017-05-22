Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getInformacionADespachoXCanje
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "texto/json"
        Dim periodo As String = context.Request("Periodo")
        Dim numero As String = context.Request("Numero")

        Dim infoCanje As New Dictionary(Of String, String)

        Dim json As New JavaScriptSerializer
        infoCanje = ControladorPersistencia.getInfoCanjeDespachoXCanje(periodo, numero)
        Dim respuesta As String
        respuesta = json.Serialize(infoCanje)
        context.Response.Write(respuesta)

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class