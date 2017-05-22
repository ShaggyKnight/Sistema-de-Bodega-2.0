Public Class ListaHistorialGrid2RecepcionXCanje
    Public recid As String
    Public FLD_CMVNUMERO As String
    Public FLD_PERCODIGO As String
    Public FLD_PREFECHA As String
    Public FLD_PREDESCRIPCION As String
    Public FLD_MOVPRECIO As String

    Public Sub New(i As Integer, codigo As String, fecha As String, fechaCompleta As String, descripcion As String, MovPrecio As String)
        Me.recid = i
        Me.FLD_CMVNUMERO = codigo
        Me.FLD_PERCODIGO = fecha
        Me.FLD_PREFECHA = fechaCompleta
        Me.FLD_PREDESCRIPCION = descripcion
        Me.FLD_MOVPRECIO = MovPrecio
    End Sub
End Class
