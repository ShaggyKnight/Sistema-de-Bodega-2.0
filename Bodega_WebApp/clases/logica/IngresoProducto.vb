Public Class IngresoProducto
    Public codigo As String
    Public nombre As String
    Public unidMedida As String
    Public aRecibir As String
    Public factor As String
    Public cantidad As String
    Public valor As String
    Public codigoItem As String
    Public recepcionXFactor As String
    Public recepcionado As String
    Public total As String

    Public detalles As List(Of IngresoProductoDetalle)

    Public Sub New(ByVal codigo As String, _
        ByVal nombre As String, _
        ByVal unidMedida As String, _
        ByVal aRecibir As String, _
        ByVal factor As String, _
        ByVal cantidad As String, _
        ByVal valor As String, _
        ByVal recepcionado As String, _
        ByVal recepcionXFactor As String, _
        ByVal total As String,
        ByVal codigoItem As String)

        Me.codigo = codigo
        Me.nombre = nombre
        Me.unidMedida = unidMedida
        Me.aRecibir = aRecibir
        Me.factor = factor
        Me.cantidad = cantidad
        Me.valor = valor
        Me.recepcionXFactor = recepcionXFactor
        Me.recepcionado = recepcionado
        Me.total = total
        Me.codigoItem = codigoItem

        detalles = New List(Of IngresoProductoDetalle)
    End Sub

    Public Sub AgregarDetalle(ByVal cantidad As String, _
        ByVal numeroDeLote As String, _
        ByVal numeroDeSerie As String, _
        ByVal fechaVencimiento As String)
        detalles.Add(New IngresoProductoDetalle(cantidad, numeroDeLote, numeroDeSerie, fechaVencimiento))
    End Sub

    Public Sub AgregarDetalle(ByVal ingreso As IngresoProductoDetalle)
        detalles.Add(ingreso)
    End Sub
End Class
