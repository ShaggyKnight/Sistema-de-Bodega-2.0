Public Class ListaDevolucionUsuario
    Public status As String
    Public total As Integer
    Public records As List(Of DevolucionUsuario)
    Public Sub New()
        Me.status = "success"
        Me.total = 0
        Me.records = New List(Of DevolucionUsuario)
    End Sub
    Public Sub setDevolucion(ByVal devolucion As DevolucionUsuario)
        Me.records.Add(devolucion)
        Me.total += 1
    End Sub
End Class
