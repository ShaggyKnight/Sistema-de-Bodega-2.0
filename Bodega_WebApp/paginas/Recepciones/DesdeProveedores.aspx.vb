Public Class DesdeProveedores
    Inherits System.Web.UI.Page
    Implements System.Web.IHttpHandler

    Dim listaMateriales As New Dictionary(Of String, IngresoProducto)
    Dim listaDatosOC As New Dictionary(Of String, String)
    Dim ordenDeCompra As New OrdenDeCompra()
    Dim bodegas As New List(Of KeyValuePair(Of String, String))
    Protected bodegaValida As Boolean


    Protected Overrides Sub OnInit(ByVal e As System.EventArgs)
        bodegaValida = True
        Dim tiposDocumento As New List(Of KeyValuePair(Of String, String))
        Dim usuario As UsuarioLogeado = Session("usuarioLogeado")
        Dim datosBodegas As New List(Of Dictionary(Of String, String))
        Dim establecimiento As String = ControladorPresentacion.getestablecimiento(usuario.centroDeCosto)

        tiposDocumento.Add(New KeyValuePair(Of String, String)("FACTURA", "FACTURA"))
        tiposDocumento.Add(New KeyValuePair(Of String, String)("BOLETA", "BOLETA"))
        tiposDocumento.Add(New KeyValuePair(Of String, String)("GUIA", "GUIA"))
        tiposDocumento.Add(New KeyValuePair(Of String, String)("OTRO", "OTRO"))

        datosBodegas = ControladorLogica.getListaBodegas(establecimiento.Substring(0, establecimiento.IndexOf("-") - 1))

        For Each bodega As Dictionary(Of String, String) In datosBodegas

            bodegas.Add(New KeyValuePair(Of String, String)(bodega("codigo"), bodega("codigo") + " - " + bodega("nombre")))

        Next

        selecBodegas.DataSource = bodegas
        selecBodegas.DataValueField = "Key"
        selecBodegas.DataTextField = "Value"
        selecBodegas.DataBind()

        tipoDocumento.DataSource = tiposDocumento
        tipoDocumento.DataValueField = "Key"
        tipoDocumento.DataTextField = "Value"
        tipoDocumento.DataBind()

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsPostBack Then

            listaDatosOC = Session("datosOC")
            listaMateriales = Session("listaDeMateriales")
            ordenDeCompra = Session("ordenDeCompra")

            Dim factores As String() = Context.Request.Form.GetValues("factor")

        End If
    End Sub
    Protected Sub buscarMats_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles buscarMats.Click

        Dim usuario As UsuarioLogeado = Session("usuarioLogeado")
        bodegaValida = ControladorPresentacion.validarBodega(nroOC.Value.ToString, usuario)
        Dim nroOCompra = nroOC.Value.ToString
        cargarInformacion(usuario)

        If (bodegaValida) Then
            datsEstado.Style.Add("display", "inline-block")
            contenedorGrilla.Style.Add("display", "inline-block")
            footIzqInterno.Style.Add("display", "inline-block")

        Else
            datsEstado.Style.Add("display", "none")
            contenedorGrilla.Style.Add("display", "none")
            footIzqInterno.Style.Add("display", "none")
        End If

    End Sub

    Protected Sub cargarInformacion(ByVal usuario As UsuarioLogeado)

        Dim fechaServer = ControladorPresentacion.getFechaServidor()
        Dim contenidoTablaMateriales As List(Of Dictionary(Of String, String))
        contenidoTablaMateriales = ControladorPresentacion.getDatosMaterial(nroOC.Value.ToString)
        listaMateriales = New Dictionary(Of String, IngresoProducto)
        listaDatosOC = ControladorPresentacion.getDatosOrdenCompra(nroOC.Value.ToString, usuario)

        ordenDeCompra = New OrdenDeCompra(listaDatosOC("FLD_OCONUMERO"), listaDatosOC("FLD_PERCODIGO"), listaDatosOC("FLD_PROVEEDOR"), listaDatosOC("FLD_OCOESTADO"), listaDatosOC("FLD_OCPRECIO"), listaDatosOC("FLD_BODCODIGO"), listaDatosOC("FLD_BODNOMBRES"), listaDatosOC("FLD_OCODESCRIPCION"))



        Dim bodega As String = ordenDeCompra.codigoBodega
        Dim tipoDoc As String = listaDatosOC("tipoDocumento")
        Dim formatToMoney As Double

        fechaServidor.Text = fechaServer.Date
        estadoOC.Text = ordenDeCompra.estadoOC

        If (Trim(ordenDeCompra.estadoOC) = Trim("RECEPCIONADA TOTALMENTE") Or Trim(ordenDeCompra.estadoOC) = Trim("RECEPCIONADA PARCIALMENTE")) Then

            selecBodegas.Enabled = False
            tipoDocumento.Enabled = False
            nroDocumento.Enabled = False
            nroDocumento.Text = listaDatosOC("nroDocumento")
            nroRecepcion.Text = listaDatosOC("numeroRecepcion")
            tipoDocumento.SelectedValue = Trim(tipoDoc)

            If (Trim(ordenDeCompra.estadoOC) = Trim("RECEPCIONADA PARCIALMENTE")) Then

                totalAcumulado.Text = listaDatosOC("totalRecepcionado")

            End If
        Else
            nroDocumento.Text = "----"
            nroRecepcion.Text = "----"
            totalAcumulado.Text = "$0000"
            selecBodegas.Enabled = True
            tipoDocumento.Enabled = True
            nroDocumento.Enabled = True
        End If

        selecBodegas.SelectedValue = bodega
        proveedor.Text = ordenDeCompra.rutProveedor
        observacionDoc.Text = ordenDeCompra.descripcion

        If Double.TryParse(ordenDeCompra.precio, formatToMoney) Then
            precioOC.Text = formatToMoney.ToString("$#,###")
        End If

        For Each datosMaterial As Dictionary(Of String, String) In contenidoTablaMateriales
            Dim valor As String = "0"
            Dim total As String = "0"

            Dim valorNum As String = datosMaterial("Fld_PPU_Neto")

            If Double.TryParse(valorNum, formatToMoney) Then
                valor = formatToMoney.ToString("$#,###")
            End If


            Dim material As New IngresoProducto(datosMaterial("Fld_MatCodigo"), datosMaterial("Fld_MatNombre"), datosMaterial("Fld_UnidMedida"), datosMaterial("Fld_Cantidad"), datosMaterial("Fld_UnidMedida"), "0", valor, datosMaterial("Fld_Recibido"), "0", total, datosMaterial("Fld_IteCodigo"))
            Dim listaDetallesMats = ControladorPresentacion.getDetallesMateriales(ordenDeCompra.numeroOC, material.codigo)

            If (material.aRecibir = material.cantidad) Then

                material.recepcionado = "Total"

            End If
            Dim contCantidad As Integer
            For Each detalleMat As Dictionary(Of String, String) In listaDetallesMats

                material.AgregarDetalle(detalleMat("FLD_CANTIDAD"), detalleMat("FLD_LOTE"), detalleMat("FLD_SERIE"), detalleMat("FLD_FECHAVENCIMIENTO"))
                contCantidad += Integer.Parse(detalleMat("FLD_CANTIDAD"))
            Next

            material.cantidad = contCantidad
            If (contCantidad > 0) Then
                total = Replace(material.valor, "$", "")
                While total.IndexOf(".") <> -1
                    total = Replace(total, ".", "")
                End While

                total = contCantidad * Integer.Parse(total) * 1.1899999999999999

                If Double.TryParse(total, formatToMoney) Then
                    total = formatToMoney.ToString("$#,###")
                End If

                material.total = total

            End If
            listaMateriales.Add(material.codigo, material)
        Next

        Session("listaDeMateriales") = listaMateriales
        Session("ordenDeCompra") = ordenDeCompra

        Dim newTable As New DataTable

        newTable.Columns.Add("Codigo")
        newTable.Columns.Add("NombreMaterial")
        newTable.Columns.Add("UnidMedida")
        newTable.Columns.Add("aRecibir")
        newTable.Columns.Add("Cantidad")
        newTable.Columns.Add("Valor")
        newTable.Columns.Add("Recepcionado")
        newTable.Columns.Add("Total")

        For i = 0 To listaMateriales.Count - 1
            newTable.Rows.Add(listaMateriales.Values(i).codigo, listaMateriales.Values(i).nombre, listaMateriales.Values(i).unidMedida, listaMateriales.Values(i).aRecibir, listaMateriales.Values(i).cantidad, listaMateriales.Values(i).valor, listaMateriales.Values(i).recepcionado, listaMateriales.Values(i).total)
        Next

        DataGrid1.DataSource = newTable
        DataGrid1.DataBind()

    End Sub
    Protected Sub calculaTotalAcumulado()

        Dim formatToMoney As Double
        Dim acumulado As Integer = 0

        For i = 0 To listaMateriales.Count - 1
            acumulado = acumulado + ((Integer.Parse(listaMateriales.Values(i).valor) * Integer.Parse(listaMateriales.Values(i).cantidad)) / Integer.Parse(listaMateriales.Values(i).aRecibir))
        Next

        If Double.TryParse(acumulado.ToString, formatToMoney) Then
            totalAcumulado.Text = formatToMoney.ToString("$#,###.00")
        End If

    End Sub

    Protected Sub guardarRecepcion_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles guardarRecepcion.Click


        Dim netoTotal As Integer
        Dim valor As String
        Dim comparar As String = "----"
        Dim recepcion As New Recepcion()

        For i = 0 To listaMateriales.Count - 1
            valor = listaMateriales.Values(i).valor
            valor = Replace(valor, "$", "")
            While valor.IndexOf(".") <> -1
                valor = Replace(valor, ".", "")
            End While
            netoTotal += Integer.Parse(valor) * listaMateriales.Values(i).cantidad
        Next

        netoTotal = netoTotal * 1.19

        If (String.Compare(nroRecepcion.Text, comparar)) Then

            Dim periodo As String
            Dim tipoMovimiento As String
            Dim comMovimiento As String
            Dim nroDoc As String
            Dim tipoDocRecepcion As String
            Dim obsRecepcion As String
            Dim difPeso As String

            obsRecepcion = observacionOC.Text
            periodo = ordenDeCompra.periodo
            tipoMovimiento = 1
            comMovimiento = nroRecepcion.Text
            nroDoc = nroDocumento.Text
            tipoDocRecepcion = tipoDocumento.SelectedValue
            difPeso = difPesoFoot.Text
            difPeso = Replace(difPeso, "$", "")
            While difPeso.IndexOf(".") <> -1
                difPeso = Replace(difPeso, ".", "")
            End While

            recepcion = New Recepcion(periodo, tipoMovimiento, comMovimiento, nroDoc, tipoDocRecepcion, obsRecepcion, netoTotal, difPeso)
            ControladorLogica.updateRecepcion(recepcion)
        Else
            
            Dim periodo As String
            Dim tipoMovimiento As String
            Dim comMovimiento As String
            Dim nroDoc As String
            Dim tipoDocRecepcion As String
            Dim obsRecepcion As String
            Dim difPeso As String
            Dim usulogin As String
            Dim contador As Integer

            Dim user As UsuarioLogeado = Session("usuarioLogeado")
            usulogin = user.username
            obsRecepcion = observacionOC.Text
            periodo = ordenDeCompra.periodo
            tipoMovimiento = 1
            comMovimiento = nroRecepcion.Text
            nroDoc = nroDocumento.Text
            tipoDocRecepcion = tipoDocumento.SelectedValue
            difPeso = difPesoFoot.Text
            difPeso = Replace(difPeso, "$", "")
            While difPeso.IndexOf(".") <> -1
                difPeso = Replace(difPeso, ".", "")
            End While

            'Dim validate = ControladorLogica.crearRecepcion(periodo, tipoMovimiento, usulogin)

            recepcion = New Recepcion(periodo, tipoMovimiento, comMovimiento, nroDoc, tipoDocRecepcion, obsRecepcion, netoTotal, difPeso)

            For contador = 0 To listaMateriales.Count
                Dim codigo = DataGrid1.Items(contador).Cells(0).Text()
            Next

            'Dim intRow As Integer = 0
            'Dim strName As String = ""
            'Dim intRows As Integer = DataGrid1.Items.Count - 1
            'Dim gridItem As DataGridItem
            'Dim gridCant As Integer
            'Dim codigoItem As String

            'For intRow = 0 To intRows
            '    gridItem = DataGrid1.Items(intRow)
            '    strName = gridItem.Cells(0).Text().Trim()
            '    gridCant = Integer.Parse(gridItem.Cells(5).Text().Trim())

            'Next

        End If
    End Sub
End Class