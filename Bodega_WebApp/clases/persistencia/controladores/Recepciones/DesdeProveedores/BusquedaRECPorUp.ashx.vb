Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class BusquedaRECPorUp
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "aplication/json"
        Dim jsonSerializado As String = ""
        Dim criterio As String = context.Request("criterioBusqueda")

        Select Case criterio
            Case "porRecepcion"
                'Buscar Recepción
                jsonSerializado = getRecordsRecepcion(context)
            Case "porOCompra"
                'Buscar Orden de Compra
                jsonSerializado = getRecordsOCompra(context)
            Case "OCxNroFactura"
                jsonSerializado = getOCxNroFactura(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function getRecordsRecepcion(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim tipoBusqueda As Integer = 1
        Dim nroRecepcion As String = context.Request("numeroRecBRECEP")
        Dim periodoRecep As String = context.Request("periodoBRECEP")
        Dim listaDeRecepciones As New ListaBRECEP
        Dim listaRecepciones As New List(Of Dictionary(Of String, String))

        If (nroRecepcion = "undefined" Or nroRecepcion = "") Then
            nroRecepcion = "0"
        End If

        If (periodoRecep = "undefined" Or periodoRecep = "") Then
            periodoRecep = "0"
        End If

        listaRecepciones = ControladorLogica.getRecepcionesBRECEP(Trim(nroRecepcion), Trim(periodoRecep), 0, "0", "0", tipoBusqueda)

        For Each recepcion As Dictionary(Of String, String) In listaRecepciones

            Dim nuevaRecepcion As New RecepBusquedaPopUp(listaDeRecepciones.total, _
                                                        recepcion("FLD_PERCODIGO") + "/" + recepcion("FLD_CMVNUMERO"), _
                                                        recepcion("FLD_RECFECHA"), _
                                                        recepcion("FLD_RECDESCRIPCION"), _
                                                        recepcion("FLD_PERCODIGO_OCO") + "/" + recepcion("FLD_OCONUMERO"), _
                                                        recepcion("FLD_PRORUT") + " " + recepcion("FLD_PRORAZONSOC"))
            listaDeRecepciones.setRecepcion(nuevaRecepcion)
        Next

        jsonserializado = serializer.Serialize(listaDeRecepciones)
        Return jsonserializado

    End Function

    Public Function getRecordsOCompra(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim tipoBusqueda As Integer = 2
        Dim nroOCompra As String = context.Request("numeroOCBRECEP")
        Dim periodoOCRecep As String = context.Request("periodoOCBRECEP")
        Dim estadoOCRecep As String = context.Request("estadoBRECEP")
        Dim listaDeRecepciones As New ListaBRECEP
        Dim listaRecepciones As New List(Of Dictionary(Of String, String))

        If (nroOCompra = "undefined" Or nroOCompra = "") Then
            nroOCompra = "0"
        End If

        If (periodoOCRecep = "undefined" Or periodoOCRecep = "") Then
            periodoOCRecep = "0"
        End If

        If (estadoOCRecep = "undefined" Or estadoOCRecep = "") Then
            estadoOCRecep = "0"
        End If

        listaRecepciones = ControladorLogica.getRecepcionesBRECEP(0, "0", Trim(nroOCompra), Trim(periodoOCRecep), Trim(estadoOCRecep), tipoBusqueda)

        For Each recepcion As Dictionary(Of String, String) In listaRecepciones

            Dim nuevaRecepcion As New RecepBusquedaPopUp(listaDeRecepciones.total, _
                                                            recepcion("FLD_PERCODIGO") + "/" + recepcion("FLD_CMVNUMERO"), _
                                                            recepcion("FLD_RECFECHA"), _
                                                            recepcion("FLD_RECDESCRIPCION"), _
                                                            recepcion("FLD_PERCODIGO_OCO") + "/" + recepcion("FLD_OCONUMERO"), _
                                                            recepcion("FLD_PRORUT") + " " + recepcion("FLD_PRORAZONSOC"))
            listaDeRecepciones.setRecepcion(nuevaRecepcion)
        Next

        serializer.MaxJsonLength = 50000000
        jsonserializado = serializer.Serialize(listaDeRecepciones)
        Return jsonserializado

    End Function
    Public Function getOCxNroFactura(ByVal context As HttpContext)

        Dim jsonserializado As String = ""
        Dim serializer As New JavaScriptSerializer
        Dim tipoBusqueda As Integer = 3
        Dim nroFactura As String = context.Request("NroFactura")
        Dim periodoRecep As String = context.Request("Periodo")
        'Dim listaDeRecepciones As New ListaBRECEP
        Dim listaDeRecepciones As New ListaOCxNroFactura
        Dim listaRecepciones As New List(Of Dictionary(Of String, String))

        If (nroFactura = "undefined" Or nroFactura = "") Then
            nroFactura = "0"
        End If

        If (periodoRecep = "undefined" Or periodoRecep = "") Then
            periodoRecep = ""
        End If

        listaRecepciones = ControladorPersistencia.getOCxNroFactura(Trim(nroFactura), Trim(periodoRecep), 0, "0", "0", tipoBusqueda)

        Dim recid As Integer = 1

        For Each recepcion As Dictionary(Of String, String) In listaRecepciones

            Dim nuevaRecepcion As New OCxFactura(recid, _
                                                    recepcion("FLD_CMVNUMERO"), _
                                                    recepcion("FLD_PERCODIGO"), _
                                                    recepcion("FLD_RECFECHA"), _
                                                    recepcion("FLD_RECDESCRIPCION"), _
                                                    recepcion("FLD_OCONUMERO"), _
                                                    recepcion("FLD_PRORUT") + " " + recepcion("FLD_PRORAZONSOC"))
            listaDeRecepciones.setRecepcion(nuevaRecepcion)
            recid = recid + 1
        Next

        jsonserializado = serializer.Serialize(listaDeRecepciones)
        Return jsonserializado

    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class