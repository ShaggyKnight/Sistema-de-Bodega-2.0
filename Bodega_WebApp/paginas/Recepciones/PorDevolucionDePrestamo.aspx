<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="PorDevolucionDePrestamo.aspx.vb" Inherits="plantilla2013vbasic.PorDevolucionDePrestamo" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, plantilla2013vbasic.Site).idePagina = plantilla2013vbasic.Pagina.despaDevolucionDePrestamos%>
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:3px; height: 250px">
    </div>
    <div id="grid" style="width: 100%; height: 320px;">
    </div>
    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247);"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        // Variables Globales Grid

        $('#form').w2form({
            name: 'form',
            style: 'border: 0px; background-color: #f5f6f7;',
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
                                '<div class="w2ui-label w2ui-span5" style="width: 104px; margin-left: 12px; text-align: left; margin-top: 12px;">Valor</div>'+
				                '<div class="w2ui-field w2ui-span5">'+
				                '	<input name="valor" type="text" maxlength="100" style="width: 32%; margin-left: -16px;" disabled/>' +
				                '</div>'+
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
                    { name: 'fechaPrestamo', type: 'text' }
                    
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
                toolbar: true,
                footer: true
            },
            multiSearch: false, 
            searches: [
			        { type: 'text', field: 'recid', caption: 'Codigo Material' },
		        ],
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
                        //if(anio >= 2014 && ValorDevuelto > 0){
                        if(anio >= 2014){

				            $('#'+ event.box_id).w2grid({
					            name: 'subgrid-' + event.recid, 
					            show: { columnHeaders: true,
                                        toolbar: true,
                                        toolbarAdd: false,
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
					            ]
//                                ,
//					            records: [
//						            { recid: 1 ,codMaterial2: w2ui['grid'].records[idLocalTemp -1].codMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: ''}
//					            ]

                                ,
                                //-------------------------


                                // ================================
                                // ================================
                                // Grabar nueva Donación.
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
    //alert('control 0')
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

   // alert('tamaño' + w2ui[subGridName].records.length);

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

                                        //alert(local_Recid +" "+ local_Codigo+" "+local_nombre +" "+local_Item +" "+local_CntDespachada +" "+local_CntDevuelta +" "+local_Precio+" "+local_Total +" "+local_Existencia)
                                        w2ui['grid'].add({ recid: local_Recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cntDespachado: local_CntDespachada, cntDevuelta: local_CntDevuelta, cntDevolver: local_CntDevolver, PrecioUnitario: local_Precio, total: local_Total, existencia: local_Existencia, "style": "background-color: #C2F5B4" });

                                        //----------------------------
                                    
                                    }else{

                                        // CASO 1.- Existe incompleto. (form no a sido guardado en tabla 1).

                                        // ========================
                                        // Control de Correlativo
                                        // ========================
                                            
                                        // Verifica si los datos vienen de la principal o de ninguna.
                                        var datos = 0;

                                        $.ajax({
                                        type: "POST",
                                        url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/buscaCorrelativo_Despacho_PorDevolucionDePrestamo.ashx",
                                        async: false,
                                        data: { "fecha": w2ui['form'].record['anioPrestamo'], "Ncorrelativo": w2ui['form'].record['NDevolucion'],  "CodMaterial": w2ui['grid'].records[IDTemp].codMaterial },
                                        dataType: "json",
                                        success: function (response) {

 console.log(response)                    
                                            if(response.item == "null"){

                                                alert('¡Error, Correlativo no encontrado!')
 
                                            }else{
                                                var tabla = parseInt(response.Tabla)

                                                if(tabla == 1){
                                                    datos = 1;
    //alert('tabla 1')
                                                }

                                                if(tabla == 3){
                                                    datos = 3;
    //alert('tabla 3')
                                                }

                                            } // Fin Validador de codigo

                                        }// Fin success
                                        });// fin ajax

                                        // esta siendo engresado, momentaneamente esta incompleto.
                                        if (datos == 3){
    //alert('control tabla 3')          
                                            // ===========================
         
                                            // Graba Detalle de Movimiento
                                            // ===========================

                                            // General
                                            var CodigoMovimiento2 = 'E';
                                            var anioDevolucion2 = w2ui['form'].record['anioDonacion'];
                                            var CodCorrelativo2  = w2ui['form'].record['NDevolucion'];
                                            var cantidadYaEntregado2 = parseInt(w2ui['grid'].records[IDTemp].cntDevuelta);
                                            var CodBodega2 = w2ui['form'].record['Nombre_Bodega'];
                                            var ItemArticulo2 = w2ui['grid'].records[IDTemp].item;
                                            var PrecioUni2 = w2ui['grid'].records[IDTemp].PrecioUnitario;

                                            // Grid Detalle.
                                            var local_CodMaterial2;
                                            var local_Cantidad2;
                                            var local_Serielote2;
                                            var local_fechaVto2;
                                            var cont2 = 1;

                                            for (var i = 0; i < w2ui[subGridName].records.length; i++){ 
                                        
                                                local_CodMaterial2 = w2ui[subGridName].records[i].codMaterial2;
                                                local_Cantidad2 =  w2ui[subGridName].records[i].cantidad2;
                                                local_Serielote2 =  w2ui[subGridName].records[i].loteSerie2;
                                                local_fechaVto2 = w2ui[subGridName].records[i].fechaVencimiento2;

                                                $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/saveTempRecep_PorDevolucionDePrestamo.ashx",
                                                //url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveTempRecep_DevolucionxPrestamo.ashx",
                                                async: false,
                                                data: {"cont": cont2, "NumeroDonacionArticulo": CodigoMovimiento2, "fecha": anioDevolucion2, "NumeroCorrelativo": CodCorrelativo2, "CantidadMovimientoGeneral": cantidadYaEntregado2, "CantidadMovimientoDetalle": local_Cantidad2, "CodigoMaterial": local_CodMaterial2, "NSerie": local_Serielote2, "fechaVencimiento": local_fechaVto2, "CodBodega": CodBodega2, "ItemArticulo": ItemArticulo2, "PrecioUni": PrecioUni2},
                                                dataType: "json",
                                                 success: function (response) {

                                                  }// Fin success
                                                });// fin ajax

                                                cont2 = cont2 + 1;

                                            }// Fin for.

                                            //----------------------------
                                            // Cambia color asigna termino
                                    
                                            var local_Recid2 = w2ui['grid'].records[IDTemp].recid;
                                            var local_Codigo2 = w2ui['grid'].records[IDTemp].codMaterial;
                                            var local_nombre2 = w2ui['grid'].records[IDTemp].nombreMaterial;
                                            var local_Item2 = w2ui['grid'].records[IDTemp].item;
                                            var local_CntDespachada2 = w2ui['grid'].records[IDTemp].cntDespachado;
                                            var local_CntDevuelta2 =w2ui['grid'].records[IDTemp].cntDevuelta;
                                            var local_CntDevolver2 = w2ui['grid'].records[IDTemp].cntDevolver;
                                            var local_Precio2 = w2ui['grid'].records[IDTemp].PrecioUnitario;
                                            var local_Total2 = w2ui['grid'].records[IDTemp].total;
                                            var local_Existencia2 = w2ui['grid'].records[IDTemp].existencia;

                                            w2ui['grid'].select(local_Recid2);
                                            w2ui['grid'].delete(true);

                                            //alert(local_Recid +" "+ local_Codigo+" "+local_nombre +" "+local_Item +" "+local_CntDespachada +" "+local_CntDevuelta +" "+local_Precio+" "+local_Total +" "+local_Existencia)
                                            w2ui['grid'].add({ recid: local_Recid2, codMaterial: local_Codigo2, nombreMaterial: local_nombre2, item: local_Item2, cntDespachado: local_CntDespachada2, cntDevuelta: local_CntDevuelta2, cntDevolver: local_CntDevolver2, PrecioUnitario: local_Precio2, total: local_Total2, existencia: local_Existencia2, "style": "background-color: #C2F5B4" });

                                            //----------------------------
                                            
                                        }else { // fin datos 3.
         
                                            //--------------
                                            if (datos == 1){

                                            // ============================
                                            // Obtiene NUEVO Correlativo
                                            // ============================
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

                                                //alert(local_Recid +" "+ local_Codigo+" "+local_nombre +" "+local_Item +" "+local_CntDespachada +" "+local_CntDevuelta +" "+local_Precio+" "+local_Total +" "+local_Existencia)
                                                w2ui['grid'].add({ recid: local_Recid3, codMaterial: local_Codigo3, nombreMaterial: local_nombre3, item: local_Item3, cntDespachado: local_CntDespachada3, cntDevuelta: local_CntDevuelta3, cntDevolver: local_CntDevolver3, PrecioUnitario: local_Precio3, total: local_Total3, existencia: local_Existencia3, "style": "background-color: #C2F5B4" });

                                                //---------------------------------

                                            }// fin datos 1.
                                            //--------------
                                        }

                                    } // fin control de ingreso.

                                  }//fin Global_SaveSubGrid verifica si se puede o no grabar.

                                },
                                //===========================
                                //===========================
                                // No se usa.
                                onChange: function (event) {

                            
                                } // fin Onchange
                                //-------------------------

				            }); // fin abrir grid para detalle, cuando existen valores 2014
				        w2ui['subgrid-' + event.recid].resize();

 // -----------------------------
 // Maneja los datos del Sub Grid
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

    //alert(datos);

                            // Tabla 1, busca los ya ingresados.
                            if(datos == 1){

                                //cntDespachado cntDevuelta cntDevolver
                                var Despachado = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);
                                var Devuelta = parseInt(w2ui['grid'].records[IDTemp].cntDevuelta); 

                                var prueba = Despachado - Devuelta;
                            
                                if(prueba == 0){
    //alert('A caso 1')
    //alert("codBodega " + w2ui['form'].record['Nombre_Bodega'] + " codMaterial "+ w2ui['grid'].records[IDTemp].codMaterial + " NCorrelativo "+ w2ui['form'].record['NDevolucion']);

                            
                                    $.ajax({
                                    type: "POST",
                                    url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/getHistorial_Detalle_PorDevolucionDePrestamo.ashx",
                                    async: false,
                                    data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[IDTemp].codMaterial, "NCorrelativo": w2ui['form'].record['NPrestamo'], "anioPrestamo": w2ui['form'].record['anioPrestamo']},
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
    //alert('B  caso 1')
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
   
                            }// fin datos 3

                        }else{ // Correlativo no existe.


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

            // Grabar nueva Donación.
            onSave: function (event) {

                // valida que la descripcion este escrita.
                if(w2ui['form'].record['observacion']){
                }else{
                    w2ui['form'].record['observacion'] = '';
                    w2ui['form'].refresh();
                }


//                //----------------------

//                var CodigoMovimiento = 'E'
//                var anioDevolucion = w2ui['form'].record['anioDonacion'];
//                var CodCorrelativo = w2ui['form'].record['NDevolucion'];
//                var CodBodega = w2ui['form'].record['Nombre_Bodega'];

//                for (var i = 0; i < w2ui['grid'].records.length; i++){ 
//                                        
//                    var cantidadYaEntregado = parseInt(w2ui['grid'].records[i].cntDevuelta);
//                    //var local_Cantidad = parseInt(w2ui['grid'].records[i].cntDevolver);
//                    var local_Cantidad = 0;
//                    var local_CodMaterial = w2ui['grid'].records[i].codMaterial;
//                    var local_Serielote = '---'
//                    var local_fechaVto = '01/01/1900';
//                    var ItemArticulo = w2ui['grid'].records[i].item;  
//                    var PrecioUni = w2ui['grid'].records[i].PrecioUnitario;
//                        
//                        // cntDespachado cntDevuelta cntDevolver

//                    $.ajax({
//                    type: "POST",
//                    url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/saveTempRecep_PorDevolucionDePrestamo.ashx",
//                    async: false,
//                    data: {"cont": w2ui['grid'].records.length + i, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioDevolucion, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadYaEntregado, "CantidadMovimientoDetalle": local_Cantidad, "CodigoMaterial": local_CodMaterial, "NSerie": local_Serielote, "fechaVencimiento": local_fechaVto, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni},
//                    dataType: "json",
//                    success: function (response) {

//                    }// Fin success
//                    });// fin ajax

//                }// Fin for. 


//                //----------------------


                if(w2ui['form'].record['NDevolucion']){

                    // ================================

                    // Obtiene Numero Correlativo
                    // ================================

                    var grabar = 0;

                    $.ajax({
                    type: "POST",
                    url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/buscaCorrelativo_Despacho_PorDevolucionDePrestamo.ashx",
                    async: false,
                    data: { "fecha": w2ui['form'].record['anioPrestamo'], "Ncorrelativo": w2ui['form'].record['NDevolucion'],  "CodMaterial": '' },
                    dataType: "json",
                    success: function (response) {
                    
                        if(response.item == "null"){

                            alert('¡Error, Correlativo no encontrado!')
 
                        }else{
                            var tabla = parseInt(response.Tabla)

                            if(tabla == 1){
                                grabar = 1;
                            }
                        } // Fin Validador de codigo

                    }// Fin success
                    });// fin ajax

                    if(grabar == 1){
                        alert('Ud. NO puede grabar la Devolución por que esta ya EXISTE.')
                    }else{
                
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

                    }// verifica si existe en tabla1.
                
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
                    //w2ui['form'].url = '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx';
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
                                                    data: { "cmd": 'RPTInforme', "NTransaccion": NTransaccion, "periodo": periodo, "codTransaccion": 'E', "Linea": cont, "codMaterial": CodigoMaterial, "nombreMaterial": NombreMaterial, "CodItem": '', "cantMaterial": CantidadMovimiento, "precioMaterial": PrecioUnitario, "bodega": bodega, "descripcion": w2ui['form'].record['descripcion'], "fechaMovimieno": fechaTransaccion, "proveedor": '', "ordenCompra": '0', "ordenCompraEstado": '', "numeroDocumento": NroPrestamo, "Institucion": programaMinsal, "centroCosto": '', "tipoDocumento": '', "tituloMenu": 'RECEPCIÓN PROGRAMA MINSAL', "descuento": '0', "impuesto": '0', "diferenciaPeso": '0', "usuario": '' },
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
console.log(response)

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

            return /\d/.test(String.fromCharCode(keynum));
        } 

// console.log(event)
    
    </script>
</asp:Content>

