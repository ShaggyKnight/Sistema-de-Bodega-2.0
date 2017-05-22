Public Class cenabast
    Inherits System.Web.UI.Page

    Dim contenidoLista As New List(Of KeyValuePair(Of Integer, String))
    Dim listaMateriales As New Dictionary(Of String, IngresoProducto)

    Protected Overrides Sub OnInit(ByVal e As System.EventArgs)

        'If IsNothing(Session("listaDeMateriales")) Then
        '    For i = 1 To 3
        '        Dim Material As New IngresoProducto(i.ToString() + i.ToString() + i.ToString() + "-0006", "Material Prueba " + i.ToString(), i.ToString() + i.ToString(), i.ToString(), "0", "1" + i.ToString() + "000", "0000", "", Integer.Parse("1" + i.ToString() + "000") * Integer.Parse(i.ToString() + i.ToString()))
        '        Dim detalleMaterial As New IngresoProductoDetalle()
        '        Material.AgregarDetalle(detalleMaterial)
        '        listaMateriales.Add(i.ToString() + i.ToString() + i.ToString() + "-0006", Material)
        '    Next

        '    Session("listaDeMateriales") = listaMateriales
        'Else
        '    listaMateriales = Session("listaDeMateriales")
        'End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'If Not IsPostBack Then

        '    Dim newTable As New DataTable

        '    newTable.Columns.Add("Codigo")
        '    newTable.Columns.Add("NombreMaterial")
        '    newTable.Columns.Add("aRecibir")
        '    newTable.Columns.Add("Cantidad")
        '    newTable.Columns.Add("Valor")
        '    newTable.Columns.Add("Total")

        '    contenidoLista.Add(New KeyValuePair(Of Integer, String)(1, "Total"))
        '    contenidoLista.Add(New KeyValuePair(Of Integer, String)(2, "Parcial"))

        '    For i = 0 To listaMateriales.Count - 1
        '        newTable.Rows.Add(listaMateriales.Values(i).codigo, listaMateriales.Values(i).nombre, listaMateriales.Values(i).aRecibir, listaMateriales.Values(i).cantidad, listaMateriales.Values(i).valor, listaMateriales.Values(i).total)
        '    Next

        '    DataGrid1.DataSource = newTable
        '    DataGrid1.DataBind()

        'Else
        '    Dim factores As String() = Context.Request.Form.GetValues("factor")
        'End If
    End Sub
    Protected Sub DataGrid1_ItemCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles DataGrid1.ItemCreated
        'If Not (e.Item.ItemType = ListItemType.Footer Or e.Item.ItemType = ListItemType.Header) Then

        '    Dim list As DropDownList = DirectCast(e.Item.FindControl("DropDownList2"), DropDownList)

        '    list.DataSource = contenidoLista
        '    list.DataValueField = "Key"
        '    list.DataTextField = "Value"
        '    list.DataBind()
        'End If
    End Sub
    ' ''' <summary>
    ' ''' Crea contenedor de producto
    ' ''' </summary>
    ' ''' <param name="padre">Panel padre en el que se alojara el contenedor</param>
    ' ''' <param name="identificador">Número entero </param>
    ' ''' <remarks></remarks>
    'Public Sub crearContenedorMaterial(ByRef padre As Panel, ByVal identificador As Integer)
    '    crearTituloMateriales(padre)
    '    Dim contenedorPrincipal As New Panel

    '    contenedorPrincipal.CssClass = "contenedorPrincipal"
    '    contenedorPrincipal.ID = "informacionProducto" & identificador
    '    crearContenidoMateriales(contenedorPrincipal, identificador)
    '    crearTituloLineaDetalle(contenedorPrincipal)
    '    crearLineaDetalle(contenedorPrincipal, identificador, 1)
    '    crearLineaAgregarDetalle(contenedorPrincipal, identificador)
    '    padre.Controls.Add(contenedorPrincipal)
    '    padre.Controls.Add(New LiteralControl("<div id=""finalContenedorCompra""></div>"))
    'End Sub

    'Public Sub crearTituloMateriales(ByRef Panel1 As Panel)
    '    Dim contenedorTitulos As New Panel
    '    Dim lineaTitulos As New Panel
    '    Dim tituloCodigo As New Panel
    '    Dim tituloNombre As New Panel
    '    Dim tituloARecibir As New Panel
    '    Dim tituloFactor As New Panel
    '    Dim tituloCantidad As New Panel
    '    Dim tituloValor As New Panel
    '    Dim tituloRecepcionPorFactura As New Panel
    '    Dim tituloRecepcionado As New Panel
    '    Dim tituloTotal As New Panel

    '    contenedorTitulos.CssClass = "contenedorTitulos"
    '    lineaTitulos.CssClass = "contenedorCompra"
    '    tituloCodigo.CssClass = "tituloCompra primeraColumna"
    '    tituloNombre.CssClass = "tituloCompra segundaColumna"
    '    tituloARecibir.CssClass = "tituloCompra terceraColumna"
    '    tituloFactor.CssClass = "tituloCompra cuartaColumna"
    '    tituloCantidad.CssClass = "tituloCompra quintaColumna"
    '    tituloValor.CssClass = "tituloCompra sextaColumna"
    '    tituloRecepcionPorFactura.CssClass = "tituloCompra septimaColumna"
    '    tituloRecepcionado.CssClass = "tituloCompra octavaColumna"
    '    tituloTotal.CssClass = "ultimoTituloCompra novenaColumna"

    '    contenedorTitulos.Controls.Add(lineaTitulos)
    '    lineaTitulos.Controls.Add(tituloCodigo)
    '    lineaTitulos.Controls.Add(tituloNombre)
    '    lineaTitulos.Controls.Add(tituloARecibir)
    '    lineaTitulos.Controls.Add(tituloFactor)
    '    lineaTitulos.Controls.Add(tituloCantidad)
    '    lineaTitulos.Controls.Add(tituloValor)
    '    lineaTitulos.Controls.Add(tituloRecepcionPorFactura)
    '    lineaTitulos.Controls.Add(tituloRecepcionado)
    '    lineaTitulos.Controls.Add(tituloTotal)

    '    Dim contenedorTituloConSangria As New Panel
    '    contenedorTituloConSangria.CssClass = "sangriaVertical"
    '    contenedorTituloConSangria.Controls.Add(New LiteralControl("Código"))
    '    tituloCodigo.Controls.Add(contenedorTituloConSangria)

    '    tituloNombre.Controls.Add(New LiteralControl("Nombre<br />Material"))

    '    contenedorTituloConSangria = New Panel
    '    contenedorTituloConSangria.CssClass = "sangriaVertical"
    '    contenedorTituloConSangria.Controls.Add(New LiteralControl("A Recibir"))
    '    tituloARecibir.Controls.Add(contenedorTituloConSangria)

    '    contenedorTituloConSangria = New Panel
    '    contenedorTituloConSangria.CssClass = "sangriaVertical"
    '    contenedorTituloConSangria.Controls.Add(New LiteralControl("Factor"))
    '    tituloFactor.Controls.Add(contenedorTituloConSangria)

    '    contenedorTituloConSangria = New Panel
    '    contenedorTituloConSangria.CssClass = "sangriaVertical"
    '    contenedorTituloConSangria.Controls.Add(New LiteralControl("Cantidad"))
    '    tituloCantidad.Controls.Add(contenedorTituloConSangria)

    '    contenedorTituloConSangria = New Panel
    '    contenedorTituloConSangria.CssClass = "sangriaVertical"
    '    contenedorTituloConSangria.Controls.Add(New LiteralControl("Valor"))
    '    tituloValor.Controls.Add(contenedorTituloConSangria)

    '    tituloRecepcionPorFactura.Controls.Add(New LiteralControl("Recep<br />x Fact"))

    '    contenedorTituloConSangria = New Panel
    '    contenedorTituloConSangria.CssClass = "sangriaVertical"
    '    contenedorTituloConSangria.Controls.Add(New LiteralControl("Recepcionado"))
    '    tituloRecepcionado.Controls.Add(contenedorTituloConSangria)

    '    contenedorTituloConSangria = New Panel
    '    contenedorTituloConSangria.CssClass = "sangriaVertical"
    '    contenedorTituloConSangria.Controls.Add(New LiteralControl("Total"))
    '    tituloTotal.Controls.Add(contenedorTituloConSangria)

    '    lineaTitulos.Controls.Add(New LiteralControl("<div style=""clear: both;""></div>"))
    '    Panel1.Controls.Add(contenedorTitulos)
    'End Sub

    'Public Sub crearContenidoMateriales(ByRef Panel1 As Panel, ByVal identificador As Integer)
    '    Dim lineaContenido As New Panel
    '    Dim codigo As New Panel
    '    Dim nombre As New Panel
    '    Dim aRecibir As New Panel
    '    Dim factor As New Panel
    '    Dim cantidad As New Panel
    '    Dim valor As New Panel
    '    Dim recepcionPorFactura As New Panel
    '    Dim recepcionado As New Panel
    '    Dim total As New Panel

    '    lineaContenido.CssClass = "contenedorContenido"
    '    codigo.CssClass = "textoCompra primeraColumna"
    '    nombre.CssClass = "textoCompra segundaColumna"
    '    aRecibir.CssClass = "textoCompra terceraColumna"
    '    factor.CssClass = "textoCompra cuartaColumna"
    '    cantidad.CssClass = "textoCompra quintaColumna"
    '    valor.CssClass = "textoCompra sextaColumna"
    '    recepcionPorFactura.CssClass = "textoCompra septimaColumna"
    '    recepcionado.CssClass = "textoCompra octavaColumna"
    '    total.CssClass = "textoCompra novenaColumna"

    '    lineaContenido.CssClass = "contenedorContenido"
    '    codigo.ID = "contenedorCodigo" & identificador
    '    nombre.ID = "contenedorNombre" & identificador
    '    aRecibir.ID = "contenedorARecibir" & identificador
    '    factor.ID = "contenedorFactor" & identificador
    '    cantidad.ID = "contenedorCantidad" & identificador
    '    valor.ID = "contenedorValor" & identificador
    '    recepcionPorFactura.ID = "contenedorRecepcionPorFactura" & identificador
    '    recepcionado.ID = "contenedorRecepcionado" & identificador
    '    total.ID = "contenedorTotal" & identificador

    '    lineaContenido.Controls.Add(codigo)
    '    lineaContenido.Controls.Add(nombre)
    '    lineaContenido.Controls.Add(aRecibir)
    '    lineaContenido.Controls.Add(factor)
    '    lineaContenido.Controls.Add(cantidad)
    '    lineaContenido.Controls.Add(valor)
    '    lineaContenido.Controls.Add(recepcionPorFactura)
    '    lineaContenido.Controls.Add(recepcionado)
    '    lineaContenido.Controls.Add(total)

    '    codigo.Controls.Add(New LiteralControl("000-0000"))

    '    nombre.Controls.Add(New LiteralControl("Material a recepcionar"))

    '    'Dim input As New TextBox
    '    'input.ID = "aRecibir1"
    '    'input.Attributes.Add("placeholder", "Ingrese Cantidad")
    '    'aRecibir.Controls.Add(input)
    '    aRecibir.Controls.Add(New LiteralControl("0"))

    '    'Input = New TextBox
    '    Dim input As New TextBox
    '    input.ID = "factor" & identificador
    '    input.Attributes.Add("placeholder", "Ingrese Cantidad")
    '    factor.Controls.Add(input)

    '    cantidad.Controls.Add(New LiteralControl("0"))

    '    input = New TextBox
    '    input.ID = "valor" & identificador
    '    input.Attributes.Add("placeholder", "Ingrese Cantidad")
    '    valor.Controls.Add(input)

    '    input = New TextBox
    '    input.ID = "recepcionPorFactura" & identificador
    '    input.Attributes.Add("placeholder", "Ingrese valor")
    '    recepcionPorFactura.Controls.Add(input)

    '    Dim inputSelect As New DropDownList
    '    inputSelect.Items.Add(New ListItem("tipo recepción", ""))
    '    inputSelect.ID = "recepcionado" & identificador
    '    recepcionado.Controls.Add(inputSelect)

    '    total.Controls.Add(New LiteralControl("0"))

    '    lineaContenido.Controls.Add(New LiteralControl("<div style=""clear: both;""></div>"))
    '    Panel1.Controls.Add(lineaContenido)
    'End Sub

    'Private Sub crearTituloLineaDetalle(ByRef Panel1 As Panel)
    '    Dim lineaDetalle As Panel = New Panel()
    '    Dim contenedorDetalle As Panel = New Panel()
    '    Dim sangriaDetalle As Panel = New Panel()
    '    lineaDetalle.CssClass = "lineaTituloDetalleDeCompra"
    '    sangriaDetalle.CssClass = "sangriaTituloDetalleCompra"
    '    contenedorDetalle.CssClass = "contenedorTituloDetalleCompra"
    '    lineaDetalle.Controls.Add(sangriaDetalle)
    '    lineaDetalle.Controls.Add(contenedorDetalle)

    '    Dim tituloCantidad As Panel = New Panel
    '    Dim tituloBoxLote As Panel = New Panel
    '    Dim tituloBoxSerie As Panel = New Panel
    '    Dim tituloVencimiento As Panel = New Panel

    '    tituloCantidad.Controls.Add(New LiteralControl("Cantidad"))
    '    tituloBoxLote.Controls.Add(New LiteralControl("Nº de Lote"))
    '    tituloBoxSerie.Controls.Add(New LiteralControl("Nº de Serie"))
    '    tituloVencimiento.Controls.Add(New LiteralControl("Fecha de Vencimiento"))

    '    tituloCantidad.CssClass = "tituloDetalleCompraCantidad"
    '    tituloBoxLote.CssClass = "tituloDetalleCompraLote"
    '    tituloBoxSerie.CssClass = "tituloDetalleCompraSerie"
    '    tituloVencimiento.CssClass = "tituloDetalleCompraVencimiento"

    '    contenedorDetalle.Controls.Add(tituloCantidad)
    '    contenedorDetalle.Controls.Add(tituloBoxLote)
    '    contenedorDetalle.Controls.Add(tituloBoxSerie)
    '    contenedorDetalle.Controls.Add(tituloVencimiento)

    '    contenedorDetalle.Controls.Add(New LiteralControl("<div style=""clear: both;""></div>"))
    '    Panel1.Controls.Add(lineaDetalle)
    '    Panel1.Controls.Add(New LiteralControl("<div style=""clear: both;""></div>"))
    'End Sub

    'Private Sub crearLineaDetalle(ByRef Panel1 As Panel, ByVal identificadorPadre As Integer, ByVal identificador As Integer)

    '    Dim lineaDetalle As Panel = New Panel()
    '    Dim contenedorDetalle As Panel = New Panel()
    '    Dim sangriaDetalle As Panel = New Panel()
    '    lineaDetalle.CssClass = "lineaDetalleDeCompra"
    '    sangriaDetalle.CssClass = "sangriaDetalleCompra"
    '    contenedorDetalle.CssClass = "contenedorDetalleCompra"
    '    lineaDetalle.Controls.Add(sangriaDetalle)
    '    lineaDetalle.Controls.Add(contenedorDetalle)

    '    lineaDetalle.ID = "lineaDetalle" & identificadorPadre & "." & identificador
    '    contenedorDetalle.ID = "contenedorDetalle" & identificadorPadre & "." & identificador

    '    Dim contenedorTextBoxCantidad As Panel = New Panel
    '    Dim contenedorTextBoxLote As Panel = New Panel
    '    Dim contenedorTextBoxSerie As Panel = New Panel
    '    Dim contenedorTextBoxVencimiento As Panel = New Panel
    '    Dim textBoxCantidad As TextBox = New TextBox
    '    Dim textBoxLote As TextBox = New TextBox
    '    Dim textBoxSerie As TextBox = New TextBox
    '    Dim textBoxVencimiento As TextBox = New TextBox
    '    textBoxCantidad.ID = "cantidad" & identificadorPadre & "." & identificador
    '    textBoxLote.ID = "lote" & identificadorPadre & "." & identificador
    '    textBoxSerie.ID = "serie" & identificadorPadre & "." & identificador
    '    textBoxVencimiento.ID = "vencimiento" & identificadorPadre & "." & identificador

    '    textBoxCantidad.Attributes.Add("placeholder", "Ingrese Cantidad")
    '    textBoxLote.Attributes.Add("placeholder", "Ingrese Lote")
    '    textBoxSerie.Attributes.Add("placeholder", "Ingrese Serie")
    '    textBoxVencimiento.Attributes.Add("placeholder", "Ingrese Vencimiento")

    '    contenedorTextBoxCantidad.ID = "contenedorCantidad" & identificadorPadre & "." & identificador
    '    contenedorTextBoxLote.ID = "contenedorLote" & identificadorPadre & "." & identificador
    '    contenedorTextBoxSerie.ID = "contenedorSerie" & identificadorPadre & "." & identificador
    '    contenedorTextBoxVencimiento.ID = "contenedorVencimiento" & identificadorPadre & "." & identificador

    '    contenedorTextBoxCantidad.Controls.Add(textBoxCantidad)
    '    contenedorTextBoxLote.Controls.Add(textBoxLote)
    '    contenedorTextBoxSerie.Controls.Add(textBoxSerie)
    '    contenedorTextBoxVencimiento.Controls.Add(textBoxVencimiento)

    '    contenedorTextBoxCantidad.CssClass = "detalleCompraCantidad"
    '    contenedorTextBoxLote.CssClass = "detalleCompraLote"
    '    contenedorTextBoxSerie.CssClass = "detalleCompraSerie"
    '    contenedorTextBoxVencimiento.CssClass = "detalleCompraVencimiento"

    '    contenedorDetalle.Controls.Add(contenedorTextBoxCantidad)
    '    contenedorDetalle.Controls.Add(contenedorTextBoxLote)
    '    contenedorDetalle.Controls.Add(contenedorTextBoxSerie)
    '    contenedorDetalle.Controls.Add(contenedorTextBoxVencimiento)

    '    contenedorDetalle.Controls.Add(New LiteralControl("<div style=""clear: both;""></div>"))
    '    Panel1.Controls.Add(lineaDetalle)
    '    Panel1.Controls.Add(New LiteralControl("<div style=""clear: both;""></div>"))
    'End Sub

    'Private Sub crearLineaAgregarDetalle(ByRef Panel1 As Panel, ByVal identificadorPadre As Integer)

    '    Dim lineaDetalle As Panel = New Panel()
    '    Dim contenedorDetalle As Panel = New Panel()
    '    Dim sangriaDetalle As Panel = New Panel()
    '    lineaDetalle.CssClass = "lineaDetalleDeCompra"
    '    sangriaDetalle.CssClass = "sangriaDetalleCompra"
    '    contenedorDetalle.CssClass = "contenedorDetalleCompra"
    '    lineaDetalle.Controls.Add(sangriaDetalle)
    '    lineaDetalle.Controls.Add(contenedorDetalle)

    '    Dim btnMas As New Button
    '    btnMas.CssClass = "botonMas"
    '    btnMas.CommandArgument = identificadorPadre
    '    btnMas.ID = "btnMas" & identificadorPadre
    '    AddHandler btnMas.Command, AddressOf Me.agregarCampo
    '    sangriaDetalle.Controls.Add(btnMas)

    '    contenedorDetalle.Controls.Add(New LiteralControl("<div style=""clear: both;""></div>"))
    '    Panel1.Controls.Add(lineaDetalle)
    '    Panel1.Controls.Add(New LiteralControl("<div style=""clear: both;""></div>"))
    'End Sub

    'Public Sub agregarCampo(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.CommandEventArgs)
    '    Dim listaIngresos As List(Of IngresoProducto) = ControladorPresentacion.GetEstructuraIngresoFrom(Panel1)
    'End Sub

End Class