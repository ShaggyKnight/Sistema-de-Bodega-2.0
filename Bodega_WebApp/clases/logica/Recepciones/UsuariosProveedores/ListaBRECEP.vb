Public Class ListaBRECEP
    Public status As String
    Public total As Integer
    Public records As List(Of RecepBusquedaPopUp)

    Public Sub New()
        Me.records = New List(Of RecepBusquedaPopUp)
        total = 0
        status = "success"
    End Sub
    Public Sub setRecepcion(ByVal recepcion As RecepBusquedaPopUp)
        Me.records.Add(recepcion)
        total += 1
    End Sub
End Class
