<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="DespachoXServicio.aspx.vb" Inherits="Bodega_WebApp.DespachoXServicio" %>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reporXServicio%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:8px; height: 302px; width: 54%; margin-left: 20%; margin-top: 10px;">
    </div>

    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247); width: 54%; margin-left: 20%;"></div>

</asp:Content> 
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        /*  
          *Correcciones:
            Se disminuyo el tamaño del form para el ancho de los botones
            Correccion de TimeOut para los 2 modos, Resumen y Detalle.
        */

        $('#form').w2form({
            name: 'form',
            style: 'background-color: #f5f6f7;', //#777 #f5f6f7
            recid: 10,
            url: '../../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
            header: 'Reporte Despacho X Servicio',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 488px; margin-left: 26px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 214px;">' +

            // Fecha Inicio
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; width: 98px;">Fecha Inicio: </div>' +
		            '	<div class="w2ui-field" >' +
                    '   <input name="Fecha_Inicio" type="text" maxlength="100" size="16" id="field_date" placeholder="dd/mm/yyyy" class="w2field" style="box-sizing: border-box;" onkeypress="return justFecha(event);">' +
		            '	</div>' +

            //Fecha Termino
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; width: 98px;">Fecha Termino: </div>' +
		            '	<div class="w2ui-field" >' +
                    '   <input name="fechaServidor" type="text" maxlength="100" size="16" id="field_date" placeholder="dd/mm/yyyy" class="w2field" style="box-sizing: border-box;" onkeypress="return justFecha(event);">' +
		            '	</div>' +


            // Opciones
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; width: 98px;">Opciones: </div>' +
                    '	<div class="w2ui-field" >' +
		            '	</div>' +


        //     Detalle de un Centro Costo
		            '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: -80px; margin-top: 14px; width: 36%;">Detalle de un Centro Costo </div>' +
                    '	<div class="w2ui-field" >' +
		            '	    <input name="DCC" class="form-control" type=checkbox style="margin-top: 11px; margin-left: 15%;"/>' +
                    '	</div>' +

        //     Resumen un Centro Costo
                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 28px; margin-top: 8px; width: 36%; ">Resumen de un Centro Costo </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<input name="R1CC" class="form-control" type=checkbox style="margin-top: 5px; margin-left: 26%;"/>' +
		            '	</div>' +

//        //     Resumen TODOS los Centro Costo
//				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 28px; width: 46%; margin-top: 8px;">Resumen de Todos los Centro Costo </div>' +
//		            '	<div class="w2ui-field" >' +
//		            '		<input name="R_ALLCC" class="form-control" type=checkbox style="margin-top: 5px; margin-left: 30%;"/>' +
//		            '	</div>' +


				    '<div class="w2ui-label w2ui-span4" style="margin-top: 3%; margin-left: 7px; width: 122px;">Selec. Centro Costo: </div>' +
				    '<div class="w2ui-field w2ui-span4">' +
					'       <select id="Nombre_CentroC" name="Nombre_CentroC" type="text" style="margin-left: 3%; margin-top: 1%;" disabled />' +
				    '</div>' +

//                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 18px; width: 36%;">Opciones: </div>' +
//                        '<div style="margin-top: 9%;">' +
//                        '       <input id="Opciones1" name="Opciones" type="radio" value="1" style="margin-left: -26%;"/>' + '  Detalle de un Centro Costo' +
//                        '</div>' +
//                        '<div>' +
//                        '       <input id="Opciones2" name="Opciones" type="radio" value="2" style="margin-top: 2%; margin-left: 12%;"/>' + '  Resumen de un Centro Costo' +
//                        '</div>' +
//                        '<div>' +
//                        '       <input id="Opciones3" name="Opciones" type="radio" value="3" style="margin-top: 2%; margin-left: 12%;"/>' + '  Resumen de Todos los Centro Costo' +
//                        '</div>' +


			       '</div>' +
		        '</div>' +

              '</div>'
                    ,
            fields: [

		            { name: 'Fecha_Inicio', type: 'date' },
                    { name: 'fechaServidor', type: 'date' },

                    { name: 'DCC', type: 'checkbox' },
                    { name: 'R1CC', type: 'checkbox' },
//                    { name: 'R_ALLCC', type: 'checkbox' },

                    { name: 'Nombre_CentroC', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Reportes/Despacho/DespachoXPauta/getListaCentroCosto.ashx',
                            showNone: true
                        }
                    }
	            ],
            onChange: function (event) {

                console.log(event);


                if (event.target == "DCC") {
                    if ($("#DCC")[0].checked) {
                        $('#Nombre_CentroC').prop('disabled', false);
                        $("#R1CC").prop('checked', false)
                        $("#R_ALLCC").prop('checked', false)
                    } else {
                        $('#Nombre_CentroC').prop('disabled', true);
                    }
                }

                if (event.target == "R1CC") {
                    if ($("#R1CC")[0].checked) {
                        $('#Nombre_CentroC').prop('disabled', false);
                        //$("#R1CC")[0].checked)
                        $("#DCC").prop('checked',false)
                        $("#R_ALLCC").prop('checked', false)
                    } else {
                        $('#Nombre_CentroC').prop('disabled', true);
                    }
                }

//                if (event.target == "R_ALLCC") {
//                    if ($("#R_ALLCC")[0].checked) {
//                        $('#Nombre_CentroC').prop('disabled', true);
//                        $("#DCC").prop('checked', false)
//                        $("#R1CC").prop('checked', false)
//                    } else {
//                        $('#Nombre_CentroC').prop('disabled', true);
//                    }
//                }
            },
            onLoad: function (event) {

            }

        });    // Fin Form1


        // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: 'border: 0px; background-color: #f5f6f7',
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

                    var fechaInicio = w2ui['form'].record.Fecha_Inicio;
                    var fechaTermino = w2ui['form'].record.fechaServidor;
                    var opcion3 = $("#DCC")[0].checked;
                    var opcion2 = $("#R1CC")[0].checked;
