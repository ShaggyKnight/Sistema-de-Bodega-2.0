Public Class Report_InveXItem2
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("Bodega")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("Item")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("Establecimiento")

    End Sub

End Class