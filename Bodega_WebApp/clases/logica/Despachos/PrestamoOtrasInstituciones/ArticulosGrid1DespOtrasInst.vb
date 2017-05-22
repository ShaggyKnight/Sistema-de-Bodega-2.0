Public Class ArticulosGrid1DespOtrasInst
    Public recid As String
    Public FLD_MATCODIGO As String
    Public FLD_MATNOMBRE As String
    Public FLD_ITECODIGO As String
    Public FLD_CANTIDAD As String
    Public FLD_PRECIOUNITARIO As String
    Public FLD_TOTAL_PRESTAMO As String
    Public FLD_EXICANTIDAD As String
    Public bodega As String
    Public Nserie As String
    Public FechaVto As String

    Public Sub New(recid As String, codigo As String, nombre As String, item As String, cantidad As String,
                   precioUnitario As String, totalPrestamo As String, cantidadExistente As String, bodega As String,
                   Nserie As String, FechaVto As String)
        Me.recid = recid
        Me.FLD_MATCODIGO = codigo
        Me.FLD_MATNOMBRE = nombre
        Me.FLD_ITECODIGO = item
        Me.FLD_CANTIDAD = cantidad
        Me.FLD_PRECIOUNITARIO = precioUnitario
        Me.FLD_TOTAL_PRESTAMO = totalPrestamo
        Me.FLD_EXICANTIDAD = cantidadExistente
        Me.bodega = bodega
        Me.Nserie = Nserie
        Me.FechaVto = FechaVto

    End Sub
End Class
