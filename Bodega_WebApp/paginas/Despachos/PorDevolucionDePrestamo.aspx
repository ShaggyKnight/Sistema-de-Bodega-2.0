<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="PorDevolucionDePrestamo.aspx.vb" Inherits="Bodega_WebApp.PorDevolucionDePrestamo" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.despaDevolucionDePrestamos%>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:3px; height: 278px; margin-bottom: 4px; margin-top: 2px;">
    </div>
    <div id="grid" style="width: 100%; height: 320px;">
    </div>
    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247);"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">
        /*
          *Solicitudes:
            
          *Correcciones:
            Se reparo el metodo automatico de carga en el sub grid. Ahora existe un check donde que permite una recomendacion de articulos que podrian ser despachados.
            El subGrid ahora cuenta con validaciones manuales y el boton add para agregar una nueva fila, adicionalmente las fechas de vto salen con 4 meses sumados a la fecha atual.
            El lote y/o numero de serie que ingresan del detalle se cambiaron a mayuscula.
            Ahora el grid solo muestra algunas propiedades del grid.
            El ingreso manual valida con el Nserie que el producto exista para eliminar su saldo.
            Nuevo nivel de detalle en TB_DETALLE_EXISTENCIAS
            Boton grabar

          *Pruebas:
            Carga: ok.
            Save: ok.
            Imprime: ok.
            QR: o tiene, si entran los productos ya tienen rotulado.
        */

        // Variables Globales Grid
        var checkRecomendacion = 0;
        var SaveGlobal = 0;

        /* formPrincipal */
        $('#form').w2form({ 
            name: 'form',
            header: 'DEVOLUCIÓN DE PRÉSTAMO',
            style: 'background-color: #f5f6f7;',
            recid: 10,
            url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                        '<div style="width: 446px; margin-left: 20px; float: left;">' +
			                '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			                '<div class="w2ui-group" style="height: 210px;">'+
				                '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Fecha</div>' +
				                '<div class="w2ui-field w2ui-span4">'+
					                '<input name="fechaServidor" type="text" maxlength="100" style="width: 37%;margin-left: 8px;" disabled/>' +
				                '</div>'+
				                '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px;">Periodo</div>' +
				                '<div class="w2ui-field w2ui-span5">'+
					                '<input name="anioDonacion" type="text" maxlength="100" style="width: 36%;margin-left: -12px;" disabled/>' +
				                '</div>'+
				                '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px;">N° Devolución</div>'+
				                '<div class="w2ui-field w2ui-span5">'+
				                '	<input name="NDevolucion" type="text" maxlength="100" style="width: 32%;margin-left: -11px;" disabled/>' +
				                '</div>'+
				                '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Bodega</div>'+
		                        '	<div class="w2ui-field" style="margin-left: 90px !important;">' +
		                        '		<select name="Nombre_Bodega" type="text" style="margin-left: 7px;"/>' +
		                        '	</div>' +
				                '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Institución</div>'+
		                        '	<div class="w2ui-field" style="margin-left: 90px !important;">' +
		                        '		<select name="Nombre_Institucion" type="text" style="margin-left: 7px;"/>' +
		                        '	</div>' +


                                /* Nuevo grupo para valor de recomendación */
                    '           <div class="group col-12" style="height: 35px;">' +
                    '               <div class="col-6">' +

                                '<div class="w2ui-label w2ui-span5" style="width: 104px; margin-left: 12px; text-align: left; margin-top: 12px;">Valor</div>'+
				                '<div class="w2ui-field w2ui-span5">'+
				                '	<input name="valor" type="text" maxlength="100" style="width: 100%; margin-left: -16px;" disabled/>' +
				                '</div>'+

                    '           	</div>' +

                    '               <div class="col-6" style="margin-top: 6px;">' +


		            '	            <div class="w2ui-label w2ui-span3" style="text-align: left; width: 94px; margin-left: 16px;">¿Sugerencia?:</div>' +
		            '	            <div class="w2ui-field w2ui-span4" >' +
		            '		            <input name="recomendacion" id="recomendacion" class="form-control" type=checkbox style="margin-left: 4px; margin-top: 3px;"/>' +
		            '	            </div>' +

                    '               </div>' +

                    '           </div>' +
			                
                            
                            '</div>'+
		           '</div>' +

		        '<div style="margin-left: 490px; width: 340px; width: 364px;">' +
			      '<div style="padding: 3px; font-weight: bold; color: #030303;">Info. de Solicitud del Préstamo</div>'+
			        '<div class="w2ui-group" style="height: 185px;">'+
				    '<div class="w2ui-label w2ui-span5" style="margin-top: 20px; text-align: left; margin-left: 12px;">Periodo</div>' +
				    '<div class="w2ui-field w2ui-span5">'+
					    '<input name="anioPrestamo" type="text" maxlength="100" style="width: 44%; margin-top: 12px;" disabled/>' +
				    '</div>'+
				    '<div class="w2ui-label w2ui-span5" style="margin-top: 9px;margin-left: -18px;">N° Préstamo</div>'+
				    '<div class="w2ui-field w2ui-span5">'+
				    '	<input name="NPrestamo" type="text" maxlength="100" style="width: 44%;margin-left: 1px;"" disabled/>' +
				    '</div>'+
                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 12px; margin-top: 12px;">Fecha</div>' +
				    '<div class="w2ui-field w2ui-span4">'+
					    '<input name="fechaPrestamo" type="text" maxlength="100" style="width: 48%;margin-left: 20px; margin-top: 2px;" disabled/>' +
				    '</div>'+
                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: -80px;">Descripción</div>'+
				    '<div class="w2ui-field w2ui-span4">'+
					'<textarea name="descripcion" type="text" style="width: 78%; height: 48px; resize: none; margin-left: 20px;"></textarea>' +
				    '</div>'+
			      '</div>'+
		        '</div>'+
              '</div>'
                    ,
            fields: [
		            { name: 'fechaServidor', type: 'text' },
                    { name: 'anioDonacion', type: 'text' },
                    { name: 'NDevolucion', type: 'text' },
                    { name: 'descripcion', type: 'text' },
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
                    { name: 'valor', type: 'int' },
                    { name: 'anioPrestamo', type: 'text' },
                    { name: 'NPrestamo', type: 'text' },
                    { name: 'fechaPrestamo', type: 'text' },
                    { name: 'recomendacion', type: 'checkbox' }
                    
	            ],
	                onLoad: function(event) {
		                console.log(event);
	                },
                    
                    onChange: function (event) {
                        if (event.target == "recomendacion") {
                            if (this.fields[10].el.checked) {
                                checkRecomendacion = 1;
                            }else{
                                checkRecomendacion = 0;
                            }
                        }
                    }
        }); // Fin Form1


        $('#grid').w2grid({
            name: 'grid',
            header: 'Lista de Materiales',
            show: {
                header: true,
                footer: true,
                toolbar: true,
                toolbarSave: true,
                toolbarSearch: false,
                toolbarReload: true,
                toolbarColumns: true
            },
            multiSearch: false, 
//            searches: [
//			        { type: 'text', field: 'recid', caption: 'Codigo Material' },
//		        ],
            columns: [
			        { field: 'codMaterial', caption: 'Cod. Material', size: '14%', attr: "align=center"},
			        { field: 'nombreMaterial', caption: 'Nombre Material', size: '26%' },
                    { field: 'item', caption: 'Item', size: '14%' },
                    { field: 'cntDespachado', caption: 'Cnt.Despachada', size: '16%' },
                    { field: 'cntDevuelta', caption: 'Cnt. Devuelta', size: '15%' },
			        { field: 'cntDevolver', caption: 'Cnt. Devolver', size: '15%', sortable: true, resizable: true,
			            editable: { type: 'int', inTag: 'maxlength=4' }, attr: "align=center"
			        },
                    { field: 'PrecioUnitario', caption: 'Precio Unitario', size: '14%' },
                    { field: 'total', caption: 'Total', size: '14%' },
                    { field: 'existencia', caption: 'Existencia', size: '14%' },
		        ],


            //===========================
            onExpand: function (event) {

                    var idLocalTemp = event.recid;
                    var idSubGrid = 1;
                    var Global_SaveSubGrid = 0;
                    var IDTemp;
                    
                    // ----------------------------------
                    // Encuentra el Recid actualmente utilizado.
                    for (var z = 0; z <= w2ui['grid'].records.length -1; z++){ 

                        var recid = w2ui['grid'].records[z].recid;

                        if (event.recid == recid ){
                            IDTemp = z;
                        }

                    }// fin for 2
                    // ----------------------------------


                    // Nombre del Grid
                    var subGridName = 'subgrid-' + $.trim(event.recid);

			        if (w2ui.hasOwnProperty('subgrid-' + event.recid)) w2ui['subgrid-' + event.recid].destroy();
			        $('#'+ event.box_id).css({ margin: '0px', padding: '0px', width: '100%' }).animate({ height: '105px' }, 100);
			        
                    setTimeout(function () {

                        var anio = w2ui['form'].record['anioPrestamo'];

                        var ValorDevuelto = w2ui['grid'].records[IDTemp].cntDevolver;


                        // Busca de acuerdo a si es Nuevo o Antiguo.
                        if(anio >= 2014){

				            $('#'+ event.box_id).w2grid({
					            name: 'subgrid-' + event.recid, 
					            show: { columnHeaders: true,
                                        toolbar: true,
                                        toolbarAdd: true,
                                        //toolbarDelete: true,
                                        toolbarSave: true,
                                        toolbarSearch: false,
                                        toolbarReload: false,
                                        toolbarColumns: false
                                      },
					            fixedBody: false,
					            columns: [				
						            { field: 'codMaterial2', caption: 'Cod. Material', size: '30%' },
						            { field: 'cantidad2', caption: 'Cantidad', size: '30%', 
                                        editable: { type: 'int', format: 'maxlength = 4'}, attr: "align=center"
                                     },
						            { field: 'loteSerie2', caption: 'Serie o Lote', size: '30%',
                                        editable: { type: 'text', inTag: 'maxlength = 12' }, attr: "align=center"
                                    },
						            { field: 'fechaVencimiento2', caption: 'Fecha Vto.', size: '30%', 
                                        editable: { type: 'date', format: 'dd/mm/yy'}, attr: "align=center , onkeypress='return justFecha(event);'"
                                    },
					            ],
                                onAdd: function (event) {

                                    var sumaCantidad = 0;

                                    var CantDespachado = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);
                                    var local_Codigo = w2ui['grid'].records[IDTemp].codMaterial;

                                    for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                        sumaCantidad = sumaCantidad + parseInt(w2ui[subGridName].records[i].cantidad2);
                                    }

                                    // verifica que la cantidad ya ingresada no sea superior a la entrega.
                                    if (sumaCantidad < CantDespachado) {

                                        var todayDate = new Date();
                                        var day = todayDate.getDate();
                                        var month = todayDate.getMonth() + 4;
                                        var year = todayDate.getFullYear();
                                        w2ui[subGridName].add({recid: (this.records[this.total - 1].recid + 1) , codMaterial2: local_Codigo, cantidad2: '', loteSerie2: '', fechaVencimiento2: (day + '/' + month + '/' + year) });
                                        w2ui[subGridName].total = w2ui[subGridName].total + 1;
    
                                    }else{
                                         alert('No puede ingresar mas articulos, Supera la Cantidad a Devolver.');
                                    }

                                },
                                //-------------------------

                                /* saveDetalle */
                                onSave: function (event) {

                                  if(Global_SaveSubGrid == 0){
                                    alert('Cantidad maxima ingresada no Disponible.')
                                  }else{

                                    // verifica si el articulo fue ingresado.
                                    var control = 0;
                                    // ================================

                                    // Obtiene Numero Correlativo
                                    // ================================

                                    if(w2ui['form'].record['NDevolucion']){
                                        control = 1;
                                    }else{

                                        $.ajax({
                                        type: "POST",
                                        url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/getCorrelativo_Desp_PorDevolucionDePrestamo.ashx",
                                        async: false,
                                        data: { "fecha": w2ui['form'].record['anioDonacion'] },
                                        dataType: "json",
                                        success: function (response) {
                    
                                            if(response.item == "null"){

                                                alert('¡Error, Correlativo no encontrado!')
 
                                            }else{
                                                w2ui['form'].record['NDevolucion'] = response.Correlativo;
                                                w2ui['form'].refresh();
                                            } // Fin Validador de codigo

                                         }// Fin success
                                         });// fin ajax
                                    }// fin if existe correlativo

                                    if (control == 0){
                                        // ===========================
         
                                        // Graba Detalle de Movimiento
                                        // ===========================

                                        // General
                                        var CodigoMovimiento = 'E';
                                        var anioDevolucion = w2ui['form'].record['anioDonacion'];
                                        var CodCorrelativo  = w2ui['form'].record['NDevolucion'];
                                        var cantidadYaEntregado = parseInt(w2ui['grid'].records[IDTemp].cntDevuelta);
                                        var CodBodega = w2ui['form'].record['Nombre_Bodega'];
                                        var ItemArticulo = w2ui['grid'].records[IDTemp].item;
                                        var PrecioUni = w2ui['grid'].records[IDTemp].PrecioUnitario;

                                        // Grid Detalle.
                                        var local_CodMaterial;
                                        var local_Cantidad;
                                        var local_Serielote;
                                        var local_fechaVto;
                                        var cont = 1;

                                        for (var i = 0; i < w2ui[subGridName].records.length; i++){ 
                                        
                                            local_CodMaterial = w2ui[subGridName].records[i].codMaterial2;
                                            local_Cantidad =  w2ui[subGridName].records[i].cantidad2;
                                            local_Serielote =  w2ui[subGridName].records[i].loteSerie2;
                                            local_fechaVto = w2ui[subGridName].records[i].fechaVencimiento2;

                                            $.ajax({
                                            type: "POST",
                                            url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/saveTempRecep_PorDevolucionDePrestamo.ashx",
                                            //url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveTempRecep_DevolucionxPrestamo.ashx",
                                            async: false,
                                            data: {"cont": cont, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioDevolucion, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadYaEntregado, "CantidadMovimientoDetalle": local_Cantidad, "CodigoMaterial": local_CodMaterial, "NSerie": local_Serielote, "fechaVencimiento": local_fechaVto, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni},
                                            dataType: "json",
                                             success: function (response) {

                                              }// Fin success
                                            });// fin ajax

                                            cont = cont + 1;

                                        }// Fin for.

                                        //----------------------------
                                        // Cambia color asigna termino
                                    
                                        var local_Recid = w2ui['grid'].records[IDTemp].recid;
                                        var local_Codigo = w2ui['grid'].records[IDTemp].codMaterial;
                                        var local_nombre = w2ui['grid'].records[IDTemp].nombreMaterial;
                                        var local_Item = w2ui['grid'].records[IDTemp].item;
                                        var local_CntDespachada = w2ui['grid'].records[IDTemp].cntDespachado;
                                        var local_CntDevuelta =w2ui['grid'].records[IDTemp].cntDevuelta;
                                        var local_CntDevolver = w2ui['grid'].records[IDTemp].cntDevolver;
                                        var local_Precio = w2ui['grid'].records[IDTemp].PrecioUnitario;
                                        var local_Total = w2ui['grid'].records[IDTemp].total;
                                        var local_Existencia = w2ui['grid'].records[IDTemp].existencia;

                                        w2ui['grid'].select(local_Recid);
                                        w2ui['grid'].delete(true);

                                        /* luego de guardar el detalle permite que la operacion se pueda volver a guardar */
                                        SaveGlobal = 1;

                                        w2ui['grid'].add({ recid: local_Recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cntDespachado: local_CntDespachada, cntDevuelta: local_CntDevuelta, cntDevolver: local_CntDevolver, PrecioUnitario: local_Precio, total: local_Total, existencia: local_Existencia, "style": "background-color: #C2F5B4" });

                                        //----------------------------
                                    
                                    }else{

                                        /* --> version 2.8.1 atras esta esta parte de casos no entendidos (cambio de logica)
                                         *  ahora graba de inmediado porque no despliega la info de materiales antiguos grabados.
                                         */
                                                                                    
                                        if(SaveGlobal == 0){        
                                            $.ajax({
                                            type: "POST",
                                            url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/getCorrelativo_Desp_PorDevolucionDePrestamo.ashx",
                                            async: false,
                                            data: { "fecha": w2ui['form'].record['anioDonacion'] },
                                            dataType: "json",
                                            success: function (response) {
                    
                                                if(response.item == "null"){

                                                    alert('¡Error, Correlativo no encontrado!')
 
                                                }else{
                                                    w2ui['form'].record['NDevolucion'] = response.Correlativo;
                                                    w2ui['form'].refresh();
                                                } // Fin Validador de codigo

                                             }// Fin success
                                             });// fin ajax
                                        }
                                            // ===========================
         
                                            // Graba Detalle de Movimiento
                                            // ===========================

                                            // General
                                            var CodigoMovimiento3 = 'E';
                                            var anioDevolucion3 = w2ui['form'].record['anioDonacion'];
                                            var CodCorrelativo3  = w2ui['form'].record['NDevolucion'];
                                            var cantidadYaEntregado3 = parseInt(w2ui['grid'].records[IDTemp].cntDevuelta);
                                            var CodBodega3 = w2ui['form'].record['Nombre_Bodega'];
                                            var ItemArticulo3 = w2ui['grid'].records[IDTemp].item;
                                            var PrecioUni3 = w2ui['grid'].records[IDTemp].PrecioUnitario;

                                            // Grid Detalle.
                                            var local_CodMaterial3;
                                            var local_Cantidad3;
                                            var local_Serielote3;
                                            var local_fechaVto3;
                                            var cont3 = 1;

                                            for (var i = 0; i < w2ui[subGridName].records.length; i++){ 
                                        
                                                local_CodMaterial3 = w2ui[subGridName].records[i].codMaterial2;
                                                local_Cantidad3 =  w2ui[subGridName].records[i].cantidad2;
                                                local_Serielote3 =  w2ui[subGridName].records[i].loteSerie2;
                                                local_fechaVto3 = w2ui[subGridName].records[i].fechaVencimiento2;

                                                $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/saveTempRecep_PorDevolucionDePrestamo.ashx",
                                                //url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveTempRecep_DevolucionxPrestamo.ashx",
                                                async: false,
                                                data: {"cont": cont3, "NumeroDonacionArticulo": CodigoMovimiento3, "fecha": anioDevolucion3, "NumeroCorrelativo": CodCorrelativo3, "CantidadMovimientoGeneral": cantidadYaEntregado3, "CantidadMovimientoDetalle": local_Cantidad3, "CodigoMaterial": local_CodMaterial3, "NSerie": local_Serielote3, "fechaVencimiento": local_fechaVto3, "CodBodega": CodBodega3, "ItemArticulo": ItemArticulo3, "PrecioUni": PrecioUni3},
                                                dataType: "json",
                                                    success: function (response) {

                                                    }// Fin success
                                                });// fin ajax

                                                cont3 = cont3 + 1;

                                            }// Fin for.

                                            //--------------------------------
                                            // Cambia color asigna termino
                                    
                                            var local_Recid3 = w2ui['grid'].records[IDTemp].recid;
                                            var local_Codigo3 = w2ui['grid'].records[IDTemp].codMaterial;
                                            var local_nombre3 = w2ui['grid'].records[IDTemp].nombreMaterial;
                                            var local_Item3 = w2ui['grid'].records[IDTemp].item;
                                            var local_CntDespachada3 = w2ui['grid'].records[IDTemp].cntDespachado;
                                            var local_CntDevuelta3 =w2ui['grid'].records[IDTemp].cntDevuelta;
                                            var local_CntDevolver3 = w2ui['grid'].records[IDTemp].cntDevolver;
                                            var local_Precio3 = w2ui['grid'].records[IDTemp].PrecioUnitario;
                                            var local_Total3 = w2ui['grid'].records[IDTemp].total;
                                            var local_Existencia3 = w2ui['grid'].records[IDTemp].existencia;

                                            w2ui['grid'].select(local_Recid3);
                                            w2ui['grid'].delete(true);

                                            /* luego de guardar el detalle permite que la operacion se pueda volver a guardar */
                                            SaveGlobal = 1;

                                            w2ui['grid'].add({ recid: local_Recid3, codMaterial: local_Codigo3, nombreMaterial: local_nombre3, item: local_Item3, cntDespachado: local_CntDespachada3, cntDevuelta: local_CntDevuelta3, cntDevolver: local_CntDevolver3, PrecioUnitario: local_Precio3, total: local_Total3, existencia: local_Existencia3, "style": "background-color: #C2F5B4" });


                                    } // fin control de ingreso.

                                  }//fin Global_SaveSubGrid verifica si se puede o no grabar.

                                },
                                /* Cambios de valores en el grid (ingreso manual) */
                                onChange: function (event) {

                                    var local_CodMaterial;
                                    var local_Cantidad;
                                    var local_Serielote;
                                    var local_fechaVto;
                                    //var CantDespachado = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);
                                    var CantDespachado = parseInt(w2ui['grid'].records[IDTemp].cntDevolver);

                                    /* Cantidad.  */
                                    if (event.column == 1) {

                                        if (event.value_new > CantDespachado) {

                                            alert('Cantidad Ingresada Supera a Cantidad Prestada');

                                            w2ui[subGridName].remove('');
                                            w2ui[subGridName].remove(event.recid);
                                            w2ui[subGridName].add({ recid: event.recid, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: '' });

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

                                            w2ui[subGridName].remove('');
                                            w2ui[subGridName].remove(event.recid);
                                            w2ui[subGridName].add({ recid: event.recid, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });

                                            var sumaCantidad = 0;

                                            for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                                sumaCantidad = sumaCantidad + parseInt(w2ui[subGridName].records[i].cantidad2);
                                            }

                                            // verifica que la cantidad ya ingresada no sea superior a la entrega.
                                            if (sumaCantidad <= CantDespachado) {

                                                // Se permite el Save.
                                                Global_SaveSubGrid = 1;
                                                //w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });

                                            }else{
                                                Global_SaveSubGrid = 0;
                                                w2ui[subGridName].remove('');
                                                w2ui[subGridName].remove(event.recid);
                                                w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: '', loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });
                                                alert('Cantidad Ingresada Supera a Cantidad Prestada');
                                            }

                                        } // fin if cantidad inicial no pruede ser mas grande que lo prestado.

                                    } // fin columna 1

                                    /* Serie o lote. */
                                    if (event.column == 2) {

                                        var CantDevolver = parseInt(w2ui['grid'].records[IDTemp].cntDevolver);

                                        $.ajax({
                                        type: "POST",
                                        url: "../../clases/persistencia/controladores/validaDetalleMaterial.ashx",
                                        async: false,
                                        data: { "cmd": 'validaTraeFVto', "codMaterial": w2ui['grid'].records[IDTemp].codMaterial,  "Bodega": w2ui['form'].record['Nombre_Bodega'], "Nserie": event.value_new.toUpperCase() },
                                        dataType: "json",
                                        success: function (response) {
                    
                                            if(response.validate == "1"){

                                                alert('¡Error, No existe registro de material para este Nº Serie.!')
                                                local_Serielote = '';
                                                local_fechaVto = '';
                                                Global_SaveSubGrid = 0;
 
                                            }else{
                                                Global_SaveSubGrid = 1;

                                                local_Cantidad = parseInt(response.FLD_MOVCANTIDAD);

                                                var sumaCantidad = 0;
                                                for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                                    if(w2ui[subGridName].records[i].cantidad2){
                                                        sumaCantidad = sumaCantidad + parseInt(w2ui[subGridName].records[i].cantidad2);
                                                    }
                                                }
                                                CantDevolver = CantDevolver - sumaCantidad;

                                                if(local_Cantidad > CantDevolver){
                                                    local_Cantidad = CantDevolver
                                                }
                                                
                                                local_Serielote = event.value_new.toUpperCase();
                                                local_fechaVto = response.FLD_FECHAVENCIMIENTO;

                                            } // Fin Validador de codigo

                                        }// Fin success
                                        });// fin ajax

                                        for (var i = 0; i < w2ui[subGridName].records.length; i++) {

                                            if (event.recid == w2ui[subGridName].records[i].recid) {
                                                
                                                local_CodMaterial = w2ui[subGridName].records[i].codMaterial2;
                                                //local_Serielote = event.value_new.toUpperCase();

                                                // para valiar que la cantidad ingresada.
                                                if(local_Cantidad == ""){
                                                    if (w2ui[subGridName].records[i].cantidad2 == "") {
                                                        local_Cantidad = "";
                                                    } else {
                                                        local_Cantidad = w2ui[subGridName].records[i].cantidad2;
                                                    }
                                                }

                                                if(local_fechaVto == ""){
                                                    // para valiar que la fecha este ingresada.
                                                    if (w2ui[subGridName].records[i].fechaVencimiento2 == "" ) {
                                                        local_fechaVto = "";
                                                    } else {
                                                        local_fechaVto = w2ui[subGridName].records[i].fechaVencimiento2;
                                                    }
                                                }

                                            }
                                        }

                                        w2ui[subGridName].remove('');
                                        w2ui[subGridName].remove(event.recid);
                                        w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });

                                    } // fin columna 2.


                                    /* Fecha Vto. */
                                    if (event.column == 3) {

                                        CantDespachado = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);

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

                                        var fechaNew = event.value_new;
                                        var controlFecha = 0;

                                        var fechaPart = fechaNew.split("/");

                                        if (fechaPart.length == 3) {
                                            var dia = parseInt(fechaPart[0]);
                                            var mes = parseInt(fechaPart[1]);
                                            var anio = parseInt(fechaPart[2]);

                                            if (dia <= 31 && mes <= 12 && anio >= 1900) {

                                            } else {
                                                controlFecha = 1;
                                                alert(" Fecha mal ingresada.")
                                            }

                                        } else {
                                            controlFecha = 1;
                                            alert(" Fecha mal ingresada. Ej: 01/01/1900")
                                        }

                                        if (controlFecha == 1) {
                                            Global_SaveSubGrid = 0;
                                            w2ui[subGridName].remove('');
                                            w2ui[subGridName].remove(event.recid);
                                            w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: '' });
                                        } else {
                                            Global_SaveSubGrid = 1;
                                            w2ui[subGridName].remove('');
                                            w2ui[subGridName].remove(event.recid);
                                            w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });
                                         } 
                                          
                                    } // fin columna 3.
                            
                                } // fin onchange
                                //-------------------------

				            }); // fin abrir grid para detalle, cuando existen valores 2014
				        w2ui['subgrid-' + event.recid].resize();
                        w2ui.grid.resize();

 // -----------------------------
 // Maneja los datos del SubGrid
 // -----------------------------

                        // ===========================

                        // Obtiene Numero Correlativo
                        // ===========================

                        if(w2ui['form'].record['NDevolucion']){
                        
                            // Verifica si los datos vienen de la principal o la temporal.
                            var datos = 0;

                            $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/buscaCorrelativo_Despacho_PorDevolucionDePrestamo.ashx",
                            async: false,
                            data: { "fecha": w2ui['form'].record['anioPrestamo'], "Ncorrelativo": w2ui['form'].record['NDevolucion'],  "CodMaterial": w2ui['grid'].records[IDTemp].codMaterial },
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

    //  alert(datos);

                            // Tabla 1, busca los ya ingresados.
                            if(datos == 1){

                                //cntDespachado cntDevuelta cntDevolver
                                var Despachado = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);
                                var Devuelta = parseInt(w2ui['grid'].records[IDTemp].cntDevuelta); 

                                var prueba = Despachado - Devuelta;
                            
                                if(prueba == 0){
                            
                                    $.ajax({
                                    type: "POST",
                                    url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/getHistorial_Detalle_PorDevolucionDePrestamo.ashx",
                                    async: false,
                                    data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[IDTemp].codMaterial, "NCorrelativo": w2ui['form'].record['NDevolucion'], "anioPrestamo": w2ui['form'].record['anioDonacion']},
                                    dataType: "json",
                                    success: function (response) {

                                        // Carga articulos Grid1
                                        w2ui[subGridName].clear();
                                        var recidID = 1;

                                        // Transcribe los nuevos Records o articulos actualmente disponibles.
                                        for (var i = 0; i < response.records.length; i++){
                                            w2ui[subGridName].add({  recid: recidID ,codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2 });
                                            recidID = recidID + 1;
                                        }// fin for
                            
                                    }// Fin success
                                    });// fin ajax	
                                }else{
                                    
                                    /* Proporciona permisos para que el sub grid calcule automaticamente que detalle es apto para la solicitud en curso */
                                    if(checkRecomendacion == 1){

                                        $.ajax({
                                        type: "POST",
                                        url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/getDetalleProductosDespOtrasInst.ashx",
                                        async: false,
                                        data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[IDTemp].codMaterial },
                                        dataType: "json",
                                        success: function (response) {

                                            var cantidadADespachar = parseInt(w2ui['grid'].records[IDTemp].cntDevolver);
                                            var sumaParcial = 0;
                                            var sumaCheck = 0;

                                            // Carga articulos Grid1
                                            w2ui[subGridName].clear();
                                            var recidID = 1;

                                            // Transcribe los nuevos Records o articulos actualmente disponibles.
                                            for (var i = 0; i < response.records.length; i++){

                                                var cantidadNueva = parseInt(response.records[i].cantidad2);

                                                if ( cantidadADespachar > sumaParcial ){

                                                    w2ui[subGridName].add({  recid: recidID ,codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2 });
                                                    recidID = recidID + 1;
                                                    sumaParcial = sumaParcial + cantidadNueva;

                                                 } // fin if
                                            }// fin for
                            
                                        }// Fin success
                                        });// fin ajax		
                        
                                        var cantidadADespachar = parseInt(w2ui['grid'].records[IDTemp].cntDevolver);
                                        var sumaParcial2 = 0;

                                        // Elimina el ultimo dato y lo adapta a lo solicitado.
                                        for (var i = 0; i <= w2ui[subGridName].records.length -1; i++){

                                            var cantidadNueva = parseInt(w2ui[subGridName].records[i].cantidad2);

                                            sumaParcial2 = sumaParcial2 + cantidadNueva;

                                           if (i == w2ui[subGridName].records.length - 1){
   
                                                    var calculaMonto = 0;
                                                    var finalMonto = 0;
                                        
                                                    if(cantidadADespachar > sumaParcial2){

                                                        alert('Monto Solicitado  >' + ' ' + cantidadADespachar + ' ' + '<,  excede la existencia de materiales con "Fecha de Vencimiento".');
                                                        alert('El maximo en existencia con fecha son :  ' + sumaParcial2);

                                                        // No se permite el Save.
                                                        Global_SaveSubGrid = 0;

                                                    }else{

                                                        finalMonto = sumaParcial2 - cantidadADespachar;
                                                        NuevoMonto = cantidadNueva - finalMonto;

                                                        // extrae indice en tabla recid del articulo modificado
                                                        var recidID = parseInt(w2ui[subGridName].records[i].recid);
                                                        var local_CodMaterial = w2ui[subGridName].records[i].codMaterial2;
                                                        var local_Cantidad = NuevoMonto;
                                                        var local_Serielote = w2ui[subGridName].records[i].loteSerie2;
                                                        var local_fechaVto = w2ui[subGridName].records[i].fechaVencimiento2;

                                                        //Elimina el antiguo calculo de final y cambia x el nuevo.
                                                        w2ui[subGridName].select(recidID);
                                                        w2ui[subGridName].delete(true);

                                                        w2ui[subGridName].add({ recid: recidID ,codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });

                                                        // Se permite el Save.
                                                        Global_SaveSubGrid = 1;

                                                    } // fin if verifica numeros negativos.

                                                }// fin if, ve si es el ultimo valor.
                                        }// fin For, ultimo valor.

                                    }else{

                                        /* Si no esta completo se habilita un nuevo ingreso */
                                        var todayDate = new Date();
                                        var day = todayDate.getDate();
                                        var month = todayDate.getMonth() + 4;
                                        var year = todayDate.getFullYear();
                                        w2ui[subGridName].add({ recid: 1, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: (day + '/' + month + '/' + year) });

                                        /* --> version 2.8.1 atras esta esta parte llamado automatico a detlle */
                                    }
                                }

                            }// fin datos 1


                            // Tabla 2, busca el valor tabla temp.
                            if(datos == 2){ 

                                $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/getHistorial_DetalleTemp_PorDevoDePrestamo.ashx",
                                async: false,
                                data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[IDTemp].codMaterial, "NCorrelativo": w2ui['form'].record['NDevolucion'] },
                                dataType: "json",
                                success: function (response) {

                                    // Carga articulos Grid1
                                    w2ui[subGridName].clear();
                                    var recidID = 1;

                                    // Transcribe los nuevos Records o articulos actualmente disponibles.
                                    for (var i = 0; i < response.records.length; i++){
                                        w2ui[subGridName].add({  recid: recidID ,codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2 });
                                        recidID = recidID + 1;
                                    }// fin for
                            
                                }// Fin success
                                });// fin ajax	

                            }// fin datos 2


                            // Tabla 3, No esta en nunguna de las 2 anteriores.
                            if(datos == 3){ 

                                if(checkRecomendacion == 1){
                                    $.ajax({
                                    type: "POST",
                                    url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/getDetalleProductosDespOtrasInst.ashx",
                                    async: false,
                                    data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[IDTemp].codMaterial },
                                    dataType: "json",
                                    success: function (response) {

                                        var cantidadADespachar = parseInt(w2ui['grid'].records[IDTemp].cntDevolver);
                                        var sumaParcial = 0;
                                        var sumaCheck = 0;

                                        // Carga articulos Grid1
                                        w2ui[subGridName].clear();
                                        var recidID = 1;

                                        // Transcribe los nuevos Records o articulos actualmente disponibles.
                                        for (var i = 0; i < response.records.length; i++){

                                            var cantidadNueva = parseInt(response.records[i].cantidad2);

                                            if ( cantidadADespachar > sumaParcial ){

                                                w2ui[subGridName].add({  recid: recidID ,codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2 });
                                                recidID = recidID + 1;
                                                sumaParcial = sumaParcial + cantidadNueva;

                                             } // fin if
                                        }// fin for
                            
                                    }// Fin success
                                    });// fin ajax		
                        
                                    var cantidadADespachar = parseInt(w2ui['grid'].records[IDTemp].cntDevolver);
                                    var sumaParcial2 = 0;

                                    // Elimina el ultimo dato y lo adapta a lo solicitado.
                                    for (var i = 0; i <= w2ui[subGridName].records.length -1; i++){

                                        var cantidadNueva = parseInt(w2ui[subGridName].records[i].cantidad2);

                                        sumaParcial2 = sumaParcial2 + cantidadNueva;

                                       if (i == w2ui[subGridName].records.length - 1){
   
                                                var calculaMonto = 0;
                                                var finalMonto = 0;
                                        
                                                if(cantidadADespachar > sumaParcial2){

                                                    alert('Monto Solicitado  >' + ' ' + cantidadADespachar + ' ' + '<,  excede la existencia de materiales con "Fecha de Vencimiento".');
                                                    alert('El maximo en existencia con fecha son :  ' + sumaParcial2);

                                                    // No se permite el Save.
                                                    Global_SaveSubGrid = 0;

                                                }else{

                                                    finalMonto = sumaParcial2 - cantidadADespachar;
                                                    NuevoMonto = cantidadNueva - finalMonto;

                                                    // extrae indice en tabla recid del articulo modificado
                                                    var recidID = parseInt(w2ui[subGridName].records[i].recid);
                                                    var local_CodMaterial = w2ui[subGridName].records[i].codMaterial2;
                                                    var local_Cantidad = NuevoMonto;
                                                    var local_Serielote = w2ui[subGridName].records[i].loteSerie2;
                                                    var local_fechaVto = w2ui[subGridName].records[i].fechaVencimiento2;

                                                    //Elimina el antiguo calculo de final y cambia x el nuevo.
                                                    w2ui[subGridName].select(recidID);
                                                    w2ui[subGridName].delete(true);

                                                    w2ui[subGridName].add({ recid: recidID ,codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });

                                                    // Se permite el Save.
                                                    Global_SaveSubGrid = 1;

                                                } // fin if verifica numeros negativos.

                                            }// fin if, ve si es el ultimo valor.
                                    }// fin For, ultimo valor.
                                }else{
                                    /* Si no esta completo se habilita un nuevo ingreso */
                                    var todayDate = new Date();
                                    var day = todayDate.getDate();
                                    var month = todayDate.getMonth() + 4;
                                    var year = todayDate.getFullYear();
                                    w2ui[subGridName].add({ recid: 1, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: (day + '/' + month + '/' + year) });                                
                                }
  
                            }// fin datos 3

                        }else{ // Correlativo no existe.
                            

                            /* Proporciona permisos para que el sub grid calcule automaticamente que detalle es apto para la solicitud en curso */
                            if(checkRecomendacion == 1){

                                $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Despachos/PrestamoOtrasInstituciones/getDetalleProductosDespOtrasInst.ashx",
                                async: false,
                                data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[IDTemp].codMaterial },
                                dataType: "json",
                                success: function (response) {

                                    var cantidadADespachar = parseInt(w2ui['grid'].records[IDTemp].cntDevolver);
                                    var sumaParcial = 0;
                                    var sumaCheck = 0;

                                    // Carga articulos Grid1
                                    w2ui[subGridName].clear();
                                    var recidID = 1;

                                    // Transcribe los nuevos Records o articulos actualmente disponibles.
                                    for (var i = 0; i < response.records.length; i++){

                                        var cantidadNueva = parseInt(response.records[i].cantidad2);

                                        if ( cantidadADespachar > sumaParcial ){

                                            w2ui[subGridName].add({  recid: recidID ,codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2 });
                                            recidID = recidID + 1;
                                            sumaParcial = sumaParcial + cantidadNueva;

                                         } // fin if
                                    }// fin for
                            
                                }// Fin success
                                });// fin ajax		
                        
                                var cantidadADespachar = parseInt(w2ui['grid'].records[IDTemp].cntDevolver);
                                var sumaParcial2 = 0;

                                // Elimina el ultimo dato y lo adapta a lo solicitado.
                                for (var i = 0; i <= w2ui[subGridName].records.length -1; i++){

                                    var cantidadNueva = parseInt(w2ui[subGridName].records[i].cantidad2);

                                    sumaParcial2 = sumaParcial2 + cantidadNueva;

                                   if (i == w2ui[subGridName].records.length - 1){
   
                                            var calculaMonto = 0;
                                            var finalMonto = 0;
                                        
                                            if(cantidadADespachar > sumaParcial2){

                                                alert('Monto Solicitado  >' + ' ' + cantidadADespachar + ' ' + '<,  excede la existencia de materiales con "Fecha de Vencimiento".');
                                                alert('El maximo en existencia con fecha son :  ' + sumaParcial2);

                                                // No se permite el Save.
                                                Global_SaveSubGrid = 0;

                                            }else{

                                                finalMonto = sumaParcial2 - cantidadADespachar;
                                                NuevoMonto = cantidadNueva - finalMonto;

                                                // extrae indice en tabla recid del articulo modificado
                                                var recidID = parseInt(w2ui[subGridName].records[i].recid);
                                                var local_CodMaterial = w2ui[subGridName].records[i].codMaterial2;
                                                var local_Cantidad = NuevoMonto;
                                                var local_Serielote = w2ui[subGridName].records[i].loteSerie2;
                                                var local_fechaVto = w2ui[subGridName].records[i].fechaVencimiento2;

                                                //Elimina el antiguo calculo de final y cambia x el nuevo.
                                                w2ui[subGridName].select(recidID);
                                                w2ui[subGridName].delete(true);

                                                w2ui[subGridName].add({ recid: recidID ,codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });

                                                // Se permite el Save.
                                                Global_SaveSubGrid = 1;

                                            } // fin if verifica numeros negativos.

                                        }// fin if, ve si es el ultimo valor.
                                }// fin For, ultimo valor.

                            }else{

                            /* Si no solicita permisos el grid queda abierto para inscribir datos.*/
                            var todayDate = new Date();
                            var day = todayDate.getDate();
                            var month = todayDate.getMonth() + 4;
                            var year = todayDate.getFullYear();
                            w2ui[subGridName].add({ recid: 1, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: (day + '/' + month + '/' + year) });
                            
                            }// fin checkRecomendacion

                        }// fin if correlativo existe.

