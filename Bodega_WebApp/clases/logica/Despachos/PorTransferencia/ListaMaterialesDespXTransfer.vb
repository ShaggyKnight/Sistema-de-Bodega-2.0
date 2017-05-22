Public Class ListaMaterialesDespXTransfer
    Public status As String
    Public total As Integer
    Public records As List(Of MaterialDespXTransferencia)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
        Me.records = New List(Of MaterialDespXTransferencia)
    End Sub
    Public Sub agregarMaterial(ByVal material As MaterialDespXTransferencia)
        Me.records.Add(material)
        Me.total += 1
    End Sub
End Class
