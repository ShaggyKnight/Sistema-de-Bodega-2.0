Public Class ListaDeArticulosDeHistorial
    Public articulo As New List(Of historialArticulos)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(codigo As String, nombre As String, cantidad As String, descripcion As String, neto As String,
                   total As String, precioUnitario As String, totalDonacion As String, item As String, bodega As String, cantidadExistente As String,
                   Nserie As String, fechaVencimiento As String)
        Me.articulo.Add(New historialArticulos(codigo, nombre, cantidad, descripcion, neto, total, precioUnitario, totalDonacion, item, bodega, cantidadExistente, Nserie, fechaVencimiento))
    End Sub
End Class
