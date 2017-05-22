Public Class MaterialDevXUsuario

    Public recid As Integer
    Public matCodigo As String
    Public nombreMaterial As String
    Public cantidad As Integer
    Public loteSerie As String
    Public fechaVencimiento As String
    Public precioUnitario As Double
    Public unidadMedida As String
    Public codItemPresupuestario As String
    Public nombreItemPres As String

    Public Sub New(ByVal recid As Integer, _
                   ByVal matCodigo As String, _
                   ByVal nombreMaterial As String, _
                   ByVal cantidad As Integer, _
                   ByVal loteSerie As String, _
                   ByVal fechaVencimiento As String, _
                   ByVal precioUnitario As Double, _
                   ByVal unidadMedida As String, _
                   ByVal codItemPresupuestario As String, _
                   ByVal nombreItemPres As String)

        Me.recid = recid
        Me.matCodigo = matCodigo
        Me.nombreMaterial = nombreMaterial
        Me.cantidad = cantidad
        Me.loteSerie = loteSerie
        Me.fechaVencimiento = fechaVencimiento
        Me.precioUnitario = precioUnitario
        Me.unidadMedida = unidadMedida
        Me.codItemPresupuestario = codItemPresupuestario
        Me.nombreItemPres = nombreItemPres
    End Sub
End Class
