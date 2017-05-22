Public Class MaterialDespXTransferencia
    Public recid As String
    Public codigoMaterial As String
    Public nombreMaterial As String
    Public codigoItem As String
    Public nombreItem As String
    Public cantidadEntregado As Integer
    Public cantidadPedida As Integer
    Public cantidadPendiente As Integer
    Public existenciaBSol As Integer
    Public existenciaBDesp As Integer
    Public precioUnitario As Double
    Public cantidadADespachar As Integer
    Public total As Double
    Public Sub New(ByVal codigoMaterial As String, _
                   ByVal nombreMaterial As String, _
                   ByVal codigoItem As String, _
                   ByVal nombreItem As String, _
                   ByVal cantidadEntregado As Integer, _
                   ByVal cantidadPedida As Integer, _
                   ByVal cantidadPendiente As Integer, _
                   ByVal existenciaBSol As Integer, _
                   ByVal existenciaBDesp As Integer, _
                   ByVal precioUnitario As Double, _
                   ByVal cantidadADespachar As Integer, _
                   ByVal total As Double)

        Me.recid = codigoMaterial
        Me.codigoMaterial = codigoMaterial
        Me.nombreMaterial = nombreMaterial
        Me.codigoItem = codigoItem
        Me.nombreItem = nombreItem
        Me.cantidadEntregado = cantidadEntregado
        Me.cantidadPedida = cantidadPedida
        Me.cantidadPendiente = cantidadPendiente
        Me.existenciaBSol = existenciaBSol
        Me.existenciaBDesp = existenciaBDesp
        Me.precioUnitario = precioUnitario
        Me.cantidadADespachar = cantidadADespachar
        Me.total = total

    End Sub
End Class
