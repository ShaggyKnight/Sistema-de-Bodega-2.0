Public Class QR_RecepcionDesdeProveedores
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("TMVCodigo")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("PerCodigo")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("NroOC")
        ObjectDataSource1.SelectParameters(3).DefaultValue = Request.QueryString("PercodigoOC")
        ObjectDataSource1.SelectParameters(4).DefaultValue = Request.QueryString("IdChileCompra")
        ObjectDataSource1.SelectParameters(5).DefaultValue = Request.QueryString("Proveedor")
        ObjectDataSource1.SelectParameters(6).DefaultValue = Request.QueryString("NroRecepcion")
        ObjectDataSource1.SelectParameters(7).DefaultValue = Request.QueryString("fechaRecepcion")
        ObjectDataSource1.SelectParameters(8).DefaultValue = Request.QueryString("nroDocumento")

        ReportViewer1.LocalReport.EnableExternalImages = True
    End Sub

End Class