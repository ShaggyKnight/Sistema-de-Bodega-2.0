Public Class Repot_StockCritico_MinMax
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("id_Temp")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("codigoBodega")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("familia")

    End Sub

End Class