﻿Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class buscaCorrelativoRecep_DevolucionxPrestamo
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "texto/json"
        Dim fecha As String = context.Request("fecha")
        Dim Ncorrelativo As String = context.Request("Ncorrelativo")
        Dim CodMaterial As String = context.Request("CodMaterial")

        Dim json As New JavaScriptSerializer
        Dim articulo As New Dictionary(Of String, String)
        articulo = ControladorPersistencia.BuscaCorrelativoRecep_DevolucionxPrestamo(fecha, Ncorrelativo, CodMaterial)
        Dim respuesta As String
        respuesta = json.Serialize(articulo)
        context.Response.Write(respuesta)

    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class