Public Class listHistorialMinsal
    Public recid As String
    Public FLD_PERCODIGO As String
    Public FLD_CMVNUMERO As String
    Public Fld_Minfecha As String
    Public Fld_NroDoc As String
    Public Fld_MinDescrip As String
    Public Fld_MovPrecio As String
    Public Programa As String

    Public Sub New(i As Integer, fecha As String, codigo As String, fechaCompleta As String,
                   NroDoc As String, MinDescrip As String, MovPrecio As String, Programa As String)
        Me.recid = i
        Me.FLD_PERCODIGO = fecha
        Me.FLD_CMVNUMERO = codigo
        Me.Fld_Minfecha = fechaCompleta
        Me.Fld_NroDoc = NroDoc
        Me.Fld_MinDescrip = MinDescrip
        Me.Fld_MovPrecio = MovPrecio
        Me.Programa = Programa
    End Sub
End Class
