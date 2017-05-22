Imports System.Web
Imports System.Web.Services
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization
Imports System.Linq

Public Class getMateriales
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim cmd As String = context.Request("cmd")
        Dim isReload As Integer = Integer.Parse(context.Request("reload"))
        Dim jsonSerializado As String = "{""status"": ""error"", ""text"":""Se produjo un error en la obtencion de los datos, vuelva a intentarlo mas Tarde. Si el problema persiste comuniquese con informática.""}"

        Select Case cmd
            Case "get-records"
                If isReload = 0 Then
                    jsonSerializado = getRecords(context)
                Else
                    'Si es 1 recupera lo recien guardado del detalle material.
                    jsonSerializado = getRecordsReload(context)
                End If
            Case "update-factorFactura"
                jsonSerializado = updateFactorFactura(context)
            Case "update-records"
                jsonSerializado = updateRecords(context)
            Case "create-records"
                ' Funcion principal del save grobal.
                jsonSerializado = crearRecepcion(context)
            Case "mat-Movimiento"
                jsonSerializado = getMaterialesXNumRecepcion(context)

        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function updateFactorFactura(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim idOC As String = context.Request("idoc")
        Dim matCodigo As String = context.Request("0[matCodigo]")
        Dim factor As String = context.Request("1[factor]")
        Dim factura As String = context.Request("2[factura]")
        Dim estado As Integer = 0

        estado = ControladorPersistencia.updateFactorFacturaMaterial(idOC, matCodigo, factor, factura)

        If estado = 0 Then
            jsonSerializado = "{""status"": ""success""}"
        Else
            jsonSerializado = "{""status"":""error"", ""message"":""Se presento un problema en la base de datos vuelva a interntarlo mas tarde, si el problema persiste comuniquese con informática""}"
        End If

        Return jsonSerializado

    End Function
    'Metodo que obtiene los datos de los materiales para una orden de compra especifica en primera instancia
    Public Function getRecords(ByVal context As HttpContext)

        Dim Records As New ListaMaterial("success", "0")
        Dim s As New JavaScriptSerializer()
        Dim idOC As String = context.Request("idoc")
        Dim estadoIva As Integer = context.Request("snIva")
        Dim periodo As String = context.Request("periodoOC")
        Dim usuario As String = context.Request("userName")
        Dim searchField As String = ""
        Dim searchValue As String = ""
        Dim listaMats As List(Of Material) = New List(Of Material)
        Dim LocalList As List(Of String) = New List(Of String)
        Dim listaDatosMats As List(Of Dictionary(Of String, String))
        Dim jsonSerializado As String

        listaDatosMats = ControladorPersistencia.getDatosMaterial(idOC, periodo, usuario)

        For Each mat As Dictionary(Of String, String) In listaDatosMats

            Dim total As Double = 0.0
            Dim precioUnitario As String
            Dim cantidadPendiente As Integer

            cantidadPendiente = Double.Parse(mat("Fld_Cantidad")) - Double.Parse(mat("Fld_Entregado"))

            precioUnitario = mat("Fld_PPU_Neto").ToString
            total = Double.Parse(mat("Fld_Total").ToString)

            Dim material As New Material(Trim(mat("Fld_MatCodigo")), _
                                         mat("Fld_MatNombre"), _
                                         mat("Fld_UnidMedida"), _
                                         cantidadPendiente.ToString(), _
                                         mat("Fld_Factor"), _
                                         "0", _
                                         "$" + precioUnitario, _
                                         mat("Fld_IteCodigo"), _
                                         "0", _
                                         mat("Fld_Entregado"), _
                                         "$" + total.ToString)

            If Trim(mat("Fld_MatCodigo")) = "error" Then
                jsonSerializado = "{""status"":""error"",""message"":""Ocurrio un error en la base de datos, " + mat("Fld_MatNombre") + ".""}"
                Return jsonSerializado
            End If

            Records.setRecord(material)
            Records.total += 1

        Next

        jsonSerializado = s.Serialize(Records)
        Return jsonSerializado

    End Function
    'metodo que actualiza los datos de una recepcion realizada.
    Public Function updateRecords(ByVal context As HttpContext)

        Dim estado As Integer = 0
        Dim serializer As New JavaScriptSerializer
        Dim jsonSerializado As String = ""
        Dim tipoMovimiento As Integer = 1
        Dim usuLogin As String = context.Request("usuario")
        Dim materialesLength As Integer = context.Request("largoGrid")
        Dim estadoOrdenCompra As String = context.Request("1[dataOrdenC][estado]")
        Dim nroDocumento As String = context.Request("1[dataOrdenC][nroDocumento]")
        Dim comMovimiento As String = context.Request("1[dataOrdenC][nroRecepcion]")
        Dim tipoDocRecepcion As String = context.Request("1[dataOrdenC][tipo_documento]")
        Dim obsRecepcion As String = context.Request("1[dataOrdenC][observacionRecp]")
        Dim precioNetoRecep As String = context.Request("2[dataRecep][precioNeto]")
        Dim difPeso As String = context.Request("2[dataRecep][difpeso]")

        Dim periodo As String = ControladorPersistencia.getFechaServidor().Year

        Dim recepcion As New Recepcion(periodo, tipoMovimiento, comMovimiento, nroDocumento, tipoDocRecepcion, obsRecepcion, precioNetoRecep, difPeso)
        estado = ControladorPersistencia.updateRecepcion(recepcion)

        If estado = 1 Then
            jsonSerializado = "{""status"":""error"",""message"":""Ocurrio un error en la base de datos vualva a intentarlo mas tarde, si el problema persiste comuniquese con informática.""}"
        Else
            jsonSerializado = "{""status"":""success""}"
        End If

        Return jsonSerializado
    End Function
    'metodo para generar recepcion
    Public Function crearRecepcion(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim estado As New Dictionary(Of String, String)
        Dim tipoMovimiento As Integer = 1
        Dim usuLogin As String = context.Request("usuario")
        Dim numeroOC As String = context.Request("numeroOC")
        Dim fechaServer As String = ControladorPersistencia.getFechaServidor().Date
        Dim codigoBodega As String = context.Request("dataOrdenC[bodegaRecepcion]")
        Dim periodoOC As String = context.Request("dataOrdenC[periodo]")
        Dim nroDocumento As String = context.Request("dataOrdenC[nroDocumento]")
        Dim tipoDocRecepcion As String = context.Request("dataOrdenC[tipo_documento]")
        Dim obsRecepcion As String = UCase(context.Request("dataOrdenC[observacionRecp]"))

        Dim precioNetoRecep As String = context.Request("precioNetoTemp")
        Dim descuento As String = context.Request("descuentoTemp")
        Dim ivaRecep As String = context.Request("ivaTemp")
        Dim precioRecep As String = context.Request("totalRecepTemp")
        'Dim obsRecepcion As String = UCase(context.Request("totalOCTemp"))          ' no se solicita

        'Dim descuento As String = context.Request("dataRecep[descuento]")
        'Dim descuento2 As String = context.Request("dataOrdenC[valorAjuste]")  'Nunca supe porque desde "dataRecep[descuento]" no entrega el valor.
        Dim impuestoRecep As String = context.Request("dataRecep[impuesto]")
        Dim difPeso As String = context.Request("dataRecep[difpeso]")

        estado = ControladorPersistencia.crearRecepcion(Trim(numeroOC), periodoOC, tipoMovimiento, Trim(usuLogin), codigoBodega,
                                                         periodoOC, precioRecep, nroDocumento, tipoDocRecepcion, obsRecepcion,
                                                         precioNetoRecep, ivaRecep, descuento, impuestoRecep, difPeso)

        ' Metodo antiguo falto el descuento
        'Dim recepcion As New Recepcion(Trim(periodo), tipoMovimiento, 0, Trim(codigoBodega), Trim(fechaServer), Trim(periodoOC), Trim(precioRecep), Trim(nroDocumento), Trim(tipoDocRecepcion), Trim(obsRecepcion), Trim(precioNetoRecep), Trim(ivaRecep), Trim(impuestoRecep), Trim(difPeso))
        'estado = ControladorPersistencia.crearRecepcion(recepcion, Trim(usuLogin), Trim(numeroOC))

        If (estado("FLD_CMVNUMERO") <> "0") Then
            jsonSerializado = "{""status"":""succes"",""cmvNumero"":" & Trim(estado("FLD_CMVNUMERO")) & ",""tmvCodigo"":" & Trim(estado("FLD_TMVCODIGO")) & ",""periodo"":" & Trim(estado("FLD_PERCODIGO")) & "}"
        Else
            jsonSerializado = "{""status"":""error"",""message"":""Se presentó un problema en la base de datos vuelva a intentarlo mas tarde, si el problema persiste comuníquese con informática.""}"
        End If

        Return jsonSerializado
    End Function
    'metodo que obtiene los datos de los materiales para una orden de compra especifica siempre que 
    'sea un reload o un filtrado de los mismos
    Public Function getRecordsReload(ByVal context As HttpContext)

        Dim Records As New ListaMaterial("sucess", "0")
        Dim s As New JavaScriptSerializer()
        Dim idOC As String = context.Request("idoc")
        Dim estadoIva As Integer = context.Request("snIva")
        Dim searchField As String = ""
        Dim searchValue As String = ""
        Dim listaMats As List(Of Material) = New List(Of Material)
        Dim LocalList As List(Of String) = New List(Of String)
        Dim listaDatosMats As List(Of Dictionary(Of String, String))

        listaDatosMats = ControladorPersistencia.getDatosMaterialesTemporal(idOC)

        For Each mat As Dictionary(Of String, String) In listaDatosMats

            Dim total As Double = 0.0
            Dim precioUnitario As String

            If estadoIva = 1 Then

                precioUnitario = mat("Fld_PrecioUnitario").ToString
                total = Math.Round(Double.Parse(mat("Fld_Total").ToString), 1, MidpointRounding.AwayFromZero)

            Else

                precioUnitario = mat("Fld_PPU_Neto").ToString
                total = Math.Round((Double.Parse(mat("Fld_Total").ToString) / 1.19), 1, MidpointRounding.AwayFromZero)

            End If

            Dim material As New Material(Trim(mat("Fld_MatCodigo")), _
                                         mat("Fld_MatNombre"), _
                                         mat("Fld_UnidMedida"), _
                                         mat("Fld_Cantidad"), _
                                         mat("Fld_Factor"), _
                                         mat("Fld_Cantidad_Temporal"), _
                                         "$" + precioUnitario, _
                                         mat("Fld_IteCodigo"), _
                                         mat("Fld_RecepcionFactura"), _
                                         mat("Fld_Entregado"), _
                                         "$" + total.ToString)

            Records.setRecord(material)
            Records.total += 1

        Next

        If (context.Request("search[0][field]") <> Nothing) Then

            searchField = context.Request("search[0][field]")
            searchValue = context.Request("search[0][value]")

            If (searchField.Equals("recid")) Then

                For Each mat As Material In Records.records
                    If (mat.recid.Contains(searchValue) = True) Then
                        listaMats.Add(mat)
                    End If
                Next

            ElseIf (searchField.Equals("nombreMaterial")) Then

                For Each mat As Material In Records.records
                    If (mat.nombreMaterial.ToUpper.Contains(searchValue.ToUpper) = True) Then
                        listaMats.Add(mat)
                    End If
                Next

            ElseIf (searchField.Equals("cantidad")) Then

                For Each mat As Material In Records.records
                    If (mat.cantidad.Contains(searchValue) = True) Then
                        listaMats.Add(mat)
                    End If
                Next

            End If

            Records.setListaRecords(listaMats)
            Records.total = listaMats.Count

            Dim jsonSerializado As String = s.Serialize(Records)
            Return jsonSerializado

        Else

            Dim jsonSerializado As String = s.Serialize(Records)
            Return jsonSerializado

        End If

    End Function
    'Obtiene la lista de solo matetriales que fueron recepcionados
    Public Function getMaterialesXNumRecepcion(ByVal context As HttpContext)

        Dim nroOC As String = context.Request("numRecepcion")
        Dim periodo As String = context.Request("periodo")

        Dim json As New JavaScriptSerializer
        Dim retorno As ListaMaterialRecepcion
        retorno = ControladorPersistencia.getMaterialesXBusRecep("1", nroOC, periodo)
        Dim respuesta As String
        respuesta = json.Serialize(retorno)
        'context.Response.Write(respuesta)

        Return respuesta
    End Function
    
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class