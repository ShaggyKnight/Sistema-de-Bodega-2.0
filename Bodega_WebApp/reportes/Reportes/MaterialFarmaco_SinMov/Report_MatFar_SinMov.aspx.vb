﻿Public Class Report_MatFar_SinMov
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ObjectDataSource1.SelectParameters(0).DefaultValue = Request.QueryString("FechaInicio")
        ObjectDataSource1.SelectParameters(1).DefaultValue = Request.QueryString("FechaTermino")
        ObjectDataSource1.SelectParameters(2).DefaultValue = Request.QueryString("bodega")
        ObjectDataSource1.SelectParameters(3).DefaultValue = Request.QueryString("Stock")
    End Sub

End Class