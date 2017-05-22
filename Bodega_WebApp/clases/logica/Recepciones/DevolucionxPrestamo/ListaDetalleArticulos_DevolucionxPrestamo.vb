Public Class ListaDetalleArticulos_DevolucionxPrestamo
    Public status As String
    Public total As Integer
    Public records As New List(Of ArticulosDetalleGrid1_DevolucionxPrestamo)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(i As Integer, numeroLinea As String, codigo As String, fechaCompleta As String,
                    NTransaccion As String, codMaterial As String, cantMovimiento As String, NSerie As String, fechaVto As String, bodega As String)
        Me.records.Add(New ArticulosDetalleGrid1_DevolucionxPrestamo(i, numeroLinea, codigo, fechaCompleta, NTransaccion, codMaterial, cantMovimiento, NSerie, fechaVto, bodega))
        Me.total = Me.total + 1
    End Sub
End Class
