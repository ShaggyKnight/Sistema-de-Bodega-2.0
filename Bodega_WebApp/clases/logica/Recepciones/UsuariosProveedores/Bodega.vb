Public Class Bodega
    Public id As String
    Public text As String

    Public Sub New()

    End Sub
    Public Sub New(ByVal codigo As String, ByVal nombre As String)
        Me.id = codigo
        Me.text = nombre
    End Sub
End Class
