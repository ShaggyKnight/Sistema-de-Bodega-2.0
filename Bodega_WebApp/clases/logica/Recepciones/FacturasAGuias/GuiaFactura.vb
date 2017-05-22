Public Class GuiaFactura
    Public recid As String
    Public guia As String
    Public recepcion As String
    Public añoRecepcion As String
    Public nroOC As String
    Public añoOC As String
    Public nroFactura As String

    Public Sub New()

    End Sub
    Public Sub New(ByVal recid As String, _
                   ByVal guia As String, _
                   ByVal recepcion As String, _
                   ByVal añoRecepcion As String, _
                   ByVal nroOC As String, _
                   ByVal añoOC As String, _
                   ByVal nroFactura As String)

        Me.recid = recid
        Me.guia = guia
        Me.recepcion = recepcion
        Me.añoRecepcion = añoRecepcion
        Me.nroOC = nroOC
        Me.añoOC = añoOC
        Me.nroFactura = nroFactura

    End Sub
End Class
