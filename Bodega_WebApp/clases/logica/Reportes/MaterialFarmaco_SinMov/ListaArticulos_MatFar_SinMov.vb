Public Class ListaArticulos_MatFar_SinMov
    Public status As String
    Public total As Integer
    Public records As New List(Of ResponseList_Articulos_MatFar_SinMov)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(i As Integer, Codigo As String, Nombre As String, Stock As String,
                            Fecha As String, NumUltimoMov As String, TipoMov As String, TipoStock As String)
        Me.records.Add(New ResponseList_Articulos_MatFar_SinMov(i, Codigo, Nombre, Stock,
                                                                Fecha, NumUltimoMov, TipoMov, TipoStock))
        Me.total = Me.total + 1
    End Sub
End Class
