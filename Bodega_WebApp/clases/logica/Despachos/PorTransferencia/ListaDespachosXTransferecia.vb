Public Class ListaDespachosXTransferecia
    Public status As String
    Public total As Integer
    Public records As List(Of DespachoXTransferencia)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
        Me.records = New List(Of DespachoXTransferencia)
    End Sub

    Public Sub ingresaTransferencia(ByVal transferencia As DespachoXTransferencia)
        Me.records.Add(transferencia)
        Me.total += 1
    End Sub
End Class
