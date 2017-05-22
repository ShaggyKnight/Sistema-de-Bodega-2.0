Public Class ListaArticulosGrid1DespOtrasInst
    Public articulo As New List(Of ArticulosGrid1DespOtrasInst)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(recid As String, codigo As String, nombre As String, item As String, cantidad As String,
                   precioUnitario As String, totalPrestamo As String, cantidadExistente As String, bodega As String, Nserie As String, FechaVto As String)
        Me.articulo.Add(New ArticulosGrid1DespOtrasInst(recid, codigo, nombre, item, cantidad, precioUnitario, totalPrestamo, cantidadExistente, bodega, Nserie, FechaVto))
    End Sub
End Class
