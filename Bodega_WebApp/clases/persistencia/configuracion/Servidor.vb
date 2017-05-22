Public Class Servidor
    Public Property nombre As String
    Public Property stringConexion As String
    Public Property id As Integer


    Sub New(ByVal id As Integer, ByVal nombre As String, ByVal stringConexion As String)
        Me.id = id
        Me.nombre = nombre
        Me.stringConexion = stringConexion
    End Sub

End Class
