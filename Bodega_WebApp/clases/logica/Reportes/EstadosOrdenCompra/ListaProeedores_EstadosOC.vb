Public Class ListaProeedores_EstadosOC
    Public status As String
    Public total As Integer
    Public records As New List(Of ResponseList_ProveedoresEstadosOC)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(i As Integer, rut As String, razonSocial As String, direccion As String,
                   fono As String, ciudad As String, contacto As String, rutSinDigito As String)
        Me.records.Add(New ResponseList_ProveedoresEstadosOC(i, rut, razonSocial, direccion, fono, ciudad, contacto, rutSinDigito))
        Me.total = Me.total + 1
    End Sub
End Class
