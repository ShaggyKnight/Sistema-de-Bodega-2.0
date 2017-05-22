Public Class RecepBusquedaPopUp
    Public recid As String
    Public codigoRECEP As String
    Public fechaBRECEP As String
    Public descripcionBRECEP As String
    Public numeroOCRECEP As String
    Public proveedorBRECEP As String

    Public Sub New(ByVal recid As Integer, _
                   ByVal codigo As String, _
                   ByVal fecha As String, _
                   ByVal descripcion As String, _
                   ByVal numero As String, _
                   ByVal proveedor As String)

        Me.recid = recid
        Me.codigoRECEP = codigo
        Me.fechaBRECEP = fecha
        Me.descripcionBRECEP = descripcion
        Me.numeroOCRECEP = numero
        Me.proveedorBRECEP = proveedor

    End Sub
    Public Sub New()

    End Sub
End Class
