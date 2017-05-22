Public Class historialArticulosRecepcionxCanje
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

    Public Sub New(recid As Integer, codigo As String, nombre As String, itemCodigo As String,
                   itemDenominacion As String, bodCodigo As String, bodNombre As String, movimiento As String,
                   cantDevolver As String, precioUnitario As String)
        Me.recid = recid
        Me.FLD_MATCODIGO = codigo
        Me.FLD_MATNOMBRE = nombre
        Me.FLD_ITECODIGO = itemCodigo
        Me.FLD_ITEDENOMINACION = itemDenominacion
        Me.FLD_BODCODIGO = bodCodigo
        Me.FLD_BODNOMBRES = bodNombre
        Me.FLD_MOVCANTIDAD = movimiento
        Me.CNT_DEVOLVER = cantDevolver
        Me.FLD_PRECIOUNITARIO = precioUnitario

    End Sub
End Class
