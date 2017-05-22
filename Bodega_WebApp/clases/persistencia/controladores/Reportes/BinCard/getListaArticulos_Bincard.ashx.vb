Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getListaArticulos_Bincard
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim retorno As ListaArticulos_BinCard

        Dim codBodega As String = context.Request("CodBodega")
        Dim codMaterial As String = UCase(context.Request("CodMaterial"))
        Dim anio As String = context.Request("Anio")

        retorno = ControladorPersistencia.getListaArticulos_Bincard(codBodega, codMaterial, anio)

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