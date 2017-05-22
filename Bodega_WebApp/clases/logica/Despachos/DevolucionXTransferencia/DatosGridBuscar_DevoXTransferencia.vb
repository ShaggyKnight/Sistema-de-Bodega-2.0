Public Class DatosGridBuscar_DevoXTransferencia

    Public recid As Integer
    Public periodoTransf As Integer
    Public numeroTransf As Integer
    Public fechaTransf As String
    Public tipoPedido As String
    Public bodegaOrigen As String
    Public bodegaDestino As String
    Public numeroPedido As Integer
    Public periodoPedido As Integer

    Public Sub New(ByVal recid As Integer, _
                   ByVal periodoTransf As Integer, _
                   ByVal numeroTransf As Integer, _
                   ByVal fechaTransf As String, _
                   ByVal tipoPedido As String, _
                   ByVal bodegaOrigen As String, _
                   ByVal bodegaDestino As String, _
                   ByVal numeroPedido As Integer, _
                   ByVal periodoPedido As Integer)

        Me.recid = recid
        Me.periodoTransf = periodoTransf
        Me.numeroTransf = numeroTransf
        Me.fechaTransf = fechaTransf
        Me.tipoPedido = tipoPedido
        Me.bodegaOrigen = bodegaOrigen
        Me.bodegaDestino = bodegaDestino
        Me.numeroPedido = numeroPedido
        Me.periodoPedido = periodoPedido

    End Sub
End Class