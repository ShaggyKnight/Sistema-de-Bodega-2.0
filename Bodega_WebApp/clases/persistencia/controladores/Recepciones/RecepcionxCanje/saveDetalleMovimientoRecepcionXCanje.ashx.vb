Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class saveDetalleMovimientoRecepcionXCanje
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"

        Dim codigo As String = context.Request("codigo")
        Dim periodo As String = context.Request("Periodo")
        Dim numero As String = context.Request("Numero")
        Dim movimiento As String = context.Request("MovCantidad")
        Dim codBodega As String = context.Request("codBodega")
        Dim matCodigo As String = context.Request("matCodigo")
        Dim item As String = context.Request("itemCodigo")
        Dim precio As String = context.Request("precioUnitario")
        Dim Nserie As String = context.Request("NSerie")
        Dim fechaVto As String = context.Request("fechaVencimiento")

        Dim respuesta As New Dictionary(Of String, String)

        ControladorPersistencia.saveDetalleMovimientoRecepcionXCanje(codigo, periodo, numero, movimiento, codBodega, matCodigo, item, precio, Nserie, fechaVto)

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