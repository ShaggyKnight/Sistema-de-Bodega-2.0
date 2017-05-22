Public Class ListaObjetosSelectBox
    Public status As String
    Public items As List(Of ObjetoSelectBox)

    Public Sub New()
        items = New List(Of ObjetoSelectBox)
    End Sub
    Public Sub setObjeto(ByVal itemDeLista As ObjetoSelectBox)
        Me.items.Add(itemDeLista)
    End Sub
End Class
