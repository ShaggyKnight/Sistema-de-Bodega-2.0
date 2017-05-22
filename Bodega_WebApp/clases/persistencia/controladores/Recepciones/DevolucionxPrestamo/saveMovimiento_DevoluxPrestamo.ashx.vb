Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class saveMovimiento_DevoluxPrestamo
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"

        Dim usuario As UsuarioLogeado = context.Session("usuarioLogeado")
        Dim CodigoTrasaccion As String = context.Request("CodigoTrasaccion")
        Dim fechaDonacion As String = context.Request("fechaDonacion")
        Dim NcorrelativoNuevo As String = context.Request("NcorrelativoNuevo")
        Dim fechaCompleta As String = context.Request("fechaCompleta")
        Dim descripcion As String = context.Request("descripcion")
        Dim CodigoTrasaccionAnterior_Prestamo As String = context.Request("CodigoTrasaccionAnterior_Prestamo")
        Dim fechaPrestamo As String = context.Request("fechaPrestamo")
        Dim NcorrelativoAntiguo_Prestamo As String = context.Request("NcorrelativoAntiguo_Prestamo")


        Dim respuesta As New Dictionary(Of String, String)

        ControladorPersistencia.saveMovimiento_DevoluxPrestamo(CodigoTrasaccion, fechaPrestamo, NcorrelativoNuevo, fechaCompleta, usuario.username, descripcion, CodigoTrasaccionAnterior_Prestamo, fechaDonacion, NcorrelativoAntiguo_Prestamo)

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