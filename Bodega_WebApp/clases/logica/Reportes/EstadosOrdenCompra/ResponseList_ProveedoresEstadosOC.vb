Public Class ResponseList_ProveedoresEstadosOC
    Public recid As String
    Public FULL_RUT As String
    Public FLD_PRORAZONSOC As String
    Public FLD_PRODIRECCION As String
    Public FLD_PROFONO As String
    Public FLD_PROCIUDAD As String
    Public FLD_PROCONTACTO As String
    Public FLD_PRORUT As String
    Public Sub New(i As Integer, rut As String, razonSocial As String, direccion As String,
                   fono As String, ciudad As String, contacto As String, rutSinDigito As String)
        Me.recid = i
        Me.FULL_RUT = rut
        Me.FLD_PRORAZONSOC = razonSocial
        Me.FLD_PRODIRECCION = direccion
        Me.FLD_PROFONO = fono
        Me.FLD_PROCIUDAD = ciudad
        Me.FLD_PROCONTACTO = contacto
        Me.FLD_PRORUT = rutSinDigito
    End Sub
End Class
