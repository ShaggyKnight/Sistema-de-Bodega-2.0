Public Class ListaMaterialesAjuste

    Public status As String
    Public total As Integer
    Public records As New List(Of MaterialDetalleAjuste)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(ByVal recid As Integer, ByVal tipoMov As String, ByVal anio As String, ByVal numMov As String, ByVal codMaterial As String, ByVal cantMov As String, ByVal existencia As String, ByVal nserie As String, ByVal fechaVto As String)
        Me.records.Add(New MaterialDetalleAjuste(recid, tipoMov, anio, numMov, codMaterial, cantMov, existencia, nserie, fechaVto))
        Me.total = Me.total + 1
    End Sub
End Class
