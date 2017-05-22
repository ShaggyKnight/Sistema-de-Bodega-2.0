Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getBusquedaxCodigoRecepxSoliPrestamo
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "texto/json"
        Dim codigo As String = context.Request("codigoMaterial")
        Dim bodega As String = context.Request("codBodega")

        Dim json As New JavaScriptSerializer
        Dim articulo As New Dictionary(Of String, String)
        articulo = ControladorPersistencia.getProductoxCodigoparaRecepxSoliPrestamo(codigo, Bodega)
        Dim respuesta As String
        respuesta = json.Serialize(articulo)
        context.Response.Write(respuesta)

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class