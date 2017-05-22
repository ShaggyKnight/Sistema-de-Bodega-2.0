Public Class ListaDetallesMaterial
    Public status As String = "succes"
    Public total As Integer = 0
    Public records As New List(Of DetallesMaterial)

    Public Sub New()
    End Sub
    Public Sub setDetalleMaterial(ByVal detalleMaterial As DetallesMaterial)
        Me.records.Add(detalleMaterial)
    End Sub
    Public Sub setDetalleMaterialDespacho(ByVal detalleMaterial As DetallesMaterial)
        Me.records.Add(detalleMaterial)
        Me.total += 1
    End Sub

End Class
