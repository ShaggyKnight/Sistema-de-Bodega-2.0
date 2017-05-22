Public Class ListaDetallesMatDespXTransfer
    Public status As String
    Public total As Integer
    Public records As List(Of DetalleMaterialDespXTransferencia)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
        Me.records = New List(Of DetalleMaterialDespXTransferencia)
    End Sub

    Public Sub agregarDetalle(ByVal detalleMat As DetalleMaterialDespXTransferencia)
        Me.records.Add(detalleMat)
        Me.total += 1
    End Sub

End Class
