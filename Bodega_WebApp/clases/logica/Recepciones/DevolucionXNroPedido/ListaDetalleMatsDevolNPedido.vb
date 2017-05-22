Public Class ListaDetalleMatsDevolNPedido
    Public status As String
    Public total As Integer
    Public records As New List(Of DetalleMaterialDevolNPedido)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub
    Public Sub setDetalleMaterial(ByVal detalleMaterial As DetalleMaterialDevolNPedido)
        Me.records.Add(detalleMaterial)
        Me.total += 1
    End Sub
End Class
