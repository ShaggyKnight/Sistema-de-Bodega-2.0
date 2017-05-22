Public Class OrdenCompra
    Public numeroOC As String
    Public proveedor As String
    Public estado As String
    Public precio As String
    Public codigoBodega As String
    Public nombreBodega As String
    Public descripcion As String
    Public nroRecepcion As String
    Public tipo_documento As String
    Public nroDocumento As String
    Public totalRecepcionado As String
    Public periodo As String
    Public observacionRecp As String
    Public impuesto As String
    Public precioNeto As String
    Public totalRecepcion As String
    Public ivaTotal As String
    Public totalOCompra As String
    Public difpeso As String
    Public chileCompra As String
    Public fechaRecepcion As String
    Public nroNotaCredito As String
    Public descuento As String

    Public Sub New(ByVal nroOC As String, _
                   ByVal proveedor As String, _
                   ByVal periodo As String, _
                   ByVal estado As String, _
                   ByVal precio As String, _
                   ByVal codigoBod As String, _
                   ByVal nombreBodega As String, _
                   ByVal descripcion As String, _
                   ByVal nroRecepcion As String, _
                   ByVal tipoDocumento As String, _
                   ByVal nroDocumento As String, _
                   ByVal totalRecepcion As String, _
                   ByVal obsRecepcion As String, _
                   ByVal impuesto As String, _
                   ByVal difPeso As String, _
                   ByVal chileCompra As String, _
                   ByVal fechaRecepcion As String, _
                   ByVal nroNotaCredito As String, _
                   ByVal descuento As String)

        Me.numeroOC = nroOC
        Me.proveedor = proveedor
        Me.periodo = periodo
        Me.estado = estado
        Me.precio = Math.Round((Double.Parse(precio) / 1.19), 2).ToString
        Me.codigoBodega = codigoBod
        Me.nombreBodega = nombreBodega
        Me.descripcion = descripcion
        Me.nroRecepcion = nroRecepcion
        Me.tipo_documento = tipoDocumento
        Me.nroDocumento = nroDocumento
        Me.totalRecepcionado = totalRecepcion
        Me.observacionRecp = obsRecepcion
        Me.impuesto = impuesto
        Me.precioNeto = Math.Round((Double.Parse(totalRecepcion) / 1.19), 2).ToString
        Me.ivaTotal = Math.Round((Double.Parse(totalRecepcion) / 1.19) * 0.19, 2).ToString
        Me.totalRecepcion = totalRecepcion
        Me.totalOCompra = precio
        Me.difpeso = difPeso
        Me.chileCompra = chileCompra
        Me.fechaRecepcion = fechaRecepcion
        Me.nroNotaCredito = nroNotaCredito
        Me.descuento = descuento
    End Sub
    'Public Sub New(ByVal precio As String, _
    '               ByVal descuento As String)
    '    Me.numeroOC = ""
    '    Me.proveedor = ""
    '    Me.periodo = ""
    '    Me.estado = ""
    '    Me.precio = ""
    '    Me.codigoBodega = ""
    '    Me.nombreBodega = ""
    '    Me.descripcion = ""
    '    Me.nroRecepcion = ""
    '    Me.tipo_documento = ""
    '    Me.nroDocumento = ""
    '    Me.totalRecepcionado = ""
    '    Me.observacionRecp = ""
    '    Me.descuento = descuento
    '    Me.impuesto = "0"
    '    Me.precioNeto = "0"
    '    Me.ivaTotal = "0"
    '    Me.totalRecepcion = "0"
    '    Me.totalOCompra = precio
    '    Me.difpeso = "0"
    'End Sub
    Public Sub New()

    End Sub
    'Public Sub New(ByVal precio As String, _
    '               ByVal totalRecepcion As String, _
    '               ByVal impuesto As String, _
    '               ByVal descuento As String, _
    '               ByVal difPeso As String)
    '    Me.numeroOC = ""
    '    Me.proveedor = ""
    '    Me.periodo = ""
    '    Me.estado = ""
    '    Me.precio = ""
    '    Me.codigoBodega = ""
    '    Me.nombreBodega = ""
    '    Me.descripcion = ""
    '    Me.nroRecepcion = ""
    '    Me.tipo_documento = ""
    '    Me.nroDocumento = ""
    '    Me.totalRecepcionado = ""
    '    Me.observacionRecp = ""
    '    Me.descuento = descuento
    '    Me.impuesto = impuesto
    '    Me.precioNeto = Math.Round((Double.Parse(totalRecepcion) / 1.19), 2).ToString
    '    Me.ivaTotal = Math.Round((Double.Parse(totalRecepcion) / 1.19) * 0.19, 2).ToString
    '    Me.totalRecepcion = totalRecepcion
    '    Me.totalOCompra = precio
    '    Me.difpeso = difPeso
    'End Sub
End Class
