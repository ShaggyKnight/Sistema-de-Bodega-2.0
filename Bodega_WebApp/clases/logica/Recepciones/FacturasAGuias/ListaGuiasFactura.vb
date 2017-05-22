Public Class ListaGuiasFactura
    Public status As String
    Public total As String
    Public records As List(Of GuiaFactura)

    Public Sub New()
        Me.records = New List(Of GuiaFactura)
        total = 0
        status = "success"
    End Sub
    Public Sub setGuia(ByVal guia As GuiaFactura)
        Me.records.Add(guia)
        total += 1
    End Sub
End Class
