Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getCorrelativo_Stock_CriMinMax
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest


        context.Response.ContentType = "texto/json"

        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("tipoBusqueda")
        Select Case cmd
            Case "BuscaCorrelativo"
                jsonSerializado = getCorrelativo(context)
            Case "DeleteTEMP"
                jsonSerializado = eliminaBusqueda(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function getCorrelativo(ByVal context As HttpContext)

        Dim json As New JavaScriptSerializer
        Dim articulo As New Dictionary(Of String, String)
        articulo = ControladorPersistencia.getCorrelativo_Stock_CriMinMax()
        Dim respuesta As String
        respuesta = json.Serialize(articulo)
        Return respuesta

    End Function
    Public Function eliminaBusqueda(ByVal context As HttpContext)

        Dim ID_TEMP As String = context.Request("Global_ID")

        Dim json As New JavaScriptSerializer
        Dim articulo As New Dictionary(Of String, String)
        articulo = ControladorPersistencia.Delete_TEMP_Stock_CriMinMax(ID_TEMP)
        Dim respuesta As String
        respuesta = json.Serialize(articulo)
        Return respuesta

    End Function

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class