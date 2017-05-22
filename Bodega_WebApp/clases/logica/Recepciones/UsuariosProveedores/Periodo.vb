Public Class Periodo
    Public id As String
    Public text As String

    Public Sub New()

    End Sub
    Public Sub New(ByVal percodigo As String, ByVal pernombre As String)
        Me.id = percodigo
        Me.text = pernombre
    End Sub
End Class
