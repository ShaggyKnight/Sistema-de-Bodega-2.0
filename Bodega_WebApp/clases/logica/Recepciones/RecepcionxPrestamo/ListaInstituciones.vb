Public Class ListaInstituciones
    Public items As New List(Of ResponseItemList)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(id As String, nombre As String)
        Me.items.Add(New ResponseItemList(id, nombre))
    End Sub
End Class
