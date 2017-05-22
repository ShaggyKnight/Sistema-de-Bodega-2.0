Public Class IngresoProductoDetalle
    Public cantidad As String
    Public numeroDeLote As String
    Public numeroDeSerie As String
    Public fechaVencimiento As String

    Public Sub New()
    End Sub

    Public Sub New(ByVal cantidad As String, _
        ByVal numeroDeLote As String, _
        ByVal numeroDeSerie As String, _
        ByVal fechaVencimiento As String)
        Me.cantidad = cantidad
        Me.numeroDeLote = numeroDeLote
        Me.numeroDeSerie = numeroDeSerie
        Me.fechaVencimiento = fechaVencimiento
    End Sub

    Public Sub setDetalle(ByVal cantidad As String, _
        ByVal numeroDeLote As String, _
        ByVal numeroDeSerie As String, _
        ByVal fechaVencimiento As String)
        Me.cantidad = cantidad
        Me.numeroDeLote = numeroDeLote
        Me.numeroDeSerie = numeroDeSerie
        Me.fechaVencimiento = fechaVencimiento
    End Sub
End Class
