<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="DespachosXTransferencia.aspx.vb" Inherits="Bodega_WebApp.DespachosXTransferencia" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.despaTransferencias%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="formDespXTransferencia" style="height: 349px; top: 2px;">
    </div>
    <div id="gridDespXTransferencia" style="height: 400px; top: 4px;">
    </div>
</asp:Content>
<asp:Content ID="FooterContent" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="JavaScriptContent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <!-- variables Globales -->
    <script type="text/javascript">
        // nuevo, para lectura QR
        var lectorQR = 'off';
        var subGridName = '';
        var countTeclas = 0;
    </script>
    <script type="text/javascript">

        var numeroPedido = '';
        var periodoPedido = '';
        var codigoBodegaDesp = '';
        var codigoBodegaSol = '';
        var observacion = '';
        var tmvCodigo = '';
        var usuario = '';
        usuario = '<%=usuario.username %>';
        var sel_index = 0;
        var load = 0; /* como el onLoad borrar el form, esto evita que se borra cada vez que se inicia una búsqueda */

        /* Datos temp para la nueva operación */
        var numeroTransTemp = '';
        var obsTemp = '';

    </script>
    <!-- w2ui Definicion elementos de PopUp de busqueda por BODEGA-->
    <script type="text/javascript">
        var config = {
            layout: {
                name: 'layout',
                padding: 4,
                panels: [
			            { type: 'left', size: '72%', minSize: 300 },
			            { type: 'main', minSize: 300 }
		            ]
            },
            grid: {
                name: 'gridDESPTRANSF',
                columns: [
			        { field: 'periodoDespacho', caption: 'Periodo', size: '4%' },
			        { field: 'numeroPedido', caption: 'Número', size: '5%' },
			        { field: 'estadoPedido', caption: 'Estado', size: '12%' },
			        { field: 'tipoPedido', caption: 'Tipo', size: '14%' },
			        { field: 'bodegaSolicita', caption: 'Solicitado A:', size: '25%' }
		        ],
                onSelect: function (event) {
                    numeroPedido = this.records[this.last.sel_ind].numeroPedido;
                    periodoPedido = this.records[this.last.sel_ind].periodoDespacho;
                }
            },
            form: {
                header: 'Criterios de Busqueda',
                name: 'formDESPTRANSF',
                formHTML: '<div class="w2ui-page page-0">' +
		                    '<div class="w2ui-label w2ui-span5">Número Pedido:</div>' +
		                    '<div class="w2ui-field w2ui-span5">' +
			                    '<input name="numeroDESPTRANSF" type="text" maxlength="10" size="20"/>' +
		                    '</div>' +
		                    '<div class="w2ui-label w2ui-span5">Periodo:</div>' +
		                    '<div class="w2ui-field w2ui-span5">' +
			                    '<select name="periodoDESPTRANSF" type="select"/>' +
		                    '</div>' +
                            '<div class="w2ui-label w2ui-span5">Estado:</div>' +
		                    '<div class="w2ui-field w2ui-span5">' +
			                    '<select name="estadoDESPTRANSF" type="select"/>' +
		                    '</div>' +
		                '</div>' +
                        '<div class="w2ui-buttons">' +
		                    '<input type="button" value="Buscar" name="Buscar">' +
		                    '<input type="button" value="Limpiar" name="Limpiar">' +
                            '<input type="button" value="Aceptar" name="Aceptar">' +
	                    '</div>',
                fields: [
			            { name: 'numeroDESPTRANSF', type: 'text' },
			            { name: 'periodoDESPTRANSF', type: 'list',
			                options: { url: '../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx?tipoBusqueda=listaPeriodos' }
			            },
                        { name: 'estadoDESPTRANSF', type: 'list',
                            options: { url: '../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx?tipoBusqueda=estadoPedidos' }
                        }
		        ],
                actions: {
                    Buscar: function () {
                        var numeroTransf = this.record.numeroDESPTRANSF;
                        var periodoTransf = this.record.periodoDESPTRANSF;
                        var estadoTransf = this.record.estadoDESPTRANSF;

                        if (numeroTransf == '' || numeroTransf == undefined) {
                            numeroTransf = 0;
                        }
                        if (periodoTransf == '' || periodoTransf == undefined) {
                            periodoTransf = 0;
                        }
                        if (estadoTransf == undefined) {
                            estadoTransf = '';
                        }

                        w2ui.gridDESPTRANSF.url = '../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx?tipoBusqueda=busqedaListaDespachos' + '&numeroPedido=' + numeroTransf + '&periodoPedido=' + periodoTransf + '&estadoPedido=' + estadoTransf;
                        w2ui.gridDESPTRANSF.reload();
                    },
                    Aceptar: function () {

                        w2ui.formDespXTransferencia.url = '../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx?tipoBusqueda=busquedaDatosTransferencia' + '&periodo=' + periodoPedido + '&numeroPedido=' + numeroPedido;
                        w2ui.formDespXTransferencia.reload();
                        setTimeout(function () {
                            codigoBodegaDesp = $('#bodegaDespacha').val();
                            codigoBodegaSol = $('#bodegaSolicita').val();
                            w2ui.gridDespXTransferencia.url = '../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx?tipoBusqueda=buscaMatsTransferencia' + '&numeroPedido=' + numeroPedido + '&periodoPedido=' + periodoPedido + '&codBodDesp=' + codigoBodegaDesp + '&codBodSoli=' + codigoBodegaSol + '&usuario=' + usuario;
                            w2ui.gridDespXTransferencia.reload();
                        }, 500);
                        w2popup.close();
                    },
                    Limpiar: function () {
                        this.clear();
                        w2ui.gridDESPTRANSF.clear();
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
    <!-- instancia de apertura de pop up para busqueda por BODEGA -->
    <script type="text/javascript">
        function openPopup() {
            w2popup.open({
                title: 'BUSQUEDA POR TRANSFERENCIAS',
                width: 1100,
                height: 600,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                modal: true,
                onOpen: function (event) {
                    event.onComplete = function () {
                        $('#w2ui-popup #main').w2render('layout');
                        w2ui.layout.content('left', w2ui.gridDESPTRANSF);
                        w2ui.layout.content('main', w2ui.formDESPTRANSF);
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
    <!-- w2ui Form -->
    <script type="text/javascript">
        $('#formDespXTransferencia').w2form({
            name: 'formDespXTransferencia',
            focus: 0,
            header: 'Ficha Despachos por Transferencia',
            recid: 10,
            url: '../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx?tipoBusqueda=periodoForm',
            formHTML: '<div class="w2ui-page page-0">' +
		                '<div style="width: 350px; float: left;">' +
			                '<div class="w2ui-group" style="height: 228px; margin: 0;">' +
				                '<div class="w2ui-label w2ui-span4">Número:</div>' +
				                '<div class="w2ui-field w2ui-span4">' +
					                '<input name="numeroPedido" type="text" maxlength="6" id="numeroPedido"/>' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span4">Período:</div>' +
				                '<div class="w2ui-field w2ui-span4">' +
					                '<input name="periodoDespacho" type="text" maxlength="4" disabled="disabled"/>' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span4">Estado:</div>' +
				                '<div class="w2ui-field w2ui-span4">' +
					                '<input name="estadoPedido" type="text" disabled="disabled"/>' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span4">Tipo:</div>' +
				                '<div class="w2ui-field w2ui-span4">' +
					                '<input name="tipoPedido" type="text" disabled="disabled" style="width: 192px;"/>' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span4">Observación:</div>' +
				                '<div class="w2ui-field w2ui-span4">' +
					                '<textarea name="observacionPedido" type="text" style="width: 94%; height: 75px; resize: none"></textarea>' +
				                '</div>' +

                            // nuevo, para lectura QR
		                    '<div class="w2ui-field" style="display:; margin-top: -10%;position: relative;z-index: -1;">' +
                                //'<textarea name="ValQR" type="text" maxlength="80" id="ValQR" ></textarea>' + "visibility:hidden
                                //'<textarea name="ValQR" type="text" maxlength="80" id="ValQR" visibility:hidden ></textarea>' +
                            '</div>' +

			                '</div>' +
		                '</div>' +
		                '<div style="margin-left: 365px;">' +
			                '<div class="w2ui-group" style="height: 106px; width: 96%;">' +
				                '<div class="w2ui-label w2ui-span7">Bodega Solicitante:</div>' +
				                '<div class="w2ui-field w2ui-span7">' +
					                '<input name="bodegaSolicita" type="text" maxlength="50" style="width: 60px; margin-right: 2px;" disabled="disabled"/>' +
                                    '-' +
					                '<input name="nombreBodegaSolicita" type="text" style="width: 160px; margin-left: 2px;" disabled="disabled"/>' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span7">Bodega Despachante:</div>' +
				                '<div class="w2ui-field w2ui-span7">' +
					                '<input name="bodegaDespacha" type="text" maxlength="50" style="width: 60px; margin-right: 2px;" disabled="disabled"/>' +
                                    '-' +
					                '<input name="nombreBodegaDespacha" type="text" style="width: 160px; margin-left: 2px;" disabled="disabled"/>' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span7" style="display: none;" >Nueva Recepción:</div>' +
				                '<div class="w2ui-field w2ui-span7" style="display: none;" >' +
					                '<input name="newIngreso" id="newIngreso" type="checkbox" style="margin-right: 2px;"/>' +
				                '</div>' +
			                '</div>' +
		                '</div>' +
                        '<div style="margin-left: 365px;">' +
                            '<div style="padding: 3px; font-weight: bold; color: #777;">Transferencia Generada</div>' +
			                '<div class="w2ui-group" style="height: 90px; width: 96%;">' +
				                '<div class="w2ui-label w2ui-span6">Nº Transferencia:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<input name="nroTransferencia" type="text" maxlength="50" style="width: 60px; margin-right: 2px;" disabled="disabled"/>' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span6">Periodo:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<input name="periodoTransferencia" type="text" maxlength="50" style="width: 60px; margin-right: 2px;" disabled="disabled"/>' +
				                '</div>' +
			                '</div>' +
		                '</div>' +

	                '</div>' +
	                '<div class="w2ui-buttons">' +
		                '<input type="button" value="Pedidos x Bodega" name="buscarPedidosBod" style="width: 10%;">' +
		                '<input type="button" value="Guardar" name="guardarDespacho" style="width: 10%; border-color: cornflowerblue;">' +
		                '<input type="button" value="Imprimir Traspaso" name="imprimirTraspaso" style="width: 11%;">' +
                        '<input type="button" value="Limpiar" name="limpiarPedido" style="width: 10%;">' +
	                '</div>',
            fields: [
			    { name: 'numeroPedido', type: 'int' },
			    { name: 'periodoDespacho', type: 'int' },
			    { name: 'estadoPedido', type: 'text' },
			    { name: 'tipoPedido', type: 'text' },
			    { name: 'observacionPedido', type: 'text' },
			    { name: 'bodegaSolicita', type: 'text' },
			    { name: 'nombreBodegaSolicita', type: 'text' },
			    { name: 'bodegaDespacha', type: 'text' },
			    { name: 'nombreBodegaDespacha', type: 'text' },
			    { name: 'newIngreso', type: 'checkbox' },
                { name: 'nroTransferencia', type: 'int' },
                { name: 'periodoTransferencia', type: 'int' },
                { name: 'ValQR', type: 'text'} // nuevo, para lectura QR
		    ],
            onLoad: function (event) {

                if (load == 0) {
                    setTimeout(function () {

                        var todayDate = new Date();
                        var year = todayDate.getFullYear();
                        /* Izquierda */
                        w2ui['formDespXTransferencia'].record['numeroPedido'] = '';
                        w2ui['formDespXTransferencia'].record['estadoPedido'] = '';
                        w2ui['formDespXTransferencia'].record['tipoPedido'] = '';
                        w2ui['formDespXTransferencia'].record['observacionPedido'] = '';
                        /* Derecha*/
                        w2ui['formDespXTransferencia'].record['bodegaSolicita'] = '';
                        w2ui['formDespXTransferencia'].record['nombreBodegaSolicita'] = '';
                        w2ui['formDespXTransferencia'].record['bodegaDespacha'] = '';
                        w2ui['formDespXTransferencia'].record['nombreBodegaDespacha'] = '';
                        w2ui['formDespXTransferencia'].record['nroTransferencia'] = '0';

                        /* Datos relevantes */
                        w2ui['formDespXTransferencia'].record['periodoDespacho'] = year;
                        w2ui['formDespXTransferencia'].record['periodoTransferencia'] = year;
                        // nuevo, para lectura QR
                        w2ui['formDespXTransferencia'].record['ValQR'] = '';
                        w2ui['formDespXTransferencia'].refresh();

                        $('#numeroPedido').focus();

                    }, 350);
                }
            },
            onChange: function (event) {

                /* Agregar cambio buscador instantaneo. */
                if (event.target == "numeroPedido") {
                    load = 1;
                    setTimeout(function () {
                        TransferenciaBodega_Fast();
                    }, 600);
                }

            },
            actions: {
                buscarPedido: function () {
                    periodoPedido = $('#periodoDespacho').val();
                    numeroPedido = $('#numeroPedido').val();
                    if (numeroPedido != '' && numeroPedido != '0' && numeroPedido != undefined) {
                        if (periodoPedido != '' && periodoPedido != '0' && periodoPedido != undefined) {
                            w2ui.formDespXTransferencia.url = '../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx?tipoBusqueda=busquedaDatosTransferencia' + '&periodo=' + periodoPedido + '&numeroPedido=' + numeroPedido;
                            w2ui.formDespXTransferencia.reload();
                            setTimeout(function () {
                                codigoBodegaDesp = $('#bodegaDespacha').val();
                                codigoBodegaSol = $('#bodegaSolicita').val();
                                w2ui.gridDespXTransferencia.url = '../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx?tipoBusqueda=buscaMatsTransferencia' + '&periodo=' + periodoPedido + '&numeroPedido=' + numeroPedido + '&codBodDesp=' + codigoBodegaDesp + '&codBodSoli=' + codigoBodegaSoli;
                                w2ui.gridDespXTransferencia.reload();
                            }, 300);
                        } else {
                            w2alert('Debe ingresar el período del pedido para realizar la búsqueda');
                        }
                    } else {
                        w2alert('Debe ingresar el número del pedido para realizar la búsqueda');
                    }

                },
                buscarPedidosBod: function () {
                    load = 1;
                    openPopup();
                },
                limpiarPedido: function () {

                    var todayDate = new Date();
                    var year = todayDate.getFullYear();

                    /* Izquierda */
                    w2ui['formDespXTransferencia'].record['numeroPedido'] = '';
                    w2ui['formDespXTransferencia'].record['estadoPedido'] = '';
                    w2ui['formDespXTransferencia'].record['tipoPedido'] = '';
                    w2ui['formDespXTransferencia'].record['observacionPedido'] = '';

                    /* Derecha*/
                    w2ui['formDespXTransferencia'].record['bodegaSolicita'] = '';
                    w2ui['formDespXTransferencia'].record['nombreBodegaSolicita'] = '';
                    w2ui['formDespXTransferencia'].record['bodegaDespacha'] = '';
                    w2ui['formDespXTransferencia'].record['nombreBodegaDespacha'] = '';
                    w2ui['formDespXTransferencia'].record['nroTransferencia'] = '0';

                    /* Datos relevantes */
                    w2ui['formDespXTransferencia'].record['periodoDespacho'] = year;
                    w2ui['formDespXTransferencia'].record['periodoTransferencia'] = year;
                    w2ui['formDespXTransferencia'].record['ValQR'] = '';
                    this.refresh();

                    w2ui.gridDespXTransferencia.clear();
                },
                /* globalSave, saveForm */
                guardarDespacho: function () {
                    codigoBodegaDesp = $('#bodegaDespacha').val();
                    codigoBodegaSol = $('#bodegaSolicita').val();
                    observacion = $('#observacionPedido').val();

                    if (w2ui['formDespXTransferencia'].record['estadoPedido'] == 'DESP.PARCIAL' || w2ui['formDespXTransferencia'].record['estadoPedido'] == 'DESP.TOTAL' || w2ui['formDespXTransferencia'].record['estadoPedido'] == 'ANULADO') {

                        w2alert(' La Transferencia Nº ' + w2ui['formDespXTransferencia'].record['nroTransferencia'] + ' ya se encuentra registrada.');

                    } else {

                        if (w2ui['formDespXTransferencia'].record['nroTransferencia'] != '0') {

                            $.ajax({
                                url: '../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx',
                                type: 'POST',
                                dataType: "json",
                                data: { tipoBusqueda: 'guardaTransferencia', numeroPedido: w2ui['formDespXTransferencia'].record['numeroPedido'], periodoDespacho: w2ui['formDespXTransferencia'].record['periodoDespacho'], observacionPedido: w2ui['formDespXTransferencia'].record['observacionPedido'], bodegaSolicita: w2ui['formDespXTransferencia'].record['bodegaSolicita'], bodegaDespacha: w2ui['formDespXTransferencia'].record['bodegaDespacha'], nroTransferencia: w2ui['formDespXTransferencia'].record['nroTransferencia'], usuario: usuario },
                                success: function (response) {

                                    if (response.status == 'error') {
                                        w2alert(response.message);
                                    } else {

                                        var Obs = $('#observacionPedido').val();
                                        Obs = Obs.toUpperCase();
                                        $('#observacionPedido').val(Obs);

                                        w2ui.gridDespXTransferencia.url = '../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx?tipoBusqueda=buscaMatsTransferencia' + '&numeroPedido=' + w2ui['formDespXTransferencia'].record['numeroPedido'] + '&periodoPedido=' + w2ui['formDespXTransferencia'].record['periodoDespacho'] + '&codBodDesp=' + w2ui['formDespXTransferencia'].record['bodegaDespacha'] + '&codBodSoli=' + w2ui['formDespXTransferencia'].record['bodegaSolicita'] + '&usuario=' + usuario;
                                        w2ui.gridDespXTransferencia.reload();


                                        w2alert('¡Se creo el despacho de Transferencia Nº ' + response.cmvNumero + ' con éxito!');

                                    }

                                },
                                error: function (response) {
                                    alert("Ha ocurrido un error en la operación vuelva a intentarlo más tarde.");
                                }
                            });

                        } else {
                            w2alert(' Primero debe indicar el detalle de produtos. ');
                        }


                    } // verifica que no pueda volver a ser ingresado.

                },
                imprimirDespacho: function () {
                    alert('Imprimir 1');
                },
                imprimirTraspaso: function () {

                    var NTransaccion;
                    var periodo;
                    var proveedor;
                    var bodega;
                    var bodega2;
                    var NumDocumento;

                    // Identifica ID de busqueda.
                    if (w2ui['formDespXTransferencia'].record['numeroPedido'] && w2ui['formDespXTransferencia'].record['periodoDespacho']) {
                        NTransaccion = w2ui['formDespXTransferencia'].record['numeroPedido'];
                        periodo = w2ui['formDespXTransferencia'].record['periodoDespacho'];

                        if (w2ui['formDespXTransferencia'].record['estadoPedido']) {
                            proveedor = w2ui['formDespXTransferencia'].record['estadoPedido'];

                            if (w2ui['formDespXTransferencia'].record['bodegaSolicita'] && w2ui['formDespXTransferencia'].record['bodegaDespacha']) {
                                bodega = w2ui['formDespXTransferencia'].record['nombreBodegaSolicita'];
                                bodega2 = w2ui['formDespXTransferencia'].record['nombreBodegaDespacha'];

                                if (w2ui['formDespXTransferencia'].record['nroTransferencia']) {
                                    NumDocumento = w2ui['formDespXTransferencia'].record['nroTransferencia'];


                                    /* Graba materiales en la tabla TEMP */
                                    var cont = 1;
                                    var CodigoMaterial;
                                    var NombreMaterial;
                                    var itemMaterial;
                                    var CantidadMovimiento;
                                    var CantDespachar;
                                    var total;
                                    var observacion = w2ui['formDespXTransferencia'].record['observacionPedido'];

                                    var done = 0;
                                    var ReportUsuario = '';

                                    for (var i = 0; i <= w2ui['gridDespXTransferencia'].records.length - 1; i++) {

                                        CodigoMaterial = w2ui['gridDespXTransferencia'].records[i].codigoMaterial;
                                        NombreMaterial = w2ui['gridDespXTransferencia'].records[i].nombreMaterial;
                                        itemMaterial = w2ui['gridDespXTransferencia'].records[i].codigoItem;
                                        CantidadMovimiento = w2ui['gridDespXTransferencia'].records[i].cantidadEntregado;
                                        CantDespachar = w2ui['gridDespXTransferencia'].records[i].existenciaBDesp;
                                        total = parseInt(w2ui['gridDespXTransferencia'].records[i].cantidadEntregado) * parseInt(w2ui['gridDespXTransferencia'].records[i].precioUnitario)


                                        $.ajax({
                                            type: "POST",
                                            url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                                            async: false,
                                            data: { "cmd": 'RPTInforme', "NTransaccion": NTransaccion, "periodo": periodo, "codTransaccion": '8', "Linea": cont, "codMaterial": CodigoMaterial, "nombreMaterial": NombreMaterial, "CodItem": '', "cantMaterial": CantidadMovimiento, "precioMaterial": '0', "bodega": bodega, "descripcion": observacion.toUpperCase(), "fechaMovimieno": '01/01/1900', "proveedor": bodega2, "ordenCompra": '0', "ordenCompraEstado": '', "numeroDocumento": NumDocumento, "Institucion": itemMaterial, "centroCosto": '', "tipoDocumento": '', "tituloMenu": 'TRASPASO ENTRE BODEGAS', "descuento": CantDespachar, "impuesto": total, "diferenciaPeso": '0', "usuario": '' },
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
                                        window.open('../../reportes/Despachos/Transferencia/Rpt_DespachoXTransferencia.aspx?CMVCodigo=' + NTransaccion + '&PERCodigo=' + periodo + '&TMVCodigo=' + '8' + '&usuario=' + ReportUsuario);
                                    } else {
                                        alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                    }

                                } else { alert("Primero se debe generar la transacción."); } // Fin nroTransferencia.
                            } else { alert("Faltan datos para imprimir."); } // Fin bodegaSolicita.
                        } else { alert("Faltan datos para imprimir."); } // Fin estadoPedido.
                    } else { // alerta de mensaje por no ingresar nada, numeroPedido ni periodoDespacho.
                        alert("Primero ingrese o búsque un préstamo.");
                    }
                }
            }
        });
    </script>
    <!-- Comentario -->
    <script type="text/javascript">
    /* gridPrincipal, */
        $('#gridDespXTransferencia').w2grid({
            name: 'gridDespXTransferencia',
            show: {
                toolbar: true,
                footer: true,
                toolbarAdd: false,
                toolbarDelete: false,
                toolbarSave: false,
                toolbarEdit: false,
                toolbarSearch: false,
                toolbarQR: true // nuevo, para lectura QR
            },
            columns: [
			    { field: 'codigoMaterial', caption: 'Cod. Material', size: '8%' },
                { field: 'nombreMaterial', caption: 'Nombre Material', size: '18%' },
                { field: 'codigoItem', caption: 'Cod.Item', size: '8%' },
                { field: 'nombreItem', caption: 'Nom.Item', size: '12%' },
                { field: 'cantidadPedida', caption: 'Pedida', size: '7%', attr: 'align=center' },
			    { field: 'cantidadEntregado', caption: 'Entregado', size: '7%', attr: 'align=center' },
                { field: 'cantidadPendiente', caption: 'Pendiente', size: '7%', attr: 'align=center' },
			    { field: 'existenciaBSol', caption: 'Exis.B Reci.', size: '8%', attr: 'align=center' },
			    { field: 'existenciaBDesp', caption: 'Exis.B Desp', size: '8%', attr: 'align=center' },
			    { field: 'precioUnitario', caption: '$ Unitario', size: '8%', attr: 'align=center' },
			    { field: 'total', caption: 'Total', size: '8%', attr: 'align=center' }
		    ],
            onQR: function (event) { // nuevo, para lectura QR
                event.preventDefault();
                console.log(event);

                if (lectorQR == 'on') {
                    console.log('Off QR');
                    lectorQR = 'off';
                    $('#ValQR').focus();
                    w2ui[subGridName].remove(this.records.length);
                } else {
                    console.log('On QR');
                    /*setTimeout(function () {
                    $('#tb_' + 'gridDespXTransferencia_toolbar' + '_item_' + 'QR' + ' table.w2ui-button').addClass('checked');
                    $('#tb_' + 'gridDespXTransferencia_toolbar' + '_item_' + 'QR' + ' table.w2ui-button').prop("checked", true);
                        
                    }, 100);*/

                    if (subGridName != '') {
                        lectorQR = 'on';
                        w2ui[subGridName].editField(w2ui[subGridName].records.length, 2, '');
                    } else {
                        // setTimeout(function () {
                        //  $('#tb_' + 'gridDespXTransferencia_toolbar' + '_item_' + 'QR' + ' table.w2ui-button').removeClass('checked');
                        //  $('#tb_' + 'gridDespXTransferencia_toolbar' + '_item_' + 'QR' + ' table.w2ui-button').prop("checked", false);
                        lectorQR = 'off';
                        w2alert('Seleccione el detalle del elemento a transferir!.');
                        //}, 100);
                    }
                }
            },
            onCollapse: function (event) { // nuevo, para cuando cierra el sub grid
                // tambien debe existir al finalizar el sub save.
                lectorQR = 'off';
            },
            onSelect: function (event) {
                // remueve o borra la propiedad checked del boton lector.
                setTimeout(function () {
                    $('#tb_' + 'gridDespXTransferencia_toolbar' + '_item_' + 'QR' + ' table.w2ui-button').removeClass('checked');
                    $('#tb_' + 'gridDespXTransferencia_toolbar' + '_item_' + 'QR' + ' table.w2ui-button').prop("checked", false);
                }, 10);
            },
            onExpand: function (event) {

                var idLocalTemp = event.recid;
                var IDTemp;

                var date = new Date();
                var actualDate = date.getDate() + '/' + (date.getMonth() + 4) + '/' + date.getFullYear();

                // ----------------------------------
                // Encuentra el Recid actualmente utilizado.
                for (var z = 0; z <= w2ui['gridDespXTransferencia'].records.length - 1; z++) {

                    var recid = w2ui['gridDespXTransferencia'].records[z].recid;

                    if (event.recid == recid) {
                        IDTemp = z;
                    }

                } // fin for 2
                // ----------------------------------

                // Nombre del Grid
                subGridName = 'subgrid-' + $.trim(event.recid);

                if (w2ui.hasOwnProperty('subgrid-' + event.recid)) w2ui['subgrid-' + event.recid].destroy();
                $('#' + event.box_id).css({ margin: '0px', padding: '0px', width: '100%' }).animate({ height: '105px' }, 100);

                var IDTemp;
                // ----------------------------------
                // Encuentra el Recid actualmente utilizado.
                for (var z = 0; z <= w2ui['gridDespXTransferencia'].records.length - 1; z++) {

                    var recid = w2ui['gridDespXTransferencia'].records[z].recid;

                    if (event.recid == recid) {
                        IDTemp = z;
                    }

                } // fin for 2
                // ----------------------------------
                var codMatrial = $.trim(event.recid);

                setTimeout(function () {

                    var anio = w2ui['formDespXTransferencia'].record['periodoDespacho'];

                    // Busca de acuerdo a si es Nuevo o Antiguo.
                    if (anio >= 2015) {

                        $('#' + event.box_id).w2grid({
                            name: 'subgrid-' + event.recid,
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
                            columns: [
						            { field: 'codMaterial2', caption: 'Cod. Material', size: '30%' },
						            { field: 'cantidad2', caption: 'Cantidad', size: '30%',
						                editable: { type: 'int', format: 'maxlength = 4' }, attr: "align=center"
						            },
						            { field: 'loteSerie2', caption: 'Serie o Lote', size: '30%',
						                editable: { type: 'text', inTag: 'maxlength = 80' }, attr: "align=center, onkeypress='return justCount(event);'"  // nuevo, para lectura QR
						            },
						            { field: 'fechaVencimiento2', caption: 'Fecha Vto.', size: '30%',
						                editable: { type: 'date', format: 'dd/mm/yy' }, attr: "align=center"
						            }
					            ],
                            records: [
						            { recid: 1, codMaterial2: w2ui['gridDespXTransferencia'].records[IDTemp].codigoMaterial, cantidad2: '0', loteSerie2: '', fechaVencimiento2: actualDate }
					            ]
                            ,
                            //-------------------------

                            // ================================
                            /* saveSubGrid, saveExpand, saveDetalle */
                            onSave: function (event) {

                                var sumaCantidad = 0;
                                var cantidadRecibir = 0;
                                var position = 0;

                                if (w2ui['formDespXTransferencia'].record['estadoPedido'] == 'DESP.PARCIAL' || w2ui['formDespXTransferencia'].record['estadoPedido'] == 'DESP.TOTAL' || w2ui['formDespXTransferencia'].record['estadoPedido'] == 'ANULADO') {

                                    w2alert(' La transferencia ya fue efectuada.');

                                } else {

                                    // nuevo, si la lectura de QR esta activada borra el ultimo elemento en blanco.
                                    if (lectorQR == 'on') {
                                        w2ui[subGridName].remove(w2ui[subGridName].records.length);
                                    }

                                    for (i = 0; i < this.records.length; i++) {
                                        if (this.records[i].changed) {
                                            if (this.records[i].changes.cantidad2 != 'undefined') {
                                                sumaCantidad = sumaCantidad + parseInt(this.records[i].changes.cantidad2);
                                                position = i;
                                            }
                                        } else {
                                            sumaCantidad = sumaCantidad + parseInt(this.records[i].cantidad2);
                                        }
                                    }

                                    for (i = 0; i < w2ui['gridDespXTransferencia'].records.length; i++) {
                                        var MaterialRecid = w2ui['gridDespXTransferencia'].records[i].codigoMaterial;
                                        if (MaterialRecid == codMatrial) {
                                            cantidadRecibir = parseInt(w2ui['gridDespXTransferencia'].records[i].cantidadPendiente);
                                            break;
                                        }
                                    }


                                    var codMaterial;
                                    var cantidadMaterial;
                                    var LoteMaterial;
                                    var fechaVto;
                                    var exitoCorrelativo = 0;
                                    var exito = 0;

                                    if (cantidadRecibir >= sumaCantidad) {

                                        /* Busca correlativo para el save grobal */
                                        if (w2ui['formDespXTransferencia'].record['nroTransferencia'] == '0') {

                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/Despachos/PorTransferencia/getCorrelativo_DespachoTransferencia.ashx",
                                                async: false,
                                                data: { "fecha": w2ui['formDespXTransferencia'].record['periodoTransferencia'] },
                                                dataType: "json",
                                                success: function (response) {

                                                    if (response.item == "null") {

                                                        alert('¡Error, Correlativo no encontrado!')

                                                    } else {
                                                        w2ui['formDespXTransferencia'].record['nroTransferencia'] = response.Correlativo;
                                                        w2ui['formDespXTransferencia'].refresh();

                                                        exitoCorrelativo = 1;

                                                    } // Fin Validador de codigo

                                                } // Fin success
                                            }); // fin ajax

                                        } // fin if existe correlativo                                    

                                        if (exitoCorrelativo = 1) {
                                            for (i = 0; i < this.records.length; i++) {

                                                codMaterial = this.records[i].codMaterial2;

                                                if (this.records[i].changes) {
                                                    cantidadMaterial = this.records[i].changes.cantidad2;
                                                } else {
                                                    cantidadMaterial = this.records[i].cantidad2;
                                                }

                                                LoteMaterial = this.records[i].loteSerie2;
                                                fechaVto = this.records[i].fechaVencimiento2;

                                                $.ajax({
                                                    type: "POST",
                                                    url: "../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx",
                                                    async: false,
                                                    data: { "tipoBusqueda": 'guardarDetalleMat', "NumPedido": w2ui['formDespXTransferencia'].record['numeroPedido'], "PeriodoPedido": w2ui['formDespXTransferencia'].record['periodoDespacho'], "NuevoNumTransaccion": w2ui['formDespXTransferencia'].record['nroTransferencia'], "lengthDetalles": this.records.length, "codMaterial": codMaterial, "cantidadMaterial": cantidadMaterial, "LoteMaterial": LoteMaterial, "fechaVto": fechaVto, "numeroLinea": i + 1 },
                                                    dataType: "json",
                                                    success: function (response) {
                                                        exito = 1;
                                                    } // Fin success
                                                }); // fin ajax
                                            }

                                            /* si se realiza la transaccion se cambia de color la ventana*/
                                            if (exito = 1) {

                                                var recid = w2ui['gridDespXTransferencia'].records[IDTemp].recid;
                                                var CodMaterial = w2ui['gridDespXTransferencia'].records[IDTemp].codigoMaterial;
                                                var nombreMaterial = w2ui['gridDespXTransferencia'].records[IDTemp].nombreMaterial;
                                                var codigoItem = w2ui['gridDespXTransferencia'].records[IDTemp].codigoItem;
                                                var nombreItem = w2ui['gridDespXTransferencia'].records[IDTemp].nombreItem;
                                                var cantidadPedida = w2ui['gridDespXTransferencia'].records[IDTemp].cantidadPedida;
                                                var cantidadEntregado = sumaCantidad;
                                                var cantidadPendiente = parseInt(w2ui['gridDespXTransferencia'].records[IDTemp].cantidadPedida) - sumaCantidad;
                                                var existenciaBSol = w2ui['gridDespXTransferencia'].records[IDTemp].existenciaBSol
                                                var existenciaBDesp = w2ui['gridDespXTransferencia'].records[IDTemp].existenciaBDesp;
                                                var precioUnitario = w2ui['gridDespXTransferencia'].records[IDTemp].precioUnitario;
                                                var total = sumaCantidad * parseInt(w2ui['gridDespXTransferencia'].records[IDTemp].precioUnitario);

                                                w2ui['gridDespXTransferencia'].remove(recid);
                                                w2ui['gridDespXTransferencia'].add({ recid: recid, codigoMaterial: CodMaterial, nombreMaterial: nombreMaterial, codigoItem: codigoItem, nombreItem: nombreItem, cantidadPedida: cantidadPedida, cantidadEntregado: cantidadEntregado, cantidadPendiente: cantidadPendiente, existenciaBSol: existenciaBSol, existenciaBDesp: existenciaBDesp, precioUnitario: precioUnitario, total: total, "style": "background-color: #C2F5B4" });

                                                // indica que la lectura sera desactivada debido al collapse el grid
                                                lectorQR = 'off';
                                                w2alert('Detalle Ingresado con Exito.');

                                            } else {
                                                w2alert('Error en el ingreso del detalle.');
                                            }

                                        } else {
                                            w2alert('Error de conexión.');
                                        }

                                    } else {
                                        this.reload();
                                        w2alert('La cantidad de materiales ingresados es MAYOR a la cantidad supuesta a recibir, por favor verifique esta información y vuelva a intentarlo.');
                                    }

                                } // fin bandera save.

                            },
                            //===========================
                            //===========================

                            onChange: function (event) {

                                var local_CodMaterial;
                                var local_Cantidad;
                                var local_Serielote;
                                var local_fechaVto;
                                var CantDespachado = parseInt(w2ui['gridDespXTransferencia'].records[IDTemp].cantidadPendiente);

                                // Cantidad. 
                                if (event.column == 1) {

                                    if (event.value_new > CantDespachado) {
                                        alert('Cantidad Ingresada Supera a Cantidad Solicitada');
                                        event.value_new = 0;
                                    }

                                } // fin columna 1


                                /* Serie o lote. */ // nuevo, para lectura QR
                                if (event.column == 2) {

                                    // Si excede el maximo permitido significa que esta siendo leido el QR.
                                    if (lectorQR == 'on') {
                                        console.log('QR');
                                        var str = event.value_new.toUpperCase();
                                        var inicioNserie = str.indexOf("NUMSERIE");
                                        inicioNserie = inicioNserie + 9;
                                        var finalNserie = inicioNserie + 30;
                                        var res = str.substring(inicioNserie, finalNserie);
                                        var NserieCadena = res.split(" ", 1);
                                        Nserie = NserieCadena[0];
                                        Nserie = Nserie.substring(0, Nserie.length - 1);
                                        /* 
                                        console.log('QR');
                                        var str = event.value_new.toUpperCase();
                                        var inicioNserie = str.indexOf("SERIELOTE");
                                        inicioNserie = inicioNserie + 10;
                                        var finalNserie = inicioNserie + 16;
                                        var res = str.substring(inicioNserie, finalNserie);
                                        var NserieCadena = res.split(" ", 1);
                                        Nserie = NserieCadena[0];
                                        Nserie = Nserie.substring(0, Nserie.length - 1);
                                        */
                                    } else {
                                        console.log('No QR');
                                        Nserie = event.value_new.toUpperCase();
                                    }

                                    var CantDevolver = parseInt(w2ui['gridDespXTransferencia'].records[IDTemp].cantidad);

                                    $.ajax({
                                        type: "POST",
                                        url: "../../clases/persistencia/controladores/validaDetalleMaterial.ashx",
                                        async: false,
                                        data: { "cmd": 'validaTraeFVto', "codMaterial": w2ui['gridDespXTransferencia'].records[IDTemp].codigoMaterial, "Bodega": w2ui['formDespXTransferencia'].record['bodegaDespacha'], "Nserie": Nserie },
                                        dataType: "json",
                                        success: function (response) {

                                            if (response.validate == "1") {

                                                //w2alert('¡Error, No existe registro de material para este Nº Serie.!')
                                                local_Serielote = '';
                                                local_fechaVto = '';

                                                // si no existe registro debe refrescar la opcion de busqueda de QR
                                                swal({ title: "Cancelar búsqueda por QR?",
                                                    text: "Continuar o no usando la pistola de lectura!",
                                                    type: "warning",
                                                    showCancelButton: true,
                                                    cancelButtonText: 'No',
                                                    cancelButtonColor: "#DD6B55",
                                                    confirmButtonColor: "#59B33A",
                                                    confirmButtonText: "Si",
                                                    closeOnConfirm: false
                                                },
                                                 function () {
                                                     console.log('ok');
                                                 });

                                            } else {

                                                Global_SaveSubGrid = 1;
                                                local_Cantidad = parseInt(response.FLD_MOVCANTIDAD);

                                                var sumaCantidad = 0;
                                                for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                                    if (w2ui[subGridName].records[i].cantidad2) {
                                                        sumaCantidad = sumaCantidad + parseInt(w2ui[subGridName].records[i].cantidad2);
                                                    }
                                                }
                                                CantDevolver = CantDevolver - sumaCantidad;

                                                if (local_Cantidad > CantDevolver) {
                                                    local_Cantidad = CantDevolver
                                                }

                                                local_Serielote = Nserie;
                                                local_fechaVto = response.FLD_FECHAVENCIMIENTO;
                                            } // Fin Validador de codigo

                                        } // Fin success
                                    }); // fin ajax

                                    for (var i = 0; i < w2ui[subGridName].records.length; i++) {

                                        if (event.recid == w2ui[subGridName].records[i].recid) {

                                            local_CodMaterial = w2ui[subGridName].records[i].codMaterial2;
                                            //local_Serielote = event.value_new.toUpperCase();

                                            // para valiar que la cantidad ingresada.
                                            if (local_Cantidad == "") {
                                                if (w2ui[subGridName].records[i].cantidad2 == "") {
                                                    local_Cantidad = "";
                                                } else {
                                                    local_Cantidad = w2ui[subGridName].records[i].cantidad2;
                                                }
                                            }

                                            // para valiar que la fecha este ingresada.
                                            if (local_fechaVto == "") {
                                                if (w2ui[subGridName].records[i].fechaVencimiento2 == "") {
                                                    local_fechaVto = "";
                                                } else {
                                                    local_fechaVto = w2ui[subGridName].records[i].fechaVencimiento2;
                                                }
                                            }
                                        }
                                    }

                                    w2ui[subGridName].remove('');
                                    w2ui[subGridName].remove(event.recid);
                                    w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });

                                    // nuevo, para lectura QR
                                    if (lectorQR == 'on' && local_Cantidad != undefined) {
                                        var todayDate = new Date();
                                        var day = todayDate.getDate();
                                        var month = todayDate.getMonth() + 1;
                                        var year = todayDate.getFullYear();
                                        w2ui[subGridName].add({ recid: (this.records[this.total - 1].recid + 1), codMaterial2: w2ui['gridDespXTransferencia'].records[IDTemp].codigoMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: (day + '/' + month + '/' + year) });
                                        w2ui[subGridName].total = w2ui[subGridName].total + 1;

                                        setTimeout(function () {
                                            $('#ValQR').val('');
                                            setTimeout(function () {
                                                w2ui[subGridName].editField(w2ui[subGridName].records.length, 2, '');
                                            }, 120); // 100 max qr
                                        }, 200); // 900 max qr
                                    }

                                } // fin columna 2.


                                // Fecha Vto.
                                if (event.column == 3) {

                                    var fechaNew = event.value_new;
                                    var controlFecha = 0;

                                    var fechaPart = fechaNew.split("/");

                                    if (fechaPart.length == 3) {
                                        var dia = parseInt(fechaPart[0]);
                                        var mes = parseInt(fechaPart[1]);
                                        var anio = parseInt(fechaPart[2]);

                                        if (dia <= 31 && mes <= 12 && anio >= 1900) {

                                        } else {
                                            controlFecha = 1;
                                            alert(" Fecha mal ingresada.")
                                            event.value_new = '01/01/1900';
                                        }

                                    } else {
                                        controlFecha = 1;
                                        alert(" Fecha mal ingresada. Ej: 01/01/1900")
                                        event.value_new = '01/01/1900';
                                    }

                                } // fin columna 3.

                            }, // fin Onchange
                            //===========================
                            onAdd: function (event) {

                                if (w2ui['formDespXTransferencia'].record['estadoPedido'] == 'DESP.PARCIAL' || w2ui['formDespXTransferencia'].record['estadoPedido'] == 'DESP.TOTAL' || w2ui['formDespXTransferencia'].record['estadoPedido'] == 'ANULADO') {

                                    w2alert(' La transferencia ya fue efectuada.');

                                } else {
                                    var todayDate = new Date();
                                    var day = todayDate.getDate();
                                    var month = todayDate.getMonth() + 1;
                                    var year = todayDate.getFullYear();
                                    w2ui[subGridName].add({ recid: (this.records[this.total - 1].recid + 1), codMaterial2: w2ui['gridDespXTransferencia'].records[IDTemp].codigoMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: (day + '/' + month + '/' + year) });
                                    w2ui[subGridName].total = w2ui[subGridName].total + 1;

                                }

                            },
                            //===========================
                            onDelete: function (event) {
                                event.preventDefault();


                                if (w2ui['formDespXTransferencia'].record['estadoPedido'] == 'DESP.PARCIAL' || w2ui['formDespXTransferencia'].record['estadoPedido'] == 'DESP.TOTAL' || w2ui['formDespXTransferencia'].record['estadoPedido'] == 'ANULADO') {

                                    w2alert('La transferencia ya fue efectuada.');

                                } else {

                                    for (i = 0; this.records.length > i; i++) {
                                        if (this.records[i].selected && this.records[i].selected == true) {
                                            w2ui[subGridName].remove(this.records[i].recid);
                                            w2ui[subGridName].total = w2ui[subGridName].total - 1;
                                            w2ui[subGridName].buffered = w2ui[subGridName].buffered - 1;
                                            if (this.total == -1 && this.records.length == 0) {
                                                var todayDate = new Date();
                                                var day = todayDate.getDate();
                                                var month = todayDate.getMonth() + 1;
                                                var year = todayDate.getFullYear();
                                                w2ui[subGridName].add({ recid: 1, codMaterial2: w2ui['gridDespXTransferencia'].records[IDTemp].codigoMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: (day + '/' + month + '/' + year) });
                                                w2ui[subGridName].total = w2ui[subGridName].total + 1;
                                            }
                                            break;
                                        }
                                    }

                                } // Si esta ingresado no se puede eliminar.

                            }
                            //-------------------------

                        }); // fin abrir grid para detalle, cuando existen valores 2014


                        // -----------------------------
                        // Maneja los datos del Sub Grid
                        // -----------------------------

                        w2ui['subgrid-' + event.recid].resize();
                        w2ui.gridDespXTransferencia.resize();

                        var periodo = parseInt($('#periodoDespacho').val());

                        // Al cambiar de selector si continua el 'Lector QR' presionado activa el edit del NSerie del nuevo elemento seleccionado
                        if (lectorQR == 'on') {
                            w2ui[subGridName].editField(1, 2, '');
                        }

                        /* Datos em TEMP o Real */
                        if (w2ui['formDespXTransferencia'].record['numeroPedido'] && $('#nroTransferencia').val() > '0') {

                            $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx",
                                async: false,
                                data: { "tipoBusqueda": 'BuscaOrigenDeDatos', "NumTransferencia": w2ui['formDespXTransferencia'].record['nroTransferencia'], "periodoPedido": w2ui['formDespXTransferencia'].record['periodoTransferencia'], "CodMaterial": codMatrial },
                                dataType: "json",
                                success: function (response) {

                                    // Carga articulos Grid1
                                    w2ui[subGridName].clear();
                                    var recidID = 1;
                                    largoDatos = response.records.length + 1;

                                    /* Para cuando la busqueda esta completa pero no tiene detalle */
                                    if (response.records[0].FLD_TMVCODIGO == '' && response.records[0].FLD_PERCODIGO == '') {
                                        w2ui[subGridName].add({ recid: recidID, codMaterial2: w2ui['gridDespXTransferencia'].records[IDTemp].codigoMaterial, cantidad2: '0', loteSerie2: '', fechaVencimiento2: actualDate });
                                    } else {
                                        // Transcribe los nuevos Records o articulos actualmente disponibles.
                                        for (var i = 0; i < response.records.length; i++) {

                                            var cantidad0 = parseInt(response.records[i].cantidad2);

                                            if (cantidad0 == 0) {

                                            } else {
                                                w2ui[subGridName].add({ recid: recidID, codMaterial2: w2ui['gridDespXTransferencia'].records[IDTemp].codigoMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2 });
                                            }
                                            recidID = recidID + 1;
                                        } // fin for
                                    } // Controla que exista la busqueda.

                                } // Fin success
                            }); // fin ajax	

                        } // fin datos en temp o real.

                        /* end if 2014. */
                    } else {
                        /* Error debido a que nuevos dato no contienen detalle de movimiento */
                        w2ui.gridDespXTransferencia.collapse(w2ui['gridDespXTransferencia'].records[IDTemp].recid);
                        w2alert(' Operaciones antiguas no contienen detalle de material.');
                    } // end IF.
                }, 300); // fin set time out.

            }
        });
    </script>

        <!-- Metodo para validacion de bodega de usuario -->
    <script type="text/javascript">

        function TransferenciaBodega_Fast() {

            var solicitudEntrante = w2ui['formDespXTransferencia'].record['numeroPedido'];

            w2ui.formDespXTransferencia.url = '../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx?tipoBusqueda=busquedaDatosTransferencia' + '&periodo=' + w2ui['formDespXTransferencia'].record['periodoDespacho'] + '&numeroPedido=' + w2ui['formDespXTransferencia'].record['numeroPedido'];
            w2ui.formDespXTransferencia.reload();

            setTimeout(function () {

                if (w2ui['formDespXTransferencia'].record['numeroPedido'] == '0' && w2ui['formDespXTransferencia'].record['bodegaSolicita'] == '') {

                    var todayDate = new Date();
                    var year = todayDate.getFullYear();
                    /* Izquierda */
                    w2ui['formDespXTransferencia'].record['numeroPedido'] = '';
                    w2ui['formDespXTransferencia'].record['estadoPedido'] = '';
                    w2ui['formDespXTransferencia'].record['tipoPedido'] = '';
                    w2ui['formDespXTransferencia'].record['observacionPedido'] = '';
                    /* Derecha*/
                    w2ui['formDespXTransferencia'].record['bodegaSolicita'] = '';
                    w2ui['formDespXTransferencia'].record['nombreBodegaSolicita'] = '';
                    w2ui['formDespXTransferencia'].record['bodegaDespacha'] = '';
                    w2ui['formDespXTransferencia'].record['nombreBodegaDespacha'] = '';
                    w2ui['formDespXTransferencia'].record['nroTransferencia'] = '0';

                    /* Datos relevantes */
                    w2ui['formDespXTransferencia'].record['periodoDespacho'] = year;
                    w2ui['formDespXTransferencia'].record['periodoTransferencia'] = year;
                    w2ui['formDespXTransferencia'].refresh();

                    w2alert('No existe el pedido Nº ' + solicitudEntrante);
                    $('#numeroPedido').focus();
                } else {
                    setTimeout(function () {
                        codigoBodegaDesp = w2ui['formDespXTransferencia'].record['bodegaDespacha'];
                        codigoBodegaSol = w2ui['formDespXTransferencia'].record['bodegaSolicita'];
                        w2ui.gridDespXTransferencia.url = '../../clases/persistencia/controladores/Despachos/PorTransferencia/DataDespachoTransferencia.ashx?tipoBusqueda=buscaMatsTransferencia' + '&numeroPedido=' + w2ui['formDespXTransferencia'].record['numeroPedido'] + '&periodoPedido=' + w2ui['formDespXTransferencia'].record['periodoDespacho'] + '&codBodDesp=' + codigoBodegaDesp + '&codBodSoli=' + codigoBodegaSol + '&usuario=' + usuario;
                        w2ui.gridDespXTransferencia.reload();
                    }, 400);
                }

            }, 500);

        } // fin funcion


        // nuevo, para lectura QR
        function justCount(e) {

            countTeclas = countTeclas + 1;
            setTimeout(function () {
                //console.log(countTeclas);
                if (countTeclas == 60) {
                    $('#ValQR').focus();
                    countTeclas = 0;
                }
            }, 100); // no puede ser menos porque no salta a las 60 a ValQR.
            /*
            countTeclas = countTeclas + 1;
                setTimeout(function () {
                    //console.log(countTeclas);
                    if (countTeclas == 80) {
                        $('#ValQR').focus();
                        countTeclas = 0;
                    }
                }, 1200); // no puede ser menos porque no salta a las 80 a ValQR.
             */
         }
    </script>
</asp:Content>
