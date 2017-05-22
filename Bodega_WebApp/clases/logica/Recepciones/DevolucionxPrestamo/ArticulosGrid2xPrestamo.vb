Public Class ArticulosGrid2xPrestamo
    Public recid As String
    Public FLD_CMVNUMERO As String
    Public FLD_PERCODIGO As String
    Public FLD_PREFECHA As String
    Public FLD_PREDESCRIPCION As String

    Public Sub New(i As Integer, fecha As String, codigo As String, fechaCompleta As String, descripcion As String)
        Me.recid = i
        Me.FLD_CMVNUMERO = codigo
        Me.FLD_PERCODIGO = fecha
        Me.FLD_PREFECHA = fechaCompleta
        Me.FLD_PREDESCRIPCION = descripcion
    End Sub
End Class
