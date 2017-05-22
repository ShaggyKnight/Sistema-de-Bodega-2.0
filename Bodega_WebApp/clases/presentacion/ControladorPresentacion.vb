Imports System.IO

Public Class ControladorPresentacion
    Public Shared Function getListaServidores() As List(Of Servidor)
        Return ControladorLogica.getListaServidores()
    End Function
    Public Shared Sub setPersistencia(ByVal usuario As String, ByVal contrasena As String, ByVal idServidor As Integer, httpSessionState As HttpSessionState)
        ControladorLogica.setPersistencia(usuario, contrasena, idServidor, httpSessionState)
    End Sub

    Public Shared Function GetUsuario(ByVal usuario As String) As UsuarioLogeado
        Return ControladorLogica.GetUsuario(usuario)
    End Function
    Public Shared Function getDatosOrdenCompra(ByVal numeroOC As String, ByVal usuario As UsuarioLogeado)
        Return ControladorLogica.getDatosOrdenCompra(numeroOC, usuario)

        ' Dim datos As Dictionary(Of String, String) = ControladorLogica.getDatosOrdenCompra(numeroOC, usuario)

        'Dim ordenCompra As New OrdenDeCompra(datos("FLD_OCONUMERO"), datos("FLD_PERCODIGO"), datos("FLD_PROVEEDOR"), datos("FLD_OCONUMERO"), datos("FLD_OCONUMERO"), datos("FLD_OCONUMERO"), datos("FLD_OCONUMERO"), datos("FLD_OCONUMERO"))
    End Function
    Public Shared Function getDatosMaterial(ByVal numeroOC As String)
        Return ControladorLogica.getDatosMaterial(numeroOC)
    End Function
    Public Shared Function getListaBodegas(ByVal establecimiento As String)
        Return ControladorLogica.getListaBodegas(establecimiento)
    End Function
    Public Shared Function getestablecimiento(ByVal cCosto As String)
        Return ControladorLogica.getestablecimiento(cCosto)
    End Function
    Public Shared Function validarBodega(ByVal numeroOC As String, ByVal usuario As UsuarioLogeado) As Boolean
        Return ControladorLogica.validarBodega(numeroOC, usuario)
    End Function
    Public Shared Function getFechaServidor() As DateTime
        Return ControladorLogica.getFechaServidor()
    End Function
    Public Shared Function updateRecepcion(ByVal recepcion As Recepcion)
        Return ControladorLogica.updateRecepcion(recepcion)
    End Function
    'Public Shared Function crearRecepcion(ByVal periodo As String, tipoMovimiento As String, usuario As String)
    '    Return ControladorLogica.crearRecepcion(periodo, tipoMovimiento, usuario)
    'End Function
    'Public Shared Function GetEstructuraIngresoFrom(ByRef panel As Panel) As List(Of IngresoProducto)
    '    Dim i As Integer = 1
    '    Dim ingresosProductos As New List(Of IngresoProducto)
    '    While (1)
    '        Dim agregar As IngresoProducto
    '        Try
    '            Dim panelInfoProducto As Panel = panel.FindControl("informacionProducto" & i)
    '            agregar = GenerarIngresoProductoFrom(panel, i)
    '        Catch ex As Exception
    '            Exit While
    '        End Try
    '        ingresosProductos.Add(agregar)
    '        i = i + 1
    '    End While
    '    Return ingresosProductos
    'End Function

    'Private Shared Function GenerarIngresoProductoFrom(ByRef panelPrincipal As Panel, ByVal posicionIngresoProducto As Integer) As IngresoProducto
    '    Dim padre As Panel = panelPrincipal.FindControl("informacionProducto" & posicionIngresoProducto)
    '    Dim sb As New StringBuilder()
    '    CType(padre.FindControl("contenedorCodigo" & posicionIngresoProducto), Panel).RenderControl(New HtmlTextWriter(New StringWriter(sb)))

    '    Dim s As String = sb.ToString()
    '    s = s.Substring(s.IndexOf(">") + 1)
    '    s = s.Substring(0, s.Length - 6)
    '    Dim codigo = s.Trim()
    '    sb = New StringBuilder
    '    CType(padre.FindControl("contenedorNombre" & posicionIngresoProducto), Panel).RenderControl(New HtmlTextWriter(New StringWriter(sb)))
    '    s = sb.ToString()
    '    s = s.Substring(s.IndexOf(">") + 1)
    '    s = s.Substring(0, s.Length - 6)
    '    Dim nombre = s.Trim()
    '    Dim factor As String = CType(padre.FindControl("contenedorFactor" & posicionIngresoProducto).FindControl("factor" & posicionIngresoProducto), TextBox).Text
    '    Dim valor As String = CType(padre.FindControl("contenedorValor" & posicionIngresoProducto).FindControl("valor" & posicionIngresoProducto), TextBox).Text
    '    Dim recepcionPorFactura As String = CType(padre.FindControl("contenedorRecepcionPorFactura" & posicionIngresoProducto).FindControl("recepcionPorFactura" & posicionIngresoProducto), TextBox).Text
    '    Dim recepcionado As String = CType(padre.FindControl("contenedorRecepcionado" & posicionIngresoProducto).FindControl("recepcionado" & posicionIngresoProducto), DropDownList).Text
    '    Dim retorno As New IngresoProducto(codigo, nombre, "", factor, "", valor, recepcionPorFactura, recepcionado, "")
    '    Dim i As Integer = 1
    '    While (1)
    '        Try
    '            retorno.AgregarDetalle(GenerarDetalleIngresoProductoFrom(padre, posicionIngresoProducto, i))
    '        Catch ex As Exception
    '            Exit While
    '        End Try
    '        i = i + 1
    '    End While
    '    Return retorno
    'End Function

    'Private Shared Function GenerarDetalleIngresoProductoFrom(ByRef padre As Panel, ByVal posicionPadre As Integer, ByVal posicionIngresoProducto As Integer) As IngresoProductoDetalle
    '    Dim cantidad As String
    '    Dim lote As String
    '    Dim serie As String
    '    Dim fechaVencimiento As String

    '    padre = padre.FindControl("lineaDetalle" & posicionPadre & "." & posicionIngresoProducto)
    '    padre = padre.FindControl("contenedorDetalle" & posicionPadre & "." & posicionIngresoProducto)


    '    cantidad = CType(padre.FindControl("contenedorCantidad" & posicionPadre & "." & posicionIngresoProducto).Controls(0), TextBox).Text
    '    lote = CType(padre.FindControl("contenedorLote" & posicionPadre & "." & posicionIngresoProducto).Controls(0), TextBox).Text
    '    serie = CType(padre.FindControl("contenedorSerie" & posicionPadre & "." & posicionIngresoProducto).Controls(0), TextBox).Text
    '    fechaVencimiento = CType(padre.FindControl("contenedorVencimiento" & posicionPadre & "." & posicionIngresoProducto).Controls(0), TextBox).Text

    '    Return New IngresoProductoDetalle(cantidad, lote, serie, fechaVencimiento)
    'End Function
End Class
