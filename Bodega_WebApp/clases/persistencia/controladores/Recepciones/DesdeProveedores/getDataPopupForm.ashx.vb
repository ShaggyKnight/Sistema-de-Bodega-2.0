Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getDataPopupForm
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("cmd")
        Dim campoACargar As String = context.Request("campoDeCarga")
        Select Case campoACargar
            Case "periodo"
                jsonSerializado = getListaPeriodos(context)
            Case "estado"
                jsonSerializado = getListaEstados(context)
            Case "proveedor"
                jsonSerializado = getListaProveedores(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub

    Public Function getListaPeriodos(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listPeriodos As New List(Of Dictionary(Of String, String))
        Dim ListaDePeriodos As New ListaObjetosSelectBox

        listPeriodos = ControladorPersistencia.getListaPeriodos()

        For Each datosPeriodo As Dictionary(Of String, String) In listPeriodos
            Dim Periodo As New ObjetoSelectBox(datosPeriodo("percodigo"), datosPeriodo("pernombre"))
            ListaDePeriodos.setObjeto(Periodo)
        Next

        jsonSerializado = serializer.Serialize(ListaDePeriodos)

        Return jsonSerializado

    End Function

    Public Function getListaEstados(ByVal context As HttpContext)
        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listEstados As New List(Of Dictionary(Of String, String))
        Dim listaDeEstados As New ListaObjetosSelectBox

        listEstados = ControladorPersistencia.getListaEstados()

        For Each datosEstado As Dictionary(Of String, String) In listEstados
            Dim estado As New ObjetoSelectBox(datosEstado("FLD_OCOESTADO"), datosEstado("FLD_COMBO"))
            listaDeEstados.setObjeto(estado)
        Next

        jsonSerializado = serializer.Serialize(listaDeEstados)

        Return jsonSerializado
    End Function

    Public Function getListaProveedores(ByVal context As HttpContext)
        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listProveedores As New List(Of Dictionary(Of String, String))
        Dim listaDeProveedores As New ListaObjetosSelectBox

        listProveedores = ControladorPersistencia.getListaProveedores()

        For Each datosProveedor As Dictionary(Of String, String) In listProveedores
            Dim proveedor As New ObjetoSelectBox(datosProveedor("FLD_PRORUT"), datosProveedor("PROVEEDOR"))
            listaDeProveedores.setObjeto(proveedor)
        Next

        jsonSerializado = serializer.Serialize(listaDeProveedores)

        Return jsonSerializado
    End Function

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class