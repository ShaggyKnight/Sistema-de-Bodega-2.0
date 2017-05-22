Public Class MovsAjuste

    Public recid As String
    Public NroAjuste As String
    Public periodoAjuste As String
    Public fechaAjuste As String
    Public descripcion As String
    Public BodAjuste As String

    Public Sub New(ByVal recid As Integer, ByVal NumAjuste As String, ByVal anio As String, ByVal fecha As String, ByVal descrip As String, ByVal bodega As String)
        Me.recid = recid
        Me.NroAjuste = NumAjuste
        Me.periodoAjuste = anio
        Me.fechaAjuste = fecha
        Me.descripcion = descrip
        Me.BodAjuste = bodega
    End Sub

End Class
