Public Class ListaProgramas
    Public items As New List(Of ResponseListProgramas)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(id As String, nombre As String)
        Me.items.Add(New ResponseListProgramas(id, nombre))
    End Sub
End Class
