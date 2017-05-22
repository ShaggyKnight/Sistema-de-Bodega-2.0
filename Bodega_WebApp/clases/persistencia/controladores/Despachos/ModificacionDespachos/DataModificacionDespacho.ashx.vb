Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class DataModificacionDespacho
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("tipoBusqueda")

        Select Case cmd
            Case "ListaPeriodos"
                jsonSerializado = getDatosSelect(context)
            Case "buscaDespachos"
                jsonSerializado = obtieneDespachos(context)
            Case "guardaCambios"
                jsonSerializado = guardaDescripcion(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function guardaDescripcion(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim estado As New Dictionary(Of String, String)
        Dim percodigo As String = Trim(context.Request("periodo"))
        Dim nroDespacho As String = Trim(context.Request("nroDespacho"))
        Dim descripcion As String = Trim(context.Request("descipcion"))

        estado = ControladorPersistencia.actualizaDescripcionDespacho(percodigo, nroDespacho, descripcion)

        If (estado("ERROR") <> "0") Then
            jsonSerializado = "{""status"":""error"",""messagge"":""Se presento el siguiente error: " & estado("ERROR") & " vuelva a intentarlo mas tarde. Si el problema persiste comuniquese con informática""}"
        Else
            jsonSerializado = "{""status"":""success""}"
        End If


    End Function
    Public Function obtieneDespachos(ByVal context As HttpContext)

        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listDespachos As New List(Of Dictionary(Of String, String))
        Dim listaDeDespachos As New ListaDespachosModDespachos
        Dim percodigo As String = Trim(context.Request("periodo"))
        Dim nroDespacho As String = Trim(context.Request("numeroDespacho"))
        Dim limiteDatos As Integer = Integer.Parse(context.Request("limit"))
        Dim limiteInferior As Integer = Integer.Parse(context.Request("limit"))
        Dim contador As Integer = Integer.Parse(context.Request("contador"))
        Dim total As String

        limiteDatos = limiteDatos * (contador + 1)
        limiteInferior = limiteInferior * contador

        listDespachos = ControladorPersistencia.getListaDespachosModDespachos(percodigo, nroDespacho, limiteDatos, limiteInferior)

        If (listDespachos(0).Item("error") = "0") Then

            For Each dataDespacho As Dictionary(Of String, String) In listDespachos

                Dim despacho As New DespachoModDespachos(Trim(dataDespacho("RNumber")), _
                                                       Trim(dataDespacho("FLD_PERCODIGO")), _
                                                       Trim(dataDespacho("FLD_CMVNUMERO")), _
                                                       Trim(dataDespacho("FLD_DESFECHA")), _
                                                       Trim(dataDespacho("FLD_DESDESCRIPCION")), _
                                                       Trim(dataDespacho("FLD_PBONUMERO")))

                listaDeDespachos.setDespacho(despacho)
                total = Trim(dataDespacho("TOTAL"))
            Next

            listaDeDespachos.total = total
            serializer.MaxJsonLength = 30000000
            jsonSerializado = serializer.Serialize(listaDeDespachos)

        Else

            jsonSerializado = "{""status"":""error"",""messagge"":" & listDespachos(0).Item("error") & "}"
        End If

        Return jsonSerializado

    End Function
    Public Function getDatosSelect(ByVal context As HttpContext)
        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listPeriodos As New List(Of Dictionary(Of String, String))
        Dim ListaDePeriodos As New ListaObjetosSelectBox

        listPeriodos = ControladorPersistencia.getListaPeriodos()

        For Each datosPeriodo As Dictionary(Of String, String) In listPeriodos
            Dim Periodo As New ObjetoSelectBox(Trim(datosPeriodo("percodigo")), Trim(datosPeriodo("pernombre")))
            ListaDePeriodos.setObjeto(Periodo)
        Next

        jsonSerializado = serializer.Serialize(ListaDePeriodos)
        Return jsonSerializado

    End Function

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class