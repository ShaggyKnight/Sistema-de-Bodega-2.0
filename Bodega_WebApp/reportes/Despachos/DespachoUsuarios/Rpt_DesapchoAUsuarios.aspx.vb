Public Class Rpt_DesapchoAUsuarios
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("CmvCodigo")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("PerCodigo")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("TMVCodigo")
        ObjectDataSource1.SelectParameters(3).DefaultValue = Request.QueryString("usuario")

        ReportViewer1.LocalReport.DisplayName = Request.QueryString("nombreReport")
    End Sub

End Class