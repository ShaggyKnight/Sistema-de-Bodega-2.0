Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getListaMateriales_BincardGeneral
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "texto/json"

        Dim codBodega As String = context.Request("codBodega")

        Dim retorno As ListaMateriales_BinCard

        retorno = ControladorPersistencia.getListaMateriales_BinCard(codBodega)

        ' Tamaño de salida de datos
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