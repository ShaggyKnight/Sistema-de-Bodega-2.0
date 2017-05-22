Public Class ResponseFechaENLista
    Public fechaServidor As String
    Public anioDonacion As String
    Public anioPrestamo As String

    Public Sub New(ByVal fechaCompleta As String, ByVal soloAnio As String)
        Me.fechaServidor = fechaCompleta
        Me.anioDonacion = soloAnio
        Me.anioPrestamo = soloAnio
    End Sub
End Class
