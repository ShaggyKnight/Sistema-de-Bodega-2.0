Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class getDetalleMaterial
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim NroOCompra As String = context.Request("idoc")
        Dim codMaterial As String = context.Request("codigoMaterial")
        Dim periodoOC As String = context.Request("periodo")
        Dim cmd As String = context.Request("cmd")
        Dim jsonSerializado As String = ""

        Select Case cmd
            Case "get-records"
                jsonSerializado = getRecords(context)
            Case "save-records"
                'Graba el detalle del material.
                jsonSerializado = saveRecords(NroOCompra, context, periodoOC)
            Case "getRecordsParaQR"
                'Graba el detalle del material.
                jsonSerializado = getRecordsParaQR(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    Public Function getRecords(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim listaDetallesMaterial As New List(Of Dictionary(Of String, String))
        Dim nroRecepcion As String = context.Request("nroRecepcion")
        Dim NroOCompra As String = context.Request("idoc")
        Dim codMaterial As String = context.Request("codigoMaterial")
        Dim periodoOC As String = context.Request("periodo")
        Dim listDetMats As New ListaDetallesMaterial()
        Dim serializer As New JavaScriptSerializer()
        Dim count As Integer = 1

        Try

            listaDetallesMaterial = ControladorPersistencia.getDetallesMateriales(NroOCompra, codMaterial, periodoOC, nroRecepcion)

            For Each detalleMaterial As Dictionary(Of String, String) In listaDetallesMaterial
                Dim detMaterial As New DetallesMaterial(count, _
                                                        codMaterial, _
                                                        detalleMaterial("FLD_CANTIDAD"), _
                                                        detalleMaterial("FLD_LOTE"), _
                                                        detalleMaterial("FLD_LOTE"), _
                                                        detalleMaterial("FLD_FECHAVENCIMIENTO").ToString)

                listDetMats.setDetalleMaterial(detMaterial)
                listDetMats.total += 1
                count += 1
            Next

            jsonSerializado = serializer.Serialize(listDetMats)

            Return jsonSerializado

        Catch ex As Exception

            jsonSerializado = "{""status"":""error"",""   message"":" + ex.ToString + "}"
            Return jsonSerializado
        End Try
    End Function
    Public Function saveRecords(ByVal NroOCompra As String, ByVal context As HttpContext, ByVal periodo As String)

        Dim serializer As New JavaScriptSerializer()
        Dim estado As Integer = 1
        Dim codMaterial As String = context.Request("codigoMaterial")
        Dim RecordsLength = context.Request("largoGrid")
        Dim listaDetalles As List(Of Dictionary(Of String, String)) = New List(Of Dictionary(Of String, String))

        estado = ControladorPersistencia.limpiarTemporalDetalles(NroOCompra, codMaterial)

        If estado = 0 Then

            For i As Integer = 0 To RecordsLength - 1

                Dim detalle As Dictionary(Of String, String) = New Dictionary(Of String, String)

                detalle.Add("codigoMaterial", codMaterial)
                detalle.Add("nroOCompra", NroOCompra)
                detalle.Add("periodo", periodo)
                If context.Request(i.ToString + "[changes][cantidad]") <> Nothing Then

                    detalle.Add("cantidad", context.Request(i.ToString + "[changes][cantidad]"))

                Else

                    detalle.Add("cantidad", context.Request(i.ToString + "[cantidad]"))

                End If
                If context.Request(i.ToString + "[changes][loteSerie]") <> Nothing Then

                    detalle.Add("nroLote", UCase(context.Request(i.ToString + "[changes][loteSerie]")))
                    detalle.Add("nroSerie", UCase(context.Request(i.ToString + "[changes][loteSerie]")))
                Else
                    detalle.Add("nroLote", UCase(context.Request(i.ToString + "[loteSerie]")))
                    detalle.Add("nroSerie", UCase(context.Request(i.ToString + "[loteSerie]")))

                End If
                'If context.Request(i.ToString + "[changes][loteSerie]") <> Nothing Then

                '    detalle.Add("nroSerie", context.Request(i.ToString + "[changes][loteSerie]"))
                'Else
                '    detalle.Add("nroSerie", context.Request(i.ToString + "[loteSerie]"))

                'End If
                If context.Request(i.ToString + "[changes][fechaVencimiento]") <> Nothing Then

                    detalle.Add("fechaVencimiento", context.Request(i.ToString + "[changes][fechaVencimiento]"))
                Else
                    detalle.Add("fechaVencimiento", context.Request(i.ToString + "[fechaVencimiento]"))

                End If

                estado = ControladorPersistencia.saveDetallesMaterialTemporal(NroOCompra, codMaterial, detalle)

                If estado = 1 Then
                    Return "{""status"":""error"",""message"": ""Ocurrio un error en la Base de datos, intente de nuevo mas tarde. Si el problema persiste comuniquese con informática""}"
                End If
            Next
        Else
            Return "{""status"":""error"",""message"": ""Ocurrio un error en la Base de datos, intente de nuevo mas tarde. Si el problema persiste comuniquese con informática""}"
        End If
        Return "{""status"":""success""}"

    End Function
    Public Function getRecordsParaQR(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim listaDetallesMaterial As New List(Of Dictionary(Of String, String))
        Dim nroRecepcion As String = context.Request("nroRecepcion")
        Dim NroOCompra As String = context.Request("idoc")
        Dim codMaterial As String = context.Request("codigoMaterial")
        Dim periodoOC As String = context.Request("periodo")
        Dim listDetMats As New ListaDetalleMatQR()
        Dim serializer As New JavaScriptSerializer()
        'Dim count As Integer = 1

        Try

            listaDetallesMaterial = ControladorPersistencia.getRecordsParaQR(codMaterial, periodoOC, nroRecepcion)

            For Each detalleMaterial As Dictionary(Of String, String) In listaDetallesMaterial
                Dim detMaterial As New DetalleMaterialQR(detalleMaterial("FLD_MATCODIGO"), _
                                                        detalleMaterial("FLD_NSERIE"), _
                                                        detalleMaterial("FLD_MOVCANTIDAD"))

                listDetMats.setDetalleMaterial(detMaterial)
                listDetMats.total += 1
            Next

            jsonSerializado = serializer.Serialize(listDetMats)

            Return jsonSerializado

        Catch ex As Exception

            jsonSerializado = "{""status"":""error"",""   message"":" + ex.ToString + "}"
            Return jsonSerializado
        End Try
    End Function

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class