Public Class ResponseFormDateList
    Public fechaServidor As String
    Public anioDonacion As String

    Public Sub New(fechaCompleta As String, soloAnio As String)
        Me.fechaServidor = fechaCompleta
        Me.anioDonacion = soloAnio
    End Sub
End Class
