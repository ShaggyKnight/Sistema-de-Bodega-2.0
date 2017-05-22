Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getArticlosAGrid1xPrestamo
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim retorno As ListaDevoPrestamo

        Dim numero As Integer = Convert.ToInt32(context.Request("NumeroPrestamo"))
        Dim fecha As String = context.Request("FechaPrestamo")

        retorno = ControladorPersistencia.cargaHistorial_Grid1_DevoxPrestamo(numero, fecha)

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