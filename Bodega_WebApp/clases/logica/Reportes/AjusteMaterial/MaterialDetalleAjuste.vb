Public Class MaterialDetalleAjuste
    Public recid As String
    Public movEntrada As String     'Public FLD_TMVDESCRIPCION As String
    Public periodo As String        'Public FLD_PERCODIGO As String
    Public numMov As String         'Public FLD_CMVNUMERO As String
    Public codMaterial As String    'Public FLD_MATCODIGO As String
    Public cantEntrada As String    'Public FLD_MOVCANTIDAD As String
    Public existencia As String     'Public FLD_EXICANTIDAD As String
    Public loteSerie As String      'Public FLD_NSERIE As String
    Public loteSerie2 As String      'Public FLD_NSERIE As String
    Public fechaVencimiento As String  'Public FLD_FECHAVENCIMIENTO As String 
    Public descripcion As String  'Public FLD_FECHAVENCIMIENTO As String 
    Public Sub New(ByVal recid As Integer, ByVal tipoMov As String, ByVal anio As String, ByVal numMov As String, ByVal codMat As String,
                   ByVal cantMov As String, ByVal existencia As String, ByVal nserie As String, ByVal fechaVto As String)
        Me.recid = recid
        Me.movEntrada = tipoMov
        Me.periodo = anio
        Me.numMov = numMov
        Me.codMaterial = codMat
        Me.cantEntrada = cantMov
        Me.existencia = existencia
        Me.loteSerie = nserie
        Me.loteSerie2 = ""
        Me.fechaVencimiento = fechaVto
        Me.descripcion = ""

    End Sub
End Class
