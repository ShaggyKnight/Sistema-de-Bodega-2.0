Imports DocumentFormat.OpenXml.Spreadsheet
Imports ClosedXML
Imports ClosedXML.Excel
Imports System.Web.Script.Serialization


Public Class DownloadExcelGuiasFactura
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim cmd As String = Context.Request("tipoBusqueda")
        Select Case cmd
            Case "1"
                getGuiasDespacho(Context, 0)
            Case "2"
                getGuiasDespacho(Context, 1)
            Case "3"
                getGuiasDespacho(Context, 2)
        End Select

    End Sub
    Public Sub getGuiasDespacho(ByVal context As HttpContext, ByVal tipoBusqueda As Integer)

        Dim jsonSerializado As String = ""
        Dim tablaGuias As New DataTable
        Dim proveedor As String = context.Request("proveedor")
        Dim factura As Integer = Integer.Parse(context.Request("nroFactura"))
        Dim percodigo As String = context.Request("periodo")
        Dim nroGuia As Integer = Integer.Parse(context.Request("nroGuia"))
        Dim nombreProveedor As String = context.Request("nombreProveedor")
        nombreProveedor = nombreProveedor.Replace("amperSand", "&")
        Dim listaGuias As List(Of Dictionary(Of String, String))

        If (percodigo = "" Or percodigo = "undefined") Then
            percodigo = ControladorPersistencia.getFechaServidor().Year
        End If

        listaGuias = ControladorPersistencia.getGuiasFactura(proveedor, tipoBusqueda, factura, Integer.Parse(percodigo), nroGuia)

        tablaGuias.TableName = "Asociación de Guias a Factura"

        tablaGuias.Columns.Add("Nº Guia", GetType(Integer))
        tablaGuias.Columns.Add("Nº Recepcion", GetType(Integer))
        tablaGuias.Columns.Add("Año Recepcion", GetType(Integer))
        tablaGuias.Columns.Add("Nº O. Compra", GetType(Integer))
        tablaGuias.Columns.Add("Año O. Compra", GetType(Integer))
        tablaGuias.Columns.Add("Nº Factura", GetType(Integer))

        For Each GuiaFactura As Dictionary(Of String, String) In listaGuias

            tablaGuias.Rows.Add(GuiaFactura("GUIA"), _
                                GuiaFactura("FLD_CMVNUMERO"), _
                                GuiaFactura("FLD_PERCODIGO"), _
                                GuiaFactura("FLD_OCONUMERO"), _
                                GuiaFactura("FLD_PERCODIGO_OCO"), _
                                GuiaFactura("FACTURA"))
        Next

        Response.Clear()
        Response.ContentType =
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        Response.AddHeader("content-disposition", "attachment;filename=Lista_Guias_Factura.xlsx")

        Using memoryStream As New IO.MemoryStream()
            Dim exportExcel As New XLWorkbook()
            Dim Worksheet = exportExcel.Worksheets.Add("GuiasAFactura")

            Worksheet.Cell(2, 2).Value = "Lista de Guias Asociadas a Factura"
            Worksheet.Range(2, 2, 2, 7).Merge().AddToNamed("Titles")
            Worksheet.Cell(3, 2).Value = "Proveedor:"
            Worksheet.Cell(3, 3).Value = nombreProveedor
            Worksheet.Range(3, 3, 3, 7).Merge()
            Worksheet.Cell(4, 2).Value = "Periodo:"
            Worksheet.Cell(4, 3).Value = percodigo
            Worksheet.Cell(4, 4).Value = "Guia:"
            Worksheet.Cell(4, 5).Value = nroGuia
            Worksheet.Cell(4, 6).Value = "Factura:"
            Worksheet.Cell(4, 7).Value = factura
            Worksheet.Cell(6, 2).InsertTable(tablaGuias.AsEnumerable)

            Dim titlesStyle = exportExcel.Style
            titlesStyle.Font.Bold = True
            titlesStyle.Alignment.Horizontal = XLAlignmentHorizontalValues.Center
            titlesStyle.Fill.BackgroundColor = XLColor.FromHtml("#0174DF")
            titlesStyle.Font.FontColor = XLColor.White

            exportExcel.NamedRanges.NamedRange("Titles").Ranges.Style = titlesStyle

            Worksheet.Columns().AdjustToContents()
            exportExcel.SaveAs(memoryStream)
            memoryStream.WriteTo(Response.OutputStream)
        End Using
        Response.End()

    End Sub
End Class