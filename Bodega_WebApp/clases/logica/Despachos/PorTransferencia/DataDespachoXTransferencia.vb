Public Class DataDespachoXTransferencia
    Public status As String
    Public record As List(Of DespachoXTransferencia)

    Public Sub New()
        Me.status = "success"
        Me.record = New List(Of DespachoXTransferencia)
    End Sub

    Public Sub agregarDespacho(ByVal despacho As DespachoXTransferencia)
        Me.record.Add(despacho)
    End Sub
End Class
