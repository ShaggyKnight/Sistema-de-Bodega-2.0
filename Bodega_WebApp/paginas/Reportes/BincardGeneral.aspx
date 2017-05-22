<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="BincardGeneral.aspx.vb" Inherits="Bodega_WebApp.BincardGeneral" %>


<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportBincardGeneral%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:3px; height: 260px; margin-bottom: 4px; margin-top: 2px;">
    </div>
    <div id="form2" style="height: 52px; margin-top: -2px; border: 0px; background-color: rgb(245, 246, 247);">
    </div>
    <div id="grid" style="width: 100%; height: 320px; margin-top: 2px;">
    </div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">
        var codBodega = 0;
    </script>
    <script type="text/javascript">

        /*  

          *Solicitudes:

          *Correcciones:
            Correccion de TimeOut.
            Correccion para limpiar tabla temp (con atributo FLD_TIMESTAMP).
            Se reparo el correlativo.

        */

        var Global_ID = 0;
        var Global_Bodega;
        var Global_Material;

        $('#form').w2form({
            name: 'form',
            header: 'BINCARD',
            style: 'background-color: #f5f6f7;',
            recid: 10,
            url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 474px; margin-left: 20px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">Consulta Bincard</div>' +
			        '<div class="w2ui-group" style="height: 184px;">' +

				    '   <div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; width: 98px;">Establecimiento</div>' +
		            '	<div class="w2ui-field w2ui-span5" >' +
		            '		<select name="Nombre_Establecimiento" type="list" style="width: 92%; " />' +
		            '	</div>' +

				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 10px;">Bodega</div>' +
		            '	<div class="w2ui-field w2ui-span5" >' +
		            '		<select name="Nombre_Bodega" type="text" style="margin-top: 4px; "/>' +
            		'	</div>' +

                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 13px; width: 88px;">Lista Materiales</div>' +
		            '	<div class="w2ui-field w2ui-span5" >' +
		            '		<select name="Nombre_Materiales" type="text" style="margin-top: 4px; width: 92%;"/>' +
		            '	</div>' +
            /* nuevo, material x ingreso manual */
				    '<div class="w2ui-label w2ui-span4" style="margin-top: 2%; margin-left: -20px;">*Material</div>' +
				    '   <div class="w2ui-field w2ui-span5">' +
					'       <input id="CodMaterial_Manual" name="CodMaterial_Manual" type="text" maxlength="10" style="width: 26%; " onkeypress="return justCodigo(event);"/>' +
				    '   </div>' +

				    '<div class="w2ui-label w2ui-span4" style="margin-top: 2%; text-align: left; margin-left: 10px;">Periodo</div>' +
		            '	<div class="w2ui-field w2ui-span5" >' +
		            '		<select name="Periodos" type="text" style="width: 26%; "/>' +
		            '	</div>' +
			      '</div>' +

		        '</div>' +

		        '<div style="margin-left: 516px; width: 340px; width: 268px;">' +
			      '<div style="padding: 3px; font-weight: bold; color: #030303;">Info. General</div>' +
			        '<div class="w2ui-group" style="height: 120px;">' +
				    '<div class="w2ui-label w2ui-span5" style="margin-top: 22px; text-align: left; margin-left: 12px;">Fecha</div>' +
				    '<div class="w2ui-field w2ui-span5">' +
					    '<input name="fechaServidor" type="text" maxlength="100" style="width: 70%; margin-top: 13px; margin-left: 15px; " disabled/>' +
				    '</div>' +
				    '<div class="w2ui-label w2ui-span5" style="width: 104px; margin-left: 13px; text-align: left; margin-top: 14px;">Periodo Actual</div>' +
				    '<div class="w2ui-field w2ui-span5">' +
				    '	<input name="anioDonacion" type="text" maxlength="100" style="width: 70%; margin-left: 10px; margin-top: 4px;" disabled/>' +
				    '</div>' +
			      '</div>' +
		        '</div>' +
              '</div>'
                    ,
            fields: [
                    { name: 'Nombre_Establecimiento', type: 'list',
                        options: {
                            url: '../../clases/persistencia/controladores/StockEmergencia/getListaEstablecimientos_StockEmergencia.ashx',
                            //url: '../../../clases/persistencia/controladores/Reportes/Transferencias/EntreBodegas/DataRptTransferenciasBodegas.ashx?tipoBusqueda=cargaDatos' + '&indentificadorBusqueda=establecimientos',
                            showNone: true
                        }
                    },
                    { name: 'Nombre_Bodega', type: 'list',
                        options: {
                            url: '../../clases/persistencia/controladores/Reportes/BinCard/getListaBodegas_Bincard.ashx',
                            showNone: true
                        }
                    },

            		{ name: 'Nombre_Materiales', type: 'list',
            		    options: {
            		        url: '../../clases/persistencia/controladores/Reportes/BinCard/getListaMateriales_BincardGeneral.ashx?CodBodega=' + codBodega,
            		        showNone: true
            		    }
            		},

            		{ name: 'Periodos', type: 'list',
            		    options: {
            		        url: '../../clases/persistencia/controladores/Reportes/BinCard/getListaPeriodos_BincardGeneral.ashx',
            		        showNone: true
            		    }
            		},

                    { name: 'CodMaterial_Manual', type: 'text' },
		            { name: 'fechaServidor', type: 'text' },
                    { name: 'anioDonacion', type: 'text' }


	            ],
            // Cambio en el Form.
            onChange: function (event) {

                // Al cambiar la bodega carga las bodegas pertenecientes al mismo
                if (event.target == 'Nombre_Bodega') {

                    var CodEstablecimiento = $('#Nombre_Establecimiento').val();
                    codBodega = $('#Nombre_Bodega').val();
                    var codMaterial = $('#Nombre_Materiales').val();
                    var periodo = $('#Periodos').val();

                    var fechaActual = $('#fechaServidor').val();
                    var periodoActual = $('#anioDonacion').val();

                    var div_bodega = codBodega.split("-");

                    this.fields[2].options.url = '../../clases/persistencia/controladores/Reportes/BinCard/getListaMateriales_BincardGeneral.ashx?CodBodega=' + div_bodega[0];

                    this.record = {
                        Nombre_Establecimiento: CodEstablecimiento,
                        Nombre_Bodega: codBodega,
                        Nombre_Materiales: codMaterial,
                        Periodos: periodo,
                        fechaServidor: fechaActual,
                        anioDonacion: periodoActual
                    }

                    this.refresh();
                }

                /* Cambio de Materiales.*/
                if (event.target == 'CodMaterial_Manual') {

                    //alert(w2ui['form'].record.CodMaterial_Manual);
                    //alert(w2ui['form'].record.Nombre_Bodega);

                    if (w2ui['form'].record.Nombre_Bodega) {

                        if (event.value_new != "") {
                            // Divide Cadena.
                            var bodega1 = $('#Nombre_Bodega').val();
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
                                            $('#CodMaterial_Manual').val('');
                                            //w2ui['form'].reload();
                                        }

                                    } // Fin Validador de codigo

                                } // Fin success
                            }); // fin ajax
                        }

                    } else {
                        $('#CodMaterial_Manual').val('');
                        alert("Primero ingrese la bodega!.");
                    } // fin Material.

                } // fin Bodega.        

            },
            //-------------------------
            onLoad: function (event) {
                console.log(event);
            }
        });           // Fin Form1

        //==============================


        $('#grid').w2grid({
            name: 'grid',
            header: 'Bincard General',
            show: {
                header: true,
                toolbarSave: true,
                toolbar: true,
                footer: true
            },
            multiSearch: false,
            searches: [
			        { type: 'text', field: 'recid', caption: 'Codigo Material' },
		        ],
            columns: [
			        { field: 'fecha', caption: 'Fecha', size: '90px', type: 'date' },
			        { field: 'TipoMov', caption: 'Tipo Mov.', size: '140px' },
			        { field: 'NDocumento', caption: 'N° Doc.', size: '80px' },
                    { field: 'valorNeto', caption: 'Precio Neto', size: '90px' },
                    { field: 'fisicoEntrada', caption: 'Físico Entrada', size: '90px' },
                    { field: 'salida', caption: 'Salida', size: '80px' },
                    { field: 'saldo', caption: 'Saldo', size: '80px' },
                    { field: 'valorEntrada', caption: 'Val. Entrada', size: '90px' },
                    { field: 'salidaE', caption: 'Salida', size: '80px' },
                    { field: 'saldoE', caption: 'Saldo', size: '80px' },
                    { field: 'precioPonderado', caption: 'Precio Ponderado Medio', size: '140px' },
                    { field: 'observacion', caption: 'Observación', size: '200px' },
                    { field: 'codItem', caption: 'Cod. Item', size: '120px' },
                    { field: 'descripcionItem', caption: 'Descripción Item', size: '140px' },
		        ],

            // Agrega un nuevo elemento.
            onAdd: function (event) {

            },

            // Cambio en la grilla.
            onChange: function (event) {

            },
            //-------------------------

            onSave: function (event) {

            }
            // ===========================
        });

        // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: 'border: 0px; background-color: #f5f6f7',
            formHTML:
                '</div>' +
		            '<div class="w2ui-buttons">' +
		            '	<input type="button" value="Procesar" name="procesar">' +
                    '	<input type="button" value="Imprimir" name="imprimir">' +
                    '	<input type="button" value="Limpiar" name="limpiar">' +
                    '</div>' +
		            '</div>',
            actions: {

                "procesar": function () {
                    
                    if (w2ui['form'].record['Nombre_Materiales'] || w2ui['form'].record['CodMaterial_Manual']) {
                        if (w2ui['form'].record['Nombre_Bodega'] && w2ui['form'].record['Periodos'] && w2ui['form'].record['Nombre_Materiales']) {
                            
                            /* Limpia el campo de busqueda alternativo.*/
                            $('#CodMaterial_Manual').val('');
                            
                            /* Divide Cadena. */
                            var bodega1 = w2ui['form'].record['Nombre_Bodega'];
                            var material1 = w2ui['form'].record['Nombre_Materiales'];

                            var div_bodega = bodega1.split("-");
                            var div_material = material1.split("-");
                            var material2 = div_material[0] + "-" + div_material[1];
                            Global_Bodega = bodega1;
                            Global_Material = material1;

                            w2ui['grid'].url = '../../clases/persistencia/controladores/Reportes/BinCard/getListaArticulos_Bincard.ashx?CodBodega=' + div_bodega[0] + '&CodMaterial=' + material2 + '&Anio=' + w2ui['form'].record['Periodos'];
                            w2ui['grid'].reload();
                        } else if (w2ui['form'].record['Nombre_Bodega'] && w2ui['form'].record['Periodos'] && w2ui['form'].record['CodMaterial_Manual']) {
                            // Divide Cadena.
                            var bodega1 = w2ui['form'].record['Nombre_Bodega'];
                            var material1 = w2ui['form'].record['CodMaterial_Manual'];

                            var div_bodega = bodega1.split("-");
                            var div_material = material1.split("-");
                            var material2 = div_material[0] + "-" + div_material[1];
                            Global_Bodega = bodega1;
                            Global_Material = material1;

                            w2ui['grid'].url = '../../clases/persistencia/controladores/Reportes/BinCard/getListaArticulos_Bincard.ashx?CodBodega=' + div_bodega[0] + '&CodMaterial=' + material2 + '&Anio=' + w2ui['form'].record['Periodos'];
                            w2ui['grid'].reload();
                        } else {
                            alert(' Faltan parametros de búsqueda!.');
                        }
                    } else {
                        alert(' Ingrese el material. Mediante la *Lista Materiales ó *Material');
                    }
                },

                "imprimir": function () {

                    // Verifica que el Grid Contenga Datos.
                    if (w2ui['grid'].records.length > 0) {

                        // =============================
                        // Obtiene Numero Correlativo
                        // =============================
                        $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Reportes/BinCard/getCorrelativo_Bincard.ashx",
                            async: false,
                            //data: { "fecha": w2ui['form'].record['anioDonacion'] },
                            dataType: "json",
                            success: function (response) {

                                if (response.item == "null") {

                                    alert('¡Error, Correlativo no encontrado!')

                                } else {
                                    Global_ID = response.Correlativo;
                                } // Fin Validador de codigo

                            } // Fin success
                        }); // fin ajax

                        // ===========================

                        // Carga la tabla para su impresión.
                        // ===========================

                        // General
                        var id_Temp = Global_ID;
                        var Bodega = Global_Bodega;
                        var CodMaterial = Global_Material;
                        var AnioBincard = w2ui['form'].record['anioDonacion'];

                        // Grid Detalle.
                        var fecha;
                        var TipoMov;
                        var NDoc;

                        var PrecioNeto;
                        var FisicoEntrada;
                        var Salida;
                        var Saldo;

                        var ValEntrada;
                        var SalidaV;
                        var SaldoV;
                        var PrecioPonderado;

                        var Obsevacion;
                        var CodItem;
                        var Descripcion;


                        for (var i = 0; i < w2ui['grid'].records.length; i++) {

                            fecha = w2ui['grid'].records[i].fecha;
                            TipoMov = w2ui['grid'].records[i].TipoMov;
                            NDoc = w2ui['grid'].records[i].NDocumento;

                            PrecioNeto = w2ui['grid'].records[i].valorNeto;
                            FisicoEntrada = w2ui['grid'].records[i].fisicoEntrada;
                            Salida = w2ui['grid'].records[i].salida;
                            Saldo = w2ui['grid'].records[i].saldo;

                            ValEntrada = w2ui['grid'].records[i].valorEntrada;
                            SalidaV = w2ui['grid'].records[i].salidaE;
                            SaldoV = w2ui['grid'].records[i].saldoE;
                            PrecioPonderado = w2ui['grid'].records[i].precioPonderado;

                            Obsevacion = w2ui['grid'].records[i].observacion;
                            CodItem = w2ui['grid'].records[i].codItem;
                            Descripcion = w2ui['grid'].records[i].descripcionItem;


                            $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Reportes/BinCard/SaveTemp_BinCard.ashx",
                                async: false,
                                data: { "id_Temp": id_Temp, "fecha": fecha, "TipoMov": TipoMov, "NDoc": NDoc, "PrecioNeto": PrecioNeto, "FisicoEntrada": FisicoEntrada, "Salida": Salida, "Saldo": Saldo, "ValEntrada": ValEntrada, "SalidaV": SalidaV, "SaldoV": SaldoV, "PrecioPonderado": PrecioPonderado, "Obsevacion": Obsevacion, "CodItem": CodItem, "Descripcion": Descripcion, "Bodega": Bodega, "CodMaterial": CodMaterial, "AnioBincard": AnioBincard },
                                dataType: "json",
                                success: function (response) {

                                } // Fin success
                            }); // fin ajax

                        } // Fin for.

                        // Si el Orden no esta especificado se tomo como valor Defecto el 1. "Codigo"
                        window.open('../../reportes/Reportes/BinCard/Report_Bincard.aspx?Global_ID=' + Global_ID);


                        //                        setTimeout(function () {

                        //                            // Elimina la busqueda establecida
                        //                            $.ajax({
                        //                                type: "POST",
                        //                                url: "../../clases/persistencia/controladores/Reportes/BinCard/busca_Bodega_Material_Bincard.ashx",
                        //                                async: false,
                        //                                data: { "Global_ID": Global_ID, "tipoBusqueda": 'DeleteTEMP' },
                        //                                dataType: "json",
                        //                                success: function (response) {

                        //                                } // Fin success

                        //                            }); // fin ajax }

                        //                        }, 10000);

                    } else {
                        alert("Primero debe realizar búsqueda de transacciones");
                    }

                },

                "limpiar": function () {
                    // Pagina Principal
                    w2ui['grid'].clear();
                    w2ui['form'].reload();
                }
            }
        });

        /* Permite Numero y las letras P, I, G */
        function justCodigo(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 44) || (KeyAscii >= 46) && (KeyAscii <= 47) || (KeyAscii >= 58) && (KeyAscii <= 70) || (KeyAscii == 72) || (KeyAscii >= 74) && (KeyAscii <= 79) || (KeyAscii >= 81) && (KeyAscii <= 102) || (KeyAscii == 104) || (KeyAscii >= 106) && (KeyAscii <= 111) || (KeyAscii >= 113) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;
            else
                return true;
            //return /\d/.test(String.fromCharCode(keynum));
        } 

        // console.log(w2ui['grid2'].getSelection());

        /*
        // Caso 1 : Cambio de Bodega con o sin Material
                if (event.target == 'Nombre_Bodega' && event.value_new) {

                    if (w2ui['form'].record['Nombre_Materiales']) {

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
                if (event.target == 'Nombre_Materiales') {

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
                                        //w2ui['form'].reload();
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


