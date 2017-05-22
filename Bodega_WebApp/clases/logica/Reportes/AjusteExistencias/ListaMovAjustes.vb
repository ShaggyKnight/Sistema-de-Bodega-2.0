Public Class ListaMovAjustes
    Public status As String
    Public total As Integer
    Public records As New List(Of MovsAjuste)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(ByVal recid As Integer, ByVal NumAjuste As String, ByVal anio As String, ByVal fecha As String, ByVal descrip As String, ByVal bodega As String)
        Me.records.Add(New MovsAjuste(recid, NumAjuste, anio, fecha, descrip, bodega))
        Me.total = Me.total + 1
    End Sub
End Class