// ----------------------------------
// Fin, maneja los datos del Sub Grid
// ----------------------------------

                        // end if 2014.
                        }else{
				            $('#'+ event.box_id).w2grid({
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
					            ],
					            records: [
						            { recid: '' ,codMaterial2: '---', cantidad2: '0', loteSerie2: '---', fechaVencimiento2: '01/01/1900'}
					            ]
                                //-------------------------

				            });
				        w2ui['subgrid-' + event.recid].resize();                        
                        } // end IF.
			        }, 300); // fin set time out.
		        }
                ,
                //===========================


            // No busca por grilla.
            onChange: function (event) {

                // ----------------------------------------
                // Verifica si se modifico la columna Cantidad.
                if(event.column == 5){
                                     
                    var local_Codigo;
                    var local_Nombre;
                    var local_Item;
                    var local_CntDespachada;
                    var local_CntDevuelta;
                    var local_CntDevolver;
                    var local_Precio;
                    var local_Total;
                    var local_Existencia;

                    if(event.value_new >= 1){
                        
                        for (var i = 0; i < w2ui['grid'].records.length; i++){ 
                         
                            if(event.recid == w2ui['grid'].records[i].recid){

                                local_CntDespachada = parseInt(w2ui['grid'].records[i].cntDespachado);
                                local_CntDevuelta = parseInt(w2ui['grid'].records[i].cntDevuelta);

                                // comprueba que lo ingresado no este por sobre lo retornado.

                                var compruebaValor = local_CntDespachada - local_CntDevuelta;

                                if (compruebaValor == 0){
                                    
                                    alert('¡ Articulo ya fue devulto en un 100% !')

                                    local_Codigo = w2ui['grid'].records[i].codMaterial;
                                    local_nombre = w2ui['grid'].records[i].nombreMaterial;
                                    local_Item = w2ui['grid'].records[i].item;
                                    local_CntDespachada = w2ui['grid'].records[i].cntDespachado;
                                    local_CntDevuelta = w2ui['grid'].records[i].cntDevuelta;
                                    local_CntDevolver = 0;
                                    local_Precio = w2ui['grid'].records[i].PrecioUnitario;
                                    local_Total = w2ui['grid'].records[i].total;
                                    local_Existencia = w2ui['grid'].records[i].existencia;

                                }else{

                                    if(event.value_new > local_CntDespachada){

                                        alert('¡Error, Cantidad recibida Inferiror que cantidad Devulta!')

                                        local_Codigo = w2ui['grid'].records[i].codMaterial;
                                        local_nombre = w2ui['grid'].records[i].nombreMaterial;
                                        local_Item = w2ui['grid'].records[i].item;
                                        local_CntDespachada = w2ui['grid'].records[i].cntDespachado;
                                        local_CntDevuelta = w2ui['grid'].records[i].cntDevuelta;
                                        local_CntDevolver = 0;
                                        local_Precio = w2ui['grid'].records[i].PrecioUnitario;
                                        local_Total = w2ui['grid'].records[i].total;
                                        local_Existencia = w2ui['grid'].records[i].existencia;

                                    }else{
                                    
                                        local_Codigo = w2ui['grid'].records[i].codMaterial;
                                        local_nombre = w2ui['grid'].records[i].nombreMaterial;
                                        local_Item = w2ui['grid'].records[i].item;
                                        local_CntDespachada = w2ui['grid'].records[i].cntDespachado;
                                        local_CntDevuelta = w2ui['grid'].records[i].cntDevuelta;
                                        local_CntDevolver = event.value_new;
                                        local_Precio = w2ui['grid'].records[i].PrecioUnitario;
                                        local_Total = w2ui['grid'].records[i].total;
                                        local_Existencia = w2ui['grid'].records[i].existencia;
                                    }
                                } // verifica valor.
                            }
                        } // fin for.
                        
                        w2ui['grid'].select(event.recid);
                        w2ui['grid'].delete(true);
                        
                        w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cntDespachado: local_CntDespachada, cntDevuelta: local_CntDevuelta, cntDevolver: local_CntDevolver, PrecioUnitario: local_Precio, total: local_Total, existencia: local_Existencia });

                    }// Fin if valor nuevo mayor a 1


                    if(event.value_new <= 0){
                        
                        for (var i = 0; i < w2ui['grid'].records.length; i++){ 
                         
                            if(event.recid == w2ui['grid'].records[i].recid){

                                local_Codigo = w2ui['grid'].records[i].codMaterial;
                                local_nombre = w2ui['grid'].records[i].nombreMaterial;
                                local_Item = w2ui['grid'].records[i].item;
                                local_CntDespachada = w2ui['grid'].records[i].cntDespachado;
                                local_CntDevuelta = w2ui['grid'].records[i].cntDevuelta;
                                local_CntDevolver = 0;
                                local_Precio = w2ui['grid'].records[i].PrecioUnitario;
                                local_Total = w2ui['grid'].records[i].total;
                                local_Existencia = w2ui['grid'].records[i].existencia;
                            }
                        } // fin for.
                        
                        w2ui['grid'].select(event.recid);
                        w2ui['grid'].delete(true);
                        
                        w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cntDespachado: local_CntDespachada, cntDevuelta: local_CntDevuelta, cntDevolver: local_CntDevolver, PrecioUnitario: local_Precio, total: local_Total, existencia: local_Existencia });

                    }// Fin if valor es 0

                }// Fin if 3

            //-------------------------
            },

            /* saveForm */
            onSave: function (event) {

                // valida que la descripcion este escrita.
                if(w2ui['form'].record['observacion']){
                }else{
                    w2ui['form'].record['observacion'] = '';
                    w2ui['form'].refresh();
                }

                if(w2ui['form'].record['NDevolucion']){

                    if(SaveGlobal == 1){
                
                        // if valida que la institucion sea seleccionada.
                        if(w2ui['grid'].records.length > 0 && w2ui['form'].record['Nombre_Bodega'] &&  w2ui['form'].record['Nombre_Institucion']){

                            // ==========================
         
                            // Graba el Movimiento
                            // ==========================

                            $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/saveMovimiento.ashx",
                            async: false,
                            data: { "fecha": w2ui['form'].record['anioDonacion'], "NumeroDonacionArticulo": 'E' ,"NumeroCorrelativo": w2ui['form'].record['NDevolucion']},
                            dataType: "json",
                            success: function (response) {
                    
                                if(response.item == "null"){
                                    alert('Error!, al grabar el movimiento')
                                }else{
                                } // Fin Validador de codigo

                             }// Fin success
                             });// fin ajax

                        
                            // ===========================
         
                            // Graba Detalle de Movimiento
                            // ===========================

                            $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/saveDetalleMovimiento_PorDevoluDePrestamo.ashx",
                            async: false,
                            data: {"fechaNueva": w2ui['form'].record['anioDonacion'], "NCorrelativoNuevo": w2ui['form'].record['NDevolucion'], "CodigoTrasaccionNuevo": 'E', "fechaAntiguo": w2ui['form'].record['anioPrestamo'], "NCorrelativoAntiguo": w2ui['form'].record['NPrestamo'] },
                            dataType: "json",
                            success: function (response) {
                    
                                if(response.item == "done"){


                                } // Fin Validador de codigo


                            }// Fin success
                            });// fin ajax

          

                            // ===========================

                            // Graba el Prestamo.
                            // ===========================   

                            $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/savePrestamo_PorDevoluDePrestamo.ashx",
                            async: false,
                            data: { "fechaActual": w2ui['form'].record['anioDonacion'], "codigoActual": 'E', "NCorrelativoNuevo": w2ui['form'].record['NDevolucion'], "fechaCompleta": w2ui['form'].record['fechaServidor'], "descripcion": w2ui['form'].record['descripcion'], "valor": w2ui['form'].record['valor'], "numeroDoc": 1, "Instituto": w2ui['form'].record['Nombre_Institucion'], "codigoAntiguo": 'J', "fechaAntigua": w2ui['form'].record['anioPrestamo'], "NCorrelativoAntiguo": w2ui['form'].record['NPrestamo'] },
                            dataType: "json",
                             success: function (response) {
                    
                                if(response.item == "done"){

                                    alert('¡Registro completado con éxito!');

                                } // Fin Validador de codigo

                             }// Fin success
                            });// fin ajax


                        }else{
                            alert('¡Error, Faltan datos en el formulario!')
                        } // end if valida institucion bodega datos del form.

                    }else{
                        alert('Ud. NO puede grabar la Devolución por que esta ya EXISTE.')
                    }//verifica si existe en tabla1.
                    
                // no existen datos en el Sub-Save.
                }else{
                    alert('¡Error, Primero debe asignar que articulos desea despachar.!')  
                }

            // ===========================
            }// Fin Save.
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
		            '	<input type="button" value="Grabar" name="saveForm" style="border-color: tomato;">' +
                    '	<input type="button" value="Imprimir" name="imprimir">' +
                    '	<input type="button" value="Limpiar" name="limpiar">' +
                //'	<input type="button" value="ImprimirQR" name="imprimirQR">' +
                '</div>'+
		        '</div>',
			actions: { 

            	"saveForm": function () {
			            w2ui['grid'].save();
			        },
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
                    var NPrestamo; // numeroDocumento en json

                    // Identifica ID de busqueda.
                    if (w2ui['form'].record['NDevolucion']) {
                        NTransaccion = w2ui['form'].record['NDevolucion'];

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

                                    if (w2ui['form'].record['anioDonacion']) {
                                        periodo = w2ui['form'].record['anioDonacion'];

                                        if (w2ui['form'].record['NPrestamo']) {
                                        NroPrestamo = w2ui['form'].record['NPrestamo'];

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
                                                CantidadMovimiento = w2ui['grid'].records[i].cntDevuelta;
                                                PrecioUnitario = w2ui['grid'].records[i].PrecioUnitario;

                                                $.ajax({
                                                    type: "POST",
                                                    url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                                                    async: false,
                                                    data: { "cmd": 'RPTInforme', "NTransaccion": NTransaccion, "periodo": periodo, "codTransaccion": 'E', "Linea": cont, "codMaterial": CodigoMaterial, "nombreMaterial": NombreMaterial, "CodItem": '', "cantMaterial": CantidadMovimiento, "precioMaterial": PrecioUnitario, "bodega": bodega, "descripcion": w2ui['form'].record['descripcion'], "fechaMovimieno": fechaTransaccion, "proveedor": '', "ordenCompra": '0', "ordenCompraEstado": '', "numeroDocumento": NroPrestamo, "Institucion": programaMinsal, "centroCosto": '', "tipoDocumento": '', "tituloMenu": 'DEVOLUCIÓN DE PRÉSTAMO', "descuento": '0', "impuesto": '0', "diferenciaPeso": '0', "usuario": '' },
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
                                                window.open('../../reportes/Despachos/DespXPrestamo/RptVentana_DevolucionXPrestamo.aspx?CMVCodigo=' + NTransaccion + '&PERCodigo=' + periodo + '&TMVCodigo=' + 'E' + '&usuario=' + ReportUsuario);
                                            } else {    
                                                alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                            }

                                        } else { alert("Faltan datos para imprimir."); } // Fin N° solicitud x préstamo.
                                    } else { alert("Faltan datos para imprimir."); } // Fin nombre anio donacion.
                                } else { alert("Faltan datos para imprimir."); } // Fin nombre Programa.
                            } else { alert("Faltan datos para imprimir."); } // Fin nombre Bodega.
                        } else { alert("Faltan datos para imprimir."); } // Fin fechaTransaccion.
                    } else { // alerta de mensaje por no ingresar nada.
                        alert("Primero ingrese o búsque una recepción");
                    }

                }, // fin imprimir

                /*===================================*/

			    "imprimirQR": function () {
                        
                    // Identifica ID de busqueda.
                    if (w2ui['form'].record['NDevolucion']){ 

                        var datos = 0;

                        $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/buscaCorrelativo_Despacho_PorDevolucionDePrestamo.ashx",
                        async: false,
                        data: { "fecha": w2ui['form'].record['anioPrestamo'], "Ncorrelativo": w2ui['form'].record['NDevolucion'],  "CodMaterial": w2ui['grid'].records[0].codMaterial },
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

                            var Institucion;

                            if (w2ui['form'].record['Nombre_Institucion']) {
                                Institucion = $('#Nombre_Institucion option:selected').text();
                                var div_institucion = Institucion.split("-")
                                Institucion = div_institucion[1];
                                 window.open('../../generadorQR/Despachos/XDevolucionDePrestamo/QR_XDevolucionDePrestamo.aspx?TMVCodigo=' + 'E' +'&PerCodigo='+ w2ui['form'].record['anioPrestamo'] + '&ID=' + w2ui['form'].record['NPrestamo'] + '&fechaOperacion=' + w2ui['form'].record['fechaServidor'] + '&anioDevolucion=' + w2ui['form'].record['anioDonacion'] + '&NumDevolucion=' + w2ui['form'].record['NDevolucion']  + '&Proveedor=' + Institucion);
                            } else {
                                alert("Primero Identifique la institución.");
                            }

                           
                        }else{
                            alert(" Primero se necesita guardar la operación. ");
                        }
                            
                    }else{ // alerta de mensaje por no ingresar nada.
                        alert("Primero Identifique Recepción que desea Imprimir");
                    }

                }// Fin Imprimir
			}
		});

		
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
		        header: 'Criterios de Búsqueda',
		        name: 'form3',
		        fields: [
			        { name: 'NPrestamo', type: 'text', required: true, html: { caption: 'Número Préstamo', attr: 'size="10" maxlength="10"' } },
			        { name: 'FPrestamo', type: 'list', required: true, html: { caption: 'Periodo' },
		                options: {
		                    url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/BuscarDonaciones.ashx',
		                    showNone: true
		                }
		            }
		        ],
		        record: { 
			        NPrestamo	: ''
		        },
		        actions: {
			        Buscar: function () { 

                        // Busqueda por fecha.
                        if (w2ui['form3'].record.FPrestamo >= 0){
                            w2ui['grid2'].url = '../../clases/persistencia/controladores/Recepciones/RecepcionxPrestamo/cargaHistorialxFechaRecpXSoliPrestamo.ashx?FechaDonacion=' + w2ui['form3'].record.FPrestamo;
                            w2ui['grid2'].reload();
                        }
                        // Busqueda por numero de donación.
                        else if (w2ui['form3'].record.NPrestamo != ''){
                           w2ui['grid2'].url = '../../clases/persistencia/controladores/Recepciones/RecepcionxPrestamo/cargaHistorialxNumeroRecpXSoliPrestamo.ashx?NumeroaDonacion=' + w2ui['form3'].record.NPrestamo;
                           w2ui['grid2'].reload();
                        }
                          // alerta de mensaje por no ingresar nada.
                          else{
                            alert("Ingrese Elemento de Búsqueda");
                          }
			        },
                    Limpiar: function () {
                        this.clear();
                        w2ui['grid2'].clear();
			        },
                    /* cargaGrid */
			        Aceptar: function () {

                        var anio = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO;

                        // Busca de acuerdo a si es nuevo o antiguo.
                        if(anio >= 2014){

                            var Ingresado = 0;

                            var codBodega;
                            var codInstitucion;
                            // valor del form.
                            var valorForm = 0;

                          // Busca Bodega y Articulos Asociados.
                          $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/getArticulosGrid2_A_Grid1.ashx",
                            async: false,
                            data: { "codigo": 'J', "Periodo": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO, "Numero": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO },
                            dataType: "json",
                            success: function (response) {

                                // Carga articulos Grid1
                                w2ui['grid'].clear();
                                var recidID = 100;
                                for (var i = 0; i < response.articulo.length; i++){ 

                                    // Cantidad a Devolver, se parsea a enteero.
                                    var local_CantDevuelta = parseInt(response.articulo[i].FLD_CANTADEVOLVER);

                                    // Bandera de control nos permite saber que el articulo fue ya guardado.
                                    if(local_CantDevuelta > 0){
                                        Ingresado = 1;
                                    }

                                    w2ui['grid'].add({ recid: recidID, codMaterial: response.articulo[i].recid, nombreMaterial: response.articulo[i].FLD_MATNOMBRE, item: response.articulo[i].FLD_ITECODIGO, cntDespachado: response.articulo[i].FLD_MOVCANTIDAD, cntDevuelta: response.articulo[i].FLD_CANTADEVOLVER, cntDevolver: 0, PrecioUnitario: response.articulo[i].FLD_PRECIOUNITARIO, total: response.articulo[i].totalDonacion,  existencia: response.articulo[i].cantidadExistente });
                                    recidID = recidID + 1;
                                }


                                // Verifica que no existan codigos Duplicados. De ser asi los suma.
                                for (var i = 0; i <  w2ui['grid'].records.length; i++){ 
                                    
                                    var codigo = w2ui['grid'].records[i].codMaterial;
                                    var sumaTotal = 0;
                                    var sumaDevolucion = 0;
                                    var cantidadRepeticiones = 1;

                                    // ----------------------------------
                                    // for que suma los codigos iguales.
                                    for (var z = 0; z < w2ui['grid'].records.length; z++){ 

                                       //alert(" recid " + w2ui['grid'].records[z].recid + " " + " cod " + w2ui['grid'].records[z].codMaterial + " " + " cantidad " + w2ui['grid'].records[z].cntDespachado  )

                                        var codigo2 = w2ui['grid'].records[z].codMaterial;
                                        var recidTest = w2ui['grid'].records[z].recid;
                                        // cantidad nueva.
                                        var cantidad2 = parseInt(w2ui['grid'].records[z].cntDespachado);
                                        var cantidadDevuelta = parseInt(w2ui['grid'].records[z]. cntDevuelta);
                                        
                                        if(codigo == codigo2){
                                            sumaTotal = sumaTotal + cantidad2;
                                            sumaDevolucion = sumaDevolucion + cantidadDevuelta;
                                            cantidadRepeticiones = cantidadRepeticiones + 1;
                                        } // fin if

                                    }// fin for 2
                                    // ----------------------------------

                                    // valores antiguos
                                    var recid =  w2ui['grid'].records[i].recid;
                                    var codMaterial =  w2ui['grid'].records[i].codMaterial;
                                    var nombreMaterial =  w2ui['grid'].records[i].nombreMaterial;
                                    var item =  w2ui['grid'].records[i].item;
                                    //var cntDevuelta =  w2ui['grid'].records[i].cntDevuelta;
                                    var PrecioUnitario =  w2ui['grid'].records[i].PrecioUnitario;
                                    var total =  w2ui['grid'].records[i].total;
                                    var existencia =  w2ui['grid'].records[i].existencia;

                                    // ----------------------------------
                                    // Elimina todos los codigos del mismo tipo;
                                    for (var e = w2ui['grid'].records.length - 1; e >= 0; e--){ 

                                        //alert("DEL "+" recid " + w2ui['grid'].records[e].recid + " " + " cod " + w2ui['grid'].records[e].codMaterial + " " + " cantidad " + w2ui['grid'].records[e].cntDespachado  )

                                        var codigo2 = w2ui['grid'].records[e].codMaterial;
                                        var recidTest = parseInt(w2ui['grid'].records[e].recid);

                                        if(codigo == codigo2){
                                            // se elimina el repetido
                                            w2ui['grid'].select(recidTest);
                                            w2ui['grid'].delete(true);
                                        } // fin if

                                    }// fin for 3 
                                    // ----------------------------------

                                    var NewRecid;
                                    var masGrande = 0;

                                    // ----------------------------------
                                    // Busca el nuevo recid.
                                    for (var t = 0; t < w2ui['grid'].records.length; t++){ 
                                        
                                        NewRecid = w2ui['grid'].records[t].recid;
                                        
                                        if(NewRecid > masGrande){
                                            masGrande = NewRecid;
                                        }
                                    }// fin for 4
                                    // ----------------------------------

                                    // se agrega el nuevo.
                                    w2ui['grid'].add({ recid: masGrande + 1, codMaterial: codMaterial, nombreMaterial: nombreMaterial, item: item, cntDespachado: sumaTotal, cntDevuelta: sumaDevolucion, cntDevolver: 0, PrecioUnitario: PrecioUnitario, total: total,  existencia: existencia });

                                }// fin for 1

                                var NewRecid = 1;
                                

                                // ----------------------------------
                                // Ordena los recid de los articulos del 1 al x.
                                for (var e = w2ui['grid'].records.length - 1; e >= 0; e--){ 

                                    // valores antiguos
                                    var recid =  w2ui['grid'].records[e].recid;
                                    var codMaterial =  w2ui['grid'].records[e].codMaterial;
                                    var nombreMaterial =  w2ui['grid'].records[e].nombreMaterial;
                                    var item =  w2ui['grid'].records[e].item;
                                    var cntDespachado = parseInt(w2ui['grid'].records[e].cntDespachado);
                                    var cntDevuelta =  parseInt(w2ui['grid'].records[e].cntDevuelta);
                                    var PrecioUnitario =  w2ui['grid'].records[e].PrecioUnitario;
                                    var total =  w2ui['grid'].records[e].total;
                                    var existencia =  w2ui['grid'].records[e].existencia;

                                    w2ui['grid'].select(recid);
                                    w2ui['grid'].delete(true);

                                    // se agrega el nuevo.
                                    w2ui['grid'].add({ recid: NewRecid, codMaterial: codMaterial, nombreMaterial: nombreMaterial, item: item, cntDespachado: cntDespachado, cntDevuelta: cntDevuelta, cntDevolver: (cntDespachado - cntDevuelta), PrecioUnitario: PrecioUnitario, total: total,  existencia: existencia });
                                    NewRecid = NewRecid + 1;

                                }// fin for 4
                                // ----------------------------------

                                // Guarda valor de Bodega.
                                codBodega = response.articulo[0].bodega;

                             }// Fin success
                           });// fin ajax


                            // Busca el nuevo recid.
                            for (var t = 0; t < w2ui['grid'].records.length; t++){   
                                valorForm = valorForm + parseInt(w2ui['grid'].records[t].total);
                            }// fin for 2


                          // Busca Institucion.
                          $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Recepciones/RecepcionxPrestamo/cargaHistorialxNumeroRecpXSoliPrestamo.ashx",
                            async: false,
                            data: { "NumeroaDonacion": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO},
                            dataType: "json",
                            success: function (response) {

                                for (var i = 0; i < response.records.length; i++){ 
                                    // Guarda valor de Institucion.
                                    if(response.records[i].FLD_CMVNUMERO == w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO
                                        && response.records[i].FLD_PERCODIGO == w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO){
                                        codInstitucion = response.records[i].Instituto
                                    }
                                }

                             }// Fin success
                          });// fin ajax


                            // Traspado valores al principal.
                            w2ui['form'].record['fechaPrestamo'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PREFECHA;
                            w2ui['form'].record['anioPrestamo'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PERCODIGO;
                            //w2ui['form'].record['descripcion'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PREDESCRIPCION;
                            w2ui['form'].record['NPrestamo'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_CMVNUMERO;
                            w2ui['form'].record['Nombre_Bodega'] = codBodega;
                            w2ui['form'].record['Nombre_Institucion'] = codInstitucion;
                            w2ui['form'].record['valor'] = valorForm;
                            w2ui['form'].refresh();
                            w2popup.close();

                            // Limpia el popUp
                            this.clear();
                            w2ui['grid2'].clear();
                            this.record['NDonacion'] = '';
                            this.refresh();


                            // Devolucion ya guardada, se recuperan los datos.
                            if(Ingresado == 1){

                                $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/getDatos_EncabezadoHistotico_PorDevoDePrestamo.ashx",
                                async: false,
                                data: { "CodigoTrasaccionNuevo": 'E', "CodigoTrasaccionAntiguo": 'J', "fechaPrestamo": w2ui['form'].record['anioPrestamo'], "NcorrelativoAntiguo_Prestamo": w2ui['form'].record['NPrestamo']},
                                dataType: "json",
                                success: function (response) {
//console.log(response)

                                    w2ui['form'].record['NDevolucion'] = response.NDevolucion;
                                    w2ui['form'].record['descripcion'] = response.Descripcion;
                                    w2ui['form'].record['fechaServidor'] = response.fechaDevPrestamo;
                                    w2ui['form'].record['anioDonacion'] = response.anioDevPrestamo;
                                    w2ui['form'].refresh();

                                }// Fin success
                                });// fin ajax                      
                      
                          }// fin carga datos ya ingresados.

                    }else{

                      // Busca Bodega y Articulos Asociados.
                      $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/getArticlosAGrid1xPrestamoAntiguo.ashx",
                        async: false,
                        data: { "NumeroPrestamo": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO, "FechaPrestamo": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO },
                        dataType: "json",
                        success: function (response) {
                            
                            // Forma Atigua.
                            //------------------------------------------------
                            w2ui['grid'].clear();
                            var recidID = 1;
                            for (var i = 0; i < response.records.length; i++){ 
                                // recid, nombreMaterial, cntDespachado, cntDevolver, PrecioUnitario
                                w2ui['grid'].add({ recid: recidID,codMaterial: response.records[i].FLD_MATCODIGO, nombreMaterial: response.records[i].FLD_MATNOMBRE, cntDespachado: response.records[i].FLD_MOVCANTIDAD, cntDevuelta: response.records[i].CNT_DEVOLVER, PrecioUnitario: response.records[i].FLD_PRECIOUNITARIO });
                                recidID = recidID + 1;
                            }

                            // Guarda fechas actuales.
                            var fechaActual = w2ui['form'].record['fechaServidor'];
                            var anioActual = w2ui['form'].record['anioDonacion'];

                            // Identifica y despliega la Bodega Bodega records
                            w2ui['form'].record['Nombre_Bodega'] = response.records[0].FLD_BODCODIGO
                            
                            // Despliega la informacion del form Izquierda
                            w2ui['form'].record['fechaPrestamo'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PREFECHA;
                            w2ui['form'].record['anioPrestamo'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PERCODIGO;
                            //w2ui['form'].record['NPrestamo'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_CMVNUMERO;
                            //w2ui['form'].record['observacion'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PREDESCRIPCION;
                            
                            // Despliega la informacion del form Derecha
                            w2ui['form'].record['anioDonacion'] = anioActual;
                            w2ui['form'].record['NPrestamo'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_CMVNUMERO;
                            w2ui['form'].record['fechaServidor'] = fechaActual;
                            w2ui['form'].refresh();
                            w2popup.close();

                         }// Fin success
                      });// fin ajax

                    } // end if Nuevo o Antiguo

                     // Limpia el popUp
                        this.clear();
                        w2ui['grid2'].clear();
                        this.record['NDevolucion'] = '';
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
		        title 	: 'Historial - Devoluciones de Préstamos',
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
            else
                return true;

            //return /\d/.test(String.fromCharCode(keynum));
        } 

// console.log(event)
    
    </script>
</asp:Content>

