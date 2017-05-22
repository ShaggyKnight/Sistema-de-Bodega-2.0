<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="ConsolidadoMensualTransf.aspx.vb" Inherits="Bodega_WebApp.ConsolidadoMensualTransf" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportConsolidadoMensual%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="formRptConsolidadoMensual" style="margin-bottom:8px; height: 368px; width: 57%; top: 10px; margin-left: 20%;">
    </div>
</asp:Content>
<asp:Content ID="FooterContent" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="JavascriptContent" ContentPlaceHolderID="contenedorJavascript" runat="server">
<script type="text/javascript">
    var codEstablecimiento = 0;
    </script>
    <script type="text/javascript">
        $('#formRptConsolidadoMensual').w2form({
            name: 'formRptConsolidadoMensual',
            recid: 10,
            header: 'Consolidado Mensual de Traspasos entre Bodegas',
            formHTML:
	            '<div class="w2ui-page page-0">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303; margin-left: 4%;">General</div>' +
			        '<div class="w2ui-group" style="height: 228px;   width: 90%; margin-left: 5%;">' +

            // Mes Inicio
				        '<div class="w2ui-label w2ui-span7">Mes inicio: </div>' +
		                '<div class="w2ui-field w2ui-span7" >' +
                        '   <input name="mesInicio" type="text" maxlength="3" size="2"/>' +
		                '</div>' +

            //Mes Termino
				        '<div class="w2ui-label w2ui-span7">Mes Termino: </div>' +
		                '<div class="w2ui-field w2ui-span7">' +
                        '   <input name="mesTermino" type="text" maxlength="3" size="2"/>' +
		                '</div>' +

            //Año de busqueda
				        '<div class="w2ui-label w2ui-span7">Año: </div>' +
		                '<div class="w2ui-field w2ui-span7">' +
                        '   <input name="añoBusqueda" type="text" maxlength="5" size="4"/>' +
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
			       '</div>' +
		        '</div>' +
		        '<div class="w2ui-buttons">' +
		        '	<input type="button" value="Imprimir" name="imprimir">' +
		        '	<input type="button" value="Limpiar" name="limpiar">' +
                '</div>',
            fields: [
		            { name: 'mesInicio', type: 'int' },
                    { name: 'mesTermino', type: 'int' },
                    { name: 'añoBusqueda', type: 'int'},
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
                    }
	        ],
            actions: {
                imprimir: function () {

                    var mesIncio = $("#mesInicio").val();
                    var mesTermino = $("#mesTermino").val();
                    var añoBusqueda = $("#añoBusqueda").val();
                    var BodegaDespacho = $("#BodegaDespacho").val();
                    var BodegaSolicito = $("#BodegaSolicito").val();

                    window.open('../../../reportes/Reportes/Transferencias/ConsolidadoMensual/Report_ConsolidadoMensualTBod.aspx?mesIncio=' + mesIncio + '&mesTermino=' + mesTermino + '&añoBusqueda=' + añoBusqueda + '&BodegaDespacha=' + BodegaDespacho + '&BodegaSolicita=' + BodegaSolicito);
                    
                },
                limpiar: function () {
                    this.clear();
                }
            },
            // Cambio en el Form.
            onChange: function (event) {

                // Al cambiar el establecimiento carga las bodegas pertenecientes al mismo
                if (event.target == 'Establecimiento') {

                    var mesInicio = $("#mesInicio").val();
                    var mesTermino = $("#mesTermino").val();
                    var añoBusqueda = $("#añoBusqueda").val();
                    codEstablecimiento = $('#Establecimiento').val();

                    this.fields[4].options.url = '../../../clases/persistencia/controladores/Reportes/Transferencias/EntreBodegas/DataRptTransferenciasBodegas.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=bodegas' + '&establecimiento=' + codEstablecimiento;
                    this.fields[5].options.url = '../../../clases/persistencia/controladores/Reportes/Transferencias/EntreBodegas/DataRptTransferenciasBodegas.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=bodegas' + '&establecimiento=' + codEstablecimiento;

                    this.record = {
                        mesInicio: mesInicio,
                        mesTermino: mesTermino,
                        añoBusqueda: añoBusqueda,
                        Establecimiento: codEstablecimiento
                    }

                    this.refresh();
                }

            }

        });
    </script>
</asp:Content>
