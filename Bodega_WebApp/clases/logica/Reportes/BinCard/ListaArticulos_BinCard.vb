Public Class ListaArticulos_BinCard
    Public status As String
    Public total As Integer
    Public records As New List(Of ResponseList_Articulos_BinCard)

    Public Sub New()
        Me.status = "success"
        Me.total = 0
    End Sub

    Public Sub AgregarRecords(i As Integer, fecha As String, codigo As String, NumeroDocumento As String,
                   neto As String, cantidadEntrada As String, cantidadSalida As String, cantidadSaldo As String,
                   costoEntradaV As String, cantidadSalidaV As String, cantidadSaldoEntradaV As String, ponderado As String, observacion1 As String,
                   codigoItem As String, descripcion1 As String)
        Me.records.Add(New ResponseList_Articulos_BinCard(i, fecha, codigo, NumeroDocumento, neto, cantidadEntrada,
                                                          cantidadSalida, cantidadSaldo, costoEntradaV, cantidadSalidaV,
                                                          cantidadSaldoEntradaV, ponderado, observacion1, codigoItem,
                                                          descripcion1))
        Me.total = Me.total + 1
    End Sub
End Class
