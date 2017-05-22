Public Class _Default
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            Dim newTable As New DataTable

            newTable.Columns.Add("Cantidad")
            newTable.Columns.Add("NroSerie")
            newTable.Columns.Add("Lote")
            newTable.Columns.Add("FechaVencimiento")


            newTable.Rows.Add("000", "225522", "E0025", "10/08/2013")
            newTable.Rows.Add("000", "000000", "A5689", "26/11/2013")
            newTable.Rows.Add("000", "------", "T0206", "05/06/2014")

           
            detalleMaterialGrid.DataSource = newTable
            detalleMaterialGrid.DataBind()

        End If
    End Sub
    
End Class