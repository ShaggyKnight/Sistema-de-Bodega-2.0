Public Class ListaDevoPrestamoAntiguo
    Public status As String
    Public total As Integer
    Public records As New List(Of ArticulosGrid1xPrestamoAntiguo)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(i As Integer, codMaterial As String, nombre As String, itemCodigo As String,
                   itemDenominacion As String, codBodega As String, bogNombre As String, movCantidad As String,
                    catDevolver As String, precioUnitario As String)
        Me.records.Add(New ArticulosGrid1xPrestamoAntiguo(i, codMaterial, nombre, itemCodigo, itemDenominacion, codBodega, bogNombre, movCantidad, catDevolver, precioUnitario))
        Me.total = Me.total + 1
    End Sub
End Class
