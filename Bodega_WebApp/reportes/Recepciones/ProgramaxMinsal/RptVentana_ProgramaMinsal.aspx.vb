Public Class RptVentana_ProgramaMinsal
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("CMVCodigo")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("PERCodigo")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("TMVCodigo")
        ObjectDataSource1.SelectParameters(3).DefaultValue = Request.QueryString("usuario")
    End Sub

End Class