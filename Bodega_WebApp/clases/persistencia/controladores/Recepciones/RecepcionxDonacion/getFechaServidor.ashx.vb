Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getFechaServidor
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"

        Dim retorno As FechasdelaLista

        retorno = ControladorPersistencia.getListaFechasServidor()


        ' Tamaño de salida de datos
        Dim json As New JavaScriptSerializer

        Dim datosSerializados As String = json.Serialize(retorno)
        Dim inicioFin As Integer = datosSerializados.IndexOf("["c)
        Dim finFin As Integer = datosSerializados.Length
        Dim strTemp As String = (datosSerializados.Substring(0, inicioFin))
        strTemp = strTemp + (datosSerializados.Substring((inicioFin + 1), (finFin - (inicioFin + 3)))) + "}"


        context.Response.Write(strTemp)

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class