Public Class ControladorLogica
    Public Shared Function getListaServidores() As List(Of Servidor)
        Return ControladorPersistencia.getListaServidores()
    End Function

    Public Shared Sub setPersistencia(ByVal usuario As String, ByVal contrasena As String, ByVal idServidor As Integer, httpSessionState As HttpSessionState)
        ControladorPersistencia.setPersistencia(usuario, contrasena, idServidor, httpSessionState)
    End Sub

    Public Shared Function GetUsuario(ByVal usuario As String) As UsuarioLogeado
        If Not ControladorPersistencia.UsuarioValido(usuario) Then
            Throw New Exception("Su cuenta figura como no vigente. Porfavor, contacte a Informática")
        End If
        Return ControladorPersistencia.GetUsuario(usuario)
    End Function
    'NUEVOS METODOS
    'CENABAST
    Public Shared Function generaRecepcionCenabast(ByVal periodo As String, ByVal usuarioOperacion As String, ByVal observacion As String, _
                                                    ByVal centroCosto As String, ByVal codBodega As String)
        Return ControladorPersistencia.generaRecepcionCenabast(periodo, usuarioOperacion, observacion, centroCosto, codBodega)
    End Function
    Public Shared Function saveMaterialesRecepCenabast(ByVal periodo As String, ByVal usuarioOperacion As String, ByVal codMat As String, _
                                                           ByVal cantidad As Integer, ByVal loteSerie As String, ByVal fechaVencimiento As String, ByVal precioUnitario As String)
        Return ControladorPersistencia.saveMaterialesRecepCenabast(periodo, usuarioOperacion, codMat, cantidad, loteSerie, fechaVencimiento, precioUnitario)
    End Function
    Public Shared Function getListaMaterialesRecepCenabast(ByVal nombreMaterial As String, ByVal codigoCenabast As String, ByVal codigoMaterial As String, _
                                                           ByVal codigoBodega As String)
        Return ControladorPersistencia.getListaMatsRecepcionCenabastPUp(nombreMaterial, codigoCenabast, codigoMaterial, codigoBodega)
    End Function
    Public Shared Function getListaPeriodos()
        Return ControladorPersistencia.getListaPeriodos()
    End Function
    Public Shared Function getlistaBodegasDevUsuarios(ByVal establecimiento As String)
        Return ControladorPersistencia.getlistaBodegasDevUsuarios(establecimiento)
    End Function
    Public Shared Function getListaCentrosCostosDevUsu(ByVal establecimiento As String)
        Return ControladorPersistencia.getListaCentrosCostosDevUsu(establecimiento)
    End Function
    'FIN CENABAST
    Public Shared Function getRecepcionesBRECEP(ByVal nroRecepcion As Integer, ByVal periodoRecep As String, ByVal nroOC As Integer, _
                                                ByVal periodoOC As String, ByVal estadoOC As String, ByVal tipoBusqueda As Integer)
        Return ControladorPersistencia.getRecepcionesBRECEP(nroRecepcion, periodoRecep, nroOC, periodoOC, estadoOC, tipoBusqueda)
    End Function
    Public Shared Function getCentrosResponsabilidad()
        Return ControladorPersistencia.getCentrosResponsabilidad()
    End Function
    Public Shared Function getCentrosCosto()
        Return ControladorPersistencia.getCentrosCosto()
    End Function
    Public Shared Function getListaMateriales()
        Return ControladorPersistencia.getListaMateriales()
    End Function
    Public Shared Function getItemsPresupuestarios()
        Return ControladorPersistencia.getItemsPresupuestarios()
    End Function
    'FIN NUEVOS METODOS
    'DE AQUI METODOS ANTIGUOS SIN USO
    Public Shared Function getDatosOrdenCompra(ByVal numeroOC As String, ByVal usuario As UsuarioLogeado)
        'Return ControladorPersistencia.getDatosOrdenCompra(numeroOC, usuario)
    End Function
    Public Shared Function getDatosMaterial(ByVal numeroOC As String)
        'Return ControladorPersistencia.getDatosMaterial(numeroOC)
    End Function
    Public Shared Function getListaBodegas(ByVal establecimiento As String)
        Return ControladorPersistencia.getDatosBodegas(establecimiento)
    End Function
    Public Shared Function getestablecimiento(ByVal cCosto As String)
        Return ControladorPersistencia.getEstablecimiento(cCosto)
    End Function
    Public Shared Function validarBodega(ByVal numeroOC As String, ByVal usuario As UsuarioLogeado) As Boolean
        'Return ControladorPersistencia.validarBodega(numeroOC, usuario)
    End Function
    Public Shared Function getFechaServidor() As DateTime
        Return ControladorPersistencia.getFechaServidor()
    End Function
    Public Shared Function updateRecepcion(ByVal recepcion As Recepcion)
        Return ControladorPersistencia.updateRecepcion(recepcion)
    End Function
    'Public Shared Function crearRecepcion(ByVal periodo As String, tipoMovimiento As String, usuario As String)
    'Dim recepcion As New Recepcion()
    '   Return ControladorPersistencia.crearRecepcion(recepcion, tipoMovimiento, usuario)
    'End Function

    Public Shared Function getDespachosNPedido(ByVal nroDespacho As Integer, ByVal periodo As String, ByVal nroPedido As Integer, ByVal usuario As String)
        Return ControladorPersistencia.getDespachosNPedido(nroDespacho, periodo, nroPedido, usuario)
    End Function

    Shared Function getDespachosNPedidoPopUp(ByVal nroDespacho As Integer, ByVal periodo As String, ByVal nroPedido As Integer)
        Return ControladorPersistencia.getDespachosNPedidoPopUp(nroDespacho, periodo, nroPedido)
    End Function

    Shared Function getDetallesMaterialDevolNPedido(ByVal nroDespacho As String, ByVal numeroPedido As String, ByVal periodo As String, ByVal matCodigo As String, ByVal usuario As String, ByVal fechaVencimientoAnterior As String, ByVal loteSerie_Anterior As String) As List(Of Dictionary(Of String, String))
        Return ControladorPersistencia.getDetallesMaterialDevolNPedido(nroDespacho, numeroPedido, periodo, matCodigo, usuario, _
                                                                                  fechaVencimientoAnterior, loteSerie_Anterior)
    End Function

    Shared Function saveDetalleMaterialDevNPedido(ByVal nroDespacho As String, ByVal periodo As String, ByVal nroPedido As String, ByVal matCodigo As String, ByVal loteSerieChanged As String, ByVal cantidad As String, ByVal fechaVencimiento As String, ByVal usuario As String, ByVal loteSerieAnt As String, ByVal fechaVencimientoAnterior As String, ByVal loteSerie_Anterior As String) As Integer
        Return ControladorPersistencia.saveDetalleMaterialDevNPedido(nroDespacho, periodo, nroPedido, matCodigo, _
                                                                    loteSerieChanged, cantidad, fechaVencimiento, _
                                                                    usuario, loteSerieAnt, fechaVencimientoAnterior, loteSerie_Anterior)
    End Function

    Shared Function actualizaEstadoMaterialDevolucion(ByVal nroDespacho As String, ByVal periodo As String, ByVal nroPedido As String, ByVal matCodigo As String, ByVal cantidadARecibir As Integer, ByVal usuario As String, ByVal loteSerie As String, ByVal fechaVencimiento As String) As Integer
        Return ControladorPersistencia.actualizaEstadoMaterialDevolucion(nroDespacho, periodo, nroPedido, matCodigo, cantidadARecibir, usuario, loteSerie, fechaVencimiento)
    End Function

    Shared Function getListaProveedores() As List(Of Dictionary(Of String, String))
        Return ControladorPersistencia.getListaProveedores()
    End Function

End Class
