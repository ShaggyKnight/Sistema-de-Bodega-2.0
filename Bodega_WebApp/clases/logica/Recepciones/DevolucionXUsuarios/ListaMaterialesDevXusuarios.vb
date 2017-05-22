Public Class ListaMaterialesDevXusuarios
    Public status As String
    Public total As Integer
    Public records As List(Of MaterialDevXUsuario)

    Public Sub New()
        status = "success"
        total = 0
        records = New List(Of MaterialDevXUsuario)
    End Sub
    Public Sub setMaterial(ByVal material As MaterialDevXUsuario)
        records.Add(material)
        total += 1
    End Sub
End Class
