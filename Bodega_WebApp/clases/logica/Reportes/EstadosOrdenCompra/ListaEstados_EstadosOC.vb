Public Class ListaEstados_EstadosOC
    Public items As New List(Of ResponseList_EstadosOC)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(id As String, nombre As String)
        Me.items.Add(New ResponseList_EstadosOC(id, nombre))
    End Sub
End Class