//                    var opcion1 = $("#R_ALLCC")[0].checked;
                    var centroCosto = w2ui['form'].record.Nombre_CentroC;


                    if (fechaInicio && fechaTermino) {

                        if (opcion2 || opcion3) {

//                            /*  opcion 1 */
//                            if (opcion1) {
//                                alert(' 1 ' + 'resumen all no cc')
//                                window.open('../../../reportes/Reportes/Despacho/DespachoXServicio/Resumen Todos CC/Report_DespaXServicio_ALLCC.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&TipoInforme=' + '1' + '&CentroCosto=' + 'noSelect');

//                            } else {

                                /* Opcion 3 - Detalle, reporte diferente */
                                if (opcion3) {
                                    if (centroCosto) {
                                        window.open('../../../reportes/Reportes/Despacho/DespachoXServicio/DespachoXServicio_D1CC/Report_DespaXServicio_D1CC.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&TipoInforme=' + '3' + '&CentroCosto=' + centroCosto);
                                    } else {
                                        alert("Error, Se debe definir un CENTRO DE COSTO")
                                    }
                                }

                                /* Opcion 2 - Resumen 1 CC */
                                if (opcion2) {
                                    if (centroCosto) {
                                        window.open('../../../reportes/Reportes/Despacho/DespachoXServicio/DespachoXServicio_R1CC/Report_DespaXServicio_R1CC.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&TipoInforme=' + '2' + '&CentroCosto=' + centroCosto);
                                    } else {
                                        alert("Error, Se debe definir un CENTRO DE COSTO")
                                    }
                                }

                        } else {
                            alert("Error, Se debe definir una de las dos opciones de reporte")
                        } // fin if, bodega && estado

                    } else {
                        alert("Error, Se deben definir el periodo de INICIO y TERMINO ")
                    } // fin if, fechaInicio && fechaTermino
                }
            },
            onLoad: function (event) {

            }
        });

        function justFecha(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 46) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;

            return /\d/.test(String.fromCharCode(keynum));
        } 

        // console.log(response);
    </script>
</asp:Content>
