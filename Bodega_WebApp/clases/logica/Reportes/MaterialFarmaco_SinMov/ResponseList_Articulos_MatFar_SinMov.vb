Public Class ResponseList_Articulos_MatFar_SinMov
    Public recid As String
    Public codigo As String
    Public nombre As String
    Public stock As String
    Public fecha As String
    Public NumUltimoMov As String
    Public tipoMov As String
    Public tipoStock As String

    Public Sub New(i As Integer, Codigo As String, Nombre As String, Stock As String,
                   Fecha As String, NumUltimoMov As String, TipoMov As String, TipoStock As String)
        Me.recid = i
        Me.codigo = Fecha
        Me.nombre = Codigo
        Me.stock = Stock
        Me.fecha = Fecha
        Me.NumUltimoMov = NumUltimoMov
        Me.tipoMov = TipoMov
        Me.tipoStock = TipoStock
    End Sub
End Class
