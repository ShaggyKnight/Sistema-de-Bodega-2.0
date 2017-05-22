Public Class ListaOrdenesCompra
    Public status As String
    Public record As List(Of OrdenCompra)

    Public Sub New()
        record = New List(Of OrdenCompra)
    End Sub
    Public Sub setOrdenDeCompra(ByVal ordenCompra As OrdenCompra)
        Me.status = "success"
        Me.record.Add(ordenCompra)
    End Sub
    Public Sub setOrdenesCompra(ByVal ordenesCompra As List(Of OrdenCompra))
        Me.record = ordenesCompra
    End Sub
End Class
