<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="DevolucionxPrestamo.aspx.vb" Inherits="Bodega_WebApp.DevolucionxPrestamo" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.recepDevolucionPrestamo%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:3px; height: 250px; margin-bottom: 4px; margin-top: 2px;">
    </div>
    <div id="grid" style="width: 100%; height: 320px;">
    </div>
    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247);"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        /*
          *Solicitudes:
            Se agrego el buscador inmediato para la ventana en el form principal (metodos nuevos al final).
            Con correcciones en los llamados y el procedimiento (PRO_TB_DEVOLUCIONESxPRESTAMO_ENCABEZADO_NET2014)

          *Correcciones:
            El lote y/o numero de serie que ingresan del detalle se cambiaron a mayuscula.
            Ahora el grid solo muestra algunas propiedades del grid.
            Se incorporo el boton add.
            El ingreso manual valida con el Nserie que el producto exista para eliminar su saldo.
            Nuevo nivel de detalle en TB_DETALLE_EXISTENCIAS.
            Boton grabar
            (ojo antes del 126 no funciona porq no hay nada en la tabla nueva de detalle)

          *Pruebas:
            Save: ok
            Imprime: ok
            QR: ok 

        */

        // Variables Globales Grid
        var Global_ClonData = 0;

        $('#form').w2form({
            name: 'form',
            header: 'DEVOLUCIÓN DE PRÉSTAMO',
            style: 'background-color: #f5f6f7;',
            recid: 10,
            url: '../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/getFechaServer_DevoXPrestamo.ashx',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                        '<div style="width: 476px; margin-left: 20px; float: left;">' +
			                '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			                '<div class="w2ui-group" style="height: 175px;">' +

				                '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px;">N° Devolución</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
				                '	<input name="NDevolucion" id="NDevolucion" type="text" maxlength="100" style="width: 32%;margin-left: -11px;" disabled/>' +
				                '</div>' +

				                '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px;">Periodo</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
					                '<input name="anioDonacion" type="text" maxlength="100" style="width: 36%;margin-left: -12px;" disabled/>' +
				                '</div>' +

				                '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Fecha</div>' +
				                '<div class="w2ui-field w2ui-span4">' +
					                '<input name="fechaServidor" type="text" maxlength="100" style="width: 37%;margin-left: 8px;" disabled/>' +
				                '</div>' +

				                '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px;">Observación</div>' +
				                '<div class="w2ui-field w2ui-span5">' +
				                '	<input name="observacion" type="text" maxlength="100" style="width: 90%;margin-left: -11px;"/>' +
				                '</div>' +
				                '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Bodega</div>' +
		                        '	<div class="w2ui-field" style="margin-left: 90px !important;">' +
		                        '		<select name="Nombre_Bodega" id="Nombre_Bodega" type="text" style="margin-left: 7px;"/>' +
		                        '	</div>' +
			                '</div>' +
		           '</div>' +

		        '<div style="margin-left: 518px; width: 340px; width: 268px;">' +
			      '<div style="padding: 3px; font-weight: bold; color: #030303;">Información del Préstamo</div>' +
			        '<div class="w2ui-group" style="height: 140px;">' +

                    '<div class="w2ui-label w2ui-span5" style="margin-top: 20px; text-align: left; margin-left: 12px;">N° Préstamo</div>' +
				    '<div class="w2ui-field w2ui-span5">' +
					    '<input name="NPrestamo" type="text" maxlength="100" style="width: 70%; margin-top: 12px;"/>' +
				    '</div>' +

                    '<div class="w2ui-label w2ui-span5" style="margin-top: 9px; text-align: left; margin-left: 12px;">Periodo</div>' +
				    '<div class="w2ui-field w2ui-span5">' +
				    '	<input name="anioPrestamo" type="text" maxlength="100" style="width: 70%;" disabled/>' +
				    '</div>' +

                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 12px; margin-top: 12px;">Fecha</div>' +
				    '<div class="w2ui-field w2ui-span4">' +
					    '<input name="fechaPrestamo" type="text" maxlength="100" style="width: 62%;margin-left: 20px; margin-top: 2px;" disabled/>' +
				    '</div>' +

			      '</div>' +
		        '</div>' +
              '</div>'
                    ,
            fields: [
                    { name: 'NDevolucion', type: 'text' },
                    { name: 'anioDonacion', type: 'text' },
                    { name: 'fechaServidor', type: 'text' },
                    { name: 'observacion', type: 'text' },
		            { name: 'Nombre_Bodega', type: 'list',
		                options: {
		                    url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getLista.ashx',
		                    showNone: true
		                }
		            },
                    { name: 'anioPrestamo', type: 'text' },
                    { name: 'NPrestamo', type: 'text' },
                    { name: 'fechaPrestamo', type: 'text' }

	            ],
            onChange: function (event) {

                /* Agregar cambio buscador instantaneo. */
                if (event.target == "NPrestamo" && event.target != '') {
                    //nro_Fast = $('#NDevolucion').val();
                    setTimeout(function () {
                        DevoluPrestamo_Fast();

                        setTimeout(function () {
                            if ($('#NDevolucion').val() == '') {
                                $('#Nombre_Bodega').val('');
                            }
                        }, 450);

                    }, 600);
                }
            } // fin change.

        });    // Fin Form1


        $('#grid').w2grid({
            name: 'grid',
            header: 'Lista de Materiales',
            show: {
                header: true,
                footer: true,
                toolbar: true,
                toolbarReload: true,
                toolbarColumns: true,
                toolbarDelete: false,
                //toolbarSave: true,
                toolbarSearch: false
            },
            multiSearch: false,
            searches: [
			        { type: 'text', field: 'recid', caption: 'Codigo Material' },
		        ],
            columns: [
			        { field: 'codMaterial', caption: 'Cod. Material', size: '12%', attr: "align=center" },
			        { field: 'nombreMaterial', caption: 'Nombre Material', size: '32%' },
                    { field: 'item', caption: 'Item', size: '15%' },
                    { field: 'cntDespachado', caption: 'Cnt. Despachada', size: '16%' },
                    { field: 'cntDevuelta', caption: 'Cnt. Devuelta', size: '14%' },
			        { field: 'cntDevolver', caption: 'Cnt. Devolver', size: '14%', sortable: true, resizable: true,
			            editable: { type: 'int', inTag: 'maxlength=4' }, attr: "align=center"
			        },
                    { field: 'PrecioUnitario', caption: 'Precio Unitario', size: '20%' }
		        ],


            //===========================
            onExpand: function (event) {

                var idLocalTemp = event.recid;
                //var idSubGrid = 1;
                var Global_SaveSubGrid = 0;
                var IDTemp;

                // ----------------------------------
                // Encuentra el Recid actualmente utilizado.
                for (var z = 0; z <= w2ui['grid'].records.length - 1; z++) {

                    var recid = w2ui['grid'].records[z].recid;

                    if (event.recid == recid) {
                        IDTemp = z;
                    }

                } // fin for 2
                // ----------------------------------

                // Nombre del Grid
                var subGridName = 'subgrid-' + $.trim(event.recid);

                if (w2ui.hasOwnProperty('subgrid-' + event.recid)) w2ui['subgrid-' + event.recid].destroy();
                $('#' + event.box_id).css({ margin: '0px', padding: '0px', width: '100%' }).animate({ height: '105px' }, 100);

                setTimeout(function () {

                    var anio = w2ui['form'].record['anioPrestamo']

                    // Busca de acuerdo a si es Nuevo o Antiguo.
                    if (anio >= 2014) {

                        $('#' + event.box_id).w2grid({
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
						                editable: { type: 'int', format: 'maxlength = 4' }, attr: "align=center"
						            },
						            { field: 'loteSerie2', caption: 'Serie o Lote', size: '30%',
						                editable: { type: 'text', inTag: 'maxlength = 12' }, attr: "align=center"
						            },
						            { field: 'fechaVencimiento2', caption: 'Fecha Vto.', size: '30%',
						                editable: { type: 'date', format: 'dd/mm/yy' }, attr: "align=center"
						            },
                                    { field: 'oldVal', caption: ' ', size: '1%' },
					            ],
                            records: [
						            { recid: 1, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: '', oldVal: '' }
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
                                    w2ui[subGridName].add({ recid: (this.records[this.total - 1].recid + 1), codMaterial2: local_Codigo, cantidad2: '', loteSerie2: '', fechaVencimiento2: (day + '/' + month + '/' + year) });
                                    w2ui[subGridName].total = w2ui[subGridName].total + 1;

                                } else {
                                    alert('No puede ingresar mas articulos, Supera la Cantidad a Devolver.');
                                }

                            },
                            //-------------------------


                            // ================================
                            // ================================
                            /* saveDetalle */
                            onSave: function (event) {

                                if (Global_SaveSubGrid == 0) {
                                    alert('Cantidad maxima ingresada no Disponible.')
                                } else {


                                    if (w2ui[subGridName].records[w2ui[subGridName].records.length - 1].cantidad2 == '' || w2ui[subGridName].records[w2ui[subGridName].records.length - 1].loteSerie2 == '') {
                                        // Se elimina la ultima linea en blanco.
                                        w2ui[subGridName].remove(w2ui[subGridName].records[w2ui[subGridName].records.length - 1].recid);

                                    }


                                    // verifica si el articulo fue ingresado.
                                    var control = 0;

                                    // ================================

                                    // Obtiene Numero Correlativo
                                    // ================================

                                    if (w2ui['form'].record['NDevolucion']) {
                                        control = 1;
                                    } else {

                                        $.ajax({
                                            type: "POST",
                                            url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/getCorrelativoRecepDevoxPrestamo.ashx",
                                            async: false,
                                            data: { "fecha": w2ui['form'].record['anioDonacion'] },
                                            dataType: "json",
                                            success: function (response) {

                                                if (response.item == "null") {

                                                    alert('¡Error, Correlativo no encontrado!')

                                                } else {
                                                    w2ui['form'].record['NDevolucion'] = response.Correlativo;
                                                    w2ui['form'].refresh();
                                                } // Fin Validador de codigo

                                            } // Fin success
                                        }); // fin ajax

                                    } // fin if existe correlativo

                                    if (control == 0) {

                                        // ===========================

                                        // Graba Detalle de Movimiento
                                        // ===========================

                                        // General
                                        var CodigoMovimiento = 'T';
                                        var anioDevolucion = w2ui['form'].record['anioDonacion'];
                                        var CodCorrelativo = w2ui['form'].record['NDevolucion'];
                                        var cantidadMovimiento = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);
                                        var CodBodega = w2ui['form'].record['Nombre_Bodega'];
                                        var ItemArticulo = w2ui['grid'].records[IDTemp].item;
                                        var PrecioUni = w2ui['grid'].records[IDTemp].PrecioUnitario;

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

                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveTempRecep_DevolucionxPrestamo.ashx",
                                                async: false,
                                                data: { "cont": cont, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioDevolucion, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadMovimiento, "CantidadMovimientoDetalle": local_Cantidad2, "CodigoMaterial": local_CodMaterial2, "NSerie": local_Serielote2, "fechaVencimiento": local_fechaVto2, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni },
                                                dataType: "json",
                                                success: function (response) {

                                                    if (response.item == "done") {

                                                    } // Fin Validador de codigo

                                                } // Fin success
                                            }); // fin ajax

                                            cont = cont + 1;

                                        } // Fin for.

                                        var recid = w2ui['grid'].records[IDTemp].recid;
                                        var CodMaterial = w2ui['grid'].records[IDTemp].codMaterial;
                                        var nombreMaterial = w2ui['grid'].records[IDTemp].nombreMaterial;
                                        var item = w2ui['grid'].records[IDTemp].item;
                                        var cantDespachado = w2ui['grid'].records[IDTemp].cntDespachado;
                                        var cantDevuelta = parseInt(w2ui['grid'].records[IDTemp].cntDevuelta);
                                        var cantDevolver = 0;
                                        var PrecioUitario = w2ui['grid'].records[IDTemp].PrecioUnitario;

                                        // Se calcula La nueva Cantidad
                                        for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                            cantDevolver = cantDevolver + parseInt(w2ui[subGridName].records[i].cantidad2);
                                        } // Fin for.

                                        // Se elimina la ultima linea en blanco.
                                        w2ui['grid'].remove(recid);

                                        w2ui['grid'].add({ recid: recid, codMaterial: CodMaterial, nombreMaterial: nombreMaterial, item: item, cntDespachado: cantDespachado, cntDevuelta: cantDevuelta, cntDevolver: cantDevolver, PrecioUnitario: PrecioUitario, "style": "background-color: #C2F5B4" });


                                        // fin control si es 0.
                                    } else {

                                        // ========================
                                        // Control de Correlativo, ESTA Nº DEVOLUCION
                                        // ========================

                                        // Verifica si los datos vienen de la principal o de ninguna.
                                        var datos = 0;

                                        $.ajax({
                                            type: "POST",
                                            url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/buscaCorrelativoRecep_DevolucionxPrestamo.ashx",
                                            async: false,
                                            data: { "fecha": w2ui['form'].record['anioPrestamo'], "Ncorrelativo": w2ui['form'].record['NDevolucion'], "CodMaterial": w2ui['grid'].records[IDTemp].codMaterial },
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

                                        //alert(datos + ' ' + Global_ClonData);

                                        // Esta siendo Ingresado, momentaneamente esta incompleto. (sucede cuando se ingresan nuevos valores y NO a sido guardado como devolucion.)
                                        if (datos == 3 && Global_ClonData == 0) {

                                            // ===========================

                                            // Graba Detalle de Movimiento
                                            // ===========================

                                            // General
                                            var CodigoMovimiento = 'T';
                                            var anioDevolucion = w2ui['form'].record['anioDonacion'];
                                            var CodCorrelativo = w2ui['form'].record['NDevolucion'];
                                            var cantidadMovimiento = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);
                                            var CodBodega = w2ui['form'].record['Nombre_Bodega'];
                                            var ItemArticulo = w2ui['grid'].records[IDTemp].item;
                                            var PrecioUni = w2ui['grid'].records[IDTemp].PrecioUnitario;

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

                                                $.ajax({
                                                    type: "POST",
                                                    url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveTempRecep_DevolucionxPrestamo.ashx",
                                                    async: false,
                                                    data: { "cont": cont, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioDevolucion, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadMovimiento, "CantidadMovimientoDetalle": local_Cantidad2, "CodigoMaterial": local_CodMaterial2, "NSerie": local_Serielote2, "fechaVencimiento": local_fechaVto2, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni },
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

                                            var recid = w2ui['grid'].records[IDTemp].recid;
                                            var CodMaterial = w2ui['grid'].records[IDTemp].codMaterial;
                                            var nombreMaterial = w2ui['grid'].records[IDTemp].nombreMaterial;
                                            var item = w2ui['grid'].records[IDTemp].item;
                                            var cantDespachado = w2ui['grid'].records[IDTemp].cntDespachado;
                                            var cantDevuelta = parseInt(w2ui['grid'].records[IDTemp].cntDevuelta);
                                            var cantDevolver = 0;
                                            var PrecioUitario = w2ui['grid'].records[IDTemp].PrecioUnitario;

                                            // Se calcula La nueva Cantidad
                                            for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                                cantDevolver = cantDevolver + parseInt(w2ui[subGridName].records[i].cantidad2);
                                            } // Fin for.

                                            // Se elimina la ultima linea en blanco.
                                            w2ui['grid'].remove(recid);

                                            w2ui['grid'].add({ recid: recid, codMaterial: CodMaterial, nombreMaterial: nombreMaterial, item: item, cntDespachado: cantDespachado, cntDevuelta: cantDevuelta, cntDevolver: cantDevolver, PrecioUnitario: PrecioUitario, "style": "background-color: #C2F5B4" });

                                            //----------------------------

                                        } // fin datos 2, Global_ClonData = 0;


                                        // Esta siendo Ingresado, momentaneamente esta incompleto.
                                        if (datos == 3 && Global_ClonData == 1) {

                                            // ===========================

                                            // Graba Detalle de Movimiento
                                            // ===========================

                                            // General
                                            var CodigoMovimiento = 'T';
                                            var anioDevolucion = w2ui['form'].record['anioDonacion'];
                                            var CodCorrelativo = w2ui['form'].record['NDevolucion'];
                                            var cantidadMovimiento = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);
                                            var CodBodega = w2ui['form'].record['Nombre_Bodega'];
                                            var ItemArticulo = w2ui['grid'].records[IDTemp].item;
                                            var PrecioUni = w2ui['grid'].records[IDTemp].PrecioUnitario;

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
                                                local_oldVal = w2ui[subGridName].records[i].oldVal;

                                                // valida que el dato q guarde en la temp no este duplicado en la principal.
                                                if (local_oldVal == 'x') {

                                                    // ingresar bodega con xxx significa que sera eliminado de la temp una vez iniciado el sabe global.
                                                    CodBodega = 'xxx';

                                                    $.ajax({
                                                        type: "POST",
                                                        url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveTempRecep_DevolucionxPrestamo.ashx",
                                                        async: false,
                                                        data: { "cont": cont, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioDevolucion, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadMovimiento, "CantidadMovimientoDetalle": local_Cantidad2, "CodigoMaterial": local_CodMaterial2, "NSerie": local_Serielote2, "fechaVencimiento": local_fechaVto2, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni },
                                                        dataType: "json",
                                                        success: function (response) {

                                                            if (response.item == "done") {

                                                            } // Fin Validador de codigo

                                                        } // Fin success
                                                    }); // fin ajax

                                                    cont = cont + 1;

                                                } else {

                                                    CodBodega = w2ui['form'].record['Nombre_Bodega'];

                                                    $.ajax({
                                                        type: "POST",
                                                        url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveTempRecep_DevolucionxPrestamo.ashx",
                                                        async: false,
                                                        data: { "cont": cont, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioDevolucion, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadMovimiento, "CantidadMovimientoDetalle": local_Cantidad2, "CodigoMaterial": local_CodMaterial2, "NSerie": local_Serielote2, "fechaVencimiento": local_fechaVto2, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni },
                                                        dataType: "json",
                                                        success: function (response) {

                                                            if (response.item == "done") {

                                                            } // Fin Validador de codigo

                                                        } // Fin success
                                                    }); // fin ajax

                                                    cont = cont + 1;

                                                } // fin if != x

                                            } // Fin for.

                                            //----------------------------
                                            // Cambia color asigna termino

                                            var recid = w2ui['grid'].records[IDTemp].recid;
                                            var CodMaterial = w2ui['grid'].records[IDTemp].codMaterial;
                                            var nombreMaterial = w2ui['grid'].records[IDTemp].nombreMaterial;
                                            var item = w2ui['grid'].records[IDTemp].item;
                                            var cantDespachado = w2ui['grid'].records[IDTemp].cntDespachado;
                                            var cantDevuelta = parseInt(w2ui['grid'].records[IDTemp].cntDevuelta);
                                            var cantDevolver = 0;
                                            var PrecioUitario = w2ui['grid'].records[IDTemp].PrecioUnitario;

                                            // Se calcula La nueva Cantidad
                                            for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                                cantDevolver = cantDevolver + parseInt(w2ui[subGridName].records[i].cantidad2);
                                            } // Fin for.

                                            // Se elimina la ultima linea en blanco.
                                            w2ui['grid'].remove(recid);

                                            w2ui['grid'].add({ recid: recid, codMaterial: CodMaterial, nombreMaterial: nombreMaterial, item: item, cntDespachado: cantDespachado, cntDevuelta: cantDevuelta, cntDevolver: cantDevolver, PrecioUnitario: PrecioUitario, "style": "background-color: #C2F5B4" });

                                            //----------------------------


                                        } // fin datos 3


                                        // Esta siendo Ingresado, momentaneamente esta incompleto. (sucede cuando se ingresan nuevos valores y NO a sido guardado como devolucion.)
                                        if (datos == 2 && Global_ClonData == 0) {

                                            // ===========================

                                            // Graba Detalle de Movimiento
                                            // ===========================

                                            // General
                                            var CodigoMovimiento = 'T';
                                            var anioDevolucion = w2ui['form'].record['anioDonacion'];
                                            var CodCorrelativo = w2ui['form'].record['NDevolucion'];
                                            var cantidadMovimiento = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);
                                            var CodBodega = w2ui['form'].record['Nombre_Bodega'];
                                            var ItemArticulo = w2ui['grid'].records[IDTemp].item;
                                            var PrecioUni = w2ui['grid'].records[IDTemp].PrecioUnitario;

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

                                                $.ajax({
                                                    type: "POST",
                                                    url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveTempRecep_DevolucionxPrestamo.ashx",
                                                    async: false,
                                                    data: { "cont": cont, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioDevolucion, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadMovimiento, "CantidadMovimientoDetalle": local_Cantidad2, "CodigoMaterial": local_CodMaterial2, "NSerie": local_Serielote2, "fechaVencimiento": local_fechaVto2, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni },
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

                                            var recid = w2ui['grid'].records[IDTemp].recid;
                                            var CodMaterial = w2ui['grid'].records[IDTemp].codMaterial;
                                            var nombreMaterial = w2ui['grid'].records[IDTemp].nombreMaterial;
                                            var item = w2ui['grid'].records[IDTemp].item;
                                            var cantDespachado = w2ui['grid'].records[IDTemp].cntDespachado;
                                            var cantDevuelta = parseInt(w2ui['grid'].records[IDTemp].cntDevuelta);
                                            var cantDevolver = 0;
                                            var PrecioUitario = w2ui['grid'].records[IDTemp].PrecioUnitario;

                                            // Se calcula La nueva Cantidad
                                            for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                                cantDevolver = cantDevolver + parseInt(w2ui[subGridName].records[i].cantidad2);
                                            } // Fin for.

                                            // Se elimina la ultima linea en blanco.
                                            w2ui['grid'].remove(recid);

                                            w2ui['grid'].add({ recid: recid, codMaterial: CodMaterial, nombreMaterial: nombreMaterial, item: item, cntDespachado: cantDespachado, cntDevuelta: cantDevuelta, cntDevolver: cantDevolver, PrecioUnitario: PrecioUitario, "style": "background-color: #C2F5B4" });

                                            //----------------------------

                                        } // fin datos 2, Global_ClonData = 0;


                                        // Esta siendo Ingresado, momentaneamente esta incompleto. (sucede cuando se ingresan nuevos valores y ha sido guardado previamente como devolucion sobreescribiendo la misma.)
                                        if (datos == 2 && Global_ClonData == 1) {

                                            // ===========================

                                            // Graba Detalle de Movimiento
                                            // ===========================

                                            // General
                                            var CodigoMovimiento = 'T';
                                            var anioDevolucion = w2ui['form'].record['anioDonacion'];
                                            var CodCorrelativo = w2ui['form'].record['NDevolucion'];
                                            var cantidadMovimiento = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);
                                            var CodBodega = w2ui['form'].record['Nombre_Bodega'];
                                            var ItemArticulo = w2ui['grid'].records[IDTemp].item;
                                            var PrecioUni = w2ui['grid'].records[IDTemp].PrecioUnitario;

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
                                                local_oldVal = w2ui[subGridName].records[i].oldVal;

                                                // valida que el dato q guarde en la temp no este duplicado en la principal.
                                                if (local_oldVal == 'x') {

                                                    // ingresar bodega con xxx significa que sera eliminado de la temp una vez iniciado el sabe global.
                                                    CodBodega = 'xxx';

                                                    $.ajax({
                                                        type: "POST",
                                                        url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveTempRecep_DevolucionxPrestamo.ashx",
                                                        async: false,
                                                        data: { "cont": cont, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioDevolucion, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadMovimiento, "CantidadMovimientoDetalle": local_Cantidad2, "CodigoMaterial": local_CodMaterial2, "NSerie": local_Serielote2, "fechaVencimiento": local_fechaVto2, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni },
                                                        dataType: "json",
                                                        success: function (response) {

                                                            if (response.item == "done") {

                                                            } // Fin Validador de codigo

                                                        } // Fin success
                                                    }); // fin ajax

                                                    cont = cont + 1;

                                                } else {

                                                    CodBodega = w2ui['form'].record['Nombre_Bodega'];

                                                    $.ajax({
                                                        type: "POST",
                                                        url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveTempRecep_DevolucionxPrestamo.ashx",
                                                        async: false,
                                                        data: { "cont": cont, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioDevolucion, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadMovimiento, "CantidadMovimientoDetalle": local_Cantidad2, "CodigoMaterial": local_CodMaterial2, "NSerie": local_Serielote2, "fechaVencimiento": local_fechaVto2, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni },
                                                        dataType: "json",
                                                        success: function (response) {

                                                            if (response.item == "done") {

                                                            } // Fin Validador de codigo

                                                        } // Fin success
                                                    }); // fin ajax

                                                    cont = cont + 1;

                                                } // fin if != x

                                            } // Fin for.

                                            //----------------------------
                                            // Cambia color asigna termino

                                            var recid = w2ui['grid'].records[IDTemp].recid;
                                            var CodMaterial = w2ui['grid'].records[IDTemp].codMaterial;
                                            var nombreMaterial = w2ui['grid'].records[IDTemp].nombreMaterial;
                                            var item = w2ui['grid'].records[IDTemp].item;
                                            var cantDespachado = w2ui['grid'].records[IDTemp].cntDespachado;
                                            var cantDevuelta = parseInt(w2ui['grid'].records[IDTemp].cntDevuelta);
                                            var cantDevolver = 0;
                                            var PrecioUitario = w2ui['grid'].records[IDTemp].PrecioUnitario;

                                            // Se calcula La nueva Cantidad
                                            for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                                cantDevolver = cantDevolver + parseInt(w2ui[subGridName].records[i].cantidad2);
                                            } // Fin for.

                                            // Se elimina la ultima linea en blanco.
                                            w2ui['grid'].remove(recid);

                                            w2ui['grid'].add({ recid: recid, codMaterial: CodMaterial, nombreMaterial: nombreMaterial, item: item, cntDespachado: cantDespachado, cntDevuelta: cantDevuelta, cntDevolver: cantDevolver, PrecioUnitario: PrecioUitario, "style": "background-color: #C2F5B4" });

                                            //----------------------------

                                        } // fin datos 2, Global_ClonData = 1;

                                        if (datos == 1) {

                                            // ============================
                                            // Obtiene NUEVO Correlativo
                                            // ============================

                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/getCorrelativoRecepDevoxPrestamo.ashx",
                                                async: false,
                                                data: { "fecha": w2ui['form'].record['anioDonacion'] },
                                                dataType: "json",
                                                success: function (response) {

                                                    if (response.item == "null") {

                                                        alert('¡Error, Correlativo no encontrado!')

                                                    } else {
                                                        w2ui['form'].record['NDevolucion'] = response.Correlativo;
                                                        w2ui['form'].record['observacion'] = '';
                                                        Global_ClonData = 1;
                                                        w2ui['form'].refresh();
                                                    } // Fin Validador de codigo

                                                } // Fin success
                                            }); // fin ajax


                                            // ===========================

                                            // Graba Detalle de Movimiento
                                            // ===========================

                                            // General
                                            var CodigoMovimiento = 'T';
                                            var anioDevolucion = w2ui['form'].record['anioDonacion'];
                                            var CodCorrelativo = w2ui['form'].record['NDevolucion'];
                                            var cantidadMovimiento = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);
                                            var CodBodega = w2ui['form'].record['Nombre_Bodega'];
                                            var ItemArticulo = w2ui['grid'].records[IDTemp].item;
                                            var PrecioUni = w2ui['grid'].records[IDTemp].PrecioUnitario;

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
                                                local_oldVal = w2ui[subGridName].records[i].oldVal;

                                                // valida que el dato q guarde en la temp no este duplicado en la principal.
                                                if (local_oldVal == 'x') {

                                                    // ingresar bodega con xxx significa que sera eliminado de la temp una vez iniciado el sabe global.
                                                    CodBodega = 'xxx';

                                                    $.ajax({
                                                        type: "POST",
                                                        url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveTempRecep_DevolucionxPrestamo.ashx",
                                                        async: false,
                                                        data: { "cont": cont, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioDevolucion, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadMovimiento, "CantidadMovimientoDetalle": local_Cantidad2, "CodigoMaterial": local_CodMaterial2, "NSerie": local_Serielote2, "fechaVencimiento": local_fechaVto2, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni },
                                                        dataType: "json",
                                                        success: function (response) {

                                                            if (response.item == "done") {

                                                            } // Fin Validador de codigo

                                                        } // Fin success
                                                    }); // fin ajax

                                                    cont = cont + 1;

                                                } else {

                                                    CodBodega = w2ui['form'].record['Nombre_Bodega'];

                                                    $.ajax({
                                                        type: "POST",
                                                        url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveTempRecep_DevolucionxPrestamo.ashx",
                                                        async: false,
                                                        data: { "cont": cont, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioDevolucion, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadMovimiento, "CantidadMovimientoDetalle": local_Cantidad2, "CodigoMaterial": local_CodMaterial2, "NSerie": local_Serielote2, "fechaVencimiento": local_fechaVto2, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni },
                                                        dataType: "json",
                                                        success: function (response) {

                                                            if (response.item == "done") {

                                                            } // Fin Validador de codigo

                                                        } // Fin success
                                                    }); // fin ajax

                                                    cont = cont + 1;

                                                } // fin if != x

                                            } // Fin for.

                                            //----------------------------
                                            // Cambia color asigna termino

                                            var recid = w2ui['grid'].records[IDTemp].recid;
                                            var CodMaterial = w2ui['grid'].records[IDTemp].codMaterial;
                                            var nombreMaterial = w2ui['grid'].records[IDTemp].nombreMaterial;
                                            var item = w2ui['grid'].records[IDTemp].item;
                                            var cantDespachado = w2ui['grid'].records[IDTemp].cntDespachado;
                                            var cantDevuelta = parseInt(w2ui['grid'].records[IDTemp].cntDevuelta);
                                            var cantDevolver = 0;
                                            var PrecioUitario = w2ui['grid'].records[IDTemp].PrecioUnitario;

                                            // Se calcula La nueva Cantidad
                                            for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                                cantDevolver = cantDevolver + parseInt(w2ui[subGridName].records[i].cantidad2);
                                            } // Fin for.

                                            // Se elimina la ultima linea en blanco.
                                            w2ui['grid'].remove(recid);

                                            w2ui['grid'].add({ recid: recid, codMaterial: CodMaterial, nombreMaterial: nombreMaterial, item: item, cntDespachado: cantDespachado, cntDevuelta: cantDevuelta, cntDevolver: cantDevolver, PrecioUnitario: PrecioUitario, "style": "background-color: #C2F5B4" });

                                            //----------------------------
                                        } // fin datos 1

                                    } // fin control 0.

                                } //fin Global_SaveSubGrid verifica si se puede o no grabar.

                            },
                            //===========================
                            //===========================

                            onChange: function (event) {

                                var local_CodMaterial;
                                var local_Cantidad;
                                var local_Serielote;
                                var local_fechaVto;
                                var CantDespachado = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);

                                /* Cantidad. */
                                if (event.column == 1) {

                                    if (event.value_new > CantDespachado) {

                                        alert('Cantidad Ingresada Supera a Cantidad Prestada');

                                        w2ui[subGridName].remove('');
                                        w2ui[subGridName].remove(event.recid);
                                        w2ui[subGridName].add({ recid: event.recid, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: '', oldVal: '' });

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
                                        w2ui[subGridName].add({ recid: event.recid, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto, oldVal: '' });

                                        var sumaCantidad = 0;

                                        for (var i = 0; i < w2ui[subGridName].records.length; i++) {
                                            sumaCantidad = sumaCantidad + parseInt(w2ui[subGridName].records[i].cantidad2);
                                        }

                                        // verifica que la cantidad ya ingresada no sea superior a la entrega.
                                        if (sumaCantidad <= CantDespachado) {

                                            // Se permite el Save.
                                            Global_SaveSubGrid = 1;
                                            //w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto });

                                        } else {
                                            Global_SaveSubGrid = 0;
                                            w2ui[subGridName].remove('');
                                            w2ui[subGridName].remove(event.recid);
                                            w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: '', loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto, oldVal: '' });
                                            alert('Cantidad Ingresada Supera a Cantidad Prestada');
                                        }

                                    } // fin if cantidad inicial no pruede ser mas grande que lo prestado.
                                }



                                // Serie o lote.
                                if (event.column == 2) {

                                    for (var i = 0; i < w2ui[subGridName].records.length; i++) {

                                        if (event.recid == w2ui[subGridName].records[i].recid) {

                                            local_CodMaterial = w2ui[subGridName].records[i].codMaterial2;
                                            local_Serielote = event.value_new.toUpperCase();

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

                                    if (local_fechaVto != '' && local_CodMaterial != '') {
                                        Global_SaveSubGrid = 1;
                                    } else {
                                        Global_SaveSubGrid = 0;
                                    }

                                    /*
                                    * eventos de cambio para grid principal
                                    */
                                    var codBodega = $('#Nombre_Bodega').val();
                                    var matCod = local_CodMaterial;
                                    var Nserie = event.value_new;
                                    var cambio = 0;

                                        $.ajax({
                                            type: "POST",
                                            url: "../../clases/persistencia/controladores/validaDetalleMaterial.ashx",
                                            async: false,
                                            data: { "cmd": 'validaNserie', "Bodega": codBodega, "codMaterial": matCod, "Nserie": Nserie.toUpperCase() },
                                            dataType: "json",
                                            success: function (response) {
                                                if (response.validate == "1") {
                                                    cambio = 1;
                                                    w2alert('Nº Serie no disponible');
                                                } else {
                                                    // Se puede agregar
                                                }
                                            },
                                            error: function (response) {
                                                alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                            }
                                        });

                                    w2ui[subGridName].remove('');
                                    w2ui[subGridName].remove(event.recid);

                                    if (cambio == 1) {
                                        w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: '', fechaVencimiento2: local_fechaVto, oldVal: '' });
                                    } else {
                                        w2ui[subGridName].add({ recid: event.recid, codMaterial2: local_CodMaterial, cantidad2: local_Cantidad, loteSerie2: local_Serielote, fechaVencimiento2: local_fechaVto, oldVal: '' });
                                    }

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

                            } // fin Onchange
                            //-------------------------

                        }); // fin abrir grid para detalle, cuando existen valores 2014
                        w2ui['subgrid-' + event.recid].resize();
                        w2ui.grid.resize();
                        // -----------------------------
                        // Maneja los datos del Sub Grid
                        // -----------------------------

                        // ===========================

                        // Obtiene Numero Correlativo
                        // ============================


                        if (w2ui['form'].record['NDevolucion']) {

                            // Verifica si los datos vienen de la principal o la temporal.
                            var datos = 0;

                            $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/buscaCorrelativoRecep_DevolucionxPrestamo.ashx",
                                async: false,
                                data: { "fecha": w2ui['form'].record['anioPrestamo'], "Ncorrelativo": w2ui['form'].record['NDevolucion'], "CodMaterial": w2ui['grid'].records[IDTemp].codMaterial },
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

                            // alert(" Datos " + datos);

                            // Tabla 1, busca los ya ingresados.
                            if (datos == 1) {

                                var validaCantidad = 0;
                                var largoDatos = 0;

                                $.ajax({
                                    type: "POST",
                                    url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/getHistorial_DetalleTabla1Recep_DevoxPrestamo.ashx",
                                    async: false,
                                    data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[IDTemp].codMaterial, "NCorrelativoPrestamo": w2ui['form'].record['NPrestamo'], "anioPrestamo": w2ui['form'].record['anioPrestamo'] },
                                    dataType: "json",
                                    success: function (response) {

                                        // Carga articulos Grid1
                                        w2ui[subGridName].clear();
                                        var recidID = 1;
                                        largoDatos = response.records.length + 1;

                                        // Transcribe los nuevos Records o articulos actualmente disponibles.
                                        for (var i = 0; i < response.records.length; i++) {

                                            var cantidad0 = parseInt(response.records[i].cantidad2);

                                            if (cantidad0 == 0) {

                                            } else {
                                                w2ui[subGridName].add({ recid: recidID, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2, oldVal: 'x' });
                                            }

                                            validaCantidad = validaCantidad + parseInt(response.records[i].cantidad2);
                                            recidID = recidID + 1;
                                        } // fin for

                                    } // Fin success
                                }); // fin ajax	

//                                var cantDespachada = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);

//                                if (validaCantidad < cantDespachada) {
//                                    w2ui[subGridName].add({ recid: largoDatos, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: '', oldVal: '' });
//                                }

                            } // fin datos 1


                            // Tabla 2, busca el valor tabla temp.
                            if (datos == 2) {

                                var validaCantidad = 0;
                                var largoDatos = 0;

                                $.ajax({
                                    type: "POST",
                                    url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/getHistorial_DetalleTempRecep_DevoxPrestamo.ashx",
                                    async: false,
                                    data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[IDTemp].codMaterial, "NCorrelativo": w2ui['form'].record['NDevolucion'] },
                                    dataType: "json",
                                    success: function (response) {

                                        // Carga articulos Grid1
                                        w2ui[subGridName].clear();
                                        var recidID = 1;
                                        largoDatos = response.records.length + 1;

                                        // Transcribe los nuevos Records o articulos actualmente disponibles.
                                        for (var i = 0; i < response.records.length; i++) {

                                            var antiguo = response.records[i].bodega;

                                            if (antiguo == 'xxx') {
                                                w2ui[subGridName].add({ recid: recidID, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2, oldVal: 'x' });
                                            } else {
                                                w2ui[subGridName].add({ recid: recidID, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2, oldVal: '' });
                                            }

                                            validaCantidad = validaCantidad + parseInt(response.records[i].cantidad2);
                                            recidID = recidID + 1;
                                        } // fin for

                                    } // Fin success
                                }); // fin ajax

