Public Class OCxFactura
    Public recid As String
    Public NroRecep As String
    Public periodoRecep As String
    Public fechaRecep As String
    Public descripcion As String
    Public NroOC As String
    Public Proveedor As String

    Public Sub New(ByVal recid As Integer, _
                   ByVal nroFactura As String, _
                   ByVal periodo As String, _
                   ByVal fecha As String, _
                   ByVal descripcion As String, _
                   ByVal numeroOC As String, _
                   ByVal proveedor As String)

        Me.recid = recid
        Me.NroRecep = nroFactura
        Me.periodoRecep = periodo
        Me.fechaRecep = fecha
        Me.descripcion = descripcion
        Me.NroOC = numeroOC
        Me.Proveedor = proveedor

    End Sub
    Public Sub New()

    End Sub
End Class