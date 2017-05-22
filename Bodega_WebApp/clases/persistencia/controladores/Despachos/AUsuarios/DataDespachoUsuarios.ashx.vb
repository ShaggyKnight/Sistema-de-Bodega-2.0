Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports System.Globalization

Public Class DataDespachoUsuarios
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim tipoBusqueda As String = context.Request("tipoBusqueda")

        Select Case tipoBusqueda
            Case "periodoForm"
                jsonSerializado = getPeriodoForm()
            Case "DatosPedido"
                'llama a la carga de datos desde el buscador para el encabezado principal  (FAST)
                jsonSerializado = getDatosPedidoBodega(context)
            Case "MaterialesPedido"
                'llama a carga de datos desde el buscador para grid principal   (FAST)
                jsonSerializado = getMaterialesPedido(context)
            Case "DetalleMaterial"
                jsonSerializado = getDetalleMaterialPedido(context)
            Case "estadoPedidos"
                jsonSerializado = getEstadosPedido(context)
            Case "listaPeriodos"
                jsonSerializado = getListaPeriodos(context)
            Case "centrosCosto"
                jsonSerializado = getListaCentroCosto(context)
            Case "busqedaListaPedidos"
                'Carga el grid de busqueda
                jsonSerializado = busquedaListaPedidosFiltrado(context)
            Case "guardarDetalle"
                ' guarda el detalle del producto.
                jsonSerializado = saveDetalleMaterial(context)
            Case "generarDespacho"
                'Inicia proceso de save para el Despacho de Usuario.
                jsonSerializado = generarDespachoUsuarios(context)
            Case "BuscaOrigenDeDatos"
                'Busca donde estan los datos al momento de solicitarlos.
                jsonSerializado = OrigenDataDetalle(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function generarDespachoUsuarios(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim validate As New Dictionary(Of String, String)
        Dim serializer As New JavaScriptSerializer
        Dim periodo As String = context.Request("periodo")
        Dim usuario As String = context.Request("usuario")
        Dim descripcion As String = UCase(context.Request("decripcion"))
        Dim numeroPedido As Integer = Integer.Parse(context.Request("numeroPedido"))
        Dim numeroDespacho As Integer = Integer.Parse(context.Request("numeroDespacho"))
        Dim codigoBodega As String = context.Request("codigoBodega")
        Dim cantMatetriales As Integer = context.Request("lengthMateriales")

        For i As Integer = 0 To cantMatetriales - 1
            Dim matCodigo As String = context.Request("gridData[" & i & "][recid]")
            Dim cantidad As String = context.Request("gridData[" & i & "][cantidadADespachar]")
            Dim total As String = context.Request("gridData[" & i & "][total]")

            ' En la tabla del encabezado del material cambia FLD_ADESPACHAR, FLD_CANTPENDIENTE, FLD_TOTAL (monto)
            validate = ControladorPersistencia.updateMaterialesDespachoUsuarios(numeroPedido, periodo, numeroDespacho, matCodigo, cantidad, total)

            If (validate("validate") <> "0") Then
                jsonserializado = "{""status"":""error"",""message"":""Error en el guardado de los datos, Vuelva a intentarlo mas tarde. Si el problema persiste comuniquese con informática. Error: " & validate("error") & "}"
                Return jsonserializado
            End If
        Next

        ' Graba la transaccion desde las 2 tablas temporales que contiene la información
        validate = ControladorPersistencia.generaDespachoAUsuarios(numeroPedido, usuario, descripcion, periodo, numeroDespacho, codigoBodega)

        If (validate("FLD_CMVNUMERO") <> "0") Then
            jsonserializado = "{""status"":""success"",""tmvCodigo"":""" & Trim(validate("FLD_TMVCODIGO")) & """,""periodo"":""" & Trim(validate("FLD_PERCODIGO")) & """,""cmvNumero"":""" & Trim(validate("FLD_CMVNUMERO")) & """,""estadoPedido"":""" & Trim(validate("FLD_PBOESTADO")) & """,""FechaDespacho"":""" & Trim(validate("FLD_DESFECHA")) & """}"
        Else
            jsonserializado = "{""status"":""error"",""message"":""Se produjo el siguiente en error en la base de datos: " & validate("ERROR") & " vuelva a intentarlo mas tarde, si el problema persiste contacte a informática.""}"
        End If

        Return jsonserializado

    End Function

    Public Function saveDetalleMaterial(ByVal context As HttpContext)


        Dim jsonSerializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim numeroUsuario As String = context.Request("NumPedido")
        'Dim Periodo As String = context.Request("PeriodoPedido")
        Dim Periodo As String
        Periodo = ControladorPersistencia.getFechaServidor().Year
        Dim numeroDespacho As String = context.Request("NuevoNumDespacho")
        Dim codigoBodega As String = context.Request("CodBodegaPedido")

        Dim matCodigo As String = context.Request("codMaterial")
        Dim cantidad As String = context.Request("cantidadMaterial")
        Dim loteSerieChanged As String = UCase(context.Request("LoteMaterial"))
        Dim fechaVencimiento As String = context.Request("fechaVto")
        Dim numeroLinea As Integer = Integer.Parse(context.Request("numeroLinea"))

        Dim validate As New Dictionary(Of String, String)
        'saveDetalleMaterialDespUsuario(numeroDespacho, periodo, numeroPedido, _
        '                                                                      matCodigo, Integer.Parse(cantidad), loteSerieChanged, _
        '                                                                      loteSerieAnt, fechaVencimiento, codigoBodega)
        validate = ControladorPersistencia.saveDetalleMaterialDespUsuario(numeroUsuario, Periodo, numeroDespacho,
                                                                              matCodigo, cantidad, loteSerieChanged,
                                                                              fechaVencimiento, codigoBodega, numeroLinea)

        If (Integer.Parse(validate("ERROR")) = 1) Then
            jsonSerializado = "{""status"":""error"",""message"":""OCURRIO EL SIGUIENTE ERROR: " & validate("MENSAJE") & ", vuelva a intentarlo mas tarde. Si el problema persiste contactese con Informática.""}"
        Else
            jsonSerializado = "{""status"":""success""}"
        End If

        Return jsonSerializado

    End Function
    Public Function busquedaListaPedidosFiltrado(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim nroPedido As String = context.Request("numeroPedido")
        Dim periodoPedido As String = context.Request("periodoPedido")
        Dim estadoPedido As String = context.Request("estadoPedido")
        Dim centroCostoPedido As String = context.Request("centroCostoPedido")
        Dim tipoPedido As String = context.Request("tipoPedido")
        Dim listaDePedidos As New ListaPedidosDespUsuarios
        Dim listaPedidosDesp As New List(Of Dictionary(Of String, String))

        listaPedidosDesp = ControladorPersistencia.getListaPedidosBodega()

        For Each recepcion As Dictionary(Of String, String) In listaPedidosDesp

            If (Trim(nroPedido) <> Nothing And Trim(nroPedido) <> "undefined" And Trim(nroPedido) <> "" And Trim(nroPedido) <> Trim(recepcion("FLD_PBONUMERO"))) Then

            ElseIf (Trim(periodoPedido) <> Nothing And Trim(periodoPedido) <> "undefined" And Trim(periodoPedido) <> "" And Trim(periodoPedido) <> Trim(recepcion("FLD_PERCODIGO"))) Then

            ElseIf (Trim(centroCostoPedido) <> Nothing And Trim(centroCostoPedido) <> "undefined" And Trim(centroCostoPedido) <> "" And Trim(centroCostoPedido) <> Trim(recepcion("FLD_CCOSTONUMERO"))) Then

            ElseIf (Trim(tipoPedido) <> Nothing And Trim(tipoPedido) <> "undefined" And Trim(tipoPedido) <> "" And Trim(tipoPedido) <> Trim(recepcion("FLD_PBOTIPONUMERO"))) Then

            ElseIf (Trim(estadoPedido) <> Nothing And Trim(estadoPedido) <> "undefined" And Trim(estadoPedido) <> "" And Trim(estadoPedido) <> Trim(recepcion("FLD_ESTADOPEDIDO"))) Then
            Else
                Dim nuevoPedido As New DespachoHaciaUsuarios(listaDePedidos.total + 1, _
                                                             recepcion("FLD_PBONUMERO"), _
                                                             recepcion("FLD_PERCODIGO"), _
                                                             recepcion("FLD_PBOESTADO"), _
                                                             recepcion("SOL_A"), _
                                                             recepcion("FLD_CCOCODIGO"), _
                                                             recepcion("FLD_PBOTIPO"), _
                                                             recepcion("FLD_OBSERVACION"))
                listaDePedidos.setPedido(nuevoPedido)
            End If
        Next

        serializer.MaxJsonLength = 30000000
        jsonserializado = serializer.Serialize(listaDePedidos)
        Return jsonserializado

    End Function
    Public Function getListaCentroCosto(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listCentroCosto As New List(Of Dictionary(Of String, String))
        Dim ListaDeCentroCosto As New ListaObjetosSelectBox

        listCentroCosto = ControladorPersistencia.getCentrosCosto()

        For Each datosCentroCosto As Dictionary(Of String, String) In listCentroCosto
            Dim Periodo As New ObjetoSelectBox(datosCentroCosto("FLD_CCOCODIGO"), datosCentroCosto("FLD_COMBO"))
            ListaDeCentroCosto.setObjeto(Periodo)
        Next

        jsonSerializado = serializer.Serialize(ListaDeCentroCosto)

        Return jsonSerializado

    End Function
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
    Public Function getEstadosPedido(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listEstados As New List(Of Dictionary(Of String, String))
        Dim listaDeEstados As New ListaObjetosSelectBox

        listEstados = ControladorPersistencia.getEstadoPedidosBodega()

        For Each datosEstado As Dictionary(Of String, String) In listEstados
            Dim estado As New ObjetoSelectBox(datosEstado("FLD_PBOESTADO"), datosEstado("FLD_COMBO"))
            listaDeEstados.setObjeto(estado)
        Next

        jsonSerializado = serializer.Serialize(listaDeEstados)

        Return jsonSerializado
    End Function
    Public Function getDetalleMaterialPedido(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer
        Dim jsonSerializado As String = ""
        Dim periodo As String = context.Request("periodo")
        Dim numeroPedido As Integer = Integer.Parse(context.Request("numeroPedido"))
        Dim codigobodega As String = context.Request("codigoBodega")
        Dim numeroDespacho As Integer = Integer.Parse(context.Request("numeroDespacho"))
        Dim matCodigo As String = context.Request("codigoMaterial")
        Dim cantidadPendiente As Integer = Integer.Parse(context.Request("cantidadPendiente"))
        Dim detallesMaterial As New List(Of Dictionary(Of String, String))
        Dim listaDetallesMat As New ListaDetallesMaterial()

        detallesMaterial = ControladorPersistencia.getDetalleMaterialPedidoBodega(numeroPedido, codigobodega, matCodigo)

        For Each detalle As Dictionary(Of String, String) In detallesMaterial

            If (cantidadPendiente >= Double.Parse(detalle("FLD_CANTIDAD"))) Then

                Dim nuevoDetalle As New DetallesMaterial(listaDetallesMat.total + 1, _
                                                      matCodigo, _
                                                      detalle("FLD_CANTIDAD"), _
                                                      detalle("FLD_LOTESERIE"), _
                                                      0, _
                                                      detalle("FLD_FECHAVENCIMIENTO"))
                listaDetallesMat.setDetalleMaterialDespacho(nuevoDetalle)
                cantidadPendiente -= Double.Parse(detalle("FLD_CANTIDAD"))
            Else
                Dim nuevoDetalle As New DetallesMaterial(listaDetallesMat.total + 1, _
                                                      matCodigo, _
                                                      cantidadPendiente, _
                                                      detalle("FLD_LOTESERIE"), _
                                                      0, _
                                                      detalle("FLD_FECHAVENCIMIENTO"))
                listaDetallesMat.setDetalleMaterialDespacho(nuevoDetalle)

                Exit For
            End If

        Next

        jsonSerializado = serializer.Serialize(listaDetallesMat)
        Return jsonSerializado
    End Function

    Public Function getMaterialesPedido(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer
        Dim jsonSerializado As String = ""
        Dim periodo As String = context.Request("periodo")
        Dim numeroPedido As Integer = Integer.Parse(context.Request("numeroPedido"))
        Dim codigobodega As String = context.Request("codigoBodega")
        Dim numeroDespacho As Integer = Integer.Parse(context.Request("numeroDespacho"))
        Dim materialesPedido As New List(Of Dictionary(Of String, String))
        Dim listaMaterialesPedido As New ListaMaterialesDespachoUsuarios()

        materialesPedido = ControladorPersistencia.getMaterialesPedidoBodega(periodo, numeroPedido, codigobodega, numeroDespacho)

        For Each material As Dictionary(Of String, String) In materialesPedido

            Dim nuevoMaterial As New MaterialPedidoUsuarios(Trim(material("FLD_MATCODIGO")), _
                                                            Trim(material("FLD_MATNOMBRE")), _
                                                            Trim(material("FLD_ITECODIGO")), _
                                                            Trim(material("FLD_ITEDENOMINACION")), _
                                                            Trim(material("FLD_CANTPEDIDA")), _
                                                            Trim(material("FLD_MOVCANTIDAD")), _
                                                            Trim(material("FLD_CANTPENDIENTE")), _
                                                            Trim(material("FLD_EXICANTIDAD")), _
                                                            Trim(material("FLD_EXIPRECIOUNITARIO")), _
                                                            Trim(material("FLD_ADESPACHAR")), _
                                                            Trim(material("FLD_TOTAL")), _
                                                            Trim(material("FLD_PAUTA")))
            listaMaterialesPedido.setObjeto(nuevoMaterial)

        Next

        jsonSerializado = serializer.Serialize(listaMaterialesPedido)
        Return jsonSerializado

    End Function
    Public Function getDatosPedidoBodega(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim periodo As String = context.Request("periodo")
        Dim numeroPedido As Integer = Integer.Parse(context.Request("numeroPedido"))
        Dim datosDespacho As New DatosFormDespachoUsuarios()
        Dim pedidoBodega As New Dictionary(Of String, String)

        pedidoBodega = ControladorPersistencia.getDatosPedidoAUsuarios(periodo, numeroPedido)

        Dim despacho As New DespachoHaciaUsuarios(pedidoBodega("FLD_PBONUMERO"), _
                                                  pedidoBodega("FLD_PERCODIGO"), _
                                                  pedidoBodega("FLD_PBOESTADO"), _
                                                  pedidoBodega("FLD_BODCODIGO"), _
                                                  pedidoBodega("FLD_BODNOMBRES"), _
                                                  pedidoBodega("FLD_CCOCODIGO"), _
                                                  pedidoBodega("FLD_PBOTIPO"), _
                                                  pedidoBodega("FLD_OBSERVACION"), _
                                                  pedidoBodega("FLD_CMVNUMERODESPACHO"), _
                                                  pedidoBodega("FLD_DESFECHA"))
        datosDespacho.setDatos(despacho)

        Dim datosSerializados As String = serializer.Serialize(datosDespacho)
        Dim inicioFin As Integer = datosSerializados.IndexOf("["c)
        Dim finFin As Integer = datosSerializados.Length
        Dim strTemp As String = (datosSerializados.Substring(0, inicioFin))
        strTemp = strTemp + (datosSerializados.Substring((inicioFin + 1), (finFin - (inicioFin + 3)))) + "}"

        Return strTemp
    End Function
    Public Function getPeriodoForm()

        Dim serializer As New JavaScriptSerializer()
        Dim periodo As Integer = ControladorPersistencia.getFechaServidor().Year
        Dim datosDespacho As New DatosFormDespachoUsuarios()
        Dim Pedido As New DespachoHaciaUsuarios(0, periodo, "", "0", "", "", "", "", 0, "01/01/1900")

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
        Dim NumDespacho As String = context.Request("NumDespacho")
        Dim periodoDespacho As String = context.Request("periodoPedido")
        Dim codMaterial As String = context.Request("CodMaterial")

        Dim json As New JavaScriptSerializer
        Dim retorno As ListaDetalleArticulos
        retorno = ControladorPersistencia.BuscaDetalleMaterial_Despa_HaciaUsuarios(numDespacho, periodoDespacho, codMaterial)

        respuesta = json.Serialize(retorno)
        Return respuesta
    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class