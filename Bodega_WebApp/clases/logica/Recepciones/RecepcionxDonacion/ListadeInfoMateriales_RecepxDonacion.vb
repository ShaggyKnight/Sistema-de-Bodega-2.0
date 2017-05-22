Public Class ListadeInfoMateriales_RecepxDonacion
    Public status As String
    Public total As Integer
    Public records As New List(Of InfoMateriales_RecepxDonacion)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(i As Integer, Mcodigo As String, MNombre As String, MValor As String, MItem As String)
        Me.records.Add(New InfoMateriales_RecepxDonacion(i, Mcodigo, MNombre, MValor, MItem))
        Me.total = Me.total + 1
    End Sub
End Class
