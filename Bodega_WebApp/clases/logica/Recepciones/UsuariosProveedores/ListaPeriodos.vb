Public Class ListaPeriodos
    Public status As String
    Public items As List(Of Periodo)

    Public Sub New()
        Me.status = "error"
        Me.items = New List(Of Periodo)
    End Sub
    Public Sub setPeriodo(ByVal periodo As Periodo)
        Me.status = "success"
        Me.items.Add(periodo)
    End Sub
End Class
