Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class deleteTemp_DespPresOtrasInstituciones
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"

        Dim NumeroDonacionArticulo As String = context.Request("NumeroDonacionArticulo")
        Dim CodigoMaterial As String = context.Request("CodigoMaterial")
        Dim NumeroActual As String = context.Request("NDonacionActual")

        Dim respuesta As New Dictionary(Of String, String)

        ControladorPersistencia.delete_DetalleMovimientoOtrasInst_DetalleTemp(NumeroDonacionArticulo, CodigoMaterial, NumeroActual)
        respuesta.Add("item", "done")

        ' Tamaño de salida de datos
        Dim json As New JavaScriptSerializer
        json.MaxJsonLength = 50000000
        context.Response.Write(json.Serialize(respuesta))

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class