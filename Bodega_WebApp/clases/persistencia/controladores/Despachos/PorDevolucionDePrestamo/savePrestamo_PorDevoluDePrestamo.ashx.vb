Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class savePrestamo_PorDevoluDePrestamo
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"

        Dim fechaActual As String = context.Request("fechaActual")
        Dim codigoActual As String = context.Request("codigoActual")
        Dim NCorrelativoNuevo As String = context.Request("NCorrelativoNuevo")
        Dim fechaCompleta As String = context.Request("fechaCompleta")
        Dim descripcion As String = context.Request("descripcion")
        Dim valor As String = context.Request("valor")
        Dim numeroDoc As String = context.Request("numeroDoc")
        Dim Institucion As String = context.Request("Instituto")
        Dim codigoAntiguo As String = context.Request("codigoAntiguo")
        Dim fechaAntigua As String = context.Request("fechaAntigua")
        Dim NCorrelativoAntiguo As String = context.Request("NCorrelativoAntiguo")

        Dim respuesta As New Dictionary(Of String, String)

        ControladorPersistencia.savePrestamo_PorDevoluDePrestamo(fechaActual, codigoActual, NCorrelativoNuevo,
                                                                   fechaCompleta, descripcion, valor, numeroDoc,
                                                                   Institucion, codigoAntiguo, fechaAntigua, NCorrelativoAntiguo)
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