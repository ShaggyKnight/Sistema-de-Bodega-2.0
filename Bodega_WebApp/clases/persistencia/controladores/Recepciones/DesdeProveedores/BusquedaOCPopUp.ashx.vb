Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class BusquedaOCPopUp
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("cmd")

        Select Case cmd
            Case "get-records"
                jsonSerializado = BuscarOCPopUp(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function BuscarOCPopUp(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim serializer As New JavaScriptSerializer()
        Dim listOrdenesCompra As New List(Of Dictionary(Of String, String))
        Dim listaDeOrdenesCompra As New ListaOrdenesBOC
        Dim numeroOC As String = context.Request("numeroBOC")
        Dim periodo As String = context.Request("periodoBOC")
        Dim estado As String = context.Request("estadoBOC")
        Dim proveedor As String = context.Request("rutProveedorBOC")
        Dim chileCompra As String = context.Request("chileCompraBOC")

        If periodo = "undefined" Then
            periodo = ""
        End If
        If estado = "undefined" Then
            estado = ""
        End If
        If proveedor = "undefined" Then
            proveedor = ""
        End If
        If numeroOC = "undefined" Then
            numeroOC = ""
        End If
        If chileCompra = "undefined" Then
            chileCompra = ""
        End If

        listOrdenesCompra = ControladorPersistencia.getOrdenesCompraBOC(Trim(numeroOC), Trim(periodo), Trim(estado), Trim(proveedor), Trim(chileCompra.ToUpper()))

        For Each OrdenCompra As Dictionary(Of String, String) In listOrdenesCompra
            Dim newOrdenCompra As New OCBusquedaPopUp(listaDeOrdenesCompra.total, _
                                                      OrdenCompra("FLD_PERCODIGO"), _
                                                      OrdenCompra("FLD_OCONUMERO"), _
                                                      OrdenCompra("FLD_PRORAZONSOC"), _
                                                      OrdenCompra("FLD_OCPRECIO"), _
                                                      OrdenCompra("FLD_ID_CHILECOMPRA"), _
                                                      OrdenCompra("FLD_DESCRIPCION"))

            listaDeOrdenesCompra.setBOC(newOrdenCompra)

        Next

        jsonSerializado = serializer.Serialize(listaDeOrdenesCompra)
        Return jsonSerializado

    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class