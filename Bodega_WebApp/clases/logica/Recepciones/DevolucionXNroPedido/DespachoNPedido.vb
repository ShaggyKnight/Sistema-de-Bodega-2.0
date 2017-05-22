Public Class DespachoNPedido
    Public recid As Integer
    Public nroDespacho As Integer
    Public pboNumero As Integer
    Public matCodigo As String
    Public nombreMaterial As String
    Public itemPresupuestario As String
    Public cantDespachada As String
    Public cantDevuelta As String
    Public cantADevolver As String
    Public precioUnitario As String
    Public fechaVencimiento_desp As String
    Public lote_desp As String

    Public Sub New(ByVal recid As Integer, _
                   ByVal nroDespacho As String, _
                   ByVal pboNumero As String, _
                   ByVal matCodigo As String, _
                   ByVal nombreMaterial As String, _
                   ByVal itemPresupuestario As String, _
                   ByVal cantDespachada As String, _
                   ByVal cantDevuelta As String, _
                   ByVal cantADevolver As String, _
                   ByVal precioUnitario As String, _
                   ByVal fechaVencimiento_desp As String, _
                   ByVal lote_desp As String)
        Me.recid = recid
        Me.nroDespacho = nroDespacho
        Me.pboNumero = pboNumero
        Me.matCodigo = matCodigo
        Me.nombreMaterial = nombreMaterial
        Me.itemPresupuestario = itemPresupuestario
        Me.cantDespachada = cantDespachada
        Me.cantDevuelta = cantDevuelta
        Me.cantADevolver = cantADevolver
        Me.precioUnitario = precioUnitario
        Me.fechaVencimiento_desp = fechaVencimiento_desp
        Me.lote_desp = lote_desp
    End Sub
    Public Sub New()

    End Sub
End Class
