Public Class Material

    Public recid As String
    Public nombreMaterial As String
    Public unidad As String
    Public cantidadARecibir As String
    Public factor As String
    Public cantidad As String
    Public valor As String
    Public iteCodigo As String
    Public recepcionFactura As String
    Public recepcionado As String
    Public total As String

    Public Sub New(ByVal idMaterial As String, _
                   ByVal nombreMaterial As String, _
                   ByVal unidad As String, _
                   ByVal cantidadARecibir As String, _
                   ByVal factor As String, _
                   ByVal cantidad As String, _
                   ByVal valor As String, _
                   ByVal iteCodigo As String, _
                   ByVal recepcionFactura As String, _
                   ByVal recepcionado As String, _
                   ByVal total As String)
        Me.recid = idMaterial
        Me.nombreMaterial = nombreMaterial
        Me.unidad = unidad
        Me.cantidadARecibir = cantidadARecibir
        Me.factor = factor
        Me.cantidad = cantidad
        Me.valor = valor
        Me.iteCodigo = iteCodigo
        Me.recepcionFactura = recepcionFactura
        Me.recepcionado = recepcionado
        Me.total = total
    End Sub

End Class
