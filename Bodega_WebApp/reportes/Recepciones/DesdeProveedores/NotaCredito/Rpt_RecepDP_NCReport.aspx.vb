Public Class Rpt_RecepDP_NCReport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("numeroNC")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("periodoNC")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("numeroOCNC")
        ObjectDataSource1.SelectParameters(3).DefaultValue = Request.QueryString("numeroFacNC")

        ReportViewer1.LocalReport.DisplayName = Request.QueryString("nombreReport")
    End Sub

End Class