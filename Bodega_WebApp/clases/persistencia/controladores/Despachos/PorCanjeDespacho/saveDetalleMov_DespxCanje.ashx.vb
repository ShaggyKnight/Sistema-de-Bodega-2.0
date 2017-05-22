Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class saveDetalleMov_DespxCanje
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim cont As String = context.Request("cont")
        Dim NumeroDonacionArticulo As String = context.Request("NumeroDonacionArticulo")
        Dim fecha As String = context.Request("fecha")
        Dim NumeroCorrelativo As String = context.Request("NumeroCorrelativo")
        Dim CantidadMovimiento As String = context.Request("CantidadMovimiento")
        Dim dbodega As String = context.Request("dbodega")
        Dim CodigoMaterial As String = context.Request("CodigoMaterial")
        Dim ItemMaterial As String = context.Request("ItemMaterial")
        Dim null As String = context.Request("null")
        Dim null2 As String = context.Request("null2")
        Dim null3 As String = context.Request("null3")
        Dim PrecioUnitario As String = context.Request("PrecioUnitario")
        Dim loteSerie As String = context.Request("NSerie")
        Dim fechaVencimiento As String = context.Request("fechaVencimiento")


        Dim respuesta As New Dictionary(Of String, String)

        ControladorPersistencia.saveDetalleMov_DespxCanje(cont, NumeroDonacionArticulo, fecha, NumeroCorrelativo,
                                                    CantidadMovimiento, dbodega, CodigoMaterial,
                                                    ItemMaterial, null, null2, null3, PrecioUnitario, loteSerie, fechaVencimiento)
        respuesta.Add("item", "done")

        ' Tamaño de salida de datos
        Dim json As New JavaScriptSerializer
        json.MaxJsonLength = 50000000
        context.Response.Write(json.Serialize(respuesta))

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class