Public Class DetallesMaterial
    Public recid As Integer
    Public codigoMaterial As String
    Public cantidad As Integer
    Public loteSerie As String
    Public serie As String
    Public fechaVencimiento As String

    Public Sub New(ByVal recid As Integer, _
                   ByVal codigoMaterial As String, _
                   ByVal cantidad As Integer, _
                   ByVal nroLote As String, _
                   ByVal nroSerie As String, _
                   ByVal fechaVencimiento As String)

        Me.recid = recid
        Me.codigoMaterial = codigoMaterial
        Me.cantidad = cantidad
        Me.loteSerie = nroLote
        Me.serie = nroSerie
        Me.fechaVencimiento = fechaVencimiento

    End Sub
End Class
