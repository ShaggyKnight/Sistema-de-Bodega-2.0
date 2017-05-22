Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class DataRptTransferenciasBodegas
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("tipoBusqueda")

        Select Case cmd
            Case "cargaDatos"
                jsonSerializado = getDatosSelect(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function getDatosSelect(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listBodegas As New List(Of Dictionary(Of String, String))
        Dim ListaDeBodegas As New ListaObjetosSelectBox
        Dim listEstablecimientos As New List(Of Dictionary(Of String, String))
        Dim ListaDeEstablecimientos As New ListaObjetosSelectBox
        Dim tipoBusqueda As String = context.Request("indentificadorBusqueda")
        Dim establecimiento As String = "0" & context.Request("establecimiento")

        Select Case tipoBusqueda
            Case "establecimientos"
                listEstablecimientos = ControladorPersistencia.getListaEstablecimientos()

                For Each datosEstablecimiento As Dictionary(Of String, String) In listEstablecimientos
                    Dim Periodo As New ObjetoSelectBox(Trim(datosEstablecimiento("codigoEstab")), Trim(datosEstablecimiento("nombreEstab")))
                    ListaDeEstablecimientos.setObjeto(Periodo)
                Next

                jsonSerializado = serializer.Serialize(ListaDeEstablecimientos)
            Case "bodegas"
                listBodegas = ControladorPersistencia.getlistaBodegasDevUsuarios(establecimiento)

                For Each datosBodegas As Dictionary(Of String, String) In listBodegas
                    Dim bodega As New ObjetoSelectBox(Trim(datosBodegas("BodCodigo")), Trim(datosBodegas("BodNombre")))
                    ListaDeBodegas.setObjeto(bodega)
                Next

                jsonSerializado = serializer.Serialize(ListaDeBodegas)
        End Select


        Return jsonSerializado
    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class