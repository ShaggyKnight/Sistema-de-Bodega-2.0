<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master"
    CodeBehind="facturasAGuiasDespacho.aspx.vb" Inherits="Bodega_WebApp.facturasAGuiasDespacho" %>

<asp:Content ID="headFactAGuias" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.recepFacturasaGuia%>
</asp:Content>
<asp:Content ID="bodyFactAGuias" ContentPlaceHolderID="MainContent" runat="server">
    <div id="formFactGuias">
    </div>
    <div id="gridFactGuias" style="height: 260px; top: 3px;">
    </div>
</asp:Content>
<asp:Content ID="footerFactAGuias" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
    <div id="formFooterFactGuias">
    </div>
</asp:Content>
<asp:Content ID="javaScriptFactAGuias" ContentPlaceHolderID="contenedorJavascript"
    runat="server">

     <!--Variables globales-->
    <script type="text/javascript">

        /*
        *Solicitudes:

        *Correcciones:
         Arreglo en procedimiento (PRO_Buscar_GuiasProveedor_NEW2013) para carga de datos.
         Se reparo el tiempo del mensaje de cambio exitoso en la guia.

        *Pruebas:
         Carga: ok.
         Save: ok.
         Imprime excel: ok.
         QR: no tiene.
        */

        var tipoDeBusqueda = 0;
        var rutProveedor = 0;
        var periodoGuia = 0;
        var nroGuia = 0;
        var nroFactura = 0;
        var nombreProveedor = '';
    </script>
    <!-- W2ui Form para criterios de busqueda de guias  -->
    <script type="text/javascript">
        $('#formFactGuias').w2form({
            name: 'formFactGuias',
            recid: 10,
            url: '../../clases/persistencia/controladores/Recepciones/AsocFacturaAGuiaDespacho/getGuiasDespacho.ashx?tipoBusqueda=cargaForm',
            formHTML: '<div class="w2ui-page page-0">' +
		                '<div style="width: 489px; float: left;">' +
			                '<div style="padding: 3px; font-weight: bold; color: #777;">Proveedor</div>' +
			                '<div class="w2ui-group" style="height: 53px; width: 720px;">' +
                                '<div class="col-8 col-sm-6">' +
				                    '<div class="w2ui-label w2ui-span6">Nombre Proveedor:</div>' +
				                    '<div class="w2ui-field w2ui-span6">' +
					                    '<select name="nombreProveedor" class="form-control" type="list" />' +
				                    '</div>' +
                                '</div>' +
                                '<div class="col-2 col-sm-1     ">' +
				                    '<div class="w2ui-label w2ui-span6">Rut Proveedor:</div>' +
				                    '<div class="w2ui-field w2ui-span6">' +
					                    '<input name="rutProveedor" class="form-control" type="text" placeholder="sin Dígito Verificador" maxlength="100" style="width: 100px;"/>' +
				                    '</div>' +
                                '</div>' +
			                '</div>' +
		                '</div>' +
		                '<div style="margin-left: 730px;">' +
			                '<div style="padding: 3px; font-weight: bold; color: #777;">Criterios</div>' +
			                '<div class="w2ui-group" style="height: 53px;">' +
                                '<div class="col-4">' +
				                    '<div class="w2ui-label w2ui-span3">Periodo:</div>' +
				                    '<div class="w2ui-field w2ui-span3">' +
					                    '<input name="periodoGuia" class="form-control" type="text" maxlength="100" style="width: 60px;"/>' +
				                    '</div>' +
                                '</div>' +
                                '<div class="col-4">' +
				                    '<div class="w2ui-label w2ui-span3">Guía:</div>' +
				                    '<div class="w2ui-field w2ui-span3">' +
					                    '<input name="numeroGuia" class="form-control" type="text" maxlength="100" style="width: 50px;"/>' +
				                    '</div>' +
                                '</div>' +
                                '<div class="col-4">' +
				                    '<div class="w2ui-label w2ui-span3">Factura:</div>' +
				                    '<div class="w2ui-field w2ui-span3">' +
					                    '<input name="numeroFactura" class="form-control" type="text" maxlength="100" style="width: 50px;"/>' +
				                    '</div>' +
                                '</div>' +
			                '</div>' +
		                '</div>' +
	                '</div>' +
                    '<div class="w2ui-buttons">' +
		                '<input  type="button" value="Todas" name="todasGuiaFact">' +
		                '<input type="button" value="Con Factura" name="conFactura">' +
		                '<input type="button" value="Sin Factura" name="sinFactura">' +
		                '<input type="button" value="Crear Excel" name="exportExcel">' +
	                '</div>',
            fields: [
                { name: 'nombreProveedor', type: 'list',
                    options: { url: '../../clases/persistencia/controladores/Recepciones/AsocFacturaAGuiaDespacho/getListaDatosSelect.ashx?campoDeCarga=proveedor' }
                },
			    { name: 'rutProveedor', type: 'int' },
			    { name: 'periodoGuia', type: 'int' },
			    { name: 'numeroGuia', type: 'int' },
			    { name: 'numeroFactura', type: 'int' }
            ],
            onChange: function (event) {
                if (event.target == 'nombreProveedor') {
                    this.record = {
                        nombreProveedor: $('#nombreProveedor').val(),
                        rutProveedor: $('#nombreProveedor').val(),
                        periodoGuia: $('#periodoGuia').val(),
                        numeroGuia: $('#numeroGuia').val(),
                        numeroFactura: $('#numeroFactura').val()
                    }
                    this.refresh();
                } else if (event.target == 'rutProveedor') {
                    this.record = {
                        nombreProveedor: $('#rutProveedor').val(),
                        rutProveedor: $('#rutProveedor').val(),
                        periodoGuia: $('#periodoGuia').val(),
                        numeroGuia: $('#numeroGuia').val(),
                        numeroFactura: $('#numeroFactura').val()
                    }
                    this.refresh();
                } else if (event.target == 'numeroGuia') {
                    if ($('#numeroGuia').val() == '') {
                        this.record = {
                            nombreProveedor: $('#rutProveedor').val(),
                            rutProveedor: $('#rutProveedor').val(),
                            periodoGuia: $('#periodoGuia').val(),
                            numeroGuia: 0,
                            numeroFactura: $('#numeroFactura').val()
                        }
                        this.refresh();
                    }
                } else if (event.target == 'numeroFactura') {
                    if ($('#numeroFactura').val() == '') {
                        this.record = {
                            nombreProveedor: $('#rutProveedor').val(),
                            rutProveedor: $('#rutProveedor').val(),
                            periodoGuia: $('#periodoGuia').val(),
                            numeroGuia: $('#numeroGuia').val(),
                            numeroFactura: 0
                        }
                        this.refresh();
                    }
                }
            },
            actions: {
                todasGuiaFact: function () {
                    if (this.record.rutProveedor != '' && this.record.rutProveedor != undefined) {
                        tipoDeBusqueda = 1;
                        rutProveedor = this.record.rutProveedor;
                        periodoGuia = this.record.periodoGuia;
                        nroGuia = this.record.numeroGuia;
                        nroFactura = this.record.numeroFactura;
                        nombreProveedor = this.fields[0].el.selectedOptions[0].text;
                        nombreProveedor = nombreProveedor.replace('&', 'amperSand');
                        w2ui.gridFactGuias.url = '../../clases/persistencia/controladores/Recepciones/AsocFacturaAGuiaDespacho/getGuiasDespacho.ashx?tipoBusqueda=bTodas' + '&proveedor=' + this.record.rutProveedor + '&nroFactura=' + this.record.numeroFactura + '&percodigo=' + this.record.periodoGuia + '&nroGuia=' + this.record.numeroGuia;
                        w2ui.gridFactGuias.reload();
                    } else {
                        w2alert('Debe Seleccionar o Ingresar un Proveedor Valido!!');
                    }
                },
                conFactura: function () {
                    if (this.record.rutProveedor != '' && this.record.rutProveedor != undefined) {
                        tipoDeBusqueda = 2;
                        rutProveedor = this.record.rutProveedor;
                        periodoGuia = this.record.periodoGuia;
                        nroGuia = this.record.numeroGuia;
                        nroFactura = this.record.numeroFactura;
                        nombreProveedor = this.fields[0].el.selectedOptions[0].text;
                        nombreProveedor = nombreProveedor.replace('&', 'amperSand');
                        w2ui.gridFactGuias.url = '../../clases/persistencia/controladores/Recepciones/AsocFacturaAGuiaDespacho/getGuiasDespacho.ashx?tipoBusqueda=bConFactura' + '&proveedor=' + this.record.rutProveedor + '&nroFactura=' + this.record.numeroFactura + '&percodigo=' + this.record.periodoGuia + '&nroGuia=' + this.record.numeroGuia;
                        w2ui.gridFactGuias.reload();
                    } else {
                        w2alert('Debe Seleccionar o Ingresar un Proveedor Valido!!');
                    }
                },
                sinFactura: function () {
                    if (this.record.rutProveedor != '' && this.record.rutProveedor != undefined) {
                        tipoDeBusqueda = 3;
                        rutProveedor = this.record.rutProveedor;
                        periodoGuia = this.record.periodoGuia;
                        nroGuia = this.record.numeroGuia;
                        nroFactura = this.record.numeroFactura;
                        nombreProveedor = this.fields[0].el.selectedOptions[0].text;
                        nombreProveedor = nombreProveedor.replace('&', 'amperSand');
                        w2ui.gridFactGuias.url = '../../clases/persistencia/controladores/Recepciones/AsocFacturaAGuiaDespacho/getGuiasDespacho.ashx?tipoBusqueda=bSinFactura' + '&proveedor=' + this.record.rutProveedor + '&nroFactura=' + this.record.numeroFactura + '&percodigo=' + this.record.periodoGuia + '&nroGuia=' + this.record.numeroGuia;
                        w2ui.gridFactGuias.reload();
                    } else {
                        w2alert('Debe Seleccionar o Ingresar un Proveedor Valido!!');
                    }
                },
                exportExcel: function () {
                    if (tipoDeBusqueda != 0) {
                        window.open('DownloadExcelGuiasFactura.aspx?tipoBusqueda=' + tipoDeBusqueda + '&proveedor=' + rutProveedor + '&periodo=' + periodoGuia + '&nroGuia=' + nroGuia + '&nroFactura=' + nroFactura + '&nombreProveedor=' + nombreProveedor);
                    } else {
                        w2alert('Deben EXISTIR datos para generar el archivo Excel, seleccione la busqueda que desea realizar y luego presione el boton "Crear Excel".');
                    }
                }
            }
        });
    </script>
    <!-- Grid de Guias  -->
    <script type="text/javascript">
        $('#gridFactGuias').w2grid({
            name: 'gridFactGuias',
            show: {
                toolbar: true,
                footer: true,
                toolbarSearch: false
            },
            columns: [
			    { field: 'guia', caption: 'Guia', size: '10%', attr: 'align=center' },
			    { field: 'recepcion', caption: 'Recepción', size: '10%', attr: 'align=center' },
			    { field: 'añoRecepcion', caption: 'Año Recepcion', size: '10%', attr: 'align=center' },
			    { field: 'nroOC', caption: 'Nº O. Compra', size: '10%', attr: 'align=center' },
			    { field: 'añoOC', caption: 'Año O. Compra', size: '10%', attr: 'align=center' },
			    { field: 'nroFactura', caption: 'Factura', size: '30%', attr: 'align=center', editable: { type: 'int'} }
		    ],
            onChange: function (event) {
                if (event.column == 5) {
                    this.request('guardarGuia', w2ui.formFactGuias.record, '../../clases/persistencia/controladores/Recepciones/AsocFacturaAGuiaDespacho/getGuiasDespacho.ashx?tipoBusqueda=grabarGuia' + '&guia=' + this.records[this.last.sel_ind].guia + '&recepcion=' + this.records[this.last.sel_ind].recepcion + '&añoRecepcion=' + this.records[this.last.sel_ind].añoRecepcion + '&nroFactura=' + event.value_new);
                    this.requestComplete('success', 'guardarGuia', function () {
                        setTimeout(function () {
                            w2alert('Guia a Asociada con Exito!');
                        }, 200);
                        
                    });
                }
            }
        });	

    </script>
    <%--<!--   -->
    <script type="text/javascript">
        
    </script>
    <!--   -->
    <script type="text/javascript">
        
    </script>
    <!--   -->
    <script type="text/javascript">
        
    </script>--%>
    <!-- Funcion Enter descativada  -->
    <script type="text/javascript">
        $("#gridFactGuias, #formFactGuias").keypress(function (e) {
            if (e.which == 13) {
                e.preventDefault();
            }
        });
    </script>
</asp:Content>
