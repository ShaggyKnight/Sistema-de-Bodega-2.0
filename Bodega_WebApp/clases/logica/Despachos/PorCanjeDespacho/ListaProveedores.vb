Public Class ListaProveedores
    Public items As New List(Of ResponseListProveedores)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(id As String, nombre As String)
        Me.items.Add(New ResponseListProveedores(id, nombre))
    End Sub
End Class
