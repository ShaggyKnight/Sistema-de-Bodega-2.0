Public Class ListaItems_InveXItem
    Public items As New List(Of ResponseList_MaterialesBinCard)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(id As String, nombre As String)
        Me.items.Add(New ResponseList_MaterialesBinCard(id, nombre))
    End Sub
End Class
