Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class DataDevolucionXTransferencia
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim tipoBusqueda As String = context.Request("tipoBusqueda")

        Select Case tipoBusqueda
            'Carga los datos iniciales del form.
            'Case "periodoForm"
            '    jsonSerializado = getPeriodoBD(context)
            'Case "estadoPedidos"
            '    jsonSerializado = getEstadosPedido(context)
            'Case "listaPeriodos"
            '    jsonSerializado = getListaPeriodos(context)

            Case "busquedaDatosTransferencia"
                ' llama al encabezado de datos del form luego de la busqueda. (fast)
                jsonSerializado = busquedaDevolucionTrasferencia(context)

            Case "buscaMatsTransferencia"
                'Carga datos para grid en busqueda rapida (fast)
                jsonSerializado = busquedaMaterialesDevoXTrasferencia(context)
                'Case "buscaDetalleMaterial"
                '    jsonSerializado = busquedaDetalleMaterial(context)

            Case "busquedaListaDespachos"
                'Busca transferencias para el popUp.
                jsonSerializado = busquedaListaDespachosFiltrado(context)

            Case "guardarDetalleMat"
                jsonSerializado = saveDetalleMaterial(context)

            Case "BuscaOrigenDeDatos"
                'Busca donde estan los datos al momento de solicitarlos.
                jsonSerializado = OrigenDataDetalle(context)

            Case "guardaTransferencia"
                'Inicia proceso de save para la transaccion de traspaso.
                jsonSerializado = generaDespXTransferencia(context)

            Case "AutorizacionDevolucion"
                'Busca donde estan los datos al momento de solicitarlos.
                jsonSerializado = AutorizacionDevolucion(context)

        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function busquedaDevolucionTrasferencia(ByVal context As HttpContext)
        Dim serializer As New JavaScriptSerializer()
        Dim periodo As String = context.Request("periodo")
        Dim numeroPedido As String = context.Request("numeroPedido")
        Dim datosDevolucion As New DataDevoXTransferencia()
        Dim Transferencia As New Dictionary(Of String, String)

        Transferencia = ControladorPersistencia.getDatosDevolucionXTransferencia(periodo, numeroPedido)

        Dim info As New Encabezado_DevoXTransferencia(1, _
                                                  Trim(Transferencia("FLD_TRANUMERO")), _
                                                  Trim(Transferencia("FLD_PERCODIGO")), _
                                                  Trim(Transferencia("FLD_PBOESTADO")), _
                                                  Trim(Transferencia("FLD_PBOTIPO")), _
                                                  Trim(Transferencia("FLD_OBSERVACION")), _
                                                  Trim(Transferencia("FLD_BODORIGEN")), _
                                                  Trim(Transferencia("FLD_BODNOMBRESORI")), _
                                                  Trim(Transferencia("FLD_BODDESTINO")), _
                                                  Trim(Transferencia("FLD_BODNOMBRESDES")), _
                                                  Trim(Transferencia("FLD_CMVNUMERO")), _
                                                  Trim(Transferencia("FLD_PERPEDIDO")), _
                                                  Trim(Transferencia("FLD_AUTORIZADO")), _
                                                  Trim(Transferencia("FLD_PBONUMERO")))
        datosDevolucion.agregarInfo(info)

        Dim datosSerializados As String = serializer.Serialize(datosDevolucion)
        Dim inicioFin As Integer = datosSerializados.IndexOf("["c)
        Dim finFin As Integer = datosSerializados.Length
        Dim strTemp As String = (datosSerializados.Substring(0, inicioFin))
        strTemp = strTemp + (datosSerializados.Substring((inicioFin + 1), (finFin - (inicioFin + 3)))) + "}"

        Return strTemp
    End Function
    Public Function busquedaMaterialesDevoXTrasferencia(ByVal context As HttpContext)
        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim nroTransf As String = context.Request("numeroTransf")       'Nº Transferencia, una vez realizada la transferencia entre bodega @FLD_PBONUMERO
        Dim periodoTransf As String = context.Request("periodoPedido")
        Dim codBodegaDespacha As String = context.Request("codBodDesp")
        Dim codBodegaSolicita As String = context.Request("codBodSoli")
        Dim usuarioTranf As String = context.Request("usuario")
        Dim numeroPedido As String = context.Request("numeroPedido")    ' Nº Mov Transferencia, solicitud de pedido @FLD_CMVNUMERO

        Dim nroDevoTransf As String = context.Request("nroDevoTransf")
        Dim periodoDevoTransf As String = context.Request("periodoDevoTransf")

        'Periodo = ControladorPersistencia.getFechaServidor().Year

        If (nroDevoTransf.Equals("")) Then
            nroDevoTransf = "0"
            periodoDevoTransf = ControladorPersistencia.getFechaServidor().Year
        End If


        Dim listaDeMatsTransfer As New ListaMaterialesDespXTransfer
        Dim listaMaterialesTranfer As New List(Of Dictionary(Of String, String))

        listaMaterialesTranfer = ControladorPersistencia.getListaMaterialesDevoTransfer(nroTransf, periodoTransf, codBodegaDespacha, codBodegaSolicita, _
                                                                                    usuarioTranf, numeroPedido, nroDevoTransf, periodoDevoTransf)

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
    Public Function busquedaListaDespachosFiltrado(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim nroTransf As String = context.Request("numeroPedido")
        Dim periodoTransf As String = context.Request("periodoPedido")
        Dim estadoTransf As String = context.Request("estadoPedido")
        Dim listaDeTranferencias As New ListaDevolucionXTransferecia
        Dim listaDespTranferencias As New List(Of Dictionary(Of String, String))

        'listaDespTranferencias = ControladorPersistencia.getListaTransferencias(nroTransf, periodoTransf, estadoTransf)
        listaDespTranferencias = ControladorPersistencia.getListaTransferenciasRealizadas(nroTransf, periodoTransf)

        For Each transferencia As Dictionary(Of String, String) In listaDespTranferencias

            Dim nuevaTransf As New DatosGridBuscar_DevoXTransferencia(listaDeTranferencias.total + 1, _
                                                                     Trim(transferencia("FLD_PERCODIGO")), _
                                                                     Trim(transferencia("FLD_TRANUMERO")), _
                                                                     Trim(transferencia("FLD_TRAFECHA")), _
                                                                     Trim(transferencia("FLD_PBOTIPO")), _
                                                                     Trim(transferencia("FLD_BODORIGEN")), _
                                                                     Trim(transferencia("FLD_BODDESTINO")), _
                                                                     Trim(transferencia("FLD_PBONUMERO")), _
                                                                     Trim(transferencia("FLD_PERPEDIDO"))
                                                                     )

            listaDeTranferencias.ingresaTransferencia(nuevaTransf)
        Next

        serializer.MaxJsonLength = 30000000
        jsonserializado = serializer.Serialize(listaDeTranferencias)
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
                                                                 usuario, numeroLinea, "F", periodoTransaccion, numeroTransaccion)

        If (Integer.Parse(validate("ERROR")) = 1) Then
            jsonSerializado = "{""status"":""error"",""message"":""OCURRIO EL SIGUIENTE ERROR: " & validate("MENSAJE") & ", vuelva a intentarlo mas tarde. Si el problema persiste contactese con Informática.""}"
        Else
            jsonSerializado = "{""status"":""success""}"
        End If

        Return jsonSerializado

    End Function
    Public Function OrigenDataDetalle(ByVal context As HttpContext)

        Dim respuesta As String
        Dim serializer As New JavaScriptSerializer

        Dim NDevTranf As String = context.Request("NumDevTransferencia")
        Dim fechaDevTranf As String = context.Request("periodoDevTransferencia")
        Dim codMaterial As String = context.Request("CodMaterial")
        Dim nroTransf As String = context.Request("NumPedido")
        Dim periodoTransf As String = context.Request("periodoPedido")

        Dim json As New JavaScriptSerializer
        Dim retorno As ListaDetalleArticulos
        retorno = ControladorPersistencia.BuscaDetalleMaterial_Devo_Transferencia(NDevTranf, fechaDevTranf, codMaterial, nroTransf, periodoTransf)

        respuesta = json.Serialize(retorno)
        Return respuesta
    End Function
    Public Function generaDespXTransferencia(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim validate As New Dictionary(Of String, String)
        Dim serializer As New JavaScriptSerializer
        Dim periodo As String
        Dim numeroPedido As Integer = Integer.Parse(Trim(context.Request("numeroPedido")))  'Nº Transferencia, una vez realizada la transferencia entre bodega @FLD_PBONUMERO
        Dim periodoPedido As String = Trim(context.Request("periodoDespacho"))
        Dim usuario As String = Trim(context.Request("usuario"))
        Dim descripcion As String = Trim(context.Request("observacionPedido"))
        Dim codigoBodegaRecibe As String = Trim(context.Request("bodegaSolicita"))
        Dim codigoBodegaDespacha As String = Trim(context.Request("bodegaDespacha"))
        Dim NumTransferencia As String = Trim(context.Request("nroTransferencia"))          'Nº Correlativo de la transacción
        periodo = ControladorPersistencia.getFechaServidor().Year
        validate = ControladorPersistencia.genera_DevolucionXTrasferencia(numeroPedido, periodo, descripcion, codigoBodegaRecibe, codigoBodegaDespacha, periodoPedido, usuario, NumTransferencia)

        If Integer.Parse(validate("ERROR")) = 0 Then
            jsonserializado = "{""status"":""success"",""cmvNumero"":""" & validate("FLD_CMVNUMERO") & """,""periodo"":""" & validate("FLD_PERCODIGO") & """}"
        Else
            jsonserializado = "{""status"":""error"",""message"":""Error en el guardado de los datos, Vuelva a intentarlo mas tarde. Si el problema persiste comuniquese con informática. Error: " & validate("MENSAJE") & "}"
        End If

        Return jsonserializado
    End Function
    Public Function AutorizacionDevolucion(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim validate As New Dictionary(Of String, String)
        Dim serializer As New JavaScriptSerializer

        Dim NumDevoTransf As Integer = Integer.Parse(Trim(context.Request("numeroDevolucion")))
        Dim FechaDevoTransf As String = Trim(context.Request("periodoDevolucion"))
        Dim usuario As String = Trim(context.Request("usuario"))

        validate = ControladorPersistencia.genera_DevolucionTrasferencia(NumDevoTransf, FechaDevoTransf, usuario)

        If Integer.Parse(validate("ERROR")) = 0 Then
            jsonserializado = "{""status"":""success"",""cmvNumero"":""" & validate("FLD_CMVNUMERO") & """,""periodo"":""" & validate("FLD_PERCODIGO") & """,""tmvCodigo"":""" & validate("FLD_TMVCODIGO") & """}"
        Else
            jsonserializado = "{""status"":""error"",""message"":""Error en el guardado de los datos, Vuelva a intentarlo mas tarde. Si el problema persiste comuniquese con informática. Error: " & validate("MENSAJE") & "}"
        End If

        Return jsonserializado
    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class