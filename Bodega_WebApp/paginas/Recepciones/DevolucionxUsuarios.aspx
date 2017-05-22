<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="DevolucionxUsuarios.aspx.vb" Inherits="Bodega_WebApp.DevolucionxUsuarios" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.recepDevolucionUsuario%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="formDevUsers" style="height: 268px;"></div>
    <div id="gridDevUsers" style="height: 260px; top: 2px;"></div>
</asp:Content>
<asp:Content ID="FooterContent" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
    
</asp:Content>
<asp:Content ID="ScriptContent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <!--variables globales-->
    <script type="text/javascript">

        /*
         *Solicitudes:
            Se agrego nuevo pie de pagina.

         *Correcciones:
             Combo box carga bodega en el form (no funcionaba).
             Nuevo nivel de detalle en TB_DETALLE_EXISTENCIAS.
             Invirtieron los botones de busqueda y aceptar del form.
             El lote y/o numero de serie que ingresan del detalle se cambiaron a mayuscula.
             Ahora el primer llamado trae el CMVNUMERO y se lo pasa al procedimiento save.


         *Pruebas:
             Carga: ok.
             Save: ok.
             Imprime: --.
             QR: ok.
        */

        //Variables generales
        var userName = '';
        var centroCosto = '';
        var recidGridPopUp = 0;
        var largoGridMateriales = 0;
        var tmvNumero = 'D';
        //variables PopUp Materiales
        var codMaterial = '';
        var codItemPres = 0;
        var codBodega = '';
        var nombreMaterial = '';
        var precioMat = 0;
        var unidadMedida = '';
        var selecIndx = 0;
        //Variables PopUp Devoluciones
        var ususarioDev = '';
        var cmvNumero = 0;
        var periodoDev = '';
        var codBodegaDev = '';
        var centroCostoDev = '';
        var obervacion = '';
        var fechaDevolucion = '';

        userName = '<%=usuario.username %>';
        centroCosto = '<%=usuario.centroDeCosto %>';
    </script>
    <!-- w2ui Definicion elementos de PopUp de busqueda por BODEGA-->
    <script type="text/javascript">
        var config = {
            layout: {
                name: 'layoutMateriales',
                padding: 4,
                panels: [
			            { type: 'left', size: '65%', minSize: 300 },
			            { type: 'main', minSize: 300 }
		            ]
            },
            grid: {
                name: 'gridDEVXUSUMATS',
                columns: [
			            { field: 'matCodigo', caption: 'Cod. Material', size: '9%' },
			            { field: 'nombreMaterial', caption: 'Nombre Material', size: '20%' },
			            { field: 'precioUnitario', caption: 'Precio Unitario', size: '9%' },
			            { field: 'codItemPresupuestario', caption: 'Cod. Item', size: '8%' },
			            { field: 'nombreItemPres', caption: 'Item Presupuestario', size: '15%' },
			            { field: 'unidadMedida', caption: 'Unidad Medida', size: '10%' }
		            ],
                onSelect: function (event) {
                    codMaterial = this.records[this.last.sel_ind].matCodigo;
                    nombreMaterial = this.records[this.last.sel_ind].nombreMaterial;
                    precioMat = this.records[this.last.sel_ind].precioUnitario;
                    unidadMedida = this.records[this.last.sel_ind].unidadMedida;
                    recidGridPopUp = this.records[this.last.sel_ind].recid;
                    selecIndx = this.last.sel_ind;
                }
            },
            form: {
                header: 'Buasqueda de Materiales',
                name: 'formDEVXUSUMATS',
                formHTML: '<div class="w2ui-page page-0">' +
		                    '<div class="w2ui-label w2ui-span5">Nombre Material:</div>' +
		                    '<div class="w2ui-field w2ui-span5">' +
			                    '<input name="nombreMatDEVXUSUARIOS" type="text" maxlength="10" size="20"/>' +
		                    '</div>' +
		                    '<div class="w2ui-label w2ui-span5">Codigo:</div>' +
		                    '<div class="w2ui-field w2ui-span5">' +
		                    '	<input name="codigoMatDEVXUSUARIOS" type="text" maxlength="10" size="20"/>' +
		                    '</div>' +
		                '</div>' +
                        '<div class="w2ui-buttons">' +
		                    '<input type="button" value="Buscar" name="Buscar">' +
		                    '<input type="button" value="Limpiar" name="Limpiar">' +
		                    '<input type="button" value="Aceptar" name="Aceptar">' +
		                    '<input type="button" value="Cerrar" name="Cerrar">' +
	                    '</div>',
                fields: [
			            { name: 'nombreMatDEVXUSUARIOS', type: 'text' },
			            { name: 'codigoMatDEVXUSUARIOS', type: 'alphanumeric' }
		            ],
                actions: {
                    Buscar: function () {
                        var nombreMaterial = this.record.nombreMatDEVXUSUARIOS;
                        var codigoMaterial = this.record.codigoMatDEVXUSUARIOS;
                        if (nombreMaterial == undefined) {
                            nombreMaterial = '';
                        }
                        if (codigoMaterial == undefined) {
                            codigoMaterial = '';
                        }

                        w2ui.gridDEVXUSUMATS.url = '../../clases/persistencia/controladores/Recepciones/DevolucionXUsuarios/DevolucionUsuariosHandler.ashx?tipoBusqueda=busquedaMatsPopUp' + '&codBodega=' + codBodega + '&nombreMaterial=' + nombreMaterial + '&codigoMaterial=' + codigoMaterial + '&largoGrid=' + largoGridMateriales;
                        w2ui.gridDEVXUSUMATS.reload();
                    },
                    Aceptar: function () {

                        var todayDate = new Date();
                        var day = todayDate.getDate();
                        var month = todayDate.getMonth() + 1;
                        var year = todayDate.getFullYear();

                        if (w2ui.gridDevUsers.total > 0) {
                        /*
                            var newRecid = 0;

                            for (var i = 0; i < w2ui['gridDevUsers'].records.length; i++) {
                                if (w2ui['gridDevUsers'].records[i].recid >= newRecid) {
                                    newRecid = w2ui['gridDevUsers'].records[i].recid;
                                }
                            }
                            newRecid = newRecid + 1;
                            alert('nuevo : ' + newRecid)
                        */
                            w2ui.gridDevUsers.add({ recid: (w2ui.gridDevUsers.records[w2ui.gridDevUsers.total - 1].recid + 1), matCodigo: codMaterial, nombreMaterial: nombreMaterial, cantidad: 0, loteSerie: '0', fechaVencimiento: (day + '/' + month + '/' + year), precioUnitario: precioMat, unidadMedida: unidadMedida });
                            //                            w2ui.gridDevUsers.total = w2ui.gridDevUsers.total + 1;
                        } else {
                            w2ui.gridDevUsers.add({ recid: 1, matCodigo: codMaterial, nombreMaterial: nombreMaterial, cantidad: 0, loteSerie: '0', fechaVencimiento: (day + '/' + month + '/' + year), precioUnitario: precioMat, unidadMedida: unidadMedida });
                            //                            w2ui.gridDevUsers.total = 1;
                        }

                    },
                    Limpiar: function () {
                        this.clear();
                        w2ui.gridDEVXUSUMATS.clear();
                    },
                    Cerrar: function () {
                        w2popup.close();
                    }
                }
            },
            layout1: {
                name: 'layoutDevolucion',
                padding: 4,
                panels: [
			            { type: 'left', size: '65%', minSize: 300 },
			            { type: 'main', minSize: 300 }
		            ]
            },
            grid1: {
                name: 'gridDEVXUSUDEVS',
                columns: [
			            { field: 'cmvNumero', caption: 'Pedido', size: '9%' },
			            { field: 'periodo', caption: 'Periodo', size: '8%' },
			            { field: 'bodCodigo', caption: 'Bodega', size: '9%' },
			            { field: 'usuLogin', caption: 'Usuario', size: '9%' },
			            { field: 'descripcion', caption: 'Descripción', size: '20%' },
			            { field: 'codCentroCosto', caption: 'Centro Costo', size: '10%' },
			            { field: 'fechaDevolucion', hidden: true }
		            ],
                onSelect: function (event) {
                    cmvNumero = this.records[this.last.sel_ind].cmvNumero;
                    periodoDev = this.records[this.last.sel_ind].periodo;
                    ususarioDev = this.records[this.last.sel_ind].usuLogin;
                    codBodegaDev = this.records[this.last.sel_ind].bodCodigo;
                    centroCostoDev = this.records[this.last.sel_ind].codCentroCosto;
                    obervacion = this.records[this.last.sel_ind].descripcion;
                    fechaDevolucion = this.records[this.last.sel_ind].fechaDevolucion;
                    recidGridPopUp = this.last.sel_ind;
                }
            },
            form1: {
                header: 'Búsqueda de Devolución',
                name: 'formDEVXUSUDEVS',
                formHTML: '<div class="w2ui-page page-0">' +
		                    '<div class="w2ui-label w2ui-span5">Periodo:</div>' +
		                    '<div class="w2ui-field w2ui-span5">' +
			                    '<select name="priodosDEVXUSUARIOS" type="text" />' +
		                    '</div>' +
		                    '<div class="w2ui-label w2ui-span5">Devolución:</div>' +
		                    '<div class="w2ui-field w2ui-span5">' +
		                    '	<input name="nroPedidoDEVXUSUARIOS" type="text" maxlength="10" size="20"/>' +
		                    '</div>' +
		                '</div>' +
                        '<div class="w2ui-buttons">' +
		                    '<input type="button" value="Buscar" name="Buscar">' +
		                    '<input type="button" value="Limpiar" name="Limpiar">' +
                            '<input type="button" value="Aceptar" name="Aceptar">' +
	                    '</div>',
                fields: [
			            { name: 'priodosDEVXUSUARIOS', type: 'list',
			                options: { url: '../../clases/persistencia/controladores/Recepciones/DevolucionXUsuarios/DevolucionUsuariosHandler.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqeda=periodos' + '&centroCosto=' + centroCosto }
			            },
			            { name: 'nroPedidoDEVXUSUARIOS', type: 'int' }
		            ],
                actions: {
                    Buscar: function () {
                        var periodoDevolucion = this.record.priodosDEVXUSUARIOS;
                        var nroPedidoDevolucion = this.record.nroPedidoDEVXUSUARIOS;
                        if (periodoDevolucion == undefined || periodoDevolucion == '') {
                            w2alert('Debe seleccionar un periodo para la busqueda');
                        } else {
                            if (nroPedidoDevolucion == undefined) {
                                nroPedidoDevolucion = '';
                            }

                            w2ui.gridDEVXUSUDEVS.url = '../../clases/persistencia/controladores/Recepciones/DevolucionXUsuarios/DevolucionUsuariosHandler.ashx?tipoBusqueda=busquedaDevolsPopUp' + '&percodigo=' + periodoDevolucion + '&nroPedido=' + nroPedidoDevolucion;
                            w2ui.gridDEVXUSUDEVS.reload();
                        }
                    },
                    Aceptar: function () {

                        w2ui.formDevUsers.record = {
                            nroDevBodega: cmvNumero,
                            listaBodegas: codBodegaDev,
                            listaPeriodos: periodoDev,
                            centrosCosto: centroCostoDev,
                            usuarioDevolucion: ususarioDev,
                            observacionDevolucion: obervacion
                        }

                        w2ui.formDevUsers.refresh();

                        $('#listaBodegas').prop('disabled', true);
                        $('#listaPeriodos').attr('disabled', true);
                        $('#centrosCosto').attr('disabled', true);

                        w2ui.gridDevUsers.url = '../../clases/persistencia/controladores/Recepciones/DevolucionXUsuarios/DevolucionUsuariosHandler.ashx?tipoBusqueda=buscaMaterialesDevolucion' + '&numeroDev=' + cmvNumero + '&periodoDev=' + periodoDev + '&usuario=' + ususarioDev;
                        w2ui.gridDevUsers.reload();

                        this.clear();
                        w2ui.gridDEVXUSUDEVS.clear();
                        setTimeout(function () {
                            w2popup.close();
                        }, 300);

                    },
                    Limpiar: function () {
                        this.clear();
                        w2ui.gridDEVXUSUDEVS.clear();
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
            $().w2layout(config.layout1);
            $().w2grid(config.grid1);
            $().w2form(config.form1);

        });
    </script>
    <!-- instancia de abertura de pop up para busqueda DE MATERIAL -->
    <script type="text/javascript">
        function openPopup() {
            w2popup.open({
                title: 'BUSQUEDA DE MATERIALES',
                width: 1100,
                height: 600,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                modal: true,
                onOpen: function (event) {
                    event.onComplete = function () {
                        $('#w2ui-popup #main').w2render('layoutMateriales');
                        w2ui.layoutMateriales.content('left', w2ui.gridDEVXUSUMATS);
                        w2ui.layoutMateriales.content('main', w2ui.formDEVXUSUMATS);
                    };
                },
                onMax: function (event) {
                    event.onComplete = function () {
                        w2ui.layoutMateriales.resize();
                    }
                },
                onMin: function (event) {
                    event.onComplete = function () {
                        w2ui.layoutMateriales.resize();
                    }
                }
            });
        }
    </script>
    <!-- instancia de abertura de pop up para busqueda DE DEVOLUCIONES -->
    <script type="text/javascript">
        function openPopupDevs() {
            w2popup.open({
                title: 'BUSQUEDA DE DEVOLUCIONES USUSARIO',
                width: 1100,
                height: 600,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                modal: true,
                onOpen: function (event) {
                    event.onComplete = function () {
                        $('#w2ui-popup #main').w2render('layoutDevolucion');
                        w2ui.layoutDevolucion.content('left', w2ui.gridDEVXUSUDEVS);
                        w2ui.layoutDevolucion.content('main', w2ui.formDEVXUSUDEVS);
                    };
                },
                onMax: function (event) {
                    event.onComplete = function () {
                        w2ui.layoutDevolucion.resize();
                    }
                },
                onMin: function (event) {
                    event.onComplete = function () {
                        w2ui.layoutDevolucion.resize();
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        $('#formDevUsers').w2form({
            name: 'formDevUsers',
            header: 'Devolucion de Usuarios',
            formHTML: '<div class="w2ui-page page-0">' +
		                '<div style="width: 406px; float: left;">' +
			                '<div class="w2ui-group" style="height: 144px; margin-top: 0px;">' +
				                '<div class="w2ui-label w2ui-span6">Devolución Bodega:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<input name="nroDevBodega" type="text" maxlength="100" style="width: 60%" disabled="disabled"/>' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span6">Bodega:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<select name="listaBodegas" type="text" />' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span6">Periodo:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<select name="listaPeriodos" type="text" />' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span6">Centro Costo:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<select name="centrosCosto" type="text" />' +
				                '</div>' +
			                '</div>' +
		                '</div>' +
		                '<div style="margin-left: 411px;">' +
			                '<div class="w2ui-group" style="height: 144px;">' +
                                '<div class="w2ui-label w2ui-span5">Observación:</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
					                '<textarea name="observacionDevolucion" type="text" style="width: 60%; height: 80px; resize: none"></textarea>' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span5">Usuario:</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
					                '<input name="usuarioDevolucion" type="text" maxlength="100" style="width: 60%" disabled="disabled"/>' +
                                '</div>' +
			                '</div>' +
		               ' </div>' +
	                '</div>' +
	                '<div class="w2ui-buttons">' +
		                '<input type="button" value="Buscar Devolución" name="BuscarDevolucion" style="width: 118px;">' +
		                '<input type="button" value="Limpiar" name="limpiar">' +
                        '<input type="button" value="Guardar" name="GuardarDevolucion" style="border-color: cornflowerblue;">' +
                        '<input type="button" value="Imprimir" name="ImprimirDevolucion">' +
                        '<input type="button" value="Imprimir QRs" name="ImprimirQRs" style="width: 94px;">' +
	                '</div>',
            fields: [
                { name: 'nroDevBodega', type: 'int' },
                { name: 'usuarioDevolucion', type: 'text' },
                { name: 'observacionDevolucion', type: 'text' },
                { name: 'listaPeriodos', type: 'list',
                    options: { url: '../../clases/persistencia/controladores/Recepciones/DevolucionXUsuarios/DevolucionUsuariosHandler.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqeda=periodos' + '&centroCosto=' + centroCosto }
                },
                { name: 'listaBodegas', type: 'list',
                    options: { url: '../../clases/persistencia/controladores/Recepciones/DevolucionXUsuarios/DevolucionUsuariosHandler.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqeda=bodegas' + '&centroCosto=' + centroCosto }
                },
                { name: 'centrosCosto', type: 'list',
                    options: { url: '../../clases/persistencia/controladores/Recepciones/DevolucionXUsuarios/DevolucionUsuariosHandler.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqeda=centrosCosto' + '&centroCosto=' + centroCosto }
                }
            ],
            record: {
                usuarioDevolucion: userName
            },
            actions: {
                BuscarDevolucion: function () {
                    openPopupDevs();
                },
                limpiar: function () {
                    $('#listaBodegas').prop('disabled', false);
                    $('#listaPeriodos').attr('disabled', false);
                    $('#centrosCosto').attr('disabled', false);

                    this.clear();
                    w2ui.gridDevUsers.clear();

                    w2ui.gridDevUsers.refresh();
                },
                GuardarDevolucion: function () {
                    w2ui.gridDevUsers.save();
                },
                ImprimirDevolucion: function () {
                    var NTransaccion;
                    var fechaTransaccion;
                    var bodega;
                    var centroCosto;
                    var periodo;
                    var descripcion = this.record['observacionDevolucion'];
                    ususarioDev = this.record['usuarioDevolucion'];
                    var numeroLinea;
                    var codMaterial;
                    var nombreMaterial;
                    var cantMaterial;
                    var valorUnitario;

                    // Identifica ID de busqueda.
                    if (this.record['nroDevBodega']) {
                        NTransaccion = this.record['nroDevBodega'];

                        if (fechaDevolucion) {
                            fechaTransaccion = fechaDevolucion;

                            if (this.record['listaBodegas']) {
                                bodega = $('#listaBodegas option:selected').text();

                                if (this.record['centrosCosto']) {
                                    centroCosto = $('#centrosCosto option:selected').text();

                                    if (this.record['listaPeriodos']) {
                                        periodo = this.record['listaPeriodos'];

                                        /* Graba materiales en la tabla TEMP */
                                        var cont = 1;
                                        var CodigoMaterial;
                                        var NombreMaterial;
                                        var CantidadMovimiento;
                                        var PrecioUnitario;

                                        var done = 0;
                                        var ReportUsuario = '';

                                        for (var i = 0; i <= w2ui.gridDevUsers.records.length - 1; i++) {

                                            CodigoMaterial = w2ui.gridDevUsers.records[i].matCodigo;
                                            NombreMaterial = w2ui.gridDevUsers.records[i].nombreMaterial;
                                            CantidadMovimiento = w2ui.gridDevUsers.records[i].cantidad;
                                            PrecioUnitario = w2ui.gridDevUsers.records[i].precioUnitario;
                                            NSerielote = w2ui.gridDevUsers.records[i].loteSerie;
                                            fechaVencimiento = w2ui.gridDevUsers.records[i].fechaVencimiento;

                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                                                async: false,
                                                data: { "cmd": 'RPTInforme', "NTransaccion": NTransaccion, "periodo": periodo, "codTransaccion": tmvNumero, "Linea": cont, "codMaterial": CodigoMaterial, "nombreMaterial": NombreMaterial, "CodItem": '', "cantMaterial": CantidadMovimiento, "precioMaterial": PrecioUnitario, "bodega": bodega, "descripcion": obervacion, "fechaMovimieno": fechaTransaccion, "proveedor": '', "ordenCompra": '0', "ordenCompraEstado": '', "numeroDocumento": '0', "Institucion": '', "centroCosto": centroCosto, "tipoDocumento": '', "tituloMenu": 'RECEPCIÓN USUARIOS', "descuento": '0', "impuesto": '0', "diferenciaPeso": '0', "usuario": ususarioDev },
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
                                            window.open('../../reportes/Recepciones/deUsuarios/Rpt_Recepcion_deUsuarios.aspx?CMVCodigo=' + NTransaccion + '&PERCodigo=' + periodo + '&TMVCodigo=' + tmvNumero + '&usuario=' + ususarioDev);
                                        } else {
                                            alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                        }

                                    } else { alert("Faltan datos para imprimir."); } // Fin nombre periodo recepcion.
                                } else { alert("Faltan datos para imprimir."); } // Fin centro costo.
                            } else { alert("Faltan datos para imprimir."); } // Fin nombre Bodega.
                        } else { alert("Faltan datos para imprimir."); } // Fin fechaTransaccion.
                    } else { // alerta de mensaje por no ingresar nada.
                        alert("Primero ingrese o búsque una recepción");
                    }
                },
                ImprimirQRs: function () {

                    if (this.record['nroDevBodega'] && this.record['nroDevBodega'] != '0') {
                        openPopup3();
                    } else {
                        w2alert('Debe realizar una devolución o buscar una ya realizada para imprimir las etiquetas requeridas.');
                    }
                }
            }
        });
    </script>
    <script type="text/javascript">
        $('#gridDevUsers').w2grid({
            name: 'gridDevUsers',
            show: {
                toolbar: true,
                footer: true,
                toolbarSearch: false,
                toolbarAdd: true,
                toolbarDelete: true,
                toolbarSave: false,
                toolbarReload: false,
                toolbarColumns: false
            },
            columns: [
			    { field: 'matCodigo', caption: 'Codigo Material', size: '10%', attr: 'align=center' },
			    { field: 'nombreMaterial', caption: 'Nombre Material', size: '50%' },
			    { field: 'cantidad', caption: 'Cantidad', size: '7%', editable: { type: 'int' }, attr: 'align=center' },
				{ field: 'loteSerie', caption: 'Lote/Serie', size: '11%', editable: { type: 'alphanumeric' }, style: 'text-align:center' },
				{ field: 'fechaVencimiento', caption: 'Fecha Vencimiento', size: '11%', editable: { type: 'date', format: 'dd-mm-yy' }, attr: "align=center, onkeypress='return justFecha(event);'" },
			    { field: 'precioUnitario', caption: 'Precio Unitario', size: '9%', attr: 'align=center' },
			    { field: 'unidadMedida', caption: 'Unidad de Medida', size: '11%', attr: 'align=center' }
		    ],
            onChange: function (event) {
                if (event.column == 2) {
                    //this.set(event.recid, { 'cantidad': event.value_new });
                }
                if (event.column == 3) {
                    //this.set(event.recid, { 'loteSerie': event.value_new });
                }
                if (event.column == 4) {

//                    if (this.records[event.recid - 1].changes.cantidad > 0) {
//                        if (this.records[event.recid - 1].changes.loteSerie != '0' && this.records[event.recid - 1].changes.loteSerie != '' && this.records[event.recid - 1].changes.loteSerie != 'undefined') {

//                            var todayDate = new Date();
//                            var day = todayDate.getDate();
//                            var month = todayDate.getMonth() + 1;
//                            var year = todayDate.getFullYear();
//                            var fechaNew = event.value_new;
//                            var controlFecha = 0;

//                            var fechaPart = fechaNew.split("/");

//                            if (fechaPart.length == 3) {
//                                var dia = parseInt(fechaPart[0]);
//                                var mes = parseInt(fechaPart[1]);
//                                var anio = parseInt(fechaPart[2]);

//                                if (dia <= 31 && dia > 0 && mes <= 12 && mes > 0 && anio >= 1900 && anio <= 2050) {
//                                    controlFecha = 0;
//                                } else {
//                                    controlFecha = 1;
//                                    alert(" Fecha mal ingresada. Ej: " + day + '/' + month + '/' + year)
//                                }

//                            } else {
//                                controlFecha = 1;
//                                alert(" Fecha mal ingresada. Ej: " + day + '/' + month + '/' + year)
//                            }
//                            if (controlFecha > 0) {
//                                this.set(event.recid, { fechaVencimiento: day + '/' + month + '/' + year });
//                            } else {
//                                this.set(event.recid, { fechaVencimiento: event.value_new });
//                            }
//                        } else {
//                            alert('Debe ingresar el lote o serie del material');
//                        }
//                    } else {
//                        alert('Debe ingresar la cantidad a recibir del material');
//                    }
                }

            },
            onDblClick: function (event) {
                cmvNumero = $('#nroDevBodega').val();
                if (cmvNumero != '' && cmvNumero != undefined) {
                    w2ui.gridDevUsers.error('No puede editar los datos de un material en una devolucion ya ralizada!');
                }
            },
            onAdd: function (event) {
                cmvNumero = $('#nroDevBodega').val();
                if (cmvNumero == '' || cmvNumero == undefined) {
                    codBodega = $('#listaBodegas').val();
                    if (codBodega == '') {
                        w2alert('Debe seleccionar una Bodega para realizar la busqueda de materiales!');
                    } else {
                        openPopup();
                    }
                } else {
                    w2alert('No puede agregar un material a una devolucion ya ralizada!');
                }
            },
            onDelete: function (event) {
                event.preventDefault();
                if (cmvNumero == '' || cmvNumero == undefined) {
                    for (i = 0; this.records.length > i; i++) {
                        if (this.records[i].selected && this.records[i].selected == true) {
                            this.remove(this.records[i].recid);
                            this.total = this.total - 1;
                            this.buffered = this.buffered - 1;
                            break;
                        }
                    }
                } else {
                    w2alert('No puede eliminar un material en una devolución ya ralizada!');
                }
            },
            /* saveForm */
            onSave: function (event) {

                event.preventDefault();
                cmvNumero = $('#nroDevBodega').val();
                if (cmvNumero == '' || cmvNumero == undefined || cmvNumero == '0') {
                    $.ajax({
                        url: '../../clases/persistencia/controladores/Recepciones/DevolucionxUsuarios/DevolucionUsuariosHandler.ashx',
                        type: 'POST',
                        dataType: 'json',
                        data: { tipoBusqueda: 'obtieneFechaServidor' },
                        success: function (response) {
                            if (response.status == 'error') {
                                w2alert(response.message);
                            } else {
                                fechaDevolucion = response.fechaServer;
                            }
                        },
                        error: function (response) {
                            alert("No se pudo obtener la fecha del servidor vuelva a intentarlo mas tarde.");
                        }
                    });
                    $.ajax({
                        url: '../../clases/persistencia/controladores/Recepciones/DevolucionxUsuarios/DevolucionUsuariosHandler.ashx',
                        type: 'POST',
                        dataType: 'json',
                        data: { materiales: this.records, formData: w2ui.formDevUsers.record, tipoBusqueda: 'generaDevolucionUsuarios', usuarioLog: userName, largoGridMats: this.records.length },
                        success: function (response) {
                            if (response.status == 'error') {
                                w2alert(response.message);
                            } else {

                                w2alert('¡Se generó la devolución ' + response.cmvNumero + ' con éxito!');
                                tmvNumero = response.tmvCodigo;
                                periodoDev = response.periodo;
                                cmvNumero = response.cmvNumero;

                                w2ui.formDevUsers.record = {
                                    nroDevBodega: response.cmvNumero,
                                    listaBodegas: $('#listaBodegas').val(),
                                    listaPeriodos: $('#listaPeriodos').val(),
                                    centrosCosto: $('#centrosCosto').val(),
                                    usuarioDevolucion: $('#usuarioDevolucion').val()
                                }

                                w2ui.formDevUsers.refresh();

                                w2ui.gridDevUsers.url = '../../clases/persistencia/controladores/Recepciones/DevolucionXUsuarios/DevolucionUsuariosHandler.ashx?tipoBusqueda=buscaMaterialesDevolucion' + '&numeroDev=' + cmvNumero + '&periodoDev=' + periodoDev + '&usuario=' + ususarioDev;
                                w2ui.gridDevUsers.reload();
                            }
                        },
                        error: function (response) {
                            alert("Ha ocurrio un error en la operación vuelva a intentarlo mas tarde.");
                        }
                    });

                } else {

                    /* Se actualiza la observación */
                    $.ajax({
                        url: '../../clases/persistencia/controladores/Recepciones/DevolucionXUsuarios/DevolucionUsuariosHandler.ashx',
                        type: 'POST',
                        dataType: "json",
                        data: { formData: w2ui.formDevUsers.record, tipoBusqueda: 'actualizaDevolucionUsuarios', usuarioLog: userName },
                        success: function (response) {
                            if (response.status == 'error') {
                                w2alert(response.message);
                            } else {
                                w2ui.formDevUsers.record = {
                                    nroDevBodega: cmvNumero,
                                    listaBodegas: $('#listaBodegas').val(),
                                    listaPeriodos: $('#listaPeriodos').val(),
                                    centrosCosto: $('#centrosCosto').val(),
                                    usuarioDevolucion: $('#usuarioDevolucion').val(),
                                    observacionDevolucion: response.descripcion
                                }

                                w2ui.formDevUsers.refresh();

                                w2alert('¡Se actuaizó la observación de la devolución ' + cmvNumero + ' con éxito!');
                            }
                        },
                        error: function (response) {
                            alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                        }
                    });
                }
            }
        });

        function justFecha(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 46) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;
            else
                return true;

            //return /\d/.test(String.fromCharCode(keynum));
        } 

    </script>

    <!-- Metodo para cantidad de QR -->
    <script type="text/javascript">

        //================
        // Cantidad QR
        //================

        $(function () {
            // initialization in memory
            $().w2layout(config3.layout3);
            $().w2grid(config3.grid5);
            $().w2form(config3.form5);
        });

        // pop codigos QR
        function openPopup3() {
            w2popup.open({
                title: 'Cantidad Etiquetado',
                width: 850,
                height: 420,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                onOpen: function (event) {
                    event.onComplete = function () {

                        $('#w2ui-popup #main').w2render('layout3');
                        w2ui.layout3.content('left', w2ui.grid5);
                        w2ui.layout3.content('main', w2ui.form5);

                        w2ui['grid5'].clear();

                        setTimeout(function () {
                            $("#QRPeriodo").val(periodoDev);
                            $("#QRNumero").val(cmvNumero);

                            // recorre el grid en busca de los materiales ingresados para preguntar cuantas equiquetas se imprimiran de cada uno.
                            for (var i = 0; i < w2ui['gridDevUsers'].records.length; i++) {
                                w2ui['grid5'].add({ recid: w2ui['gridDevUsers'].records[i].recid, FLD_MATCODIGO: w2ui['gridDevUsers'].records[i].matCodigo, CANTIDAD_OFICIAL: w2ui['gridDevUsers'].records[i].cantidad, FLD_NERIE: w2ui['gridDevUsers'].records[i].loteSerie, FLD_CANTIDAD: 0 });
                            }

                        }, 200);

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

        var config3 = {
            layout3: {
                name: 'layout3',
                padding: 4,
                panels: [
			        { type: 'left', size: '58%', resizable: true, minSize: 200 },
			        { type: 'main', minSize: 200 }
		        ]
            },

            // GRID DEL POPUP
            grid5: {
                name: 'grid5',
                columns: [
			        { field: 'FLD_MATCODIGO', caption: 'Cod. Material', size: '20%', sortable: true },
                    { field: 'FLD_NERIE', caption: 'Serie o Lote', size: '20%', sortable: true },
                    { field: 'CANTIDAD_OFICIAL', caption: 'Cantidad', size: '20%', sortable: true },
			        { field: 'FLD_CANTIDAD', caption: 'Cant. Imprimir', size: '20%', sortable: true, resizable: true,
			            editable: { type: 'int', inTag: 'maxlength=4' }, attr: "align=center"
			        }
		        ]
            },

            // FORM DEL POPUP
            form5: {
                header: 'Información de Transacción',
                name: 'form5',
                fields: [
                    { name: 'QRNumero', type: 'text', html: { caption: 'Nº Operación', attr: 'size="14" maxlength="20" disabled '} },
                    { name: 'QRPeriodo', type: 'text', html: { caption: 'Periodo', attr: 'size="14" maxlength="20" disabled '} }
		        ],
                actions: {
                    Imprimir: function () {

                        // Guarda los datos para imprimir.
                        $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                            async: false,
                            data: { cmd: 'INSCantidadQR', GridQR: w2ui['grid5'].records, largoGrid: w2ui['grid5'].records.length, Periodo: periodoDev, NumMov: cmvNumero, CodMov: 'D' },
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

                        // carga pestaña de codigos QR
                        window.open('../../generadorQR/Recepcion/DevolucionxUsuario/QR_DevolXUsuario.aspx?TMVCodigo=' + 'D' + '&PerCodigo=' + periodoDev + '&ID=' + cmvNumero + '&FechaOP=' + fechaDevolucion);
                        //window.open('../../generadorQR/Recepcion/RecepcionxDonacion/QR_RecepcionxDonacion.aspx?TMVCodigo=' + '3' + '&PerCodigo=' + w2ui['form'].record['anioDonacion'] + '&ID=' + w2ui['form'].record['NDonacion'] + '&fechaOperacion=' + w2ui['form'].record['fechaServidor'] + '&Proveedor=' + 'x');

                        setTimeout(function () {
                            w2popup.close();
                        }, 200);
                    },
                    Limpiar: function () {
                        this.clear();
                        w2ui['grid5'].clear();
                    }
                }// Fin Acciones
            }// fin Form3, Grid2
        } // Fin Config.
    </script>

</asp:Content>
