Public Class ArticulosGrid1xPrestamo
    Public recid As String
    Public FLD_MATCODIGO As String
    Public FLD_MATNOMBRE As String
    Public FLD_ITECODIGO As String
    Public FLD_ITEDENOMINACION As String
    Public FLD_BODCODIGO As String
    Public FLD_BODNOMBRES As String
    Public FLD_MOVCANTIDAD As String
    Public FLD_CANTPEDIDA As String
    Public FLD_PRECIOUNITARIO As String
    Public FLD_CANTADEVOLVER As String
    Public FLD_CMVNUMERO As String


    Public Sub New(i As Integer, codMaterial As String, nombre As String, itemCodigo As String,
                   itemDenominacion As String, codBodega As String, bogNombre As String, movCantidad As String,
                    cantPedida As String, precioUnitario As String, cantDevolver As String, NDevolucion As String)
        Me.recid = i
        Me.FLD_MATCODIGO = codMaterial
        Me.FLD_MATNOMBRE = nombre
        Me.FLD_ITECODIGO = itemCodigo
        Me.FLD_ITEDENOMINACION = itemDenominacion
        Me.FLD_BODCODIGO = codBodega
        Me.FLD_BODNOMBRES = bogNombre
        Me.FLD_MOVCANTIDAD = movCantidad
        Me.FLD_CANTPEDIDA = cantPedida
        Me.FLD_PRECIOUNITARIO = precioUnitario
        Me.FLD_CANTADEVOLVER = cantDevolver
        Me.FLD_CMVNUMERO = NDevolucion
    End Sub
End Class
