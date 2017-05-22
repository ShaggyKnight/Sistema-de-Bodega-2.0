Public Class ListaPedidosDespUsuarios
    Public status As String
    Public total As Integer
    Public records As List(Of DespachoHaciaUsuarios)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
        Me.records = New List(Of DespachoHaciaUsuarios)
    End Sub

    Public Sub setPedido(ByVal pedido As DespachoHaciaUsuarios)
        Me.records.Add(pedido)
        Me.total += 1
    End Sub
End Class
