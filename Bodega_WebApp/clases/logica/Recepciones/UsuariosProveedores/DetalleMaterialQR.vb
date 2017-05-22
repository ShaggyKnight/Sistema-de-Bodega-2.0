Public Class DetalleMaterialQR
    Public codMaterial As String
    Public loteSerie2 As String
    Public cantidad2 As Integer


    Public Sub New(ByVal codigoMaterial As String, _
                   ByVal nroLote As String, _
                   ByVal cantidad As Integer)

        Me.codMaterial = codigoMaterial
        Me.loteSerie2 = nroLote
        Me.cantidad2 = cantidad

    End Sub

End Class
