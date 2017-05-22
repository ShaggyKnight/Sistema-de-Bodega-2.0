Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class cargaHistorialxFechaPMinsal
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim retorno As historialDonacionesProgramaMinsal

        Dim fecha As String = context.Request("FechaDonacion")
        retorno = ControladorPersistencia.cargaHistorialxFecha_ProgramaMinsal(fecha)

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