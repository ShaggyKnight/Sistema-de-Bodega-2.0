Public Class ListaCentroC_DespaXPauta
    Public items As New List(Of ResponseList_CentroCostos)

    Public Sub New()
    End Sub

    Public Sub AgregarRecords(id As String, nombre As String)
        Me.items.Add(New ResponseList_CentroCostos(id, nombre))
    End Sub
End Class
