Public Class ArticulosDetalleGrid1DespOtrasInst
    Public recid As String
    Public FLD_MOVNUMEROLINEA As String
    Public FLD_TMVCODIGO As String
    Public FLD_PERCODIGO As String
    Public FLD_CMVNUMERO As String
    Public codMaterial2 As String
    Public cantidad2 As String
    Public loteSerie2 As String
    Public fechaVencimiento2 As String

    Public Sub New(i As Integer, numeroLinea As String, codigo As String, fechaCompleta As String,
                    NTransaccion As String, codMaterial As String, cantMovimiento As String,
                    NSerie As String, fechaVto As String)
        Me.recid = i
        Me.FLD_MOVNUMEROLINEA = numeroLinea
        Me.FLD_TMVCODIGO = codigo
        Me.FLD_PERCODIGO = fechaCompleta
        Me.FLD_CMVNUMERO = NTransaccion
        Me.codMaterial2 = codMaterial
        Me.cantidad2 = cantMovimiento
        Me.loteSerie2 = NSerie
        Me.fechaVencimiento2 = fechaVto
    End Sub
End Class
