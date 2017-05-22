Public Class historialDonacionesProgramaMinsal
    Public status As String
    Public total As Integer
    Public records As New List(Of listHistorialMinsal)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(i As Integer, fecha As String, codigo As String, fechaCompleta As String,
                   NroDoc As String, MinDescrip As String, MovPrecio As String, Programa As String)
        Me.records.Add(New listHistorialMinsal(i, fecha, codigo, fechaCompleta, NroDoc, MinDescrip, MovPrecio, Programa))
        Me.total = Me.total + 1
    End Sub
End Class
