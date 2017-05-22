Public Class ArticulosGrid2xDespOtrasInst
    Public recid As String
    Public FLD_CMVNUMERO As String
    Public FLD_PERCODIGO As String
    Public FLD_PREFECHA As String
    Public FLD_PREDESCRIPCION As String
    Public FLD_NRODOC As String
    Public MOVPRECIO As String
    Public INSTITUTO As String

    Public Sub New(i As Integer, fecha As String, codigo As String, fechaCompleta As String, numeroDoc As String, descripcion As String, precio As String, instituto As String)
        Me.recid = i
        Me.FLD_CMVNUMERO = codigo
        Me.FLD_PERCODIGO = fecha
        Me.FLD_PREFECHA = fechaCompleta
        Me.FLD_NRODOC = numeroDoc
        Me.FLD_PREDESCRIPCION = descripcion
        Me.MOVPRECIO = precio
        Me.INSTITUTO = instituto
    End Sub
End Class
