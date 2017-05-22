Public Class ListaOCxNroFactura
    Public status As String
    Public total As Integer
    Public records As List(Of OCxFactura)

    Public Sub New()
        Me.records = New List(Of OCxFactura)
        total = 0
        status = "success"
    End Sub
    Public Sub setRecepcion(ByVal recepcion As OCxFactura)
        Me.records.Add(recepcion)
        total += 1
    End Sub
End Class
