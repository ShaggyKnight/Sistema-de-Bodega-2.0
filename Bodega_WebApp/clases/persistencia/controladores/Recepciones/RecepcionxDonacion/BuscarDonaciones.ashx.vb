Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class BuscarDonaciones
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"

        Dim retorno As ListaBodega
        retorno = ControladorPersistencia.getPeriodoDonacion()
        Dim json As New JavaScriptSerializer
        context.Response.Write(json.Serialize(retorno))
    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class