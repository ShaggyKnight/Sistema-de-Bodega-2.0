<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="DevolucionXNumeroPedido.aspx.vb" Inherits="Bodega_WebApp.DevolucionXNumeroPedido" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.recepDevolucionxNPedido%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="formDevDespachoNMat" style="height: 260px;"></div>
    <div id="gridDevDespachoNMat" style="height: 260px; top: 2px;"></div>
</asp:Content>
<asp:Content ID="FooterContent" ContentPlaceHolderID="FooterPlaceHolder" runat="server">

</asp:Content>
<asp:Content ID="JavaScriptContent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <!-- Variables Globales -->
    <script type="text/javascript">

        /*
         *Solicitudes:

         *Correcciones:
            invirtieron los botones de busqueda y aceptar del form.
        */

        var numeroDespacho = 0;
        var numeroPedido = 0;
        var periodoBusqueda = 0;
        var periodoDevolucion = 0;
        var tmvNumero = '';
        var fechaDevolucion = '';
        var devObservacion = '';
        var nroDevolucion = 0;
        var userName = '';

        userName = ' <%=usuario.username %> ';
    </script>
    <!-- w2ui Definicion elementos de PopUp de busqueda por BODEGA-->
    <script type="text/javascript">
        var config = {
            layout: {
                name: 'layout',
                padding: 4,
                panels: [
			            { type: 'left', size: '65%', minSize: 300 },
			            { type: 'main', minSize: 300 }
		            ]
            },
            grid: {
                name: 'gridDEVNUMPEDIDO',
                columns: [
			            { field: 'periodoDespacho', caption: 'Periodo', size: '7%' },
			            { field: 'numeroPedido', caption: 'Nº Pedido', size: '8.5%' },
			            { field: 'numeroDespacho', caption: 'Nº Despacho', size: '9.5%' },
                        { field: 'numeroDevolucion', caption: 'Nº Devolución', size: '10%' },
			            { field: 'fechaDespacho', caption: 'Fecha Despacho', size: '12%' },
			            { field: 'descripcion', caption: 'Descripcion', size: '30%' },
                        { field: 'fechaDevolucion', hidden: true },
                        { field: 'devDescripcion', hidden: true }
		            ],
                onSelect: function (event) {
                    numeroPedido = this.records[this.last.sel_ind].numeroPedido;
                    periodoBusqueda = this.records[this.last.sel_ind].periodoDespacho;
                    numeroDespacho = this.records[this.last.sel_ind].numeroDespacho;
                    nroDevolucion = this.records[this.last.sel_ind].numeroDevolucion;
                    fechaDevolucion = this.records[this.last.sel_ind].fechaDevolucion;
                    devObservacion = this.records[this.last.sel_ind].devDescripcion;
                    periodoDevolucion = this.records[this.last.sel_ind].fechaDevolucion.substr(6, 9);
                    tmvNumero = '2';
                }
            },
            form: {
                header: 'Criterios de Busqueda',
                name: 'formDEVNUMPEDIDO',
                formHTML: '<div class="w2ui-page page-0">' +
		                    '<div class="w2ui-label w2ui-span6">Número Pedido:</div>' +
		                    '<div class="w2ui-field w2ui-span6">' +
			                    '<input name="numeroPedidoDEVNPEDIDO" type="text" maxlength="10" size="20"/>' +
		                    '</div>' +
		                    '<div class="w2ui-label w2ui-span6">Número Despacho:</div>' +
		                    '<div class="w2ui-field w2ui-span6">' +
		                    '	<input name="numeroDespachoDEVNPEDIDO" type="text" maxlength="10" size="20"/>' +
		                    '</div>' +
		                    '<div class="w2ui-label w2ui-span6">Periodo:</div>' +
		                    '<div class="w2ui-field w2ui-span6">' +
			                    '<select name="periodoDEVNPEDIDO" type="select"/>' +
		                    '</div>' +
		                '</div>' +
                        '<div class="w2ui-buttons">' +
                            '<input type="button" value="Buscar" name="Buscar">' +
		                    '<input type="button" value="Aceptar" name="Aceptar">' +
		                    '<input type="button" value="Limpiar" name="Limpiar">' +
	                    '</div>',
                fields: [
			            { name: 'numeroPedidoDEVNPEDIDO', type: 'int' },
			            { name: 'numeroDespachoDEVNPEDIDO', type: 'int' },
			            { name: 'periodoDEVNPEDIDO', type: 'list',
			                options: { url: '../../clases/persistencia/controladores/Recepciones/AsocDevolXNroPedido/GetDatosDevXNroPedido.ashx?tipoBusqueda=datosSelect' }
			            }
		            ],
                actions: {
                    Buscar: function () {
                        w2ui.gridDEVNUMPEDIDO.url = '../../clases/persistencia/controladores/Recepciones/AsocDevolXNroPedido/GetDatosDevXNroPedido.ashx?tipoBusqueda=datosGridPopUp' + '&periodo=' + this.record.periodoDEVNPEDIDO + '&nroDespacho=' + this.record.numeroDespachoDEVNPEDIDO + '&nroPedido=' + this.record.numeroPedidoDEVNPEDIDO;
                        w2ui.gridDEVNUMPEDIDO.reload();
                    },
                    Aceptar: function () {
                        w2popup.close();

                        w2ui.formDevDespachoNMat.record = {
                            nroDevolucion: nroDevolucion,
                            nroDespacho: numeroDespacho,
                            periodoMovimiento: periodoBusqueda,
                            observacionDespacho: devObservacion,
                            nroPedido: numeroPedido
                        }

                        w2ui.formDevDespachoNMat.refresh();

                        w2ui.gridDevDespachoNMat.url = '../../clases/persistencia/controladores/Recepciones/AsocDevolXNroPedido/GetDatosDevXNroPedido.ashx?tipoBusqueda=datosGrid' + '&periodo=' + periodoBusqueda + '&nroDespacho=' + numeroDespacho + '&nroPedido=' + numeroPedido + '&nombreUsuario=' + userName;
                        w2ui.gridDevDespachoNMat.reload();

                    },
                    Limpiar: function () {
                        this.clear();
                        w2ui.gridDEVNUMPEDIDO.clear();
                    }
                }
            }
        }
    </script>
    <!-- Inicializacion en memoria de elementos w2ui para popUps -->
    <script type="text/javascript">
        $(function () {
            // initialization in memory
            $().w2layout(config.layout);
            $().w2grid(config.grid);
            $().w2form(config.form);

        });
    </script>
    <!-- instancia de abertura de pop up para busqueda por BODEGA -->
    <script type="text/javascript">
        function openPopup() {
            w2popup.open({
                title: 'BUSQUEDA DESPACHO',
                width: 1100,
                height: 600,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                modal: true,
                onOpen: function (event) {
                    event.onComplete = function () {
                        $('#w2ui-popup #main').w2render('layout');
                        w2ui.layout.content('left', w2ui.gridDEVNUMPEDIDO);
                        w2ui.layout.content('main', w2ui.formDEVNUMPEDIDO);
                    };
                },
                onMax: function (event) {
                    event.onComplete = function () {
                        w2ui.layout.resize();
                    }
                },
                onMin: function (event) {
                    event.onComplete = function () {
                        w2ui.layout.resize();
                    }
                }
            });
        }
    </script>
    <!-- Form Devolucion por nro Material -->
    <script type="text/javascript">

        $('#formDevDespachoNMat').w2form({
            name: 'formDevDespachoNMat',
            header: 'Devolución de Material por Nº Pedido',
            formHTML: '<div class="w2ui-page page-0">' +
		                '<div style="width: 340px; float: left;">' +
			                '<div class="w2ui-group" style="height: 113px; margin-top: auto;">' +
				                '<div class="w2ui-label w2ui-span5">Nº Despacho:</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
					                '<input name="nroDespacho" type="text" maxlength="100" style="width: 60%" disabled="disabled"/>' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span5">Nº Pedido:</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
					                '<input name="nroPedido" type="text" maxlength="100" style="width: 60%" disabled="disabled"/>' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span5">Nº Devolución:</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
					                '<input name="nroDevolucion" type="text" maxlength="100" style="width: 60%" disabled="disabled"/>' +
				                '</div>' +
			                '</div>' +
		                '</div>' +
		                '<div style="margin-left: 350px;">' +
			                '<div class="w2ui-group" style="height: 113px;">' +
				                '<div class="w2ui-label w2ui-span5">Periodo Desp:</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
					                '<input name="periodoMovimiento" type="text" disabled="disabled"/>' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span5">Observación:</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
					                '<textarea name="observacionDespacho" type="text" style="width: 60%; height: 40px; resize: none"></textarea>' +
				                '</div>' +
			                '</div>' +
		               ' </div>' +
	                '</div>' +
	                '<div class="w2ui-buttons">' +
		                '<input type="button" value="Buscar Despacho" name="BuscarDesp" style="width:111px;">' +
		                '<input type="button" value="Limpiar" name="limpiar">' +
                        '<input type="button" value="Guardar" name="GuardarDevolucion">' +
                        '<input type="button" value="Imprimir" name="ImprimirDevol">' +
                        '<input type="button" value="Imprimir QRs" name="ImprimirQr">' +
	                '</div>',
            fields: [
			{ name: 'nroDevolucion', type: 'int', required: true },
			{ name: 'nroDespacho', type: 'int', required: true },
			{ name: 'periodoMovimiento', type: 'text' },
			{ name: 'observacionDespacho', type: 'text' },
			{ name: 'nroPedido', type: 'int', required: true }
		],
            actions: {
                BuscarDesp: function () {
                    openPopup();
                },
                limpiar: function () {
                    this.clear();
                    w2ui.gridDevDespachoNMat.clear();
                },
                GuardarDevolucion: function () {
                    if (this.record['nroDespacho'] && this.record['nroDespacho'] != '0') {
                        w2ui.gridDevDespachoNMat.save();
                    } else {
                        w2alert('Debe buscar una devolución sin completar para realizar esta operación');
                    }
                },
                ImprimirDevol: function () {
                    if (this.record['nroDevolucion'] && this.record['nroDevolucion'] != '') {
                        nroDevolucion = this.record['nroDevolucion'];
                        if (nroDevolucion != '0') {
                            var NTransaccion = nroDevolucion;
                            var fechaTransaccion;
                            var bodega = '';
                            var periodo;
                            var descripcion = devObservacion.toUpperCase();
                            var numeroLinea;
                            var codMaterial;
                            var nombreMaterial;
                            var cantMaterial;
                            var valorUnitario;

                            if (fechaDevolucion) {
                                fechaTransaccion = fechaDevolucion;

                                if (periodoDevolucion != 0 && periodoDevolucion != '0') {
                                    periodo = periodoDevolucion;

                                    /* Graba materiales en la tabla TEMP */
                                    var cont = 1;
                                    var CodigoMaterial;
                                    var NombreMaterial;
                                    var CantidadMovimiento;
                                    var PrecioUnitario;

                                    var done = 0;
                                    var ReportUsuario = '';

                                    for (var i = 0; i <= w2ui.gridDevDespachoNMat.records.length - 1; i++) {

                                        CodigoMaterial = w2ui.gridDevDespachoNMat.records[i].matCodigo;
                                        NombreMaterial = w2ui.gridDevDespachoNMat.records[i].nombreMaterial;
                                        CantidadMovimiento = w2ui.gridDevDespachoNMat.records[i].cantDevuelta;
                                        PrecioUnitario = w2ui.gridDevDespachoNMat.records[i].precioUnitario;

                                        $.ajax({
                                            type: "POST",
                                            url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                                            async: false,
                                            data: { "cmd": 'RPTInforme', "NTransaccion": NTransaccion, "periodo": periodo, "codTransaccion": tmvNumero, "Linea": cont, "codMaterial": CodigoMaterial, "nombreMaterial": NombreMaterial, "CodItem": periodoBusqueda, "cantMaterial": CantidadMovimiento, "precioMaterial": PrecioUnitario, "bodega": '', "descripcion": descripcion, "fechaMovimieno": fechaTransaccion, "proveedor": '', "ordenCompra": numeroDespacho, "ordenCompraEstado": '', "numeroDocumento": numeroPedido, "Institucion": '', "centroCosto": '', "tipoDocumento": '', "tituloMenu": 'RECEPCIÓN MATERIALES POR Nº PEDIDO', "descuento": '0', "impuesto": '0', "diferenciaPeso": '0', "usuario": userName },
                                            dataType: "json",
                                            success: function (response) {
                                                if (response.status == 'error') {
                                                    done = 1;
                                                    w2alert(response.message);
                                                } else {
                                                    done = 0;
                                                    ReportUsuario = response.usuario;
                                                }
                                            },
                                            error: function (response) {
                                                alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                            }
                                        });

                                        cont = cont + 1;

                                    } // Fin for.

                                    if (done == 0) {
                                        window.open('../../reportes/Recepciones/porNroPedido/Rpt_Recpecion_porNroPedido.aspx?CMVCodigo=' + NTransaccion + '&PERCodigo=' + periodo + '&TMVCodigo=' + tmvNumero + '&usuario=' + userName + '&nombreReport=' + 'Rpt_DevolucionXNroPedido_' + nroDevolucion);
                                    } else {
                                        alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                    }

                                } else { alert("Faltan datos para imprimir."); } // Fin nombre periodo recepcion.
                            } else { alert("Faltan datos para imprimir."); } // Fin fechaTransaccion.
                        } else {
                            w2alert('Debe guardar la devolución para realizar esta acción!');
                        }
                    }else{
                        w2alert('Debe buscar un despacho devuelto para realizar esta acción');
                    }
                },
                ImprimirQr: function () {
                    if (this.record['nroDevolucion'] && this.record['nroDevolucion'] != '') {
                        nroDevolucion = this.record['nroDevolucion'];
                        if (nroDevolucion != '0') {
                            if (nroDevolucion != '' && nroDevolucion != undefined) {
                                window.open('../../generadorQR/Recepcion/DevolucionxNroPedido/QR_RecepcionxNroPedido.aspx?TMVCodigo=' + tmvNumero + '&PerCodigo=' + periodoDevolucion + '&ID=' + nroDevolucion + '&FechaOP=' + fechaDevolucion);
                            }
                        } else {
                            w2alert('Debe guardar la devolución para realizar esta acción!');
                        }
                    } else {
                        w2alert('Debe buscar un despacho devuelto para realizar esta acción');
                    }
                }
            }
        });

    </script>
    <!-- Grid Devolucion por nro Material -->
    <script type="text/javascript">
        $('#gridDevDespachoNMat').w2grid({
            name: 'gridDevDespachoNMat',
            show: {
                toolbar: true,
                footer: false,
                toolbarDelete: false,
                toolbarSave: false,
                toolbarSearch: false
            },
            columns: [
			    { field: 'nroDespacho', caption: 'Nº Despacho', size: '11%', attr: 'align=center' },
			    { field: 'pboNumero', caption: 'Nº Pedido', size: '11%', attr: 'align=center' },
			    { field: 'matCodigo', caption: 'Codigo Mat.', size: '10%', attr: 'align=center' },
			    { field: 'nombreMaterial', caption: 'Nombre Material', size: '44%', attr: 'align=center' },
			    { field: 'itemPresupuestario', caption: 'Item Presupuestario', size: '33%', attr: 'align=center' },
			    { field: 'cantDespachada', caption: 'Despachado', size: '10%', attr: 'align=center' },
			    { field: 'cantDevuelta', caption: 'Devuelto', size: '8%', attr: 'align=center' },
			    { field: 'cantADevolver', caption: 'A Recibir', size: '8%', attr: 'align=center' },
			    { field: 'precioUnitario', caption: 'Precio Unitario', size: '13%', attr: 'align=center' },
			    { field: 'fechaVencimiento_desp', hidden: true },
			    { field: 'lote_desp', hidden: true }
		    ],
            onExpand: function (event) {
                //creacion de sub Grid para Detalle de los Materiales
                var cantDevuelta = parseInt(this.records[event.recid - 1].cantDevuelta);
                var cantDespachada = parseInt(this.records[event.recid - 1].cantDespachada);
                if (cantDespachada > cantDevuelta) {
                    var nroDespacho = $('#nroDespacho').val();
                    var nroPedido = $('#nroPedido').val();
                    var fechaVencimiento_ant = $.trim(this.records[event.recid - 1].fechaVencimiento_desp);
                    var lote_anterior = $.trim(this.records[event.recid - 1].lote_desp);
                    var recid_grid = event.recid;
                    var codMatrial = $.trim(this.records[event.recid - 1].matCodigo);
                    var subGridName = 'subgrid-' + $.trim(event.recid);
                    if (w2ui.hasOwnProperty('subgrid-' + $.trim(event.recid))) w2ui['subgrid-' + $.trim(event.recid)].destroy();
                    $('#' + event.box_id).css({ margin: '0px', padding: '0px', width: '100%' }).animate({ height: '178px' }, 100);
                    setTimeout(function () {
                        $('#' + event.box_id).w2grid({
                            name: 'subgrid-' + $.trim(event.recid),
                            url: '../../clases/persistencia/controladores/Recepciones/AsocDevolXNroPedido/GetDatosDevXNroPedido.ashx?tipoBusqueda=detallesMaterial' + '&nroDespacho=' + nroDespacho + '&nroPedido=' + nroPedido + '&periodoBusqueda=' + periodoBusqueda + '&codigoMaterial=' + codMatrial + '&nombreUsuario=' + userName + '&fechaVencimientoAnt=' + fechaVencimiento_ant + '&loteSerie=' + lote_anterior,
                            show: {
                                columnHeaders: true,
                                toolbar: true,
                                toolbarAdd: true,
                                toolbarDelete: true,
                                toolbarSave: true,
                                toolbarSearch: false,
                                toolbarReload: false,
                                toolbarColumns: false
                            },
                            fixedBody: false,
                            multiSelect: false,
                            columns: [
                                            { field: 'codigoMaterial', caption: 'Codigo Material', size: '10%', style: 'text-align:center' },
						                    { field: 'cantidad', caption: 'Cantidad', size: '20%', editable: { type: 'int' }, style: 'text-align:center' },
						                    { field: 'loteSerie', caption: 'Nro Lote', size: '30%', editable: { type: 'alphanumeric' }, style: 'text-align:center' },
						                    { field: 'fechaVencimiento', caption: 'Fecha Vencimiento', size: '50%', editable: { type: 'date', format: 'mm-dd-yy'} }
					                    ],
                            onAdd: function (event) {
                                var todayDate = new Date();
                                var day = todayDate.getDate();
                                var month = todayDate.getMonth() + 1;
                                var year = todayDate.getFullYear();
                                w2ui[subGridName].add({ recid: (this.records[this.total - 1].recid + 1), codigoMaterial: codMatrial, cantidad: 0, loteSerie: '0', fechaVencimiento: (day + '/' + month + '/' + year) });
                                w2ui[subGridName].total = w2ui[subGridName].total + 1;
                            },
                            onChange: function (event) {
                                event.preventDefault();


                                if (event.column == 1) {
                                    this.set(event.recid, { cantidad: event.value_new });
                                }

                                if (event.column == 2) {
                                    this.set(event.recid, { loteSerie: event.value_new.toUpperCase() });
                                }

                                if (event.column == 3) {
                                    if (this.records[event.recid - 1].cantidad > 0) {
                                        if (this.records[event.recid - 1].loteSerie != '0' && this.records[event.recid - 1].loteSerie != '' && this.records[event.recid - 1].loteSerie != 'undefined') {
                                            var todayDate = new Date();
                                            var day = todayDate.getDate();
                                            var month = todayDate.getMonth() + 1;
                                            var year = todayDate.getFullYear();
                                            var fechaNew = event.value_new;
                                            var controlFecha = 0;

                                            var fechaPart = fechaNew.split("/");

                                            if (fechaPart.length == 3) {
                                                var dia = parseInt(fechaPart[0]);
                                                var mes = parseInt(fechaPart[1]);
                                                var anio = parseInt(fechaPart[2]);

                                                if (dia <= 31 && dia > 0 && mes <= 12 && mes > 0 && anio >= 1900) {
                                                    controlFecha = 0;
                                                } else {
                                                    controlFecha = 1;
                                                    alert(" Fecha mal ingresada. Ej: " + day + '/' + month + '/' + year)
                                                }

                                            } else {
                                                controlFecha = 1;
                                                alert(" Fecha mal ingresada. Ej: " + day + '/' + month + '/' + year)
                                            }
                                            if (controlFecha > 0) {
                                                this.set(event.recid, { fechaVencimiento: day + '/' + month + '/' + year });
                                            } else {
                                                this.set(event.recid, { fechaVencimiento: event.value_new });
                                            }
                                        } else {
                                            alert('Debe ingresar el lote o serie del material');
                                        }
                                    } else {
                                        alert('Debe ingresar la cantidad a recibir del material');
                                    }
                                }
                            },
                            onSave: function (event) {
                                event.preventDefault();
                                var sumaCantidad = 0;
                                var cantidadRecibir = 0;
                                var position = 0;
                                for (i = 0; i < this.records.length; i++) {
                                    if (this.records[i].changed) {
                                        if (this.records[i].changes.cantidad != 'undefined') {
                                            sumaCantidad = sumaCantidad + parseInt(this.records[i].changes.cantidad);
                                            position = i;
                                        }
                                    } else {
                                        sumaCantidad = sumaCantidad + parseInt(this.records[i].cantidad);
                                    }
                                }
                                for (i = 0; i < w2ui.gridDevDespachoNMat.records.length; i++) {
                                    var MaterialRecid = w2ui.gridDevDespachoNMat.records[i].matCodigo;
                                    if ($.trim(MaterialRecid) == $.trim(codMatrial)) {
                                        cantidadRecibir = parseInt(w2ui.gridDevDespachoNMat.records[i].cantDespachada) - parseInt(w2ui.gridDevDespachoNMat.records[i].cantDevuelta);
                                        break;
                                    }
                                }
                                if (cantidadRecibir >= sumaCantidad) {
                                    w2ui[subGridName].request("save-records", this.records, '../../clases/persistencia/controladores/Recepciones/AsocDevolXNroPedido/GetDatosDevXNroPedido.ashx?tipoBusqueda=saveDetallesMaterial' + '&periodo=' + periodoBusqueda + '&nroDespacho=' + numeroDespacho + '&nroPedido=' + numeroPedido + '&codigoMaterial=' + codMatrial + '&nombreUsuario=' + userName + '&largoGrid=' + this.records.length + '&fechaVencimientoAnt=' + fechaVencimiento_ant + '&loteSerie=' + lote_anterior);
                                    w2ui[subGridName].requestComplete('success', 'save-records', function () {
                                        w2ui.gridDevDespachoNMat.set(recid_grid, { cantADevolver: sumaCantidad });
                                        w2alert('Detalle Ingresado con Exito!! :)');
                                    });
                                } else {
                                    this.reload();
                                    w2alert('La cantidad de materiales ingresados es MAYOR a la cantidad supuesta a recibir, por favor verifique esta información y vuelva a intentarlo.');
                                }
                            },
                            onDelete: function (event) {
                                event.preventDefault();
                                for (i = 0; this.records.length > i; i++) {
                                    if (this.records[i].selected && this.records[i].selected == true) {
                                        w2ui[subGridName].remove(this.records[i].recid);
                                        w2ui[subGridName].total = w2ui[subGridName].total - 1;
                                        w2ui[subGridName].buffered = w2ui[subGridName].buffered - 1;
                                        break;
                                    }
                                }
                            }
                        });
                        w2ui['subgrid-' + $.trim(event.recid)].resize();
                        w2ui.gridDevDespachoNMat.resize();
                    }, 300);
                } else {
                    w2alert('NO puede agregar materiales a una devolución COMPLETADA');
                }

            },
            onSave: function (event) {

                event.preventDefault();
                $.ajax({
                    url: '../../clases/persistencia/controladores/Recepciones/AsocDevolXNroPedido/GetDatosDevXNroPedido.ashx',
                    type: 'POST',
                    dataType: "json",                              //generaDevolucion? probar despues
                    data: { materiales: this.records, tipoBusqueda: 'generarDespacho', periodo: periodoBusqueda, nroDespacho: numeroDespacho, nroPedido: numeroPedido, nombreUsuario: userName, largoGrid: this.records.length },
                    success: function (response) {
                        if (response.status == 'error') {
                            w2alert(response.message);
                        } else {
                            w2alert('¡Se creo la devolución ' + response.cmvNumero + ' con éxito!');
                            tmvNumero = response.tmvCodigo;
                            nroDevolucion = response.cmvNumero;
                            periodoDevolucion = response.periodo;
                            devObservacion = $('#observacionDespacho').val();

                            w2ui.formDevDespachoNMat.record = {
                                nroDevolucion: nroDevolucion,
                                nroDespacho: numeroDespacho,
                                periodoMovimiento: periodoBusqueda,
                                observacionDespacho: $('#observacionDespacho').val(),
                                nroPedido: numeroPedido
                            }
                            w2ui.formDevDespachoNMat.refresh();
                        }
                    },
                    error: function (response) {
                        alert("Ha ocurrido un error en la operación vuelva a intentarlo más tarde.");
                    }
                });

            }
        });	
    </script>
    <%--<!-- Espacio de Codigo -->
    <script type="text/javascript">
    
    </script>
    <!-- Espacio de Codigo -->
    <script type="text/javascript">
    
    </script>
    <!-- Espacio de Codigo -->
    <script type="text/javascript">
    
    </script>
    <!-- Espacio de Codigo -->
    <script type="text/javascript">
    
    </script>--%>

</asp:Content>
