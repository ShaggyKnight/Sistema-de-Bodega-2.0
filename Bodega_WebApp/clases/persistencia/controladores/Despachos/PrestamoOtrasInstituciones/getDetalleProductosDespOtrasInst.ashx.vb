Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getDetalleProductosDespOtrasInst
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "texto/json"
        Dim bodega As String = context.Request("codBodega")
        Dim codigo As String = context.Request("codMaterial")


        Dim retorno As ListaDetalleArticulos

        retorno = ControladorPersistencia.getDetalleProductosOrderFechaDOInst(codigo, bodega)

        Dim respuesta As String
        Dim json As New JavaScriptSerializer
        respuesta = json.Serialize(retorno)
        context.Response.Write(respuesta)

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class