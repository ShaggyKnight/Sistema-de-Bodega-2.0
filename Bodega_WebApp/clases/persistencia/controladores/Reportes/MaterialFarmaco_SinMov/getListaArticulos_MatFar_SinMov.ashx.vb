Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getListaArticulos_MatFar_SinMov
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim retorno As ListaArticulos_MatFar_SinMov

        Dim fechaIni As String = context.Request("FechaInicio")
        Dim fechaTermi As String = context.Request("FechaTermino")
        Dim bodega As String = context.Request("Bodega")
        Dim stock As String = context.Request("Stock")

        retorno = ControladorPersistencia.getListaArticulos_MatFar_SinMov(fechaIni, fechaTermi, bodega, stock)

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