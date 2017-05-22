Public Class FechasdelaLista
    Public status As String
    Public record As New List(Of ResponseFormDateList)

    Public Sub New()
        Me.status = "success"
    End Sub

    Public Sub AgregarRecords(fechaServer As String, anioDonacion As String)
        Me.record.Add(New ResponseFormDateList(fechaServer, anioDonacion))
    End Sub
End Class
