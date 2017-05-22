Public Class HistorialDonacionesRecepXSolicitudPrestamo
    Public status As String
    Public total As Integer
    Public records As New List(Of ListaHistorialGrid2RecepXSolicitudPrestamo)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(i As Integer, codigo As String, fecha As String, fechaCompleta As String, Ndocumento As String, descripcion As String, MovPrecio As String, instituto As String)
        Me.records.Add(New ListaHistorialGrid2RecepXSolicitudPrestamo(i, codigo, fecha, fechaCompleta, Ndocumento, descripcion, MovPrecio, instituto))
        Me.total = Me.total + 1
    End Sub
End Class
