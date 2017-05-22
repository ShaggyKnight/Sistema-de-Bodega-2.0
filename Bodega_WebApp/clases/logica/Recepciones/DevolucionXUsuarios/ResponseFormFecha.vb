Public Class ResponseFormFecha
    Public fechaServidor As String
    Public periodo As String

    Public Sub New(ByVal fechaCompleta As String, ByVal soloAnio As String)
        Me.fechaServidor = fechaCompleta
        Me.periodo = soloAnio
    End Sub
End Class
