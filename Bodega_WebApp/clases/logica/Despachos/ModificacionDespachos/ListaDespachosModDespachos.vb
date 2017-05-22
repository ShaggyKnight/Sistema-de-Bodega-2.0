Public Class ListaDespachosModDespachos
    Public status As String
    Public total As Integer
    Public records As List(Of DespachoModDespachos)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
        Me.records = New List(Of DespachoModDespachos)
    End Sub
    Public Sub setDespacho(ByVal despacho As DespachoModDespachos)
        Me.records.Add(despacho)
        Me.total += 1
    End Sub
End Class