//                                var cantDespachada = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);

//                                if (validaCantidad < cantDespachada) {
//                                    w2ui[subGridName].add({ recid: largoDatos, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: '', oldVal: '' });
//                                }

                            } // fin datos 2


                            // Tabla 3, no esta en ninguna tabla anterior. 
                            // (significa que la devolucion solicitada esta incompleta y esta siendo completada en este momento.)
                            if (datos == 3 && Global_ClonData == 1) {

                                var validaCantidad = 0;
                                var largoDatos = 0;

                                $.ajax({
                                    type: "POST",
                                    url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/getHistorial_DetalleTabla1Recep_DevoxPrestamo.ashx",
                                    async: false,
                                    data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": w2ui['grid'].records[IDTemp].codMaterial, "NCorrelativoPrestamo": w2ui['form'].record['NPrestamo'], "anioPrestamo": w2ui['form'].record['anioPrestamo'] },
                                    dataType: "json",
                                    success: function (response) {

                                        // Carga articulos Grid1
                                        w2ui[subGridName].clear();
                                        var recidID = 1;
                                        largoDatos = response.records.length + 1;

                                        // Transcribe los nuevos Records o articulos actualmente disponibles.
                                        for (var i = 0; i < response.records.length; i++) {

                                            var cantidad0 = parseInt(response.records[i].cantidad2);

                                            if (cantidad0 == 0) {

                                            } else {
                                                w2ui[subGridName].add({ recid: recidID, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2, oldVal: 'x' });
                                            }

                                            validaCantidad = validaCantidad + parseInt(response.records[i].cantidad2);
                                            recidID = recidID + 1;
                                        } // fin for

                                    } // Fin success
                                }); // fin ajax	

//                                var cantDespachada = parseInt(w2ui['grid'].records[IDTemp].cntDespachado);

//                                if (validaCantidad < cantDespachada) {
//                                    w2ui[subGridName].add({ recid: largoDatos, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: '', loteSerie2: '', fechaVencimiento2: '', oldVal: '' });
//                                }

                            } // fin datos 3.-

                        }

                        // -----------------------------
                        // Fin Maneja los datos del Sub Grid
                        // -----------------------------

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
					            ],
                            records: [
						            { recid: '', codMaterial2: '---', cantidad2: '0', loteSerie2: '---', fechaVencimiento2: '01/01/1900', oldVal: '' }
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

                //-------------------------
            },
            //-------------------------

            onDelete: function (event) {

                event.preventDefault();

                alert('NO puede elimiar los elementos transito!');

            },

            /* saveForm, saveGrid */
            onSave: function (event) {

                // valida que la descripcion este escrita.
                if (w2ui['form'].record['observacion']) {
                } else {
                    w2ui['form'].record['observacion'] = '';
                    w2ui['form'].refresh();
                }

                if (w2ui['form'].record['NDevolucion']) {

                    /*
                    //----------------------

                    // ===========================
         
                    // Graba Datos No ingresados a la Temp 
                    // (Los valores no ingresados comprenden a articulos que fueron prestados pero no devueltos.)
                    // ===========================

                    // General
                    var CodigoMovimiento = 'T'
                    var anioDevolucion = w2ui['form'].record['anioDonacion'];
                    var CodCorrelativo = w2ui['form'].record['NDevolucion'];
                    var CodBodega = w2ui['form'].record['Nombre_Bodega'];

                    for (var i = 0; i < w2ui['grid'].records.length; i++){ 
                    
                    var cantidadYaEntregado = parseInt(w2ui['grid'].records[i].cntDevuelta);                                        
                    var local_Cantidad = 0;
                    var local_CodMaterial = w2ui['grid'].records[i].codMaterial;
                    var local_Serielote = '---'
                    var local_fechaVto = '01/01/1900';
                    var ItemArticulo = w2ui['grid'].records[i].item;  
                    var PrecioUni = w2ui['grid'].records[i].PrecioUnitario;

                    $.ajax({
                    type: "POST",
                    url: "../../clases/persistencia/controladores/Despachos/PorDevolucionDePrestamo/saveTempRecep_PorDevolucionDePrestamo.ashx",
                    async: false,
                    data: {"cont": w2ui['grid'].records.length + i, "NumeroDonacionArticulo": CodigoMovimiento, "fecha": anioDevolucion, "NumeroCorrelativo": CodCorrelativo, "CantidadMovimientoGeneral": cantidadYaEntregado, "CantidadMovimientoDetalle": local_Cantidad, "CodigoMaterial": local_CodMaterial, "NSerie": local_Serielote, "fechaVencimiento": local_fechaVto, "CodBodega": CodBodega, "ItemArticulo": ItemArticulo, "PrecioUni": PrecioUni},
                    dataType: "json",
                    success: function (response) {

                    }// Fin success
                    });// fin ajax

                    }// Fin for.

                    //----------------------
                    */

                    // ================================

                    // Obtiene Numero Correlativo
                    // ================================

                    var grabar = 0;

                    $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/buscaCorrelativoRecep_DevolucionxPrestamo.ashx",
                        async: false,
                        data: { "fecha": w2ui['form'].record['anioPrestamo'], "Ncorrelativo": w2ui['form'].record['NDevolucion'], "CodMaterial": '' },
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
                        alert('Ud. NO puede grabar la Devolución por que esta ya EXISTE.')
                    } else {

                        // if valida que la bodega sea seleccionada.
                        if (w2ui['grid'].records.length > 0 && w2ui['form'].record['Nombre_Bodega']) {

                            w2ui['grid'].remove('');

                            $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveMovimiento_DevoluxPrestamo.ashx",
                                async: false,
                                data: { "CodigoTrasaccion": 'T', "fechaDonacion": w2ui['form'].record['anioDonacion'], "NcorrelativoNuevo": w2ui['form'].record['NDevolucion'], "fechaCompleta": w2ui['form'].record['fechaServidor'], "descripcion": w2ui['form'].record['observacion'], "CodigoTrasaccionAnterior_Prestamo": 'P', "fechaPrestamo": w2ui['form'].record['anioPrestamo'], "NcorrelativoAntiguo_Prestamo": w2ui['form'].record['NPrestamo'] },
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


                            //for (var i = 0; i <= w2ui['grid'].records.length - 1; i++){ 

                            $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/saveDetalleMovimiento_DevoluxPrestamo.ashx",
                                async: false,
                                data: { "fechaNueva": w2ui['form'].record['anioDonacion'], "NCorrelativoNuevo": w2ui['form'].record['NDevolucion'], "CodigoTrasaccionNuevo": 'T', "fechaAntiguo": w2ui['form'].record['anioPrestamo'], "NCorrelativoAntiguo": w2ui['form'].record['NPrestamo'] },
                                dataType: "json",
                                success: function (response) {

                                    if (response.item == "done") {

                                        alert('¡Registro completado con éxito!');

                                    } // Fin Validador de codigo


                                } // Fin success
                            }); // fin ajax

                        } else {
                            alert('¡Error, Faltan datos en el formulario!')
                        } // end if valida institucion bodega datos del form.

                    } // se recorre para saber que estan los datos guardados. se compara el cod en blanco comparado a la extencion de el grid.

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
		            '	<input type="button" value="Grabar" name="saveForm" style="border-color: tomato;">' +
                    '	<input type="button" value="Imprimir" name="imprimir">' +
                    '	<input type="button" value="ImprimirQR" name="imprimirQR">' +
                    '	<input type="button" value="Limpiar" name="limpiar">' +
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

                        // Identifica ID de busqueda.
                        if (w2ui['form'].record['NDevolucion']) {
                            NTransaccion = w2ui['form'].record['NDevolucion'];

                            if (w2ui['form'].record['fechaServidor']) {
                                fechaTransaccion = w2ui['form'].record['fechaServidor'];

                                if (w2ui['form'].record['Nombre_Bodega']) {
                                    bodega = $('#Nombre_Bodega option:selected').text();
                                    var div_bodega = bodega.split("-")
                                    bodega = div_bodega[1];

                                    if (w2ui['form'].record['anioDonacion']) {
                                        periodo = w2ui['form'].record['anioDonacion'];

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
                                            CantidadMovimiento = w2ui['grid'].records[i].cntDevuelta;
                                            PrecioUnitario = w2ui['grid'].records[i].PrecioUnitario;

                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                                                async: false,
                                                data: { "cmd": 'RPTInforme', "NTransaccion": NTransaccion, "periodo": periodo, "codTransaccion": 'T', "Linea": cont, "codMaterial": CodigoMaterial, "nombreMaterial": NombreMaterial, "CodItem": '', "cantMaterial": CantidadMovimiento, "precioMaterial": PrecioUnitario, "bodega": bodega, "descripcion": w2ui['form'].record['observacion'], "fechaMovimieno": fechaTransaccion, "proveedor": '', "ordenCompra": '0', "ordenCompraEstado": '', "numeroDocumento": '0', "Institucion": '', "centroCosto": '', "tipoDocumento": '', "tituloMenu": 'RECEPCIÓN POR DEVOLUCIÓN DE PRÉSTAMO', "descuento": '0', "impuesto": '0', "diferenciaPeso": '0', "usuario": '' },
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
                                            window.open('../../reportes/Recepciones/xDevolucionDePrestamo/RptVentana_xDevoluDePrestamo.aspx?CMVCodigo=' + NTransaccion + '&PERCodigo=' + periodo + '&TMVCodigo=' + 'T' + '&usuario=' + ReportUsuario);
                                        } else {
                                            alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                        }

                                    } else { alert("Faltan datos para imprimir."); } // Fin nombre anio donacion.
                                } else { alert("Faltan datos para imprimir."); } // Fin nombre Bodega.
                            } else { alert("Faltan datos para imprimir."); } // Fin fechaTransaccion.
                        } else { // alerta de mensaje por no ingresar nada.
                            alert("Primero ingrese o búsque una recepción");
                        }

                    }, // fin imprimir

                    /*===================================*/

			        "imprimirQR": function () {
			            
                        // Identifica ID de busqueda.
			            if (w2ui['form'].record['NDevolucion']) {
			                openPopup3();
			            } else { // alerta de mensaje por no ingresar nada.
			                w2alert("Primero identifique una devolución.");
			            }
/*
                        // Identifica ID de busqueda.
                        if (w2ui['form'].record['NPrestamo']){
                            window.open('../../generadorQR/Recepcion/DevolucionxPrestamo/QR_DevolucionxPrestamo.aspx?ID=' + w2ui['form'].record['NPrestamo'] + '&PerCodigo=' + w2ui['form'].record['anioDonacion'] + '&Bodega=' + w2ui['form'].record['Nombre_Bodega'] + '&fechaOperacion=' + w2ui['form'].record['fechaServidor']);                        
                        }else{ // alerta de mensaje por no ingresar nada.
                            alert("Primero Identifique el Préstamo");
                        }
*/

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
			        { name: 'NPrestamo', type: 'text', required: true, html: { caption: 'Numero Prestamo', attr: 'size="10" maxlength="10"' } },
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
                            w2ui['grid2'].url = '../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/cargaHistorialxFechaPrestamo.ashx?FechaPrestamo=' + w2ui['form3'].record.FPrestamo;
                            w2ui['grid2'].reload();
                        }
                        // Busqueda por numero de donación.
                        else if (w2ui['form3'].record.NPrestamo != ''){
                           w2ui['grid2'].url = '../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/cargaHistorialxNumeroPrestamo.ashx?NumeroPrestamo=' + w2ui['form3'].record.NPrestamo;
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

                    var anio = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO;

                    // Busca de acuerdo a si es nuevo o antiguo.
                    if(anio >= 2014){

                        var Ingresado = 0;

                      // Busca Bodega y Articulos Asociados.
                      $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/getArticlosAGrid1xPrestamo.ashx",
                        async: false,
                        data: { "NumeroPrestamo": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO, "FechaPrestamo": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO },
                        dataType: "json",
                        success: function (response) {
                            
                            // Forma Nueva, con FLD_CANTADEVOLVER = 0.
                            //------------------------------------------------
                            w2ui['grid'].clear();
                            var recidID = 1;
                            //var local_NDevoluvion;  1
                            for (var i = 0; i < response.records.length; i++){ 

                                // Cantidad a Devolver, se parsea a enteero.
                                var local_cntDespachado = parseInt(response.records[i].FLD_MOVCANTIDAD);
                                var local_CantDevolver = parseInt(response.records[i].FLD_CANTADEVOLVER);

                                // Bandera de control nos permite saber que el articulo fue ya guardado.
                                if(local_CantDevolver > 0){
                                    Ingresado = 1;
                                }

                                // recid, nombreMaterial, cntDespachado, cntDevolver, PrecioUnitario
                                w2ui['grid'].add({ recid: recidID,codMaterial: response.records[i].FLD_MATCODIGO, nombreMaterial: response.records[i].FLD_MATNOMBRE, item: response.records[i].FLD_ITECODIGO, cntDespachado: response.records[i].FLD_MOVCANTIDAD, cntDevuelta: local_CantDevolver, cntDevolver: (local_cntDespachado - local_CantDevolver), PrecioUnitario: response.records[i].FLD_PRECIOUNITARIO });
                                recidID = recidID + 1;
                                //local_NDevoluvion = response.records[i].FLD_CMVNUMERO;  2
                            }

                            // Guarda fechas actuales.
                            var fechaActual = w2ui['form'].record['fechaServidor'];
                            var anioActual = w2ui['form'].record['anioDonacion'];

                            // Identifica y despliega la Bodega Bodega records
                            w2ui['form'].record['Nombre_Bodega'] = response.records[0].FLD_BODCODIGO
                            
                            // Despliega la informacion del form Izquierda
                            w2ui['form'].record['fechaPrestamo'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PREFECHA;
                            w2ui['form'].record['anioPrestamo'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PERCODIGO;
                            //w2ui['form'].record['NDevolucion'] = local_NDevoluvion;  3
                            //w2ui['form'].record['observacion'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_PREDESCRIPCION;
                            
                            // Despliega la informacion del form Derecha
                            w2ui['form'].record['anioDonacion'] = anioActual;
                            w2ui['form'].record['NPrestamo'] = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1 ].FLD_CMVNUMERO;
                            w2ui['form'].record['fechaServidor'] = fechaActual;
                            w2ui['form'].refresh();
                            w2popup.close();

                         }// Fin success
                      });// fin ajax

                      // Devolucion ya guardada, se recuperan los datos.
                      if(Ingresado == 1){

                        $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/getDatos_EncabezadoHistotico_DevoxPrestamo.ashx",
                        async: false,
                        data: { "CodigoTrasaccionNuevo": 'T', "CodigoTrasaccionAntiguo": 'P', "fechaPrestamo": w2ui['form'].record['anioPrestamo'], "NcorrelativoAntiguo_Prestamo": w2ui['form'].record['NPrestamo']},
                        dataType: "json",
                        success: function (response) {

                            w2ui['form'].record['NDevolucion'] = response.NDevolucion;
                            w2ui['form'].record['observacion'] = response.Descripcion;
                            w2ui['form'].record['fechaServidor'] = response.fechaDev;
                            w2ui['form'].record['anioDonacion'] = response.anioDEV;
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
                                w2ui['grid'].add({ recid: recidID,codMaterial: response.records[i].FLD_MATCODIGO, nombreMaterial: response.records[i].FLD_MATNOMBRE, cntDespachado: response.records[i].FLD_MOVCANTIDAD, cntDevolver: response.records[i].CNT_DEVOLVER, PrecioUnitario: response.records[i].FLD_PRECIOUNITARIO });
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

// console.log(event)
    
    </script>

    <!-- Metodo para validacion de bodega de usuario -->
    <script type="text/javascript">

        function DevoluPrestamo_Fast() {

            /* limpia campos */
            w2ui['form'].record['NDevolucion'] = '';
            w2ui['form'].record['fechaPrestamo'] = '';
            w2ui['form'].record['observacion'] = '';
            w2ui['form'].refresh();

            var solicitudEntrante = w2ui['form'].record['NPrestamo'];
            var Ingresado = 0;

            // Busca Bodega y Articulos Asociados.
            $.ajax({
                type: "POST",
                url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/getArticlosAGrid1xPrestamo.ashx",
                async: false,
                data: { "NumeroPrestamo": w2ui['form'].record['NPrestamo'], "FechaPrestamo": w2ui['form'].record['anioPrestamo'] },
                dataType: "json",
                success: function (response) {

                    w2ui['grid'].clear();

                    var recidID = 1;

                    if (response.records[0].FLD_MOVCANTIDAD != '' && response.records[0].FLD_MOVCANTIDAD != '') {

                        for (var i = 0; i < response.records.length; i++) {

                            // Cantidad a Devolver, se parsea a enteero.
                            var local_cntDespachado = parseInt(response.records[i].FLD_MOVCANTIDAD);
                            var local_CantDevolver = parseInt(response.records[i].FLD_CANTADEVOLVER);

                            // Bandera de control nos permite saber que el articulo fue ya guardado.
                            if (local_CantDevolver > 0) {
                                Ingresado = 1;
                            }

                            w2ui['grid'].add({ recid: recidID, codMaterial: response.records[i].FLD_MATCODIGO, nombreMaterial: response.records[i].FLD_MATNOMBRE, item: response.records[i].FLD_ITECODIGO, cntDespachado: response.records[i].FLD_MOVCANTIDAD, cntDevuelta: local_CantDevolver, cntDevolver: (local_cntDespachado - local_CantDevolver), PrecioUnitario: response.records[i].FLD_PRECIOUNITARIO });
                            recidID = recidID + 1;
                        }

                        // Guarda fechas actuales.
                        var fechaActual = w2ui['form'].record['fechaServidor'];
                        var anioActual = w2ui['form'].record['anioDonacion'];

                        // Identifica y despliega la Bodega Bodega records
                        w2ui['form'].record['Nombre_Bodega'] = response.records[0].FLD_BODCODIGO

                        // Despliega la informacion del form Derecha
                        w2ui['form'].record['anioDonacion'] = anioActual;
                        w2ui['form'].record['fechaServidor'] = fechaActual;
                        w2ui['form'].refresh();
                        w2popup.close();

                    } else {
                        w2alert('No existe el prestamo Nº ' + solicitudEntrante);

                        // Pagina Principal
                        w2ui['grid'].clear();
                        w2ui['form'].reload();

                        // Form Buscar
                        w2ui['form3'].clear();
                        w2ui['grid2'].clear();

                    } // Fin if

                } // Fin success
            });  // fin ajax

                // Devolucion ya guardada, se recuperan los datos.
            if (Ingresado == 1) {

                $.ajax({
                    type: "POST",
                    url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/getDatos_EncabezadoHistotico_DevoxPrestamo.ashx",
                    async: false,
                    data: { "CodigoTrasaccionNuevo": 'T', "CodigoTrasaccionAntiguo": 'P', "fechaPrestamo": w2ui['form'].record['anioPrestamo'], "NcorrelativoAntiguo_Prestamo": w2ui['form'].record['NPrestamo'] },
                    dataType: "json",
                    success: function (response) {

                        w2ui['form'].record['NDevolucion'] = response.NDevolucion;
                        w2ui['form'].record['observacion'] = response.Descripcion;
                        w2ui['form'].record['fechaServidor'] = response.fechaDev;
                        w2ui['form'].record['anioDonacion'] = response.anioDEV;
                        w2ui['form'].record['fechaPrestamo'] = response.fechaPrestamo;
                        w2ui['form'].refresh();

                    } // Fin success
                });  // fin ajax                      

            } // fin carga datos ya ingresados.

        } // fin funcion

    </script>

    <!-- Metodo para cantidad de QR -->
    <script type="text/javascript">

        $(function () {
            // initialization in memory
            $().w2layout(config3.layout3);
            $().w2grid(config3.grid5);
            $().w2form(config3.form5);
        });

        // pop codigos QR
        function openPopup3() {
            w2popup.open({
                title: 'Cantidad Etiquetado',
                width: 850,
                height: 420,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                onOpen: function (event) {
                    event.onComplete = function () {

                        $('#w2ui-popup #main').w2render('layout3');
                        w2ui.layout3.content('left', w2ui.grid5);
                        w2ui.layout3.content('main', w2ui.form5);

                        w2ui['grid5'].clear();

                        setTimeout(function () {
                            $("#QRPeriodo").val($('#anioDonacion').val());
                            $("#QRNumero").val($('#NDevolucion').val());

                            // recorre el grid en busca de los materiales ingresados para preguntar cuantas equiquetas se imprimiran de cada uno.
                            for (var i = 0; i < w2ui['grid'].records.length; i++) {
                                var matCodigo = w2ui['grid'].records[i].codMaterial;
                                
                                $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Recepciones/DevolucionxPrestamo/getHistorial_DetalleTabla1Recep_DevoxPrestamo.ashx",
                                async: false,
                                data: { "codBodega": w2ui['form'].record['Nombre_Bodega'], "codMaterial": matCodigo, "NCorrelativoPrestamo": w2ui['form'].record['NPrestamo'], "anioPrestamo": w2ui['form'].record['anioPrestamo'] },
                                dataType: "json",
                                    success: function (response) {

                                        largoDatos = response.records.length + 1;

                                        // Transcribe los nuevos Records o articulos actualmente disponibles.
                                        for (var i = 0; i < response.records.length; i++) {
                                            w2ui['grid5'].add({ recid: w2ui['grid'].records.length, FLD_MATCODIGO: matCodigo, CANTIDAD_OFICIAL: response.records[i].cantidad2, FLD_NERIE: response.records[i].loteSerie2, FLD_CANTIDAD: 0 });
                                            //w2ui[subGridName].add({ recid: recidID, codMaterial2: w2ui['grid'].records[IDTemp].codMaterial, cantidad2: response.records[i].cantidad2, loteSerie2: response.records[i].loteSerie2, fechaVencimiento2: response.records[i].fechaVencimiento2, oldVal: 'x' });
                                        } // fin for

                                    } // Fin success
                                }); // fin ajax	
                                
                            }

                        }, 200);

                    };
                },
                onMax: function (event) {
                    event.onComplete = function () {
                        w2ui.layout.resize();
                    }
                },
                onMin: function (event) {
                    event.onComplete = function () {
                        w2ui.layout.resize();
                    }
                }
            });
        }

        var config3 = {
            layout3: {
                name: 'layout3',
                padding: 4,
                panels: [
			        { type: 'left', size: '58%', resizable: true, minSize: 200 },
			        { type: 'main', minSize: 200 }
		        ]
            },

            // GRID DEL POPUP
            grid5: {
                name: 'grid5',
                columns: [
			        { field: 'FLD_MATCODIGO', caption: 'Cod. Material', size: '20%', sortable: true },
                    { field: 'FLD_NERIE', caption: 'Serie o Lote', size: '20%', sortable: true },
                    { field: 'CANTIDAD_OFICIAL', caption: 'Cantidad', size: '20%', sortable: true },
			        { field: 'FLD_CANTIDAD', caption: 'Cant. Imprimir', size: '20%', sortable: true, resizable: true,
			            editable: { type: 'int', inTag: 'maxlength=4' }, attr: "align=center"
			        }
		        ]
            },

            // FORM DEL POPUP
            form5: {
                header: 'Información de Transacción',
                name: 'form5',
                fields: [
                    { name: 'QRNumero', type: 'text', html: { caption: 'Nº Operación', attr: 'size="14" maxlength="20" disabled '} },
                    { name: 'QRPeriodo', type: 'text', html: { caption: 'Periodo', attr: 'size="14" maxlength="20" disabled '} }
		        ],
                actions: {
                    Imprimir: function () {

                        // Guarda los datos para imprimir.
                        $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                            async: false,
                            data: { cmd: 'INSCantidadQR', GridQR: w2ui['grid5'].records, largoGrid: w2ui['grid5'].records.length, Periodo: w2ui['form'].record['anioDonacion'], NumMov: w2ui['form'].record['NDevolucion'], CodMov: 'T' },
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

                        // carga pestaña de codigos QR
                        window.open('../../generadorQR/Recepcion/DevolucionxPrestamo/QR_DevolucionxPrestamo.aspx?ID=' + w2ui['form'].record['NDevolucion'] + '&PerCodigo=' + w2ui['form'].record['anioDonacion'] + '&Bodega=' + w2ui['form'].record['Nombre_Bodega'] + '&fechaOperacion=' + w2ui['form'].record['fechaServidor']);

                        setTimeout(function () {
                            w2popup.close();
                        }, 200);
                    },
                    Limpiar: function () {
                        this.clear();
                        w2ui['grid5'].clear();
                    }
                }// Fin Acciones
            }// fin Form3, Grid2
        } // Fin Config.
    </script>

</asp:Content>

