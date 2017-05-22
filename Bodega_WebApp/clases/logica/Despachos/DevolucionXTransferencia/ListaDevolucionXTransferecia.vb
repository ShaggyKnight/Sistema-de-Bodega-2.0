Public Class ListaDevolucionXTransferecia
    Public status As String
    Public total As Integer
    Public records As List(Of DatosGridBuscar_DevoXTransferencia)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
        Me.records = New List(Of DatosGridBuscar_DevoXTransferencia)
    End Sub

    Public Sub ingresaTransferencia(ByVal transferencia As DatosGridBuscar_DevoXTransferencia)
        Me.records.Add(transferencia)
        Me.total += 1
    End Sub
End Class
