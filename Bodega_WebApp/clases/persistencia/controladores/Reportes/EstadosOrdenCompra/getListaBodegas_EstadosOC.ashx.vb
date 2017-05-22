Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getListaBodegas_EstadosOC
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"

        Dim usuario As UsuarioLogeado = context.Session("usuarioLogeado")
        Dim establecimiento = ControladorPersistencia.getEstablecimiento(usuario.centroDeCosto)

        Dim retorno As ListaBodega

        retorno = ControladorPersistencia.getListaBodegas_EstadosOC(usuario.centroDeCosto, establecimiento.Substring(0, establecimiento.IndexOf("-") - 1))

        ' Tamaño de salida de datos
        Dim json As New JavaScriptSerializer
        json.MaxJsonLength = 50000000
        context.Response.Write(json.Serialize(retorno))

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class