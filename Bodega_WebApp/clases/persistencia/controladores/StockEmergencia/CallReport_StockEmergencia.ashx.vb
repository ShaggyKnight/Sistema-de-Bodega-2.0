Imports System.Web
Imports System.Web.Services

Public Class CallReport_StockEmergencia
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        ' * No se ocupa *

        'Datos que puede recibir el handler.
        Dim codigoBodega As String = ""
        Dim familia As String = ""
        Dim factorTrasf As String = ""
        Dim orden As String = ""

        context.Session("CodigoBodega") = ""
        context.Session("Familia") = ""
        context.Session("FactorTrasf") = ""
        context.Session("Orden") = ""

        codigoBodega = context.Request("codigoBodega").Replace(",", "")
        familia = context.Request("familia").Replace(",", "")
        factorTrasf = context.Request("factorTrasf").Replace(",", "")
        orden = context.Request("orden").Replace(",", "")

        context.Session("CodigoBodega") = codigoBodega
        context.Session("Familia") = familia
        context.Session("FactorTrasf") = factorTrasf
        context.Session("Orden") = orden

        'context.Response.Redirect("../../../../reportes/StockEmergencia/WebForm6.aspx")
        '../../reportes/StockEmergencia/WebForm6.aspx ..\..\..\reportes\StockEmergencia\WebForm6.aspx

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class