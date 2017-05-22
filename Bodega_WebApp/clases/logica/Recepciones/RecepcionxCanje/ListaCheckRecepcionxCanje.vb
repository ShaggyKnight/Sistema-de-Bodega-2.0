Public Class ListaCheckRecepcionxCanje
    Public check As New List(Of ResponseItemListCheck)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(numero As String, codigo As String, NRxCanje As String, descripcion As String, Nserielote As String, FechaVto As String)
        Me.check.Add(New ResponseItemListCheck(numero, codigo, NRxCanje, descripcion, Nserielote, FechaVto))
    End Sub
End Class
