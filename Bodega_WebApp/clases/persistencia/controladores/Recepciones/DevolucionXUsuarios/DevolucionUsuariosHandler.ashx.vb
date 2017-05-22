Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class DevolucionUsuariosHandler
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("tipoBusqueda")

        Select Case cmd
            Case "cargaDatos"
                'Carga datos del form.
                jsonSerializado = getDatosSelect(context)
            Case "busquedaMatsPopUp"
                ' Busqueda de materiales (no implementada).
                jsonSerializado = getMaterialesDevoXUsuarioPopUp(context)
            Case "busquedaDevolsPopUp"
                ' Entrega historial de devoluciones para grid de busqueda.
                jsonSerializado = getDevolucionesDevoXUsuarioPopUp(context)
            Case "buscaMaterialesDevolucion"
                jsonSerializado = getMaterialesDevolucion(context)
            Case "generaDevolucionUsuarios"
                ' Graba la transacción
                jsonSerializado = generaDevolucionUsuarios(context)
            Case "actualizaDevolucionUsuarios"
                ' Actualiza la observación
                jsonSerializado = ActualizaObservacionDevolucion(context)
            Case "obtieneFechaServidor"
                jsonSerializado = obtienefechaServidor(context)
        End Select

        context.Response.Write(jsonSerializado)
    End Sub
    Public Function obtienefechaServidor(ByVal context As HttpContext)
        Dim jsonSerializado As String = ""
        Dim fechaServer As String = ControladorLogica.getFechaServidor().Date.ToString()
        If (fechaServer = Nothing Or fechaServer = "") Then
            jsonSerializado = "{""status"":""error"",""message"":""se produjo un error en la base de datos, vuelva a intentarlo mas tarde""}"
        Else
            jsonSerializado = "{""status"":""success"",""fechaServer"":""" & Trim(fechaServer) & """}"
        End If
        Return jsonSerializado
    End Function
    Public Function ActualizaObservacionDevolucion(ByVal context As HttpContext)
        Dim jsonSerializado As String = ""
        Dim estado As New Dictionary(Of String, String)
        Dim periodo As String = context.Request("formData[listaPeriodos]")
        Dim cmvNumero As String = context.Request("formData[nroDevBodega]")
        Dim descripcion As String = context.Request("formData[observacionDevolucion]")


        If (descripcion = Nothing Or descripcion = "") Then
            descripcion = "SIN DESCRIPCIÓN"
        End If

        estado = ControladorPersistencia.actualizaDevolucionXNPedido(Trim(periodo), Trim(descripcion), Trim(cmvNumero))

        If (estado("ERROR") <> "0") Then
            jsonSerializado = "{""status"":""error"",""message"":""Se prudujo el siguiente error en la base de datos: " & estado("ERROR") & "vuelva a intentarlo mas tarde, si el error persiste contactese con informática.""}"

        Else
            jsonSerializado = "{""status"":""success"",""descripcion"":""" & Trim(estado("FLD_DEVDESCRIPCION")) & """}"
        End If

        Return jsonSerializado
    End Function
    Public Function generaDevolucionUsuarios(ByVal context As HttpContext)

        ' Ahora el primer llamado trae el CMVNUMERO y se lo pasa al procedimiento save.

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        'Dim listaMateriales As New List(Of Dictionary(Of String, String))
        Dim estado As New Dictionary(Of String, String)
        'listaMateriales = serializer.Deserialize(Of List(Of Dictionary(Of String, String)))(context.Request("materiales"))
        Dim nroDevolucion As String = context.Request("formData[nroDevBodega]")
        Dim codBodega As String = context.Request("formData[listaBodegas]")
        Dim observacion As String = context.Request("formData[observacionDevolucion]")
        Dim periodoDevolucion As String = context.Request("formData[listaPeriodos]")
        Dim centroCosto As String = context.Request("formData[centrosCosto]")
        Dim userName As String = context.Request("formData[usuarioDevolucion]")
        Dim largoGrid As Integer = Integer.Parse(context.Request("largoGridMats"))
        Dim usuarioOperacion As String = context.Request("usuarioLog")

        '
        Dim cmvNumeroTEMP As String

        For i As Integer = 0 To largoGrid - 1

            Dim codMat As String = context.Request("materiales[" & i & "][matCodigo]")
            Dim cantidad As Integer
            Dim loteSerie As String
            Dim fechaVencimiento As String
            'Dim cantidad As Integer = Integer.Parse(context.Request("materiales[" & i & "][cantidad]"))
            'Dim loteSerie As String = context.Request("materiales[" & i & "][loteSerie]")
            'Dim fechaVencimiento As String = context.Request("materiales[" & i & "][fechaVencimiento]")
            Dim precioUnitario As Double = Double.Parse(context.Request("materiales[" & i & "][precioUnitario]"))

            If context.Request("materiales[" & i & "][changes][cantidad]") <> Nothing Then
                cantidad = context.Request("materiales[" & i & "][changes][cantidad]")
            Else
                cantidad = context.Request("materiales[" & i & "][cantidad]")
            End If

            If context.Request("materiales[" & i & "][changes][loteSerie]") <> Nothing Then
                loteSerie = UCase(context.Request("materiales[" & i & "][changes][loteSerie]"))
            Else
                loteSerie = UCase(context.Request("materiales[" & i & "][loteSerie]"))
            End If

            If context.Request("materiales[" & i & "][changes][fechaVencimiento]") <> Nothing Then
                fechaVencimiento = context.Request("materiales[" & i & "][changes][fechaVencimiento]")
            Else
                fechaVencimiento = context.Request("materiales[" & i & "][fechaVencimiento]")
            End If

            estado = ControladorPersistencia.saveMaterialesDevolucionUsuario(periodoDevolucion, usuarioOperacion, codMat, cantidad, loteSerie, fechaVencimiento, precioUnitario)

            If (estado("ERROR") <> "0") Then
                jsonSerializado = "{""status"":""error"",""message"":""Se prudujo el siguiente error en la base de datos: " & estado("ERROR") & "vuelva a intentarlo mas tarde, si el error persiste contactese con informática.""}"
                Return jsonSerializado
            End If
        Next

        If (observacion = Nothing Or observacion = "") Then
            observacion = "SIN DESCRIPCIÓN"
        End If

        cmvNumeroTEMP = estado("FLD_CMVNUMERO")

        estado = ControladorPersistencia.generaDevolucionUsuarios(periodoDevolucion, usuarioOperacion, observacion, centroCosto, codBodega, cmvNumeroTEMP)

        If (estado("FLD_CMVNUMERO") <> "0") Then
            jsonSerializado = "{""status"":""success"",""tmvCodigo"":""" & Trim(estado("FLD_TMVCODIGO")) & """,""periodo"":""" & Trim(estado("FLD_PERCODIGO")) & """,""cmvNumero"":""" & Trim(estado("FLD_CMVNUMERO")) & """}"
        Else
            jsonSerializado = "{""status"":""error"",""message"":""Se produjo el siguiente en error en la base de datos: " & estado("ERROR") & " vuelva a intentarlo mas tarde, si el problema persiste contacte a informática.""}"
        End If

        Return jsonSerializado

    End Function
    Public Function getMaterialesDevolucion(ByVal context As HttpContext)
        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listMateriales As New List(Of Dictionary(Of String, String))
        Dim listaMaterialesDevolucion As New ListaMaterialesDevXusuarios
        Dim nroDevolucion As String = context.Request("numeroDev")
        Dim periodoDevolucion As String = context.Request("periodoDev")
        Dim userName As String = context.Request("usuario")

        listMateriales = ControladorPersistencia.getListaMaterialesDevolucion(periodoDevolucion, nroDevolucion, userName)

        For Each dataMaterial As Dictionary(Of String, String) In listMateriales
            Dim Material As New MaterialDevXUsuario(listaMaterialesDevolucion.total + 1, _
                                                   Trim(dataMaterial("FLD_MATCODIGO")), _
                                                   Trim(dataMaterial("FLD_MATNOMBRE")), _
                                                   Trim(dataMaterial("FLD_CANTADEVOLVER")), _
                                                   Trim(dataMaterial("FLD_LOTE")), _
                                                   Trim(dataMaterial("FLD_FECHAVENCIMIENTO")), _
                                                   Double.Parse(Trim(dataMaterial("FLD_PRECIOUNITARIO"))), _
                                                   Trim(dataMaterial("FLD_UMEDDESCRIPCION")), _
                                                   Trim(dataMaterial("FLD_ITECODIGO")), _
                                                   "")
            listaMaterialesDevolucion.setMaterial(Material)

        Next

        jsonSerializado = serializer.Serialize(listaMaterialesDevolucion)
        Return jsonSerializado

    End Function
    Public Function getDevolucionesDevoXUsuarioPopUp(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listDevoluciones As New List(Of Dictionary(Of String, String))
        Dim listaDevolucionesUsuario As New ListaDevolucionUsuario
        Dim percodigo As String = context.Request("percodigo")
        Dim nroPedido As String = context.Request("nroPedido")

        listDevoluciones = ControladorPersistencia.getListaDevolucionesUsuarioPopUp(Trim(percodigo), nroPedido)

        For Each dataDevolucion As Dictionary(Of String, String) In listDevoluciones

            Dim devolucion As New DevolucionUsuario(listaDevolucionesUsuario.total + 1, _
                                                   Integer.Parse(Trim(dataDevolucion("FLD_CMVNUMERO"))), _
                                                   Trim(dataDevolucion("FLD_PERCODIGO")), _
                                                   Trim(dataDevolucion("FLD_BODCODIGO")), _
                                                   Trim(dataDevolucion("FLD_USULOGIN")), _
                                                   Trim(dataDevolucion("FLD_DEVDESCRIPCION")), _
                                                   Trim(dataDevolucion("FLD_CCOCODIGO")), _
                                                   Trim(dataDevolucion("FLD_DEVFECHA")))

            listaDevolucionesUsuario.setDevolucion(devolucion)

        Next
        serializer.MaxJsonLength = 20000000
        jsonSerializado = serializer.Serialize(listaDevolucionesUsuario)
        Return jsonSerializado

    End Function
    Public Function getMaterialesDevoXUsuarioPopUp(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listMateriales As New List(Of Dictionary(Of String, String))
        Dim listaMaterialesDevolucion As New ListaMaterialesDevXusuarios
        Dim nombreMaterial As String = context.Request("nombreMaterial")
        Dim codigoMaterial As String = context.Request("codigoMaterial")
        Dim codigoBodega As String = context.Request("codBodega")
        Dim largoGrid As Integer = Integer.Parse(context.Request("largoGrid"))
        Dim contador As Integer = 0

        listMateriales = ControladorPersistencia.getListaMaterialesDevXUsuariosPUp(nombreMaterial, codigoBodega, codigoMaterial)

        For Each dataMaterial As Dictionary(Of String, String) In listMateriales
                Dim Material As New MaterialDevXUsuario(listaMaterialesDevolucion.total + 1, _
                                                       Trim(dataMaterial("FLD_MATCODIGO")), _
                                                       Trim(dataMaterial("FLD_MATNOMBRE")), _
                                                       0, _
                                                       "0", _
                                                       Trim(dataMaterial("FLD_FECHAVENCIMIENTO")), _
                                                       Double.Parse(Trim(dataMaterial("FLD_EXIPRECIOUNITARIO"))), _
                                                       Trim(dataMaterial("FLD_UMEDDESCRIPCION")), _
                                                       Trim(dataMaterial("FLD_ITECODIGO")), _
                                                       Trim(dataMaterial("FLD_ITEDENOMINACION")))
                listaMaterialesDevolucion.setMaterial(Material)

        Next
        serializer.MaxJsonLength = 20000000
        jsonSerializado = serializer.Serialize(listaMaterialesDevolucion)
        Return jsonSerializado

    End Function
    Public Function getDatosSelect(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listBodegas As New List(Of Dictionary(Of String, String))
        Dim ListaDeBodegas As New ListaObjetosSelectBox
        Dim listPeriodos As New List(Of Dictionary(Of String, String))
        Dim ListaDePeriodos As New ListaObjetosSelectBox
        Dim listCentrosCosto As New List(Of Dictionary(Of String, String))
        Dim ListaDeCentrosCosto As New ListaObjetosSelectBox
        Dim tipoBusqueda As String = context.Request("indentificadorBusqeda")
        Dim CentroCostos As String = context.Request("centroCosto")

        Select Case tipoBusqueda
            Case "periodos"
                listPeriodos = ControladorPersistencia.getListaPeriodos()

                For Each datosPeriodo As Dictionary(Of String, String) In listPeriodos
                    Dim Periodo As New ObjetoSelectBox(Trim(datosPeriodo("percodigo")), Trim(datosPeriodo("pernombre")))
                    ListaDePeriodos.setObjeto(Periodo)
                Next

                jsonSerializado = serializer.Serialize(ListaDePeriodos)
            Case "bodegas"
                Dim establecimiento = ControladorPersistencia.getEstablecimiento(CentroCostos)
                listBodegas = ControladorPersistencia.getlistaBodegasDevUsuarios(establecimiento)

                For Each datosBodegas As Dictionary(Of String, String) In listBodegas
                    Dim bodega As New ObjetoSelectBox(Trim(datosBodegas("BodCodigo")), Trim(datosBodegas("BodNombre")))
                    ListaDeBodegas.setObjeto(bodega)
                Next

                jsonSerializado = serializer.Serialize(ListaDeBodegas)
            Case "centrosCosto"
                listCentrosCosto = ControladorPersistencia.getListaCentrosCostosDevUsu(CentroCostos)

                For Each datosCentrosCosto As Dictionary(Of String, String) In listCentrosCosto
                    Dim centroCosto As New ObjetoSelectBox(Trim(datosCentrosCosto("FLD_CCOCODIGO")), Trim(datosCentrosCosto("FLD_CCONOMBRE")))
                    ListaDeCentrosCosto.setObjeto(centroCosto)
                Next

                jsonSerializado = serializer.Serialize(ListaDeCentrosCosto)
        End Select
        

        Return jsonSerializado
    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class