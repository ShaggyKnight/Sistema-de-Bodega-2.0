Public Class DespachoHaciaUsuarios
    Public recid As Integer
    Public numeroPedido As Integer
    Public periodoDespacho As Integer
    Public estadoPedido As String
    Public bodegaPedido As String
    Public nombreBodegaPedido As String
    Public centroCosto As String
    Public tipoPedido As String
    Public observacionPedido As String
    Public numeroDespacho As Integer
    Public fechaDespacho As String

    Public Sub New(ByVal numeroPedido As Integer, _
                   ByVal periodoDespacho As Integer, _
                   ByVal estadoPedido As String, _
                   ByVal bodegaPedido As String, _
                   ByVal nombreBodega As String, _
                   ByVal centroCosto As String, _
                   ByVal tipoPedido As String, _
                   ByVal observacionPedido As String, _
                   ByVal numeroDespacho As Integer, _
                   ByVal fechaDespacho As String)

        Me.numeroPedido = numeroPedido
        Me.periodoDespacho = periodoDespacho
        Me.estadoPedido = estadoPedido
        Me.bodegaPedido = bodegaPedido
        Me.nombreBodegaPedido = nombreBodega
        Me.centroCosto = centroCosto
        Me.tipoPedido = tipoPedido
        Me.observacionPedido = observacionPedido
        Me.numeroDespacho = numeroDespacho
        Me.fechaDespacho = fechaDespacho.Substring(0, 10)
    End Sub
    Public Sub New(ByVal recid As Integer, _
                   ByVal numeroPedido As Integer, _
                   ByVal periodoDespacho As Integer, _
                   ByVal estadoPedido As String, _
                   ByVal bodegaPedido As String, _
                   ByVal centroCosto As String, _
                   ByVal tipoPedido As String, _
                   ByVal observacionPedido As String)

        Me.recid = recid
        Me.numeroPedido = numeroPedido
        Me.periodoDespacho = periodoDespacho
        Me.estadoPedido = estadoPedido
        Me.bodegaPedido = bodegaPedido
        Me.centroCosto = centroCosto
        Me.tipoPedido = tipoPedido
        Me.observacionPedido = observacionPedido
    End Sub
End Class
