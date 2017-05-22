Public Class Pagina
    Public Shared ReadOnly inicio As Integer = 1
    Public Shared ReadOnly recepcion As Integer = 2
    Public Shared ReadOnly despacho As Integer = 3
    Public Shared ReadOnly StockEmergencia As Integer = 4
    Public Shared ReadOnly cenabast As Integer = 5
    Public Shared ReadOnly otros As Integer = 6
    Public Shared ReadOnly reportes As Integer = 7

    Public Shared ReadOnly inventarioR As Integer = 9
    Public Shared ReadOnly despachoR As Integer = 10
    Public Shared ReadOnly transferenciaR As Integer = 11

    Public Shared ReadOnly recepDesdeProveedores As Integer = 21
    Public Shared ReadOnly recepFacturasaGuia As Integer = 22
    Public Shared ReadOnly recepDevolucionxNPedido As Integer = 23
    Public Shared ReadOnly recepDevolucionUsuario As Integer = 24
    Public Shared ReadOnly recepProgramaMinsal As Integer = 25
    Public Shared ReadOnly recepxDonacion As Integer = 26
    Public Shared ReadOnly recepDevolucionPrestamo As Integer = 27
    Public Shared ReadOnly recepSolicitudPrestamo As Integer = 28
    Public Shared ReadOnly recepCanje As Integer = 29

    Public Shared ReadOnly despaHaciaUsuarios As Integer = 31
    Public Shared ReadOnly despaModificacionDespacho As Integer = 32
    Public Shared ReadOnly despaTransferencias As Integer = 33
    Public Shared ReadOnly despaDevolucionTransferencias As Integer = 34
    Public Shared ReadOnly despaDevolucionDePrestamos As Integer = 35
    Public Shared ReadOnly despaPrestamosOtrasInstitu As Integer = 36
    Public Shared ReadOnly despaCanje As Integer = 37

    Public Shared ReadOnly otrosMantencionBodegas As Integer = 61
    Public Shared ReadOnly otrosTraspasoBodega As Integer = 62
    'Public Shared ReadOnly otrosMantencionMateriales As Integer = 63
    'Public Shared ReadOnly otrosMantencionGrupoMateriales As Integer = 64
    'Public Shared ReadOnly otrosAnularRecepcion As Integer = 65
    Public Shared ReadOnly otrosPrestamoTercerosMenu As Integer = 66
    'Public Shared ReadOnly otrosCerrarOCParciales As Integer = 67
    'Public Shared ReadOnly otrosVerificarFechaVencimiento As Integer = 68

    Public Shared ReadOnly reportBincardGeneral As Integer = 71
    Public Shared ReadOnly reportOCxFactura As Integer = 72                           ' NUEVO 03/09/2015
    'Public Shared ReadOnly reportAjustesExistencia As Integer = 72 // 72 no va
    Public Shared ReadOnly reportOrdenesCompra As Integer = 73
    'Public Shared ReadOnly reportOCxBodega As Integer = 74         // 73 74 juntos
    'Public Shared ReadOnly reportInventarioMenu As Integer = 75
    'Public Shared ReadOnly reportDespachoMenu As Integer = 76
    Public Shared ReadOnly reportTransferenciaMenu As Integer = 77
    Public Shared ReadOnly reportStockMinimoMaximo As Integer = 78
    'Public Shared ReadOnly reportFechaVencimientoxPeriodo As Integer = 79  // 72 no va
    Public Shared ReadOnly reportFVtoXPeriodoMaterial As Integer = 80  '//79 80 juntos
    Public Shared ReadOnly reportMaterialesFarmacos As Integer = 81
    'Public Shared ReadOnly reportConsumoMensualMenu As Integer = 82
    Public Shared ReadOnly reportPedidosnoPlanificados As Integer = 83

    ' DEL 75 MENU INVENTARIO
    Public Shared ReadOnly reportInventarioXItem As Integer = 90
    Public Shared ReadOnly reportInventarioXFamilia As Integer = 92
    Public Shared ReadOnly reportInventarioREAL As Integer = 93

    ' DEL 76 MENU DESPACHO
    Public Shared ReadOnly reportAUsuarios As Integer = 94
    Public Shared ReadOnly reporXServicio As Integer = 96
    Public Shared ReadOnly reporXPauta As Integer = 97
    Public Shared ReadOnly reportMandatoCENABAST As Integer = 98

    ' DEL 82 CONSUMO MENSUAL
    Public Shared ReadOnly reportProgramaDeCompra As Integer = 102
    Public Shared ReadOnly reportConsumoXBodegaStock_CriMinMax As Integer = 103
    Public Shared ReadOnly reportConsumoMensualXCCosto As Integer = 104

    'DEL 77 MENU TRANSFERENCIA
    Public Shared ReadOnly reportTrasferenciaBodegas As Integer = 110
    Public Shared ReadOnly reportConsolidadoMensual As Integer = 111

    'DEL 77 MENU TRANSFERENCIA
    Public Shared ReadOnly ajusteMaterial As Integer = 120          'Menu solo para supervisor.
    Public Shared ReadOnly ajusteExistencias As Integer = 121       ' Menu personal imprime ajustes realizados.

    Public Shared Function isRecepcion(ByVal index As Integer) As Boolean
        Return (index = Pagina.recepDesdeProveedores) Or (index = Pagina.recepFacturasaGuia) Or (index = Pagina.recepDevolucionxNPedido) Or (index = Pagina.recepDevolucionUsuario) Or (index = Pagina.recepxDonacion) Or (index = Pagina.recepProgramaMinsal) Or (index = Pagina.recepDevolucionPrestamo) Or (index = Pagina.recepSolicitudPrestamo) Or (index = Pagina.recepCanje)
    End Function

    Public Shared Function isDespacho(ByVal index As Integer) As Boolean
        Return (index = Pagina.despaHaciaUsuarios) Or (index = Pagina.despaModificacionDespacho) Or (index = Pagina.despaTransferencias) Or (index = Pagina.despaDevolucionTransferencias) Or (index = Pagina.despaPrestamosOtrasInstitu) Or (index = Pagina.despaCanje) Or (index = Pagina.despaDevolucionDePrestamos)
    End Function

    Public Shared Function isStockEmergencia(ByVal index As Integer) As Boolean
        Return (index = Pagina.StockEmergencia)
    End Function
    Public Shared Function isCenabast(ByVal index As Integer) As Boolean
        Return (index = Pagina.cenabast)
    End Function

    Public Shared Function isOtros(ByVal index As Integer) As Boolean
        Return (index = Pagina.otrosTraspasoBodega) Or (index = Pagina.otrosPrestamoTercerosMenu) Or (index = Pagina.otrosMantencionBodegas)
    End Function
    Public Shared Function isReportes(ByVal index As Integer) As Boolean
        Return (index = Pagina.reportBincardGeneral) Or (index = Pagina.reportOrdenesCompra) Or (index = Pagina.reportStockMinimoMaximo) Or (index = Pagina.reportFVtoXPeriodoMaterial) Or (index = Pagina.reportPedidosnoPlanificados) Or (index = Pagina.reportMaterialesFarmacos) Or (index = Pagina.reportInventarioXItem) Or (index = Pagina.reportInventarioXFamilia) Or (index = Pagina.reportInventarioREAL) Or (index = Pagina.reportMandatoCENABAST) Or (index = Pagina.reporXPauta) Or (index = Pagina.reporXServicio) Or (index = Pagina.reportConsumoMensualXCCosto) Or (index = Pagina.reportProgramaDeCompra) Or (index = Pagina.reportConsumoXBodegaStock_CriMinMax) Or (index = Pagina.reportAUsuarios) Or (index = Pagina.reportOCxFactura) Or (index = Pagina.reportTrasferenciaBodegas) Or (index = Pagina.reportConsolidadoMensual) Or (index = Pagina.ajusteMaterial) Or (index = Pagina.ajusteExistencias)
    End Function
    'Public Shared Function isMenuTransferencias(ByVal index As Integer) As Boolean
    '    Return (index = Pagina.reportTrasferenciaBodegas) Or (index = Pagina.reportConsolidadoMensual)
    'End Function
End Class

