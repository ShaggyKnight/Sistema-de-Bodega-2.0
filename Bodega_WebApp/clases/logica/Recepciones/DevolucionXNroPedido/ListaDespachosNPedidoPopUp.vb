Public Class ListaDespachosNPedidoPopUp
    Public status As String
    Public total As Integer
    Public records As List(Of DespachoNPedidoPopUp)

    Public Sub New()
        Me.records = New List(Of DespachoNPedidoPopUp)
        Me.total = 0
        Me.status = "success"
    End Sub
    Public Sub setDespacho(ByVal despacho As DespachoNPedidoPopUp)
        Me.records.Add(despacho)
        Me.total += 1
    End Sub
End Class
