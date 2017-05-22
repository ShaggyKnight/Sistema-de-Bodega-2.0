Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class GetDatosDevXNroPedido
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("tipoBusqueda")

        Select Case cmd
            Case "datosGrid"
                jsonSerializado = getDatosGrid(context)
            Case "datosSelect"
                jsonSerializado = getDatosSelect(context)
            Case "detallesMaterial"
                jsonSerializado = getDetalleMaterial(context)
            Case "datosGridPopUp"
                jsonSerializado = getDatosPopUpGrid(context)
            Case "saveDetallesMaterial"
                jsonSerializado = saveDatosDetallematerial(context)
            Case "generaDevolucion"
                jsonSerializado = generaDevolucionNMaterial(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    
    Public Function generaDevolucionNMaterial(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim estado As New Dictionary(Of String, String)
        Dim serializer As New JavaScriptSerializer
        Dim periodo As String = context.Request("periodo")
        Dim nroDespacho As String = context.Request("nroDespacho")
        Dim nroPedido As String = context.Request("nroPedido")
        Dim usuario As String = context.Request("nombreUsuario")
        Dim descripcion As String = context.Request("Observacion")
        Dim largoGridDetalles As Integer = Integer.Parse(context.Request("largoGrid"))
        Dim validate As Integer = 0

        For i As Integer = 0 To largoGridDetalles - 1

            Dim cantidadARecibir As String = context.Request("materiales[" & i & "][cantADevolver]")
            Dim matCodigo As String = context.Request("materiales[" & i & "][matCodigo]")
            Dim loteSerie As String = context.Request("materiales[" & i & "][lote_desp]")
            Dim fechaVencimiento As String = context.Request("materiales[" & i & "][fechaVencimiento_desp]")

            validate = ControladorLogica.actualizaEstadoMaterialDevolucion(nroDespacho, periodo, nroPedido, Trim(matCodigo), Integer.Parse(cantidadARecibir), Trim(usuario), Trim(loteSerie), Trim(fechaVencimiento))

            If (validate = 1) Then
                jsonSerializado = "{""status"":""error"",""message"":""Ocurrio un error al intentar guardar el detalle del Material, vuelva a intentarlo mas tarde. Si el problema persiste contactese con Informática.""}"
                Exit For
            Else
                jsonSerializado = "{""status"":""success""}"
            End If
        Next

        If (descripcion = Nothing Or descripcion = "") Then
            descripcion = "SIN DESCRIPCIÓN"
        End If

        estado = ControladorPersistencia.generaDevolucionXNPedido(Trim(usuario), descripcion, Trim(periodo), nroDespacho, nroPedido)

        If (estado("FLD_CMVNUMERO") <> "0") Then
            jsonSerializado = "{""status"":""succes"",""cmvNumero"":" & Trim(estado("FLD_CMVNUMERO")) & ",""tmvCodigo"":" & Trim(estado("FLD_TMVCODIGO")) & ",""periodo"":" & Trim(estado("FLD_PERCODIGO")) & "}"
        Else
            jsonSerializado = "{""status"":""error"",""message"":""Se presentó un problema en la base de datos vuelva a intentarlo mas tarde, si el problema persiste comuníquese con informática.""}"
        End If

        Return jsonSerializado

    End Function
    Public Function saveDatosDetallematerial(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim periodo As String = context.Request("periodo")
        Dim nroDespacho As String = context.Request("nroDespacho")
        Dim nroPedido As String = context.Request("nroPedido")
        Dim matCodigo As String = context.Request("codigoMaterial")
        Dim usuario As String = context.Request("nombreUsuario")
        Dim largoGridDetalles As Integer = Integer.Parse(context.Request("largoGrid"))
        Dim fechaVencimientoAnterior As String = context.Request("fechaVencimientoAnt")
        Dim loteSerie_Anterior As String = context.Request("loteSerie")
        Dim validate As Integer = 0

        For i As Integer = 0 To largoGridDetalles - 1
            Dim cantidadChanged As String = context.Request(i & "[changes][cantidad]")
            Dim loteSerieChanged As String = context.Request(i & "[changes][loteSerie]")
            Dim fechaVencimientoChanged As String = context.Request(i & "[changes][fechaVencimiento]")
            Dim cantidad As String = context.Request(i & "[cantidad]")
            Dim loteSerieAnt As String = context.Request(i & "[loteSerie]")
            Dim fechaVencimiento As String = context.Request(i & "[fechaVencimiento]")

            If cantidadChanged <> Nothing Then
                cantidad = cantidadChanged
            End If

            If loteSerieChanged = Nothing Then
                loteSerieChanged = loteSerieAnt
            End If

            If fechaVencimientoChanged <> Nothing Then
                fechaVencimiento = fechaVencimientoChanged
            End If

            validate = ControladorLogica.saveDetalleMaterialDevNPedido(nroDespacho, periodo, nroPedido, matCodigo, _
                                                                             loteSerieChanged, cantidad, fechaVencimiento, _
                                                                             Trim(usuario), loteSerieAnt, fechaVencimientoAnterior, loteSerie_Anterior)

            If (validate = 1) Then
                jsonSerializado = "{""status"":""error"",""message"":""Ocurrio un error al intentar guardar el detalle del Material, vuelva a intentarlo mas tarde. Si el problema persiste contactese con Informática.""}"
                Exit For
            Else
                jsonSerializado = "{""status"":""success""}"
            End If
        Next

        Return jsonSerializado

    End Function
    Public Function getDatosPopUpGrid(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim periodo As String = context.Request("periodo")
        Dim nroDespacho As String = context.Request("nroDespacho")
        Dim nroPedido As String = context.Request("nroPedido")
        Dim listaDespachos As List(Of Dictionary(Of String, String))
        Dim DespachosNuevos As New ListaDespachosNPedidoPopUp()

        If (periodo = "undefined" Or periodo = "") Then
            periodo = "0"
        End If
        If (nroDespacho = "undefined" Or nroDespacho = "") Then
            nroDespacho = "0"
        End If
        If (nroPedido = "undefined" Or nroPedido = "") Then
            nroPedido = "0"
        End If

        listaDespachos = ControladorLogica.getDespachosNPedidoPopUp(Integer.Parse(nroDespacho), periodo, Integer.Parse(nroPedido))

        For Each despacho As Dictionary(Of String, String) In listaDespachos

            Dim nuevoDespacho As New DespachoNPedidoPopUp(DespachosNuevos.total + 1, _
                                                     despacho("FLD_PERCODIGO"), _
                                                     despacho("FLD_PBONUMERO"), _
                                                     despacho("FLD_CMVNUMERO"), _
                                                     despacho("FLD_DESFECHA"), _
                                                     despacho("FLD_DESDESCRIPCION"), _
                                                     despacho("FLD_CMVNUMERO_DEV"), _
                                                     despacho("FLD_DEVFECHA"), _
                                                     despacho("FLD_DEVDESCRIPCION"))

            DespachosNuevos.setDespacho(nuevoDespacho)
        Next

        serializer.MaxJsonLength = 20000000
        jsonSerializado = serializer.Serialize(DespachosNuevos)

        Return jsonSerializado

    End Function
    Public Function getDetalleMaterial(ByVal context As HttpContext)
        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listaDetallesBD As New List(Of Dictionary(Of String, String))
        Dim ListaDetalleMats As New ListaDetalleMatsDevolNPedido
        Dim nroDespacho As String = context.Request("nroDespacho")
        Dim numeroPedido As String = context.Request("nroPedido")
        Dim periodo As String = context.Request("periodoBusqueda")
        Dim matCodigo As String = context.Request("codigoMaterial")
        Dim usuario As String = Trim(context.Request("nombreUsuario"))
        Dim fechaVencimientoAnterior As String = context.Request("fechaVencimientoAnt")
        Dim loteSerie_Anterior As String = context.Request("loteSerie")

        listaDetallesBD = ControladorLogica.getDetallesMaterialDevolNPedido(nroDespacho, numeroPedido, periodo, matCodigo, usuario, _
                                                                                  fechaVencimientoAnterior, loteSerie_Anterior)

        For Each detalleMat As Dictionary(Of String, String) In listaDetallesBD

            Dim detallematerial As New DetalleMaterialDevolNPedido(ListaDetalleMats.total + 1, _
                                                                    detalleMat("FLD_MATCODIGO"), _
                                                                    detalleMat("FLD_MOVCANTIDAD"), _
                                                                    detalleMat("FLD_LOTE"), _
                                                                    detalleMat("FLD_FECHAVENCIMIENTO"))
            ListaDetalleMats.setDetalleMaterial(detallematerial)

        Next

        jsonSerializado = serializer.Serialize(ListaDetalleMats)
        Return jsonSerializado

    End Function

    Public Function getDatosSelect(ByVal context As HttpContext)

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

    Public Function getDatosGrid(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim periodo As String = context.Request("periodo")
        Dim nroDespacho As Integer = Integer.Parse(context.Request("nroDespacho"))
        Dim nroPedido As Integer = Integer.Parse(context.Request("nroPedido"))
        Dim usuario As String = context.Request("nombreUsuario")
        Dim listaDespachos As List(Of Dictionary(Of String, String))
        Dim DespachosNuevos As New ListaDespachosNPedido()

        listaDespachos = ControladorLogica.getDespachosNPedido(nroDespacho, periodo, nroPedido, Trim(usuario))

        For Each despacho As Dictionary(Of String, String) In listaDespachos

            Dim nuevoDespacho As New DespachoNPedido(DespachosNuevos.total + 1, _
                                                     despacho("FLD_CMVNUMERO"), _
                                                     despacho("FLD_PBONUMERO"), _
                                                     despacho("FLD_MATCODIGO"), _
                                                     despacho("FLD_MATNOMBRE"), _
                                                     despacho("FLD_ITEDENOMINACION"), _
                                                     despacho("FLD_CANTPEDIDA"), _
                                                     despacho("FLD_CANTADEVOLVER"), _
                                                     despacho("FLD_MOVCANTIDAD"), _
                                                     despacho("FLD_PRECIOUNITARIO"), _
                                                     despacho("FLD_FECHAVENCIMIENTO"), _
                                                     despacho("FLD_LOTE"))

            DespachosNuevos.setDespacho(nuevoDespacho)
        Next

        serializer.MaxJsonLength = 20000000
        jsonSerializado = serializer.Serialize(DespachosNuevos)
        Return jsonSerializado

    End Function

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class