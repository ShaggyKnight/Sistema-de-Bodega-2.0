<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="RercepcionCenabast.aspx.vb" Inherits="Bodega_WebApp.RercepcionCenabast" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
     <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.cenabast%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="formCenabast" class="col-lg-12" style="margin-bottom: 3px; height: 398px;">
    </div>
    <div id="gridCenabast" style=" height: 400px; overflow: hidden; margin-bottom: 3px;">
    </div>
</asp:Content>
<asp:Content ID="FooterContent" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="JavascriptContent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <!--variables globales-->
    <script type="text/javascript">
        //Variables generales
        var userName = '';
        var centroCosto = '';
        var recidGridPopUp = 0;
        var largoGridMateriales = 0;
        //variables PopUp Materiales
        var codMaterial = '';
        var codItemPres = 0;
        var codBodega = '';
        var nombreMaterial = '';
        var precioMat = 0;
        var unidadMedida = '';
        var codigoCenabast = '';
        var selecIndx = 0;
        //Variables recepcion
        var cmvNumero = 0;
        var periodoDev = '';
        var nroFacturaCenabast = '';
        var nroFacturaInterno = '';
        var codBodegaDev = '';
        var centroCostoDev = '';
        var obervacion = '';

        userName = '<%=usuario.username %>';
        centroCosto = '<%=usuario.centroDeCosto %>';
    </script>
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
                name: 'gridRECXCENABAST',
                columns: [
			            { field: 'matCodigo', caption: 'Cod. Material', size: '7.5%', attr: 'align=center' },
			            { field: 'codigoCenabast', caption: 'Cod. CENABAST', size: '9.5%', attr: 'align=center' },
			            { field: 'nombreMaterial', caption: 'Nombre Material', size: '23%' },
			            { field: 'precioUnitario', caption: '$ Unitario', size: '6.5%', attr: 'align=center' },
			            { field: 'codItemPresupuestario', caption: 'Cod. Item', size: '7.5%', attr: 'align=center' },
			            { field: 'unidadMedida', caption: 'Unidad Medida', size: '10%', attr: 'align=center' }
		            ],
                onSelect: function (event) {
                    codMaterial = this.records[this.last.sel_ind].matCodigo;
                    nombreMaterial = this.records[this.last.sel_ind].nombreMaterial;
                    precioMat = this.records[this.last.sel_ind].precioUnitario;
                    unidadMedida = this.records[this.last.sel_ind].unidadMedida;
                    codigoCenabast = this.records[this.last.sel_ind].codigoCenabast;
                    recidGridPopUp = this.records[this.last.sel_ind].recid;
                    selecIndx = this.last.sel_ind;
                }
            },
            form: {
                header: 'Buasqueda de Materiales',
                name: 'formRECXCENABAST',
                formHTML: '<div class="w2ui-page page-0">' +
		                    '<div class="w2ui-label w2ui-span6">Nombre Material:</div>' +
		                    '<div class="w2ui-field w2ui-span6">' +
			                    '<input name="nombreMatRECXCENABAST" type="text" maxlength="10" size="20"/>' +
		                    '</div>' +
		                    '<div class="w2ui-label w2ui-span6">Código Material:</div>' +
		                    '<div class="w2ui-field w2ui-span6">' +
		                    '	<input name="codigoMatRECXCENABAST" type="text" maxlength="10" size="20"/>' +
		                    '</div>' +
		                    '<div class="w2ui-label w2ui-span6">Código CENABAST:</div>' +
		                    '<div class="w2ui-field w2ui-span6">' +
		                    '	<input name="codigoCenRECXCENABAST" type="text" maxlength="10" size="20"/>' +
		                    '</div>' +
		                '</div>' +
                        '<div class="w2ui-buttons">' +
		                    '<input type="button" value="Buscar" name="Buscar">' +
		                    '<input type="button" value="Aceptar" name="Aceptar">' +
		                    '<input type="button" value="Limpiar" name="Limpiar">' +
		                    '<input type="button" value="Cerrar" name="Cerrar">' +
	                    '</div>',
                fields: [
			            { name: 'nombreMatRECXCENABAST', type: 'text' },
			            { name: 'codigoMatRECXCENABAST', type: 'alphanumeric' },
			            { name: 'codigoCenRECXCENABAST', type: 'int' }
		            ],
                actions: {
                    Buscar: function () {
                        var nombreMaterial = this.record.nombreMatRECXCENABAST;
                        var codigoMaterial = this.record.codigoMatRECXCENABAST;
                        var codigoCenabast = this.record.codigoCenRECXCENABAST;

                        if (nombreMaterial == undefined) {
                            nombreMaterial = '';
                        }
                        if (codigoMaterial == undefined) {
                            codigoMaterial = '';
                        }
                        if (codigoCenabast == undefined) {
                            codigoCenabast = '';
                        }

                        w2ui.gridRECXCENABAST.url = '../../clases/persistencia/controladores/CENABAST/RecepCenabast/CenabastHandler.ashx?tipoBusqueda=busquedaMatsPopUp' + '&codBodega=' + codBodega + '&nombreMaterial=' + nombreMaterial + '&codigoMaterial=' + codigoMaterial + '&largoGrid=' + largoGridMateriales + '&codigoCenabast=' + codigoCenabast;
                        w2ui.gridRECXCENABAST.reload();
                    },
                    Aceptar: function () {

                        var todayDate = new Date();
                        var day = todayDate.getDate();
                        var month = todayDate.getMonth() + 1;
                        var year = todayDate.getFullYear();

                        if (w2ui.gridCenabast.total > 0) {
                            w2ui.gridCenabast.add({ recid: (w2ui.gridCenabast.records[w2ui.gridCenabast.total - 1].recid + 1), matCodigo: codMaterial, nombreMaterial: nombreMaterial, codigoCenabast: codigoCenabast, cantidad: 0, loteSerie: '0', fechaVencimiento: (day + '/' + month + '/' + year), precioUnitario: precioMat, unidadMedida: unidadMedida });
                            //                            w2ui.gridDevUsers.total = w2ui.gridDevUsers.total + 1;
                        } else {
                            w2ui.gridCenabast.add({ recid: 1, matCodigo: codMaterial, nombreMaterial: nombreMaterial, codigoCenabast: codigoCenabast, cantidad: 0, loteSerie: '0', fechaVencimiento: (day + '/' + month + '/' + year), precioUnitario: precioMat, unidadMedida: unidadMedida });
                            //                            w2ui.gridDevUsers.total = 1;
                        }

                    },
                    Limpiar: function () {
                        this.clear();
                        w2ui.gridRECXCENABAST.clear();
                    },
                    Cerrar: function () {
                        w2popup.close();
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
    <!-- instancia de abertura de pop up para busqueda DE MATERIAL -->
    <script type="text/javascript">
        function openPopup() {
            w2popup.open({
                title: 'BÚSQUEDA DE MATERIALES',
                width: 1100,
                height: 600,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                modal: true,
                onOpen: function (event) {
                    event.onComplete = function () {
                        $('#w2ui-popup #main').w2render('layoutMateriales');
                        w2ui.layoutMateriales.content('left', w2ui.gridRECXCENABAST);
                        w2ui.layoutMateriales.content('main', w2ui.formRECXCENABAST);
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
    <script type="text/javascript">
        $('#formCenabast').w2form({
            name: 'formCenabast',
            header: 'RECEPCIÓN POR CENABAST',
            formHTML: '<div class="w2ui-page page-0">' +
		                '<div style="width: 406px; float: left;">' +
			                '<div class="w2ui-group" style="height: 177px; margin-top: 0px;">' +
				                '<div class="w2ui-label w2ui-span6">Nro. Recepción:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<input name="nroRecepcion" type="text" maxlength="100" style="width: 60%" disabled="disabled"/>' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span6">NºFactura Cenabast:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<input name="NroFacturaCenabast" type="text" maxlength="100" style="width: 60%" />' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span6">NºFactura Interna:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<input name="nroFacturaInterno" type="text" maxlength="100" style="width: 60%" />' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span6">Centro Costo:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<select name="centrosCosto" type="text" style="width: 85%"/>' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span6">Proveedor:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<select name="ProveedorSelect" type="text" style="width: 85%"/>' +
				                '</div>' +
			                '</div>' +
		                '</div>' +
		                '<div style="margin-left: 411px;">' +
			                '<div class="w2ui-group" style="height: 177px;">' +
                                '<div class="w2ui-label w2ui-span6">Bodega:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<select name="listaBodegas" type="text" />' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span6">Periodo:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<select name="listaPeriodos" type="text" />' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span6">Total:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<input name="totalRecepcion" type="text" maxlength="60" style="width: 40%" />' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span6">Impuesto:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<input name="impuestoRecep" type="text" maxlength="60" style="width: 40%" />' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span6">I.V.A:</div>' +
				                '<div class="w2ui-field w2ui-span6">' +
					                '<input name="ivaRecep" class="form-control" type=checkbox size="35"/>' +
				                '</div>' +
			                '</div>' +
		               ' </div>' +
			            '<div class="w2ui-group" style="height: 90px; margin-top: 0px;">' +
                            '<div class="w2ui-label w2ui-span5" style="margin-left: 15%; margin-right: 1%;">Observación:</div>' +
				            '<div class="w2ui-field w2ui-span5">' +
					            '<textarea name="observacionRecepcion" type="text" style="width: 50%; height: 60px; resize: none"></textarea>' +
				            '</div>' +
		               ' </div>' +
	                '</div>' +
	                '<div class="w2ui-buttons">' +
		                '<input type="button" value="Buscar Recepción" name="buscarRecepcion" style="width: 118px;">' +
		                '<input type="button" value="Limpiar" name="limpiar">' +
                        '<input type="button" value="Guardar" name="guardarRecepcion">' +
                        '<input type="button" value="Imprimir" name="imprimirRecepcion">' +
	                '</div>',
            fields: [
                { name: 'nroRecepcion', type: 'int' },
                { name: 'NroFacturaCenabast', type: 'alphanumeric' },
                { name: 'nroFacturaInterno', type: 'alphanumeric' },
                { name: 'observacionRecepcion', type: 'text' },
                { name: 'ProveedorSelect', type: 'list',
                    options: { url: '../../clases/persistencia/controladores/CENABAST/RecepCenabast/CenabastHandler.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqeda=Proveedores' + '&centroCosto=' + centroCosto }
                },
                { name: 'totalRecepcion', type: 'int' },
                { name: 'impuestoRecep', type: 'text' },
                { name: 'ivaRecep', type: 'checkbox' },
                { name: 'listaPeriodos', type: 'list',
                    options: { url: '../../clases/persistencia/controladores/CENABAST/RecepCenabast/CenabastHandler.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqeda=periodos' + '&centroCosto=' + centroCosto }
                },
                { name: 'listaBodegas', type: 'list',
                    options: { url: '../../clases/persistencia/controladores/CENABAST/RecepCenabast/CenabastHandler.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqeda=bodegas' + '&centroCosto=' + centroCosto }
                },
                { name: 'centrosCosto', type: 'list',
                    options: { url: '../../clases/persistencia/controladores/CENABAST/RecepCenabast/CenabastHandler.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqeda=centrosCosto' + '&centroCosto=' + centroCosto }
                }
            ],
            actions: {
                buscarRecepcion: function () {
//                    openPopupDevs();
                },
                limpiar: function () {
                    $('#listaBodegas').prop('disabled', false);
                    $('#listaPeriodos').attr('disabled', false);
                    $('#centrosCosto').attr('disabled', false);

                    this.clear();
                    w2ui.gridCenabast.clear();

                    w2ui.gridCenabast.refresh();
                },
                guardarRecepcion: function () {
                    w2ui.gridCenabast.save();
                },
                imprimirRecepcion: function () {

                }
            }
        });
    </script>
    <script type="text/javascript">
        $('#gridCenabast').w2grid({
            name: 'gridCenabast',
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
			    { field: 'nombreMaterial', caption: 'Nombre Material', size: '50%', attr: 'align=center' },
			    { field: 'codigoCenabast', caption: 'Codigo CENABAST', size: '10%', attr: 'align=center' },
			    { field: 'cantidad', caption: 'Cantidad', size: '7%', editable: { type: 'int' }, attr: 'align=center' },
				{ field: 'loteSerie', caption: 'Nro Lote', size: '11%', editable: { type: 'alphanumeric' }, style: 'text-align:center' },
				{ field: 'fechaVencimiento', caption: 'Fecha Vencimiento', size: '11%', editable: { type: 'date', format: 'dd-mm-yy' }, attr: 'align=center' },
			    { field: 'precioUnitario', caption: 'Precio Unitario', size: '9%', attr: 'align=center' },
			    { field: 'unidadMedida', caption: 'Unidad de Medida', size: '11%', attr: 'align=center' }
		    ],
            onChange: function (event) {
                event.preventDefault();
                var valorNuevo = event.value_new;
                var idFila = event.recid;
                var columnaEv = event.column;
                if (columnaEv == 3) {
                    this.records[idFila - 1].cantidad = valorNuevo;
                    this.records[idFila - 1].loteSerie = this.records[idFila - 1].loteSerie;
                    this.set(idFila, { fechaVencimiento: this.records[idFila - 1].fechaVencimiento });
                } else if (columnaEv == 4) {
                    this.records[idFila - 1].cantidad = this.records[idFila - 1].cantidad;
                    this.records[idFila - 1].loteSerie = valorNuevo;
                    this.records[idFila - 1].fechaVencimiento = this.records[idFila - 1].fechaVencimiento;
                } else if (columnaEv == 5) {
                    this.records[idFila - 1].cantidad = this.records[idFila - 1].cantidad;
                    this.records[idFila - 1].loteSerie = this.records[idFila - 1].loteSerie;
                    this.records[idFila - 1].fechaVencimiento = valorNuevo;
                }
            },
            onDblClick: function (event) {
                cmvNumero = $('#nroRecepcion').val();
                if (cmvNumero != '' && cmvNumero != undefined) {
                    w2ui.gridCenabast.error('No puede editar los datos de un material en una recepción ya ralizada!');
                }
            },
            onAdd: function (event) {
                cmvNumero = $('#nroRecepcion').val();
                if (cmvNumero == '' || cmvNumero == undefined) {
                    codBodega = $('#listaBodegas').val();
                    if (codBodega == '') {
                        w2alert('Debe seleccionar una Bodega para realizar la búsqueda de materiales!');
                    } else {
                        openPopup();
                    }
                } else {
                    w2alert('No puede agregar un material a una recepción ya ralizada!');
                }
            },
            onDelete: function (event) {
                event.preventDefault();
                if (cmvNumero == '' || cmvNumero == undefined) {
                    var length = this.records.length;
                    for (i = 0; this.records.length > i; i++) {
                        if (this.records[i].selected && this.records[i].selected == true) {
                            var idChange = this.records[i].recid;
                            this.remove(this.records[i].recid)
                            for (j = i; length - 1 > j; j++) {
                                this.records[j].recid = idChange;
                                idChange = idChange + 1;
                            }
                            this.refresh();
                            break;
                        }
                    }
                } else {
                    w2alert('No puede eliminar un material en una recpeción ya ralizada!');
                }
            },
            onSave: function (event) {

                event.preventDefault();
                cmvNumero = $('#nroRecepcion').val();
                nroFacturaCenabast = $('#NroFacturaCenabast').val();
                nroFacturaInterno = $('#nroFacturaInterno').val();
                if (nroFacturaCenabast != '' && nroFacturaCenabast != undefined && nroFacturaCenabast != '0' && nroFacturaInterno != '' && nroFacturaInterno != undefined && nroFacturaInterno != '0') {
                    if (cmvNumero == '' || cmvNumero == undefined || cmvNumero == '0') {
                        $.ajax({
                            url: '../../clases/persistencia/controladores/CENABAST/RecepCenabast/CenabastHandler.ashx',
                            type: 'POST',
                            dataType: 'json',
                            data: { materiales: this.records, formData: w2ui.formCenabast.record, tipoBusqueda: 'generaRecepcionCenabast', usuarioLog: userName, largoGridMats: this.records.length },
                            success: function (response) {
                                if (response.status == 'error') {
                                    w2alert(response.message);
                                } else {

                                    w2alert('¡Se generó la Recepción ' + response.cmvNumero + ' con éxito!');

                                    window.open('../../generadorQR/Recepcion/DevolucionxUsuario/QR_DevolXUsuario.aspx?TMVCodigo=' + response.tmvCodigo + '&PerCodigo=' + response.periodo + '&ID=' + response.cmvNumero);

                                    w2ui.formCenabast.record = {
                                        nroRecepcion: response.cmvNumero,
                                        NroFacturaCenabast: $('#NroFacturaCenabast').val(),
                                        nroFacturaInterno: response.facturaInterna,
                                        listaBodegas: $('#listaBodegas').val(),
                                        listaPeriodos: $('#listaPeriodos').val(),
                                        centrosCosto: $('#centrosCosto').val()
                                    }

                                    w2ui.formCenabast.refresh();
                                }
                            },
                            error: function (response) {
                                alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                            }
                        });
                    } else {
                        w2alert("NO puede guardar una recepción ya realizada!");
                    }
                } else {
                    w2alert("Debe llenar todos los campos para guardar la recepcióºn");
                }
            }
        });	
    </script>
</asp:Content>
