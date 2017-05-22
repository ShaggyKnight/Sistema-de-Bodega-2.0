Public Class ListaMaterialesRecepCenabast
    Public status As String
    Public total As Integer
    Public records As List(Of MaterialRecepCenabast)

    Public Sub New()
        status = "success"
        total = 0
        records = New List(Of MaterialRecepCenabast)
    End Sub
    Public Sub setMaterial(ByVal material As MaterialRecepCenabast)
        records.Add(material)
        total += 1
    End Sub
End Class
