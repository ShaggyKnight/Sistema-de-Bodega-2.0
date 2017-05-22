Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class DataRptDespachoAUsuarios
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim jsonSerializado As String = ""
        Dim cmd As String = context.Request("tipoBusqueda")

        Select Case cmd
            Case "cargaDatos"
                jsonSerializado = getDatosSelect(context)
        End Select
        context.Response.Write(jsonSerializado)

    End Sub
    Public Function getDatosSelect(ByVal context As HttpContext)
        Dim serializer As New JavaScriptSerializer()
        Dim jsonSerializado As String = ""
        Dim listItemsSelectBox As New List(Of Dictionary(Of String, String))
        Dim ListaDatosSelect As New ListaObjetosSelectBox
        Dim tipoBusqueda As String = context.Request("indentificadorBusqueda")

        Select Case tipoBusqueda
            Case "centrosRespon"

                listItemsSelectBox = ControladorLogica.getCentrosResponsabilidad()
                For Each centroResp As Dictionary(Of String, String) In listItemsSelectBox
                    Dim responsCenter As New ObjetoSelectBox(centroResp("FLD_CRECODIGO"), _
                                                             centroResp("FLD_CRENOMBRE"))
                    ListaDatosSelect.setObjeto(responsCenter)
                Next
                jsonSerializado = serializer.Serialize(ListaDatosSelect)

            Case "centrosCosto"

                listItemsSelectBox = ControladorLogica.getCentrosCosto()
                For Each centroCosto As Dictionary(Of String, String) In listItemsSelectBox
                    Dim CostCenter As New ObjetoSelectBox(centroCosto("FLD_CCOCODIGO"), _
                                                          centroCosto("FLD_CCONOMBRE"))
                    ListaDatosSelect.setObjeto(CostCenter)
                Next
                jsonSerializado = serializer.Serialize(ListaDatosSelect)

            Case "listaMateriales"

                listItemsSelectBox = ControladorLogica.getListaMateriales()
                For Each Material As Dictionary(Of String, String) In listItemsSelectBox
                    Dim insumo As New ObjetoSelectBox(Material("COD_MATERIAL"), _
                                                      Material("COD_MATERIAL") & " - " & Material("NOMBRE_MATERIAL"))
                    ListaDatosSelect.setObjeto(insumo)
                Next
                jsonSerializado = serializer.Serialize(ListaDatosSelect)

            Case "itemsPresup"

                listItemsSelectBox = ControladorLogica.getItemsPresupuestarios()
                For Each itemPresup As Dictionary(Of String, String) In listItemsSelectBox
                    Dim item As New ObjetoSelectBox(itemPresup("FLD_ITECODIGO"), _
                                                    itemPresup("FLD_ITEDENOMINACION"))
                    ListaDatosSelect.setObjeto(item)
                Next
                jsonSerializado = serializer.Serialize(ListaDatosSelect)

        End Select

        Return jsonSerializado
    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class