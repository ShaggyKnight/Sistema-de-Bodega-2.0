Public Class DevolucionUsuario
    Public recid As Integer
    Public cmvNumero As Integer
    Public periodo As String
    Public bodCodigo As String
    Public usuLogin As String
    Public descripcion As String
    Public codCentroCosto As String
    Public fechaDevolucion As String

    Public Sub New(ByVal recid As Integer, _
                   ByVal cmvNumero As Integer, _
                   ByVal periodo As String, _
                   ByVal bodCodigo As String, _
                   ByVal usuLogin As String, _
                   ByVal descripcion As String, _
                   ByVal codCentroCosto As String, _
                   ByVal fechaDevolucion As String)
        Me.recid = recid
        Me.cmvNumero = cmvNumero
        Me.periodo = periodo
        Me.bodCodigo = bodCodigo
        Me.usuLogin = usuLogin
        Me.descripcion = descripcion
        Me.codCentroCosto = codCentroCosto
        Me.fechaDevolucion = fechaDevolucion
    End Sub

End Class
