Public Class Configuracion
    Public Shared Function cssAbsoluto(ByRef page As Page, ByVal ruta As String) As String
        Return "<link href=""" & page.ResolveClientUrl("~") & ruta & """ rel=""stylesheet"" type=""text/css"" />"
    End Function

    Public Shared Function javascriptAbsoluto(ByRef page As Page, ByVal ruta As String) As String
        Return "<script type=""text/javascript"" src=""" & page.ResolveClientUrl("~") & ruta + """></script>"
    End Function
End Class
