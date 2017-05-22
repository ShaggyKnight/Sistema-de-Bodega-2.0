Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getListaDatosSelect
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("cmd")
        Dim campoACargar As String = context.Request("campoDeCarga")
        Select Case campoACargar
            Case "proveedor"
                jsonSerializado = getListaProveedores(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub

    Public Function getListaProveedores(ByVal context As HttpContext)
        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listProveedores As New List(Of Dictionary(Of String, String))
        Dim listaDeProveedores As New ListaObjetosSelectBox

        listProveedores = ControladorPersistencia.getListaProveedores()

        For Each datosProveedor As Dictionary(Of String, String) In listProveedores
            Dim proveedor As New ObjetoSelectBox(datosProveedor("FLD_PRORUT"), datosProveedor("FLD_PRORAZONSOC"))
            listaDeProveedores.setObjeto(proveedor)
        Next

        jsonSerializado = serializer.Serialize(listaDeProveedores)

        Return jsonSerializado
    End Function

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class