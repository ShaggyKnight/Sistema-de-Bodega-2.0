Public Class listHistorial
    Public recid As String
    Public FLD_CMVNUMERO As String
    Public FLD_PERCODIGO As String
    Public FLD_DONFECHA As String
    Public FLD_DONDESCRIP As String

    Public Sub New(i As Integer, codigo As String, fecha As String, fechaCompleta As String, descripcion As String)
        Me.recid = i
        Me.FLD_CMVNUMERO = codigo
        Me.FLD_PERCODIGO = fecha
        Me.FLD_DONFECHA = fechaCompleta
        Me.FLD_DONDESCRIP = descripcion
    End Sub
End Class
