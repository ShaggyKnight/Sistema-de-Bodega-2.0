Public Class ListaGrid2HistoricoxPrestamo
    Public status As String
    Public total As Integer
    Public records As New List(Of ArticulosGrid2xPrestamo)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(i As Integer, fecha As String, codigo As String, fechaCompleta As String, descripcion As String)
        Me.records.Add(New ArticulosGrid2xPrestamo(i, fecha, codigo, fechaCompleta, descripcion))
        Me.total = Me.total + 1
    End Sub
End Class
