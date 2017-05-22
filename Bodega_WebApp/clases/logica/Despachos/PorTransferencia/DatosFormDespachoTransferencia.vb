Public Class DatosFormDespachoTransferencia
    Public status As String
    Public record As List(Of DespachoXTransferencia)

    Public Sub New()
        Me.record = New List(Of DespachoXTransferencia)
        Me.status = "success"
    End Sub
    Public Sub setDatos(ByVal datosDespacho As DespachoXTransferencia)
        Me.record.Add(datosDespacho)
    End Sub
End Class
