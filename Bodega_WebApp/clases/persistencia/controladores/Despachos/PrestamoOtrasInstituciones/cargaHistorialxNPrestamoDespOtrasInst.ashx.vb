Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class cargaHistorialxNPrestamoDespOtrasInst
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim retorno As ListaGrid2HistoricoxDespOtrasInst

        Dim NPrestamo As String = context.Request("NumeroPrestamo")

        retorno = ControladorPersistencia.cargaHistorialxNPrestamo_DespOtrasInst(NPrestamo)

        Dim json As New JavaScriptSerializer
        json.MaxJsonLength = 50000000
        context.Response.Write(json.Serialize(retorno))

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class