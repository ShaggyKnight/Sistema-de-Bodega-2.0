Public Class DatosFormDespachoUsuarios
    Public status As String
    Public record As List(Of DespachoHaciaUsuarios)

    Public Sub New()
        Me.record = New List(Of DespachoHaciaUsuarios)
        Me.status = "success"
    End Sub
    Public Sub setDatos(ByVal datosDespacho As DespachoHaciaUsuarios)
        Me.record.Add(datosDespacho)
    End Sub
End Class
