Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getProveedores_EstadosOC
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest


        context.Response.ContentType = "texto/json"

        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("tipoBusqueda")
        Select Case cmd
            Case "ConRut"
                jsonSerializado = getProveedoresConRut(context)
            Case "ConRazonSocial"
                jsonSerializado = getProveedoresConRazonSocial(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub

    Public Function getProveedoresConRut(ByVal context As HttpContext)

        context.Response.ContentType = "application/json"
        Dim retorno As ListaProeedores_EstadosOC

        Dim rut As String = context.Request("RUT")

        retorno = ControladorPersistencia.getProveedores_EstadosOC(rut, 1)

        Dim json As New JavaScriptSerializer
        json.MaxJsonLength = 50000000
        context.Response.Write(json.Serialize(retorno))

    End Function

    Public Function getProveedoresConRazonSocial(ByVal context As HttpContext)

        context.Response.ContentType = "application/json"
        Dim retorno As ListaProeedores_EstadosOC

        Dim razon As String = context.Request("razonSocial")
        retorno = ControladorPersistencia.getProveedores_EstadosOC(razon, 2)

        Dim json As New JavaScriptSerializer
        json.MaxJsonLength = 50000000
        context.Response.Write(json.Serialize(retorno))

    End Function


    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class