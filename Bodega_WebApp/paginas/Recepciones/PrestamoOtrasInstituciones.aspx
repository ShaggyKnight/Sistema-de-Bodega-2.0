<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="PrestamoOtrasInstituciones.aspx.vb" Inherits="plantilla2013vbasic.PrestamoOtrasInstituciones" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, plantilla2013vbasic.Site).idePagina = plantilla2013vbasic.Pagina.despaPrestamosOtrasInstitu%>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:3px; height: 230px">
    </div>
    <div id="grid" style="width: 100%; height: 320px;">
    </div>
    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247);"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        var Global_SaveComplete = 0;

        $('#form').w2form({
            name: 'form',
            style: 'border: 0px; background-color: #f5f6f7;',
            recid: 10,
            url: '../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/getFechaServidorDespachos.ashx',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 450px; margin-left: 20px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 185px;">'+
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Fecha</div>' +
				    '<div class="w2ui-field w2ui-span4">'+
					    '<input name="fechaServidor" type="text" maxlength="100" style="width: 32%; margin-left: 2px;" disabled/>' +
				    '</div>'+
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Bodega</div>'+
		            '	<div class="w2ui-field" style="margin-left: 90px !important;">' +
		            '		<select name="Nombre_Bodega" type="text" />' +
		            '	</div>' +
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Institución</div>'+
		            '	<div class="w2ui-field" style="margin-left: 90px !important;">' +
		            '		<select name="Nombre_Institucion" type="text" />' +
		            '	</div>' +
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Descripción</div>'+
				    '<div class="w2ui-field w2ui-span4">'+
					    '<textarea name="descripcion" type="text" style="width: 86%; height: 56px; resize: none; margin-left: 2px;"></textarea>' +
				    '</div>'+
			      '</div>'+
		        '</div>' +

		        '<div style="margin-left: 500px; width: 340px; width: 268px;">' +
			      '<div style="padding: 3px; font-weight: bold; color: #030303;">Prést. a Otras Inst. Generado</div>'+
			        '<div class="w2ui-group" style="height: 120px;">'+
				    '<div class="w2ui-label w2ui-span5" style="margin-top: 28px; text-align: left; margin-left: 12px;">Periodo</div>' +
				    '<div class="w2ui-field w2ui-span5">'+
					    '<input name="anioPrestamo" type="text" maxlength="100" style="width: 70%; margin-top: 19px; margin-left: 15px;" disabled/>' +
				    '</div>'+
				    '<div class="w2ui-label w2ui-span5">N°Prést. a Inst.</div>'+
				    '<div class="w2ui-field w2ui-span5">'+
				    '	<input name="NDonacion" type="text" maxlength="100" style="width: 70%; margin-left: 17px;" disabled/>' +
				    '</div>'+
			      '</div>'+
		        '</div>'+
              '</div>'
                    ,
            fields: [
		            { name: 'fechaServidor', type: 'text' },
                    { name: 'anioPrestamo', type: 'text' },
		            { name: 'Nombre_Bodega', type: 'list',
		                options: {
		                    url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getLista.ashx',
		                    showNone: true
		                }
		            },
                    { name: 'Nombre_Institucion', type: 'list',
		                options: {
		                    url: '../../clases/persistencia/controladores/Recepciones/RecepcionxPrestamo/getListaInstituciones.ashx',
		                    showNone: true
		                }
		            },
                    { name: 'descripcion', type: 'text' },
                    { name: 'NDonacion', type: 'text' }
                    
	            ],
	                onLoad: function(event) {
		                console.log(event);
	                }
        }); // Fin Form1


        $('#grid').w2grid({
            name: 'grid',
            header: 'Lista de Materiales',
            show: {
                header: true,
                toolbarSave: true,
                toolbarDelete: true,
                toolbar: true,
                footer: true
            },
            multiSearch: false,
            searches: [
			        { type: 'text', field: 'recid', caption: 'Codigo Material' },
		        ],
            columns: [
			        { field: 'codMaterial', caption: 'Cod. Material', size: '16%', sortable: true, resizable: true,
			            editable: { type: 'text', inTag: 'maxlength=20' }, attr: "align=center"
			        },
			        { field: 'nombreMaterial', caption: 'Nombre Material', size: '36%' },
                    { field: 'item', caption: 'Item', size: '16%' },
			        { field: 'cantidad', caption: 'Cantidad', size: '14%', sortable: true, resizable: true,
			            editable: { type: 'int', inTag: 'maxlength=4' }, attr: "align=center"
			        },
                    { field: 'valor', caption: 'Valor', size: '16%' },
                    { field: 'total', caption: 'Total', size: '18%' },
                    { field: 'existencia', caption: 'Existencia', size: '14%' }
		        ]
                ,
            records: [
                { recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', existencia: '' }
	            ],

            //===========================
            onExpand: function (event) {

                var idLocalTemp = event.recid;
                var idSubGrid = 1;
                var Global_SaveSubGrid = 0;

                // Nombre del Grid
                var subGridName = 'subgrid-' + $.trim(event.recid);

                if (w2ui.hasOwnProperty('subgrid-' + event.recid)) w2ui['subgrid-' + event.recid].destroy();
                $('#' + event.box_id).css({ margin: '0px', padding: '0px', width: '100%' }).animate({ height: '105px' }, 100);

                setTimeout(function () {

                    // Comprueba que el campo bodega este comleto.
                    if (w2ui['form'].record['Nombre_Bodega']) {

                        var anio = w2ui['form'].record['anioPrestamo']

                        // Busca de acuerdo a si es Nuevo o Antiguo.
                        if (anio >= 2014) {

                            $('#' + event.box_id).w2grid({
                                name: 'subgrid-' + event.recid,
                                show: { columnHeaders: true,
                                    toolbar: true,
                                    toolbarAdd: false,
                                    toolbarDelete: true,
                                    toolbarSave: true,
                                    toolbarSearch: false,
                                    toolbarReload: false,
                                    toolbarColumns: false
                                },
                                //url: '../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/getDetalleProductosDespOtrasInst.ashx?codBodega=' + w2ui['form'].record['Nombre_Bodega'] + '&codMaterial=' + w2ui['grid'].records[event.recid - 1].codMaterial,
                                //url: '../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/getDetalleProductosDespOtrasInst.ashx?codBodega=' + "" + '&codMaterial=' + "",
                                fixedBody: false,
                                columns: [
						            { field: 'codMaterial2', caption: 'Cod. Material', size: '30%', attr: "align=center" },
						            { field: 'cantidad2', caption: 'Cantidad', size: '30%',
						                editable: { type: 'int', format: 'maxlength = 4' }, attr: "align=center"
						            },
						            { field: 'loteSerie2', caption: 'Serie o Lote', size: '30%',
						                editable: { type: 'text', inTag: 'maxlength = 12' }, attr: "align=center"
						            },
						            { field: 'fechaVencimiento2', caption: 'Fecha Vto.', size: '30%',
						                editable: { type: 'date', format: 'dd/mm/yy' }, attr: "align=center , onkeypress='return justFecha(event);'"
						            },
					            ]
                                ,
                                records: [
						            { recid: 1, codMaterial2: w2ui['grid'].records[event.recid - 1].codMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: '' }
					            ]
                                ,
                                //-------------------------


                                // ================================
                                // ================================
                                // Grabar nueva Donación.
                                onSave: function (event) {

                                    if (Global_SaveSubGrid == 0) {
                                        alert('Cantidad maxima ingresada no Disponible.')
                                    } else {
                                        // ================================

                                        // Obtiene Numero Correlativo
                                        // ================================

                                        if (w2ui['form'].record['NDonacion']) {

                                        } else {

                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/getCorrelativoDespOtrasInstituciones.ashx",
                                                async: false,
                                                data: { "fecha": w2ui['form'].record['anioPrestamo'] },
                                                dataType: "json",
                                                success: function (response) {

                                                    if (response.item == "null") {

                                                        alert('¡Error, Correlativo no encontrado!')

                                                    } else {
                                                        w2ui['form'].record['NDonacion'] = response.Correlativo;
                                                        w2ui['form'].refresh();
                                                    } // Fin Validador de codigo

                                                } // Fin success
                                            }); // fin ajax
                                        } // fin if existe correlativo


                                        // ===========================

                                        // Graba Detalle de Movimiento
                                        // ===========================

                                        // General
                                        var CodigoMovimiento = 'P';
                                        var anioPrestamo = w2ui['form'].record['anioPrestamo'];
                                        var CodCorrelativo = w2ui['form'].record['NDonacion'];
                                        var cantidadMovimiento = parseInt(w2ui['grid'].records[idLocalTemp - 1].cantidad);
                                        var CodBodega = w2ui['form'].record['Nombre_Bodega'];
                                        var ItemArticulo = w2ui['grid'].records[idLocalTemp - 1].item;
                                        var PrecioUni = w2ui['grid'].records[idLocalTemp - 1].valor;

                                        // Grid Detalle.
                                        var local_CodMaterial;
                                        var local_Cantidad;
                                        var local_Serielote;
                                        var local_fechaVto;
                                        var cont = 1;

                                        for (var i = 0; i < w2ui[subGridName].records.length; i++) {

                                            local_CodMaterial2 = w2ui[subGridName].records[i].codMaterial2;
                                            local_Cantidad2 = w2ui[subGridName].records[i].cantidad2;
                                            local_Serielote2 = w2ui[subGridName].records[i].loteSerie2;
                                            local_fechaVto2 = w2ui[subGridName].records[i].fechaVencimiento2;

                                            //                                        alert(CodigoMovimiento + " " + anioPrestamo + " " + CodCorrelativo + " " + cantidadMovimiento);
                                            //                                        alert(local_CodMaterial2 + " " + local_Cantidad2 + " " + local_Serielote2 + " " + local_fechaVto2);

                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/saveTempOtrasInstituciones.ashx",
                                                async: false,
                                                data: { "cont": cont, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioPrestamo, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadMovimiento, "CantidadMovimientoDetalle": local_Cantidad2, "CodigoMaterial": local_CodMaterial2, "NSerie": local_Serielote2, "fechaVencimiento": local_fechaVto2, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni },
                                                dataType: "json",
                                                success: function (response) {

                                                    if (response.item == "done") {

                                                    } // Fin Validador de codigo

                                                } // Fin success
                                            }); // fin ajax

                                            cont = cont + 1;

                                        } // Fin for.

                                        //----------------------------
                                        // Cambia color asigna termino

                                        var local_Recid = w2ui['grid'].records[idLocalTemp - 1].recid;
                                        var local_Codigo = w2ui['grid'].records[idLocalTemp - 1].codMaterial;
                                        var local_Nombre = w2ui['grid'].records[idLocalTemp - 1].nombreMaterial;
                                        var local_Item = w2ui['grid'].records[idLocalTemp - 1].item;
                                        var local_CntPrestada = w2ui['grid'].records[idLocalTemp - 1].cantidad;
                                        var local_Valor = w2ui['grid'].records[idLocalTemp - 1].valor;
                                        var local_Total = w2ui['grid'].records[idLocalTemp - 1].total;
                                        var local_Existencia = w2ui['grid'].records[idLocalTemp - 1].existencia;

                                        //                                    w2ui['grid'].select(local_Recid);
                                        //                                    w2ui['grid'].delete(true);
                                        w2ui['grid'].remove(local_Recid);

                                        //alert(local_Recid +" "+ local_Codigo+" "+local_nombre +" "+local_Item +" "+local_CntDespachada +" "+local_CntDevuelta +" "+local_Precio+" "+local_Total +" "+local_Existencia)
                                        w2ui['grid'].add({ recid: local_Recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, item: local_Item, cantidad: local_CntPrestada, valor: local_Valor, total: local_Total, existencia: local_Existencia, "style": "background-color: #C2F5B4" });

                                        //----------------------------

                                        // Agrega un nuevo campo.
                                        //                                    w2ui['grid'].select('');
                                        //                                    w2ui['grid'].delete(true);
                                        w2ui['grid'].remove('');
                                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });

                                        Global_SaveComplete = 1;

                                    } //fin Global_SaveSubGrid verifica si se puede o no grabar.

                                },
                                //===========================
                                //===========================

                                onChange: function (event) {

                                    var local_CodMaterial;
                                    var local_Cantidad;
                                    var local_Serielote;
                                    var local_fechaVto;

                                    var CantDespachado = parseInt(w2ui['grid'].records[idLocalTemp - 1].cantidad);

                                    // Cantidad. 
                                    if (event.column == 1) {

                                        if (event.value_new > CantDespachado) {

                                            alert('Cantidad Ingresada Supera a Cantidad Prestada');
                                            //                                            w2ui[subGridName].select('');
                                            //                                            w2ui[subGridName].delete(true);
                                            //                                            w2ui[subGridName].select(event.recid);
                                            //                                            w2ui[subGridName].delete(true);
                                            w2ui[subGridName].remove('');
                                            w2ui[subGridName].remove(event.recid);
                                            w2ui[subGridName].add({ recid: event.recid, codMaterial2: w2ui['grid'].records[idLocalTemp - 1].codMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: '' });

                                        } else {// fin if valida cantidad ingresada no sea mayor a lo disponible.

                                            for (var i = 0; i < w2ui[subGridName].records.length; i++) {

                                                if (event.recid == w2ui[subGridName].records[i].recid) {
                                                    local_CodMaterial = w2ui[subGridName].records[i].codMaterial2;
                                                    local_Cantidad = event.value_new;

                                                    // para valiar que la Serie o Lote ingresada.
                                                    if (w2ui[subGridName].records[i].loteSerie2 == "") {
                                                        local_Serielote = "";
                                                    } else {
                                                        local_Serielote = w2ui[subGridName].records[i].loteSerie2;
                                                    }

                                                    // para valiar que la fecha este ingresada.
                                                    if (w2ui[subGridName].records[i].fechaVencimiento2 == "") {
                                                        local_fechaVto = "";
                                                    } else {
                                                        local_fechaVto = w2ui[subGridName].records[i].fechaVencimiento2;
                                                    }

                                                }
                                            }

                                            //                                            w2ui[subGridName].select('');
                                            //                                            w2ui[subGridName].delete(true);
                                            //                                            w2ui[subGridName].select(event.recid);
                                            //                                            w2ui[subGridName].delete(true);
                                            w2ui[subGridName].remove('');
                                            w2ui[subGridName].remove(event.recid);

                                            // Para valiar que la fecha este ingresada.
                                            if (local_Serielote == "" || local_fechaVto == "") {

                                                w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });

                                                // comprueba que la suma de la cantidad ingresada no sea mayor a la prestado.
                                                var sumaCantidad = 0;

                                                for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                                    sumaCantidad = sumaCantidad + parseInt(w2ui[subGridName].records[i].cantidad2);
                                                }

                                                // la sumatoria de lo ingresado es mayor que la cantidad a ser ingresada.
                                                if (sumaCantidad > CantDespachado) {
                                                    //                                                    w2ui[subGridName].select(event.recid);
                                                    //                                                    w2ui[subGridName].delete(true);
                                                    w2ui[subGridName].remove(event.recid);
                                                    alert('Cantidad Ingresada Supera a Cantidad Prestada');
                                                    w2ui[subGridName].add({ recid: event.recid, codMaterial2: w2ui['grid'].records[idLocalTemp - 1].codMaterial, cantidad2: '', loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });
                                                }

                                            } else {

                                                w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });
                                                w2ui[subGridName].add({ recid: event.recid + 1, codMaterial2: local_CodMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: '' });

                                                //                                                w2ui[subGridName].select(event.recid + 1);
                                                //                                                w2ui[subGridName].delete(true);

                                                w2ui[subGridName].remove(event.recid + 1);

                                                // comprueba que la suma de la cantidad ingresada no sea mayor a la prestado.
                                                var sumaCantidad = 0;

                                                for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                                    sumaCantidad = sumaCantidad + parseInt(w2ui[subGridName].records[i].cantidad2);
                                                }

                                                // la sumatoria de lo ingresado es mayor que la cantidad a ser ingresada.
                                                if (sumaCantidad > CantDespachado) {
                                                    //                                                    w2ui[subGridName].select(event.recid);
                                                    //                                                    w2ui[subGridName].delete(true);
                                                    w2ui[subGridName].remove(event.recid);
                                                    alert('Cantidad Ingresada Supera a Cantidad Prestada');
                                                    w2ui[subGridName].add({ recid: event.recid, codMaterial2: w2ui['grid'].records[idLocalTemp - 1].codMaterial, cantidad2: '', loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });
                                                } else {
                                                    // en este nuevo metodo de fecha vto, este comando funciona.
                                                    //w2ui[subGridName].add({  recid: event.recid + 1 ,codMaterial2: local_CodMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: '' });
                                                } // if valida que sumatoria no sea mayor.

                                            } // if valida fecha nulas.   

                                        } // fin if cantidad inicial no pruede ser mas grande que lo prestado.

                                    } // fin columna 1


                                    // Serie o lote.
                                    if (event.column == 2) {

                                        for (var i = 0; i < w2ui[subGridName].records.length; i++) {

                                            if (event.recid == w2ui[subGridName].records[i].recid) {

                                                local_CodMaterial = w2ui[subGridName].records[i].codMaterial2;
                                                local_Serielote = event.value_new;

                                                // para valiar que la cantidad ingresada.
                                                if (w2ui[subGridName].records[i].cantidad2 == "") {
                                                    local_Cantidad = "";
                                                } else {
                                                    local_Cantidad = w2ui[subGridName].records[i].cantidad2;
                                                }

                                                // para valiar que la fecha este ingresada.
                                                if (w2ui[subGridName].records[i].fechaVencimiento2 == "") {
                                                    local_fechaVto = "";
                                                } else {
                                                    local_fechaVto = w2ui[subGridName].records[i].fechaVencimiento2;
                                                }
                                            }
                                        }

                                        //                                        w2ui[subGridName].select('');
                                        //                                        w2ui[subGridName].delete(true);
                                        //                                        w2ui[subGridName].select(event.recid);
                                        //                                        w2ui[subGridName].delete(true);
                                        w2ui[subGridName].remove('');
                                        w2ui[subGridName].remove(event.recid);

                                        // Para valiar que la fecha este ingresada.
                                        if (local_Cantidad == "" || local_fechaVto == "") {
                                            w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });
                                        } else {
                                            w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });
                                            w2ui[subGridName].add({ recid: event.recid + 1, codMaterial2: local_CodMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: '' });
                                        }
                                    } // fin columna 2.


                                    // Fecha Vto.
                                    if (event.column == 3) {
                                        //alert('1')
                                        var CantDespachado = parseInt(w2ui['grid'].records[idLocalTemp - 1].cantidad);

                                        for (var i = 0; i < w2ui[subGridName].records.length; i++) {

                                            if (event.recid == w2ui[subGridName].records[i].recid) {

                                                local_CodMaterial = w2ui[subGridName].records[i].codMaterial2;
                                                local_fechaVto = event.value_new;

                                                // para valiar que la cantidad ingresada.
                                                if (w2ui[subGridName].records[i].cantidad2 == "") {
                                                    local_Cantidad = "";
                                                } else {
                                                    local_Cantidad = w2ui[subGridName].records[i].cantidad2;
                                                }

                                                // para valiar que la Serie o Lote ingresada.
                                                if (w2ui[subGridName].records[i].loteSerie2 == "") {
                                                    local_Serielote = "";
                                                } else {
                                                    local_Serielote = w2ui[subGridName].records[i].loteSerie2;
                                                }
                                            }
                                        } // fin for.

                                        //alert('2')
                                        // Para valiar que la fecha este ingresada.
                                        if (local_Cantidad == "" || local_Serielote == "") {
                                            //alert('3')
                                            //                                            w2ui[subGridName].select('');
                                            //                                            w2ui[subGridName].delete(true);
                                            //                                            w2ui[subGridName].select(event.recid);
                                            //                                            w2ui[subGridName].delete(true);
                                            w2ui[subGridName].remove('');
                                            w2ui[subGridName].remove(event.recid);

                                            w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });
                                        } else {

                                            var sumaCantidad = 0;

                                            for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                                sumaCantidad = sumaCantidad + parseInt(w2ui[subGridName].records[i].cantidad2);
                                            }
                                            //alert(sumaCantidad)
                                            //alert('4')
                                            // verifica que la cantidad ya ingresada no sea superior a la entrega.
                                            if (sumaCantidad == CantDespachado) {
                                                //                                                w2ui[subGridName].select('');
                                                //                                                w2ui[subGridName].delete(true);
                                                //                                                w2ui[subGridName].select(event.recid);
                                                //                                                w2ui[subGridName].delete(true);
                                                w2ui[subGridName].remove('');
                                                w2ui[subGridName].remove(event.recid);
                                                w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });
                                            } else {
                                                //alert('5')
                                                //alert(CantDespachado)
                                                // la sumatoria de lo ingresado es menor que la cantidad a ser ingresada.
                                                if (sumaCantidad <= CantDespachado) {
                                                    //alert('5-1')
                                                    //                                                    w2ui[subGridName].select('');
                                                    //                                                    w2ui[subGridName].delete(true);
                                                    //                                                    w2ui[subGridName].select(event.recid);
                                                    //                                                    w2ui[subGridName].delete(true);

                                                    w2ui[subGridName].remove('');
                                                    w2ui[subGridName].remove(event.recid);

                                                    w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });
                                                    w2ui[subGridName].add({ recid: event.recid + 1, codMaterial2: local_CodMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: '' });
                                                }

                                                // la sumatoria de lo ingresado es mayor que la cantidad a ser ingresada.
                                                if (sumaCantidad > CantDespachado) {
                                                    //alert('5-2')
                                                    alert('Cantidad Ingresada Supera a Cantidad Prestada');
                                                    //                                                    w2ui[subGridName].select('');
                                                    //                                                    w2ui[subGridName].delete(true);
                                                    //                                                    w2ui[subGridName].select(event.recid);
                                                    //                                                    w2ui[subGridName].delete(true);
                                                    w2ui[subGridName].remove('');
                                                    w2ui[subGridName].remove(event.recid);
                                                    w2ui[subGridName].add({ recid: event.recid, codMaterial2: w2ui['grid'].records[idLocalTemp - 1].codMaterial, cantidad2: '', loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });
                                                }
                                            }

                                            //alert('6')

                                        }

                                    } // fin columna 3.

                                } // fin Onchange
                                //-------------------------

                            }); // fin abrir grid para detalle, cuando existen valores 2014
                            w2ui['subgrid-' + event.recid].resize();

                            // -----------------------------
                            // Maneja los datos del Sub Grid
                            // -----------------------------

                            // ===========================

                            // Obtiene Numero Correlativo
                            // ============================


                            if (w2ui['form'].record['NDonacion']) {

                                // Verifica si los datos vienen de la principal o la temporal.
                                var datos = 0;

                                $.ajax({
                                    type: "POST",
                                    url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/buscaCorrelativoDespOtrasInstituciones.ashx",
                                    async: false,
                                    data: { "fecha": w2ui['form'].record['anioPrestamo'], "Ncorrelativo": w2ui['form'].record['NDonacion'], "CodMaterial": w2ui['grid'].records[idLocalTemp - 1].codMaterial },
                                    dataType: "json",
                                    success: function (response) {

                                        if (response.item == "null") {

                                            alert('¡Error, Correlativo no encontrado!')

                                        } else {
                                            var tabla = parseInt(response.Tabla)

                                            if (tabla == 1) {
                                                datos = 1;
                                            }
                                            if (tabla == 2) {
                                                datos = 2;
                                            }

                                            if (tabla == 3) {
                                                datos = 3;
                                            }
                                        } // Fin Validador de codigo

                                    } // Fin success
                                }); // fin ajax


                                //alert(datos);

                                // Tabla 1, busca los ya ingresados.
                                if (datos == 1) {

                                    $.ajax({
                                        type: "POST",
                                        url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/getHistorialDetalleProductosDespOtrasInst.ashx",
                                        async: false,
                                        data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[idLocalTemp - 1].codMaterial, "NCorrelativo": w2ui['form'].record['NDonacion'] },
                                        dataType: "json",
                                        success: function (response) {

                                            // Carga articulos Grid1
                                            w2ui[subGridName].clear();
                                            var recidID = 1;

                                            // Transcribe los nuevos Records o articulos actualmente disponibles.
                                            for (var i = 0; i < response.records.length; i++) {
                                                w2ui[subGridName].add({ recid: recidID, codMaterial2: w2ui['grid'].records[idLocalTemp - 1].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2 });
                                                recidID = recidID + 1;
                                            } // fin for

                                        } // Fin success
                                    }); // fin ajax	

                                } // fin datos 1


                                // Tabla 2, busca el valor tabla temp.
                                if (datos == 2) {

                                    $.ajax({
                                        type: "POST",
                                        url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/getHistorialTempDetalleProductosDespOtrasInst.ashx",
                                        async: false,
                                        data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[idLocalTemp - 1].codMaterial, "NCorrelativo": w2ui['form'].record['NDonacion'] },
                                        dataType: "json",
                                        success: function (response) {

                                            // Carga articulos Grid1
                                            w2ui[subGridName].clear();
                                            var recidID = 1;

                                            // Transcribe los nuevos Records o articulos actualmente disponibles.
                                            for (var i = 0; i < response.records.length; i++) {
                                                w2ui[subGridName].add({ recid: recidID, codMaterial2: w2ui['grid'].records[idLocalTemp - 1].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2 });
                                                recidID = recidID + 1;
                                            } // fin for

                                        } // Fin success
                                    }); // fin ajax	

                                } // fin datos 2


                                // Tabla 3, No esta en nunguna de las 2 anteriores.
                                if (datos == 3) {

                                    $.ajax({
                                        type: "POST",
                                        url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/getDetalleProductosDespOtrasInst.ashx",
                                        async: false,
                                        data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[idLocalTemp - 1].codMaterial },
                                        dataType: "json",
                                        success: function (response) {

                                            var cantidadADespachar = parseInt(w2ui['grid'].records[idLocalTemp - 1].cantidad);
                                            var sumaParcial = 0;
                                            var sumaCheck = 0;

                                            // Carga articulos Grid1
                                            w2ui[subGridName].clear();
                                            var recidID = 1;

                                            // Transcribe los nuevos Records o articulos actualmente disponibles.
                                            for (var i = 0; i < response.records.length; i++) {

                                                var cantidadNueva = parseInt(response.records[i].cantidad2);

                                                if (cantidadADespachar > sumaParcial) {

                                                    w2ui[subGridName].add({ recid: recidID, codMaterial2: w2ui['grid'].records[idLocalTemp - 1].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2 });
                                                    recidID = recidID + 1;
                                                    sumaParcial = sumaParcial + cantidadNueva;

                                                } // fin if
                                            } // fin for

                                        } // Fin success
                                    }); // fin ajax		

                                    var cantidadADespachar = parseInt(w2ui['grid'].records[idLocalTemp - 1].cantidad);
                                    var sumaParcial2 = 0;

                                    // Elimina el ultimo dato y lo adapta a lo solicitado.
                                    for (var i = 0; i <= w2ui[subGridName].records.length - 1; i++) {

                                        var cantidadNueva = parseInt(w2ui[subGridName].records[i].cantidad2);
                                        sumaParcial2 = sumaParcial2 + cantidadNueva;

                                        if (i == w2ui[subGridName].records.length - 1) {

                                            var calculaMonto = 0;
                                            var finalMonto = 0;

                                            if (cantidadADespachar > sumaParcial2) {

                                                alert('Monto Solicitado  >' + ' ' + cantidadADespachar + ' ' + '<,  excede la existencia de materiales con "Fecha de Vencimiento".');
                                                alert('El maximo en existencia con fecha son :  ' + sumaParcial2);

                                                // No se permite el Save.
                                                Global_SaveSubGrid = 0;

                                            } else {

                                                finalMonto = sumaParcial2 - cantidadADespachar;
                                                NuevoMonto = cantidadNueva - finalMonto;

                                                // extrae indice en tabla recid del articulo modificado
                                                var recidID = parseInt(w2ui[subGridName].records[i].recid);
                                                var local_CodMaterial = w2ui[subGridName].records[i].codMaterial2;
                                                var local_Cantidad = NuevoMonto;
                                                var local_Serielote = w2ui[subGridName].records[i].loteSerie2;
                                                var local_fechaVto = w2ui[subGridName].records[i].fechaVencimiento2;

                                                //Elimina el antiguo calculo de final y cambia x el nuevo.
                                                //                                            w2ui[subGridName].select(recidID);
                                                //                                            w2ui[subGridName].delete(true);
                                                w2ui[subGridName].remove(recidID);

                                                //w2ui[subGridName].add({ recid: recidID ,codMaterial2: w2ui['grid'].records[idLocalTemp - 1].codMaterial, cantidad2: calculaMonto, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2 });
                                                w2ui[subGridName].add({ recid: recidID, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });

                                                // Se permite el Save.
                                                Global_SaveSubGrid = 1;

                                            } // fin if verifica numeros negativos.

                                        } // fin if, ve si es el ultimo valor.
                                    } // fin For, ultimo valor.

                                } // fin datos 3

                            } else { // Correlativo no existe.

                                $.ajax({
                                    type: "POST",
                                    url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/getDetalleProductosDespOtrasInst.ashx",
                                    async: false,
                                    data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[idLocalTemp - 1].codMaterial },
                                    dataType: "json",
                                    success: function (response) {

                                        var cantidadADespachar = parseInt(w2ui['grid'].records[idLocalTemp - 1].cantidad);
                                        var sumaParcial = 0;
                                        var sumaCheck = 0;

                                        // Carga articulos Grid1
                                        w2ui[subGridName].clear();
                                        var recidID = 1;

                                        // Transcribe los nuevos Records o articulos actualmente disponibles.
                                        for (var i = 0; i < response.records.length; i++) {

                                            var cantidadNueva = parseInt(response.records[i].cantidad2);

                                            if (cantidadADespachar > sumaParcial) {

                                                w2ui[subGridName].add({ recid: recidID, codMaterial2: w2ui['grid'].records[idLocalTemp - 1].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2 });
                                                recidID = recidID + 1;
                                                sumaParcial = sumaParcial + cantidadNueva;

                                            } // fin if
                                        } // fin for

                                    } // Fin success
                                }); // fin ajax		

                                var cantidadADespachar = parseInt(w2ui['grid'].records[idLocalTemp - 1].cantidad);
                                var sumaParcial2 = 0;


                                // Elimina el ultimo dato y lo adapta a lo solicitado.
                                for (var i = 0; i <= w2ui[subGridName].records.length - 1; i++) {

                                    var cantidadNueva = parseInt(w2ui[subGridName].records[i].cantidad2);

                                    sumaParcial2 = sumaParcial2 + cantidadNueva;

                                    if (i == w2ui[subGridName].records.length - 1) {

                                        var calculaMonto = 0;
                                        var finalMonto = 0;

                                        if (cantidadADespachar > sumaParcial2) {

                                            alert('Monto Solicitado  >' + ' ' + cantidadADespachar + ' ' + '<,  excede la existencia de materiales con "Fecha de Vencimiento".');
                                            alert('El maximo en existencia con fecha son :  ' + sumaParcial2);

                                            // No se permite el Save.
                                            Global_SaveSubGrid = 0;

                                        } else {

                                            finalMonto = sumaParcial2 - cantidadADespachar;
                                            NuevoMonto = cantidadNueva - finalMonto;

                                            // extrae indice en tabla recid del articulo modificado
                                            var recidID = parseInt(w2ui[subGridName].records[i].recid);
                                            var local_CodMaterial = w2ui[subGridName].records[i].codMaterial2;
                                            var local_Cantidad = NuevoMonto;
                                            var local_Serielote = w2ui[subGridName].records[i].loteSerie2;
                                            var local_fechaVto = w2ui[subGridName].records[i].fechaVencimiento2;

                                            //Elimina el antiguo calculo de final y cambia x el nuevo.
                                            //                                            w2ui[subGridName].select(recidID);
                                            //                                            w2ui[subGridName].delete(true);
                                            w2ui[subGridName].remove(recidID);

                                            //w2ui[subGridName].add({ recid: recidID ,codMaterial2: w2ui['grid'].records[idLocalTemp - 1].codMaterial, cantidad2: calculaMonto, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2 });
                                            w2ui[subGridName].add({ recid: recidID, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });

                                            // Se permite el Save.
                                            Global_SaveSubGrid = 1;

                                        } // fin if verifica numeros negativos.

                                    } // fin if, ve si es el ultimo valor.
                                } // fin For, ultimo valor.

                            } // fin if correlativo existe.

                            // ----------------------------------
                            // Fin, maneja los datos del Sub Grid
                            // ----------------------------------

                            // end if 2014.
                        } else {
                            $('#' + event.box_id).w2grid({
                                name: 'subgrid-' + event.recid,
                                show: { columnHeaders: true,
                                    toolbar: false,
                                    toolbarAdd: false,
                                    toolbarDelete: false,
                                    toolbarSave: false,
                                    toolbarSearch: false,
                                    toolbarReload: false,
                                    toolbarColumns: false
                                },
                                fixedBody: false,
                                columns: [
						            { field: 'codMaterial2', caption: 'Cod. Material', size: '30%' },
						            { field: 'cantidad2', caption: 'Cantidad', size: '30%' },
						            { field: 'loteSerie2', caption: 'Serie o Lote', size: '30%' },
						            { field: 'fechaVencimiento2', caption: 'Fecha Vto.', size: '30%' }
					            ]
                                ,
                                records: [
						            { recid: '', codMaterial2: '---', cantidad2: '0', loteSerie2: '---', fechaVencimiento2: '01/01/1900' }
					            ]
                                // -------------------------

                            });
                            w2ui['subgrid-' + event.recid].resize();
                        } // end IF prueba que sea arriba de 2014

                        // fin if cosulta si esta la bodega.
                    } else {
                        alert('Primero debe indicar la BODEGA en la que se recibirá el material. ');
                        //                        w2ui['grid'].select('');
                        //                        w2ui['grid'].delete(true);
                        w2ui['grid'].remove('');
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', existencia: '', loteSerie: '', fechaVencimiento: '' });
                    }

                }, 300); // fin set time out.

            }
            ,
            //===========================


            // Cambio en la grilla.
            onChange: function (event) {

                // valida que la descripcion este escrita.
                if (w2ui['form'].record['descripcion']) {
                } else {
                    w2ui['form'].record['descripcion'] = '';
                    w2ui['form'].refresh();
                }

                // -----------------------------------
                // Verifica si modifica la columna ID.
                if (event.column == 0) {

                    // Comprueba que el campo bodega este comleto.
                    if (w2ui['form'].record['Nombre_Bodega']) {

                        if (event.recid == "") {

                            $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Recepciones/RecepcionxPrestamo/getBusquedaxCodigoRecepxSoliPrestamo.ashx",
                                async: false,
                                data: { "codigoMaterial": event.value_new, "codBodega": w2ui['form'].record['Nombre_Bodega'] },
                                dataType: "json",
                                success: function (response) {

                                    if (response.item == "null") {

                                        alert('¡Error, código no valido!')
                                        //                                    w2ui['grid'].select('');
                                        //                                    w2ui['grid'].delete(true);
                                        w2ui['grid'].remove('');
                                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', existencia: '', loteSerie: '', fechaVencimiento: '' });

                                    } else {

                                        var precio = parseInt(response.precio);
                                        var totalParcial = 1 * precio;

                                        // Ingresa un nuevo elemento al grid.
                                        var Id_Grid1 = w2ui['grid'].records.length;
                                        //                                    w2ui['grid'].select('');
                                        //                                    w2ui['grid'].delete(true);
                                        w2ui['grid'].remove('');
                                        w2ui['grid'].add({ recid: Id_Grid1, codMaterial: event.value_new, nombreMaterial: response.descripcion, item: response.item, cantidad: 1, valor: response.precio, total: totalParcial, existencia: response.existencia, loteSerie: '', fechaVencimiento: '' });
                                    } // Fin Validador de codigo

                                } // Fin success
                            }); // fin ajax

                        } // Fin iF ""
                    } else {
                        alert('Primero debe indicar la BODEGA en la que se recibirá el material. ');
                        //                        w2ui['grid'].select('');
                        //                        w2ui['grid'].delete(true);
                        w2ui['grid'].remove('');
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', existencia: '', loteSerie: '', fechaVencimiento: '' });
                    }
                } // Fin if 0


                // ----------------------------------------
                // Verifica si se modifico la columna Cantidad.
                if (event.column == 3) {

                    var local_Codigo;
                    var local_Nombre;
                    var local_Item;
                    var local_Valor;
                    var local_Existencia;
                    var local_Serie;
                    var local_Fecha;

                    if (event.recid == "") {
                        alert('¡Error, Primero ingresar el codigo.')
                        //                    w2ui['grid'].select(event.recid);
                        //                    w2ui['grid'].delete(true);
                        w2ui['grid'].remove(event.recid);
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', existencia: '', total: '', loteSerie: '', fechaVencimiento: '' });
                    } else {

                        if (event.value_new >= 1) {

                            for (var i = 0; i < w2ui['grid'].records.length; i++) {

                                if (event.recid == w2ui['grid'].records[i].recid) {

                                    local_Codigo = w2ui['grid'].records[i].codMaterial;
                                    local_nombre = w2ui['grid'].records[i].nombreMaterial;
                                    local_Item = w2ui['grid'].records[i].item;
                                    local_Valor = w2ui['grid'].records[i].valor;
                                    local_Existencia = w2ui['grid'].records[i].existencia;

                                    // Para valiar que la serie o lote este ingresado.
                                    if (w2ui['grid'].records[i].loteSerie == "") {
                                        local_Serie = "";
                                    } else {
                                        local_Serie = w2ui['grid'].records[i].loteSerie;
                                    }

                                    // Para valiar que la fecha este ingresada.
                                    if (w2ui['grid'].records[i].fechaVencimiento == "") {
                                        local_Fecha = "";
                                    } else {
                                        local_Fecha = w2ui['grid'].records[i].fechaVencimiento;
                                    }
                                }
                            } // fin for.

                            var precio = parseInt(local_Valor)
                            var total = event.value_new * precio;

                            //                        w2ui['grid'].select('');
                            //                        w2ui['grid'].delete(true);
                            //                        w2ui['grid'].select(event.recid);
                            //                        w2ui['grid'].delete(true);
                            w2ui['grid'].remove('');
                            w2ui['grid'].remove(event.recid);

                            // Para valiar que la fecha este ingresada.
                            if (local_Fecha == "" || local_Serie == "") {
                                w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cantidad: event.value_new, valor: local_Valor, total: total, existencia: local_Existencia, loteSerie: local_Serie, fechaVencimiento: local_Fecha });
                            } else {
                                w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cantidad: event.value_new, valor: local_Valor, total: total, existencia: local_Existencia, loteSerie: local_Serie, fechaVencimiento: local_Fecha });
                                w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });
                            }

                        } // Fin if valor nuevo mayor a 1

                        if (event.value_new == 0) {

                            alert('¡Error, la cantidad no puede ser 0.')

                            for (var i = 0; i < w2ui['grid'].records.length; i++) {

                                if (event.recid == w2ui['grid'].records[i].recid) {

                                    local_Codigo = w2ui['grid'].records[i].codMaterial;
                                    local_nombre = w2ui['grid'].records[i].nombreMaterial;
                                    local_Item = w2ui['grid'].records[i].item;
                                    local_Valor = w2ui['grid'].records[i].valor;
                                    local_Existencia = w2ui['grid'].records[i].existencia;

                                    // Para valiar que la serie o lote este ingresado.
                                    if (w2ui['grid'].records[i].loteSerie == "") {
                                        local_Serie = "";
                                    } else {
                                        local_Serie = w2ui['grid'].records[i].loteSerie;
                                    }

                                    // Para valiar que la fecha este ingresada.
                                    if (w2ui['grid'].records[i].fechaVencimiento == "") {
                                        local_Fecha = "";
                                    } else {
                                        local_Fecha = w2ui['grid'].records[i].fechaVencimiento;
                                    }
                                }
                            } // fin for.

                            //                        w2ui['grid'].select(event.recid);
                            //                        w2ui['grid'].delete(true);
                            //                        w2ui['grid'].select('');
                            //                        w2ui['grid'].delete(true);
                            w2ui['grid'].remove('');
                            w2ui['grid'].remove(event.recid);
                            var precio = parseInt(local_Valor)
                            var totalParcial = 1 * precio;

                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cantidad: 1, valor: local_Valor, total: totalParcial, existencia: local_Existencia, loteSerie: local_Serie, fechaVencimiento: local_Fecha });
                        } // Fin if valor = 0
                    } // Fin if verificardor de rcid vacio.

                } // Fin if 3

            },
            //-------------------------

            onDelete: function (event) {

                event.preventDefault();

                if (!w2ui['form'].record['NDonacion'] || Global_SaveComplete == 1) {

                    if (w2ui['form'].record['NDonacion'] && Global_SaveComplete == 1) {
                        /* elimina de la tabla temporal el valor ingresado*/
                        $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/deleteTemp_DespPresOtrasInstituciones.ashx",
                            async: false,
                            data: { "NumeroDonacionArticulo": 'P', "CodigoMaterial": w2ui['grid'].records[w2ui['grid'].getSelection() - 1].codMaterial, "NDonacionActual": w2ui['form'].record['NDonacion'] },
                            dataType: "json",
                            success: function (response) {

                                if (response.item == "done") {

                                } // Fin Validador de codigo

                            } // Fin success
                        }); // fin ajax
                    }

                    w2ui['grid'].remove(w2ui['grid'].getSelection());
                    w2ui['grid'].remove('');

                    var totalData = w2ui['grid'].records.length;
                    var x = 0;
                    var topRecid = 0;

                    // busca el recid mas alto ingresado.

                    try {
                        topRecid = w2ui['grid'].records[w2ui['grid'].records.length - 1].recid;
                    } catch (err) {

                    }

                    var i = 0;
                    var cantData = topRecid;

                    // ingresa los mismos recid con un indicador mas alto
                    while (i < totalData) {

                        try {
                            if (this.records[i].codMaterial) {

                                CodigoMaterial = w2ui['grid'].records[i].codMaterial;
                                NombreMaterial = w2ui['grid'].records[i].nombreMaterial;
                                ItemMaterial = w2ui['grid'].records[i].item;
                                CantidadMovimiento = w2ui['grid'].records[i].cantidad;
                                PrecioUnitario = w2ui['grid'].records[i].valor;
                                totalParcial = w2ui['grid'].records[i].total;
                                existencia = w2ui['grid'].records[i].existencia;

                                cantData = cantData + 1;
                                w2ui['grid'].add({ recid: cantData, codMaterial: CodigoMaterial, nombreMaterial: NombreMaterial, item: ItemMaterial, cantidad: CantidadMovimiento, valor: PrecioUnitario, total: totalParcial, existencia: existencia });
                                i = i + 1;
                            }
                        }
                        catch (err) {
                            i = i + 1;
                        }
                    }

                    // elimina los antiguos recid
                    var removeClone = 0;

                    while (removeClone < totalData) {
                        try {
                            if (this.records[0].codMaterial) {
                                w2ui['grid'].remove(w2ui['grid'].records[0].recid);
                                removeClone = removeClone + 1;
                            }
                        }
                        catch (err) {
                            removeClone = removeClone + 1;
                        }
                    }

                    /* regresa los datos a los recid en orden del 1 en adelante*/
                    var z = 0;
                    var newRecid = 0;

                    while (z < totalData) {

                        try {
                            if (this.records[z].codMaterial) {

                                var datos = 0;

                                $.ajax({
                                    type: "POST",
                                    url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/buscaCorrelativoDespOtrasInstituciones.ashx",
                                    async: false,
                                    data: { "fecha": w2ui['form'].record['anioPrestamo'], "Ncorrelativo": w2ui['form'].record['NDonacion'], "CodMaterial": w2ui['grid'].records[z].codMaterial },
                                    dataType: "json",
                                    success: function (response) {

                                        if (response.item == "null") {

                                            alert('¡Error, Correlativo no encontrado!')

                                        } else {
                                            var tabla = parseInt(response.Tabla)

                                            if (tabla == 1) {
                                                datos = 1;
                                            }
                                            if (tabla == 2) {
                                                datos = 2;
                                            }

                                            if (tabla == 3) {
                                                datos = 3;
                                            }
                                        } // Fin Validador de codigo

                                    } // Fin success
                                }); // fin ajax


                                //alert(datos);

                                // Tabla 1, busca los ya ingresados.
                                if (datos == 1 || datos == 2) {

                                    CodigoMaterial = w2ui['grid'].records[z].codMaterial;
                                    NombreMaterial = w2ui['grid'].records[z].nombreMaterial;
                                    ItemMaterial = w2ui['grid'].records[z].item;
                                    CantidadMovimiento = w2ui['grid'].records[z].cantidad;
                                    PrecioUnitario = w2ui['grid'].records[z].valor;
                                    totalParcial = w2ui['grid'].records[z].total;
                                    existencia = w2ui['grid'].records[z].existencia;

                                    newRecid = newRecid + 1;
                                    w2ui['grid'].add({ recid: newRecid, codMaterial: CodigoMaterial, nombreMaterial: NombreMaterial, item: ItemMaterial, cantidad: CantidadMovimiento, valor: PrecioUnitario, total: totalParcial, existencia: existencia, "style": "background-color: #C2F5B4" });
                                    z = z + 1;

                                } else {

                                    CodigoMaterial = w2ui['grid'].records[z].codMaterial;
                                    NombreMaterial = w2ui['grid'].records[z].nombreMaterial;
                                    ItemMaterial = w2ui['grid'].records[z].item;
                                    CantidadMovimiento = w2ui['grid'].records[z].cantidad;
                                    PrecioUnitario = w2ui['grid'].records[z].valor;
                                    totalParcial = w2ui['grid'].records[z].total;
                                    existencia = w2ui['grid'].records[z].existencia;

                                    newRecid = newRecid + 1;
                                    w2ui['grid'].add({ recid: newRecid, codMaterial: CodigoMaterial, nombreMaterial: NombreMaterial, item: ItemMaterial, cantidad: CantidadMovimiento, valor: PrecioUnitario, total: totalParcial, existencia: existencia });
                                    z = z + 1;

                                }
                            }
                        }
                        catch (err) {
                            z = z + 1;
                        }
                    }

                    var removeOldClone = 0;

                    while (removeOldClone < totalData) {
                        try {
                            if (this.records[0].codMaterial) {
                                w2ui['grid'].remove(w2ui['grid'].records[0].recid);
                                removeOldClone = removeOldClone + 1;
                            }
                        }
                        catch (err) {
                            removeOldClone = removeOldClone + 1;
                        }
                    }

                    /* Luego de clonar los datos mas un nuevo recid y eliminar los primeros datos clonados.
                    Se verifica si el ultimo ingreso esta completo. De estarlo se ingresa un nuevo vacio para nuevos ingresos
                    De no estar completo se continua con el proceso regular*/
                    //, "style": "background-color: #C2F5B4" });

                    if (w2ui['grid'].records.length >= 1) {

                        controlVacio = w2ui['grid'].records.length - 1;

                        //Verifica si los datos vienen de la principal o la temporal.

                        if ((w2ui['grid'].records[controlVacio].fechaVencimiento == "" || w2ui['grid'].records[controlVacio].loteSerie == "")) {

                        } else {
                            w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', existencia: '' });
                        }

                    } else {
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', existencia: '' });
                    }

                } else {
                    alert('No se permite eliminar datos ya ingresados.')
                } // fin, verifica que no existan datos cargados.

            },

            // ================================
            // Grabar nueva Donación.
            onSave: function (event) {

                // valida que la descripcion este escrita.
                if (w2ui['form'].record['descripcion']) {
                } else {
                    w2ui['form'].record['descripcion'] = '';
                    w2ui['form'].refresh();
                }


                // ================================

                // Obtiene Numero Correlativo
                // ================================

                var grabar = 0;

                $.ajax({
                    type: "POST",
                    url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/buscaCorrelativoDespOtrasInstituciones.ashx",
                    async: false,
                    data: { "fecha": w2ui['form'].record['anioPrestamo'], "Ncorrelativo": w2ui['form'].record['NDonacion'], "CodMaterial": '' },
                    dataType: "json",
                    success: function (response) {

                        if (response.item == "null") {

                            alert('¡Error, Correlativo no encontrado!')

                        } else {
                            var tabla = parseInt(response.Tabla)

                            if (tabla == 1) {
                                grabar = 1;
                            }
                        } // Fin Validador de codigo

                    } // Fin success
                }); // fin ajax

                if (grabar == 1) {
                    alert('Ud. NO puede grabar la Donación por que esta ya EXISTE.')
                } else {

                    // if valida que la institucion sea seleccionada.
                    if (w2ui['grid'].records.length > 0 && w2ui['form'].record['Nombre_Bodega'] && w2ui['form'].record['Nombre_Institucion']) {

                        // Verifica que el Grid Contenga Datos.
                        if (w2ui['grid'].records[w2ui['grid'].records.length - 1].codMaterial == '' || w2ui['grid'].records[w2ui['grid'].records.length - 1].recid == '') {

                            // ==========================

                            // Graba el Movimiento
                            // ==========================

                            // Se elimina la celda de codigo '', para poder guardar los datos actuales.
                            //                        w2ui['grid'].select('');
                            //                        w2ui['grid'].delete(true);
                            w2ui['grid'].remove('');

                            $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/saveMovimiento.ashx",
                                async: false,
                                data: { "fecha": w2ui['form'].record['anioPrestamo'], "NumeroDonacionArticulo": 'P', "NumeroCorrelativo": w2ui['form'].record['NDonacion'] },
                                dataType: "json",
                                success: function (response) {

                                    if (response.item == "null") {
                                        alert('Error!, al grabar el movimiento')
                                    } else {
                                    } // Fin Validador de codigo

                                } // Fin success
                            }); // fin ajax

                            // ===========================

                            // Graba Detalle de Movimiento
                            // ===========================


                            $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/saveDetalleMovimientoPresOtrasInst.ashx",
                                async: false,
                                data: { "fecha": w2ui['form'].record['anioPrestamo'], "NumeroCorrelativo": w2ui['form'].record['NDonacion'] },
                                dataType: "json",
                                success: function (response) {

                                    if (response.item == "done") {

                                    } // Fin Validador de codigo

                                } // Fin success
                            }); // fin ajax


                            // ===========================

                            // Graba el Prestamo.
                            // ===========================   

                            // Modifica el valor Total
                            var total = 0;
                            for (var i = 0; i <= w2ui['grid'].records.length - 1; i++) {
                                total = total + parseInt(w2ui['grid'].records[i].total);
                            }

                            $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/savePrestamoDespOtrasInstituciones.ashx",
                                async: false,
                                data: { "fecha": w2ui['form'].record['anioPrestamo'], "NumeroDonacionArticulo": 'P', "NumeroCorrelativo": w2ui['form'].record['NDonacion'], "fechaCompleta": w2ui['form'].record['fechaServidor'], "descripcion": w2ui['form'].record['descripcion'], "valor": total, "numeroDoc": 1, "Instituto": w2ui['form'].record['Nombre_Institucion'] },
                                dataType: "json",
                                success: function (response) {

                                    if (response.item == "done") {

                                        alert('¡Registro completado con éxito!');

                                    } // Fin Validador de codigo

                                } // Fin success
                            }); // fin ajax


                        } // fin if Verifica que el Grid Contenga Datos.


                    } else {
                        alert('¡Error, Faltan datos en el formulario!')
                    } // end if valida institucion bodega datos del form.

                    // se recorre para saber que estan los datos guardados. se compara el cod en blanco comparado a la extencion de el grid.

                } // Fin verifica si existe correlativo.


                // ===========================
            } // Fin Save.
            // ===========================
        });

            // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
			$('#form2').w2form({
			    name: 'form2',
			    style: 'border: 0px; background-color: #f5f6f7',
			    formHTML:
                '</div>' +
		            '<div class="w2ui-buttons">' +
		            '	<input type="button" value="Buscar Préstamo" onclick="openPopup()" name="buscar" style="width: 128px;">' +
		            '	<input type="button" value="Limpiar" name="limpiar">' +
                    '	<input type="button" value="Imprimir" name="imprimir">' +
                    //'	<input type="button" value="ImprimirQR" name="imprimirQR">' +
                    '</div>'+
		            '</div>',
			    actions: { 

			        "limpiar": function () {
                        // Pagina Principal
                        w2ui['grid'].clear();
                        w2ui['grid'].add({ recid: '', nombreMaterial: '', item: '', cantidad: '', valor:'', total: '' });
                        w2ui['form'].reload();
                        // Form Buscar
                        w2ui['form3'].clear();
                        w2ui['grid2'].clear();
                     },

                    /*===================================*/

                    "imprimir": function () {
                        var NTransaccion;
                        var fechaTransaccion;
                        var bodega;
                        var programaMinsal;
                        var periodo;
                        var descripcion;
                        var numeroLinea;
                        var codMaterial;
                        var nombreMaterial;
                        var cantMaterial;
                        var valorUnitario;

                        // Identifica ID de busqueda.
                        if (w2ui['form'].record['NDonacion']) {
                            NTransaccion = w2ui['form'].record['NDonacion'];

                            if (w2ui['form'].record['fechaServidor']) {
                                fechaTransaccion = w2ui['form'].record['fechaServidor'];

                                if (w2ui['form'].record['Nombre_Bodega']) {
                                    bodega = $('#Nombre_Bodega option:selected').text();
                                    var div_bodega = bodega.split("-")
                                    bodega = div_bodega[1];

                                    if (w2ui['form'].record['Nombre_Institucion']) {
                                        programaMinsal = $('#Nombre_Institucion option:selected').text();
                                        var div_Minsal = programaMinsal.split("-")
                                        programaMinsal = div_Minsal[1];

                                        if (w2ui['form'].record['anioPrestamo']) {
                                            periodo = w2ui['form'].record['anioPrestamo'];

                                            /* Graba materiales en la tabla TEMP */
                                            var cont = 1;
                                            var CodigoMaterial;
                                            var NombreMaterial;
                                            var ItemMaterial;
                                            var CantidadMovimiento;
                                            var PrecioUnitario;

                                            var done = 0;
                                            var ReportUsuario = '';

                                            for (var i = 0; i <= w2ui['grid'].records.length - 1; i++) {

                                                CodigoMaterial = w2ui['grid'].records[i].codMaterial;
                                                NombreMaterial = w2ui['grid'].records[i].nombreMaterial;
                                                ItemMaterial = w2ui['grid'].records[i].item;
                                                CantidadMovimiento = w2ui['grid'].records[i].cantidad;
                                                PrecioUnitario = w2ui['grid'].records[i].valor;
                                                NSerielote = w2ui['grid'].records[i].loteSerie;
                                                fechaVencimiento = w2ui['grid'].records[i].fechaVencimiento;

                                                $.ajax({
                                                    type: "POST",
                                                    url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                                                    async: false,
                                                    data: { "cmd": 'RPTInforme', "NTransaccion": NTransaccion, "periodo": periodo, "codTransaccion": 'P', "Linea": cont, "codMaterial": CodigoMaterial, "nombreMaterial": NombreMaterial, "CodItem": '', "cantMaterial": CantidadMovimiento, "precioMaterial": PrecioUnitario, "bodega": bodega, "descripcion": w2ui['form'].record['descripcion'], "fechaMovimieno": fechaTransaccion, "proveedor": '', "ordenCompra": '0', "ordenCompraEstado": '', "numeroDocumento": '0', "Institucion": programaMinsal, "centroCosto": '', "tipoDocumento": '', "tituloMenu": 'RECEPCIÓN A OTRAS INSTITUCIONES', "descuento": '0', "impuesto": '0', "diferenciaPeso": '0', "usuario": '' },
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

                                                cont = cont + 1;

                                            } // Fin for.

                                            if (done == 0) {
                                                window.open('../../reportes/Despachos/PrestamoInstituciones/RptVentana_PrestInstituciones.aspx?CMVCodigo=' + NTransaccion + '&PERCodigo=' + periodo + '&TMVCodigo=' + 'P' + '&usuario=' + ReportUsuario);
                                            } else {
                                                alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                            }

                                        } else { alert("Faltan datos para imprimir."); } // Fin nombre anio donacion.
                                    } else { alert("Faltan datos para imprimir."); } // Fin nombre Programa.
                                } else { alert("Faltan datos para imprimir."); } // Fin nombre Bodega.
                            } else { alert("Faltan datos para imprimir."); } // Fin fechaTransaccion.
                        } else { // alerta de mensaje por no ingresar nada.
                            alert("Primero ingrese o búsque un préstamo.");
                        }

                    }, // fin imprimir

                    /*===================================*/

			        "imprimirQR": function () {

                        if(w2ui['form'].record['NDonacion']){
                        
                            // Verifica si los datos vienen de la principal o la temporal.
                            var datos = 0;

                            $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/buscaCorrelativoDespOtrasInstituciones.ashx",
                            async: false,
                            data: { "fecha": w2ui['form'].record['anioPrestamo'], "Ncorrelativo": w2ui['form'].record['NDonacion'],  "CodMaterial": w2ui['grid'].records[0].codMaterial },
                            dataType: "json",
                            success: function (response) {
                    
                                if(response.item == "null"){

                                    alert('¡Error, Correlativo no encontrado!')
 
                                }else{
                                    var tabla = parseInt(response.Tabla)

                                    if(tabla == 1){
                                        datos = 1;
                                    }
                                    if(tabla == 2){
                                        datos = 2;
                                    }

                                    if(tabla == 3){
                                        datos = 3;
                                    }
                                } // Fin Validador de codigo

                            }// Fin success
                            });// fin ajax


                            /* Existe para procesar QR*/
                            if(datos == 1){
                                window.open('../../generadorQR/Despachos/PrestamoOtrasInstituciones/QR_PrestamoOtrasInstitu.aspx?TMVCodigo=' + 'P' +'&PerCodigo='+ w2ui['form'].record['anioPrestamo'] + '&ID=' + w2ui['form'].record['NDonacion']);                        
                            }else{
                                alert(" Primero se necesita guardar la operación. ");
                            }
                            
                        }else{ // alerta de mensaje por no ingresar nada.
                            alert("Primero Identifique Recepción que desea Imprimir");
                        }

                    }// Fin Imprimir
			    }
			});

			// --- POPUP GRID ----
            function openPopup () {
                $().w2form({
                    name: 'foo',
                    style: 'border: 0px; background-color: transparent;',
                    formHTML:
			            '<div class="w2ui-page page-0">' +
			            '	<div class="w2ui-label">Cod. Material:</div>' +
			            '	<div class="w2ui-field">' +
			            '		<input name="codMaterial" type="text" size="35"/>' +
			            '	</div>' +
			            '	<div class="w2ui-label">Nombre Material:</div>' +
			            '	<div class="w2ui-field">' +
			            '		<input name="nomMaterial" type="text" size="35"/>' +
			            '	</div>' +
			            '	<div class="w2ui-label">Item:</div>' +
			            '	<div class="w2ui-field">' +
			            '		<input name="item" type="text" size="35"/>' +
			            '	</div>' +
                        '	<div class="w2ui-label">Cantidad:</div>' +
			            '	<div class="w2ui-field">' +
			            '		<input name="cantidad" type="text" size="35"/>' +
			            '	</div>' +
                        '	<div class="w2ui-label">Valor:</div>' +
			            '	<div class="w2ui-field">' +
			            '		<input name="valor" type="text" size="35"/>' +
			            '	</div>' +
			            '</div>' +
			            '<div class="w2ui-buttons">' +
			            '	<input type="button" value="Reset" name="reset">' +
			            '	<input type="button" value="Save" name="save">' +
			            '</div>',
                    fields: [
			            { name: 'codMaterial', type: 'text', required: true },
			            { name: 'nomMaterial', type: 'text', required: true },
                        { name: 'item', type: 'text', required: true },
                        { name: 'cantidad', type: 'int', required: true },
			            { name: 'valor', type: 'int', required: true },
		            ]
                    ,
                    actions: {
                        "save": function () {
                        var total = (w2ui['foo'].record.cantidad * w2ui['foo'].record.valor)
                        w2ui['grid'].add({ recid: w2ui['foo'].record.codMaterial, nombreMaterial: w2ui['foo'].record.nomMaterial, item: w2ui['foo'].record.item, cantidad: w2ui['foo'].record.cantidad, valor: w2ui['foo'].record.valor, total: total });
                        w2ui['foo'].clear();
                        },
                        "reset": function () { this.clear(); }
                    }
                });


	            $().w2popup('open', {
	                title: 'Ingreso de Artículos',
		            body	: '<div id="form" style="width: 100%; height: 100%;"></div>',
		            style	: 'padding: 15px 0px 0px 0px',
		            width	: 500,
		            height	: 290, 
		            showMax : true,
		            onMin	: function (event) {
			            $(w2ui.foo.box).hide();
			            event.onComplete = function () {
				            $(w2ui.foo.box).show();
				            w2ui.foo.resize();
			            }
		            },
		            onMax	: function (event) {
			            $(w2ui.foo.box).hide();
			            event.onComplete = function () {
				            $(w2ui.foo.box).show();
				            w2ui.foo.resize();
			            }
		            },
		            onOpen	: function (event) {
			            event.onComplete = function () {
				            $('#w2ui-popup #form').w2render('foo');
			            }
		            }
	            });
            }

		
        // --- POPUP BUSCAR ----            --- POPUP BUSCAR ----
        var config = {
	        layout: {
		        name: 'layout',
		        padding: 4,
		        panels: [
			        { type: 'left', size: '60%', resizable: true, minSize: 300 },
			        { type: 'main', minSize: 300 }
		        ]
	        },

            // GRID DEL POPUP
	        grid2: { 
		        name: 'grid2',
		        columns: [
			        { field: 'FLD_CMVNUMERO', caption: 'N° Donación', size: '17%', sortable: true, searchable: true },
                    { field: 'FLD_PERCODIGO', caption: 'Año Donación', size: '19%', sortable: true, searchable: true },
			        { field: 'FLD_PREFECHA', caption: 'Fecha', size: '19%', sortable: true, searchable: true },
			        { field: 'FLD_PREDESCRIPCION', caption: 'Descripción', size: '45%' }
		        ]
	        },

            // FORM DEL POPUP
	        form3: { 
		        header: 'Busqueda de Préstamo',
		        name: 'form3',
		        fields: [
			        { name: 'NDonacion', type: 'text', required: true, html: { caption: 'Número Donación', attr: 'size="10" maxlength="10"' } },
			        { name: 'FDonacion', type: 'list', required: true, html: { caption: 'Periodo' },
		                options: {
		                    url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/BuscarDonaciones.ashx',
		                    showNone: true
		                }
		            }
		        ],
		        record: { 
			        NDonacion	: ''
		        },
		        actions: {
			        Buscar: function () { 

                        // Busqueda por fecha.
                        if (w2ui['form3'].record.FDonacion >= 0){
                            w2ui['grid2'].url = '../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/cargaHistorialxFechaDespOtrasInst.ashx?FechaPrestamo=' + w2ui['form3'].record.FDonacion;
                            w2ui['grid2'].reload();
                        }
                        // Busqueda por numero de donación.
                        else if (w2ui['form3'].record.NDonacion != ''){
                           w2ui['grid2'].url = '../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/cargaHistorialxNPrestamoDespOtrasInst.ashx?NumeroPrestamo=' + w2ui['form3'].record.NDonacion;
                           w2ui['grid2'].reload();
                        }
                          // alerta de mensaje por no ingresar nada.
                          else{
                            alert("Ingrese Elemento de Busqueda");
                          }
  
			        },
                    Limpiar: function () {
                        this.clear();
                        w2ui['grid2'].clear();
			        },
			        Aceptar: function () {
                        
                        var local_CodBodega;
                        var local_Institucion;

                      // Busca Institucion.
                      $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/cargaHistorialxFechaDespOtrasInst.ashx",
                        async: false,
                        data: { "FechaPrestamo": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO },
                        dataType: "json",
                        success: function (response) {

                            for (var i = 0; i < response.records.length; i++){ 
                                if(response.records[i].FLD_CMVNUMERO == w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO){
                                    local_Institucion = response.records[i].INSTITUTO;
                                }
                            }    

                         }// Fin success
                      });// fin ajax



                      // Busca Bodega y Articulos Asociados.
                      $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/getHistoricoArticulosAGrid1DespOtrasInst.ashx",
                        async: false,
                        data: { "codigo": 'P', "Periodo": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO, "Numero": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO },
                        dataType: "json",
                        success: function (response) {

                            // Carga articulos Grid1
                            w2ui['grid'].clear();
                            var recidID = 1;
                            for (var i = 0; i < response.articulo.length; i++){ 
                                w2ui['grid'].add({ recid: recidID, codMaterial: response.articulo[i].FLD_MATCODIGO, nombreMaterial: response.articulo[i].FLD_MATNOMBRE, item: response.articulo[i].FLD_ITECODIGO, cantidad: response.articulo[i].FLD_CANTIDAD, valor: response.articulo[i].FLD_PRECIOUNITARIO, total: response.articulo[i].FLD_TOTAL_PRESTAMO,  existencia: response.articulo[i].FLD_EXICANTIDAD, loteSerie: response.articulo[i].Nserie, fechaVencimiento: response.articulo[i].FechaVto });
                                recidID = recidID + 1;
                            }

                            // Guarda valor de Bodega.
                            local_CodBodega = response.articulo[0].bodega;

                         }// Fin success
                      });// fin ajax


                        // Trascribe al Form la Bodega y la Institución.
                        w2ui['form'].record = {
                            Nombre_Bodega: local_CodBodega,
                            Nombre_Institucion: local_Institucion
                        }

                        // Traspado valores al principal.
                        w2ui['form'].record['fechaServidor'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PREFECHA;
                        w2ui['form'].record['anioPrestamo'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PERCODIGO;
                        w2ui['form'].record['descripcion'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PREDESCRIPCION;
                        w2ui['form'].record['NDonacion'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_CMVNUMERO;
                        w2ui['form'].refresh();
                        w2popup.close();

                        // Limpia el popUp
                        this.clear();
                        w2ui['grid2'].clear();
                        this.record['NDonacion'] = '';
                        this.refresh();

			       }// Fin boton Aceptar
		        }// Fin Acciones
	        }// fin Form3, Grid2
        } // Fin Config.

        $(function () {
	        // initialization in memory
	        $().w2layout(config.layout);
	        $().w2grid(config.grid2);
	        $().w2form(config.form3);
        });

        function openPopup() {
	        w2popup.open({
		        title 	: 'Historial - Préstamos a Otras Inst.',
		        width	: 900,
		        height	: 400,
		        showMax : true,
		        body 	: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
		        onOpen  : function (event) {
			        event.onComplete = function () {
				        $('#w2ui-popup #main').w2render('layout');
                        w2ui.layout.content('left', w2ui.grid2);
				        w2ui.layout.content('main', w2ui.form3);
			        };
		        },
		        onMax : function (event) { 
			        event.onComplete = function () {
				        w2ui.layout.resize();
			        }
		        },
		        onMin : function (event) {
			        event.onComplete = function () {
				        w2ui.layout.resize();
			        }
		        }
	        });
        }

        function justFecha(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 46) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;

            return /\d/.test(String.fromCharCode(keynum));
        } 

// console.log(w2ui['grid2'].getSelection());

    </script>
</asp:Content>

