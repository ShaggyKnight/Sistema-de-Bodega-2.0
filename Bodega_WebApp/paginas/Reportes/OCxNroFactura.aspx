<%@ Page Title="Página principal" Language="vb" MasterPageFile="~/Site.Master" AutoEventWireup="false" 
CodeBehind="OCxNroFactura.aspx.vb" Inherits="Bodega_WebApp.OCxNroFactura" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportOCxFactura%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" class="col-lg-12" style="margin-top: 2px; margin-bottom:6px; height: 180px">
    </div>
    <div id="grid" style="width: 100%; height: 260px;">
    </div>
    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247);"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        $('#form').w2form({
            name: 'form',
            style: 'background-color: #f5f6f7;',
            recid: 10,
            url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
            header: 'Reporte OC por Nº Factura',
            formHTML:
                '<div id="form" style="width: 500px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 300px; margin-left: 32px; float: left;">' +
			        
                    '<div style="padding: 3px; font-weight: bold; color: #030303;">Solicitud de Reporte</div>' +
			        
                    '<div class="w2ui-group" style="height: 100px;">' +

				    '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px; margin-top: 16px;">Nº Factura:</div>' +
				    '<div class="w2ui-field w2ui-span5">' +
					    '<input name="NroFactura" id="NroFactura" type="text" maxlength="100" style="width: 50%; margin-top: 12px;" onkeypress="return justNumber(event);"/>' +
				    '</div>' +

				    '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px; margin-top: 14px;">Periodo:</div>' +
		            '	<div class="w2ui-field w2ui-span5" >' +
		            '		<select name="Periodos" id="Periodos" type="text" style="width: 56%; margin-top: 4px; "/>' +
		            '	</div>' +

			        '</div>' +
		        '</div>' +

		        '<div style="margin-left: 400px; width: 340px; width: 268px;">' +
                    '<div style="padding: 3px; font-weight: bold; color: #030303;">Info. General</div>' +
			        '<div class="w2ui-group" style="height: 100px;">' +

				        '<div class="w2ui-label w2ui-span5" style="margin-top: 18px; text-align: left; margin-left: 12px;">Fecha</div>' +
				        '<div class="w2ui-field w2ui-span5">' +
					        '<input name="fechaServidor" type="text" maxlength="100" style="width: 70%; margin-top: 9px; margin-left: 15px; " disabled/>' +
				        '</div>' +

				        '<div class="w2ui-label w2ui-span5" style="width: 104px; margin-left: 13px; text-align: left; margin-top: 16px;">Periodo Actual</div>' +
				        '<div class="w2ui-field w2ui-span5">' +
				            '<input name="anioDonacion" type="text" maxlength="100" style="width: 70%; margin-left: 10px; margin-top: 4px;" disabled/>' +
				        '</div>' +

			      '</div>' +
		        '</div>' +

              '</div>'
                    ,
            fields: [
                    { name: 'NroFactura', type: 'text' },
            		{ name: 'Periodos', type: 'list',
            		    options: {
            		        url: '../../clases/persistencia/controladores/Reportes/BinCard/getListaPeriodos_BincardGeneral.ashx',
            		        showNone: true
            		    }
            		},
		            { name: 'fechaServidor', type: 'text' },
                    { name: 'anioDonacion', type: 'text' }
	            ],
            onLoad: function (event) {
                console.log(event);
            }
        }); // Fin Form1


        $('#grid').w2grid({
            name: 'grid',
            header: 'Lista de Materiales',
            show: {
                header: true,
                toolbarDelete: false,
                toolbarSave: false,
                toolbar: false,
                footer: true
            },
            multiSearch: false,
            searches: [
			        { type: 'text', field: 'codMaterial', caption: 'Codigo Material' },
		        ],
            columns: [
			        { field: 'NroOC', caption: 'Nº OC', size: '10%' },
			        { field: 'NroRecep', caption: 'Nº Recepción', size: '10%' },
                    { field: 'periodoRecep', caption: 'Periodo', size: '10%' },
			        { field: 'fechaRecep', caption: 'Fecha', size: '10%' },
                    { field: 'descripcion', caption: 'Descripción', size: '30%' },
                    { field: 'Proveedor', caption: 'Proveedor', size: '30%' }
		        ]
        });

        // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: 'border: 0px; background-color: #f5f6f7',
            formHTML:
                '</div>' +
		            '<div class="w2ui-buttons">' +
		            '	<input type="button" value="Buscar OC" name="buscar" style="width: 90px;">' +
                    '	<input type="button" value="Imprimir" name="imprimir">' +
		            '	<input type="button" value="Limpiar" name="limpiar">' +
                    '</div>' +
		            '</div>',
            actions: {

                "buscar": function () {

                    if ($("#NroFactura").val() == '' && $("#Periodos").val() == '') {
                        w2alert("<b>Faltan Datos!</b><p>Ingrese el monto de la factura y el periodo", "¡Alerta!", function (answer) {
                            $("#NroFactura").focus();
                        });
                    } else {
                        w2ui.grid.url = '../../clases/persistencia/controladores/Recepciones/DesdeProveedores/BusquedaRECPorUp.ashx?NroFactura=' + $("#NroFactura").val() + '&Periodo=' + $("#Periodos").val() + '&criterioBusqueda=OCxNroFactura';
                        w2ui.grid.reload();
                    }

                },
                /*===================================*/

                "limpiar": function () {
                    // Pagina Principal
                    w2ui['grid'].clear();
                    w2ui['form'].reload();

                    setTimeout(function () {
                        $("#NroFactura").focus();
                    }, 400);

                },
                /*===================================*/

                "imprimir": function () {

                    if (w2ui['grid'].records.length > 0 && w2ui['grid'].getSelection() > 0) {

                        $.ajax({
                            url: '../../clases/persistencia/controladores/GeneraInforme.ashx?',
                            type: 'POST',
                            dataType: "json",
                            data: { cmd: 'New_RPT_NroFacXOC', periodo: w2ui['grid'].records[w2ui['grid'].getSelection() - 1].periodoRecep, NroOC: w2ui['grid'].records[w2ui['grid'].getSelection() - 1].NroOC, NroRecep: w2ui['grid'].records[w2ui['grid'].getSelection() - 1].NroRecep },
                            success: function (response) {
                                if (response.status == 'error') {
                                    w2alert(response.message);
                                } else {
                                    window.open('../../reportes/Recepciones/DesdeProveedores/Rpt_RecepcionDesdeProveedores_Report.aspx?CmvCodigo=' + response.cmvNumero + '&PerCodigo=' + response.periodo + '&TMVCodigo=' + response.tmvCodigo + '&usuario=' + '' + '&nombreReport=' + 'Informe_Recepción_Desde_Proveedores');
                                }
                            },
                            error: function (response) {
                                alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                            }
                        });

                    } else {

                        w2alert("<b>Faltan Datos!</b><p>Primero realice una Búsqueda y luego seleccione una OC que desea imprimir.", "¡Alerta!", function (answer) {
                            $("#NroFactura").focus();
                        });

                    }

                } // fin imprimir

            }
        });

        function justFecha(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 46) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;
            else
                return true;
        }

        /* solo permite el ingreso de numeros */
        function justNumber(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 45) || (KeyAscii >= 46) && (KeyAscii <= 47) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;
            else
                return true;
        }    

        // console.log(response);
 
    </script>
</asp:Content>
