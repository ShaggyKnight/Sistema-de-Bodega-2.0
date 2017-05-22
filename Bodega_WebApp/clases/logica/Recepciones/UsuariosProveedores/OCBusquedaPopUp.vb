Public Class OCBusquedaPopUp
    Public recid As Integer
    Public añoBOC As String
    Public numeroBOC As String
    Public proveedorBOC As String
    Public PrecioBOC As String
    Public idChileComBOC As String
    Public estadoBOC As String

    Public Sub New(ByVal recid As Integer, _
                   ByVal periodo As String, _
                   ByVal numeroOc As String, _
                   ByVal proveedor As String, _
                   ByVal precio As String, _
                   ByVal chileCompra As String, _
                   ByVal estadoOC As String)

        Me.recid = recid
        Me.añoBOC = periodo
        Me.numeroBOC = numeroOc
        Me.proveedorBOC = proveedor
        Me.PrecioBOC = precio
        Me.idChileComBOC = chileCompra
        Me.estadoBOC = estadoOC
    End Sub
    Public Sub New()

    End Sub

End Class
