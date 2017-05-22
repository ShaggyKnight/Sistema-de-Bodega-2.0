Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class DataDespachoTransferencia
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim tipoBusqueda As String = context.Request("tipoBusqueda")

        Select Case tipoBusqueda
            'Carga los datos iniciales del form.
            Case "periodoForm"
                jsonSerializado = getPeriodoBD(context)
            Case "estadoPedidos"
                jsonSerializado = getEstadosPedido(context)
            Case "listaPeriodos"
                jsonSerializado = getListaPeriodos(context)
            Case "busqedaListaDespachos"
                'Busca transferencias para el popUp.
                jsonSerializado = busquedaListaDespachosFiltrado(context)
            Case "busquedaDatosTransferencia"
                ' llama al encabezado de datos del form luego de la busqueda. (fast)
                jsonSerializado = busquedaDespachoTrasferencia(context)
            Case "buscaMatsTransferencia"
                'Carga datos para grid en busqueda rapida (fast)
                jsonSerializado = busquedaMaterialesTrasferencia(context)
            Case "buscaDetalleMaterial"
                jsonSerializado = busquedaDetalleMaterial(context)
            Case "guardarDetalleMat"
                jsonSerializado = saveDetalleMaterial(context)
            Case "guardaTransferencia"
                'Inicia proceso de save para la transaccion de traspaso.
                jsonSerializado = generaDespXTransferencia(context)
            Case "BuscaOrigenDeDatos"
                'Busca donde estan los datos al momento de solicitarlos.
                jsonSerializado = OrigenDataDetalle(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function generaDespXTransferencia(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim validate As New Dictionary(Of String, String)
        Dim serializer As New JavaScriptSerializer
        Dim periodo As String
        Dim numeroPedido As Integer = Integer.Parse(Trim(context.Request("numeroPedido")))
        Dim periodoPedido As String = Trim(context.Request("periodoDespacho"))
        Dim usuario As String = Trim(context.Request("usuario"))
        Dim descripcion As String = Trim(context.Request("observacionPedido"))
        Dim codigoBodegaRecibe As String = Trim(context.Request("bodegaSolicita"))
        Dim codigoBodegaDespacha As String = Trim(context.Request("bodegaDespacha"))
        Dim NumTransferencia As String = Trim(context.Request("nroTransferencia"))
        periodo = ControladorPersistencia.getFechaServidor().Year
        validate = ControladorPersistencia.generaDespachoTrasferencia(numeroPedido, periodo, descripcion, codigoBodegaRecibe, codigoBodegaDespacha, periodoPedido, usuario, NumTransferencia)

        If Integer.Parse(validate("ERROR")) = 0 Then
            jsonserializado = "{""status"":""success"",""cmvNumero"":""" & validate("FLD_CMVNUMERO") & """,""periodo"":""" & validate("FLD_PERCODIGO") & """,""pboEstado"":""" & validate("FLD_PBOESTADO") & """,""tmvCodigo"":""" & validate("FLD_TMVCODIGO") & """}"
        Else
            jsonserializado = "{""status"":""error"",""message"":""Error en el guardado de los datos, Vuelva a intentarlo mas tarde. Si el problema persiste comuniquese con informática. Error: " & validate("MENSAJE") & "}"
        End If

        Return jsonserializado
    End Function
    Public Function saveDetalleMaterial(ByVal context As HttpContext)
        Dim jsonSerializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim nroPedido As String = context.Request("NumPedido")
        Dim periodoPedido As String = context.Request("PeriodoPedido")
        Dim numeroTransaccion As String = context.Request("NuevoNumTransaccion")
        ' saca la fecha
        Dim periodoTransaccion As String = ControladorPersistencia.getFechaServidor().Year
        ' saca el usuario
        Dim usuarioSesion As UsuarioLogeado = context.Session("usuarioLogeado")
        Dim usuario = usuarioSesion.username.Trim()
        Dim numeroLinea As Integer = Integer.Parse(context.Request("numeroLinea"))

        Dim largoGridDetalles As Integer = Integer.Parse(context.Request("lengthDetalles"))

        Dim codigoMateChange As String = context.Request("codMaterial")
        Dim cantidadChanged As String = context.Request("cantidadMaterial")
        Dim loteSerie As String = UCase(context.Request("LoteMaterial"))
        Dim fechaVencimiento As String = context.Request("fechaVto")

        Dim validate As New Dictionary(Of String, String)

        validate = ControladorPersistencia.saveDetalleMaterialDespTransf(nroPedido, periodoPedido, codigoMateChange, loteSerie, cantidadChanged, fechaVencimiento,
                                                                 usuario, numeroLinea, 8, periodoTransaccion, numeroTransaccion)

        If (Integer.Parse(validate("ERROR")) = 1) Then
            jsonSerializado = "{""status"":""error"",""message"":""OCURRIO EL SIGUIENTE ERROR: " & validate("MENSAJE") & ", vuelva a intentarlo mas tarde. Si el problema persiste contactese con Informática.""}"
        Else
            jsonSerializado = "{""status"":""success""}"
        End If

        Return jsonSerializado

    End Function
    Public Function busquedaDetalleMaterial(ByVal context As HttpContext)
        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim numeroPedido As String = context.Request("numeroPedido")
        Dim periodoPedido As String = context.Request("periodo")
        Dim codBodegaDespacha As String = context.Request("bodegaDespacha")
        Dim numeroTransfer As String = context.Request("numeroTransfer")
        Dim periodoTransfer As String = context.Request("periodoTrafer")
        Dim codigoMaterial As String = context.Request("codigoMaterial")
        Dim cantidadPendiente As String = context.Request("cantidadPendiente")
        Dim listaDeDetallesMat As New ListaDetallesMatDespXTransfer
        Dim ListaDetallesMaterial As New List(Of Dictionary(Of String, String))

        ListaDetallesMaterial = ControladorPersistencia.getDetalleMaterial(codBodegaDespacha, codigoMaterial)

        For Each Detalle As Dictionary(Of String, String) In ListaDetallesMaterial

            If (cantidadPendiente > Double.Parse(Detalle("FLD_CANTIDAD"))) Then

                Dim nuevoDetalleMat As New DetalleMaterialDespXTransferencia(listaDeDetallesMat.total + 1, _
                                                                         Trim(Detalle("FLD_MOVNUMEROLINEA")), _
                                                                         Trim(Detalle("FLD_TMVCODIGO")), _
                                                                         Trim(Detalle("FLD_PERCODIGO")), _
                                                                         Trim(Detalle("FLD_CMVNUMERO")), _
                                                                         Trim(Detalle("FLD_MATCODIGO")), _
                                                                         Trim(Detalle("FLD_CANTIDAD")), _
                                                                         Trim(Detalle("FLD_LOTESERIE")), _
                                                                         Trim(Detalle("FLD_FECHAVENCIMIENTO")))
                listaDeDetallesMat.agregarDetalle(nuevoDetalleMat)
                cantidadPendiente -= Double.Parse(Detalle("FLD_CANTIDAD"))
            Else
                Dim nuevoDetalleMat As New DetalleMaterialDespXTransferencia(listaDeDetallesMat.total + 1, _
                                                                         Trim(Detalle("FLD_MOVNUMEROLINEA")), _
                                                                         Trim(Detalle("FLD_TMVCODIGO")), _
                                                                         Trim(Detalle("FLD_PERCODIGO")), _
                                                                         Trim(Detalle("FLD_CMVNUMERO")), _
                                                                         Trim(Detalle("FLD_MATCODIGO")), _
                                                                         cantidadPendiente, _
                                                                         Trim(Detalle("FLD_LOTESERIE")), _
                                                                         Trim(Detalle("FLD_FECHAVENCIMIENTO")))
                listaDeDetallesMat.agregarDetalle(nuevoDetalleMat)

                Exit For
            End If
            

        Next

        jsonserializado = serializer.Serialize(listaDeDetallesMat)
        Return jsonserializado
    End Function
    Public Function busquedaMaterialesTrasferencia(ByVal context As HttpContext)
        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim nroTransf As String = context.Request("numeroPedido")
        Dim periodoTransf As String = context.Request("periodoPedido")
        Dim codBodegaDespacha As String = context.Request("codBodDesp")
        Dim codBodegaSolicita As String = context.Request("codBodSoli")
        Dim usuarioTranf As String = context.Request("usuario")
        Dim listaDeMatsTransfer As New ListaMaterialesDespXTransfer
        Dim listaMaterialesTranfer As New List(Of Dictionary(Of String, String))

        listaMaterialesTranfer = ControladorPersistencia.getListaMaterialesTransfer(nroTransf, periodoTransf, codBodegaDespacha, codBodegaSolicita, _
                                                                                    usuarioTranf)

        For Each material As Dictionary(Of String, String) In listaMaterialesTranfer

            If (Integer.Parse(material("ERROR")) = 1) Then

                jsonserializado = "{""status"":""error"",""message"":""Ocurrio un error en la base de datos, " & material("MENSAJE") & "}"
                Return jsonserializado

            Else
                Dim nuevoMaterial As New MaterialDespXTransferencia(Trim(material("FLD_MATCODIGO")), _
                                                                     Trim(material("FLD_MATNOMBRE")), _
                                                                     Trim(material("FLD_ITECODIGO")), _
                                                                     Trim(material("FLD_ITEDENOMINACION")), _
                                                                     Trim(material("FLD_MOVCANTIDAD")), _
                                                                     Trim(material("FLD_CANTPEDIDA")), _
                                                                     Trim(material("FLD_CANTPENDIENTE")), _
                                                                     Trim(material("FLD_EXISBODRECI")), _
                                                                     Trim(material("FLD_EXISBODDESP")), _
                                                                     Trim(material("FLD_EXIPRECIOUNITARIO")), _
                                                                     0, _
                                                                     Trim(material("FLD_TOTAL")))
                listaDeMatsTransfer.agregarMaterial(nuevoMaterial)
            End If
        Next

        jsonserializado = serializer.Serialize(listaDeMatsTransfer)
        Return jsonserializado
    End Function
    Public Function busquedaDespachoTrasferencia(ByVal context As HttpContext)
        Dim serializer As New JavaScriptSerializer()
        Dim periodo As String = context.Request("periodo")
        Dim numeroPedido As String = context.Request("numeroPedido")
        Dim datosDespacho As New DataDespachoXTransferencia()
        Dim Transferencia As New Dictionary(Of String, String)

        Transferencia = ControladorPersistencia.getDatosDespachoXTransferencia(periodo, numeroPedido)

        Dim despacho As New DespachoXTransferencia(1, _
                                                  Trim(Transferencia("FLD_PBONUMERO")), _
                                                  Trim(Transferencia("FLD_PERCODIGO")), _
                                                  Trim(Transferencia("FLD_PBOESTADO")), _
                                                  Trim(Transferencia("FLD_PBOTIPO")), _
                                                  Trim(Transferencia("FLD_OBSERVACION")), _
                                                  Trim(Transferencia("FLD_BODORIGEN")), _
                                                  Trim(Transferencia("FLD_BODNOMBRESORI")), _
                                                  Trim(Transferencia("FLD_BODDESTINO")), _
                                                  Trim(Transferencia("FLD_BODNOMBRESDES")), _
                                                  Trim(Transferencia("FLD_CMVNUMERO")), _
                                                  Trim(Transferencia("FLD_PERPEDIDO")))
        datosDespacho.agregarDespacho(despacho)

        Dim datosSerializados As String = serializer.Serialize(datosDespacho)
        Dim inicioFin As Integer = datosSerializados.IndexOf("["c)
        Dim finFin As Integer = datosSerializados.Length
        Dim strTemp As String = (datosSerializados.Substring(0, inicioFin))
        strTemp = strTemp + (datosSerializados.Substring((inicioFin + 1), (finFin - (inicioFin + 3)))) + "}"

        Return strTemp
    End Function
    Public Function busquedaListaDespachosFiltrado(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim nroTransf As String = context.Request("numeroPedido")
        Dim periodoTransf As String = context.Request("periodoPedido")
        Dim estadoTransf As String = context.Request("estadoPedido")
        Dim listaDeTranferencias As New ListaDespachosXTransferecia
        Dim listaDespTranferencias As New List(Of Dictionary(Of String, String))

        listaDespTranferencias = ControladorPersistencia.getListaTransferencias(nroTransf, periodoTransf, estadoTransf)

        For Each transferencia As Dictionary(Of String, String) In listaDespTranferencias

            Dim nuevaTransf As New DespachoXTransferencia(listaDeTranferencias.total + 1, _
                                                         Trim(transferencia("FLD_PBONUMERO")), _
                                                         Trim(transferencia("FLD_PERCODIGO")), _
                                                         Trim(transferencia("FLD_PBOESTADO")), _
                                                         Trim(transferencia("FLD_PBOTIPO")), _
                                                         Trim("SIN OBSERVACIÓN"), _
                                                         Trim(transferencia("SOL_A")), _
                                                         Trim(transferencia("FLD_BODORIGEN")), _
                                                         Trim(transferencia("FLD_BODDESTINO")), _
                                                         "", _
                                                         0, _
                                                         0)
            listaDeTranferencias.ingresaTransferencia(nuevaTransf)
        Next

        serializer.MaxJsonLength = 30000000
        jsonserializado = serializer.Serialize(listaDeTranferencias)
        Return jsonserializado

    End Function
    Public Function getListaPeriodos(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listPeriodos As New List(Of Dictionary(Of String, String))
        Dim ListaDePeriodos As New ListaObjetosSelectBox

        listPeriodos = ControladorPersistencia.getListaPeriodos()

        For Each datosPeriodo As Dictionary(Of String, String) In listPeriodos
            Dim Periodo As New ObjetoSelectBox(Trim(datosPeriodo("percodigo")), Trim(datosPeriodo("pernombre")))
            ListaDePeriodos.setObjeto(Periodo)
        Next

        jsonSerializado = serializer.Serialize(ListaDePeriodos)

        Return jsonSerializado

    End Function
    Public Function getEstadosPedido(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listEstados As New List(Of Dictionary(Of String, String))
        Dim listaDeEstados As New ListaObjetosSelectBox

        listEstados = ControladorPersistencia.getEstadoPedidosBodega()

        For Each datosEstado As Dictionary(Of String, String) In listEstados
            Dim estado As New ObjetoSelectBox(Trim(datosEstado("FLD_PBOESTADO")), Trim(datosEstado("FLD_COMBO")))
            listaDeEstados.setObjeto(estado)
        Next

        jsonSerializado = serializer.Serialize(listaDeEstados)

        Return jsonSerializado
    End Function
    Public Function getPeriodoBD(ByVal context As HttpContext)
        Dim serializer As New JavaScriptSerializer()
        Dim periodo As Integer = ControladorPersistencia.getFechaServidor().Year
        Dim datosDespacho As New DatosFormDespachoTransferencia()
        Dim Pedido As New DespachoXTransferencia(1, 0, periodo, "", "", "", "", "", "", "", 0, periodo)

        datosDespacho.setDatos(Pedido)
        Dim datosSerializados As String = serializer.Serialize(datosDespacho)
        Dim inicioFin As Integer = datosSerializados.IndexOf("["c)
        Dim finFin As Integer = datosSerializados.Length
        Dim strTemp As String = (datosSerializados.Substring(0, inicioFin))
        strTemp = strTemp + (datosSerializados.Substring((inicioFin + 1), (finFin - (inicioFin + 3)))) + "}"

        Return strTemp
    End Function
    Public Function OrigenDataDetalle(ByVal context As HttpContext)

        Dim respuesta As String
        Dim serializer As New JavaScriptSerializer
        Dim nroTransf As String = context.Request("NumTransferencia")
        Dim periodoTransf As String = context.Request("periodoPedido")
        Dim codMaterial As String = context.Request("CodMaterial")

        Dim json As New JavaScriptSerializer
        Dim retorno As ListaDetalleArticulos
        retorno = ControladorPersistencia.BuscaDetalleMaterial_Despa_Transferencia(nroTransf, periodoTransf, codMaterial)

        respuesta = json.Serialize(retorno)
        Return respuesta
    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class