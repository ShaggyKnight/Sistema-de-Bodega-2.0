Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class validaDetalleMaterial
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("cmd")

        Select Case cmd
            Case "soloValida"
                jsonSerializado = soloValida(context)
            Case "validaTraeFVto"
                jsonSerializado = validaTraeFVto(context)
            Case "validaNserie"
                jsonSerializado = validaNserie(context)
        End Select

        context.Response.Write(jsonSerializado)
        context.Response.ContentType = "application/json"

    End Sub
    Public Function soloValida(ByVal context As HttpContext)

        Dim codMaterial As String = context.Request("codMaterial")
        Dim Bodega As String = context.Request("Bodega")
        Dim Nserie As String = context.Request("Nserie")
        Dim tipoMovimiento As Integer = 1

        Dim validar As Integer
        Dim respuesta As New Dictionary(Of String, String)

        validar = Convert.ToInt32(ControladorPersistencia.validaSiExisteElMaterial(codMaterial, Bodega, Nserie, tipoMovimiento))

        If validar = 1 Then
            respuesta.Add("item", "fail")
        Else
            respuesta.Add("item", "done")
        End If

        ' Tamaño de salida de datos
        Dim json As New JavaScriptSerializer
        json.MaxJsonLength = 50000000
        Return json.Serialize(respuesta)

    End Function
    Public Function validaTraeFVto(ByVal context As HttpContext)

        Dim codMaterial As String = context.Request("codMaterial")
        Dim Bodega As String = context.Request("Bodega")
        Dim Nserie As String = context.Request("Nserie")
        Dim tipoMovimiento As Integer = 2

        Dim respuesta As New Dictionary(Of String, String)

        respuesta = ControladorPersistencia.validaSiExisteElMaterial(codMaterial, Bodega, Nserie, tipoMovimiento)

        ' Tamaño de salida de datos
        Dim json As New JavaScriptSerializer
        json.MaxJsonLength = 50000000
        Return json.Serialize(respuesta)

    End Function
    Public Function validaNserie(ByVal context As HttpContext)

        'Dim tmvCodigo As String = context.Request("TmvCodigo")
        Dim Bodega As String = context.Request("Bodega")
        Dim codMaterial As String = context.Request("codMaterial")
        Dim Nserie As String = context.Request("Nserie")

        Dim respuesta As New Dictionary(Of String, String)

        respuesta = ControladorPersistencia.validaNserie(Bodega, codMaterial, Nserie)

        ' Tamaño de salida de datos
        Dim json As New JavaScriptSerializer
        json.MaxJsonLength = 50000000
        Return json.Serialize(respuesta)

    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class