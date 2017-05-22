Imports System.Web
Imports System.Web.Services
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization

Public Class getDatosOrdenCompra
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState
    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("cmd")
        Select Case cmd
            Case "get-record"
                jsonSerializado = getRecords(context)
            Case "validar-bodega"
                jsonSerializado = getValidacionBodega(context)
            Case "validar-OC"
                jsonSerializado = validarOC(context)
            Case "BusRecep,get-record"
                jsonSerializado = getRecordsXBusRecep(context)
        End Select
        
        context.Response.Write(jsonSerializado)

    End Sub
    'Valida la bodega del usuario en base a la requerida por la seleccion
    Public Function getValidacionBodega(ByVal context As HttpContext)
        Dim jsonSerializado As String = ""
        Dim validacion As Boolean = False
        Dim numeroOC As String = context.Request("numeroOC")
        Dim periodo As String = context.Request("periodo")
        Dim centroCosto As String = context.Request("centroCosto")

        validacion = ControladorPersistencia.validarBodega(periodo, numeroOC, centroCosto)

        jsonSerializado = "{""validacion"":""'" + validacion.ToString() + "'""}"
        Return jsonSerializado

    End Function
    'Obtiene la lista de recepciones en base a los datos de busqueda
    Public Function getRecords(ByVal context As HttpContext)

        Dim s As New JavaScriptSerializer()
        Dim ordenCompra As OrdenCompra
        Dim ordenesdeCompra As ListaOrdenesCompra = New ListaOrdenesCompra
        Dim nroOC As String = context.Request("numeroOC")
        Dim periodo As String = context.Request("periodoOC")
        Dim usuario As UsuarioLogeado = New UsuarioLogeado(context.Request("userName"), context.Request("nombre"), context.Request("rut"), context.Request("tipo"), "0", context.Request("centroCosto"))
        Dim dataOrdenCompra As Dictionary(Of String, String)

        ' va a getOrdenesCompra() y despues busca en PROC: PRO_TB_ORDENESCOMPRA_SEL_net
        dataOrdenCompra = ControladorPersistencia.getDatosOrdenCompra(nroOC, periodo, usuario)

        ordenCompra = New OrdenCompra(dataOrdenCompra("FLD_OCONUMERO"), _
                                      dataOrdenCompra("FLD_PROVEEDOR"), _
                                      Trim(dataOrdenCompra("FLD_PERCODIGO")), _
                                      dataOrdenCompra("FLD_OCOESTADO"), _
                                      dataOrdenCompra("FLD_OCPRECIO"), _
                                      dataOrdenCompra("FLD_BODCODIGO"), _
                                      dataOrdenCompra("FLD_BODNOMBRES"), _
                                      dataOrdenCompra("FLD_OCODESCRIPCION"), _
                                      dataOrdenCompra("numeroRecepcion"), _
                                      dataOrdenCompra("tipoDocumento"), _
                                      dataOrdenCompra("nroDocumento"), _
                                      dataOrdenCompra("totalRecepcionado"),
                                      dataOrdenCompra("observacionRecepcion"), _
                                      dataOrdenCompra("impuestoRecepcion"), _
                                      dataOrdenCompra("difPeso"), _
                                      dataOrdenCompra("idChileCompra"), _
                                      dataOrdenCompra("fechaRecepcion"), _
                                      dataOrdenCompra("notaCredito"), _
                                      dataOrdenCompra("descuento"))

        ordenesdeCompra.setOrdenDeCompra(ordenCompra)
        Dim datosSerializados As String = s.Serialize(ordenesdeCompra)
        Dim inicioFin As Integer = datosSerializados.IndexOf("["c)
        Dim finFin As Integer = datosSerializados.Length
        Dim strTemp As String = (datosSerializados.Substring(0, inicioFin))
        strTemp = strTemp + (datosSerializados.Substring((inicioFin + 1), (finFin - (inicioFin + 3)))) + "}"

        Return strTemp
    End Function
    'Nuevo valida si existe la OC
    'Valida la bodega del usuario en base a la requerida por la seleccion
    Public Function validarOC(ByVal context As HttpContext)
        Dim jsonSerializado As String = ""
        Dim validacion As Boolean = False
        Dim numeroOC As String = context.Request("numeroOC")
        Dim periodo As String = context.Request("periodo")
        Dim centroCosto As String = context.Request("centroCosto")

        validacion = ControladorPersistencia.validarOC(periodo, numeroOC, centroCosto)

        jsonSerializado = "{""validacion"":""" + validacion.ToString() + """}"
        Return jsonSerializado

    End Function
    'Obtiene la lista de recepciones en base a los datos de busqueda
    Public Function getRecordsXBusRecep(ByVal context As HttpContext)

        Dim s As New JavaScriptSerializer()
        Dim ordenCompra As OrdenCompra
        Dim ordenesdeCompra As ListaOrdenesCompra = New ListaOrdenesCompra
        Dim nroOC As String = context.Request("nroRecepcion")
        Dim periodo As String = context.Request("periodoOC")
        Dim usuario As UsuarioLogeado = New UsuarioLogeado(context.Request("userName"), context.Request("nombre"), context.Request("rut"), context.Request("tipo"), "0", context.Request("centroCosto"))
        Dim dataOrdenCompra As Dictionary(Of String, String)

        dataOrdenCompra = ControladorPersistencia.getDatosOrdenCompraXBusRecep(nroOC, periodo, usuario)

        ordenCompra = New OrdenCompra(dataOrdenCompra("FLD_OCONUMERO"), _
                                      dataOrdenCompra("FLD_PROVEEDOR"), _
                                      Trim(dataOrdenCompra("FLD_PERCODIGO")), _
                                      dataOrdenCompra("FLD_OCOESTADO"), _
                                      dataOrdenCompra("FLD_OCPRECIO"), _
                                      dataOrdenCompra("FLD_BODCODIGO"), _
                                      dataOrdenCompra("FLD_BODNOMBRES"), _
                                      dataOrdenCompra("FLD_OCODESCRIPCION"), _
                                      dataOrdenCompra("numeroRecepcion"), _
                                      dataOrdenCompra("tipoDocumento"), _
                                      dataOrdenCompra("nroDocumento"), _
                                      dataOrdenCompra("totalRecepcionado"),
                                      dataOrdenCompra("observacionRecepcion"), _
                                      dataOrdenCompra("impuestoRecepcion"), _
                                      dataOrdenCompra("difPeso"), _
                                      dataOrdenCompra("idChileCompra"), _
                                      dataOrdenCompra("fechaRecepcion"), _
                                      dataOrdenCompra("notaCredito"), _
                                      dataOrdenCompra("descuento"))

        ordenesdeCompra.setOrdenDeCompra(ordenCompra)
        Dim datosSerializados As String = s.Serialize(ordenesdeCompra)
        Dim inicioFin As Integer = datosSerializados.IndexOf("["c)
        Dim finFin As Integer = datosSerializados.Length
        Dim strTemp As String = (datosSerializados.Substring(0, inicioFin))
        strTemp = strTemp + (datosSerializados.Substring((inicioFin + 1), (finFin - (inicioFin + 3)))) + "}"

        Return strTemp
    End Function

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class