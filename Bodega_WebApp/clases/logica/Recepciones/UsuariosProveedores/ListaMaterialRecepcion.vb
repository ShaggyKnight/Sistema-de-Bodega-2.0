Public Class ListaMaterialRecepcion
    Public status As String
    Public total As Integer
    Public records As New List(Of Material)
    Public Sub New()
    End Sub
    Public Sub New(ByVal status As String, ByVal total As Integer)
        Me.status = status
        Me.total = total
        Me.records = New List(Of Material)
    End Sub

    Public Sub AgregarRecords(ByVal codigo As String, ByVal nombre As String, ByVal unidad As String, ByVal cantidadARecibir As String, ByVal valor As String, ByVal iteCodigo As String, ByVal total As String)
        Me.records.Add(New Material(codigo, nombre, unidad, cantidadARecibir, 1, 0, valor, iteCodigo, 0, cantidadARecibir, total))
        Me.total = Me.total + 1
        'Me.articulo.Add(New Material(codigo, nombre, unidad, cantidadARecibir, factor, cantidad, valor, iteCodigo, recepcionFactura, recepcionado, total))
    End Sub
End Class