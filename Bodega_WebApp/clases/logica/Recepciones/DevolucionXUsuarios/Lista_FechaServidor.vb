Public Class Lista_FechaServidor
    Public status As String
    Public record As New List(Of ResponseFormFecha)

    Public Sub New()
        Me.status = "success"
    End Sub

    Public Sub AgregarRecords(ByVal fechaServer As String, ByVal anioDonacion As String)
        Me.record.Add(New ResponseFormFecha(fechaServer, anioDonacion))
    End Sub
End Class