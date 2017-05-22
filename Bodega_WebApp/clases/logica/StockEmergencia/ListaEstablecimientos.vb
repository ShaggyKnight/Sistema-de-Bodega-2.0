Public Class ListaEstablecimientos
    Public items As New List(Of ResponseList_Establecimientos)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(id As String, nombre As String)
        Me.items.Add(New ResponseList_Establecimientos(id, nombre))
    End Sub
End Class
