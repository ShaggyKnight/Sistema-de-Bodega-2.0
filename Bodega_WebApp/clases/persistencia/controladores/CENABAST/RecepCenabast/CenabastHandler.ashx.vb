Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class CenabastHandler
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("tipoBusqueda")

        Select Case cmd
            Case "cargaDatos"
                jsonSerializado = getDatosSelect(context)
            Case "busquedaMatsPopUp"
                jsonSerializado = getMaterialesRecepCenabastPopUp(context)
                'Case "busquedaDevolsPopUp"
                '    jsonSerializado = getDevolucionesDevoXUsuarioPopUp(context)
                'Case "buscaMaterialesDevolucion"
                '    jsonSerializado = getMaterialesDevolucion(context)
            Case "generaDevolucionUsuarios"
                jsonSerializado = generaRecepcionCenabast(context)
        End Select

        context.Response.Write(jsonSerializado)
    End Sub
    Public Function generaRecepcionCenabast(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        'Dim listaMateriales As New List(Of Dictionary(Of String, String))
        Dim estado As New Dictionary(Of String, String)
        'listaMateriales = serializer.Deserialize(Of List(Of Dictionary(Of String, String)))(context.Request("materiales"))
        Dim periodo As String = context.Request("formData[listaPeriodos]")
        Dim observacion As String = context.Request("formData[observacionOC]")
        Dim PrecioOC As String = context.Request("formData[PrecioOC]")
        Dim usuarioOperacion As String = context.Request("usuarioLog")
        Dim centroCosto As String = context.Request("formData[centrosCosto]")
        Dim codBodega As String = context.Request("formData[listaBodegas]")
        Dim idChileCompra As String = context.Request("formData[idChileCompra]")
        Dim nroFacturaCenabast = context.Request("formData[NroFacturaCenabast]")
        Dim nroFacturaInterna = context.Request("formData[nroFacturaInterno]")
        Dim proveedor = context.Request("formData[proveedor]")
        Dim ImpuestoOC = context.Request("formData[ImpuestoOC]")
        Dim exentoIVA = context.Request("formData[exentoIVA]")
        Dim largoGrid As Integer = Integer.Parse(context.Request("largoGridMats"))

        For i As Integer = 0 To largoGrid - 1

            Dim codMat As String = context.Request("materiales[" & i & "][matCodigo]")
            Dim cantidad As Integer = Integer.Parse(context.Request("materiales[" & i & "][cantidad]"))
            Dim loteSerie As String = context.Request("materiales[" & i & "][loteSerie]")
            Dim fechaVencimiento As String = context.Request("materiales[" & i & "][fechaVencimiento]")
            Dim precioUnitario As Double = Double.Parse(context.Request("materiales[" & i & "][precioUnitario]"))

            estado = ControladorLogica.saveMaterialesRecepCenabast(periodo, usuarioOperacion, codMat, cantidad, loteSerie, fechaVencimiento, precioUnitario)

            If (estado("ERROR") <> "0") Then
                jsonSerializado = "{""status"":""error"",""message"":""Se prudujo el siguiente error en la base de datos: " & estado("ERROR") & "vuelva a intentarlo mas tarde, si el error persiste contactese con informática.""}"
                Return jsonSerializado
            End If
        Next

        If (observacion = Nothing Or observacion = "") Then
            observacion = "SIN DESCRIPCIÓN CENABAST"
        Else
            observacion = observacion & " CENABAST"
        End If
        estado = ControladorLogica.generaRecepcionCenabast(periodo, usuarioOperacion, observacion, centroCosto, codBodega)

        If (estado("FLD_CMVNUMERO") <> "0") Then
            jsonSerializado = "{""status"":""success"",""tmvCodigo"":""" & Trim(estado("FLD_TMVCODIGO")) & """,""periodo"":""" & Trim(estado("FLD_PERCODIGO")) & """,""cmvNumero"":""" & Trim(estado("FLD_CMVNUMERO")) & """}"
        Else
            jsonSerializado = "{""status"":""error"",""message"":""Se produjo el siguiente en error en la base de datos: " & estado("ERROR") & " vuelva a intentarlo mas tarde, si el problema persiste contacte a informática.""}"
        End If

        Return jsonSerializado

    End Function
    Public Function getMaterialesRecepCenabastPopUp(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listMateriales As New List(Of Dictionary(Of String, String))
        Dim listaMaterialesCenabast As New ListaMaterialesRecepCenabast
        Dim nombreMaterial As String = context.Request("nombreMaterial")
        Dim codigoMaterial As String = context.Request("codigoMaterial")
        Dim codigoCenabast As String = context.Request("codigoCenabast")
        Dim codigoBodega As String = context.Request("codBodega")
        Dim largoGrid As Integer = Integer.Parse(context.Request("largoGrid"))
        Dim contador As Integer = 0

        listMateriales = ControladorLogica.getListaMaterialesRecepCenabast(nombreMaterial, codigoCenabast, codigoMaterial, codigoBodega)

        For Each dataMaterial As Dictionary(Of String, String) In listMateriales
            Dim Material As New MaterialRecepCenabast(listaMaterialesCenabast.total + 1, _
                                                        Trim(dataMaterial("FLD_MATCODIGO")), _
                                                       Trim(dataMaterial("FLD_MATNOMBRE")), _
                                                       Trim(dataMaterial("CODIGO_CENABAST")), _
                                                       0, _
                                                       "0", _
                                                       Trim(dataMaterial("FLD_FECHAVENCIMIENTO")), _
                                                       Double.Parse(Trim(dataMaterial("FLD_EXIPRECIOUNITARIO"))), _
                                                       Trim(dataMaterial("FLD_UMEDDESCRIPCION")), _
                                                       Trim(dataMaterial("FLD_ITECODIGO")), _
                                                       Trim(dataMaterial("FLD_ITEDENOMINACION")))
            listaMaterialesCenabast.setMaterial(Material)

        Next
        serializer.MaxJsonLength = 20000000
        jsonSerializado = serializer.Serialize(listaMaterialesCenabast)
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
        Dim listProveedores As New List(Of Dictionary(Of String, String))
        Dim ListaDeProveedores As New ListaObjetosSelectBox
        Dim tipoBusqueda As String = context.Request("indentificadorBusqeda")
        Dim establecimiento As String = context.Request("centroCosto")

        Select Case tipoBusqueda
            Case "periodos"
                listPeriodos = ControladorLogica.getListaPeriodos()

                For Each datosPeriodo As Dictionary(Of String, String) In listPeriodos
                    Dim Periodo As New ObjetoSelectBox(Trim(datosPeriodo("percodigo")), Trim(datosPeriodo("pernombre")))
                    ListaDePeriodos.setObjeto(Periodo)
                Next

                jsonSerializado = serializer.Serialize(ListaDePeriodos)
            Case "bodegas"
                listBodegas = ControladorLogica.getlistaBodegasDevUsuarios("0203")

                For Each datosBodegas As Dictionary(Of String, String) In listBodegas
                    Dim bodega As New ObjetoSelectBox(Trim(datosBodegas("BodCodigo")), Trim(datosBodegas("BodNombre")))
                    ListaDeBodegas.setObjeto(bodega)
                Next

                jsonSerializado = serializer.Serialize(ListaDeBodegas)
            Case "centrosCosto"
                listCentrosCosto = ControladorLogica.getListaCentrosCostosDevUsu(establecimiento)

                For Each datosCentrosCosto As Dictionary(Of String, String) In listCentrosCosto
                    Dim centroCosto As New ObjetoSelectBox(Trim(datosCentrosCosto("FLD_CCOCODIGO")), Trim(datosCentrosCosto("FLD_CCONOMBRE")))
                    ListaDeCentrosCosto.setObjeto(centroCosto)
                Next

                jsonSerializado = serializer.Serialize(ListaDeCentrosCosto)
            Case "Proveedores"
                listProveedores = ControladorLogica.getListaProveedores()

                For Each datoProveedores As Dictionary(Of String, String) In listProveedores
                    Dim proveedor As New ObjetoSelectBox(Trim(datoProveedores("FLD_PRORUT")), Trim(datoProveedores("PROVEEDOR")))
                    ListaDeProveedores.setObjeto(proveedor)
                Next

                jsonSerializado = serializer.Serialize(ListaDeProveedores)
        End Select


        Return jsonSerializado
    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class