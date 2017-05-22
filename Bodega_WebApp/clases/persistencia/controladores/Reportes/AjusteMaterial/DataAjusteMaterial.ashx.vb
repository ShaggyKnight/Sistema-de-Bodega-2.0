Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class DataAjusteMaterial
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim tipoBusqueda As String = context.Request("tipoBusqueda")

        Select Case tipoBusqueda

            Case "busquedaDetalleMaterial"
                ' llama al detalle de materiales
                jsonSerializado = busquedaDetalleMaterial(context)

            Case "TipoAjuste"
                jsonSerializado = MotivoAjuste(context)

            Case "create-records"
                ' Funcion principal del save grobal.
                jsonSerializado = crearMovimientoAjuste(context)

            Case "createDetalle"
                jsonSerializado = crearDetalleMovAjuste(context)

            Case "totalRealExistencia"
                jsonSerializado = getValorExistenciaReal(context)

            Case "DataAjExist"
                jsonSerializado = DataAjusteExist(context)

        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function busquedaDetalleMaterial(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer

        Dim Bodega As String = context.Request("CodBodega")
        Dim codMaterial As String = context.Request("CodMaterial")

        Dim retorno As New ListaMaterialesAjuste()

        Dim json As New JavaScriptSerializer
        retorno = ControladorPersistencia.getInfoDetalleMaterialesAjuste(Bodega, codMaterial)
        'Dim respuesta As String
        'respuesta = json.Serialize(retorno)
        'context.Response.Write(respuesta)

        jsonserializado = serializer.Serialize(retorno)
        Return jsonserializado
    End Function
    Public Function MotivoAjuste(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer

        Dim retorno As New ListaMotivoAjuste()

        Dim items As New Dictionary(Of String, String)

        Dim json As New JavaScriptSerializer
        retorno = ControladorPersistencia.getMotivoAjuste()

        jsonserializado = serializer.Serialize(retorno)
        Return jsonserializado
    End Function
    'metodo para generar recepcion
    Public Function crearMovimientoAjuste(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim estado As New Dictionary(Of String, String)

        ' Graba Movimiento
        Dim usuario As UsuarioLogeado = context.Session("usuarioLogeado")
        Dim Periodo As String = context.Request("dataFormAjuste[anioDonacion]")
        Dim Bodega As String = context.Request("dataFormAjuste[Nombre_Bodega]")
        Dim descripcion As String = UCase(context.Request("dataFormAjuste[descripcion]"))

        estado = ControladorPersistencia.saveMovimientoAjuste(usuario.username, Periodo, Bodega, descripcion)

        If (estado("FLD_CMVNUMERO") <> "0") Then
            jsonSerializado = "{""status"":""success"",""cmvNumero"":" + Trim(estado("FLD_CMVNUMERO")) + "}"
            'jsonSerializado = "{""status"":""succes"",""cmvNumero"":" & Trim(estado("FLD_CMVNUMERO")) & ",""tmvCodigo"":" & Trim(estado("FLD_TMVCODIGO")) & ",""periodo"":" & Trim(estado("FLD_PERCODIGO")) & "}"
        Else
            jsonSerializado = "{""status"":""error"",""message"":""Se presentó un problema en la base de datos vuelva a intentarlo mas tarde, si el problema persiste comuníquese con informática.""}"
        End If

        Return jsonSerializado
    End Function
    'metodo para generar recepcion
    Public Function crearDetalleMovAjuste(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim estado As New Dictionary(Of String, String)

        ' Graba Movimiento
        Dim NumAjuste As String = context.Request("dataFormAjuste[numAjuste]")
        'Dim NumAjuste As String = 1
        Dim Periodo As String = context.Request("PeriodoGrid")
        Dim Bodega As String = context.Request("dataFormAjuste[Nombre_Bodega]")

        Dim codMaterial As String = UCase(context.Request("codMaterial"))
        Dim cantEntrada As String = UCase(context.Request("cantEntrada"))             '@FLD_CANTPEDIDA
        Dim loteReal As String = UCase(context.Request("loteReal"))                   '@FLD_NSERIE

        Dim detalle As String = UCase(context.Request("detalle"))                     '@FLD_OBSERVACION
        Dim existChange As String = UCase(context.Request("existenciaChange"))        '@FLD_MOVCANTIDAD
        Dim loteChange As String = UCase(context.Request("loteChange"))               '@FLD_NSERIE_NEW
        Dim fechaVtoChange As String = UCase(context.Request("fechaVto"))

        'Cambio en el existencia,lote, fechaVto
        If String.Equals(existChange, "") = False And String.Equals(loteChange, "") = False And String.Equals(fechaVtoChange, "") Then
            estado = ControladorPersistencia.saveDetalleMovimientoAjuste(1, NumAjuste, Periodo, Bodega, codMaterial, cantEntrada, loteReal, detalle, existChange, loteChange, fechaVtoChange)
            ' 
        ElseIf String.Equals(existChange, "") = False And String.Equals(fechaVtoChange, "") = False Then
            estado = ControladorPersistencia.saveDetalleMovimientoAjuste(2, NumAjuste, Periodo, Bodega, codMaterial, cantEntrada, loteReal, detalle, existChange, loteChange, fechaVtoChange)
        ElseIf String.Equals(existChange, "") = False And String.Equals(loteChange, "") = False Then
            '
            estado = ControladorPersistencia.saveDetalleMovimientoAjuste(3, NumAjuste, Periodo, Bodega, codMaterial, cantEntrada, loteReal, detalle, existChange, loteChange, "01/01/1900")
        ElseIf String.Equals(existChange, "") = False Then
            estado = ControladorPersistencia.saveDetalleMovimientoAjuste(4, NumAjuste, Periodo, Bodega, codMaterial, cantEntrada, loteReal, detalle, existChange, loteChange, "01/01/1900")
        ElseIf String.Equals(loteChange, "") = False Then
            estado = ControladorPersistencia.saveDetalleMovimientoAjuste(5, NumAjuste, Periodo, Bodega, codMaterial, cantEntrada, loteReal, detalle, 0, loteChange, "01/01/1900")
        ElseIf String.Equals(fechaVtoChange, "") = False Then
            estado = ControladorPersistencia.saveDetalleMovimientoAjuste(6, NumAjuste, Periodo, Bodega, codMaterial, cantEntrada, loteReal, detalle, 0, loteChange, fechaVtoChange)
        End If

        If (estado("FLD_CMVNUMERO") <> "0") Then
            jsonSerializado = "{""status"":""success"",""cmvNumero"":" + Trim(estado("FLD_CMVNUMERO")) + "}"
        Else
            jsonSerializado = "{""status"":""error"",""message"":""Se presentó un problema en la base de datos vuelva a intentarlo mas tarde, si el problema persiste comuníquese con informática.""}"
        End If

        Return jsonSerializado
    End Function
    Public Function getValorExistenciaReal(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer

        Dim Bodega As String = context.Request("bodega")
        Dim codMaterial As String = context.Request("material")

        Dim retorno As New Dictionary(Of String, String)
        retorno = ControladorPersistencia.getValorExistenciaReal(Bodega, codMaterial)

        jsonserializado = serializer.Serialize(retorno)
        Return jsonserializado
    End Function
    ' Para Ajuste Existencias
    Public Function DataAjusteExist(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer

        Dim NroAjuste As String = context.Request("NroAjuste")
        Dim Periodo As String = context.Request("Periodo")

        Dim retorno As New ListaMovAjustes()

        Dim json As New JavaScriptSerializer
        retorno = ControladorPersistencia.getInfoDataAjusteExistencia(NroAjuste, Periodo)

        jsonserializado = serializer.Serialize(retorno)
        Return jsonserializado
    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class