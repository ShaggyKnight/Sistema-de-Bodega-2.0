Public Class ListaOrdenesBOC
    Public status As String
    Public total As Integer
    Public records As List(Of OCBusquedaPopUp)

    Public Sub New()
        records = New List(Of OCBusquedaPopUp)
        total = 0
    End Sub

    Public Sub setBOC(ByVal ordenCompra As OCBusquedaPopUp)
        Me.records.Add(ordenCompra)
        Me.total += 1
        Me.status = "success"
    End Sub
End Class
