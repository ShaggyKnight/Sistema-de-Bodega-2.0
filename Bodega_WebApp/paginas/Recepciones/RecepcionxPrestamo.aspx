<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master"
 CodeBehind="RecepcionxPrestamo.aspx.vb" Inherits="Bodega_WebApp.RecepcionxPrestamo" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.recepSolicitudPrestamo%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:3px; height: 230px">
    </div>
    <div id="grid" style="width: 100%; height: 260px;">
    </div>
    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247);"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        $('#form').w2form({
            name: 'form',
            style: 'border: 0px; background-color: #f5f6f7;',
            recid: 10,
            url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
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
				    '<div class="w2ui-label w2ui-span4">Descripción</div>'+
				    '<div class="w2ui-field w2ui-span4">'+
					    '<textarea name="descripcion" type="text" style="width: 86%; height: 56px; resize: none; margin-left: 2px;"></textarea>' +
				    '</div>'+
			      '</div>'+
		        '</div>' +

		        '<div style="margin-left: 500px; width: 340px; width: 268px;">' +
			      '<div style="padding: 3px; font-weight: bold; color: #030303;">Rec. por Prestamo Generado</div>'+
			        '<div class="w2ui-group" style="height: 120px;">'+
				    '<div class="w2ui-label w2ui-span5" style="margin-top: 28px; text-align: left; margin-left: 12px;">Periodo</div>' +
				    '<div class="w2ui-field w2ui-span5">'+
					    '<input name="anioDonacion" type="text" maxlength="100" style="width: 70%; margin-top: 19px; margin-left: 15px;" disabled/>' +
				    '</div>'+
				    '<div class="w2ui-label w2ui-span5">N°Rec. Prestamo</div>'+
				    '<div class="w2ui-field w2ui-span5">'+
				    '	<input name="NDonacion" type="text" maxlength="100" style="width: 70%; margin-left: 10px;" disabled/>' +
				    '</div>'+
			      '</div>'+
		        '</div>'+
              '</div>'
                    ,
            fields: [
		            { name: 'fechaServidor', type: 'text' },
                    { name: 'anioDonacion', type: 'text' },
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
                    { field: 'existencia', caption: 'Existencia', size: '14%' },
                    { field: 'loteSerie', caption: 'Serie o Lote', size: '16%',
                        editable: { type: 'text', inTag: 'maxlength=12' }, attr: "align=center"
                    },
                    { field: 'fechaVencimiento', caption: 'Fecha Vto.', size: '20%', 
                        editable: { type: 'date', format: 'dd/mm/yy'}, attr: "align=center" 
                    },
		        ],
            records: [
                { recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor:'', total: '', existencia: '', loteSerie: '', fechaVencimiento: '' }
	            ],

            // Agrega un nuevo elemento.
            onAdd: function (event) {
                w2ui['grid'].select('');
                alert(w2ui['grid'].select(''));
                w2ui['grid'].delete(true);
                openPopup();

            },


            // Cambio en la grilla.
            onChange: function (event) {

                // valida que la descripcion este escrita.
                if(w2ui['form'].record['descripcion']){
                }else{
                    w2ui['form'].record['descripcion'] = '';
                    w2ui['form'].refresh();
                }

                // -----------------------------------
                // Verifica si modifica la columna ID.
                if(event.column == 0){

                    // Comprueba que el campo bodega este comleto.
                    if (w2ui['form'].record['Nombre_Bodega']){
                        
                        if(event.recid == ""){

                          $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Recepciones/RecepcionxPrestamo/getBusquedaxCodigoRecepxSoliPrestamo.ashx",
                            async: false,
                            data: { "codigoMaterial": event.value_new, "codBodega": w2ui['form'].record['Nombre_Bodega'] },
                            dataType: "json",
                            success: function (response) {

                                if(response.item == "null"){

                                    alert('¡Error, código no valido!')
                                    w2ui['grid'].select('');
                                    w2ui['grid'].delete(true);
                                    w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor:'', total: '', existencia: '', loteSerie: '', fechaVencimiento: '' });
 
                                }else{

                                    var precio = parseInt(response.precio);
                                    var totalParcial = 1 * precio;

                                    // Ingresa un nuevo elemento al grid.
                                    var Id_Grid1 = w2ui['grid'].records.length;
                                    w2ui['grid'].select('');
                                    w2ui['grid'].delete(true);
                                    w2ui['grid'].add({ recid: Id_Grid1, codMaterial: event.value_new, nombreMaterial: response.descripcion, item: response.item, cantidad: 1, valor: response.precio, total: totalParcial, existencia: response.existencia, loteSerie: '', fechaVencimiento: '' });
                                } // Fin Validador de codigo

                            }// Fin success
                          });// fin ajax

                        } // Fin iF ""
                    }else{
                        alert('Primero debe indicar la BODEGA en la que se recibirá el material. ');
                        w2ui['grid'].select('');
                        w2ui['grid'].delete(true);
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor:'', total: '', existencia: '', loteSerie: '', fechaVencimiento: '' });
                    }                    
                }// Fin if 0


                // ----------------------------------------
                // Verifica si se modifico la columna Cantidad.
                if(event.column == 3){
                                     
                    var local_Codigo;
                    var local_Nombre;
                    var local_Item;
                    var local_Valor;
                    var local_Existencia;
                    var local_Serie;
                    var local_Fecha;

                  if(event.recid == ""){
                    alert('¡Error, Primero ingresar el codigo.')
                    w2ui['grid'].select(event.recid);
                    w2ui['grid'].delete(true);
                    w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor:'', existencia: '', total: '', loteSerie: '', fechaVencimiento: '' });
                  }else{
                    
                    if(event.value_new >= 1){

                        for (var i = 0; i < w2ui['grid'].records.length; i++){ 
                         
                            if(event.recid == w2ui['grid'].records[i].recid){

                                local_Codigo = w2ui['grid'].records[i].codMaterial;
                                local_nombre = w2ui['grid'].records[i].nombreMaterial;
                                local_Item = w2ui['grid'].records[i].item;
                                local_Valor = w2ui['grid'].records[i].valor;
                                local_Existencia = w2ui['grid'].records[i].existencia;

                                // Para valiar que la serie o lote este ingresado.
                                if(w2ui['grid'].records[i].loteSerie  == ""){
                                    local_Serie = "";
                                }else{
                                    local_Serie = w2ui['grid'].records[i].loteSerie;
                                }

                                // Para valiar que la fecha este ingresada.
                                if(w2ui['grid'].records[i].fechaVencimiento  == ""){
                                    local_Fecha = "";
                                }else{
                                    local_Fecha = w2ui['grid'].records[i].fechaVencimiento;
                                }
                            }
                        } // fin for.

                        var precio = parseInt(local_Valor)
                        var total = event.value_new * precio;
                        
                        w2ui['grid'].select('');
                        w2ui['grid'].delete(true);
                        w2ui['grid'].select(event.recid);
                        w2ui['grid'].delete(true);
                        
                        // Para valiar que la fecha este ingresada.
                        if(local_Fecha  == "" || local_Serie == ""){
                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cantidad: event.value_new, valor: local_Valor, total: total, existencia: local_Existencia, loteSerie: local_Serie, fechaVencimiento: local_Fecha });
                        }else{
                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cantidad: event.value_new, valor: local_Valor, total: total, existencia: local_Existencia, loteSerie: local_Serie, fechaVencimiento: local_Fecha });
                            w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor:'', total: '', loteSerie: '', fechaVencimiento: '' });
                        }

                    }// Fin if valor nuevo mayor a 1

                    if(event.value_new == 0){
                        
                        alert('¡Error, la cantidad no puede ser 0.')

                        for (var i = 0; i < w2ui['grid'].records.length; i++){ 
                         
                            if(event.recid == w2ui['grid'].records[i].recid){

                                local_Codigo = w2ui['grid'].records[i].codMaterial;
                                local_nombre = w2ui['grid'].records[i].nombreMaterial;
                                local_Item = w2ui['grid'].records[i].item;
                                local_Valor = w2ui['grid'].records[i].valor;
                                local_Existencia = w2ui['grid'].records[i].existencia;

                                // Para valiar que la serie o lote este ingresado.
                                if(w2ui['grid'].records[i].loteSerie  == ""){
                                    local_Serie = "";
                                }else{
                                    local_Serie = w2ui['grid'].records[i].loteSerie;
                                }

                                // Para valiar que la fecha este ingresada.
                                if(w2ui['grid'].records[i].fechaVencimiento  == ""){
                                    local_Fecha = "";
                                }else{
                                    local_Fecha = w2ui['grid'].records[i].fechaVencimiento;
                                }
                            }
                        } // fin for.

                        w2ui['grid'].select(event.recid);
                        w2ui['grid'].delete(true);
                        w2ui['grid'].select('');
                        w2ui['grid'].delete(true);
                        var precio = parseInt(local_Valor)
                        var totalParcial = 1 * precio;
                        
                        w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cantidad: 1, valor: local_Valor, total: totalParcial, existencia: local_Existencia, loteSerie: local_Serie, fechaVencimiento: local_Fecha });
                    }// Fin if valor = 0
                  } // Fin if verificardor de rcid vacio.

                }// Fin if 3


                // ------------------------
                // Modificar Lote o Serie.
                if(event.column == 7){

                    var local_Codigo;
                    var local_Nombre;
                    var local_Item;
                    var local_Cantidad;
                    var local_Valor;
                    var local_Total;
                    var local_Existencia;
                    var local_Fecha;

                    if(event.recid == ""){
                        alert('¡Error, Primero ingresar el codigo.')
                        w2ui['grid'].select(event.recid);
                        w2ui['grid'].delete(true);
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor:'', total: '', loteSerie: '', fechaVencimiento: '' });
                    }else{

                        for (var i = 0; i < w2ui['grid'].records.length; i++){ 
                            if(event.recid == w2ui['grid'].records[i].recid){

                                local_Codigo = w2ui['grid'].records[i].codMaterial;
                                local_Nombre = w2ui['grid'].records[i].nombreMaterial;
                                local_Item = w2ui['grid'].records[i].item;
                                local_Cantidad = w2ui['grid'].records[i].cantidad;
                                local_Valor = w2ui['grid'].records[i].valor;
                                local_Existencia = w2ui['grid'].records[i].existencia;

                                // para valiar que cantidad este ingresada.
                                if(w2ui['grid'].records[i].cantidad  != 0){
                                    local_Cantidad = w2ui['grid'].records[i].cantidad;
                                    local_Total = w2ui['grid'].records[i].total;
                                }else{
                                    local_Cantidad = 0;
                                    local_Total = "";
                                }

                                // para valiar que la fecha este ingresada.
                                if(w2ui['grid'].records[i].fechaVencimiento  == ""){
                                    local_Fecha = "";
                                }else{
                                    local_Fecha = w2ui['grid'].records[i].fechaVencimiento;
                                }
                            }
                        }

                        w2ui['grid'].select('');
                        w2ui['grid'].delete(true);
                        w2ui['grid'].select(event.recid);
                        w2ui['grid'].delete(true);

                        // Para valiar que la fecha este ingresada.
                        if(local_Fecha  == "" || local_Total == ""){
                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, item: local_Item, cantidad: local_Cantidad, valor: local_Valor, total: local_Total, existencia: local_Existencia, loteSerie: event.value_new, fechaVencimiento: local_Fecha });
                        }else{
                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, item: local_Item, cantidad: local_Cantidad, valor: local_Valor, total: local_Total, existencia: local_Existencia, loteSerie: event.value_new, fechaVencimiento: local_Fecha });
                            w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor:'', total: '', loteSerie: '', fechaVencimiento: '' });
                        }
                        
                    }
                } // Fin editar columna 8

                // ------------------------
                // Modificar Lote o Serie.
                if(event.column == 8){

                    var local_Codigo;
                    var local_Nombre;
                    var local_Item;
                    var local_Cantidad;
                    var local_Valor;
                    var local_Total;
                    var local_Existencia;
                    var local_Serie;

                    if(event.recid == ""){
                        alert('¡Error, Primero ingresar el codigo.')
                        w2ui['grid'].select(event.recid);
                        w2ui['grid'].delete(true);
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor:'', total: '', loteSerie: '', fechaVencimiento: '' });
                    }else{

                        for (var i = 0; i < w2ui['grid'].records.length; i++){ 
                            if(event.recid == w2ui['grid'].records[i].recid){

                                local_Codigo = w2ui['grid'].records[i].codMaterial;
                                local_Nombre = w2ui['grid'].records[i].nombreMaterial;
                                local_Item = w2ui['grid'].records[i].item;
                                local_Valor = w2ui['grid'].records[i].valor;
                                local_Existencia = w2ui['grid'].records[i].existencia;


                                // para valiar que cantidad este ingresada.
                                if(w2ui['grid'].records[i].cantidad  != 0){
                                    local_Cantidad = w2ui['grid'].records[i].cantidad;
                                    local_Total = w2ui['grid'].records[i].total;
                                }else{
                                    local_Cantidad = 0;
                                    local_Total = "";
                                }

                                // para valiar que la serie o lote este ingresado.
                                if(w2ui['grid'].records[i].loteSerie  == ""){
                                    local_Serie = "";
                                }else{
                                    local_Serie = w2ui['grid'].records[i].loteSerie;
                                }
                            }
                        }

                        w2ui['grid'].select('');
                        w2ui['grid'].delete(true);
                        w2ui['grid'].select(event.recid);
                        w2ui['grid'].delete(true);

                        // Para valiar que el total esta completo y agrega un articulo.
                        if(local_Total  == ""){
                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, item: local_Item, cantidad: local_Cantidad, valor: local_Valor, total: local_Total, existencia: local_Existencia, loteSerie: local_Serie, fechaVencimiento: event.value_new });
                        }else{
                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, item: local_Item, cantidad: local_Cantidad, valor: local_Valor, total: local_Total, existencia: local_Existencia, loteSerie: local_Serie, fechaVencimiento: event.value_new });
                            w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor:'', total: '', loteSerie: '', fechaVencimiento: '' });
                        }
                    }
                } // Fin editar columna 8
            },
            //-------------------------


            // ================================
            // Grabar nueva Donación.
            onSave: function (event) {

                // valida que la descripcion este escrita.
                if(w2ui['form'].record['descripcion']){
                }else{
                    w2ui['form'].record['descripcion'] = '';
                    w2ui['form'].refresh();
                }


            // ================================

            // Obtiene Numero Correlativo
            // ================================

                if(w2ui['form'].record['NDonacion']){
                    alert('Ud. NO puede grabar la Donación por que esta ya EXISTE.')
                }else{

                  $.ajax({
                    type: "POST",
                    url: "../../clases/persistencia/controladores/Recepciones/RecepcionxPrestamo/getCorrelativoRecepxSolicitudPrestamo.ashx",
                    async: false,
                    data: { "fecha": w2ui['form'].record['anioDonacion'] },
                    dataType: "json",
                     success: function (response) {
                    
                        if(response.item == "null"){

                            alert('¡Error, Correlativo no encontrado!')
 
                            }else{
                                w2ui['form'].record['NDonacion'] = response.Correlativo;
                                w2ui['form'].refresh();
                        } // Fin Validador de codigo

                     }// Fin success
                    });// fin ajax


                // ==========================
         
                // Graba el Movimiento
                // ==========================

                // Se elimina la celda de codigo '', para poder guardar los datos actuales.
                w2ui['grid'].select('');
                w2ui['grid'].delete(true);

                
                // Verifica que el Grid Contenga Datos.
                if(w2ui['grid'].records.length > 0 && w2ui['form'].record['Nombre_Bodega'] &&  w2ui['form'].record['Nombre_Institucion']){
                        

                    $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/saveMovimiento.ashx",
                        async: false,
                        data: { "fecha": w2ui['form'].record['anioDonacion'], "NumeroDonacionArticulo": 'J' ,"NumeroCorrelativo": w2ui['form'].record['NDonacion']},
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

                        var cont = 1;
                        var CodigoMaterial;
                        var ItemMaterial;
                        var CantidadMovimiento;
                        var PrecioUnitario;
                        var NSerielote;
                        var fechaVencimiento;

                        for (var i = 0; i <= w2ui['grid'].records.length - 1; i++){ 

                            CodigoMaterial = w2ui['grid'].records[i].codMaterial;
                            ItemMaterial = w2ui['grid'].records[i].item;
                            CantidadMovimiento = w2ui['grid'].records[i].cantidad;
                            PrecioUnitario = w2ui['grid'].records[i].valor;
                            NSerielote = w2ui['grid'].records[i].loteSerie;
                            fechaVencimiento = w2ui['grid'].records[i].fechaVencimiento;

                            $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/saveDetalleMovimiento.ashx",
                            async: false,
                            data: {"cont": cont, "NumeroDonacionArticulo": 'J', "fecha": w2ui['form'].record['anioDonacion'], "NumeroCorrelativo": w2ui['form'].record['NDonacion'], "CantidadMovimiento": CantidadMovimiento, "dbodega": w2ui['form'].record['Nombre_Bodega'], "CodigoMaterial": CodigoMaterial,"ItemMaterial": ItemMaterial,"null": 0 ,"null2": 0 ,"null3": 0 ,"PrecioUnitario": PrecioUnitario, "NSerie": NSerielote, "fechaVencimiento": fechaVencimiento},
                            dataType: "json",
                             success: function (response) {
                    
                                if(response.item == "done"){

                                } // Fin Validador de codigo

                              }// Fin success
                            });// fin ajax

                            cont = cont + 1;

                        }// Fin for.


                        // ===========================

                        // Graba el Prestamo.
                        // ===========================   

                        // Modifica el valor Total
                        var total = 0;
                        for(var i = 0; i <= w2ui['grid'].records.length -1; i++){ 
                            total = total + parseInt(w2ui['grid'].records[i].total);
                        }

                        $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Recepciones/RecepcionxPrestamo/savePrestamoRecepxSolicitudPrestamo.ashx",
                        async: false,
                        data: { "fecha": w2ui['form'].record['anioDonacion'], "NumeroDonacionArticulo": 'J', "NumeroCorrelativo": w2ui['form'].record['NDonacion'], "fechaCompleta": w2ui['form'].record['fechaServidor'], "descripcion": w2ui['form'].record['descripcion'], "valor": total, "numeroDoc": 1, "Instituto": w2ui['form'].record['Nombre_Institucion'] },
                        dataType: "json",
                         success: function (response) {
                    
                            if(response.item == "done"){

                                alert('¡Registro completado con éxito!');

                            } // Fin Validador de codigo

                         }// Fin success
                        });// fin ajax

                }else{  
                    alert('¡Error, Faltan datos en la tabla o en el formulario!')
                    w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor:'', total: '', loteSerie: '', fechaVencimiento: '' });
                }// fin if grid.

            } // Fin verifica si existe correlativo.


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
		            '	<input type="button" value="Buscar Recepciones" onclick="openPopup()" name="buscar" style="width: 132px;">' +
		            '	<input type="button" value="Limpiar" name="limpiar">' +
                    '	<input type="button" value="Imprimir" name="imprimir">' +
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

			        "imprimir": function () {

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
                        w2ui['foo'].clear();8
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
		        header: 'Criterio de Busqueda',
		        name: 'form3',
		        fields: [
			        { name: 'NDonacion', type: 'text', required: true, html: { caption: 'N° Prestamo', attr: 'size="10" maxlength="10"' } },
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
                            w2ui['grid2'].url = '../../clases/persistencia/controladores/Recepciones/RecepcionxPrestamo/cargaHistorialxFechaRecpXSoliPrestamo.ashx?FechaDonacion=' + w2ui['form3'].record.FDonacion;
                            w2ui['grid2'].reload();
                        }
                        // Busqueda por numero de donación.
                        else if (w2ui['form3'].record.NDonacion != ''){
                           w2ui['grid2'].url = '../../clases/persistencia/controladores/Recepciones/RecepcionxPrestamo/cargaHistorialxNumeroRecpXSoliPrestamo.ashx?NumeroaDonacion=' + w2ui['form3'].record.NDonacion;
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
                        
                        var codBodega;
                        var codInstitucion;

                      // Busca Bodega y Articulos Asociados.
                      $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getArticulosGrid2.ashx",
                        async: false,
                        data: { "codigo": 'J', "Periodo": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO, "Numero": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO },
                        dataType: "json",
                        success: function (response) {

                            // Carga articulos Grid1
                            w2ui['grid'].clear();
                            var recidID = 1;
                            for (var i = 0; i < response.articulo.length; i++){ 
                                w2ui['grid'].add({ recid: recidID, codMaterial: response.articulo[i].recid, nombreMaterial: response.articulo[i].FLD_MATNOMBRE, item: response.articulo[i].FLD_ITECODIGO, cantidad: response.articulo[i].FLD_MOVCANTIDAD, valor: response.articulo[i].FLD_PRECIOUNITARIO, total: response.articulo[i].totalDonacion,  existencia: response.articulo[i].cantidadExistente, loteSerie: response.articulo[i].Nserie, fechaVencimiento: response.articulo[i].fechaVto });
                                recidID = recidID + 1;
                            }

                            // Guarda valor de Bodega.
                            codBodega = response.articulo[0].bodega;

                         }// Fin success
                      });// fin ajax


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


                        // Trascribe al Form la Bodega y la Institución.
                        w2ui['form'].record = {
                            Nombre_Bodega: codBodega,
                            Nombre_Institucion: codInstitucion
                        }

                        // Traspado valores al principal.
                        w2ui['form'].record['fechaServidor'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PREFECHA;
                        w2ui['form'].record['anioDonacion'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PERCODIGO;
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
		        title 	: 'Busqueda de Recepciones Por Préstamo',
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
    
// console.log(w2ui['grid2'].getSelection());

    </script>
</asp:Content>
