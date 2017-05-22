Public Class ListaMotivoAjuste
    Public items As New List(Of MotivoAjuste)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(ByVal id As String, ByVal nombre As String)
        Me.items.Add(New MotivoAjuste(id, nombre))
    End Sub
End Class
