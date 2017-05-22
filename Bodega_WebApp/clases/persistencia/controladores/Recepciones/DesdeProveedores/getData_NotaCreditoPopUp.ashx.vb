Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getData_NotaCreditoPopUp
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "aplication/json"
        Dim jsonSerializado As String = ""
        Dim criterio As String = context.Request("cmd")

        Select Case criterio
            Case "loadNC"
                jsonSerializado = getRecordsNCredito(context)
            Case "save-NC"
                jsonSerializado = saveRecordsNC(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function getRecordsNCredito(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim tipoBusqueda As Integer = 1
        Dim listaDeRecepciones As New ListaBRECEP
        Dim listaRecepciones As New List(Of Dictionary(Of String, String))

        jsonserializado = serializer.Serialize(listaDeRecepciones)
        Return jsonserializado

    End Function

    Public Function saveRecordsNC(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim estado As New Dictionary(Of String, String)

        Dim periodoNC As String = context.Request("periodoNC")
        Dim numeroOCNC As String = context.Request("numeroOCNC")
        Dim IDChileCompraNC As String = context.Request("IDChileCompraNC")
        Dim montoNC As String = context.Request("montoNC")
        Dim rutProvNC As String = context.Request("rutProvNC")
        Dim numeroFacNC As String = context.Request("numeroFacNC")
        Dim fechaFactNC As String = context.Request("fechaFactNC")
        Dim rutUserNC As String = context.Request("rutUserNC")
        Dim codBodegaNC As String = context.Request("codBodegaNC")
        Dim fechaActualNC As String = context.Request("fechaActualNC")
        Dim motivoNC As String = context.Request("motivoNC")

        estado = ControladorPersistencia.crearNotaCredito(periodoNC, numeroOCNC, IDChileCompraNC, montoNC, rutProvNC, numeroFacNC, fechaFactNC, rutUserNC, codBodegaNC, fechaActualNC, motivoNC)

        If (estado("FLD_NRONOTACRE") <> "0") Then
            jsonserializado = "{""status"":""succes"",""cmvNumero"":" & Trim(estado("FLD_NRONOTACRE")) & "}"
        Else
            jsonserializado = "{""status"":""error"",""message"":""Se presentó un problema en la base de datos vuelva a intentarlo mas tarde, si el problema persiste comuníquese con informática.""}"
        End If

        Return jsonserializado

    End Function

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class