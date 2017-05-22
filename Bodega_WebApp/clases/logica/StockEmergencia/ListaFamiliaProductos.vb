Public Class ListaFamiliaProductos
    Public items As New List(Of ResponseList_FamiliaProductos)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(id As String, nombre As String)
        Me.items.Add(New ResponseList_FamiliaProductos(id, nombre))
    End Sub
End Class
