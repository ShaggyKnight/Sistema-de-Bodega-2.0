Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class SaveTemp_BinCard
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"

        Dim id_Temp As Integer = Convert.ToInt32(context.Request("id_Temp"))
        Dim fecha As String = context.Request("fecha")
        Dim TipoMov As String = context.Request("TipoMov")
        Dim NDoc As Integer = Convert.ToInt32(context.Request("NDoc"))
        Dim PrecioNeto As String = context.Request("PrecioNeto")
        Dim FisicoEntrada As String = context.Request("FisicoEntrada")
        Dim Salida As String = context.Request("Salida")
        Dim Saldo As String = context.Request("Saldo")
        Dim ValEntrada As String = context.Request("ValEntrada")
        Dim SalidaV As String = context.Request("SalidaV")
        Dim SaldoV As String = context.Request("SaldoV")
        Dim PrecioPonderado As String = context.Request("PrecioPonderado")
        Dim Obsevacion As String = context.Request("Obsevacion")
        Dim CodItem As String = context.Request("CodItem")
        Dim Descripcion As String = context.Request("Descripcion")
        Dim Bodega As String = context.Request("Bodega")
        Dim CodMaterial As String = context.Request("CodMaterial")
        Dim AnioBincard As String = context.Request("AnioBincard")

        Dim Usuario As UsuarioLogeado = context.Session("usuarioLogeado")

        Dim respuesta As New Dictionary(Of String, String)

        ControladorPersistencia.SaveTemp_BinCard(id_Temp, fecha, TipoMov, NDoc,
                                               PrecioNeto, FisicoEntrada, Salida, Saldo, ValEntrada,
                                               SalidaV, SaldoV, PrecioPonderado, Obsevacion, CodItem, Descripcion,
                                               Usuario.username, Bodega, CodMaterial, AnioBincard)
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