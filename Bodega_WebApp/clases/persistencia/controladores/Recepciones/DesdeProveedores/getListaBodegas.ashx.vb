Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getListaBodegas
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        Dim serializer As New JavaScriptSerializer()
        Dim datosBodegas As New List(Of Dictionary(Of String, String))
        Dim listaBodegas As New ListaBodegas
        context.Response.ContentType = "application/json"
        Dim items As New List(Of Bodega)
        Dim s As New JavaScriptSerializer()
        Dim nroOC As String = context.Request("numeroOC")
        Dim usuario As UsuarioLogeado = New UsuarioLogeado(context.Request("userName"), context.Request("nombre"), context.Request("rut"), context.Request("tipo"), "0", context.Request("centroCosto"))
        Dim establecimiento = ControladorPersistencia.getEstablecimiento(usuario.centroDeCosto)

        datosBodegas = ControladorPersistencia.getDatosBodegas(establecimiento.Substring(0, establecimiento.IndexOf("-") - 1))

        For Each bodega As Dictionary(Of String, String) In datosBodegas

            Dim datoBodega As New Bodega(bodega("codigo"), bodega("nombre"))
            listaBodegas.setBodega(datoBodega)

        Next

        Dim javaScriptSerializado As String = serializer.Serialize(listaBodegas)

        context.Response.Write(javaScriptSerializado)

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class