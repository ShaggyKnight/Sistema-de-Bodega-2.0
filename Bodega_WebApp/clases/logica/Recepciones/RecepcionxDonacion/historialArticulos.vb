Public Class historialArticulos
    Public recid As String
    Public FLD_MATCODIGO As String
    Public FLD_MATNOMBRE As String
    Public FLD_MOVCANTIDAD As String
    Public FLD_UMEDDESCRIPCION As String
    Public FLD_PPUNETO As String
    Public total As String
    Public FLD_PRECIOUNITARIO As String
    Public totalDonacion As String
    Public FLD_ITECODIGO As String
    Public bodega As String
    Public cantidadExistente As String
    Public Nserie As String
    Public fechaVto As String


    Public Sub New(codigo As String, nombre As String, cantidad As String, descripcion As String, neto As String,
                   total As String, precioUnitario As String, totalDonacion As String, item As String, bodega As String, cantidadExistente As String,
                    NLote As String, fechaVencimiento As String)
        Me.recid = codigo
        Me.FLD_MATCODIGO = codigo
        Me.FLD_MATNOMBRE = nombre
        Me.FLD_MOVCANTIDAD = cantidad
        Me.FLD_UMEDDESCRIPCION = descripcion
        Me.FLD_PPUNETO = neto
        Me.total = total
        Me.FLD_PRECIOUNITARIO = precioUnitario
        Me.totalDonacion = totalDonacion
        Me.FLD_ITECODIGO = item
        Me.bodega = bodega
        Me.cantidadExistente = cantidadExistente
        Me.Nserie = NLote
        Me.fechaVto = fechaVencimiento
    End Sub
End Class
