<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="DespachoAUsuarios.aspx.vb" Inherits="Bodega_WebApp.DespachoAUsuarios1" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportAUsuarios%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="formRptDespachoAUsuarios" style="height: 398px; top: 2px;">
    </div>
    <div id="gridRptDespachoAUsuarios" style="height: 349px; top: 2px;">
    </div>
</asp:Content>
<asp:Content ID="FooterContent" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
    
</asp:Content>
<asp:Content ID="JavascriptContent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">
        var codEstablecimiento = 0;
    </script>
    <script type="text/javascript">
        $('#formRptDespachoAUsuarios').w2form({
            name: 'formRptDespachoAUsuarios',
            recid: 10,
            header: 'Despachos a Usuarios',
            formHTML:
	            '<div class="w2ui-page page-0">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 80px;">' +

            // Fecha Inicio
				        '<div class="w2ui-label w2ui-span7">Fecha Inicio: </div>' +
		                '<div class="w2ui-field w2ui-span7" >' +
                        '   <input name="Fecha_Inicio" type="text" maxlength="100" size="16" placeholder="dd/mm/yyyy" onkeypress="return justFecha(event);">' +
		                '</div>' +

            //Fecha Termino
				        '<div class="w2ui-label w2ui-span7">Fecha Termino: </div>' +
		                '<div class="w2ui-field w2ui-span7">' +
                        '   <input name="Fecha_Termino" type="text" maxlength="100" size="16" placeholder="dd/mm/yyyy" onkeypress="return justFecha(event);"/>' +
		                '</div>' +
                    '</div>' +
                    '<div class="w2ui-group" style="height: 80px;">' +
                        '<div class="w2ui-label w2ui-span1">' +
                        '   <input id="CentroRespRadio" name="CentroRespRadio" type="checkbox" style="margin-top: auto;" />' + '</div>' +
				        '<div class="w2ui-label w2ui-span7">Centro Responsabilidad: </div>' +
		                '<div class="w2ui-field w2ui-span8">' +
		                '	<select id="CentrosResp" name="CentrosResp" type="text" />' +
		                '</div>' +

                        '<div class="w2ui-label w2ui-span1">' +
                        '   <input id="cenCostoRadio" name="cenCostoRadio" type="checkbox" style="margin-top: auto;" />' + '</div>' +
                        '<div class="w2ui-label w2ui-span6">Centro de Costo: </div>' +
		                '<div class="w2ui-field w2ui-span8">' +
		                '	<select id="CentroCosto" name="CentroCosto" type="text" disabled="disabled" />' +
		                '</div>' +

                    '</div>' +
                    '<div class="w2ui-group" style="height: 80px;">' +
                        '<div class="w2ui-label w2ui-span1">' +
                        '   <input id="ProductosRadio" name="ProductosRadio" type="checkbox" style="margin-top: auto;" />' + '</div>' +
                        '<div class="w2ui-label w2ui-span5">Productos: </div>' +
		                '<div class="w2ui-field w2ui-span8">' +
		                '	<select id="codProductos" name="codProductos" type="text" style="width: 300px;" />' +
		                '</div>' +

                        '<div class="w2ui-label w2ui-span1">' +
                        '   <input id="itemsRadio" name="itemsRadio" type="checkbox" style="margin-top: auto;" />' + '</div>' +
                        '<div class="w2ui-label w2ui-span7">Items Presupuestarios: </div>' +
		                '<div class="w2ui-field w2ui-span8">' +
		                '	<select id="itemPresup" name="itemPresup" type="text" style="width: 300px;" disabled="disabled"/>' +
		                '</div>' +

			       '</div>' +
		        '</div>' +
		        '<div class="w2ui-buttons">' +
		        '	<input type="button" value="Imprimir" name="imprimir">' +
		        '	<input type="button" value="Limpiar" name="limpiar">' +
                '</div>',
            fields: [
		            { name: 'Fecha_Inicio', type: 'date' },
                    { name: 'Fecha_Termino', type: 'date' },
                    { name: 'CentroRespRadio', type: 'checkbox' },
                    { name: 'cenCostoRadio', type: 'checkbox' },
                    { name: 'ProductosRadio', type: 'checkbox' },
                    { name: 'itemsRadio', type: 'checkbox' },
                    { name: 'CentrosResp', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Reportes/Despacho/AUsuarios/DataRptDespachoAUsuarios.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=centrosRespon'
                        }
                    },
                    { name: 'CentroCosto', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Reportes/Despacho/AUsuarios/DataRptDespachoAUsuarios.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=centrosCosto'
                        }
                    },
                    { name: 'codProductos', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Reportes/Despacho/AUsuarios/DataRptDespachoAUsuarios.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=listaMateriales'
                        }
                    },
                    { name: 'itemPresup', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Reportes/Despacho/AUsuarios/DataRptDespachoAUsuarios.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=itemsPresup'
                        }
                    }
	        ],
            actions: {
                imprimir: function () {

                    //                    var FechaInicio = $("#Fecha_Inicio").val();
                    //                    var FechaTermino = $("#Fecha_Termino").val();
                    //                    var BodegaDespacho = $("#BodegaDespacho").val();
                    //                    var BodegaSolicito = $("#BodegaSolicito").val();
                    //                    var DetalleTransf = $('#DetalleTransf').prop("checked");

                    //                    if (DetalleTransf == false) {

                    //                        window.open('../../../reportes/Reportes/Transferencias/EntreBodegas/Report_TransfEntreBodegas.aspx?FechaInicio=' + FechaInicio + '&FechaTermino=' + FechaTermino + '&BodegaDespacha=' + BodegaDespacho + '&BodegaSolicita=' + BodegaSolicito + '&DetalleSN=' + 0);
                    //                    } else {
                    //                        window.open('../../../reportes/Reportes/Transferencias/EntreBodegas/Report_TransfEntreBodegasDetalle.aspx?FechaInicio=' + FechaInicio + '&FechaTermino=' + FechaTermino + '&BodegaDespacha=' + BodegaDespacho + '&BodegaSolicita=' + BodegaSolicito + '&DetalleSN=' + 1);
                    //                    }
                },
                limpiar: function () {
                    this.clear();
                }
            },
            // Cambio en el Form.
            onChange: function (event) {

                if (event.target == 'CentroRespRadio') {
                    var valor = $('#CentroCosto').val();
                    if ($('#CentroRespRadio').is(':checked') == true) {
                        $('#CentrosResp').prop('disabled', false);
                        $('#cenCostoRadio').prop('checked', false);
                        $('#CentroCosto').prop('disabled', true);
                        $('#CentroCosto').val('');
                    }

                } else if (event.target == 'cenCostoRadio') {

                    if ($('#cenCostoRadio').is(':checked') == true) {
                        $('#CentroCosto').prop('disabled', false);
                        $('#CentroRespRadio').prop('checked', false);
                        $('#CentrosResp').prop('disabled', true);
                        $('#CentrosResp').val('');
                    }

                } else if (event.target == 'ProductosRadio') {

                    if ($('#ProductosRadio').is(':checked') == true) {
                        $('#codProductos').prop('disabled', false);
                        $('#itemsRadio').prop('checked', false);
                        $('#itemPresup').prop('disabled', true);
                        $('#itemPresup').val('');
                    }

                } else {

                    if ($('#itemsRadio').is(':checked') == true) {
                        $('#itemPresup').prop('disabled', false);
                        $('#ProductosRadio').prop('checked', false);
                        $('#codProductos').prop('disabled', true);
                        $('#codProductos').val('');
                    }
                }
                // Al cambiar el establecimiento carga las bodegas pertenecientes al mismo
                //                if (event.target == 'Establecimiento') {

                //                    var fechaInicio = $('#Fecha_Inicio').val();
                //                    var fechaTermino = $('#Fecha_Termino').val();
                //                    var detalleTrasf = $('#DetalleTransf').val();
                //                    codEstablecimiento = $('#Establecimiento').val();

                //                    this.fields[3].options.url = '../../../clases/persistencia/controladores/Reportes/Transferencias/EntreBodegas/DataRptTransferenciasBodegas.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=bodegas' + '&establecimiento=' + codEstablecimiento;
                //                    this.fields[4].options.url = '../../../clases/persistencia/controladores/Reportes/Transferencias/EntreBodegas/DataRptTransferenciasBodegas.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=bodegas' + '&establecimiento=' + codEstablecimiento;

                //                    this.record = {
                //                        Fecha_Inicio: fechaInicio,
                //                        Fecha_Termino: fechaTermino,
                //                        Establecimiento: codEstablecimiento,
                //                        DetalleTransf: detalleTrasf
                //                    }

                //                    this.refresh();
                //                }

            }

        });

        function justFecha(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 46) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;

            return /\d/.test(String.fromCharCode(keynum));
        } 

    </script>
</asp:Content>
