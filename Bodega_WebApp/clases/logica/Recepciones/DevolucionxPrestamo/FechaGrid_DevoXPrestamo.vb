Public Class FechaGrid_DevoXPrestamo
    Public status As String
    Public record As New List(Of ResponseFechaENLista)

    Public Sub New()
        Me.status = "success"
    End Sub

    Public Sub AgregarRecords(ByVal fechaServer As String, ByVal anioDonacion As String)
        Me.record.Add(New ResponseFechaENLista(fechaServer, anioDonacion))
    End Sub
End Class
