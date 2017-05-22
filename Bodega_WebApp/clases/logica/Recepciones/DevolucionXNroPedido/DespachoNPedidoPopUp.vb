Public Class DespachoNPedidoPopUp
    Public recid As Integer
    Public periodoDespacho As String
    Public numeroPedido As Integer
    Public numeroDespacho As Integer
    Public fechaDespacho As String
    Public descripcion As String
    Public numeroDevolucion As String
    Public fechaDevolucion As String
    Public devDescripcion As String

    Public Sub New(ByVal recid As Integer, _
                   ByVal periodoDespacho As String, _
                   ByVal numeroPedido As String, _
                   ByVal numeroDespacho As String, _
                   ByVal fechaDespacho As String, _
                   ByVal descripcion As String, _
                   ByVal numeroDevolucion As String, _
                   ByVal fechaDevolucion As String, _
                   ByVal devDescripcion As String)
        Me.recid = recid
        Me.periodoDespacho = periodoDespacho
        Me.numeroPedido = numeroPedido
        Me.numeroDespacho = numeroDespacho
        Me.fechaDespacho = fechaDespacho
        Me.descripcion = descripcion
        Me.numeroDevolucion = numeroDevolucion
        Me.fechaDevolucion = fechaDevolucion
        Me.devDescripcion = devDescripcion

    End Sub
    Public Sub New()

    End Sub
End Class
