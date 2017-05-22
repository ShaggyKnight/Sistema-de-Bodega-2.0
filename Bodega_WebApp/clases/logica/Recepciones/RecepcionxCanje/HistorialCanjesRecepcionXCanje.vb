Public Class HistorialCanjesRecepcionXCanje
    Public status As String
    Public total As Integer
    Public records As New List(Of ListaHistorialGrid2RecepcionXCanje)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(i As Integer, codigo As String, fecha As String, fechaCompleta As String, descripcion As String, MovPrecio As String)
        Me.records.Add(New ListaHistorialGrid2RecepcionXCanje(i, codigo, fecha, fechaCompleta, descripcion, MovPrecio))
        Me.total = Me.total + 1
    End Sub
End Class
