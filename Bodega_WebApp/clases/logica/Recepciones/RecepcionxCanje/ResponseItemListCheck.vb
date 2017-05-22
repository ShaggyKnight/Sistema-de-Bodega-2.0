Public Class ResponseItemListCheck
    Public Numero As String
    Public codigo As String
    Public RCanje As String
    Public RDescripcion As String
    Public NSerie As String
    Public FechaVto As String

    Public Sub New(numero As String, codigo As String, NRxCanje As String, descripcion As String,
                   Nserielote As String, FechaVto As String)
        Me.Numero = numero
        Me.codigo = codigo
        Me.RCanje = NRxCanje
        Me.RDescripcion = descripcion
        Me.NSerie = Nserielote
        Me.FechaVto = FechaVto
    End Sub
End Class
