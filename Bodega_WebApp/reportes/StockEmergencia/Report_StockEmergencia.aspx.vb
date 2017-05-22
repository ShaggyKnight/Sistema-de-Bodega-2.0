
Public Class Report_StockEmergencia
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("codigoBodega")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("familia")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("factorTras")
        ObjectDataSource1.SelectParameters(3).DefaultValue = Request.QueryString("orden")

        'Command.CommandTimeout = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings("SqlCommandTimeOut"))

    End Sub

End Class