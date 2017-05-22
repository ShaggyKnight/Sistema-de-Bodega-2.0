Public Class Report_InveRealExistencia
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("codigoBodega")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("familia")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("IncluirCero")
        ObjectDataSource1.SelectParameters(3).DefaultValue = Request.QueryString("orden")
        ObjectDataSource1.SelectParameters(4).DefaultValue = Request.QueryString("Establecimiento")
    End Sub

End Class