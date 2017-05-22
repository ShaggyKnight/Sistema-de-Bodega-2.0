Public Class ListaMaterialesDespachoUsuarios
    Public status As String
    Public total As Integer
    Public records As List(Of Object)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
        Me.records = New List(Of Object)
    End Sub
    Public Sub setObjeto(ByVal objeto As Object)
        Me.records.Add(objeto)
        Me.total += 1
    End Sub
End Class
