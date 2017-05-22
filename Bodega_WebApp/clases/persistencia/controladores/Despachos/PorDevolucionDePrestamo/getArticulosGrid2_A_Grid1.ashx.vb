Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getArticulosGrid2_A_Grid1
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "texto/json"
        Dim codigo As String = context.Request("codigo")
        Dim periodo As String = context.Request("Periodo")
        Dim numero As String = context.Request("Numero")

        Dim json As New JavaScriptSerializer
        Dim retorno As ListaDeArticulosHistorial_XDevolucionDePrestamo
        retorno = ControladorPersistencia.getArticulosGrid2_A_Grid1(codigo, periodo, numero)
        Dim respuesta As String
        respuesta = json.Serialize(retorno)
        context.Response.Write(respuesta)

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class