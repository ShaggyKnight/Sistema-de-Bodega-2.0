Public Class ListaDevoPrestamo
    Public status As String
    Public total As Integer
    Public records As New List(Of ArticulosGrid1xPrestamo)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(i As Integer, codMaterial As String, nombre As String, itemCodigo As String,
                   itemDenominacion As String, codBodega As String, bogNombre As String, movCantidad As String,
                    cantPedida As String, precioUnitario As String, cantDevolver As String, NDevolucion As String)
        Me.records.Add(New ArticulosGrid1xPrestamo(i, codMaterial, nombre, itemCodigo, itemDenominacion, codBodega, bogNombre, movCantidad, cantPedida, precioUnitario, cantDevolver, NDevolucion))
        Me.total = Me.total + 1
    End Sub
End Class
