Public Class ListaPeriodo
    Public items As New List(Of ResponseList_Periodo)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(id As String, nombre As String)
        Me.items.Add(New ResponseList_Periodo(id, nombre))
    End Sub
End Class
