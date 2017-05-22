Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class GeneraInforme
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("cmd")

        Select Case cmd
            Case "generaInforme"
                jsonSerializado = generaInformeDesdeProveedores(context)
            Case "RPTInforme"
                jsonSerializado = CloneInforme(context)
            Case "New_RPT_NroFacXOC"
                'Nuevo generea informe de Ordenes de compra por numero factura'
                jsonSerializado = generaInformeParaNroFactura(context)
            Case "AjusteMaterial"
                jsonSerializado = generaInformeAjuteMaterial(context)
            Case "INSCantidadQR"
                jsonSerializado = INSCantidadQR(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function generaInformeDesdeProveedores(ByVal context As HttpContext)

        Dim NTransaccion As String = context.Request("formData[nroRecepcion]")
        Dim periodo As String = context.Request("percodioRecep")
        Dim codTransaccion As String = context.Request("tmvCodigo")
        Dim bodega As String = context.Request("bodegaNombre")

        Dim descripcion As String = context.Request("formData[observacionRecp]")
        Dim fechaMovimieno As String = context.Request("formData[fechaRecepcion]")
        Dim proveedor As String = context.Request("formData[proveedor]")
        Dim ordenCompra As String = context.Request("formData[numeroOC]")
        Dim ordenCompraEstado As String = context.Request("formData[estado]")

        Dim numeroDocumento As String = context.Request("formData[nroDocumento]")
        Dim Institucion As String = ""
        Dim centroCosto As String = ""
        Dim tipoDocumento As String = context.Request("formData[tipo_documento]")
        Dim tituloMenu As String = "RECEPCION DESDE PROVEEDORES"

        Dim descuento As String = context.Request("dataRecep[descuento]")
        Dim impuesto As String = context.Request("dataRecep[impuesto]")
        Dim diferenciaPeso As String = context.Request("dataRecep[difpeso]")
        Dim usuario As UsuarioLogeado = context.Session("usuarioLogeado")

        Dim largoGrid As Integer = Integer.Parse(context.Request("largoGrid"))
        fechaMovimieno = fechaMovimieno.Substring(0, 10)

        Dim jsonSerializado As String = ""
        Dim respuesta As New Dictionary(Of String, String)

        Dim rowNumber As Integer = 1

        For i As Integer = 0 To largoGrid - 1

            'Dim Linea As String = (i + 1).ToString()
            Dim codMaterial As String = context.Request("materiales[" & i & "][recid]")
            Dim nombreMaterial As String = context.Request("materiales[" & i & "][nombreMaterial]")
            Dim CodItem As String = context.Request("materiales[" & i & "][iteCodigo]")
            Dim cantMaterial As String = context.Request("materiales[" & i & "][cantidad]")

            If (cantMaterial = 0) Then
                cantMaterial = context.Request("materiales[" & i & "][recepcionado]")
                String.Format("{0:#}", cantMaterial)
            End If
            Dim total As Integer = CInt(cantMaterial)

            Dim precioMaterial As String = context.Request("materiales[" & i & "][valor]")
            precioMaterial = precioMaterial.Substring(1)

            ' OJO con el centro costo lo utilice para guardar el rut del usuario q llama al reporte para asi poder obtener su firma. para la NC (se comento el rut para ver la diferencia entre el que es solicitado en recaudación  y en bodega)
            'numeroDocumento, Institucion, Trim(usuario.rut), tipoDocumento, tituloMenu,'

            If (total > 0) Then
                respuesta = ControladorPersistencia.CloneInforme(NTransaccion, periodo, codTransaccion, rowNumber, codMaterial,
                                                             Trim(nombreMaterial), Trim(CodItem), cantMaterial, precioMaterial, bodega,
                                                             Trim(descripcion), fechaMovimieno, proveedor, ordenCompra, Trim(ordenCompraEstado),
                                                             numeroDocumento, Institucion, "", tipoDocumento, tituloMenu,
                                                             descuento, impuesto, diferenciaPeso, Trim(usuario.username))
                If (respuesta("ERROR") <> "0") Then
                    jsonSerializado = "{""status"":""error"",""message"":""Se prudujo el siguiente error en la base de datos: " & respuesta("ERROR") & "vuelva a intentarlo mas tarde, si el error persiste contactese con informática.""}"
                    Return jsonSerializado
                End If

                rowNumber = rowNumber + 1
            End If
        Next

        If (respuesta("FLD_CMVNUMERO") <> "0") Then
            jsonSerializado = "{""status"":""success"",""tmvCodigo"":""" & Trim(respuesta("FLD_TMVCODIGO")) & """,""periodo"":""" & Trim(respuesta("FLD_PERCODIGO")) & """,""cmvNumero"":""" & Trim(respuesta("FLD_CMVNUMERO")) & """}"
        Else
            jsonSerializado = "{""status"":""error"",""message"":""Se produjo el siguiente en error en la base de datos: " & respuesta("ERROR") & " vuelva a intentarlo mas tarde, si el problema persiste contacte a informática.""}"
        End If

        Return jsonSerializado

    End Function
    Public Function CloneInforme(ByVal context As HttpContext)

        Dim NTransaccion As String = context.Request("NTransaccion")
        Dim periodo As String = context.Request("periodo")
        Dim codTransaccion As String = context.Request("codTransaccion")
        Dim Linea As String = context.Request("Linea")
        Dim codMaterial As String = context.Request("codMaterial")

        Dim nombreMaterial As String = context.Request("nombreMaterial")
        Dim CodItem As String = context.Request("CodItem")
        Dim cantMaterial As String = context.Request("cantMaterial")
        Dim precioMaterial As String = context.Request("precioMaterial")
        Dim bodega As String = context.Request("bodega")

        Dim descripcion As String = context.Request("descripcion")
        Dim fechaMovimieno As String = context.Request("fechaMovimieno")
        Dim proveedor As String = context.Request("proveedor")
        Dim ordenCompra As String = context.Request("ordenCompra")
        Dim ordenCompraEstado As String = context.Request("ordenCompraEstado")

        Dim numeroDocumento As String = context.Request("numeroDocumento")
        Dim Institucion As String = context.Request("Institucion")
        Dim centroCosto As String = context.Request("centroCosto")
        Dim tipoDocumento As String = context.Request("tipoDocumento")
        Dim tituloMenu As String = context.Request("tituloMenu")

        Dim descuento As String = context.Request("descuento")
        Dim impuesto As String = context.Request("impuesto")
        Dim diferenciaPeso As String = context.Request("diferenciaPeso")
        'Dim usuario As UsuarioLogeado = context.Session("usuarioLogeado")
        Dim usuario As String = context.Request("usuario")

        Dim jsonSerializado As String = ""
        Dim respuesta As New Dictionary(Of String, String)

        If (usuario = "undefined" Or usuario = "") Then
            Dim usuarioSesion As UsuarioLogeado = context.Session("usuarioLogeado")
            usuario = usuarioSesion.username.Trim()
        End If

        respuesta = ControladorPersistencia.CloneInforme(NTransaccion, periodo, codTransaccion, Linea, codMaterial,
                                                         nombreMaterial, CodItem, cantMaterial, precioMaterial, bodega,
                                                         descripcion, fechaMovimieno, proveedor, ordenCompra, ordenCompraEstado,
                                                         numeroDocumento, Institucion, centroCosto, tipoDocumento, tituloMenu,
                                                         descuento, impuesto, diferenciaPeso, usuario)

        If (String.Equals(respuesta("ERROR"), "0")) Then
            jsonSerializado = "{""status"":""success"",""tmvCodigo"":""" & Trim(respuesta("FLD_TMVCODIGO")) & """,""periodo"":""" & Trim(respuesta("FLD_PERCODIGO")) & """,""cmvNumero"":""" & Trim(respuesta("FLD_CMVNUMERO")) & """, ""usuario"":""" & Trim(respuesta("FLD_USUARIO")) & """}"
        Else
            jsonSerializado = "{""status"":""error"",""message"":""Se produjo el siguiente en error en la base de datos: " & respuesta("ERROR") & " vuelva a intentarlo mas tarde, si el problema persiste contacte a informática.""}"
        End If

        Return jsonSerializado

    End Function
    Public Function generaInformeParaNroFactura(ByVal context As HttpContext)

        Dim periodo As String = context.Request("periodo")
        Dim NroOC As String = context.Request("NroOC")
        Dim NroRecep As String = context.Request("NroRecep")
        Dim jsonSerializado As String = ""
        Dim respuesta As New Dictionary(Of String, String)

        respuesta = ControladorPersistencia.saveData_RPT_NroFacturaOC(periodo, NroOC, NroRecep)

        If (String.Equals(respuesta("ERROR"), "0")) Then
            jsonSerializado = "{""status"":""success"",""tmvCodigo"":""" & Trim(respuesta("FLD_TMVCODIGO")) & """,""periodo"":""" & Trim(respuesta("FLD_PERCODIGO")) & """,""cmvNumero"":""" & Trim(respuesta("FLD_CMVNUMERO")) & """}"
        Else
            jsonSerializado = "{""status"":""error"",""message"":""Se produjo el siguiente en error en la base de datos: " & respuesta("ERROR") & " vuelva a intentarlo mas tarde, si el problema persiste contacte a informática.""}"
        End If

        Return jsonSerializado

    End Function
    Public Function generaInformeAjuteMaterial(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim estado As Integer = 0

        'Form
        'Dim NumAjuste As String = context.Request("dataFormAjuste[numAjuste]")
        Dim NumAjuste As String = 300
        Dim Bodega As String = context.Request("dataFormAjuste[Nombre_Bodega]")
        Dim Periodo As String = context.Request("dataFormAjuste[anioDonacion]")
        Dim descripcion As String = UCase(context.Request("dataFormAjuste[descripcion]"))
        Dim titulo As String = "AJUSTE DE MATERIALES"
        Dim tmvCodigo As String = "6"
        Dim usuarioSesion As UsuarioLogeado = context.Session("usuarioLogeado")
        Dim usuario As String = usuarioSesion.username.Trim()

        'Del grid
        Dim RecordsLength = context.Request("largoGrid")
        Dim cantRecepcionada As Integer
        Dim movimientoTemp As Integer
        Dim movFinal As Integer
        Dim z As Integer = 1

        Dim Linea As String
        Dim codMaterial As String
        Dim cantMaterial As String
        Dim NSerie As String
        Dim fechaMovimieno As String
        Dim observacion As String


        'estado = ControladorPersistencia.limpiarTemporalDetalles(NroOCompra, codMaterial)

        For i As Integer = 0 To RecordsLength - 1

            Dim detalle As Dictionary(Of String, String) = New Dictionary(Of String, String)

            'detalle.Add("codMaterial", context.Request("GridAjuste[" & i & "][codMaterial]"))
            'detalle.Add("periodo", context.Request("GridAjuste[" & i & "][periodo]"))

            'detalle.Add("linea", "" & z & "")
            Linea = z.ToString()
            codMaterial = context.Request("GridAjuste[" & i & "][codMaterial]")

            'Cant Existencia
            If context.Request("GridAjuste[" & i & "][changes][existencia]") <> Nothing Then
                cantRecepcionada = context.Request("GridAjuste[" & i & "][cantEntrada]")
                movimientoTemp = Integer.Parse(context.Request("GridAjuste[" & i & "][changes][existencia]"))
                If (movimientoTemp < cantRecepcionada) Then
                    movFinal = movimientoTemp - cantRecepcionada
                Else
                    movFinal = cantRecepcionada - movimientoTemp
                End If
                cantMaterial = movFinal.ToString()
                'detalle.Add("cantidad", movFinal)
            Else
                'detalle.Add("cantidad", context.Request("GridAjuste[" & i & "][existencia]"))
                'cantMaterial = context.Request("GridAjuste[" & i & "][existencia]")
                cantMaterial = 0
            End If

            'Lote o Serie
            If context.Request("GridAjuste[" & i & "][changes][loteSerie2]") <> Nothing Then
                'detalle.Add("nroLote", UCase(context.Request("GridAjuste[" & i & "][changes][loteSerie2]")))
                NSerie = UCase(context.Request("GridAjuste[" & i & "][changes][loteSerie2]"))
            Else
                'detalle.Add("nroLote", UCase(context.Request("GridAjuste[" & i & "][loteSerie2]")))
                'NSerie = UCase(context.Request("GridAjuste[" & i & "][loteSerie2]"))
                NSerie = ""
            End If

            'Fecha Vto
            If context.Request("GridAjuste[" & i & "][changes][fechaVencimiento]") <> Nothing Then
                'detalle.Add("fechaVencimiento", context.Request("GridAjuste[" & i & "][changes][fechaVencimiento]"))
                fechaMovimieno = UCase(context.Request("GridAjuste[" & i & "][changes][fechaVencimiento]"))
            Else
                'detalle.Add("fechaVencimiento", context.Request("GridAjuste[" & i & "][fechaVencimiento]"))
                'fechaMovimieno = UCase(context.Request("GridAjuste[" & i & "][fechaVencimiento]"))
                fechaMovimieno = "01/01/1990"
            End If

            ' Si existio algun cambio saca el detalle y envia a guardar el movimiento
            If context.Request("GridAjuste[" & i & "][changes][descripcion]") <> Nothing Then
                observacion = context.Request("GridAjuste[" & i & "][changes][descripcion]")
                estado = ControladorPersistencia.CloneInforme_Ajuste(NumAjuste, Periodo, tmvCodigo, Linea, codMaterial,
                                                         NSerie, "", cantMaterial, Bodega, observacion, fechaMovimieno, descripcion, 0, "",
                                                         0, "", "", "", titulo, 0, 0, 0, usuario)
                z = z + 1
            End If
        Next

        If estado = 1 Then
            Return "{""status"":""error"",""message"": ""Ocurrio un error en la Base de datos, intente de nuevo mas tarde. Si el problema persiste comuniquese con informática""}"
        Else
            Return "{""status"":""success"", ""usuario"":""" & usuario & """}"
        End If

    End Function
    Public Function INSCantidadQR(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim estado As New Dictionary(Of String, String)

        'Del Form
        Dim Periodo As String = context.Request("Periodo")
        Dim CodMov As String = context.Request("CodMov")
        Dim NumMov As String = context.Request("NumMov")

        'Del grid
        Dim RecordsLength = context.Request("largoGrid")
        Dim CodMaterial As String
        Dim NSerie As String
        Dim CantImprimir As String

        For i As Integer = 0 To RecordsLength - 1

            CodMaterial = UCase(context.Request("GridQR[" & i & "][FLD_MATCODIGO]"))
            NSerie = UCase(context.Request("GridQR[" & i & "][FLD_NERIE]"))

            If context.Request("GridQR[" & i & "][changes][FLD_CANTIDAD]") <> Nothing Then
                CantImprimir = UCase(context.Request("GridQR[" & i & "][changes][FLD_CANTIDAD]"))
            Else
                CantImprimir = 0
            End If

            estado = ControladorPersistencia.Insertar_CantidadQR(CodMaterial, NSerie, CantImprimir, Periodo, NumMov, CodMov)

        Next

        If (estado("FLD_CMVNUMERO") <> "0") Then
            jsonSerializado = "{""status"":""success"",""cmvNumero"":" + Trim(estado("FLD_CMVNUMERO")) + "}"
        Else
            jsonSerializado = "{""status"":""error"",""message"":""Se presentó un problema en la base de datos vuelva a intentarlo mas tarde, si el problema persiste comuníquese con informática.""}"
        End If

        Return jsonSerializado
    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class