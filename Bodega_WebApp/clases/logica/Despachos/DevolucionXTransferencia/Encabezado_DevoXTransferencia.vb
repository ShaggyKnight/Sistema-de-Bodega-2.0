Public Class Encabezado_DevoXTransferencia
    Public recid As Integer
    Public numeroPedido As Integer
    Public periodoDespacho As Integer
    Public estadoPedido As String
    Public tipoPedido As String
    Public observacionPedido As String
    Public bodegaSolicita As String
    Public nombreBodegaSolicita As String
    Public bodegaDespacha As String
    Public nombreBodegaDespacha As String
    Public nroDevoXTransferencia As Integer
    Public periodoDevoXTransferencia As Integer
    Public autorizacion As String
    Public nroSolicitudOriginal As Integer

    Public Sub New(ByVal recid As Integer, _
                   ByVal numeroPedido As Integer, _
                   ByVal periodoDespacho As Integer, _
                   ByVal estadoPedido As String, _
                   ByVal tipoPedido As String, _
                   ByVal observacionPedido As String, _
                   ByVal bodegaSolicita As String, _
                   ByVal nombreBodegaSolicita As String, _
                   ByVal bodegaDespacha As String, _
                   ByVal nombreBodegaDespacha As String, _
                   ByVal nroTransferencia As Integer, _
                   ByVal periodoTransferencia As Integer, _
                   ByVal autorizacion As String, _
                   ByVal nroSolicitudOriginal As Integer)

        Me.recid = recid
        Me.numeroPedido = numeroPedido
        Me.periodoDespacho = periodoDespacho
        Me.estadoPedido = estadoPedido
        Me.tipoPedido = tipoPedido
        Me.observacionPedido = observacionPedido
        Me.bodegaSolicita = bodegaSolicita
        Me.nombreBodegaSolicita = nombreBodegaSolicita
        Me.bodegaDespacha = bodegaDespacha
        Me.nombreBodegaDespacha = nombreBodegaDespacha
        Me.nroDevoXTransferencia = nroTransferencia
        Me.periodoDevoXTransferencia = periodoTransferencia
        Me.autorizacion = autorizacion
        Me.nroSolicitudOriginal = nroSolicitudOriginal

    End Sub
End Class