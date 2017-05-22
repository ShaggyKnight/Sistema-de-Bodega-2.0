Public Class ListaHistorialGrid2RecepXSolicitudPrestamo
    Public recid As String
    Public FLD_CMVNUMERO As String
    Public FLD_PERCODIGO As String
    Public FLD_PREFECHA As String
    Public FLD_NRODOC As String
    Public FLD_PREDESCRIPCION As String
    Public FLD_MOVPRECIO As String
    Public Instituto As String

    Public Sub New(i As Integer, codigo As String, fecha As String, fechaCompleta As String, Ndocumento As String, descripcion As String, MovPrecio As String, instituto As String)
        Me.recid = i
        Me.FLD_CMVNUMERO = codigo
        Me.FLD_PERCODIGO = fecha
        Me.FLD_PREFECHA = fechaCompleta
        Me.FLD_NRODOC = Ndocumento
        Me.FLD_PREDESCRIPCION = descripcion
        Me.FLD_MOVPRECIO = MovPrecio
        Me.Instituto = instituto
    End Sub
End Class
