Public Class ListaDespachosNPedido
    Public status As String
    Public total As Integer
    Public records As List(Of DespachoNPedido)

    Public Sub New()
        Me.records = New List(Of DespachoNPedido)
        Me.total = 0
        Me.status = "success"
    End Sub
    Public Sub setDespacho(ByVal despacho As DespachoNPedido)
        Me.records.Add(despacho)
        Me.total += 1
    End Sub
End Class
