Public Class ListaGrid2HistoricoxDespOtrasInst
    Public status As String
    Public total As Integer
    Public records As New List(Of ArticulosGrid2xDespOtrasInst)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(i As Integer, fecha As String, codigo As String, fechaCompleta As String, numeroDoc As String, descripcion As String, precio As String, instituto As String)
        Me.records.Add(New ArticulosGrid2xDespOtrasInst(i, fecha, codigo, fechaCompleta, numeroDoc, descripcion, precio, instituto))
        Me.total = Me.total + 1
    End Sub
End Class
