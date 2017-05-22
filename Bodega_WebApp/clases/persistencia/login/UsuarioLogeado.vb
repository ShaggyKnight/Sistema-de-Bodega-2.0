Public Class UsuarioLogeado
    Public ReadOnly permisos As Permisos
    Public ReadOnly username As String
    Public ReadOnly nombre As String
    Public ReadOnly rut As String
    Public ReadOnly tipo As String
    Public ReadOnly centroDeCosto As String

    Public Sub New(ByVal username As String, _
                   ByVal nombre As String, _
                   ByVal rut As String, _
                   ByVal tipo As String, _
                   ByVal privilegio As String, _
                   ByVal centroDeCosto As String)
        Me.username = username
        Me.nombre = nombre
        Me.rut = rut
        Me.tipo = tipo
        Me.centroDeCosto = centroDeCosto
        Me.permisos = New Permisos(privilegio)
    End Sub


End Class
