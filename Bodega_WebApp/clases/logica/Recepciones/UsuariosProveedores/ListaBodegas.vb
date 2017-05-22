Public Class ListaBodegas
    'Public status As String = "success"
    Public items As List(Of Bodega)

    Public Sub New()
        items = New List(Of Bodega)
    End Sub
    Public Sub setBodega(ByVal bodega As Bodega)
        items.Add(bodega)
    End Sub
    Public Sub detBodegas(ByVal lista As List(Of Bodega))
        Me.items = lista
    End Sub
End Class
