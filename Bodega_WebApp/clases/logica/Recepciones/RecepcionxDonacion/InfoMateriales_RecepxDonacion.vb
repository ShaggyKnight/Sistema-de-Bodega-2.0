Public Class InfoMateriales_RecepxDonacion
    Public recid As String
    Public FLD_MATCODIGO As String
    Public FLD_MATNOMBRE As String
    Public FLD_EXIPRECIOUNITARIO As String
    Public FLD_ITECODIGO As String

    Public Sub New(i As Integer, Mcodigo As String, MNombre As String, MValor As String, MItem As String)
        Me.recid = i
        Me.FLD_MATCODIGO = Mcodigo
        Me.FLD_MATNOMBRE = MNombre
        Me.FLD_EXIPRECIOUNITARIO = MValor
        Me.FLD_ITECODIGO = MItem
    End Sub
End Class
