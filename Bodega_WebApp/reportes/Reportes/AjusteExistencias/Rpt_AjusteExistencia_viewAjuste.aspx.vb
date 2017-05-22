Public Class Rpt_AjusteExistencia_viewAjuste
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("PerCodigo")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("CmvCodigo")

        ReportViewer1.LocalReport.DisplayName = Request.QueryString("nombreReport")

    End Sub

End Class