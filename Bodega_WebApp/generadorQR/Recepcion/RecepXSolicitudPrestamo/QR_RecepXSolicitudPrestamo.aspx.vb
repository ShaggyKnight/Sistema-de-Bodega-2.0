Public Class QR_RecepXSolicitudPrestamo
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("TMVCodigo")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("PerCodigo")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("ID")
        ObjectDataSource1.SelectParameters(3).DefaultValue = Request.QueryString("fechaOperacion")
        ObjectDataSource1.SelectParameters(4).DefaultValue = Request.QueryString("Proveedor")
        ReportViewer1.LocalReport.EnableExternalImages = True
    End Sub

End Class