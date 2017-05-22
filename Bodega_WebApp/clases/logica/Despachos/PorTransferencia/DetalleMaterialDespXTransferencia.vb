Public Class DetalleMaterialDespXTransferencia
    Public recid As Integer
    Public numeroLinea As Integer
    Public tmvCodigo As String
    Public percodigo As String
    Public cmvNumero As Integer
    Public codigoMaterial As String
    Public cantidad As Integer
    Public lote_Serie As String
    Public fechaVencimiento As String

    Public Sub New(ByVal recid As Integer, _
                   ByVal numeroLinea As Integer, _
                   ByVal tmvCodigo As String, _
                   ByVal percodigo As String, _
                   ByVal cmvNumero As Integer, _
                   ByVal codigoMaterial As String, _
                   ByVal cantidad As Integer, _
                   ByVal lote_Serie As String, _
                   ByVal fechaVencimiento As String)
        Me.recid = recid
        Me.numeroLinea = numeroLinea
        Me.tmvCodigo = tmvCodigo
        Me.percodigo = percodigo
        Me.cmvNumero = cmvNumero
        Me.codigoMaterial = codigoMaterial
        Me.cantidad = cantidad
        Me.lote_Serie = lote_Serie
        Me.fechaVencimiento = fechaVencimiento

    End Sub
End Class
