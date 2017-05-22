Public Class QR_DevolucionxPrestamo
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("ID")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("PerCodigo")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("Bodega")
        ObjectDataSource1.SelectParameters(3).DefaultValue = Request.QueryString("fechaOperacion")
        ReportViewer1.LocalReport.EnableExternalImages = True
    End Sub

End Class