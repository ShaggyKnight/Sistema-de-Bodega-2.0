Public Class detalleMateriales
    Inherits System.Web.UI.Page

    Protected listaMateriales As Dictionary(Of String, IngresoProducto)
    Protected listaDetallesMaterial As List(Of IngresoProductoDetalle)
    Protected idPadre As String
    Dim newTable As New DataTable

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            idPadre = Request.Form("codigoPadre")
            listaMateriales = Session.Contents("listaDeMateriales")
        End If
        If IsPostBack Then
            idPadre = Request.Form("postback")
            Dim cantidades As String() = Context.Request.Form.GetValues("cantidadDetalleMat")
            Dim series As String() = Context.Request.Form.GetValues("nroSerieDetalleMat")
            Dim lotes As String() = Context.Request.Form.GetValues("nroLoteDetalleMat")
            Dim Fechasvencimiento As String() = Context.Request.Form.GetValues("fechaVencimiento")

            listaMateriales = Session.Contents("listaDeMateriales")
            listaMateriales(idPadre).detalles.Clear()
            For index = 0 To cantidades.Count() - 1
                Dim detalle As New IngresoProductoDetalle(cantidades(index), lotes(index), series(index), Fechasvencimiento(index))
                listaMateriales(idPadre).AgregarDetalle(detalle)
            Next
            'Session("listaDeMateriales") = listaMateriales
        End If
        listaDetallesMaterial = listaMateriales(idPadre).detalles

    End Sub

End Class