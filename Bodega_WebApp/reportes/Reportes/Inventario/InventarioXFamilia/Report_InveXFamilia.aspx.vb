Public Class Report_InveXFamilia
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("CodBodega")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("CodFamilia")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("FechaActual")
        ObjectDataSource1.SelectParameters(3).DefaultValue = Request.QueryString("Establecimiento")
        ReportViewer1.LocalReport.EnableExternalImages = True
    End Sub

End Class