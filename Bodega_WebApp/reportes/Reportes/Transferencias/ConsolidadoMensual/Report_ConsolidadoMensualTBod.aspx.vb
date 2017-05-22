Public Class Report_ConsolidadoMensualTBod
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("añoBusqueda")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("mesIncio")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("mesTermino")
        ObjectDataSource1.SelectParameters(3).DefaultValue = Request.QueryString("BodegaDespacha")
        ObjectDataSource1.SelectParameters(4).DefaultValue = Request.QueryString("BodegaSolicita")


    End Sub

End Class