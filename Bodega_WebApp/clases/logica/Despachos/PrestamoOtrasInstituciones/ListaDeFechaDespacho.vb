Public Class ListaDeFechaDespacho
    Public status As String
    Public record As New List(Of ResponseDateListDespacho)

    Public Sub New()
        Me.status = "success"
    End Sub

    Public Sub AgregarRecords(fechaServer As String, anioPrestamo As String)
        Me.record.Add(New ResponseDateListDespacho(fechaServer, anioPrestamo))
    End Sub
End Class
