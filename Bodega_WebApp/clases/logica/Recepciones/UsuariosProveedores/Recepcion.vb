Public Class Recepcion
    Public periodo As String
    Public tipoMovimiento As String
    Public comMovimineto As String
    Public bodCodigo As String
    Public fechaRecep As String
    Public percodigoOC As String
    Public precioRecep As Double
    Public nroDoc As String
    Public tipoDocRecepcion As String
    Public obsRecepcion As String
    Public pNeto As Double
    Public ivaRecep As Double
    Public impuestoRecep As Double
    Public difPeso As String

    Public Sub New()

    End Sub
    Public Sub New(ByVal periodo As String, _
                   ByVal tipoMovimiento As String, _
                   ByVal comMovimiento As String, _
                   ByVal nroDoc As String, _
                   ByVal tipoRecepcion As String, _
                   ByVal obsRecepcion As String, _
                   ByVal pNeto As Double, _
                   ByVal difPeso As String)
        Me.periodo = periodo
        Me.tipoMovimiento = tipoMovimiento
        Me.comMovimineto = comMovimiento
        Me.bodCodigo = ""
        Me.fechaRecep = ""
        Me.percodigoOC = ""
        Me.precioRecep = ""
        Me.nroDoc = nroDoc
        Me.tipoDocRecepcion = tipoRecepcion
        Me.obsRecepcion = obsRecepcion
        Me.pNeto = pNeto
        Me.ivaRecep = ""
        Me.impuestoRecep = ""
        Me.difPeso = difPeso
    End Sub

    Public Sub New(ByVal periodo As String, _
                   ByVal tipoMovimiento As String, _
                   ByVal comMovimiento As String, _
                   ByVal bodCodigo As String, _
                   ByVal fechaRecep As String, _
                   ByVal percodigoOC As String, _
                   ByVal precioRecep As Double, _
                   ByVal nroDoc As String, _
                   ByVal tipoRecepcion As String, _
                   ByVal obsRecepcion As String, _
                   ByVal pNeto As Double, _
                   ByVal ivaRecep As Double, _
                   ByVal impuestoRecep As Double, _
                   ByVal difPeso As String)
        Me.periodo = periodo
        Me.tipoMovimiento = tipoMovimiento
        Me.comMovimineto = comMovimiento
        Me.bodCodigo = bodCodigo
        Me.fechaRecep = fechaRecep
        Me.percodigoOC = percodigoOC
        Me.precioRecep = precioRecep
        Me.nroDoc = nroDoc
        Me.tipoDocRecepcion = tipoRecepcion
        Me.obsRecepcion = obsRecepcion
        Me.pNeto = pNeto
        Me.ivaRecep = ivaRecep
        Me.impuestoRecep = impuestoRecep
        Me.difPeso = difPeso

    End Sub
End Class
