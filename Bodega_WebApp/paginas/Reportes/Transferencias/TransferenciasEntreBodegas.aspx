<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="TransferenciasEntreBodegas.aspx.vb" Inherits="Bodega_WebApp.TransferenciasEntreBodegas" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportTrasferenciaBodegas%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="formRptTransferenciasBodegas" style="margin-bottom:8px; height: 349px; width: 54%; top: 10px; margin-left: 20%;">
    </div>
</asp:Content>
<asp:Content ID="FooterContent" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="JavaScriptContent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">
    var codEstablecimiento = 0;
    </script>
    <script type="text/javascript">
        $('#formRptTransferenciasBodegas').w2form({
            name: 'formRptTransferenciasBodegas',
            recid: 10,
            header: 'Transferencias entre Bodegas',
            formHTML:
	            '<div class="w2ui-page page-0">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303; margin-left: 4%;">General</div>' +
			        '<div class="w2ui-group" style="height: 204px; width: 90%; margin-left: 5%;">' +

            // Fecha Inicio
				        '<div class="w2ui-label w2ui-span7">Fecha Inicio: </div>' +
		                '<div class="w2ui-field w2ui-span7" >' +
                        '   <input name="Fecha_Inicio" type="text" maxlength="100" size="16" placeholder="dd/mm/yyyy">' +
		                '</div>' +

            //Fecha Termino
				        '<div class="w2ui-label w2ui-span7">Fecha Termino: </div>' +
		                '<div class="w2ui-field w2ui-span7">' +
                        '   <input name="Fecha_Termino" type="text" maxlength="100" size="16" placeholder="dd/mm/yyyy" />' +
		                '</div>' +

				        '<div class="w2ui-label w2ui-span7">Establecimiento: </div>' +
		                '<div class="w2ui-field w2ui-span7">' +
		                '	<select id="Establecimiento" name="Establecimiento" type="text" />' +
		                '</div>' +

                        '<div class="w2ui-label w2ui-span7">Bodega Despachó: </div>' +
		                '<div class="w2ui-field w2ui-span7">' +
		                '	<select id="BodegaDespacho" name="BodegaDespacho" type="text" />' +
		                '</div>' +

                        '<div class="w2ui-label w2ui-span7">Bodega Solicitó: </div>' +
		                '<div class="w2ui-field w2ui-span7">' +
		                '	<select id="BodegaSolicito" name="BodegaSolicito" type="text" />' +
		                '</div>' +

                        '<div class="w2ui-label w2ui-span7">Incluir Detalle Transf: </div>' +
		                '<div class="w2ui-field w2ui-span7">' +
		                '	<input id="DetalleTransf" name="DetalleTransf" type="checkbox" />' +
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
                    { name: 'Establecimiento', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Reportes/Transferencias/EntreBodegas/DataRptTransferenciasBodegas.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=establecimientos'
                        }
                    },
                    { name: 'BodegaDespacho', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Reportes/Transferencias/EntreBodegas/DataRptTransferenciasBodegas.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=bodegas' + '&establecimiento=' + codEstablecimiento
                        }
                    },
                    { name: 'BodegaSolicito', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Reportes/Transferencias/EntreBodegas/DataRptTransferenciasBodegas.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=bodegas' + '&establecimiento=' + codEstablecimiento
                        }
                    },
                    { name: 'DetalleTransf', type: 'checkbox' }
	        ],
            actions: {
                imprimir: function () {

                    var FechaInicio = $("#Fecha_Inicio").val();
                    var FechaTermino = $("#Fecha_Termino").val();
                    var BodegaDespacho = $("#BodegaDespacho").val();
                    var BodegaSolicito = $("#BodegaSolicito").val();
                    var DetalleTransf = $('#DetalleTransf').prop("checked");

                    if (DetalleTransf == false) {

                        window.open('../../../reportes/Reportes/Transferencias/EntreBodegas/Report_TransfEntreBodegas.aspx?FechaInicio=' + FechaInicio + '&FechaTermino=' + FechaTermino + '&BodegaDespacha=' + BodegaDespacho + '&BodegaSolicita=' + BodegaSolicito + '&DetalleSN=' + 0);
                    } else {
                        window.open('../../../reportes/Reportes/Transferencias/EntreBodegas/Report_TransfEntreBodegasDetalle.aspx?FechaInicio=' + FechaInicio + '&FechaTermino=' + FechaTermino + '&BodegaDespacha=' + BodegaDespacho + '&BodegaSolicita=' + BodegaSolicito + '&DetalleSN=' + 1);
                    }
                },
                limpiar: function () {
                    this.clear();
                }
            },
            // Cambio en el Form.
            onChange: function (event) {

                // Al cambiar el establecimiento carga las bodegas pertenecientes al mismo
                if (event.target == 'Establecimiento') {

                    var fechaInicio = $('#Fecha_Inicio').val();
                    var fechaTermino = $('#Fecha_Termino').val();
                    var detalleTrasf = $('#DetalleTransf').val();
                    codEstablecimiento = $('#Establecimiento').val();

                    this.fields[3].options.url = '../../../clases/persistencia/controladores/Reportes/Transferencias/EntreBodegas/DataRptTransferenciasBodegas.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=bodegas' + '&establecimiento=' + codEstablecimiento;
                    this.fields[4].options.url = '../../../clases/persistencia/controladores/Reportes/Transferencias/EntreBodegas/DataRptTransferenciasBodegas.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=bodegas' + '&establecimiento=' + codEstablecimiento;

                    this.record = {
                        Fecha_Inicio: fechaInicio,
                        Fecha_Termino: fechaTermino,
                        Establecimiento: codEstablecimiento,
                        DetalleTransf: detalleTrasf
                    }

                    this.refresh();
                }

            }

        });
    </script>
</asp:Content>
