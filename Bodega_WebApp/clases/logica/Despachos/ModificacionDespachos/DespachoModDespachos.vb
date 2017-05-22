Public Class DespachoModDespachos
    Public recid As Integer
    Public periodo As String
    Public nroDespacho As String
    Public fechaDespacho As String
    Public descripcion As String
    Public nroPedido As String

    Public Sub New(ByVal recid As Integer, _
                   ByVal periodo As String, _
                   ByVal nroDespacho As String, _
                   ByVal fechaDespacho As String, _
                   ByVal descripcion As String, _
                   ByVal nroPedido As String)

        Me.recid = recid
        Me.periodo = periodo
        Me.nroDespacho = nroDespacho
        Me.fechaDespacho = fechaDespacho
        Me.descripcion = descripcion
        Me.nroPedido = nroPedido
    End Sub
End Class
