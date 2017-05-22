Public Class ListaMaterial

    Public status As String
    Public total As Integer
    Public records As List(Of Material)

    Public Sub New()
        Me.records = New List(Of Material)
    End Sub
    Public Sub New(ByVal status As String, ByVal total As Integer)
        Me.status = status
        Me.total = total
        Me.records = New List(Of Material)
    End Sub
    Public Sub setRecord(ByVal material As Material)
        Me.records.Add(material)
    End Sub
    Public Sub setListaRecords(ByVal materiales As List(Of Material))
        Me.records = materiales
    End Sub
End Class
