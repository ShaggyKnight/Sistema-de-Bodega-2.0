Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getHistoricoArticulosAGrid1DespOtrasInst
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim retorno As ListaArticulosGrid1DespOtrasInst

        Dim codigo As String = context.Request("codigo")
        Dim periodo As String = context.Request("Periodo")
        Dim numero As String = context.Request("Numero")

        retorno = ControladorPersistencia.cargaHistorialAGrid1DespOtrasInst(codigo, periodo, numero)

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