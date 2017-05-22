Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class saveTempRecep_DevolucionxPrestamo
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"

        Dim cont As String = context.Request("cont")
        Dim NumeroDonacionArticulo As String = context.Request("NumeroDonacionArticulo")
        Dim fecha As String = context.Request("fecha")
        Dim NumeroCorrelativo As String = context.Request("NumeroCorrelativo")
        Dim CantidadMovimientoG As String = context.Request("CantidadMovimientoGeneral")
        Dim CantidadMovimientoD As String = context.Request("CantidadMovimientoDetalle")
        Dim CodigoMaterial As String = context.Request("CodigoMaterial")
        Dim NSerie As String = context.Request("NSerie")
        Dim FechaVto As String = context.Request("fechaVencimiento")
        Dim CodBodega As String = context.Request("CodBodega")
        Dim ItemArticulo As String = context.Request("ItemArticulo")
        Dim PrecioUni As String = context.Request("PrecioUni")


        Dim respuesta As New Dictionary(Of String, String)

        ControladorPersistencia.saveDetalleMovimiento_DevoluxPrestamo_Temp(cont, NumeroDonacionArticulo, fecha, NumeroCorrelativo,
                                               CantidadMovimientoG, CantidadMovimientoD, CodigoMaterial,
                                               NSerie, FechaVto, CodBodega, ItemArticulo, PrecioUni)
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