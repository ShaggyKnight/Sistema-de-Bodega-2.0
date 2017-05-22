Public Class MaterialPedidoUsuarios
    Public recid As String
    Public nombreMaterial As String
    Public codItem As String
    Public itemPresupuestario As String
    Public cantidadPedida As Integer
    Public cantidadEntregado As Integer
    Public cantidadPendiente As Integer
    Public cantidadExistencia As Integer
    Public precioUnitario As Integer
    Public cantidadADespachar As Integer
    Public total As Integer
    Public pauta As String

    Public Sub New()

    End Sub
    Public Sub New(ByVal codigoMaterial As String, _
                   ByVal nombreMaterial As String, _
                   ByVal codItem As String, _
                   ByVal itemPresupuestario As String, _
                   ByVal cantidadPedida As Integer, _
                   ByVal cantidadEntregado As Integer, _
                   ByVal cantidadPendiente As Integer, _
                   ByVal cantidadExistencia As Integer, _
                   ByVal precioUnitario As Integer, _
                   ByVal cantidadADespachar As Integer, _
                   ByVal total As Integer, _
                   ByVal pauta As String)

        Me.recid = codigoMaterial
        Me.nombreMaterial = nombreMaterial
        Me.codItem = codItem
        Me.itemPresupuestario = itemPresupuestario
        Me.cantidadPedida = cantidadPedida
        Me.cantidadEntregado = cantidadEntregado
        Me.cantidadPendiente = cantidadPendiente
        Me.cantidadExistencia = cantidadExistencia
        Me.precioUnitario = precioUnitario
        Me.cantidadADespachar = cantidadADespachar
        Me.total = total
        Me.pauta = pauta

    End Sub
End Class
