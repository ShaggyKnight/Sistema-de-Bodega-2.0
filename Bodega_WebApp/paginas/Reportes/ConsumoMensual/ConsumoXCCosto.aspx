<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="ConsumoXCCosto.aspx.vb" Inherits="Bodega_WebApp.ConsumoXCCosto" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportConsumoMensualXCCosto%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:8px; height: 304px; width: 57%; margin-left: 20%; top: 15px; margin-bottom:8px;">
    </div>

    <div id="form2" style="height: 52px; background-color: rgb(245, 246, 247); width: 57%; margin-left: 20%;"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        /*  
          *Correcciones:
            Se disminuyo el tamaño del form para el ancho de los botones
            Correccion de TimeOut.
        */

        $('#form').w2form({
            name: 'form',
            style: 'background-color: #f5f6f7;', //#777 #f5f6f7
            recid: 10,
            url: '../../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
            header: 'Reporte Consumo Mensual x Centro Costo',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 488px; margin-left: 26px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 216px;">' +


            // Bodega
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 8px;">Bodega : </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Bodega" name="Nombre_Bodega" type="text" Style=" margin-left: -4%; width: 70%;"/>' +
		            '	</div>' + 


            // Opciones
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; width: 98px;">Opciones: </div>' +
                    '	<div class="w2ui-field" >' +
		            '	</div>' +


            //  Detalle de un Centro Costo
		            '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: -80px; margin-top: 14px; width: 36%;">Consumo de un Centro Costo </div>' +
                    '	<div class="w2ui-field" >' +
		            '	    <input name="1CC" class="form-control" type=checkbox style="margin-top: 11px; margin-left: 26%;"/>' +
                    '	</div>' +

            //  Todos los Policlinicos
                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 28px; margin-top: 8px; width: 36%; ">Todos los Policlinicos </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<input name="TodosPolicli" class="form-control" type=checkbox style="margin-top: 5px; margin-left: 32%;"/>' +
		            '	</div>' +

            //  Todos los Pabellones (Sin Maternidad)
                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 28px; margin-top: 8px; width: 48%; ">Todos los Pabellones (Sin Maternidad) </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<input name="TodosPabellones" class="form-control" type=checkbox style="margin-top: 5px; margin-left: 38%;"/>' +
		            '	</div>' +


            //  Nombre Centro Costo
				    '<div class="w2ui-label w2ui-span4" style="margin-top: 3%; margin-left: 7px; width: 122px;">Selec. Centro Costo: </div>' +
				    '<div class="w2ui-field w2ui-span4">' +
					'       <select id="Nombre_CentroC" name="Nombre_CentroC" type="text" style="margin-left: 3%; margin-top: 1%;" disabled />' +
				    '</div>' +

			       '</div>' +
		        '</div>' +

              '</div>'
                    ,
            fields: [

                    { name: 'Nombre_Bodega', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getLista.ashx',
                            showNone: true
                        }
                    },

                    { name: '1CC', type: 'checkbox' },
                    { name: 'TodosPolicli', type: 'checkbox' },
                    { name: 'TodosPabellones', type: 'checkbox' },

                    {name: 'Nombre_CentroC', type: 'list',
                    options: {
                        url: '../../../clases/persistencia/controladores/Reportes/Despacho/DespachoXPauta/getListaCentroCosto.ashx',
                        showNone: true
                    }
                }
	            ],
            onChange: function (event) {

                console.log(event);


                if (event.target == "1CC") {
                    if ($("#1CC")[0].checked) {
                        $('#Nombre_CentroC').prop('disabled', false);
                        $("#TodosPolicli").prop('checked', false)
                        $("#TodosPabellones").prop('checked', false)
                    } else {
                        $('#Nombre_CentroC').prop('disabled', true);
                    }
                }

                if (event.target == "TodosPolicli") {
                    if ($("#R1CC").checked) {
                        $('#Nombre_CentroC').prop('disabled', true);
                        $("#1CC").prop('checked', false)
                        $("#TodosPabellones").prop('checked', false)
                    } else {
                        $('#Nombre_CentroC').prop('disabled', true);
                        $("#1CC").prop('checked', false)
                        $("#TodosPabellones").prop('checked', false)
                    }
                }

                if (event.target == "TodosPabellones") {
                    if ($("#R1CC").checked) {
                        $('#Nombre_CentroC').prop('disabled', true);
                        $("#1CC").prop('checked', false)
                        $("#TodosPolicli").prop('checked', false)
                    } else {
                        $('#Nombre_CentroC').prop('disabled', true);
                        $("#1CC").prop('checked', false)
                        $("#TodosPolicli").prop('checked', false)
                    }
                }

            },
            onLoad: function (event) {

            }

        });    // Fin Form1


        // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: 'background-color: #f5f6f7',
            formHTML:
            '</div>' +
		        '<div class="w2ui-buttons">' +
		        '	<input type="button" value="Imprimir" name="imprimir">' +
		        '	<input type="button" value="Limpiar" name="limpiar">' +

                '</div>' +
		        '</div>',
            actions: {

                "limpiar": function () {
                    w2ui['form'].clear();
                    w2ui['form'].refresh();
                },
                "imprimir": function () {

                    var bodega = w2ui['form'].record.Nombre_Bodega;
                    var opcion1 = $("#1CC")[0].checked;
                    var opcion2 = $("#TodosPolicli")[0].checked;
                    var opcion3 = $("#TodosPabellones")[0].checked;
                    var opcion3 = $("#TodosPabellones")[0].checked;
                    var centroCosto = w2ui['form'].record.Nombre_CentroC;


                    if (bodega) {

                        if (opcion2 || opcion3 || opcion1) {

                            /* Opcion 1 - Detalle de un Centro Costo */
                            if (opcion1) {
                                if (centroCosto) {
                                    window.open('../../../reportes/Reportes/ConsumoMensual/ConsumoXCCosto/Report_ConsumoXCCosto.aspx?Bodega=' + bodega + '&TipoInforme=' + '0' + '&CentroCosto=' + centroCosto);
                                } else {
                                    alert("Error, Se debe definir un CENTRO DE COSTO")
                                }
                            }

                            /* Opcion 2 - Todos los Policlinicos */
                            if (opcion2) {
                                window.open('../../../reportes/Reportes/ConsumoMensual/ConsumoXCCosto/Report_ConsumoXCCosto.aspx?Bodega=' + bodega + '&TipoInforme=' + '2' + '&CentroCosto=' + 'no');
                            }

                            /* Opcion 3 - Todos los Pabellones (Sin Maternidad) */
                            if (opcion3) {
                                window.open('../../../reportes/Reportes/ConsumoMensual/ConsumoXCCosto/Report_ConsumoXCCosto.aspx?Bodega=' + bodega + '&TipoInforme=' + '1' + '&CentroCosto=' + 'no');
                            }

                        } else {
                            alert("Error, Se debe definir una OPCION de reporte")
                        } // fin if, Opciones

                    } else {
                        alert("Error, Se deben definir el periodo de BODEGA ")
                    } // fin if, Bodega
                }
            },
            onLoad: function (event) {

            }
        });


        // console.log(response);
    </script>
</asp:Content>
