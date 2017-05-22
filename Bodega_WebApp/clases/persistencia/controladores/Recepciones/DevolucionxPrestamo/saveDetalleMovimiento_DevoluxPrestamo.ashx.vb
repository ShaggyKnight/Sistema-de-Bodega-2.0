Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class saveDetalleMovimiento_DevoluxPrestamo
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"

        Dim fechaNueva As String = context.Request("fechaNueva")
        Dim NCorrelativoNuevo As String = context.Request("NCorrelativoNuevo")
        Dim CodigoTrasaccionNuevo As String = context.Request("CodigoTrasaccionNuevo")
        Dim fechaAntiguo As String = context.Request("fechaAntiguo")
        Dim NCorrelativoAntiguo As String = context.Request("NCorrelativoAntiguo")

        Dim respuesta As New Dictionary(Of String, String)

        ControladorPersistencia.saveDetalleMovimiento_DevoluxPrestamo(fechaNueva, NCorrelativoNuevo, CodigoTrasaccionNuevo, fechaAntiguo, NCorrelativoAntiguo)
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