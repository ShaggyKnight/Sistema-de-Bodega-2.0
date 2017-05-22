Public Class Servidores
    Public ReadOnly servidores As List(Of Servidor)
    Public ReadOnly idPorDefecto As Integer = 2
    Private Sub New()
        servidores = New List(Of Servidor)
        Me.agregarServidorALista(1, "Desarrollo", "10.6.29.64\COLOSO")
        Me.agregarServidorALista(2, "Servidor Pruebas", "10.6.51.56")
        'Me.agregarServidorALista(2, "Hospital Antofagasta", "10.6.29.54")
    End Sub

    Private Sub agregarServidorALista(ByVal id As Integer, ByVal nombre As String, ByVal stringConexion As String)
        servidores.Add( _
            New Servidor(id, nombre, stringConexion) _
        )
    End Sub

    Public Shared ReadOnly Property Instancia As Servidores
        Get
            Static Instance As Servidores = New Servidores
            Return Instance
        End Get
    End Property

    Public Function getIpServidor(ByVal ideServidor) As String
        For Each servidor As Servidor In servidores
            If servidor.id = ideServidor Then
                Return servidor.stringConexion
            End If
        Next
        Throw New Exception("Servidor seleccionado no existe en nuestro registro interno.")
    End Function
End Class
