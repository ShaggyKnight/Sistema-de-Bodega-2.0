Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getDatos_EncabezadoHistotico_PorDevoDePrestamo
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "texto/json"
        Dim CodigoTrasaccionNuevo As String = context.Request("CodigoTrasaccionNuevo")
        Dim CodigoTrasaccionAntiguo As String = context.Request("CodigoTrasaccionAntiguo")
        Dim fechaPrestamo As String = context.Request("fechaPrestamo")
        Dim NcorrelativoAntiguo_Prestamo As String = context.Request("NcorrelativoAntiguo_Prestamo")

        Dim EncabezadoDevolucion As New Dictionary(Of String, String)
        EncabezadoDevolucion = ControladorPersistencia.getDatos_EncabezadoHistotico_PorDevoDePrestamo(CodigoTrasaccionNuevo, CodigoTrasaccionAntiguo, fechaPrestamo, NcorrelativoAntiguo_Prestamo)

        Dim json As New JavaScriptSerializer
        Dim respuesta As String
        respuesta = json.Serialize(EncabezadoDevolucion)
        context.Response.Write(respuesta)

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class