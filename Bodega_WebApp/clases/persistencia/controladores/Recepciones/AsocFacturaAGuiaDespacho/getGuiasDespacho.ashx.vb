Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports ClosedXML.Excel

Public Class getGuiasDespacho
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("tipoBusqueda")
        Select Case cmd
            Case "bTodas"
                jsonSerializado = getGuiasDespacho(context, 0)
            Case "bConFactura"
                jsonSerializado = getGuiasDespacho(context, 1)
            Case "bSinFactura"
                jsonSerializado = getGuiasDespacho(context, 2)
            Case "cargaForm"
                jsonSerializado = getDatosForm()
            Case "grabarGuia"
                ' Graba los datos de las guias modificadas
                jsonSerializado = guardarGuiaFactura(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function guardarGuiaFactura(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim validate As Integer
        Dim serializer As New JavaScriptSerializer
        Dim nroGuia As String = context.Request("guia")
        Dim nroRecepcion As String = context.Request("recepcion")
        Dim añorecepcion As String = context.Request("añoRecepcion")
        Dim nroFactura As String = context.Request("nroFactura")
        Dim rutProveedor As String = context.Request("rutProveedor")

        validate = ControladorPersistencia.guardarGuiasFactura(nroGuia, nroRecepcion, añorecepcion, nroFactura, rutProveedor)

        If (validate = 0) Then
            jsonSerializado = "{""status"":""success""}"
        Else
            jsonSerializado = "{""status"":""error"",""message"":""Ocurrio un ERROR en la Base de Datos vuelva a intentarlo mas tarde o consulte con informática.""}"
        End If

        Return jsonSerializado

    End Function
    'Decuelve las guias en base a los criterios especificados y el tipo de busqueda realizada
    Public Function getGuiasDespacho(ByVal context As HttpContext, ByVal tipoBusqueda As Integer)
        Dim jsonSerializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim proveedor As String = context.Request("proveedor")
        Dim factura As Integer = Integer.Parse(context.Request("nroFactura"))
        Dim percodigo As String = context.Request("percodigo")
        Dim nroGuia As Integer = Integer.Parse(context.Request("nroGuia"))
        Dim listaGuias As List(Of Dictionary(Of String, String))
        Dim GuiasFactura As New ListaGuiasFactura
        If (percodigo = "" Or percodigo = "undefined") Then
            percodigo = ControladorPersistencia.getFechaServidor().Year
        End If

        listaGuias = ControladorPersistencia.getGuiasFactura(proveedor, tipoBusqueda, factura, Integer.Parse(percodigo), nroGuia)

        For Each GuiaFactura As Dictionary(Of String, String) In listaGuias
            Dim nuevaGuia As New GuiaFactura(GuiasFactura.total + 1, _
                                             GuiaFactura("GUIA"), _
                                             GuiaFactura("FLD_CMVNUMERO"), _
                                             GuiaFactura("FLD_PERCODIGO"), _
                                             GuiaFactura("FLD_OCONUMERO"), _
                                             GuiaFactura("FLD_PERCODIGO_OCO"), _
                                             GuiaFactura("FACTURA"))
            GuiasFactura.setGuia(nuevaGuia)
        Next

        jsonSerializado = serializer.Serialize(GuiasFactura)
        Return jsonSerializado

    End Function
    'Devuelve los datos por default para el form de informacion de busqueda
    Public Function getDatosForm()

        Dim jsonSrializado As String = ""
        Dim añoServidor As DateTime

        añoServidor = ControladorPersistencia.getFechaServidor()

        jsonSrializado = "{""status"":""success"",""record"":{""periodoGuia"":" + añoServidor.Year.ToString + ",""numeroGuia"":" + 0.ToString + ",""numeroFactura"":" + 0.ToString + "}}"
        Return jsonSrializado
    End Function
    
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class