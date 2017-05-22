Public Class Report_TransfEntreBodegasDetalle
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("FechaInicio")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("FechaTermino")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("BodegaDespacha")
        ObjectDataSource1.SelectParameters(3).DefaultValue = Request.QueryString("BodegaSolicita")
        ObjectDataSource1.SelectParameters(4).DefaultValue = Request.QueryString("DetalleSN")

        'ObjectDataSource1.SelectParameters(0).DefaultValue = "01/01/2012"
        'ObjectDataSource1.SelectParameters(1).DefaultValue = "01/12/2014"
        'ObjectDataSource1.SelectParameters(2).DefaultValue = "BOD004"
        'ObjectDataSource1.SelectParameters(3).DefaultValue = "BOD029"
        'ObjectDataSource1.SelectParameters(4).DefaultValue = "1"
    End Sub

End Class