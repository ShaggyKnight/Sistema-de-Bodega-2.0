<%@ Page Title="Página principal" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="AjusteMaterial.aspx.vb" Inherits="Bodega_WebApp.AjusteMaterial" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.ajusteMaterial%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" class="col-lg-12" style="margin-top: 2px; margin-bottom:6px; height: 230px">
    </div>
    <div id="grid" style="width: 100%; height: 260px;">
    </div>
    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247);"></div>

    <div id="formMotivoAjuste" style="margin-bottom: 3px;">
    </div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">
        var codBodega = 0;
    </script>
    <script type="text/javascript">
    /* MODULO SUPERVISOR */
        $('#form').w2form({
            name: 'form',
            style: 'background-color: #f5f6f7;',
            recid: 10,
            url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
            header: 'Ajuste de Materiales',
            formHTML:
                '<div id="form" style="width: 500px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 474px; margin-left: 20px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">Información Ajuste</div>' +
			        '<div class="w2ui-group" style="height: 152px;">' +

				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 10px;">Bodega</div>' +
		            '	<div class="w2ui-field w2ui-span5" >' +
		            '		<select name="Nombre_Bodega" type="text" style="margin-top: 4px; "/>' +
            		'	</div>' +

                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 13px; width: 88px;">Lista Materiales</div>' +
		            '	<div class="w2ui-field w2ui-span5" >' +
		            '		<select name="Nombre_Materiales" type="text" style="margin-top: 4px; width: 92%;"/>' +
		            '	</div>' +

				    '<div class="w2ui-label w2ui-span4" style="margin-top: 2%; margin-left: -20px;">*Material</div>' +
				    '   <div class="w2ui-field w2ui-span5">' +
					'       <input id="CodMaterial_Manual" name="CodMaterial_Manual" type="text" maxlength="10" style="width: 26%; " onkeypress="return justCodigo(event);"/>' +
				    '   </div>' +


                    '      <div class="group" style="height: 41px;">' +
                    '         <div class="col-7" style="margin-left: -13%;">' +

                    '           <div class="w2ui-label w2ui-span3" style="width: 125px; text-align: left; margin-top: 4%; margin-left: 4%;">Total Detalle Material:</div>' +
		            '           	<div class="w2ui-field w2ui-span5">' +
		            '                   <input id="TotalAjuste" name="TotalAjuste" type="text" maxlength="10" style="width: 58%; margin-left: 4%; margin-top: 1%; color: tomato;" disabled />' +
		            '           	</div>' +
                    '         </div>' +

                    '         <div class="col-5" style="margin-top: -1%; margin-left: -3%;">' +

		            '	        <div class="w2ui-label w2ui-span3" style=" text-align: left; width: 95px; margin-top: 8%; margin-left: -4%;">Real Existencia:</div>' +
		            '	        <div class="w2ui-field w2ui-span3">' +
		            '		        <input name="realExistencia" id="realExistencia" class="form-control" style="width: 98px; margin-top: 5%; margin-left: 14%;" type="text" disabled/>' +
		            '	        </div>' +
                    '         </div>' +
                    '     </div>' +


			        '</div>' +
		        '</div>' +

		        '<div style="margin-left: 516px; width: 340px; width: 350px;">' +
			      '<div style="padding: 3px; font-weight: bold; color: #030303;">Info. General</div>' +
			        '<div class="w2ui-group" style="height: 152px;">' +

				    '<div class="w2ui-label w2ui-span5" style="width: 104px; margin-left: 13px; text-align: left; margin-top: 4px;">Nº Ajuste</div>' +
				    '<div class="w2ui-field w2ui-span5">' +
				    '	<input id="numAjuste" name="numAjuste" type="text" maxlength="100" style="width: 40%; margin-left: 10px; margin-top: -4px;" disabled/>' +
				    '</div>' +

				    '<div class="w2ui-label w2ui-span5" style="margin-top: 8px; text-align: left; margin-left: 12px;">Fecha</div>' +
				    '<div class="w2ui-field w2ui-span5">' +
					    '<input name="fechaServidor" type="text" maxlength="100" style="width: 40%; margin-top: -1px; margin-left: 15px; " disabled/>' +
				    '</div>' +

				    '<div class="w2ui-label w2ui-span5" style="width: 104px; margin-left: 13px; text-align: left; margin-top: 10px;">Periodo Actual</div>' +
				    '<div class="w2ui-field w2ui-span5">' +
				    '	<input name="anioDonacion" type="text" maxlength="100" style="width: 40%; margin-left: 10px; margin-top: 1px;" disabled/>' +
				    '</div>' +

                    '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 14px;">Observación</div>' +
				    '<div class="w2ui-field w2ui-span5">' +
				    '   <textarea name="descripcion" type="text" style="width: 94%; height: 36px; resize: none; margin-left: 2px;"></textarea>' +
				    '</div>' +

			      '</div>' +
		        '</div>' +
              '</div>'
                    ,
            fields: [
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
                    { name: 'CodMaterial_Manual', type: 'text' },
                    { name: 'TotalAjuste', type: 'text' },
                    { name: 'realExistencia', type: 'text' },
                    { name: 'numAjuste', type: 'int' },
                    { name: 'fechaServidor', type: 'text' },
                    { name: 'anioDonacion', type: 'text' },
                    { name: 'descripcion', type: 'text' }
                    
	            ],
            onLoad: function (event) {
                console.log(event);
            },
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

                    this.fields[1].options.url = '../../clases/persistencia/controladores/Reportes/BinCard/getListaMateriales_BincardGeneral.ashx?CodBodega=' + div_bodega[0];

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
                                data: { "bodega": div_bodega[0], "material": material2.toUpperCase(), "tipoBusqueda": 'PExistencia' },
                                dataType: "json",
                                success: function (response) {

                                    if (response.item == "null") {

                                        alert('¡Error, BD!')

                                    } else {
                                        var existe = parseInt(response.existe)

                                        if (existe == 1) {

                                            // =============================
                                            //   Existencia real material
                                            // =============================
                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/Reportes/AjusteMaterial/DataAjusteMaterial.ashx?",
                                                async: false,
                                                data: { "bodega": div_bodega[0], "material": material2.toUpperCase(), "tipoBusqueda": 'totalRealExistencia' },
                                                dataType: "json",
                                                success: function (response) {

                                                    $('#realExistencia').val(response.TotalRealExistencia);
                                                    //w2ui['form'].record['realExistencia'] = response.TotalRealExistencia;
                                                    //w2ui['form'].refresh();

                                                } // Fin success
                                            }); // fin ajax

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
            columns: [
                    { field: 'recid', caption: 'Nº', size: '1%' },
			        { field: 'movEntrada', caption: 'Mov. Entrada', size: '8%' },
			        { field: 'periodo', caption: 'Año', size: '2%' },
                    { field: 'numMov', caption: 'Nº Mov.', size: '3%' },
                    { field: 'codMaterial', caption: 'Cod. Mat.', size: '4%' },
			        { field: 'cantEntrada', caption: 'Cant. Entrada', size: '5%' },
                    { field: 'existencia', caption: 'Existencia', size: '5%' ,
                        editable: { type: 'int', inTag: 'maxlength=10' }, attr: "align=center"
                    },
                    { field: 'loteSerie', caption: 'Serie o Lote', size: '7%' },
                    { field: 'loteSerie2', caption: 'Nuevo Nº.Serie', size: '7%',
                        editable: { type: 'alphanumeric', inTag: 'maxlength=20' }, attr: "align=center"
                    },
                    { field: 'fechaVencimiento', caption: 'Fecha Vto.', size: '4%',
                        editable: { type: 'date', format: 'dd/mm/yy' }, attr: "align=center , onkeypress='return justFecha(event);'"
                    },
                    { field: 'descripcion', caption: 'Motivo Ajuste', size: '12%',
                        editable: { type: 'alphanumeric', inTag: 'maxlength=60' }, attr: "align=center"
                    },
		        ],
            onChange: function (event) {
                
                if (event.type == 'change') {
                    if (event.column !=  10) {

                        var getSelect = w2ui['grid'].getSelection();
                        var totalMaterial = parseInt($('#TotalAjuste').val());
                        var totalEntrada = 0;

                        try {
                            var motivo = w2ui['grid'].records[getSelect - 1].changes.descripcion;

                            if (motivo == ''){
                                openPopup_MotivoAjuste();
                            }else{
                                if(event.value_previous != event.value_new){
                                    totalEntrada = parseInt(event.value_previous) - parseInt(event.value_new);
                                    totalMaterial = totalMaterial - totalEntrada;
                                }
                            } 
                            $('#TotalAjuste').val(totalMaterial);
                        }
                        catch(err) {
                            if (event.column ==  6) {
                               if(parseInt(event.value_new) < 0){
                                    //totalMaterial = totalMaterial - parseInt(event.value_new);
                                    event.value_new = event.value_original;
                               }else{
                                    totalEntrada = parseInt(event.value_original) - parseInt(event.value_new);
                                    totalMaterial = totalMaterial - totalEntrada;
                               } 
                               $('#TotalAjuste').val(totalMaterial);
                            }
                           openPopup_MotivoAjuste();
                        }
                    }
                }

            } // fin onchange

        });

        // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: 'border: 0px; background-color: #f5f6f7',
            formHTML:
                '</div>' +
		            '<div class="w2ui-buttons">' +
		            '	<input type="button" value="Buscar Material" name="buscar" style="width: 10%;">' +
                    '	<input type="button" value="Grabar" name="saveForm" style="border-color: tomato;">' +
                    '	<input type="button" value="Imprimir" name="imprimir">' +
		            '	<input type="button" value="Limpiar" name="limpiar">' +
                    '</div>' +
		            '</div>',
            actions: {

                "buscar": function () {

                    if (w2ui['form'].record['Nombre_Materiales'] || w2ui['form'].record['CodMaterial_Manual']) {
                        if (w2ui['form'].record['Nombre_Bodega'] && w2ui['form'].record['Nombre_Materiales']) {
                            
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

                            w2ui['grid'].url = '../../clases/persistencia/controladores/Reportes/AjusteMaterial/DataAjusteMaterial.ashx?tipoBusqueda=' + 'busquedaDetalleMaterial' + '&CodBodega=' + div_bodega[0] + '&CodMaterial=' + material2.toUpperCase();
                            w2ui['grid'].reload();
                        } else if (w2ui['form'].record['Nombre_Bodega'] && w2ui['form'].record['CodMaterial_Manual']) {
                            // Divide Cadena.
                            var bodega1 = w2ui['form'].record['Nombre_Bodega'];
                            var material1 = w2ui['form'].record['CodMaterial_Manual'];

                            var div_bodega = bodega1.split("-");
                            var div_material = material1.split("-");
                            var material2 = div_material[0] + "-" + div_material[1];
                            Global_Bodega = bodega1;
                            Global_Material = material1;

                            w2ui['grid'].url = '../../clases/persistencia/controladores/Reportes/AjusteMaterial/DataAjusteMaterial.ashx?tipoBusqueda=' + 'busquedaDetalleMaterial' + '&CodBodega=' + div_bodega[0] + '&CodMaterial=' + material2.toUpperCase();
                            w2ui['grid'].reload();

                        } else {
                            alert(' Faltan parametros de búsqueda!.');
                        }
                    } else {
                        alert(' Ingrese el material. Mediante la *Lista Materiales ó *Material');
                    }

                    setTimeout(function () {

                    var totalMaterial = 0;

                    for (i = 0; i < w2ui['grid'].records.length; i++) {
                        totalMaterial = totalMaterial + parseInt(w2ui['grid'].records[i].existencia);
                    }

                    $('#TotalAjuste').val(totalMaterial);
                    }, 400);
                },
                /*===================================*/

                "saveForm": function () {

                    // valida que la descripcion este escrita.
                    if(w2ui['form'].record['descripcion']){
                    }else{
                        w2ui['form'].record['descripcion'] = '';
                        w2ui['form'].refresh();
                    }

                    if(w2ui['form'].record['numAjuste']){
                        alert('Ud. NO puede grabar el Ajuste por que esta ya EXISTE.')
                    }else{

                        var existeCambio = 0;

                        /* Controla que existan cambios (o ajustes) en la grilla. */
                        try{
                        
                            for (var i = 0; i <= w2ui['grid'].records.length - 1; i++) {  
                                if(w2ui['grid'].records[i].changed){
                                    existeCambio = 1;
                                    break;
                                }
                            }
                        }
                        catch(e){
                                        
                        }    

                        if(existeCambio == 1){

                            // ===========================
                            //  Graba  el  Movimiento
                            // ===========================
                            $.ajax({
                                url: '../../clases/persistencia/controladores/Reportes/AjusteMaterial/DataAjusteMaterial.ashx',
                                type: 'POST',
                                dataType: 'json',
                                data: { tipoBusqueda: 'create-records', dataFormAjuste: w2ui['form'].record },
                                success: function (response) {

                                    if (response.status == 'error') {
                                        w2alert(response.message);
                                    } else {

                                        var NroOperacion = response.cmvNumero;

                                        w2ui['form'].record['numAjuste'] = NroOperacion;
                                        w2ui['form'].refresh();

                                        // ===========================
                                        // Graba Detalle de Movimiento
                                        // ===========================

                                        var CodigoMaterial;
                                        var CantidadEntrada;
                                        var LoteReal;
                                        var ObsChange;
                                        var ExistChange;
                                        var LoteChange;
                                        var PeriodoGrid;
                                        var FechaVtoChange;
                                        var exitoDetalle = 0;

                                        for (var i = 0; i <= w2ui['grid'].records.length - 1; i++) {
                                        
                                            // datos reales
                                            CodigoMaterial = w2ui['grid'].records[i].codMaterial;
                                            CantidadEntrada = w2ui['grid'].records[i].cantEntrada;
                                            LoteReal = w2ui['grid'].records[i].loteSerie;
                                            PeriodoGrid = w2ui['grid'].records[i].periodo;
                                         
                                            try {
                                                ObsChange = w2ui['grid'].records[i].changes.descripcion
                                                ExistChange = w2ui['grid'].records[i].changes.existencia;
                                                LoteChange = w2ui['grid'].records[i].changes.loteSerie2;
                                                FechaVtoChange = w2ui['grid'].records[i].changes.fechaVencimiento;

                                                $.ajax({
                                                    type: "POST",
                                                    url: "../../clases/persistencia/controladores/Reportes/AjusteMaterial/DataAjusteMaterial.ashx",
                                                    async: false,
                                                    data: { 'tipoBusqueda': 'createDetalle', 'dataFormAjuste': w2ui['form'].record, 'codMaterial': CodigoMaterial, 'PeriodoGrid': PeriodoGrid, 'cantEntrada': CantidadEntrada, 'loteReal': LoteReal, 'detalle': ObsChange, 'existenciaChange' :ExistChange, 'loteChange': LoteChange, 'fechaVto': FechaVtoChange },
                                                    dataType: "json",
                                                    success: function (response) {

                                                        if (response.cmvNumero != 0) {
                                                            exitoDetalle = 1;
                                                        } // Fin Validador de codigo

                                                    } // Fin success
                                                }); // fin ajax
                                            }
                                            catch(e){
                                        
                                            }                                              

                                        } // Fin for.

                                        if (exitoDetalle == 1) {
                                            w2alert('¡Se creo el Ajuste Nº ' + w2ui['form'].record['numAjuste'] + ' con éxito!');
                                        } else {
                                            alert("Ha ocurrio un error en el detalle de la operación, vuelva intentarlo mas tarde.");
                                        }

                                    } // fin error

                                }, // Fin success
                                error: function (response) {
                                    alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                } // fin error
                            }); // fin ajax
                        }else{
                            w2alert('Antes de grabar ingrese los Ajustes!');
                        }

                    } // Fin verifica si existe correlativo.

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

                    var done = 0;
                    var ReportUsuario = '';

                    // Verifica que exista el ajuste para imprimir
                    if (w2ui['form'].record['numAjuste']) {
                            if (w2ui['form'].record['Nombre_Bodega']) {
                                
                                // Guarda los datos para imprimir.
                                $.ajax({
                                    type: "POST",
                                    url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                                    async: false,
                                    data: { "cmd": 'AjusteMaterial', "GridAjuste": w2ui['grid'].records, "largoGrid": w2ui['grid'].records.length, "dataFormAjuste": w2ui['form'].record },
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

                                if (done == 0) {
                                    window.open('../../reportes/Reportes/AjusteMaterial/RptVentana_AjusteMaterial.aspx?CMVCodigo=' + w2ui['form'].record['numAjuste'] + '&PERCodigo=' + w2ui['form'].record['anioDonacion'] + '&TMVCodigo=' + '6' + '&usuario=' + ReportUsuario);
                                } else {
                                    alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                }

                            } else { 
                                alert("Faltan datos para imprimir."); 
                            } // Fin nombre Bodega.
                    } else { 
                        // alerta de mensaje por no ingresar nada.
                        alert("Primero grabe la operación");
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

        /* Permite Numero y las letras P, I, G */
        function justCodigo(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 44) || (KeyAscii >= 46) && (KeyAscii <= 47) || (KeyAscii >= 58) && (KeyAscii <= 70) || (KeyAscii == 72) || (KeyAscii >= 74) && (KeyAscii <= 79) || (KeyAscii >= 81) && (KeyAscii <= 102) || (KeyAscii == 104) || (KeyAscii >= 106) && (KeyAscii <= 111) || (KeyAscii >= 113) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;
            else
                return true;
            //return /\d/.test(String.fromCharCode(keynum));
        } 

        // console.log(response);
 
    </script>


    <!-- w2ui MOTIVO AJUSTE -->
    <script type="text/javascript">

        function openPopup_MotivoAjuste() {
            w2popup.open({
                title: '',
                width: 600,
                height: 200,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                modal: true,
                onOpen: function (event) {
                    event.onComplete = function () {

                        $('#w2ui-popup #main').w2render('layout');
                        w2ui.layout.content('left', w2ui.gridNota);
                        w2ui.layout.content('main', w2ui.formMotivoAjuste);

                        $("#Numlinea").val(w2ui['grid'].getSelection());
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

    </script>

    <!-- w2ui FormMotivo,  FormAjuste -->
    <script type="text/javascript">

        var config = {
            /* nota */
            layout: {
                name: 'layout',
                padding: 4,
                panels: [
			            { type: 'main', minSize: 750 }
		            ]
            },
            grid1: {
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
            form1: {
                header: 'Motivo Ajuste',
                name: 'formMotivoAjuste',
                url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
                formHTML:
                        '<div class="w2ui-page page-0">' +

                /* Grupo Nota Credito */
	                       '<div style="width: 100%; float: left; margin-right: 0px;">' +
                           '<div style="padding: 3px; font-weight: bold; color: #777;" >Motivo Ajuste</div>' +
                            '<div class="w2ui-group" style="height: 50px;">' +

				                '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 10px;">Bodega</div>' +
		                        '	<div class="w2ui-field w2ui-span5" >' +
		                        '		<select name="tipoAjuste" type="text" style="width: 90%"/>' +
            		            '	</div>' +

				                '   <div class="w2ui-field w2ui-span5" style="display: none;">' +
					            '       <input id="Numlinea" name="Numlinea" type="text" style="width: 34%;" onkeypress="" disabled />' +
				                '   </div>' +

                            '</div>' +
                          '</div>' +

                        '</div>' + // fin
                        '<div class="w2ui-buttons">' +
		                    '<input type="button" value="Aceptar" name="aceptar" style="width: 88px; border-color: tomato;">' +
	                    '</div>',
                fields: [
                    { name: 'tipoAjuste', type: 'list', required: true,
                        options: {
                            url: '../../clases/persistencia/controladores/Reportes/AjusteMaterial/DataAjusteMaterial.ashx?tipoBusqueda=' + 'TipoAjuste',
                            showNone: true
                        }
                    },
                    { name: 'TotalAjuste', type: 'int' }

                ],
                actions: {

                    /* traspaso de mensaje a grid principal */
                    aceptar: function () {
                        w2ui.grid.editField($('#Numlinea').val(), 10, $('#tipoAjuste option:selected').text());
                        $("#tipoAjuste").focus();
                        w2popup.close();
                    }

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

        });
    </script>

</asp:Content>
