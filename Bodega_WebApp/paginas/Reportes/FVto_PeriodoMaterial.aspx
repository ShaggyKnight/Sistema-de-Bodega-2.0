<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="FVto_PeriodoMaterial.aspx.vb" Inherits="Bodega_WebApp.FVto_PeriodoMaterial" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportFVtoXPeriodoMaterial%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:8px; height: 240px; width: 57%; margin-left: 20%; top: 10px; margin-bottom:8px;">
    </div>

    <div id="form2" style="height: 52px; background-color: rgb(245, 246, 247); width: 57%; margin-left: 20%;"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">
        var codBodega = 0;
    </script>
    <script type="text/javascript">

        /*  
          *Correcciones:
           Se disminuyo el tamaño del form para el ancho de los botones
           Se saco el borde quitando el border en la declaración
           Correccion de TimeOut.
        */

        $('#form').w2form({
            name: 'form',
            style: 'background-color: #f5f6f7;', //#777 #f5f6f7
            recid: 10,
            header: 'Fecha Vencimiento Periodo - Material',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 488px; margin-left: 26px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 150px;">' +

            // Fecha Inicio
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; width: 98px;">Fecha Inicio: </div>' +
		            '	<div class="w2ui-field" >' +
                    '   <input name="Fecha_Inicio" type="text" maxlength="100" size="16" id="field_date" placeholder="dd/mm/yyyy" class="w2field" style="box-sizing: border-box;" onkeypress="return justFecha(event);">' +
		            '	</div>' +

            //Fecha Termino
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; width: 98px;">Fecha Termino: </div>' +
		            '	<div class="w2ui-field" >' +
                    '   <input name="Fecha_Termino" type="text" maxlength="100" size="16" id="field_date" placeholder="dd/mm/yyyy" class="w2field" style="box-sizing: border-box;" onkeypress="return justFecha(event);">' +
		            '	</div>' +

				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Bodega: </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Bodega" name="Nombre_Bodega" type="text" />' +
		            '	</div>' +

                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 10px;">Materiales: </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Materiales" name="Nombre_Materiales" type="text" style="width: 92%;"/>' +
		            '	</div>' +

			       '</div>' +
		        '</div>' +

              '</div>'
                    ,
            fields: [

		            { name: 'Fecha_Inicio', type: 'date' },
                    { name: 'Fecha_Termino', type: 'date' },

                    { name: 'Nombre_Bodega', type: 'list',
                        options: {
                            url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getLista.ashx',
                            showNone: true
                        }
                    },
                    { name: 'Nombre_Materiales', type: 'list',
                        options: {
                            url: '../../clases/persistencia/controladores/Reportes/FVto_PeriodoMaterial/getListaMateriales_FVto_PeriMate.ashx?CodBodega=' + codBodega,
                            showNone: true
                        }
                    }
	        ],
            // Cambio en el Form.
            onChange: function (event) {

                // Al cambiar la bodega carga las bodegas pertenecientes al mismo
                if (event.target == 'Nombre_Bodega') {

                    var fechaInicio = $('#Fecha_Inicio').val();
                    var fechaTermino = $('#Fecha_Termino').val();
                    codBodega = $('#Nombre_Bodega').val();
                    var codMaterial = $('#Nombre_Materiales').val();

                    this.fields[3].options.url = '../../clases/persistencia/controladores/Reportes/FVto_PeriodoMaterial/getListaMateriales_FVto_PeriMate.ashx?CodBodega=' + codBodega;

                    this.record = {
                        Fecha_Inicio: fechaInicio,
                        Fecha_Termino: fechaTermino,
                        Nombre_Bodega: codBodega,
                        Nombre_Materiales: codMaterial
                    }

                    this.refresh();
                }

            },
            //-------------------------
            onLoad: function (event) {

            }

        });   // Fin Form1


        // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: 'background-color: #f5f6f7',
            formHTML:
            '</div>' +
		        '<div class="w2ui-buttons">' +
		        '	<input type="button" value="Imprimir" name="imprimir">' +
                //'	<input type="button" id="id_BOT" value="Busca Proveedor" onclick="openPopup2()" name="buscar2" style="width: 116px;" disabled >' +
		        '	<input type="button" value="Limpiar" name="limpiar">' +

                '</div>' +
		        '</div>',
            actions: {

                "limpiar": function () {
                    w2ui['form'].clear();
                    w2ui['form'].record['factorTransferencia'] = 30;
                    w2ui['form'].refresh();
                },
                "imprimir": function () {

                    var fechaInicio = w2ui['form'].record.Fecha_Inicio;
                    var fechaTermino = w2ui['form'].record.Fecha_Termino;
                    var bodega = w2ui['form'].record.Nombre_Bodega;
                    var material = w2ui['form'].record.Nombre_Materiales;

                    if (fechaInicio && fechaTermino) {

                        if (bodega && material) {

                            window.open('../../reportes/Reportes/FVto_PeriodoMaterial/Report_FVto_PeriodoMaterial.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&Material=' + material );

                        } else {
                            alert("Error, Se debe definir la BODEGA y el MATERIAL ")
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


        /*

                // Caso 1 : Cambio de Bodega con o sin Material
                if (event.target == 'Nombre_Bodega' && event.value_new) {

                    if (w2ui['form'].record['Nombre_Materiales'] && event.value_new != "%") {

                        // Divide Cadena.
                        var bodega1 = event.value_new;
                        var material1 = w2ui['form'].record['Nombre_Materiales'];

                        var div_bodega = bodega1.split("-");
                        var div_material = material1.split("-");
                        var material2 = div_material[0] + "-" + div_material[1];

                        // =============================
                        // Prueba material bodega.
                        // =============================
                        $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Reportes/BinCard/busca_Bodega_Material_Bincard.ashx",
                            async: false,
                            data: { "bodega": div_bodega[0], "material": material2, "tipoBusqueda": 'PExistencia' },
                            dataType: "json",
                            success: function (response) {

                                if (response.item == "null") {

                                    alert('¡Error, BD!')

                                } else {
                                    var existe = parseInt(response.existe)

                                    if (existe == 1) {
                                    }

                                    if (existe == 2) {
                                        alert('¡ Material No Existe en la Bodega 2. !')
                                        //w2ui['form'].reload();
                                    }

                                } // Fin Validador de codigo

                            } // Fin success
                        }); // fin ajax

                    } else {
                                //alert("aun no existe material")
                    } // fin Material.
                } // fin Bodega.

                // Caso 2 : Cambio de Materiales con o sin Bodega.
                if (event.target == 'Nombre_Materiales' && event.value_new != "%") {

                    if (w2ui['form'].record['Nombre_Bodega']) {

                        // Divide Cadena.
                        var bodega1 = w2ui['form'].record['Nombre_Bodega'];
                        var material1 = event.value_new;

                        var div_bodega = bodega1.split("-");
                        var div_material = material1.split("-");
                        var material2 = div_material[0] + "-" + div_material[1];

                        // =============================
                        // Prueba material bodega.
                        // =============================
                        $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Reportes/BinCard/busca_Bodega_Material_Bincard.ashx",
                            async: false,
                            data: { "bodega": div_bodega[0], "material": material2, "tipoBusqueda": 'PExistencia' },
                            dataType: "json",
                            success: function (response) {

                                if (response.item == "null") {

                                    alert('¡Error, BD!')

                                } else {
                                    var existe = parseInt(response.existe)

                                    if (existe == 1) {
                                    }

                                    if (existe == 2) {
                                        alert('¡ Material No Existe en la Bodega. !');
                                    }

                                 } // Fin Validador de codigo

                            } // Fin success
                        }); // fin ajax

                    } else {
                        //alert("aun no existe bodega")
                    } // fin Material.
                } // fin Bodega.        
        */
    </script>
</asp:Content>

