Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class savePrestamoRecepxSolicitudPrestamo
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim fecha As String = context.Request("fecha")
        Dim NumeroDonacionArticulo As String = context.Request("NumeroDonacionArticulo")
        Dim Ncorrelativo As String = context.Request("NumeroCorrelativo")
        Dim fechaCompleta As String = context.Request("fechaCompleta")
        Dim descripcion As String = context.Request("descripcion")
        Dim valor As String = context.Request("valor")
        Dim numeroDoc As String = context.Request("numeroDoc")
        Dim Institucion As String = context.Request("Instituto")

        Dim respuesta As New Dictionary(Of String, String)

        ControladorPersistencia.saveDonacionRecepxSolicitudPrestamo(fecha, NumeroDonacionArticulo, Ncorrelativo, fechaCompleta,
                                               descripcion, valor, numeroDoc, Institucion)
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