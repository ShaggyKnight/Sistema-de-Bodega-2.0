Public Class ResponseDateListDespacho
    Public fechaServidor As String
    Public anioPrestamo As String

    Public Sub New(fechaCompleta As String, soloAnio As String)
        Me.fechaServidor = fechaCompleta
        Me.anioPrestamo = soloAnio
    End Sub
End Class
