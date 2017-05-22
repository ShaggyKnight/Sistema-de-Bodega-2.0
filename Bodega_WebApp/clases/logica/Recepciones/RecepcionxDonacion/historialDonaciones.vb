Public Class historialDonaciones

    Public status As String
    Public total As Integer
    Public records As New List(Of listHistorial)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub    

    Public Sub AgregarRecords(i As Integer, FLD_CMVNUMERO As String, FLD_PERCODIGO As String, FLD_DONFECHA As String, FLD_DONDESCRIP As String)
        Me.records.Add(New listHistorial(i, FLD_CMVNUMERO, FLD_PERCODIGO, FLD_DONFECHA, FLD_DONDESCRIP))
        Me.total = Me.total + 1
    End Sub

End Class
