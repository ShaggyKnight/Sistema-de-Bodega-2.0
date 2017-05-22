Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getHistorialArticulosRecepcionxCanje
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        Dim periodo As String = context.Request("Periodo")
        Dim numero As String = context.Request("Numero")

        Dim retorno As New ListaHistorialRecepcionxCanje()

        Dim json As New JavaScriptSerializer
        retorno = ControladorPersistencia.getInfoHistoricoCanjeRecepcionXCanje(periodo, numero)
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