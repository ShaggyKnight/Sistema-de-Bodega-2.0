Public Class ListaHistorialRecepcionxCanje
    Public articulo As New List(Of historialArticulosRecepcionxCanje)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(recid As Integer, codigo As String, nombre As String, itemCodigo As String, itemDenominacion As String, bodCodigo As String,
                   bodNombre As String, movimiento As String, cantDevolver As String, precioUnitario As String)
        Me.articulo.Add(New historialArticulosRecepcionxCanje(recid, codigo, nombre, itemCodigo, itemDenominacion, bodCodigo, bodNombre, movimiento, cantDevolver, precioUnitario))
    End Sub
End Class
