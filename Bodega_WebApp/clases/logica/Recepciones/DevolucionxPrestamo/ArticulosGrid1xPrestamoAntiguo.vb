Public Class ArticulosGrid1xPrestamoAntiguo
    Public recid As String
    Public FLD_MATCODIGO As String
    Public FLD_MATNOMBRE As String
    Public FLD_ITECODIGO As String
    Public FLD_ITEDENOMINACION As String
    Public FLD_BODCODIGO As String
    Public FLD_BODNOMBRES As String
    Public FLD_MOVCANTIDAD As String
    Public CNT_DEVOLVER As String
    Public FLD_PRECIOUNITARIO As String


    Public Sub New(i As Integer, codMaterial As String, nombre As String, itemCodigo As String,
                   itemDenominacion As String, codBodega As String, bogNombre As String, movCantidad As String,
                    catDevolver As String, precioUnitario As String)
        Me.recid = i
        Me.FLD_MATCODIGO = codMaterial
        Me.FLD_MATNOMBRE = nombre
        Me.FLD_ITECODIGO = itemCodigo
        Me.FLD_ITEDENOMINACION = itemDenominacion
        Me.FLD_BODCODIGO = codBodega
        Me.FLD_BODNOMBRES = bogNombre
        Me.FLD_MOVCANTIDAD = movCantidad
        Me.CNT_DEVOLVER = catDevolver
        Me.FLD_PRECIOUNITARIO = precioUnitario
    End Sub
End Class
