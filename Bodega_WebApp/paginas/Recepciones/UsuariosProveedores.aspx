<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master"
    CodeBehind="UsuariosProveedores.aspx.vb" Inherits="Bodega_WebApp.UsuariosProveedores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.recepDesdeProveedores%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="form" class="col-lg-12" style="margin-bottom: 3px;">
    </div>
    <div id="grid" style=" height: 400px; overflow: hidden; margin-bottom: 3px;">
    </div>
    <div id="formFooter" style="margin-bottom: 3px;">
    </div>
    <div id="formNota" style="margin-bottom: 3px;">
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <!-- Variables globales -->
    <script type="text/javascript">

        /*
          *Solicitudes:
            se agrego la columna Estado de OC.
            se agrego el buscador inmediato de OC en el form principal (metodos nuevos al final).
            Creación de nueva opción Nota de Credito.
            Creación de nueva opcion Ajuste de valores.
            No existe NC cuando es "Contrato Marco" CM
            Se limpia el footer al colocar newIngreso
            Colocar Punto a los miles
            
        
          *Correcciones:
            se agrego boton limpiar.
            invirtieron los botones de busqueda y aceptar del form.
            Ahora la tabla Pro_ObtieneOrdenesyRecepciones_net se limpia con FLD_TIMESTAMP.
            se agregaron nuevos atributos al llamado de carga instantanea PRO_TB_ORDENESCOMPRA_SEL_net.
            Nuevo nivel de detalle en TB_DETALLE_EXISTENCIAS.

          *Pruebas:
            Carga: --
            Save: --
            Imprime: --
            QR: -
        */

        var periodo = '';
        var numeroOC = 0;
        var reload = 0;
        var iva = 1.19;
        var ivaSN = 0;
        var userName = "";
        var nombre = "";
        var rut = "";
        var tipo = "";
        var centroCosto = "";
        var bodegaDefault = "";
        var periodoRecep = "";
        var fechaRecepcion = "";
        var tmvCodigo = "";
        var nroRecepcion = 0;
        var idChileCompra = '';
        var nombreProveedor = '';
        var nroOc_Fast = 0;

        userName = ' <%=usuario.username %> ';
        nombre = '<%= usuario.nombre %>';
        rut = '<%= usuario.rut %>';
        tipo = '<%= usuario.tipo %>';
        centroCosto = '<%= usuario.centroDeCosto %>';

        /* datos temp para la nueva recepcion */
        var numeroDocTemp = '';
        var NOCtemp = '';
        var NNotaCreditotemp = '';
        var precioFacturatemp = '';
        var nroRecepciontemp = '';
        var totalAcumuladotemp = '';
        /*footerTemp*/
        var precionetotemp = '';
        var descuentotemp = '';
        var ivatemp = '';
        var totalReceptemp = '';
        
    </script>
    <!-- w2ui Definicion elementos de PopUp de busqueda por Recepcion y por orden de compra -->
    <script type="text/javascript">

        var config = {
            layout1: {
                name: 'layout1',
                padding: 4,
                panels: [
			            { type: 'left', size: '60%', minSize: 300 },
			            { type: 'main', minSize: 300 }
		            ]
            },
            grid2: {
                name: 'gridBRECEP',
                columns: [
			            { field: 'codigoRECEP', caption: 'Recepción', size: '9%' },
			            { field: 'fechaBRECEP', caption: 'Fecha', size: '10%' },
			            { field: 'descripcionBRECEP', caption: 'Descripción', size: '20%' },
			            { field: 'numeroOCRECEP', caption: 'O. Compra', size: '10%' },
			            { field: 'proveedorBRECEP', caption: 'Proveedor de Recepción', size: '30%' }
		            ],
                onSelect: function (event) {
                    numeroOC = this.records[this.last.sel_ind].numeroOCRECEP.substring(7);
                    periodo = this.records[this.last.sel_ind].numeroOCRECEP.substring(0, 4);
                    periodoRecep = this.records[this.last.sel_ind].codigoRECEP.substring(0, 4);
                    fechaRecepcion = this.records[this.last.sel_ind].fechaBRECEP;
                    nroRecepcion = this.records[this.last.sel_ind].codigoRECEP;
                }
            },
            form2: {
                header: 'Criterios de Busqueda',
                name: 'formBRECEP',
                formHTML: '<div class="w2ui-page page-0">' +
		                    '<div class="w2ui-label">Número Recepción:</div>' +
		                    '<div class="w2ui-field">' +
			                    '<input name="numeroRecBRECEP" type="text" maxlength="10" size="20"/>' +
		                    '</div>' +
		                    '<div class="w2ui-label">Periodo:</div>' +
		                    '<div class="w2ui-field">' +
			                    '<select name="periodoBRECEP" type="select"/>' +
		                    '</div>' +
	                    '</div>' +
                        '<div class="w2ui-page page-1">' +
		                    '<div class="w2ui-label">Numero O.C.:</div>' +
		                    '<div class="w2ui-field">' +
		                    '	<input name="numeroOCBRECEP" type="text" maxlength="10" size="20"/>' +
		                    '</div>' +
                            '<div class="w2ui-label">Periodo:</div>' +
		                    '<div class="w2ui-field">' +
			                    '<select name="periodoOCBRECEP" type="select"/>' +
		                    '</div>' +
                            '<div class="w2ui-label">Estado:</div>' +
		                    '<div class="w2ui-field">' +
			                    '<select name="estadoBRECEP" type="select"/>' +
		                    '</div>' +
	                    '</div>' +
                        '<div class="w2ui-buttons">' +
                            '<input type="button" value="Buscar" name="Buscar">' +
		                    '<input type="button" value="Limpiar" name="Limpiar">' +
                            '<input type="button" value="Aceptar" name="Aceptar">' +
	                    '</div>',
                fields: [
			            { name: 'numeroRecBRECEP', type: 'text' },
			            { name: 'numeroOCBRECEP', type: 'text' },
			            { name: 'periodoBRECEP', type: 'list',
			                options: { url: '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDataPopupForm.ashx?campoDeCarga=periodo' }
			            },
                        { name: 'periodoOCBRECEP', type: 'list',
                            options: { url: '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDataPopupForm.ashx?campoDeCarga=periodo' }
                        },
			            { name: 'estadoBRECEP', type: 'list', html: { caption: 'Estado OC', attr: 'style="display:none;"' },
			                options: { url: '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDataPopupForm.ashx?campoDeCarga=estado' }
			            }
		            ],
                tabs: [
			        { id: 'tab1', caption: 'Por Recepción' },
			        { id: 'tab2', caption: 'Por Orden Compra' }
		        ],
                actions: {
                    Buscar: function () {
                        if (this.page == 0) {
                            w2ui.gridBRECEP.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/BusquedaRECPorUp.ashx?numeroRecBRECEP=' + this.record.numeroRecBRECEP + '&periodoBRECEP=' + this.record.periodoBRECEP + '&criterioBusqueda=porRecepcion';
                            w2ui.gridBRECEP.reload();
                        } else {
                            w2ui.gridBRECEP.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/BusquedaRECPorUp.ashx?numeroOCBRECEP=' + this.record.numeroOCBRECEP + '&periodoOCBRECEP=' + this.record.periodoOCBRECEP + '&estadoBRECEP=' + this.record.estadoBRECEP + '&criterioBusqueda=porOCompra';
                            w2ui.gridBRECEP.reload();
                        }
                    },

                    Limpiar: function () {
                        this.clear();
                        w2ui.gridBRECEP.clear();
                    },

                    /* BuscaRecep, buscador de recepcion */
                    Aceptar: function () {

                        var NroOC = w2ui['gridBRECEP'].records[w2ui['gridBRECEP'].getSelection()].codigoRECEP;
                        NroOC = NroOC.split("/");
                        nroRecepcion = parseInt(NroOC[1]);

                        w2popup.close();
                        
                        setTimeout(function () {
                            validarBodega_BusRecep();
                        }, 800);

                    }
                }
            },
            layout: {
                name: 'layout',
                padding: 4,
                panels: [
			            { type: 'left', size: '60%', minSize: 300 },
			            { type: 'main', minSize: 300 }
		            ]
            },
            grid1: {
                name: 'gridBOC',
                columns: [
			            { field: 'añoBOC', caption: 'Año', size: '5%' },
			            { field: 'numeroBOC', caption: 'N°', size: '5%' },
			            { field: 'proveedorBOC', caption: 'Proveedor', size: '28%' },
			            { field: 'PrecioBOC', caption: 'Precio', size: '10%' },
			            { field: 'idChileComBOC', caption: 'I.D. ChileCompra', size: '13%' },
                        { field: 'estadoBOC', caption: 'Estado OC', size: '16%' }
		            ],
                onSelect: function (event) {
                    numeroOC = this.records[this.last.sel_ind].numeroBOC;
                    periodo = this.records[this.last.sel_ind].añoBOC;
                }
            },
            form1: {
                header: 'Criterios de Busqueda',
                name: 'formBOC',
                fields: [
			            { name: 'numeroBOC', type: 'text', html: { caption: 'Número OC', attr: 'size="10" maxlength="10"'} },
			            { name: 'idChileCOmpraBOC', type: 'text', html: { caption: 'ID Chile Compra', attr: 'size="30" maxlength="30"'} },
			            { name: 'periodoBOC', type: 'list', html: { caption: 'Periodo OC' },
			                options: { url: '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDataPopupForm.ashx?campoDeCarga=periodo' }
			            },
			            { name: 'estadoBOC', type: 'list', html: { caption: 'Estado OC' },
			                options: { url: '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDataPopupForm.ashx?campoDeCarga=estado' }
			            },
			            { name: 'rutProveedorBOC', type: 'list', html: { caption: 'Proveedor', attr: 'style="width:274px;"' },
			                options: { url: '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDataPopupForm.ashx?campoDeCarga=proveedor' }
			            }
		            ],
                actions: {
                    Buscar: function () {
                        w2ui.gridBOC.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/BusquedaOCPopUp.ashx?numeroBOC=' + this.record.numeroBOC + '&periodoBOC=' + this.record.periodoBOC + '&estadoBOC=' + this.record.estadoBOC + '&rutProveedorBOC=' + this.record.rutProveedorBOC + '&chileCompraBOC=' + this.record.idChileCOmpraBOC;
                        w2ui.gridBOC.reload();
                    },

                    Limpiar: function () {
                        this.clear();
                    },

                    /* Buscador de Ordenes de Compra */
                    Aceptar: function () {

                        w2popup.close();
                        setTimeout(function () {
                            validarBodega();
                        }, 600);
                    }
                }
            },

            /* nota */
            layout2: {
                name: 'layout2',
                padding: 4,
                panels: [
			            { type: 'main', minSize: 750 }
		            ]
            },
            grid3: {
                name: 'gridNota',
                columns: [
			            { field: 'codigoRECEP', caption: 'Recepción', size: '9%' },
			            { field: 'fechaBRECEP', caption: 'Fecha', size: '10%' },
			            { field: 'descripcionBRECEP', caption: 'Descripción', size: '20%' },
			            { field: 'numeroOCRECEP', caption: 'O. Compra', size: '10%' },
			            { field: 'proveedorBRECEP', caption: 'Proveedor de Recepción', size: '30%' }
		            ],
                onSelect: function (event) {

                }
            },
            form3: {
                header: 'SOLICITUD DE NOTA DE CREDITO',
                name: 'formNota',
                url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
                formHTML:
                        '<div class="w2ui-page page-0">' +

                /* Grupo Nota Credito */
	                       '<div style="width: 340px; float: left; margin-right: 0px;">' +
                           '<div style="padding: 3px; font-weight: bold; color: #777;" >Nota Credito</div>' +
                            '<div class="w2ui-group" style="height: 185px;">' +

		                        '<div class="w2ui-label">Nº Nota Credito:</div>' +
		                        '<div class="w2ui-field w2ui-required">' +
			                        '<input name="numeroNC" id="numeroNC" type="text" maxlength="10" size="20" disabled/>' +
		                        '</div>' +

                /* no se muestra guarda la ID_ChileCompra*/
                                '<div class="w2ui-label" style="display: none;">ID ChileCompra:</div>' +
		                        '<div class="w2ui-field w2ui-required"  style="display: none;">' +
			                        '<input name="IDChileCompraNC" id="IDChileCompraNC" type="text" maxlength="10" size="20" disabled/>' +
		                        '</div>' +

		                        '<div class="w2ui-label">Periodo:</div>' +
		                        '<div class="w2ui-field">' +
                                    '<input name="periodoNC" id="periodoNC" type="text" maxlength="10" size="20" disabled/>' +
		                        '</div>' +

                                '<div class="w2ui-label">Nº OC:</div>' +
		                        '<div class="w2ui-field">' +
			                        '<input name="numeroOCNC" id="numeroOCNC" type="text" maxlength="10" size="20" disabled/>' +
		                        '</div>' +

                                '<div class="w2ui-label">Monto:</div>' +
		                        '<div class="w2ui-field w2ui-required">' +
			                        '<input name="montoNC" id="montoNC" type="text" maxlength="10" size="20"  disabled="disabled" onkeypress="return justNumber(event);"/>' +
		                        '</div>' +

                            '</div>' +
                          '</div>' +

                /* Grupo Proveedor */
						'<div style="width: 360px; float: right; margin-left: 0px;">' +
							'<div style="padding: 3px; font-weight: bold; color: #777;">Proveedor</div>' +
							'<div class="w2ui-group" style="height: 185px;">' +

		                        '<div class="w2ui-label">Nombre:</div>' +
		                        '<div class="w2ui-field">' +
			                        '<input name="nombreProvNC" id="nombreProvNC" type="text" maxlength="40" size="26" disabled/>' +
		                        '</div>' +

		                        '<div class="w2ui-label">Rut:</div>' +
		                        '<div class="w2ui-field">' +
			                        '<input name="rutProvNC" id="rutProvNC" type="text" maxlength="10" size="20" disabled/>' +
		                        '</div>' +

                                '<div class="w2ui-label">Nº Factura:</div>' +
		                        '<div class="w2ui-field">' +
			                        '<input name="numeroFacNC" id="numeroFacNC" type="text" maxlength="10" size="20" disabled/>' +
		                        '</div>' +

                                '<div class="w2ui-label">Fecha Factura:</div>' +
		                        '<div class="w2ui-field w2ui-required">' +
                                '<input name="fechaFactNC" id="fechaFactNC" type="text" maxlength="10" size="20" onkeypress="return justFecha(event);"/>' +
		                        '</div>' +

							'</div>' +
						'</div>' +

                /* Grupo Bodega */
						'<div style="clear: both; padding-top: 15px;">' +
							'<div style="padding: 3px; font-weight: bold; color: #777;">Bodega</div>' +
                            '<div class="w2ui-group">' +

                                '<div class="w2ui-label">Nombre Solicitante:</div>' +
		                        '<div class="w2ui-field">' +
			                        '<input name="nombreSolicitanteNC" id="nombreSolicitanteNC" type="text" maxlength="10" size="20" disabled/>' +
		                        '</div>' +

                                '<div class="w2ui-label">Fecha:</div>' +
		                        '<div class="w2ui-field">' +
			                        '<input name="fechaActualNC" id="fechaActualNC" type="text" maxlength="10" size="20" disabled/>' +
		                        '</div>' +

                                '<div class="w2ui-label">Bodega:</div>' +
				                '<div class="w2ui-field">' +
					                '<input name="codBodegaNC" id="codBodegaNC" type="text" maxlength="50" style="width: 70px; margin-right: 2px;" disabled="disabled"/>' +
                                    '-' +
					                '<input name="nombreBodegaNC" id="nombreBodegaNC" type="text" style="width: 160px; margin-left: 2px;" disabled="disabled"/>' +
				                '</div>' +

                            '<div class="w2ui-label">Motivo:</div>' +
							'<div class="w2ui-field w2ui-required">' +
									'<textarea name="motivoNC" id="motivoNC" type="text" style="width: 78%; height: 80px; resize: none" id="description" ></textarea>' +
							'</div>' +

                            '</div>' +
						'</div>' +

                        '</div>' + // fin
                        '<div class="w2ui-buttons">' +
		                    '<input type="button" value="Grabar Nota" name="SaveNC" style="width: 88px; border-color: tomato;">' +
		                    '<input type="button" value="Imprimir" name="ImprimirNC" style="margin-left: 2%;">' +
	                    '</div>',
                fields: [
                    { field: 'numeroNC', type: 'int', required: true },
                    { field: 'periodoNC', type: 'text' },
                    { field: 'numeroOCNC', type: 'text' },
                    { field: 'IDChileCompraNC', type: 'text' },
                    { field: 'montoNC', type: 'int', required: true },
                    { field: 'nombreProvNC', type: 'text' },
                    { field: 'rutProvNC', type: 'text' },
                    { field: 'numeroFacNC', type: 'text' },
                    { field: 'fechaFactNC', type: 'text' },
                    { field: 'nombreSolicitanteNC', type: 'text' },
                    { field: 'fechaActualNC', type: 'text', required: true },
                    { field: 'codBodegaNC', type: 'text' },
                    { field: 'nombreBodegaNC', type: 'text' },
                    { field: 'motivoNC', type: 'text', required: true }
                ],
                actions: {
                    /* saveNota */
                    SaveNC: function () {

                        /* Luego de crear la Nota de Credito se llama al save para guardar la transacción */
                        var validaMotivoNC = 0;
                        var validaFechaFactura = 0;

                        if ($("#fechaFactNC").val() == '') {
                            validaFechaFactura = 1;
                        }

                        if ($("#motivoNC").val() == '') {
                            validaMotivoNC = 1;
                        }

                        if (validaFechaFactura == 0 && validaMotivoNC == 0) {

                            var montoMOVNC = parseInt($('#precioFactura').val()) - parseInt($('#precioNeto').val());

                            $.ajax({
                                url: '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getData_NotaCreditoPopUp.ashx',
                                type: 'POST',
                                dataType: "json",
                                data: { cmd: 'save-NC', periodoNC: $("#periodoNC").val(), numeroOCNC: $("#numeroOCNC").val(), IDChileCompraNC: $("#IDChileCompraNC").val(), montoNC: montoMOVNC, rutProvNC: $("#rutProvNC").val(), numeroFacNC: $("#numeroFacNC").val(), fechaFactNC: $("#fechaFactNC").val(), rutUserNC: rut, codBodegaNC: $("#codBodegaNC").val(), fechaActualNC: $("#fechaActualNC").val(), motivoNC: $("#motivoNC").val() },
                                success: function (response) {
                                    if (response.status == 'error') {
                                        w2alert(response.message);
                                    } else {

                                        w2ui['form'].record['nroNotaCredito'] = response.cmvNumero;
                                        w2ui['form'].refresh();

                                        $("#numeroNC").val(response.cmvNumero);

                                        /* Se cierra el Popup */
                                        w2popup.close();

                                        /* si termina bien graba la recepción grobal, al terminar pregunta si se envia por email */
                                        w2ui['grid'].save();   // se saca mientras probando nota credito

                                    }
                                },
                                error: function (response) {
                                    alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                }
                            });
                        } else {

                            if (validaFechaFactura == 1 && validaMotivoNC == 1) {
                                w2alert('Ingrese Todos los datos solicitados.');
                            } else {

                                if (validaFechaFactura == 1) {
                                    w2alert("<b>Faltan Datos!</b><p>Ingrese la fecha de la factura.", "¡Alerta!", function (answer) {
                                        $("#fechaFactNC").focus();
                                    });
                                } else {
                                    w2alert("<b>Faltan Datos!</b><p>Ingrese el motivo de la nota de credito.", "¡Alerta!", function (answer) {
                                        $("#fechaFactNC").focus();
                                    });
                                }

                            }
                        }
                    },
                    ImprimirNC: function () {

                        if ($("#numeroNC").val() == '') {
                            alert('Primero guarde la NOTA DE CREDITO. Ingrese los datos solicitados y presione "Grabar Nota".');
                        } else {

                            var nameDescarga = $('#nombreProvNC').val();

                            if (nameDescarga.length > 18) {
                                nameDescarga = nameDescarga.substring(0, 18);
                            }

                            nameDescarga = 'NC_' + nameDescarga + '_FACTURA_' + $('#numeroFacNC').val();

                            window.open('../../reportes/Recepciones/DesdeProveedores/NotCredito/Rpt_RecepDP_NCReport.aspx?numeroNC=' + $("#numeroNC").val() + '&periodoNC=' + $("#periodoNC").val() + '&numeroOCNC=' + $("#numeroOCNC").val() + '&numeroFacNC=' + $("#numeroFacNC").val() + '&nombreReport=' + nameDescarga);
                        }

                    } // fin imprimirNC
                    
                }
            }


        }
    </script>
    <!-- Inicializacion en memoria de elementos w2ui para popUps -->
    <script type="text/javascript">
        $(function () {
            // initialization in memory
            /*    Public fechaServidor As String
            Public anioDonacion As String*/
            $().w2layout(config.layout);
            $().w2grid(config.grid1);
            $().w2form(config.form1);
            $().w2layout(config.layout1);
            $().w2grid(config.grid2);
            $().w2form(config.form2);

            /* para nota credito*/
            $().w2layout(config.layout2);
            $().w2grid(config.grid3);
            $().w2form(config.form3);

        });
    </script>
    <!-- instancia de abertura de pop up para busqueda por orden de compra -->
    <script type="text/javascript">
        function openPopup() {
            w2popup.open({
                title: 'Busqueda de Ordenes de Compra',
                width: 1100,
                height: 600,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                modal: true,
                onOpen: function (event) {
                    event.onComplete = function () {
                        $('#w2ui-popup #main').w2render('layout');
                        w2ui.layout.content('left', w2ui.gridBOC);
                        w2ui.layout.content('main', w2ui.formBOC);
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
    <!-- instancia de abertura de pop up para busqueda por Recepcion -->
    <script type="text/javascript">
        function openPopup1() {
            w2popup.open({
                title: 'Busqueda de Recepciones',
                width: 1200,
                height: 600,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                modal: true,
                onOpen: function (event) {
                    event.onComplete = function () {
                        $('#w2ui-popup #main').w2render('layout1');
                        w2ui.layout1.content('left', w2ui.gridBRECEP);
                        w2ui.layout1.content('main', w2ui.formBRECEP);

                        $('#xordencompraBRECEP').prop('type', 'radio');
                        $('#xrecepcionBRECEP').prop('type', 'radio');
                    };
                },
                onMax: function (event) {
                    event.onComplete = function () {
                        w2ui.layout1.resize();
                    }
                },
                onMin: function (event) {
                    event.onComplete = function () {
                        w2ui.layout1.resize();
                    }
                }
            });
        }
    </script>
       
    <!-- Metodo de carga de datos para recepcion -->
    <script type="text/javascript">

        //w2ui Grid de materiales de recepcion
        $('#grid').w2grid({
            name: 'grid',
            header: 'Lista de Materiales',
            show: {
                toolbar: true,
                footer: true,
                toolbarAdd: false,
                toolbarDelete: false,
                toolbarSave: false,
                toolbarEdit: false,
                toolbarSearch: false
            },
            fixedBody: true,
            multiSearch: false,
            searches: [

			        { type: 'text', field: 'recid', caption: 'Codigo Material' },
			        { type: 'text', field: 'nombreMaterial', caption: 'Nombre Material' },
			        { type: 'int', field: 'cantidadARecibir', caption: 'A Recibir' }
		        ],
            columns: [
                    { field: 'iteCodigo', caption: 'Codigo Item', hidden: true },
			        { field: 'recid', caption: 'Codigo Material', size: '16%', style: 'text-align:center' },
			        { field: 'nombreMaterial', caption: 'Nombre Material', size: '50%', style: 'text-align:center' },
			        { field: 'unidad', caption: 'Unidad de Medida', size: '17%', style: 'text-align:center' },
			        { field: 'cantidadARecibir', caption: 'A Recibir', size: '10%', style: 'text-align:center' },
			        { field: 'factor', caption: 'Factor', size: '8%', editable: { type: 'int' }, style: 'text-align:center' },
			        { field: 'cantidad', caption: 'Cantidad', size: '10%', style: 'text-align:center' },
			        { field: 'valor', caption: 'Precio Unitario', size: '20%', style: 'text-align:center' },
			        { field: 'recepcionFactura', caption: 'Recep x Factura', size: '16%', editable: { type: 'int' }, style: 'text-align:center' },
			        { field: 'recepcionado', caption: 'Recepcionado', size: '14%', style: 'text-align:center' },
			        { field: 'total', caption: 'Total', size: '20%', style: 'text-align:center' }
		        ],
            onReload: function (event) {
                /* reloadGrid */
                reload = 1;
                w2ui['grid'].url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getMateriales.ashx?idoc=' + numeroOC + '&periodoOC=' + periodo + '&reload=' + reload + '&snIva=' + ivaSN + '&userName=' + userName;
            },
            onSearch: function (event) {
                reload = 1;
                w2ui['grid'].url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getMateriales.ashx?idoc=' + numeroOC + '&periodoOC=' + periodo + '&reload=' + reload + '&snIva=' + ivaSN + '&userName=' + userName;
            },
            onChange: function (event) {
                if (event.column == 5) {
                    if (event.value_new > 0) {
                        this.request('update-factorFactura', [{ 'matCodigo': event.recid }, { 'factor': event.value_new }, { 'factura': this.records[this.last.sel_ind].recepcionFactura}]);
                        this.requestComplete('update-factorFactura', 'success', function () {
                            w2ui['grid'].reload();
                        });
                    } else {
                        w2alert('Debe ingresar valores superiores a "0" para el factor!!');
                    }
                }
                if (event.column == 8) {
                    if (event.value_new > 0) {
                        var valfactura = event.value_new;
                        w2ui['grid'].reload();
                        this.request('update-factorFactura', [{ 'matCodigo': event.recid }, { 'factor': this.records[this.last.sel_ind].factor }, { 'factura': valfactura}]);
                        this.requestComplete('update-factorFactura', 'success', function () {
                            w2ui['grid'].reload();
                        });

                    } else {
                        alert('Debe ingresar un número de factura válido!!');
                    }
                }
            },
            /* saveGrid */
            onSave: function (event) {
                event.preventDefault();

                var valorRecp = $('#nroRecepcion').val();
                var estadoRecep = $('#estado').val();
                var updateSN = 0;

                if (valorRecp != '0' && (estadoRecep == 'RECEPCIONADA TOTALMENTE')) {
                    this.request('update-records', [{ 'materiales': this.records }, { 'dataOrdenC': w2ui['form'].record }, { 'dataRecep': w2ui['formFooter'].record }, { 'usuario': userName }, { 'largoGrid': this.records.length}]);
                    this.requestComplete('success', 'update-records', function () {
                        w2alert('Se actualizó la recepcion con exito!!');
                        fechaRecepcion = $('#fechaRecepcion').val();

                    });
                } else {
                    var bodega = $('#codigoBodega').val();
                    var nroDocRecep = $('#nroDocumento').val();
                    var totalOC = $('#totalOCompra').val();
                    var nroOc = $('#numeroOC').val();
                    fechaRecepcion = $('#fechaRecepcion').val();

                    var precioNetoTemp = $("#precioNeto").val()
                    var descuentoTemp = $("#descuento").val()
                    var ivaTemp = $("#ivaTotal").val()
                    var totalRecepTemp = $("#totalRecepcion").val()
                    var totalOCTemp = $("#totalOCompra").val()

                    if (bodega != "" && nroDocRecep != "" && nroDocRecep != "0" && totalOC != "0" && totalOC != "") {
                        $.ajax({
                            url: '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getMateriales.ashx?',
                            type: 'POST',
                            dataType: "json",
                            data: { cmd: 'create-records', materiales: this.records, dataOrdenC: w2ui['form'].record, dataRecep: w2ui['formFooter'].record, usuario: userName, largoGrid: this.records.length, numeroOC: numeroOC, reload: reload, precioNetoTemp: precioNetoTemp, descuentoTemp: descuentoTemp, ivaTemp: ivaTemp, totalRecepTemp: totalRecepTemp, totalOCTemp: totalOCTemp },
                            success: function (response) {
                                if (response.status == 'error') {
                                    w2alert(response.message);
                                } else {

                                    $('#bodegaRecepcion').prop('disabled', true);
                                    $('#tipo_documento').prop('disabled', true);
                                    $('#nroDocumento').prop('disabled', true);
                                    $('#ivaSN').prop('disabled', true);
                                    $('#difpeso').prop('disabled', true);
                                    periodoRecep = response.periodo;
                                    tmvCodigo = response.tmvCodigo;
                                    nroRecepcion = response.cmvNumero;
                                    idChileCompra = $('#chileCompra').val();
                                    nombreProveedor = $('#proveedor').val();
                                    $('#nroRecepcion').val(response.cmvNumero);

                                    var NRecep = response.cmvNumero;
                                    var PeriodoRecep = w2ui['form'].record['periodo'];

                                    /* Reload data Grid */
                                    setTimeout(function () {
                                        w2ui.grid.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getMateriales.ashx?cmd=' + 'mat-Movimiento' + '&numRecepcion=' + NRecep + '&periodo=' + PeriodoRecep + '&reload=' + '3';
                                        w2ui.grid.reload();
                                    }, 100);

                                    w2alert('¡Se creo la recepción ' + response.cmvNumero + ' con éxito!');
                                    //reload = 0;
                                    //DatosValidos();
                                }
                            },
                            error: function (response) {
                                alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                            }
                        });
                    } else {
                        alert('Faltan Datos!. Asegure el haber Completado todos los campos.');
                    }
                } // fin RECEPCIONADA TOTALMENTE.

            },
            onLoad: function (event) {
                /* Actualizacion de campos en carga de GRID */
                event.onComplete = function () {
                    if (reload == 1) {

                        var precioNeto = 0.0;
                        var ivaTotal = 0.0;
                        var descuento = 0.0;
                        var impuesto = 0.0;
                        var totalRecep = 0.0;
                        var totalOC = 0.0;
                        /* siempre debe indircar iva */
                        var ivaChecked = $("#ivaSN")[0].checked;

                        if (!ivaChecked) {
                            $("#ivaSN").prop('checked', true)
                        }

                        for (i = 0; i <= this.records.length - 1; i++) {
                            var tempPrecioNeto = parseFloat(this.records[i].total.substring(1));
                            var tempIvaTotal = parseFloat(this.records[i].total.substring(1));
                            var tempTotalRecep = parseFloat(this.records[i].total.substring(1));

                            /* guarda suma del footer */
                            precioNeto = precioNeto + tempPrecioNeto;
                            ivaTotal = ivaTotal + (Math.round(tempIvaTotal * 0.19));

                            /* calcula la suma local para el total recepcionado */
                            tempPrecioNeto = tempPrecioNeto;
                            tempIvaTotal = Math.round(tempIvaTotal * 0.19);
                            totalRecep = totalRecep + (tempPrecioNeto + tempIvaTotal);
                        }

                        /* cambia el valor parcial del grid */
                        $("#totalRecepcionado").val(formatoNumero(Math.round(totalRecep)));

                        /* primero le sacamos el formato */
                        var totalOCTemp = quitaPunto($("#precio").val());
                        totalOCTemp = Math.round(parseFloat(totalOCTemp) * 1.19);

                        /* despues de calculado, reaparece el formato numerico */
                        totalOCTemp = formatoNumero(totalOCTemp);
                        var netoTemp = formatoNumero(precioNeto);
                        var ivaTemp = formatoNumero(ivaTotal);
                        var totalRecep = formatoNumero(totalRecep);
                        var descuentoTemp = formatoNumero($('#descuento').val());

                        w2ui['formFooter'].record = {
                            precioNeto: netoTemp,
                            ivaTotal: ivaTemp,
                            totalRecepcion: totalRecep,
                            totalOCompra: totalOCTemp,
                            //totalRecepcionado: totalRecep.toFixed(2),  // este valor no esta en el footer
                            descuento: descuentoTemp,
                            impuesto: 0,
                            difpeso: $('#difpeso').val()
                        }
                        w2ui['formFooter'].refresh();

                    }

                }
            },
            onExpand: function (event) {
                //creacion de Grid para Detalle de los Materiales
                var estadoRecep = $('#estado').val().toString();
                if (estadoRecep != 'RECEPCIONADA TOTALMENTE') {
                    var valorRecp = $('#nroRecepcion').val();
                    var periodoOC = $('#periodo').val();
                    var codMatrial = $.trim(event.recid);
                    var subGridName = 'subgrid-' + $.trim(event.recid);
                    if (w2ui.hasOwnProperty('subgrid-' + $.trim(event.recid))) w2ui['subgrid-' + $.trim(event.recid)].destroy();
                    $('#' + event.box_id).css({ margin: '0px', padding: '0px', width: '100%' }).animate({ height: '178px' }, 100);
                    setTimeout(function () {
                        $('#' + event.box_id).w2grid({
                            name: 'subgrid-' + $.trim(event.recid),
                            url: '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDetalleMaterial.ashx?idoc=' + numeroOC + '&periodoOC=' + periodo + '&codigoMaterial=' + codMatrial + '&periodo=' + periodoOC + '&nroRecepcion' + valorRecp,
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
                                    { field: 'codigoMaterial', caption: 'Codigo Material', size: '10%', hidden: true, style: 'text-align:center' },
						            { field: 'cantidad', caption: 'Cantidad', size: '20%', editable: { type: 'int' }, style: 'text-align:center' },
						            { field: 'loteSerie', caption: 'Nro Lote', size: '30%', editable: { type: 'alphanumeric' }, style: 'text-align:center' },
						            { field: 'fechaVencimiento', caption: 'Fecha Vencimiento', size: '50%', editable: { type: 'date', format: 'mm-dd-yy'} }
					            ],
                            onAdd: function (event) {
                                var todayDate = new Date();
                                var day = todayDate.getDate();
                                var month = todayDate.getMonth() + 1;
                                var year = todayDate.getFullYear();
                                w2ui[subGridName].add({ recid: (this.records[this.total - 1].recid + 1), cantidad: 0, loteSerie: '0', fechaVencimiento: (day + '/' + month + '/' + year) });
                                w2ui[subGridName].total = w2ui[subGridName].total + 1;
                            },
                            onChange: function (event) {

                                /*eventos de cambio para grid principal*/
                                if (event.column == 2) {

                                    //var tmvCodigo = '1'
                                    //var percodigo = 
                                    //var codMov = nroRecepcion
                                    var codBodega = $('#bodegaRecepcion').val();
                                    var matCod = codMatrial;
                                    var Nserie = event.value_new;

                                    if (event.value_new != '0' && event.value_new != '') {

                                        setTimeout(function () {
                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/validaDetalleMaterial.ashx",
                                                async: false,
                                                data: { "cmd": 'validaNserie', "Bodega": codBodega, "codMaterial": matCod, "Nserie": Nserie.toUpperCase() },
                                                dataType: "json",
                                                success: function (response) {
                                                    if (response.validate == "1") {
                                                        w2ui[subGridName].set(event.recid, { loteSerie: '0' });
                                                        w2ui[subGridName].set(event.recid, { changes: { loteSerie: '0'} });
                                                        w2ui[subGridName].refresh();
                                                        w2alert('Nº Serie no disponible');
                                                    } else {
                                                        // Se puede agregar
                                                    }
                                                },
                                                error: function (response) {
                                                    alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                                }
                                            });
                                        }, 100);

                                    } else {
                                        alert('Debe ingresar un valor de serie válido!!');
                                    }
                                }

                                if (event.column == 3) {

                                    if (this.records[event.recid - 1].changes.cantidad > 0) {
                                        if (this.records[event.recid - 1].changes.loteSerie != '0' && this.records[event.recid - 1].changes.loteSerie != '' && this.records[event.recid - 1].changes.loteSerie != 'undefined') {

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

                                                if (dia <= 31 && dia > 0 && mes <= 12 && mes > 0 && anio >= 1900 && anio <= 2050) {
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
                            /* saveExpand, saveDetalle */
                            onSave: function (event) {
                                event.preventDefault();

                                var sumaCantidad = 0;
                                var cantidadRecibir = 0;
                                var position = 0;
                                var DetalleCero = 0;
                                for (i = 0; i < this.records.length; i++) {
                                    if (this.records[i].changed) {
                                        if (this.records[i].changes.cantidad != 'undefined') {
                                            sumaCantidad = sumaCantidad + parseInt(this.records[i].changes.cantidad);
                                            position = i;
                                        }
                                    } else {
                                        if (this.records[i].cantidad == '0') {
                                            DetalleCero = 1;
                                        }
                                        sumaCantidad = sumaCantidad + parseInt(this.records[i].cantidad);
                                    }
                                }
                                for (i = 0; i < w2ui['grid'].records.length; i++) {
                                    var MaterialRecid = w2ui['grid'].records[i].recid;
                                    if (MaterialRecid == codMatrial) {
                                        cantidadRecibir = parseInt(w2ui['grid'].records[i].cantidadARecibir);
                                        break;
                                    }
                                }
                                if (cantidadRecibir >= sumaCantidad && DetalleCero == 0) {
                                    w2ui[subGridName].request("save-records", this.records, '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDetalleMaterial.ashx?idoc=' + numeroOC + '&largoGrid=' + this.records.length + '&codigoMaterial=' + codMatrial + '&periodo=' + periodoOC);
                                    w2ui[subGridName].requestComplete('success', 'save-records', function (evento) {
                                        w2alert('Detalle Ingresado con Exito!! :)');
                                        reload = 1;
                                        w2ui['grid'].url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getMateriales.ashx?idoc=' + numeroOC + '&reload=' + reload + '&snIva=' + ivaSN + '&userName=' + userName;
                                        w2ui['grid'].reload();
                                    });
                                } else {
                                    this.reload();
                                    w2alert('La cantidad de materiales ingresados NO puede ser 0 y tampoco MAYOR a la cantidad a recibir,  por favor verifique esta información y vuelva a intentarlo.');
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
                        w2ui.grid.resize();
                    }, 300);
                } else {
                    w2alert('NO puede MODIFICAR los materiales de las recepciones TOTALMENTE completadas.');
                }
            }
        });

        /* w2ui Form de datos orden de compra parea recepcion */
        $('#form').w2form({
            name: 'form',
            recid: 10,
            url: '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getFechaServidor.ashx',
            style: 'border: 0px; background-color: #f5f6f7; height: 514px;',
            formHTML:
		            '<div class="w2ui-page page-0">' +
                    '   <div class="col-lg-6">' +
			        '       <div class="w2ui-group" style="margin-bottom: 0;">' +


                    '           <div class="group col-12" style="height: 35px;">' +
                    '               <div class="col-6">' +

		            '	                <div class="w2ui-label w2ui-span3" style="text-align: left; width: 94px; margin-left: 56px;">Nº O. Compra:</div>' +
		            '                       <div class="w2ui-field w2ui-span3" style="margin-top: -2px;">' +
		            '   		                <input name="numeroOC" class="form-control" style="width: 90px;" type="text" size="35"/>' +
		            '           	        </div>' +

                    '           	</div>' +

                    '               <div class="col-6">' +


		            '	            <div class="w2ui-label w2ui-span3" style="text-align: left; width: 104px; margin-left: -18px;">Nueva Recepción:</div>' +
		            '	            <div class="w2ui-field w2ui-span4" >' +
		            '		            <input name="newIngreso" id="newIngreso" class="form-control" type=checkbox style="margin-left: 4px; margin-top: 3px;"/>' +
		            '	            </div>' +

                    '               </div>' +

                    '           </div>' +


		            '	        <div class="w2ui-label w2ui-span7">Estado:</div>' +
		            '	        <div class="w2ui-field w2ui-span7">' +
		            '		        <input name="estado" class="form-control" style="width: 198px;" type="text" size="35" disabled/>' +
		            '	        </div>' +
		            '	        <div class="w2ui-label w2ui-span7">ID Chile Compra:</div>' +
		            '	        <div class="w2ui-field w2ui-span7">' +
		            '		        <input name="chileCompra" class="form-control" style="width: 198px;" type="text" size="35" disabled/>' +
		            '	        </div>' +
		            '	        <div class="w2ui-field w2ui-span7" style="left: 10px; display: none;">' +
		            '		        <input name="fechaRecepcion" type="text" style="width: 138px;" size="35"/>' +
		            '	        </div>' +
                    '       </div>' +
                    '   </div>' +
                    '   <div class="col-lg-6">' +
			        '       <div class="w2ui-group" style="height: 118px;">' +
		            '	        <div class="w2ui-label w2ui-span7" style="width: 140px; margin-right: 10px;">Periodo O.C:</div>' +
                    '           <div class="w2ui-field" style="left: 10px;">' +
		            '		        <input name="periodo" type="text" style="width: 138px;" size="35" disabled/>' +
		            '	        </div>' +
		            '	        <div class="w2ui-field w2ui-span7" style="left: 10px; display: none;">' +
		            '		        <input name="codigoBodega" type="text" style="width: 138px;" size="35"/>' +
		            '	        </div>' +
		            '	        <div class="w2ui-label w2ui-span7" style="width: 140px; margin-right: 10px;">Bodega Recepción:</div>' +
		            '	        <div class="w2ui-field w2ui-span7" style="left: 10px;">' +
		            '		        <select name="bodegaRecepcion" class="form-control" style="width: 251px;"  id="bodegaRecep" type="text"/>' +
		            '	        </div>' +
		            '	        <div class="w2ui-label w2ui-span7" style="width: 140px;">Tipo de Documento:</div>' +
		            '	        <div class="w2ui-field w2ui-span7" style="margin-left: 147px !important;">' +
		            '		        <select name="tipo_documento" class="form-control" type="text" style="width: 138px;" />' +
		            '	        </div>' +
                    '       </div>' +
                    '   </div>' +
                    '   <div class="col-lg-6">' +
			        '       <div class="w2ui-group">' +
                    '	        <div class="w2ui-label w2ui-span7">Proveedor:</div>' +
		            '	        <div class="w2ui-field w2ui-span7">' +
		            '		        <input name="proveedor" class="form-control" style="width: 251px;" type="text" size="35" disabled/>' +
		            '	        </div>' +
		            '	        <div class="w2ui-label w2ui-span7">Número Recepcion:</div>' +
		            '	        <div class="w2ui-field w2ui-span7">' +
		            '		        <input name="nroRecepcion" class="form-control" style="width: 138px;" type="text" size="35" disabled/>' +
		            '	        </div>' +
                    '           <div class="w2ui-label w2ui-span7" style="width: 140px;">Número del Documento:</div>' +
		            '	        <div class="w2ui-field w2ui-span7" >' +
		            '		        <input name="nroDocumento" class="form-control" style="width: 138px;" id="nroDocumento" type="text" size="35"/>' +
		            '	        </div>' +
                    '       </div>' +
                    '   </div>' +
                    '   <div class="col-lg-6">' +
			        '       <div class="w2ui-group" style="height: 118px;">' +
		            '	        <div class="w2ui-label w2ui-span7">IVA:</div>' +
		            '	        <div class="w2ui-field w2ui-span7">' +
		            '		        <input name="ivaSN" id="ivaSN" class="form-control" type=checkbox size="35"/>' +
		            '	        </div>' +
		            '	        <div class="w2ui-label w2ui-span7">Valor O/C:</div>' +
		            '	        <div class="w2ui-field input-group w2ui-span7">' +
                    '               <span class="input-group-addon" style="width: 12px;">$</span>' +
		            '		        <input name="precio" type="text" class="form-control" style="width: 138px;" disabled/>' +
		            '	        </div>' +
		            '	        <div class="w2ui-label w2ui-span7">Total Acumuldado:</div>' +
		            '	        <div class="w2ui-field input-group w2ui-span7">' +
                    '               <span class="input-group-addon" style="width: 12px;">$</span>' +
		            '		        <input name="totalRecepcionado" type="text" class="form-control" style="width: 138px;" disabled/>' +
		            '	        </div>' +
                    '       </div>' +
                    '   </div>' +

                    '<div style="padding: 3px; font-weight: bold; color: #777;">Observaciones</div>' +

            /* IZQ lado nuevo */
                    '   <div class="col-lg-6">' +
	                '     <div class="w2ui-group">' +
                    '	        <div class="w2ui-label w2ui-span7" style="width: 200px; margin-left: 162px;">OBSERVACIÓN DE LA RECEPCIÓN:</div>' +
		            '	        <div class="w2ui-field w2ui-span7">' +
		            '               <textarea name="observacionRecp" class="form-control" type="text" style="width: 385px; height: 42px; resize: none; margin-left: -18%;"></textarea>' +
		            '	        </div>' +

                    '      <div class="group" style="height: 41px;">' +
                    '         <div class="col-7">' +

                    '           <div class="w2ui-label w2ui-span3" style="width: 132px; text-align: left; margin-top: 18px; margin-left: 10%;">Valor Factura (NETO):</div>' +
		            '           	<div class="w2ui-field w2ui-span3 input-group w2ui-required" style=" margin-top: 8px; ">' +
                    '                  <span class="input-group-addon" style="width: 12px;">$</span>' +
		            '           		    <input name="precioFactura" class="form-control" style="width: 124px;" type="text" size="35" onkeypress="return just_precioFactura(event);"/>' +
		            '           	</div>' +
                    '         </div>' +

                    '         <div class="col-4">' +

		            '	        <div class="w2ui-label w2ui-span3" style="text-align: left; width: 104px; margin-top: 18px; ">Nº Nota Credito:</div>' +
		            '	        <div class="w2ui-field w2ui-span3" style="margin-top: 8px;">' +
		            '		        <input name="nroNotaCredito" id="nroNotaCredito" class="form-control" style="width: 60px;" type="text" disabled/>' +
		            '	      </div>' +
                    '     </div>' +

                    '   </div>' +

                    '   </div>' +
                    '   </div>' +

            /* DER lado nuevo */
                    '   <div class="col-lg-6">' +
			        '       <div class="w2ui-group" style="height: 140px;">' +
                    '           <div class="w2ui-label col-lg-6" style="width: 365px;">OBSERVACIÓN DE LA ORDEN DE COMPRA:</div>' +
		            '           <div class="w2ui-field input-group col-lg-5" style="margin-left: 54px;">' +
			        '               <textarea name="descripcion" class="form-control" type="text" style="width: 385px; height: 54px; resize: none; margin-top: -4px;" disabled></textarea>' +
		            '           </div>' +

            // grupo ajuste
                    '       <div class="group" style="height: 41px;">' +
                    '           <div class="col-4" style="margin-left: 18px;">' +

                    '               <div class="w2ui-label w2ui-span3" style="width: 116px; text-align: left; margin-top: 14px; margin-left: 42px;">Ajuste de Valores:</div>' +
		            '	            <div class="w2ui-field w2ui-span4" >' +
		            '		                <input name="ajusteValor" id="ajusteValor" class="form-control" type=checkbox style="margin-left: 4px; margin-top: 11px;"/>' +
		            '               </div>' +
                    '           </div>' +

                    '           <div class="col-5" id="diplayAjuste" style="display:none;">' +

		            '	            <div class="w2ui-label w2ui-span2" style="text-align: left; width: 44px; margin-top: 14px; margin-left: 16px;">Valor:</div>' +
		            '	            <div class="w2ui-field w2ui-span2 input-group w2ui-required" style="margin-top: 4px; ">' +
                    '                   <span class="input-group-addon" style="width: 12px;">$</span>' +
		            '		            <input name="valorAjuste" id="valorAjuste" class="form-control" style="width: 112px;" type="text"/>' +
		            '	            </div>' +
                    '           </div>' +

                    '       </div>' +
                    '   </div>' +



                    '   </div>' +

                    '</div>' +
                    '<div class="w2ui-buttons">' +
                    '   <input type="button" value="NC" name="notaCredito" style="width: 130px; display:none"/>' +  /* boton temp nota credito */
			        '   <input type="button" value="Buscar O.Compra" name="BuscarOC" style="width: 130px;"/>' +
                    '   <input type="button" value="Buscar Recepción" name="BuscarRecep" style="width: 130px;"/>' +
			        '   <input type="button" value="Guardar" name="saveForm" style="width: 130px; border-color: cornflowerblue;">' +
                    '   </input>' +
			        '   <input type="button" value="Imprimir QRs" name="Imprimir" style="width: 130px;"/>' +
			        '   <input type="button" value="Imprimir Recepción" name="ImprimirRecep" style="width: 130px;"/>' +
                    '   <input type="button" value="Limpiar" name="Limpiar" style="width: 130px;"/>' +
                    '   <input type="button" value="Imprimir Nota" name="ImprimirNotaCredito" style="width: 130px;"/>' +
                    '   <input type="button" value="test" name="btest" style="width: 130px; display:none" />' +
		            ' </div>',
            fields: [
                    { name: 'numeroOC', type: 'int' },
		            { name: 'codigoBodega', type: 'text' },
		            { name: 'estado', type: 'text' },
		            { name: 'nroRecepcion', type: 'text', required: true },
		            { name: 'proveedor', type: 'text' },
                    { name: 'nroDocumento', type: 'text', required: true },
		            { name: 'bodegaRecepcion', type: 'list',
		                options: { url: '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getListaBodegas.ashx?idoc=' + numeroOC + '&periodoOC=' + periodo + '&userName=' + userName + '&nombre=' + nombre + '&rut=' + rut + '&tipo=' + tipo + '&centroCosto=' + centroCosto, showNone: false, value: 'BOD006' }
		            },
		            { name: 'tipo_documento', type: 'list',
		                options: { items: [{ id: 'FACTURA', text: 'FACTURA' }, { id: 'BOLETA', text: 'BOLETA' }, { id: 'GUIA', text: 'GUIA' }, { id: 'OTRO', text: 'OTRO'}], showNone: false }
		            },
		            { name: 'ivaSN', type: 'checkbox' },
		            { name: 'precio', type: 'text' },
		            { name: 'totalRecepcionado', type: 'text' },
		            { name: 'descripcion', type: 'text' },
                    { name: 'periodo', type: 'text' },
		            { name: 'observacionRecp', type: 'text' },
                    { name: 'chileCompra', type: 'text' },
                    { name: 'fechaRecepcion', type: 'text' },
                    { name: 'precioFactura', type: 'text', required: true },     // nuevo para valor factura.
                    {name: 'newIngreso', type: 'checkbox' },                    // para limpiar e ingresar una nueva recepción.
                    {name: 'nroNotaCredito', type: 'text' },                    // almacena el numero de la nota de credito si existe.
                    {name: 'ajusteValor', type: 'checkbox' },                    // Ajuste de valor para descuento interno.
                    {name: 'valorAjuste', type: 'int'}                          // valo de ajuste
	            ],
            onChange: function (event) {

                /* Cambia el formato del valor factura. */
                if (event.target == "precioFactura") {
                    $("#precioFactura").val(formatoNumero($("#precioFactura").val()));
                }

                /* Agregar cambio buscador instantaneo. */
                if (event.target == "numeroOC") {
                    nroOc_Fast = $('#numeroOC').val();
                    setTimeout(function () {
                        validarBodega_Fast();
                    }, 600);
                }

                if (event.target == "ivaSN") {
                    if (this.fields[8].el.checked) {
                        this.fields[9].el.value = (parseFloat(this.fields[9].el.value) * iva).toFixed(2);
                        this.fields[10].el.value = (parseFloat(this.fields[10].el.value) * iva).toFixed(2);
                        reload = 1;
                        ivaSN = 0;
                        //ivaSN = 1; // es 1 pero este paso no necesita ser incorporado en la migración.
                        w2ui['grid'].url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getMateriales.ashx?idoc=' + numeroOC + '&snIva=' + ivaSN + '&reload=' + reload + '&userName=' + userName;
                        w2ui['grid'].reload();
                    } else {
                        this.fields[9].el.value = (parseFloat(this.fields[9].el.value) / iva).toFixed(2);
                        this.fields[10].el.value = (parseFloat(this.fields[10].el.value) / iva).toFixed(2);
                        reload = 1;
                        ivaSN = 0;
                        w2ui['grid'].url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getMateriales.ashx?idoc=' + numeroOC + '&snIva=' + ivaSN + '&reload=' + reload + '&userName=' + userName;
                        w2ui['grid'].reload();
                    }
                }

                /* Controla si s ingresa o no una nueva recepción */
                if (event.target == "newIngreso") {

                    if (w2ui['form'].record['nroRecepcion'] > 0) {

                        if (this.fields[17].el.checked) {

                            numeroDocTemp = this.fields[5].el.value;
                            NNotaCreditotemp = this.fields[18].el.value;
                            precioFacturatemp = this.fields[16].el.value;
                            nroRecepciontemp = this.fields[3].el.value;
                            totalAcumuladotemp = this.fields[10].el.value;
                            precionetotemp = $('#precioNeto').val();
                            descuentotemp = $('#descuento').val();
                            ivatemp = $('#ivaTotal').val();
                            totalReceptemp = $('#totalRecepcion').val();

                            /* cambia atributo */
                            $('#nroDocumento').prop('disabled', false);
                            $('#difpeso').prop('disabled', false);
                            $('#tipo_documento').prop('disabled', false);
                            $('#sumDif').prop('disabled', false);
                            $('#restDif').prop('disabled', false);

                            /* limpia datos para el nuevo ingreso */
                            this.fields[5].el.value = '';
                            this.fields[18].el.value = '';
                            this.fields[16].el.value = '';
                            this.fields[3].el.value = '';
                            this.fields[10].el.value = '0,00';
                            $('#precioNeto').val('0');
                            $('#descuento').val('0');
                            $('#ivaTotal').val('0');
                            $('#totalRecepcion').val('0,00');

                        } else {

                            this.fields[5].el.value = numeroDocTemp;
                            this.fields[18].el.value = NNotaCreditotemp;
                            this.fields[16].el.value = precioFacturatemp;
                            this.fields[3].el.value = nroRecepciontemp;
                            this.fields[10].el.value = totalAcumuladotemp;
                            $('#precioNeto').val(precionetotemp);
                            $('#descuento').val(descuentotemp);
                            $('#ivaTotal').val(ivatemp);
                            $('#totalRecepcion').val(totalReceptemp);

                            /* cambia atributo */
                            $('#nroDocumento').prop('disabled', true);
                            $('#difpeso').prop('disabled', true);
                            $('#tipo_documento').prop('disabled', true);
                            $('#sumDif').prop('disabled', true);
                            $('#restDif').prop('disabled', true);
                        }
                    }
                } // fin cambio nuevo ingreso

                /* Controla si s ingresa o no una nueva recepción */
                if (event.target == "ajusteValor") {

                    if (this.fields[19].el.checked) {
                        $('#diplayAjuste').css('display', 'block');
                    } else {
                        $('#diplayAjuste').css('display', 'none');
                    }
                }

                /* Controla si s ingresa o no una nueva recepción */
                if (event.target == "ajusteValor") {

                    if (this.fields[19].el.checked) {
                        $('#diplayAjuste').css('display', 'block');
                    } else {
                        $('#diplayAjuste').css('display', 'none');
                        $("#valorAjuste").val('');
                    }
                }

                /* Controla si s ingresa o no una nueva recepción */
                if (event.target == "valorAjuste") {
                    $("#descuento").val($("#valorAjuste").val());

                    var subTotalTemp = parseInt($('#precioNeto').val()) - parseInt($('#descuento').val());
                    $("#ivaTotal").val(subTotalTemp * 0.19);

                    var totalTemp = parseInt(subTotalTemp + parseInt($('#ivaTotal').val()));
                    $("#totalRecepcion").val(totalTemp);
                    $("#totalRecepcionado").val(totalTemp);
                }
            },
            actions: {
                btest: function () {

                    /* Saca el formato numerico de los campos para el save */
                    Quit_FormatNumber();
                    var precioFacturaTemp = quitaPunto($("#precioFactura").val());

                    var precioFacturaNuevo = parseInt(precioFacturaTemp);
                    var precioFacNew_Round = Math.round(precioFacturaNuevo);
                    var precioNetoFooter = parseInt($('#precioNeto').val());
                    var precioNetoFoo_Round = Math.round(precioNetoFooter);

                    /* Control llamado a popUp | verifica que el valor no supere los 1000 pesos */
                    if (precioFacNew_Round >= precioNetoFoo_Round) {

                        if ((precioFacNew_Round - precioNetoFoo_Round) > 1000) {

                            /* Las OC de portal con codigo CM "Contrato Marco" no llevan NC */
                            var TipoCompra = ($('#chileCompra').val()).toUpperCase();
                            var patt = /CM/g;
                            var result = patt.test(TipoCompra);

                            if (!result) {
                                /* NOTA DE CREDITO */
                                openPopup_notaCredito();
                            }
                        }
                    }
                },
                notaCredito: function () {
                    openPopup_notaCredito();
                },
                BuscarOC: function () {
                    nroOc_Fast = 0;
                    openPopup();
                },
                BuscarRecep: function () {
                    openPopup1();
                },
                saveForm: function () {

                    if ($("#estado").val() == 'ANULADA' || $("#estado").val() == 'RECEPCIONADA TOTALMENTE') {
                        w2alert('¡No puede realizar esta acción!');
                    } else {
                        if ($("#nroRecepcion").val() != '' && parseInt($('#nroRecepcion').val()) > 0) {
                            w2alert("<b>Doc. Ya Ingresado!</b><p>Indique si es una nueva recepción.", "¡Alerta!", function (answer) {
                                $("#numeroOC").focus();
                            });
                        } else {

                            /* Si el monto factura neto es mayor que precio neto final de la transacción se llama a la nota de credito   */
                            if (w2ui['form'].record['precioFactura']) {

                                /* Saca el formato numerico de los campos para el save */
                                Quit_FormatNumber();
                                var precioFacturaTemp = quitaPunto($("#precioFactura").val());

                                var precioFacturaNuevo = parseInt(precioFacturaTemp);
                                var precioFacNew_Round = Math.round(precioFacturaNuevo);
                                var precioNetoFooter = parseInt($('#precioNeto').val());
                                var precioNetoFoo_Round = Math.round(precioNetoFooter);

                                /* Control llamado a popUp | verifica que el valor no supere los 1000 pesos */
                                if (precioFacNew_Round >= precioNetoFoo_Round) {

                                    if ((precioFacNew_Round - precioNetoFoo_Round) > 1000) {

                                        /* Las OC de portal con codigo CM "Contrato Marco" no llevan NC */
                                        var TipoCompra = ($('#chileCompra').val()).toUpperCase();
                                        var patt = /CM/g;
                                        var result = patt.test(TipoCompra);

                                        if (!result) {
                                            /* NOTA DE CREDITO */
                                            openPopup_notaCredito();
                                        }

                                    } else {

                                        /* si no es mayor a los 1000 graba Y Pregunta si la diferencia de PESO esta bien */
                                        w2confirm('<b>¿Diferencia de pesos?</b><p>El monto bruto actual es de $' + $('#totalRecepcion').val() + ' , ¿El monto es correcto?', '¡Ajuste!', function (answer) {
                                            if (answer == 'Yes') {
                                                /* GRABA */
                                                w2ui['grid'].save();
                                            } else {
                                                $("#difpeso").focus();
                                            }
                                        });

                                    }

                                } else {

                                    if ((precioNetoFoo_Round - precioFacNew_Round) > 1000 && $("#valorAjuste").val() == '') {
                                        /* LLama a AJUSTE de sistema */
                                        w2alert("<b>Ajuste de valores!</b><p>Ingrese la cantidad de descuento para cuadrar la factura.", "¡Alerta!", function (answer) {
                                            $("#ajusteValor").prop('checked', true);
                                            $('#diplayAjuste').css('display', 'block');
                                            $("#valorAjuste").focus();
                                        });


                                    } else {
                                        /* Pregunta si la diferencia de PESO esta bien */
                                        w2confirm('<b>¿Diferencia de pesos?</b><p>El monto bruto actual es de $' + $('#totalRecepcion').val() + ' , ¿El monto es correcto?', '¡Ajuste!', function (answer) {
                                            if (answer == 'Yes') {
                                                /* GRABA */
                                                w2ui['grid'].save();
                                            } else {
                                                $("#difpeso").focus();
                                            }
                                        });
                                    }

                                }

                            } else {
                                w2alert("<b>Faltan Datos!</b><p>Ingrese el monto de la factura.", "¡Alerta!", function (answer) {
                                    $("#precioFactura").focus();
                                });
                            }

                        } // fin si existe recepción.
                    } // fin diferente de estados.

                },
                /* imprimirQR codigos QR, codQR*/
                Imprimir: function () {

                    // Identifica ID de busqueda.
                    if ($('#nroRecepcion').val() != '0') {
                        openPopup3();
                    } else { // alerta de mensaje por no ingresar nada.
                        w2alert('¡No puede realizar esta acción sin antes haber concretado la recepción!');
                    }
                    /*
                    var nroDocRecep = $('#nroDocumento').val();
                    nroRecepcion = $('#nroRecepcion').val();
                    idChileCompra = $('#chileCompra').val();
                    nombreProveedor = $('#proveedor').val();
                    fechaRecepcion = $('#fechaRecepcion').val().substr(0, 10);
                    var periodoRecep_OC = $('#fechaRecepcion').val().substr(6, 4);
                    var periodo_OC = $('#periodo').val();

                    if (nroRecepcion != '0') {
                    window.open('../../generadorQR/Recepcion/UsuariosProveedores/QR_RecepcionDesdeProveedores.aspx?TMVCodigo=' + '1' + '&PerCodigo=' + periodoRecep_OC + '&NroOC=' + numeroOC + '&PercodigoOC=' + periodo_OC + '&IdChileCompra=' + idChileCompra + '&Proveedor=' + nombreProveedor + '&NroRecepcion=' + nroRecepcion + '&fechaRecepcion=' + fechaRecepcion + '&nroDocumento=' + nroDocRecep);
                    } else {
                    w2alert('¡No puede realizar esta acción sin antes haber concretado la recepción!');
                    }
                    */
                },
                ImprimirRecep: function () {

                    var cmvNumero = this.record.nroRecepcion;
                    var periodoRecep = this.record.periodo;

                    if (cmvNumero != '0') {
                        var tmvCodigo = "1";
                        var bodegas = document.getElementById("bodegaRecepcion")
                        var bodega = this.record.bodegaRecepcion + '-' + bodegas.options[bodegas.selectedIndex].text;

                        $.ajax({
                            url: '../../clases/persistencia/controladores/GeneraInforme.ashx?',
                            type: 'POST',
                            dataType: "json",
                            data: { cmd: 'generaInforme', materiales: w2ui.grid.records, formData: this.record, dataRecep: w2ui['formFooter'].record, usuarioLogeado: userName, largoGrid: w2ui.grid.records.length, bodegaNombre: bodega, tmvCodigo: "1", percodioRecep: periodoRecep, percodigoOC: periodo },
                            success: function (response) {
                                if (response.status == 'error') {
                                    w2alert(response.message);
                                } else {
                                    window.open('../../reportes/Recepciones/DesdeProveedores/Rpt_RecepcionDesdeProveedores_Report.aspx?TMVCodigo=' + response.tmvCodigo + '&PerCodigo=' + response.periodo + '&CmvCodigo=' + response.cmvNumero + '&usuario=' + userName.trim() + '&nombreReport=' + 'Informe_Recepción_Desde_Proveedores');
                                }
                            },
                            error: function (response) {
                                alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                            }
                        });
                    } else {
                        w2alert('¡No puede realizar esta acción sin antes haber concretado la recepción!');
                    }
                },
                Limpiar: function () {

                    // Pagina Principal
                    w2ui['grid'].clear();
                    w2ui['form'].record = { periodo: $('#periodo').val() }
                    w2ui['form'].refresh();

                    w2ui['formFooter'].record = {
                        precioNeto: 0,
                        ivaTotal: 0,
                        totalRecepcion: 0,
                        totalOCompra: 0,
                        totalRecepcionado: 0,
                        descuento: 0,
                        impuesto: 0,
                        difpeso: 0
                    }
                    w2ui['formFooter'].refresh();

                    // Form datos
                    periodo = '';
                    numeroOC = 0;
                    reload = 0;
                    iva = 1.19;
                    ivaSN = 0;
                    userName = ' <%=usuario.username %> ';
                    nombre = ' <%=usuario.nombre %> ';
                    rut = '<%= usuario.rut %>';
                    tipo = '<%= usuario.tipo %>';
                    centroCosto = '<%= usuario.centroDeCosto %>';
                    bodegaDefault = "";
                    periodoRecep = "";
                    fechaRecepcion = "";
                    tmvCodigo = "";
                    nroRecepcion = 0;
                    idChileCompra = '';
                    nombreProveedor = '';
                    nroOc_Fast = 0;

                },
                /* imprimirNC */
                ImprimirNotaCredito: function () {

                    if ($("#nroNotaCredito").val() == '') {
                        w2alert('No Existe nota de credito.!');
                    } else {

                        var nameDescarga = $('#chileCompra').val();
                        var periodoPrint = $('#fechaRecepcion').val().substring(6, 10);

                        if (nameDescarga.length > 18) {
                            nameDescarga = nameDescarga.substring(0, 18);
                        }

                        nameDescarga = 'NC_' + nameDescarga + '_FACTURA_' + $('#nroDocumento').val();

                        window.open('../../reportes/Recepciones/DesdeProveedores/NotaCredito/Rpt_RecepDP_NCReport.aspx?numeroNC=' + $("#nroNotaCredito").val() + '&periodoNC=' + periodoPrint + '&numeroOCNC=' + $("#numeroOC").val() + '&numeroFacNC=' + $("#nroDocumento").val() + '&nombreReport=' + nameDescarga);
                    }


                } // Imprimir nota de credito

            }
        });
            //w2ui Form de datos Inferiores para valores de recepcion y OC
        $("#formFooter").w2form({
            name: 'formFooter',
            recid: 10,
            style: 'border: 0px; background-color: #f5f6f7; height: 123px;',
            formHTML:
                        '<div class="w2ui-page page-0" style="top: 10px;">' +
		                '	<div class="w2ui-label">Precio Neto:</div>' +
		                '	<div class="w2ui-field input-group">' +
                    '               <span class="input-group-addon" style="width: 12px;">$</span>' +
		                '		<input name="precioNeto" class="form-control" style="width: 138px;" type="text" size="35" disabled/>' +
		                '	</div>' +
		                '	<div class="w2ui-label">Descuento(-):</div>' +
		                '	<div class="w2ui-field input-group">' +
                    '               <span class="input-group-addon" style="width: 12px;">$</span>' +
		                '		<input name="descuento" id="descuento" class="form-control" style="width: 138px;" type="text" size="35" disabled/>' +
		                '	</div>' +
		                '	<div class="w2ui-label">I.V.A:</div>' +
		                '	<div class="w2ui-field input-group">' +
                    '               <span class="input-group-addon" style="width: 12px;">$</span>' +
		                '		<input name="ivaTotal" class="form-control" style="width: 138px;" type="text" size="35" disabled/>' +
		                '	</div>' +
		                '</div>' +
                        '<div class="w2ui-page page-0" style="left: 389px; top: 10px;">' +
		                '	<div class="w2ui-label" style="width: 140px; margin-right: 10px;">Impuesto:</div>' +
		                '	<div class="w2ui-field input-group" style="left: 10px;">' +
                    '           <span class="input-group-addon" style="width: 12px;">$</span>' +
		                '		<input name="impuesto" class="form-control" style="width: 138px;" type="text" size="35" disabled/>' +
		                '	</div>' +
		                '	<div class="w2ui-label" style="width: 140px; margin-right: 10px;">Total Recepción:</div>' +
		                '	<div class="w2ui-field input-group" style="left: 10px;">' +
                    '               <span class="input-group-addon" style="width: 12px;">$</span>' +
		                '		<input name="totalRecepcion" class="form-control" style="width: 138px;" type="text" size="35" disabled/>' +
		                '	</div>' +
		                '	<div class="w2ui-label" style="width: 140px; margin-right: 10px;">Total Orden de Compra:</div>' +
		                '	<div class="w2ui-field input-group" style="left: 10px; important!">' +
                    '               <span class="input-group-addon" style="width: 12px;">$</span>' +
		                '		<input name="totalOCompra" class="form-control" style="width: 138px;" type="text" size="35" disabled/>' +
                        '     (+I.V.A)' +
		                '	</div>' +
		                '</div>' +
                        '<div class="w2ui-page page-0" style="left: 772px; top: 15px;">' +
                        '   <div class="w2ui-label" style="width: 140px; margin-right: 10px; margin-left: 16px;">Diferencia de Peso</div>' +
		                '	<div class="w2ui-field input-group" style=" margin-top: 29px; margin-left: 7px;">' +
                        '       <span class="input-group-addon" style="width: 14px;">$</span>' +
                        '       <input name="difpeso" class="form-control" style="width: 138px;" type="text">' +
                        '       <span class="input-group-addon" style="width: 15px;"> </span>' +
		                '	</div>' +
                        '       <div class="w2ui-field-up" style="margin-left: 322px; margin-top: -35px;" type="up"><span class="glyphicons plus" style="zoom: 47%;"></span></div>' +
                        '       <div class="w2ui-field-down" style="margin-left: 323px;" type="down"><span class="glyphicons minus" type="down" style="zoom: 47%;"></span></div>' +
			                    '<input type="button" class="btn" id="sumDif" name="sumDif" style="margin-left: 155px;  margin-top: -17px; position: absolute; width: 14px; height: 14px; background: transparent;"/>' +
			                    '<input type="button" class="btn" id="restDif" name="restDif" style="margin-left: 156px;  margin-top: -5px; position: absolute; width: 14px; height: 12px; background: transparent;"/>' +
                        '</div>',
            fields: [
                    { name: 'precioNeto', type: 'text' },
		            { name: 'descuento', type: 'text' },
		            { name: 'ivaTotal', type: 'text' },
		            { name: 'impuesto', type: 'text' },
                    { name: 'totalRecepcion', type: 'text' },
                    { name: 'totalOCompra', type: 'text' },
                    { name: 'difpeso', type: 'int' }
                ],
            actions: {
                sumDif: function () {
                    var difPesoSum = $('#difpeso').val();

                    $('#difpeso').val(parseInt(difPesoSum) + 1);
                    if (parseInt($('#difpeso').val()) <= 1000) {
                        this.record = {
                            precioNeto: $('#precioNeto').val(),
                            ivaTotal: $('#ivaTotal').val(),
                            totalRecepcion: parseFloat($('#totalRecepcion').val()) + 1.00,
                            totalOCompra: $('#totalOCompra').val(),
                            totalRecepcionado: $('#totalRecepcionado').val(),
                            descuento: $('#descuento').val(),
                            impuesto: $('#impuesto').val(),
                            difpeso: $('#difpeso').val()
                        }
                    } else {
                        w2alert('La diferencia de valor NO puede superar los mil pesos (1000).');
                    }
                    // 
                    this.refresh();
                },
                restDif: function () {
                    var difPesoRest = $('#difpeso').val();
                    $('#difpeso').val(parseInt(difPesoRest) - 1);
                    if (parseInt($('#difpeso').val()) >= -1000) {
                        this.record = {
                            precioNeto: $('#precioNeto').val(),
                            ivaTotal: $('#ivaTotal').val(),
                            totalRecepcion: parseFloat($('#totalRecepcion').val()) - 1.00,
                            totalOCompra: $('#totalOCompra').val(),
                            totalRecepcionado: $('#totalRecepcionado').val(),
                            descuento: $('#descuento').val(),
                            impuesto: $('#impuesto').val(),
                            difpeso: $('#difpeso').val()
                        }
                        //                            
                    } else {
                        w2alert('La diferencia de valor NO puede superar los menos mil pesos (-1000).');
                    }
                    this.refresh();
                }
            },
            onChange: function (event) {
                if (event.target == 'difpeso') {
                    if (parseInt($('#difpeso').val()) <= 1000 && parseInt($('#difpeso').val()) >= -1000) {
                        this.record = {
                            precioNeto: $('#precioNeto').val(),
                            ivaTotal: $('#ivaTotal').val(),
                            totalRecepcion: parseFloat($('#precioNeto').val()) + parseFloat($('#ivaTotal').val()) + parseFloat($('#difpeso').val()),
                            totalOCompra: $('#totalOCompra').val(),
                            totalRecepcionado: $('#totalRecepcionado').val(),
                            descuento: $('#descuento').val(),
                            impuesto: $('#impuesto').val(),
                            difpeso: $('#difpeso').val()
                        }
                    } else {
                        w2alert('La diferencia de valor NO puede superar los MIL pesos (1000) o menos MIL pesos (-1000).');
                    }
                    // 
                    this.refresh();
                }
            },
            onLoad: function (event) {
                event.onComplete = function () {
                    var bodega = $('#codigoBodega').val();

                    var estadoRecep = $('#estado').val();
                    if (estadoRecep == 'RECEPCIONADA TOTALMENTE' || estadoRecep == 'RECEPCIONADA PARCIALMENTE') {
                        $('#bodegaRecepcion').prop('disabled', true);
                        $('#tipo_documento').prop('disabled', true);
                        $('#nroDocumento').prop('disabled', true);
                        $('#ivaSN').prop('disabled', true);
                        $('#difpeso').prop('disabled', true);
                        $('#sumDif').prop('disabled', true);
                        $('#restDif').prop('disabled', true);

                    } else {
                        $('#bodegaRecepcion').prop('disabled', false);
                        $('#tipo_documento').prop('disabled', false);
                        $('#nroDocumento').prop('disabled', false);
                        $('#ivaSN').prop('disabled', false);
                        $('#difpeso').prop('disabled', false);
                    }

                    if (nroOc_Fast != 0) {
                        numeroOC = nroOc_Fast;
                    }

                    w2ui['form'].record = {
                        bodegaRecepcion: bodega,
                        numeroOC: numeroOC,
                        codigoBodega: $('#codigoBodega').val(),
                        estado: estadoRecep,
                        nroRecepcion: $('#nroRecepcion').val(),
                        proveedor: $('#proveedor').val(),
                        nroDocumento: $('#nroDocumento').val(),
                        tipo_documento: 'FACTURA',
                        precio: $('#precio').val(),
                        totalRecepcionado: $('#totalRecepcionado').val(),
                        descripcion: $('#descripcion').val(),
                        periodo: $('#periodo').val(),
                        observacionRecp: $('#observacionRecp').val(),
                        chileCompra: $('#chileCompra').val(),
                        fechaRecepcion: $('#fechaRecepcion').val(),
                        nroNotaCredito: $('#nroNotaCredito').val()
                    }
                    w2ui['form'].refresh();
                }
                
            }

        });


        $("#grid, #form").keypress(function (e) {
            if (e.which == 13) {
                e.preventDefault();
            }
        });

    </script>
     <!-- Metodo para validacion de bodega de usuario -->
    <script type="text/javascript">
        function DatosValidos() {
            /* Encabezado */
            w2ui.form.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDatosOrdenCompra.ashx?numeroOC=' + numeroOC + '&periodoOC=' + periodo + '&userName=' + userName + '&nombre=' + nombre + '&rut=' + rut + '&tipo=' + tipo + '&centroCosto=' + centroCosto;
            w2ui.form.reload();
            /* Data Grid */
            w2ui.grid.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getMateriales.ashx?idoc=' + numeroOC + '&periodoOC=' + periodo + '&reload=' + reload + '&snIva=' + ivaSN + '&userName=' + userName;
            w2ui.grid.reload();
            /* Otros */
            w2ui.formFooter.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDatosOrdenCompra.ashx?numeroOC=' + numeroOC + '&periodoOC=' + periodo + '&userName=' + userName + '&nombre=' + nombre + '&rut=' + rut + '&tipo=' + tipo + '&centroCosto=' + centroCosto;
            w2ui.formFooter.reload();

            /* Da formato a numeros del Form */
            setTimeout(function () {
                FormatNumber();
            }, 2000);
        }

        function validarBodega() {
            $.ajax({
                type: "POST",
                url: "../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDatosOrdenCompra.ashx",
                async: false,
                data: { 'cmd': 'validar-bodega', 'numeroOC': numeroOC, 'periodo': periodo, 'centroCosto': centroCosto },
                dataType: 'json',
                success: function (response) {

                    if (response.validacion == 'True') {
                        reload = 0;
                        DatosValidos();
                    } else {
                        w2popup.open({
                            title: 'Bodega Incorrecta',
                            body: '<div class="w2ui-centered"><div><div><span class="glyphicons circle_exclamation_mark" style="color: goldenrod; zoom: 3; margin-bottom: 28px; margin-left: 22px;"/></div>La Bodega asociada a la Orden de Compra no pertenece a sus permiso de Bodega para Recepción, ¿desea Realizar la recepción de todas Maneras?</div></div>',
                            buttons: '<input type="button" value="Aceptar" onclick="DatosValidos(); w2popup.close();"> ' +
                            '<input type="button" value="Cancelar" onclick="w2popup.close();"> ',
                            modal: true
                        });
                    }
                }
            });
        }

        /* Para llamado instantaneo como el original */
        function DatosValidos_Fast() {
            /* Encabezado */
            w2ui.form.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDatosOrdenCompra.ashx?numeroOC=' + nroOc_Fast + '&periodoOC=' + $('#periodo').val() + '&userName=' + userName + '&nombre=' + nombre + '&rut=' + rut + '&tipo=' + tipo + '&centroCosto=' + centroCosto;
            w2ui.form.reload();
            /* Data Grid */
            w2ui.grid.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getMateriales.ashx?idoc=' + nroOc_Fast + '&periodoOC=' + $('#periodo').val() + '&reload=' + reload + '&snIva=' + ivaSN + '&userName=' + userName;
            w2ui.grid.reload();

            w2ui.formFooter.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDatosOrdenCompra.ashx?numeroOC=' + nroOc_Fast + '&periodoOC=' + $('#periodo').val() + '&userName=' + userName + '&nombre=' + nombre + '&rut=' + rut + '&tipo=' + tipo + '&centroCosto=' + centroCosto;
            w2ui.formFooter.reload();

            /* Da formato a numeros del Form */
            setTimeout(function () {
                FormatNumber();
            }, 2000);
        }

        /* valida si existe el N° de orden ingresada y controla la validacion de bodega*/
        function validarBodega_Fast() {
            $.ajax({
                type: "POST",
                url: "../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDatosOrdenCompra.ashx",
                async: false,
                data: { "cmd": 'validar-OC', "numeroOC": nroOc_Fast, "periodo": w2ui['form'].record['periodo'], "centroCosto": centroCosto },
                dataType: 'json',
                success: function (response) {

                    if (response.validacion == 'True') {

                        $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDatosOrdenCompra.ashx",
                            async: false,
                            data: { "cmd": 'validar-bodega', "numeroOC": nroOc_Fast, "periodo": w2ui['form'].record['periodo'], "centroCosto": centroCosto },
                            dataType: 'json',
                            success: function (response) {

                                if (response.validacion == 'True') {
                                    reload = 0;
                                    DatosValidos_Fast();
                                } else {
                                    w2popup.open({
                                        title: 'Bodega Incorrecta',
                                        body: '<div class="w2ui-centered"><div><div><span class="glyphicons circle_exclamation_mark" style="color: goldenrod; zoom: 3; margin-bottom: 28px; margin-left: 22px;"/></div>La Bodega asociada a la Orden de Compra no pertenece a sus permiso de Bodega para Recepción, ¿desea Realizar la recepción de todas Maneras?</div></div>',
                                        buttons: '<input type="button" value="Aceptar" onclick="DatosValidos_Fast(); w2popup.close();"> ' +
                            '<input type="button" value="Cancelar" onclick="w2popup.close();"> ',
                                        modal: true
                                    });

                                }
                            }
                        });

                    } else {
                        alert('¡No existe la OC ingresada.!');
                        w2ui['form'].record = { periodo: $('#periodo').val() }
                        w2ui['form'].refresh();
                    }
                }
            });
        } // fin validarBodega_Fast

        /* Valida Bodega si es llamado desde Búsqueda por Recepcion */
        function validarBodega_BusRecep() {
            $.ajax({
                type: "POST",
                url: "../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDatosOrdenCompra.ashx",
                async: false,
                data: { 'cmd': 'validar-bodega', 'numeroOC': numeroOC, 'periodo': periodo, 'centroCosto': centroCosto },
                dataType: 'json',
                success: function (response) {

                    if (response.validacion == 'True') {
                        reload = 0;
                        DatosValidos();
                    } else {
                        w2popup.open({
                            title: 'Bodega Incorrecta',
                            body: '<div class="w2ui-centered"><div><div><span class="glyphicons circle_exclamation_mark" style="color: goldenrod; zoom: 3; margin-bottom: 28px; margin-left: 22px;"/></div>La Bodega asociada a la Orden de Compra no pertenece a sus permiso de Bodega para Recepción, ¿desea Realizar la recepción de todas Maneras?</div></div>',
                            buttons: '<input type="button" value="Aceptar" onclick="DatosValidos_BusRecep(); w2popup.close();"> ' +
                            '<input type="button" value="Cancelar" onclick="w2popup.close();"> ',
                            modal: true
                        });
                    }
                }
            });
        }

        /* Para llamado Búsqueda por Recepcion */
        function DatosValidos_BusRecep() {

            /* Encabezado */
            w2ui.form.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDatosOrdenCompra.ashx?cmd=' + 'BusRecep' + '&nroRecepcion=' + nroRecepcion + '&periodoOC=' + periodo + '&userName=' + userName + '&nombre=' + nombre + '&rut=' + rut + '&tipo=' + tipo + '&centroCosto=' + centroCosto;
            w2ui.form.reload();

            /* footer */
            w2ui.formFooter.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDatosOrdenCompra.ashx?cmd=' + 'BusRecep' + '&nroRecepcion=' + nroRecepcion + '&periodoOC=' + periodo + '&userName=' + userName + '&nombre=' + nombre + '&rut=' + rut + '&tipo=' + tipo + '&centroCosto=' + centroCosto;
            w2ui.formFooter.reload();

//            /* Data Grid */
//            setTimeout(function () {
//                w2ui.grid.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getMateriales.ashx?idoc=' + w2ui['form'].record['numeroOC'] + '&periodoOC=' + w2ui['form'].record['periodo'] + '&reload=' + reload + '&snIva=' + ivaSN + '&userName=' + userName;
//                //w2ui.grid.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getMateriales.ashx?idoc=' + $('#numeroOC').val() + '&periodoOC=' + w2ui['form'].record['periodo'] + '&reload=' + reload + '&snIva=' + ivaSN + '&userName=' + userName;
//                w2ui.grid.reload();
//            }, 800);

            /* Data Grid */
            setTimeout(function () {
                w2ui.grid.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getMateriales.ashx?cmd=' + 'mat-Movimiento' + '&numRecepcion=' + w2ui['form'].record['nroRecepcion'] + '&periodo=' + w2ui['form'].record['periodo'] + '&reload=' + '3';
                w2ui.grid.reload();
            }, 800);

            /* Da formato a numeros del Form */
            setTimeout(function () {
                FormatNumber();
            }, 2000);
        }

    </script>

    <!-- w2ui popUp para nota credito -->
    <script type="text/javascript">
        function openPopup_notaCredito() {
            w2popup.open({
                title: '',
                width: 750,
                height: 600,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                modal: true,
                onOpen: function (event) {
                    event.onComplete = function () {

                        $('#w2ui-popup #main').w2render('layout2');
                        w2ui.layout2.content('left', w2ui.gridNota);
                        w2ui.layout2.content('main', w2ui.formNota);

                        var date = new Date();
                        var actualDate = date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear();

                        /* cambia valores del pop Up*/
                        if ($("#nroNotaCredito").val() != 0) {
                            $("#numeroNC").val($("#nroNotaCredito").val());
                        } else {
                            $("#numeroNC").val('');
                        }

                        $("#IDChileCompraNC").val($('#chileCompra').val());
                        $("#periodoNC").val(date.getFullYear());
                        $("#numeroOCNC").val($('#numeroOC').val());
                        $("#montoNC").val($('#precioFactura').val());

                        var NombreProveedor = w2ui['form'].record['proveedor'];
                        var div_Nproveedor = NombreProveedor.split("-");
                        NombreProveedor = div_Nproveedor[1];
                        NombreProveedor = NombreProveedor.substring(2);

                        var rutProveedor = w2ui['form'].record['proveedor'];
                        var div_Rproveedor = rutProveedor.split("-");
                        rutProveedor = div_Rproveedor[0] + '-' + div_Rproveedor[1].substring(0, 1);

                        $("#nombreProvNC").val(NombreProveedor);
                        $("#rutProvNC").val(rutProveedor);
                        $("#numeroFacNC").val($('#nroDocumento').val());
                        $("#fechaFactNC").val('');                               // campo no existe sera ingresado junto a la nota de credito

                        $("#nombreSolicitanteNC").val(nombre);
                        $("#fechaActualNC").val(actualDate);

                        $("#codBodegaNC").val($('#bodegaRecepcion').val());
                        $("#nombreBodegaNC").val($('#bodegaRecepcion option:selected').text());
                        //$("#bodegaNC").val('');

                        /* Se calcula la diferencia */
                        var precioFacturaTemp = quitaPunto($("#precioFactura").val());
                        var precioNetoTemp = quitaPunto($('#precioNeto').val());
                        var montoNC = parseInt(precioFacturaTemp) - parseInt(precioNetoTemp);

                        $("#motivoNC").val('Solicitamos Nota de Crédito para la Factura Nº ' + $('#nroDocumento').val() + ' por diferencia de precio con la Orden de Compra del Portal Nº ' + $('#chileCompra').val() + ' por un monto de $' + montoNC + ' neto debido a diferencia en precio de facturación de los productos.');

                    };

                },
                onMax: function (event) {
                    event.onComplete = function () {
                        w2ui.layout2.resize();
                    }
                },
                onMin: function (event) {
                    event.onComplete = function () {
                        w2ui.layout2.resize();
                    }
                }
            });
        }

        /* solo permite el ingreso de caracteres de fecha validos */
        function justFecha(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 46) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;
            else
                return true;
            //return /\d/.test(String.fromCharCode(keynum));
        }

        /* solo permite el ingreso de numeros */
        function justNumber(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 45) || (KeyAscii >= 46) && (KeyAscii <= 47) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;
            else
                return true;
        }

        /* solo permite el ingreso de numeros y "." para valorFactura */
        function just_precioFactura(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 45) || (KeyAscii == 47) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;
            else
                return true;
        }

        // formatear número
        function formatoNumero(val) {
            while (/(\d+)(\d{3})/.test(val.toString())) {
                val = val.toString().replace(/(\d+)(\d{3})/, '$1' + '.' + '$2');
            }
            return val;
        }

        // quitar puntos o comas
        function quitaPunto(val) {
            //return val.replace(/./g, "");
            return val.split('.').join('')
        }

        /* proporciona formato numerico a los valores del form */
        function FormatNumber() {
            $("#totalRecepcionado").val(formatoNumero($("#totalRecepcionado").val()));
            $("#precio").val(formatoNumero($("#precio").val()));
            // footer
            $("#precioNeto").val(formatoNumero($("#precioNeto").val()));
            $("#descuento").val(formatoNumero($("#descuento").val()));
            $("#ivaTotal").val(formatoNumero($("#ivaTotal").val()));
            $("#totalRecepcion").val(formatoNumero($("#totalRecepcion").val()));
            $("#totalOCompra").val(formatoNumero($("#totalOCompra").val()));
        }

        function Quit_FormatNumber() { 
            $("#totalRecepcionado").val(quitaPunto($("#totalRecepcionado").val()));
            $("#precio").val(quitaPunto($("#precio").val()));
            // footer
            $("#precioNeto").val(quitaPunto($("#precioNeto").val()));
            $("#descuento").val(quitaPunto($("#descuento").val()));
            $("#ivaTotal").val(quitaPunto($("#ivaTotal").val()));
            $("#totalRecepcion").val(quitaPunto($("#totalRecepcion").val()));
            $("#totalOCompra").val(quitaPunto($("#totalOCompra").val()));
        }

    </script>

    <!-- Metodo para cantidad de QR -->
    <script type="text/javascript">

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
                            $("#QRPeriodo").val($('#periodo').val());
                            $("#QRNumero").val($('#nroRecepcion').val());

                            periodoRecepcion = $('#fechaRecepcion').val().substr(6, 4);

                            // recorre el grid en busca de los materiales ingresados para preguntar cuantas equiquetas se imprimiran de cada uno.
                            for (var i = 0; i < w2ui['grid'].records.length; i++) {
                                var matCodigo = w2ui['grid'].records[i].recid;

                                $.ajax({
                                    type: "POST",
                                    url: "../../clases/persistencia/controladores/Recepciones/DesdeProveedores/getDetalleMaterial.ashx",
                                    async: false,
                                    data: { "cmd": 'getRecordsParaQR', "idoc": w2ui['form'].record['numeroOC'], "periodoOC": w2ui['form'].record['periodo'], "codigoMaterial": matCodigo, "periodo": periodoRecepcion, "nroRecepcion": $('#nroRecepcion').val() },
                                    dataType: "json",
                                    success: function (response) {

                                        largoDatos = response.records.length + 1;

                                        // Transcribe los nuevos Records o articulos actualmente disponibles.
                                        for (var i = 0; i < response.records.length; i++) {
                                            w2ui['grid5'].add({ recid: w2ui['grid'].records.length, FLD_MATCODIGO: matCodigo, CANTIDAD_OFICIAL: response.records[i].cantidad2, FLD_NERIE: response.records[i].loteSerie2.trim(), FLD_CANTIDAD: 0 });
                                        } // fin for

                                    } // Fin success
                                }); // fin ajax	

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

                        var periodoRecepcion = $('#fechaRecepcion').val().substr(6, 4);

                        // Guarda los datos para imprimir.
                        $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                            async: false,
                            data: { cmd: 'INSCantidadQR', GridQR: w2ui['grid5'].records, largoGrid: w2ui['grid5'].records.length, Periodo: periodoRecepcion, NumMov: w2ui['form'].record['nroRecepcion'], CodMov: '1' },
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

                        var nroDocRecep = $('#nroDocumento').val();
                        nroRecepcion = $('#nroRecepcion').val();
                        idChileCompra = $('#chileCompra').val();
                        nombreProveedor = $('#proveedor').val();
                        fechaRecepcion = $('#fechaRecepcion').val().substr(0, 10);
                        var periodoRecep_OC = $('#fechaRecepcion').val().substr(6, 4);
                        var periodo_OC = $('#periodo').val();
                        
                        // carga pestaña de codigos QR
                        window.open('../../generadorQR/Recepcion/UsuariosProveedores/QR_RecepcionDesdeProveedores.aspx?TMVCodigo=' + '1' + '&PerCodigo=' + periodoRecep_OC + '&NroOC=' + nroRecepcion + '&PercodigoOC=' + periodo_OC + '&IdChileCompra=' + idChileCompra + '&Proveedor=' + nombreProveedor + '&NroRecepcion=' + nroRecepcion + '&fechaRecepcion=' + fechaRecepcion + '&nroDocumento=' + nroDocRecep);

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
