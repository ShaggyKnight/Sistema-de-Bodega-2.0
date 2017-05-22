<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master"
    CodeBehind="DespachoAUsuarios.aspx.vb" Inherits="Bodega_WebApp.DespachoAUsuarios" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.despaHaciaUsuarios%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="formDespachoAUsuarios" style="height: 320px; top: 2px;">
    </div>
    <div id="gridDespachoAUsuarios" style="height: 300px; top: 4px;">
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
    
        /*
         *Solicitudes:
            Se agrego el buscador inmediato de transferencias en el form principal (metodos nuevos al final).
            Correccion en el pie de pagina del informe.

         *Correcciones:
            Invirtieron los botones de busqueda y aceptar del form.
            Arreglo en el llamado de los datos del grid y carga de encabezado.
            Cambio de fecha en el procedimiento PRO_TB_PEDIDOSBODEGA_SEL_net a 01/01/1900; y tb se modifico la entrega de datos para la busqueda rapida.
            Se agrego boton limpiar.
            Los datos de entrada del modelo principal fueron cambiados de 0 a ''.
            (PRO_BUSCA_DETALLE_MATERIALES_DespOInt_NET2014) se cambio la entrega de fecha desde datime a varchar.
            Detalle reparado ahora guarda bien., incorporacion de busca correlativo y reparacion de proceso en save.
            El lote y/o numero de serie que ingresan del detalle se cambiaron a mayuscula.
            Ahora el grid solo muestra algunas propiedades del grid.
            Al procedimiento TB_MATERIALES_DESPACHO_USU_TEMP se le agrego el FLD_TIMESTAMP
            Ahora carga los materiales que solo existen en la BD para ser despachados. Buscando por el NSERIE
            En la carga de los materiales PRO_TB_DESPACHOS_SELMAT_net ya no se repiten las tuplas de material.
          
         *Pruebas:
            Carga: ok.
            Save: ok.
            Imprime: ok.
            QR: no tiene, si entran los productos ya tienen rotulado.            
        */

        var numeroPedido = '';
        var periodoPedido = '';
        var estadoPedido = '';
        var sel_index = 0;
        var numeroDespacho = 0;
        var periodoDespacho = '';
        var tmvCodigo = '';
        var FechaDespacho = '';
        var despObservacion = 'SIN OBSERVACIÓN';
        var usuario = '';
        var load = 0; /* como el onLoad borrar el form, esto evita que se borra cada vez que se inicia una búsqueda */
        usuario = ' <%=usuario.username %> ';

        /* Datos temp para la nueva operación */
        var numeroPedidoTemp = '';
        var periodoPedidoTemp = '';
        var estadoPedidoTemp = '';
        var numeroDespachoTemp = '';
        var codBodegaTemp = '';
        var tipoPedidoTemp = '';
        var obsTemp = '';

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
                name: 'gridDESPUSU',
                columns: [
			            { field: 'periodoDespacho', caption: 'Periodo', size: '9%' },
			            { field: 'numeroPedido', caption: 'Número', size: '10%' },
			            { field: 'estadoPedido', caption: 'Estado', size: '20%' },
			            { field: 'centroCosto', caption: 'Centro Costo', size: '30%' },
			            { field: 'tipoPedido', caption: 'Tipo', size: '20%' },
			            { field: 'bodegaPedido', caption: 'Solicitado A:', size: '25%' },
			            { field: 'observacionPedido', caption: 'Observación', size: '15%' }
		            ],
                onSelect: function (event) {
                    numeroPedido = this.records[this.last.sel_ind].numeroPedido;
                    periodoPedido = this.records[this.last.sel_ind].periodoDespacho;
                }
            },
            form: {
                header: 'Criterios de Busqueda',
                name: 'formDESPUSU',
                formHTML: '<div class="w2ui-page page-0">' +
		                    '<div class="w2ui-label w2ui-span5">Número Pedido:</div>' +
		                    '<div class="w2ui-field w2ui-span5">' +
			                    '<input name="numeroDESPUSU" type="text" maxlength="10" size="20"/>' +
		                    '</div>' +
		                    '<div class="w2ui-label w2ui-span5">Periodo:</div>' +
		                    '<div class="w2ui-field w2ui-span5">' +
			                    '<select name="periodoDESPUSU" type="select"/>' +
		                    '</div>' +
		                    '<div class="w2ui-label w2ui-span5">Centro Costo:</div>' +
		                    '<div class="w2ui-field w2ui-span5">' +
		                    '	<select name="centroCostoDESPUSU" type="select" style="width:200px;"/>' +
		                    '</div>' +
                            '<div class="w2ui-label w2ui-span5">Estado:</div>' +
		                    '<div class="w2ui-field w2ui-span5">' +
			                    '<select name="estadoDESPUSU" type="select"/>' +
		                    '</div>' +
                            '<div class="w2ui-label w2ui-span5">Tipo:</div>' +
		                    '<div class="w2ui-field w2ui-span5">' +
			                    '<select name="tipoDESPUSU" type="select" style="width:200px;"/>' +
		                    '</div>' +
		                '</div>' +
                        '<div class="w2ui-buttons">' +
                            '<input type="button" value="Buscar" name="Buscar">' +
		                    '<input type="button" value="Limpiar" name="Limpiar">' +
                            '<input type="button" value="Aceptar" name="Aceptar">' +
	                    '</div>',
                fields: [
			            { name: 'numeroDESPUSU', type: 'text' },
			            { name: 'centroCostoDESPUSU', type: 'list',
			                options: { url: '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx?tipoBusqueda=centrosCosto' }
			            },
			            { name: 'periodoDESPUSU', type: 'list',
			                options: { url: '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx?tipoBusqueda=listaPeriodos' }
			            },
                        { name: 'estadoDESPUSU', type: 'list',
                            options: { url: '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx?tipoBusqueda=estadoPedidos' }
                        },
			            { name: 'tipoDESPUSU', type: 'list', options: {
			                items: [{ id: 1, text: 'PLANIFICADO' }, { id: 2, text: 'NO PLANIFICADO' }, { id: 3, text: 'NO PLANIFICADO CON REBAJA DE PRESUPUESTO'}]
			            }
			            }
		            ],
                actions: {
                    Buscar: function () {
                        w2ui.gridDESPUSU.url = '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx?tipoBusqueda=busqedaListaPedidos' + '&numeroPedido=' + this.record.numeroDESPUSU + '&periodoPedido=' + this.record.periodoDESPUSU + '&centroCostoPedido=' + this.record.centroCostoDESPUSU + '&estadoPedido=' + this.record.estadoDESPUSU + '&tipoPedido=' + this.record.tipoDESPUSU;
                        w2ui.gridDESPUSU.reload();
                    },
                    Aceptar: function () {

                        w2popup.close();
                        
                        /* carga desde popup */
                        w2ui.formDespachoAUsuarios.url = '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx?tipoBusqueda=DatosPedido' + '&periodo=' + periodoPedido + '&numeroPedido=' + numeroPedido;
                        w2ui.formDespachoAUsuarios.reload();
                        setTimeout(function () {
                            var codigoBodega = $('#bodegaPedido').val();
                            var numeroDespacho = $('#numeroDespacho').val();
                            w2ui.gridDespachoAUsuarios.url = '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx?tipoBusqueda=MaterialesPedido' + '&periodo=' + periodoPedido + '&numeroPedido=' + numeroPedido + '&codigoBodega=' + codigoBodega + '&numeroDespacho=' + numeroDespacho;
                            w2ui.gridDespachoAUsuarios.reload();
                        }, 400);

                    },
                    Limpiar: function () {
                        this.clear();
                        w2ui.gridDESPUSU.clear();
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
                title: 'BUSQUEDA POR BODEGA',
                width: 1100,
                height: 600,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                modal: true,
                onOpen: function (event) {
                    event.onComplete = function () {
                        $('#w2ui-popup #main').w2render('layout');
                        w2ui.layout.content('left', w2ui.gridDESPUSU);
                        w2ui.layout.content('main', w2ui.formDESPUSU);
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
        $('#formDespachoAUsuarios').w2form({
            name: 'formDespachoAUsuarios',
            header: 'Despacho a Usuarios',
            recid: 10,
            url: '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx?tipoBusqueda=periodoForm',
            formHTML: '<div class="w2ui-page page-0">' +
		                '<div style="width: 340px; float: left; ">' +
			                '<div class="w2ui-group" style="height: 185px;">' +
				                '<div class="w2ui-label w2ui-span4">Número:</div>' +
				                '<div class="w2ui-field w2ui-span4">' +
					                '<input name="numeroPedido" type="text" maxlength="6" id="numeroPedido"/>' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span4">Período:</div>' +
				                '<div class="w2ui-field w2ui-span4">' +
					                '<input name="periodoDespacho" type="text" maxlength="100" disabled/>' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span4">Estado:</div>' +
				                '<div class="w2ui-field w2ui-span4">' +
					                '<input name="estadoPedido" type="text" disabled="disabled"/>' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span4">Despacho:</div>' +
				                '<div class="w2ui-field w2ui-span4">' +
					                '<input name="numeroDespacho" type="text" disabled="disabled"/>' +
				                '</div>' +

		                        '<div class="w2ui-label w2ui-span3" style="width: 104px; margin-left: 20px; margin-top: 12px;">Nueva Recepción:</div>' +
		                        '<div class="w2ui-field w2ui-span4" >' +
		                            '<input name="newIngreso" id="newIngreso" class="form-control" type=checkbox style="margin-left: 48px; margin-top: 9px;"/>' +
		                        '</div>' +

				                '<div class="w2ui-field w2ui-span4">' +
					                '<input name="fechaDespacho" type="text" style="display: none;" disabled="disabled"/>' +
				                '</div>' +
			                '</div>' +
		                '</div>' +
		                '<div style="margin-left: 350px;">' +
			                '<div class="w2ui-group" style="height: 192px;">' +
				                '<div class="w2ui-label w2ui-span5">Bodega:</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
					                '<input name="bodegaPedido" type="text" maxlength="50" style="width: 60px; margin-right: 2px;" disabled="disabled"/>' +
                                    '-' +
					                '<input name="nombreBodegaPedido" type="text" style="width: 160px; margin-left: 2px;" disabled="disabled"/>' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span5">C. Costo:</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
					                '<input name="centroCosto" type="text" style="width: 230px;" disabled="disabled"/>' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span5">Tipo:</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
					                '<input name="tipoPedido" type="text" style="width: 230px;" disabled="disabled"/>' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span5">Observación:</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
					                '<textarea name="observacionPedido" type="text" style="width: 70%; height: 60px; resize: none"></textarea>' +
				                '</div>' +

                            // nuevo, para lectura QR
		                    '<div class="w2ui-field" style="display:; margin-top: -10%;position: relative;z-index: -1;">' +
                                '<textarea name="ValQR" type="text" maxlength="80" id="ValQR"visibility:hidden ></textarea>' +
                            '</div>' +

			                '</div>' +
		                '</div>' +
	                '</div>' +

	                '<div class="w2ui-buttons">' +
            //'<input type="button" value="Buscar Pedido" name="buscarPedido" style="width: 10%;">' +   // busqueda inmediata boton.
		                '<input type="button" value="Pedidos x Bodega" name="buscarPedidosBod" style="width: 10%;">' +
		                '<input type="button" value="Guardar" name="guardarDespacho" style="width: 10%; border-color: cornflowerblue;">' +
		                '<input type="button" value="Imprimir Despacho" name="imprimirDespacho" style="width: 11%;">' +
                        '<input type="button" value="Limpiar" name="limpiarPedido" style="width: 10%;">' +
            //'<input type="button" value="Imprimir Traspaso" name="imprimirTraspaso" style="width: 11%;">' +
	                '</div>',
            fields: [
			    { name: 'numeroPedido', type: 'int', required: true },
			    { name: 'periodoDespacho', type: 'int', required: true },
			    { name: 'estadoPedido', type: 'text' },
                { name: 'newIngreso', type: 'checkbox' },                    // para limpiar e ingresar una nueva operación.
			    {name: 'bodegaPedido', type: 'text' },
			    { name: 'nombreBodegaPedido', type: 'text' },
			    { name: 'centroCosto', type: 'text' },
			    { name: 'tipoPedido', type: 'text' },
			    { name: 'observacionPedido', type: 'text' },
                { name: 'numeroDespacho', type: 'int' },
                { name: 'fechaDespacho', type: 'text' },
                { name: 'ValQR', type: 'text'} // nuevo, para lectura QR
		    ],
            onLoad: function (event) {

                if (load == 0) {

                    setTimeout(function () {
                        var todayDate = new Date();
                        var year = todayDate.getFullYear();
                        /* Izquierda */
                        w2ui['formDespachoAUsuarios'].record['numeroPedido'] = '';
                        w2ui['formDespachoAUsuarios'].record['periodoDespacho'] = year;
                        w2ui['formDespachoAUsuarios'].record['estadoPedido'] = '';
                        w2ui['formDespachoAUsuarios'].record['numeroDespacho'] = '0';
                        /* Derecha*/
                        w2ui['formDespachoAUsuarios'].record['bodegaPedido'] = '';
                        w2ui['formDespachoAUsuarios'].record['nombreBodegaPedido'] = '';
                        w2ui['formDespachoAUsuarios'].record['centroCosto'] = '';
                        w2ui['formDespachoAUsuarios'].record['tipoPedido'] = '';
                        w2ui['formDespachoAUsuarios'].record['tobservacionPedido'] = '';

                        // nuevo, para lectura QR
                        w2ui['formDespachoAUsuarios'].record['ValQR'] = '';

                        w2ui['formDespachoAUsuarios'].refresh();

                        $('#numeroPedido').focus();

                    }, 350);
                } // fin load.

            },
            onChange: function (event) {

                /* Agregar cambio buscador instantaneo. */
                load = 1;
                if (event.target == "numeroPedido") {
                    setTimeout(function () {
                        DespachoUsuario_Fast();
                    }, 600);
                }

                /* Controla si s ingresa o no una nueva recepción */
                if (event.target == "newIngreso") {

                    if (w2ui['formDespachoAUsuarios'].record['numeroDespacho'] > 0) {

                        if (this.fields[3].el.checked) {

                            //numeroPedidoTemp = this.fields[0].el.value;
                            //periodoPedidoTemp = this.fields[1].el.value;
                            //estadoPedidoTemp = this.fields[2].el.value;
                            numeroDespachoTemp = this.fields[9].el.value;
                            //codBodegaTemp = this.fields[4].el.value;
                            //tipoPedidoTemp = this.fields[7].el.value;
                            obsTemp = this.fields[8].el.value;

                            /* limpia datos para el nuevo ingreso */
                            //this.fields[0].el.value = '';
                            this.fields[9].el.value = 0;
                            this.fields[8].el.value = '';

                        } else {

                            this.fields[9].el.value = numeroDespachoTemp;
                            this.fields[8].el.value = obsTemp;

                        }
                    }
                } // fin cambio nuevo ingreso

            },
            actions: {
                buscarPedido: function () {
                    var periodo = $('#periodoDespacho').val();
                    var numeroDesp = $('#numeroPedido').val();
                    if (periodo != '' && periodo != 'undefined' && numeroDesp != '' && numeroDesp != 'undefined' && periodo != '0' && numeroDesp != '0') {
                        this.url = '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx?tipoBusqueda=DatosPedido' + '&periodo=' + periodo + '&numeroPedido=' + numeroDesp;
                        this.reload();
                        setTimeout(function () {
                            this.record = {
                                numeroPedido: $('#numeroPedido').val(),
                                periodoDespacho: $('#periodoDespacho').val(),
                                estadoPedido: $('#estadoPedido').val(),
                                bodegaPedido: $('#bodegaPedido').val(),
                                nombreBodegaPedido: $('#nombreBodegaPedido').val(),
                                centroCosto: $('#centroCosto').val(),
                                tipoPedido: $('#tipoPedido').val(),
                                observacionDespacho: $('#observacionPedido').val(),
                                numeroDespacho: $('#numeroDespacho').val(),
                                fechaDespacho: $('#fechaDespacho').val()
                            }
                            this.refresh();

                        }, 200);
                        setTimeout(function () {
                            var codigoBodega = $('#bodegaPedido').val();
                            var numeroDespacho = $('#numeroDespacho').val();
                            FechaDespacho = $('#fechaDespacho').val();
                            w2ui.gridDespachoAUsuarios.url = '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx?tipoBusqueda=MaterialesPedido' + '&periodo=' + periodo + '&numeroPedido=' + numeroDesp + '&codigoBodega=' + codigoBodega + '&numeroDespacho=' + numeroDespacho;
                            w2ui.gridDespachoAUsuarios.reload();

                        }, 350);

                    } else {
                        w2alert('Debe ingresar un número de pedido y un periodo válidos para realizar esta búsqueda.');
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
                    w2ui['formDespachoAUsuarios'].record['numeroPedido'] = '';
                    w2ui['formDespachoAUsuarios'].record['periodoDespacho'] = year;
                    w2ui['formDespachoAUsuarios'].record['estadoPedido'] = '';
                    w2ui['formDespachoAUsuarios'].record['numeroDespacho'] = '0';
                    /* Derecha*/
                    w2ui['formDespachoAUsuarios'].record['bodegaPedido'] = '';
                    w2ui['formDespachoAUsuarios'].record['nombreBodegaPedido'] = '';
                    w2ui['formDespachoAUsuarios'].record['centroCosto'] = '';
                    w2ui['formDespachoAUsuarios'].record['tipoPedido'] = '';
                    w2ui['formDespachoAUsuarios'].record['observacionPedido'] = '';
                    w2ui['formDespachoAUsuarios'].refresh();

                    w2ui.gridDespachoAUsuarios.clear();
                    $('#numeroPedido').focus();
                    /*
                    var todayDate = new Date();
                    var year = todayDate.getFullYear();

                    this.clear();
                    w2ui.gridDespachoAUsuarios.clear();
                    this.record = {
                    numeroPedido: 0,
                    periodoDespacho: year,
                    numeroDespacho: 0,
                    bodegaPedido: ''
                    }

                    this.refresh();
                    load = 1;
                    */
                },
                /* saveForm, saveGrid, saveTotal */
                guardarDespacho: function () {
                    var periodo = $('#periodoDespacho').val();
                    var numeroPedido = $('#numeroPedido').val();
                    var codigoBodega = $('#bodegaPedido').val();
                    var numeroDespacho = $('#numeroDespacho').val();
                    var observacion = $('#observacionPedido').val();
                    $.ajax({
                        url: '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx',
                        type: 'POST',
                        dataType: "json",
                        data: { tipoBusqueda: 'generarDespacho', gridData: w2ui.gridDespachoAUsuarios.records, formData: this.Record, periodo: periodo, decripcion: observacion.toUpperCase(), numeroDespacho: numeroDespacho, numeroPedido: numeroPedido, codigoBodega: codigoBodega, usuario: usuario, lengthMateriales: w2ui.gridDespachoAUsuarios.records.length },
                        success: function (response) {
                            if (response.status == 'error') {
                                w2alert(response.message);
                            } else {
                                w2alert('¡Se creo el despacho Nº ' + response.cmvNumero + ' con éxito!');
                                tmvCodigo = response.tmvCodigo;
                                numeroDespacho = response.cmvNumero;
                                periodoDespacho = response.periodo;
                                estadoPedido = response.estadoPedido;
                                FechaDespacho = response.fechaDespacho;
                                despObservacion = $('#observacionDespacho').val();

                                w2ui.formDevDespachoNMat.record = {
                                    numeroPedido: numeroPedido,
                                    periodoDespacho: periodo,
                                    estadoPedido: estadoPedido,
                                    bodegaPedido: $('#bodegaPedido').val(),
                                    nombreBodegaPedido: $('#nombreBodegaPedido').val(),
                                    centroCosto: $('#centroCosto').val(),
                                    tipoPedido: $('#tipoPedido').val(),
                                    observacionDespacho: $('#observacionPedido').val(),
                                    numeroDespacho: numeroDespacho
                                }
                                w2ui.formDevDespachoNMat.refresh();
                            }
                        },
                        error: function (response) {
                            alert("Ha ocurrido un error en la operación vuelva a intentarlo más tarde.");
                        }
                    });
                    //w2ui.gridDespachoAUsuarios.request('save-records', { 'formData': this.record, 'gridData': w2ui.gridDespachoAUsuarios.records }, '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx?tipoBusqueda=generarDespacho' + '&usuario=' + usuario + '&decripcion='+ observacion + '&periodo=' + periodo + '&numeroPedido=' + numeroPedido + '&codigoBodega=' + codigoBodega + '&numeroDespacho=' + numeroDespacho + '&lengthMateriales=' + w2ui.gridDespachoAUsuarios.records.length);
                },
                imprimirDespacho: function () {
                    var NTransaccion;
                    var fechaTransaccion;
                    var bodega;
                    var centroCosto;
                    var periodo;

                    if (w2ui['formDespachoAUsuarios'].record['observacionPedido']) {
                        descripcion = $("#observacionPedido").val();
                    } else {
                        var descripcion = despObservacion;
                    }

                    var numeroLinea;
                    var codMaterial;
                    var nombreMaterial;
                    var cantMaterial;
                    var valorUnitario;
                    var tipoPedido;

                    // Identifica ID de busqueda.
                    if ($('#numeroDespacho').val()) {
                        NTransaccion = $('#numeroDespacho').val();

                        if (w2ui['formDespachoAUsuarios'].record['fechaDespacho'] != '') {
                            fechaTransaccion = $('#fechaDespacho').val();

                            if (this.record['bodegaPedido']) {
                                bodega = this.record['bodegaPedido'] + '-' + this.record['nombreBodegaPedido'];

                                if (this.record['centroCosto']) {
                                    centroCosto = this.record['centroCosto'];

                                    if ($('#periodoDespacho').val()) {
                                        periodo = $('#periodoDespacho').val();

                                        estadoPedido = $('#estadoPedido').val();
                                        numeroPedido = $('#numeroPedido').val();
                                        tipoPedido = this.record['tipoPedido'];
                                        tmvCodigo = '8';

                                        /* Graba materiales en la tabla TEMP */
                                        var cont = 1;
                                        var CodigoMaterial;
                                        var NombreMaterial;
                                        var CantidadMovimiento;
                                        var PrecioUnitario;
                                        var done = 0;
                                        var ReportUsuario = '';

                                        for (var i = 0; i <= w2ui.gridDespachoAUsuarios.records.length - 1; i++) {

                                            CodigoMaterial = w2ui.gridDespachoAUsuarios.records[i].recid;
                                            NombreMaterial = w2ui.gridDespachoAUsuarios.records[i].nombreMaterial;
                                            CantidadMovimiento = w2ui.gridDespachoAUsuarios.records[i].cantidadEntregado + w2ui.gridDespachoAUsuarios.records[i].cantidadADespachar;
                                            PrecioUnitario = w2ui.gridDespachoAUsuarios.records[i].precioUnitario;

                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                                                async: false,
                                                data: { "cmd": 'RPTInforme', "NTransaccion": NTransaccion, "periodo": periodo, "codTransaccion": tmvCodigo, "Linea": cont, "codMaterial": CodigoMaterial, "nombreMaterial": NombreMaterial, "CodItem": '', "cantMaterial": CantidadMovimiento, "precioMaterial": PrecioUnitario, "bodega": bodega, "descripcion": descripcion.toUpperCase(), "fechaMovimieno": fechaTransaccion, "proveedor": tipoPedido, "ordenCompra": numeroPedido, "ordenCompraEstado": estadoPedido, "numeroDocumento": '0', "Institucion": '', "centroCosto": centroCosto, "tipoDocumento": '', "tituloMenu": 'DESPACHO A USUARIOS', "descuento": '0', "impuesto": '0', "diferenciaPeso": '0', "usuario": usuario },
                                                dataType: "json",
                                                success: function (response) {
                                                    if (response.status == 'error') {
                                                        done = 1;
                                                        w2alert(response.message);
                                                    } else {
                                                        done = 0;
                                                    }
                                                },
                                                error: function (response) {
                                                    alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                                }
                                            });

                                            cont = cont + 1;

                                        } // Fin for.

                                        if (done == 0) {
                                            window.open('../../reportes/Despachos/DespachoUsuarios/Rpt_DesapchoAUsuarios.aspx?CMVCodigo=' + NTransaccion + '&PERCodigo=' + periodo + '&TMVCodigo=' + tmvCodigo + '&usuario=' + usuario + '&nombreReport' + 'Rpt_DespachoAUsuarios_' + NTransaccion + '_' + periodo);
                                        } else {
                                            alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                        }

                                    } else { alert("Faltan datos para imprimir.(Periodo)"); } // Fin nombre periodo Despacho.
                                } else { alert("Faltan datos para imprimir.(CentroCosto)"); } // Fin centro costo.
                            } else { alert("Faltan datos para imprimir.(Bodega)"); } // Fin nombre Bodega.
                        } else { alert("Faltan datos para imprimir.(FechaDespacho)"); } // Fin fechaTransaccion.
                    } else { // alerta de mensaje por no ingresar nada.
                        alert("Primero ingrese o búsque un despacho");
                    }
                },
                imprimirTraspaso: function () {
                    alert('Imprimir 2');
                }
            }
        });
    </script>
    <!-- Comentario -->
    <script type="text/javascript">
        $('#gridDespachoAUsuarios').w2grid({
            name: 'gridDespachoAUsuarios',
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
			    { field: 'recid', caption: 'Codigo', size: '8%', attr: 'align=center' },
			    { field: 'nombreMaterial', caption: 'Nombre Material', size: '35%', attr: 'align=center' },
                { field: 'codItem', caption: 'Cod. Item', size: '10%', attr: 'align=center' },
                { field: 'itemPresupuestario', caption: 'Item Presupuestario', size: '22%', attr: 'align=center' },
			    { field: 'cantidadPedida', caption: 'Pedido', size: '6%', attr: 'align=center' },
			    { field: 'cantidadEntregado', caption: 'Entregado', size: '8,5%', attr: 'align=center' },
			    { field: 'cantidadPendiente', caption: 'Pendiente', size: '8%', attr: 'align=center' },
			    { field: 'cantidadExistencia', caption: 'Existencia', size: '8%', attr: 'align=center' },
			    { field: 'precioUnitario', caption: '$ Unitario', size: '9%', attr: 'align=center' },
			    { field: 'cantidadADespachar', caption: 'A Despachar', size: '10%', attr: 'align=center' },
			    { field: 'total', caption: 'Total', size: '8%', attr: 'align=center' },
			    { field: 'pauta', caption: 'Pauta', size: '8%', attr: 'align=center' }
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
                    if (subGridName != '') {
                        lectorQR = 'on';
                        w2ui[subGridName].editField(w2ui[subGridName].records.length, 2, '');
                    } else {
                        lectorQR = 'off';
                        w2alert('Seleccione el detalle del elemento a transferir!.');
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
                    $('#tb_' + 'gridDespachoAUsuarios_toolbar' + '_item_' + 'QR' + ' table.w2ui-button').removeClass('checked');
                    $('#tb_' + 'gridDespachoAUsuarios_toolbar' + '_item_' + 'QR' + ' table.w2ui-button').prop("checked", false);
                }, 10);
            },
            onExpand: function (event) {
                var periodo = $('#periodoDespacho').val();
                var numeroPedido = $('#numeroPedido').val();
                var codigoBodega = $('#bodegaPedido').val();
                var numeroDespacho = $('#numeroDespacho').val();
                var matCodigo = $.trim(event.recid);
                var recidMatGrid = 0;
                var date = new Date();
                var actualDate = date.getDate() + '/' + (date.getMonth() + 4) + '/' + date.getFullYear();
                for (j = 0; j < this.records.length; j++) {
                    if (this.records[j].recid == matCodigo) {
                        sel_index = j;
                        break;
                    }
                }
                var cantidadPendiente = w2ui.gridDespachoAUsuarios.records[sel_index].cantidadPendiente;

                var IDTemp;

                // ----------------------------------
                // Encuentra el Recid actualmente utilizado.
                for (var z = 0; z <= w2ui['gridDespachoAUsuarios'].records.length - 1; z++) {

                    var recid = w2ui['gridDespachoAUsuarios'].records[z].recid;

                    if (event.recid == recid) {
                        IDTemp = z;
                    }

                } // fin for 2
                // ----------------------------------

                subGridName = 'subgrid-' + $.trim(event.recid);

                if (w2ui.hasOwnProperty(subGridName)) w2ui[subGridName].destroy();
                $('#' + event.box_id).css({ margin: '0px', padding: '0px', width: '100%' }).animate({ height: '170px' }, 100);
                setTimeout(function () {
                    $('#' + event.box_id).w2grid({
                        name: subGridName,
                        show: { toolbar: true,
                            footer: false,
                            toolbarAdd: true,
                            toolbarDelete: true,
                            toolbarSave: true,
                            toolbarEdit: false,
                            toolbarSearch: false,
                            columnHeaders: true,
                            toolbarReload: false,
                            toolbarColumns: false
                        },
                        fixedBody: false,
                        multiSelect: false,
                        columns: [
                            { field: 'codigoMaterial', caption: 'Codigo Material', size: '10%', attr: 'align=center' },
						    { field: 'cantidad', caption: 'Cantidad', size: '10%', editable: { type: 'int' }, attr: 'align=center' },
						    { field: 'lote', caption: 'Lote/Serie', size: '20%', editable: { type: 'text', inTag: 'maxlength = 80' }, attr: "align=center, onkeypress='return justCount(event);'" },  // nuevo, para lectura QR
						    { field: 'fechaVencimiento', caption: 'Fecha Vencimiento', size: '20%', editable: { type: 'date', format: 'dd-mm-yy' }, attr: 'align=center' }
					    ],
                        records: [
						    { recid: 1, codigoMaterial: matCodigo, cantidad: '0', lote: '', fechaVencimiento: actualDate }
					    ],
                        onAdd: function (event) {
                            var g = w2ui[subGridName].records.length;
                            w2ui[subGridName].add({ recid: g + 1, codigoMaterial: matCodigo, cantidad: '0', lote: '', fechaVencimiento: actualDate });
                        },
                        onDelete: function (event) {
                            for (i = 0; w2ui[subGridName].records.length > i; i++) {
                                if (w2ui[subGridName].records[i].selected && w2ui[subGridName].records[i].selected == true) {
                                    w2ui[subGridName].remove(w2ui[subGridName].records[i].recid);
                                    w2ui[subGridName].total = w2ui[subGridName].total - 1;
                                    w2ui[subGridName].buffered = w2ui[subGridName].buffered - 1;
                                    break;
                                }
                            }
                        },

                        onChange: function (event) {

                            var local_CodMaterial;
                            var local_Cantidad;
                            var local_Serielote;
                            var local_fechaVto;

                            /* Serie o lote. */  // nuevo, para lectura QR
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
                                } else {
                                    console.log('No QR');
                                    Nserie = event.value_new.toUpperCase();
                                }

                                var CantDevolver = parseInt(w2ui['gridDespachoAUsuarios'].records[IDTemp].cantidadPendiente);

                                $.ajax({
                                    type: "POST",
                                    url: "../../clases/persistencia/controladores/validaDetalleMaterial.ashx",
                                    async: false,
                                    data: { "cmd": 'validaTraeFVto', "codMaterial": w2ui['gridDespachoAUsuarios'].records[IDTemp].recid, "Bodega": w2ui['formDespachoAUsuarios'].record['bodegaPedido'], "Nserie": Nserie }, //event.value_new.toUpperCase()
                                    dataType: "json",
                                    success: function (response) {

                                        if (response.validate == "1") {

                                            alert('¡Error, No existe registro de material para este Nº Serie.!')
                                            local_Serielote = '';
                                            local_fechaVto = '';

                                        } else {

                                            local_Cantidad = parseInt(response.FLD_MOVCANTIDAD);

                                            var sumaCantidad = 0;
                                            for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                                if (w2ui[subGridName].records[i].cantidad) {
                                                    sumaCantidad = sumaCantidad + parseInt(w2ui[subGridName].records[i].cantidad);
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

                                this.set(event.recid, { cantidad: local_Cantidad });
                                this.set(event.recid, { lote: local_Serielote });
                                this.set(event.recid, { fechaVencimiento: local_fechaVto });

                                // nuevo, para lectura QR
                                if (lectorQR == 'on' && local_Cantidad != undefined) {
                                    var todayDate = new Date();
                                    var day = todayDate.getDate();
                                    var month = todayDate.getMonth() + 1;
                                    var year = todayDate.getFullYear();
                                    w2ui[subGridName].add({ recid: (this.records[this.total - 1].recid + 1), codMaterial2: w2ui['gridDespachoAUsuarios'].records[IDTemp].codigoMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: (day + '/' + month + '/' + year) });
                                    w2ui[subGridName].total = w2ui[subGridName].total + 1;

                                    setTimeout(function () {
                                        $('#ValQR').val('');
                                        setTimeout(function () {
                                            w2ui[subGridName].editField(w2ui[subGridName].records.length, 2, '');
                                        }, 120); // 100 max qr
                                    }, 200); // 900 max qr
                                }


                            } // fin columna 2.

                        } // fin Onchange
                        ,
                        /* saveExpand, saveDetalle */
                        onSave: function (event) {

                            var sumaCantidad = 0;
                            var cantidadRecibir = 0;
                            var position = 0;
                            var isCero = 0;

                            if (w2ui['formDespachoAUsuarios'].record['estadoPedido'] == 'DESP.TOTAL' || w2ui['formDespachoAUsuarios'].record['estadoPedido'] == 'ANULADO') {

                                w2alert(' La transferencia ya fue efectuada.');

                            } else {

                                for (i = 0; i < this.records.length; i++) {
                                    if (this.records[i].changed) {
                                        if (this.records[i].changes.cantidad) {
                                            sumaCantidad = sumaCantidad + parseInt(this.records[i].changes.cantidad);
                                            position = i;
                                        } else {
                                            sumaCantidad = sumaCantidad + parseInt(this.records[i].cantidad);
                                            position = i;
                                        }
                                    } else {
                                        sumaCantidad = sumaCantidad + parseInt(this.records[i].cantidad);
                                    }
                                }

                                /* controla que no se ingresen catidades 0 */
                                for (i = 0; i < this.records.length; i++) {
                                    if (this.records[i].changed) {
                                        if (this.records[i].changes.cantidad == 0) {
                                            isCero = 1;
                                        }
                                        if (this.records[i].cantidad == 0) {
                                            if (this.records[i].changes.cantidad > 0) {
                                            } else {
                                                isCero = 1;
                                            }
                                        }
                                    } else {
                                        if (this.records[i].cantidad == 0) {
                                            isCero = 1;
                                        }
                                    }
                                }

                                for (i = 0; i < w2ui['gridDespachoAUsuarios'].records.length; i++) {
                                    var MaterialRecid = w2ui['gridDespachoAUsuarios'].records[i].recid;
                                    if (MaterialRecid == matCodigo) {
                                        cantidadRecibir = parseInt(w2ui['gridDespachoAUsuarios'].records[i].cantidadPendiente);
                                        break;
                                    }
                                }


                                var codMaterial;
                                var cantidadMaterial;
                                var LoteMaterial;
                                var fechaVto;
                                var exitoCorrelativo = 0;
                                var exito = 0;

                                if (isCero == 0) {
                                    if (cantidadRecibir >= sumaCantidad) {

                                        var numeroDespacho = parseInt(w2ui['formDespachoAUsuarios'].record['numeroPedido']);

                                        /* Busca correlativo para el save grobal */
                                        if (numeroDespacho = 0 || numeroDespacho > 0) {

                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/Despachos/AUsuarios/getCorrelativo_DespachoHaciaUsuarios.ashx",
                                                async: false,
                                                data: { "fecha": w2ui['formDespachoAUsuarios'].record['periodoDespacho'] },
                                                dataType: "json",
                                                success: function (response) {

                                                    if (response.item == "null") {

                                                        alert('¡Error, Correlativo no encontrado!')

                                                    } else {
                                                        w2ui['formDespachoAUsuarios'].record['observacionPedido'] = '';
                                                        w2ui['formDespachoAUsuarios'].record['numeroDespacho'] = response.Correlativo;
                                                        w2ui['formDespachoAUsuarios'].refresh();

                                                        exitoCorrelativo = 1;

                                                    } // Fin Validador de codigo

                                                } // Fin success
                                            }); // fin ajax

                                        } // fin if existe correlativo                                    

                                        if (exitoCorrelativo = 1) {
                                            for (i = 0; i < this.records.length; i++) {

                                                /* Obtiene el codigo, cantidad material, cantidad, fechaVto. */
                                                codMaterial = this.records[i].codigoMaterial;
                                                if (this.records[i].changes.cantidad) {
                                                    cantidadMaterial = this.records[i].changes.cantidad;
                                                } else {
                                                    cantidadMaterial = this.records[i].cantidad;
                                                }

                                                if (this.records[i].changes.lote) {
                                                    LoteMaterial = this.records[i].changes.lote;
                                                } else {
                                                    LoteMaterial = this.records[i].lote;
                                                }

                                                if (this.records[i].changes.fechaVencimiento) {
                                                    fechaVto = this.records[i].changes.fechaVencimiento;
                                                } else {
                                                    fechaVto = this.records[i].fechaVencimiento;
                                                }

                                                $.ajax({
                                                    type: "POST",
                                                    url: "../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx",
                                                    async: false,
                                                    data: { "tipoBusqueda": 'guardarDetalle', "NumPedido": w2ui['formDespachoAUsuarios'].record['numeroPedido'], "PeriodoPedido": w2ui['formDespachoAUsuarios'].record['periodoDespacho'], "NuevoNumDespacho": w2ui['formDespachoAUsuarios'].record['numeroDespacho'], "CodBodegaPedido": w2ui['formDespachoAUsuarios'].record['bodegaPedido'], "codMaterial": codMaterial, "cantidadMaterial": cantidadMaterial, "LoteMaterial": LoteMaterial, "fechaVto": fechaVto, "numeroLinea": i + 1 },
                                                    dataType: "json",
                                                    success: function (response) {
                                                        exito = 1;
                                                    } // Fin success
                                                }); // fin ajax
                                            }

                                            /* si se realiza la transaccion se cambia de color la ventana*/
                                            if (exito = 1) {

                                                var recid = w2ui['gridDespachoAUsuarios'].records[IDTemp].recid;
                                                var nombreMaterial = w2ui['gridDespachoAUsuarios'].records[IDTemp].nombreMaterial;
                                                var codigoItem = w2ui['gridDespachoAUsuarios'].records[IDTemp].codItem;
                                                var itemPresupuestario = w2ui['gridDespachoAUsuarios'].records[IDTemp].itemPresupuestario;
                                                var cantidadPedida = w2ui['gridDespachoAUsuarios'].records[IDTemp].cantidadPedida;
                                                var cantidadEntregado = w2ui['gridDespachoAUsuarios'].records[IDTemp].cantidadEntregado;
                                                var cantidadPendiente = w2ui['gridDespachoAUsuarios'].records[IDTemp].cantidadPendiente;
                                                var cantidadExistencia = w2ui['gridDespachoAUsuarios'].records[IDTemp].cantidadExistencia;
                                                var precioUnitario = w2ui['gridDespachoAUsuarios'].records[IDTemp].precioUnitario;
                                                var cantidadADespachar = parseInt(w2ui['gridDespachoAUsuarios'].records[IDTemp].cantidadEntregado) + sumaCantidad;
                                                var total = sumaCantidad * parseInt(w2ui['gridDespachoAUsuarios'].records[IDTemp].precioUnitario);

                                                w2ui['gridDespachoAUsuarios'].remove(recid);
                                                w2ui['gridDespachoAUsuarios'].add({ recid: recid, nombreMaterial: nombreMaterial, codigoItem: codigoItem, itemPresupuestario: itemPresupuestario, cantidadPedida: cantidadPedida, cantidadEntregado: cantidadEntregado, cantidadPendiente: cantidadPendiente, cantidadExistencia: cantidadExistencia, precioUnitario: precioUnitario, cantidadADespachar: cantidadADespachar, total: total, "style": "background-color: #C2F5B4" });
                                                w2alert('Detalle Ingresado con Exito.');
                                            } else {
                                                w2alert('Error en el ingreso del detalle.');
                                            }

                                        } else {
                                            w2alert('Error de conexión.');
                                        }

                                    } else {
                                        w2alert('La cantidad de materiales ingresados es MAYOR a la cantidad supuesta a recibir, por favor verifique esta información y vuelva a intentarlo.');
                                        this.reload();
                                    } // fin si es mayor que cantidad solicitada
                                } else {
                                    w2alert('La cantidad no puede ser 0.');
                                    this.reload();
                                } // fin existe un 0 en cantidad
                            }
                        }
                    });


                    // -----------------------------
                    // Maneja los datos del Sub Grid
                    // -----------------------------

                    w2ui['subgrid-' + event.recid].resize();
                    w2ui.gridDespachoAUsuarios.resize();

                    /* Datos em TEMP o Real */
                    if (w2ui['formDespachoAUsuarios'].record['numeroPedido'] && $('#numeroDespacho').val() > 0) {

                        $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx",
                            async: false,
                            data: { "tipoBusqueda": 'BuscaOrigenDeDatos', "NumDespacho": w2ui['formDespachoAUsuarios'].record['numeroDespacho'], "periodoPedido": w2ui['formDespachoAUsuarios'].record['periodoDespacho'], "CodMaterial": w2ui['gridDespachoAUsuarios'].records[IDTemp].recid },
                            dataType: "json",
                            success: function (response) {

                                // Carga articulos Grid1
                                w2ui[subGridName].clear();
                                var recidID = 1;
                                largoDatos = response.records.length + 1;

                                /* Para cuando la busqueda esta completa pero no tiene detalle por lo antiguo */
                                if (response.records[0].FLD_TMVCODIGO == '' && response.records[0].FLD_PERCODIGO == '') {
                                    w2ui.gridDespXTransferencia.collapse(w2ui['gridDespachoAUsuarios'].records[IDTemp].recid);
                                    w2alert('Dada la antiguedad del ingreso este no posee detalle.');
                                } else {
                                    // Transcribe los nuevos Records o articulos actualmente disponibles.
                                    for (var i = 0; i < response.records.length; i++) {

                                        var cantidad0 = parseInt(response.records[i].cantidad2);

                                        if (cantidad0 == 0) {

                                        } else {

                                            //alert(w2ui['gridDespachoAUsuarios'].records[IDTemp].recid + ' ' + response.records[i].cantidad2 + ' ' + response.records[i].loteSerie2 + ' ' + response.records[i].fechaVencimiento2);

                                            w2ui[subGridName].add({ recid: recidID, codigoMaterial: w2ui['gridDespachoAUsuarios'].records[IDTemp].recid, cantidad: response.records[i].cantidad2, lote: response.records[i].loteSerie2, fechaVencimiento: response.records[i].fechaVencimiento2 });
                                        }
                                        recidID = recidID + 1;
                                    } // fin for
                                } // Controla que exista la busqueda.

                            } // Fin success
                        }); // fin ajax	

                    } // fin datos en temp o real.

                }, 300);
            } // fin onExpand
        });
    </script>

        <!-- Metodo para validacion de bodega de usuario -->
    <script type="text/javascript">

        function DespachoUsuario_Fast() {

            var solicitudEntrante = w2ui['formDespachoAUsuarios'].record['numeroPedido'];

            w2ui.formDespachoAUsuarios.url = '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx?tipoBusqueda=DatosPedido' + '&periodo=' + w2ui['formDespachoAUsuarios'].record['periodoDespacho'] + '&numeroPedido=' + w2ui['formDespachoAUsuarios'].record['numeroPedido'];
            w2ui.formDespachoAUsuarios.reload();

            setTimeout(function () {

                if (w2ui['formDespachoAUsuarios'].record['numeroDespacho'] == '0' && w2ui['formDespachoAUsuarios'].record['bodegaPedido'] == '') {

                    var todayDate = new Date();
                    var year = todayDate.getFullYear();
                    /* Izquierda */
                    w2ui['formDespachoAUsuarios'].record['numeroPedido'] = '';
                    w2ui['formDespachoAUsuarios'].record['periodoDespacho'] = year;
                    w2ui['formDespachoAUsuarios'].record['estadoPedido'] = '';
                    w2ui['formDespachoAUsuarios'].record['numeroDespacho'] = '0';
                    /* Derecha*/
                    w2ui['formDespachoAUsuarios'].record['bodegaPedido'] = '';
                    w2ui['formDespachoAUsuarios'].record['nombreBodegaPedido'] = '';
                    w2ui['formDespachoAUsuarios'].record['centroCosto'] = '';
                    w2ui['formDespachoAUsuarios'].record['tipoPedido'] = '';
                    w2ui['formDespachoAUsuarios'].record['tobservacionPedido'] = '';
                    w2ui['formDespachoAUsuarios'].refresh();

                    w2alert('No existe el pedido Nº ' + solicitudEntrante);
                    w2ui.gridDespachoAUsuarios.clear();
                    $('#numeroPedido').focus();
 
                } else {

                    setTimeout(function () {
                        codigoBodegaPedido = w2ui['formDespachoAUsuarios'].record['bodegaPedido'];
                        w2ui.gridDespachoAUsuarios.url = '../../clases/persistencia/controladores/Despachos/AUsuarios/DataDespachoUsuarios.ashx?tipoBusqueda=MaterialesPedido' + '&periodo=' + w2ui['formDespachoAUsuarios'].record['periodoDespacho'] + '&numeroPedido=' + w2ui['formDespachoAUsuarios'].record['numeroPedido'] + '&codigoBodega=' + codigoBodegaPedido + '&numeroDespacho=' + w2ui['formDespachoAUsuarios'].record['numeroDespacho'];
                        w2ui.gridDespachoAUsuarios.reload();
                    }, 350);
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
        }

    </script>
</asp:Content>
