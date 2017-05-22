Public Class OrdenDeCompra

    Public numeroOC As String
    Public periodo As String
    Public rutProveedor As String
    Public estadoOC As String
    Public precio As String
    Public codigoBodega As String
    Public nombreBodega As String
    Public descripcion As String

    Public Sub New(ByVal numeroOC As String, _
        ByVal periodo As String, _
        ByVal rutProveedor As String, _
        ByVal estadoOC As String, _
        ByVal precio As String, _
        ByVal codigoBodega As String, _
        ByVal nombreBodega As String, _
        ByVal descripcion As String)

        Me.numeroOC = numeroOC
        Me.periodo = periodo
        Me.rutProveedor = rutProveedor
        Me.estadoOC = estadoOC
        Me.precio = precio
        Me.codigoBodega = codigoBodega
        Me.nombreBodega = nombreBodega
        Me.descripcion = descripcion

    End Sub

    Public Sub New()
        Me.numeroOC = ""
        Me.periodo = ""
        Me.rutProveedor = ""
        Me.estadoOC = ""
        Me.precio = ""
        Me.codigoBodega = ""
        Me.nombreBodega = ""
        Me.descripcion = ""
    End Sub
End Class
