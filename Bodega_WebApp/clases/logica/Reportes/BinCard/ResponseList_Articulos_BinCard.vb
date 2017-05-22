Public Class ResponseList_Articulos_BinCard
    Public recid As String
    Public fecha As String
    Public TipoMov As String
    Public NDocumento As String
    Public valorNeto As String
    Public fisicoEntrada As String
    Public salida As String
    Public saldo As String
    Public valorEntrada As String
    Public salidaE As String
    Public saldoE As String
    Public precioPonderado As String
    Public observacion As String
    Public codItem As String
    Public descripcionItem As String

    Public Sub New(i As Integer, fecha As String, codigo As String, NumeroDocumento As String,
                   neto As String, cantidadEntrada As String, cantidadSalida As String, cantidadSaldo As String,
                   costoEntradaV As String, cantidadSalidaV As String, cantidadSaldoEntradaV As String,
                   ponderado As String, observacion1 As String, codigoItem As String, descripcion1 As String)

        Me.recid = i
        Me.fecha = fecha
        Me.TipoMov = codigo
        Me.NDocumento = NumeroDocumento
        Me.valorNeto = neto
        Me.fisicoEntrada = cantidadEntrada
        Me.salida = cantidadSalida
        Me.saldo = cantidadSaldo
        Me.valorEntrada = costoEntradaV
        Me.salidaE = cantidadSalidaV
        Me.saldoE = cantidadSaldoEntradaV
        Me.precioPonderado = ponderado
        Me.observacion = observacion1
        Me.codItem = codigoItem
        Me.descripcionItem = descripcion1

    End Sub
End Class
