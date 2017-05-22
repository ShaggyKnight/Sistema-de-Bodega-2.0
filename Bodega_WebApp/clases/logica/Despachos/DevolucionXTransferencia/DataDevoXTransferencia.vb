Public Class DataDevoXTransferencia
    Public status As String
    Public record As List(Of Encabezado_DevoXTransferencia)

    Public Sub New()
        Me.status = "success"
        Me.record = New List(Of Encabezado_DevoXTransferencia)
    End Sub

    Public Sub agregarInfo(ByVal info As Encabezado_DevoXTransferencia)
        Me.record.Add(info)
    End Sub
End Class
