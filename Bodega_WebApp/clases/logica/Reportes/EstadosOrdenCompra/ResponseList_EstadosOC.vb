﻿Public Class ResponseList_EstadosOC
    Public id As String
    Public text As String

    Public Sub New(id As String, nombre As String)
        Me.id = id
        Me.text = nombre
    End Sub
End Class
