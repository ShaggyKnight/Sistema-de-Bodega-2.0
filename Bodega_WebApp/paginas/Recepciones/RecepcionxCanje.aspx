<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="RecepcionxCanje.aspx.vb" Inherits="Bodega_WebApp.RecepcionxCanje" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.recepCanje%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:3px; height: 240px; margin-bottom: 4px; margin-top: 2px;">
    </div>
    <div id="grid" style="width: 100%; height: 310px;">
    </div>
    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247);"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">
        /*
        *Solicitudes:
         
        *Correcciones:
            El lote y/o numero de serie que ingresan del detalle se cambiaron a mayuscula.
            Ahora el grid solo muestra algunas propiedades del grid.
            Nuevo nivel de detalle en TB_DETALLE_EXISTENCIAS

        *Pruebas:
            Carga: 
            Save: 
            Imprime: 
            QR: 

        */

        var Global_Periodo;
        var Global_NDespacho;

        $('#form').w2form({
            name: 'form',
            header: 'RECEPCIÓN POR CANJE',
            style: 'background-color: #f5f6f7;',
            recid: 10,
            url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 450px; margin-left: 20px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 165px;">'+
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 10px;">Fecha</div>' +
				    '<div class="w2ui-field w2ui-span4">'+
					    '<input name="fechaServidor" type="text" maxlength="100" style="width: 32%; margin-left: 2px; margin-top: 4px;" disabled/>' +
				    '</div>'+
                    '<div class="w2ui-label w2ui-span5" style="width:  104px; margin-left: 10px; margin-top: 12px; text-align: left;">N°Recepción</div>'+
				    '<div class="w2ui-field w2ui-span5">'+
				    '	<input name="NDonacion" type="text" maxlength="100" style="width: 34%; margin-left: -20px; margin-top: 4px;" disabled/>' +
				    '</div>'+
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 10px;">Descripción</div>'+
				    '<div class="w2ui-field w2ui-span4">'+
					    '<textarea name="descripcion" type="text" style="width: 86%; height: 56px; resize: none; margin-left: 2px; margin-top: 6px;"></textarea>' +
				    '</div>'+
			      '</div>'+
		        '</div>' +

		        '<div style="margin-left: 500px; width: 340px; width: 268px;">' +
			      '<div style="padding: 3px; font-weight: bold; color: #030303;">Info. Canje Generado</div>' +
			        '<div class="w2ui-group" style="height: 114px;">'+
				    '<div class="w2ui-label w2ui-span5" style="margin-top: 22px; text-align: left; margin-left: 12px;">Periodo</div>' +
				    '<div class="w2ui-field w2ui-span5">' +
					    '<input name="anioDonacion" type="text" maxlength="100" style="width: 70%; margin-top: 11px; margin-left: 15px;" disabled/>' +
				    '</div>' +
				    '<div class="w2ui-label w2ui-span5" style="margin-top: 16px; margin-left: -104px; width: 110px;">N°Canje Despacho</div>'+
				    '<div class="w2ui-field w2ui-span5">' +
				    '	<input name="NCanjeDespacho" type="text" maxlength="100" style="width: 70%; margin-left: 16px; margin-top: 8px;" disabled/>' +
				    '</div>' +
				    '<div class="w2ui-field w2ui-span5">' +
				    '	<input name="Nombre_Bodega" id="Nombre_Bodega" type="text" style="display:none;" disabled/>' +
				    '</div>' +
			      '</div>' +
		        '</div>' +
              '</div>'
                    ,
            fields: [
		            { name: 'fechaServidor', type: 'text' },
                    { name: 'NDonacion', type: 'text' },
                    { name: 'descripcion', type: 'text' },
                    { name: 'anioDonacion', type: 'text' },
                    { name: 'NCanjeDespacho', type: 'text' }
                    
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
                footer: true,
                toolbar: true,
                toolbarReload: true,
                toolbarColumns: true,
                toolbarDelete: false,
                toolbarSave: false,
                toolbarSearch: false
            },
            multiSearch: false,
            searches: [
			        { type: 'text', field: 'recid', caption: 'Codigo Material' },
		        ],
            columns: [
			        { field: 'codMaterial', caption: 'Cod. Material', size: '14%', attr: "align=center" },
			        { field: 'nombreMaterial', caption: 'Nombre Material', size: '27%' },
                    { field: 'itemPresupuestario', caption: 'Item Presupuestario', size: '21%' },
                    { field: 'cntDespachado', caption: 'Cnt. Despachada', size: '17%' },
			        { field: 'cntDevolver', caption: 'Cnt. Devuelta', size: '15%', sortable: true, resizable: true,
			            editable: { type: 'int', inTag: 'maxlength=4' }, attr: "align=center"
			        },
                    { field: 'PrecioUnitario', caption: 'Precio Unitario', size: '16%' },
                    { field: 'loteSerie', caption: 'Serie o Lote', size: '16%',
                        editable: { type: 'alphanumeric', inTag: 'maxlength=20' }, attr: "align=center"
                    },
                    { field: 'fechaVencimiento', caption: 'Fecha Vto.', size: '15%',
                        editable: { type: 'date', format: 'dd/mm/yy' }, attr: "align=center , onkeypress='return justFecha(event);'"
                    },
		        ],
            records: [
                { recid: '', codMaterial: '', nombreMaterial: '', itemPresupuestario: '', cntDespachado: '', cntDevolver: '', PrecioUnitario: '', loteSerie: '', fechaVencimiento: '' }
	            ],

            // Agrega un nuevo elemento.
            onAdd: function (event) {

            },


            // Cambio en la grilla.
            onChange: function (event) {

                // valida que la descripcion este escrita.
                if (w2ui['form'].record['descripcion']) {
                } else {
                    w2ui['form'].record['descripcion'] = '';
                    w2ui['form'].refresh();
                }


                // ----------------------------------------
                // Verifica si se modifico la columna Cantidad.
                if (event.column == 4) {

                    var local_Codigo;
                    var local_Nombre;
                    var local_Item;
                    var local_CantDespachada;
                    var local_CantDevuelta;
                    var local_PrecioUnitario;

                    if (event.recid == "") {
                        alert('¡Error, Primero debe realizar una búsqueda.')
                        //                        w2ui['grid'].select(event.recid);
                        //                        w2ui['grid'].delete(true);
                        w2ui['grid'].remove(event.recid);
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', itemPresupuestario: '', cntDespachado: '', cntDevolver: '', PrecioUnitario: '', loteSerie: '', fechaVencimiento: '' });
                    } else {

                        if (event.value_new >= 1) {

                            for (var i = 0; i < w2ui['grid'].records.length; i++) {

                                if (event.recid == w2ui['grid'].records[i].recid) {

                                    local_Codigo = w2ui['grid'].records[i].codMaterial;
                                    local_Nombre = w2ui['grid'].records[i].nombreMaterial;
                                    local_Item = w2ui['grid'].records[i].itemPresupuestario;
                                    local_CantDespachada = w2ui['grid'].records[i].cntDespachado;
                                    local_CantDevuelta = w2ui['grid'].records[i].cntDevolver;
                                    local_PrecioUnitario = w2ui['grid'].records[i].PrecioUnitario;

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


                            //elimina la anterior
                            w2ui['grid'].remove(event.recid);

                            if (parseInt(event.value_new) <= parseInt(local_CantDespachada)) {
                                // PARA FECHA DE VTO.
                                w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, itemPresupuestario: local_Item, cntDespachado: local_CantDespachada, cntDevolver: event.value_new, PrecioUnitario: local_PrecioUnitario, loteSerie: local_Serie, fechaVencimiento: local_Fecha });
                                //w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, itemPresupuestario: local_Item, cntDespachado: local_CantDespachada, cntDevolver: event.value_new, PrecioUnitario: local_PrecioUnitario });
                            } else {
                                alert('Error, Cantidad ingresada no puede superar a la Despachada.')
                                w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, itemPresupuestario: local_Item, cntDespachado: local_CantDespachada, cntDevolver: local_CantDevuelta, PrecioUnitario: local_PrecioUnitario, loteSerie: local_Serie, fechaVencimiento: local_Fecha });
                            }

                        } // Fin if valor nuevo mayor a 1

                        if (event.value_new == 0) {

                            alert('¡Error, la cantidad no puede ser 0.')

                            for (var i = 0; i < w2ui['grid'].records.length; i++) {

                                if (event.recid == w2ui['grid'].records[i].recid) {

                                    local_Codigo = w2ui['grid'].records[i].codMaterial;
                                    local_Nombre = w2ui['grid'].records[i].nombreMaterial;
                                    local_Item = w2ui['grid'].records[i].itemPresupuestario;
                                    local_CantDespachada = w2ui['grid'].records[i].cntDespachado;
                                    local_CantDevuelta = w2ui['grid'].records[i].cntDevolver;
                                    local_PrecioUnitario = w2ui['grid'].records[i].PrecioUnitario;

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

                            w2ui['grid'].remove(event.recid);

                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, itemPresupuestario: local_Item, cntDespachado: local_CantDespachada, cntDevolver: local_CantDevuelta, PrecioUnitario: local_PrecioUnitario, loteSerie: local_Serie, fechaVencimiento: local_Fecha });
                        } // Fin if valor = 0

                    } // Fin if entrada es vacia sin buscar previamente los Canjes.

                } // Fin if 4


                // ------------------------
                // Modificar Lote o Serie.
                if (event.column == 6) {

                    var local_Codigo;
                    var local_Nombre;
                    var local_Item;
                    var local_CantDespachada;
                    var local_CantDevuelta;
                    var local_PrecioUnitario;
                    var local_Fecha;

                    if (event.recid == "") {
                        alert('¡Error, Primero ingresar el codigo.')
                        w2ui['grid'].remove(event.recid);
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', itemPresupuestario: '', cntDespachado: '', cntDevolver: '', PrecioUnitario: '', loteSerie: '', fechaVencimiento: '' });
                    } else {

                        for (var i = 0; i < w2ui['grid'].records.length; i++) {
                            if (event.recid == w2ui['grid'].records[i].recid) {

                                local_Codigo = w2ui['grid'].records[i].codMaterial;
                                local_Nombre = w2ui['grid'].records[i].nombreMaterial;
                                local_Item = w2ui['grid'].records[i].itemPresupuestario;
                                local_CantDespachada = w2ui['grid'].records[i].cntDespachado;
                                local_CantDevuelta = w2ui['grid'].records[i].cntDevolver;
                                local_PrecioUnitario = w2ui['grid'].records[i].PrecioUnitario;

                                // para valiar que la fecha este ingresada.
                                if (w2ui['grid'].records[i].fechaVencimiento == "") {
                                    local_Fecha = "";
                                } else {
                                    local_Fecha = w2ui['grid'].records[i].fechaVencimiento;
                                }
                            }
                        }

                        var codBodega = $('#Nombre_Bodega').val();
                        var matCod = local_Codigo;
                        var Nserie = event.value_new;
                        var cambio = 0;

                        cambio = controlNserie(codBodega, matCod, Nserie)

                        w2ui['grid'].remove(event.recid);

                        // Para valiar que la fecha este ingresada.
                        if (local_Fecha == "" || local_Total == "") {
                            if (cambio == 1) {
                                //w2ui['grid'].set(event.recid, { loteSerie: '' });
                                //w2ui['grid'].set(event.recid, { changes: { loteSerie: '' } });
                                w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, itemPresupuestario: local_Item, cntDespachado: local_CantDespachada, cntDevolver: local_CantDevuelta, PrecioUnitario: local_PrecioUnitario, loteSerie: '', fechaVencimiento: local_Fecha });
                            } else {
                                w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, itemPresupuestario: local_Item, cntDespachado: local_CantDespachada, cntDevolver: local_CantDevuelta, PrecioUnitario: local_PrecioUnitario, loteSerie: event.value_new.toUpperCase(), fechaVencimiento: local_Fecha });
                            }
                        } else {
                            w2ui['grid'].remove(event.recid);
                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, itemPresupuestario: local_Item, cntDespachado: local_CantDespachada, cntDevolver: local_CantDevuelta, PrecioUnitario: local_PrecioUnitario, loteSerie: event.value_new.toUpperCase(), fechaVencimiento: local_Fecha });
                        }
                    }
                } // Fin editar columna 6

                // ------------------------
                // Modificar Fecha Vto.
                if (event.column == 7) {

                    var local_Codigo;
                    var local_Nombre;
                    var local_Item;
                    var local_CantDespachada;
                    var local_CantDevuelta;
                    var local_PrecioUnitario;
                    var local_Serie;

                    if (event.recid == "") {
                        alert('¡Error, Primero ingresar el codigo.')
                        w2ui['grid'].remove(event.recid);
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', itemPresupuestario: '', cntDespachado: '', cntDevolver: '', PrecioUnitario: '', loteSerie: '', fechaVencimiento: '' });
                    } else {

                        for (var i = 0; i < w2ui['grid'].records.length; i++) {
                            if (event.recid == w2ui['grid'].records[i].recid) {

                                local_Codigo = w2ui['grid'].records[i].codMaterial;
                                local_Nombre = w2ui['grid'].records[i].nombreMaterial;
                                local_Item = w2ui['grid'].records[i].itemPresupuestario;
                                local_CantDespachada = w2ui['grid'].records[i].cntDespachado;
                                local_CantDevuelta = w2ui['grid'].records[i].cntDevolver;
                                local_PrecioUnitario = w2ui['grid'].records[i].PrecioUnitario;

                                // para valiar que la serie o lote este ingresado.
                                if (w2ui['grid'].records[i].loteSerie == "") {
                                    local_Serie = "";
                                } else {
                                    local_Serie = w2ui['grid'].records[i].loteSerie;
                                }
                            }
                        }

                        w2ui['grid'].remove(event.recid);

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
                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, itemPresupuestario: local_Item, cntDespachado: local_CantDespachada, cntDevolver: local_CantDevuelta, PrecioUnitario: local_PrecioUnitario, loteSerie: local_Serie, fechaVencimiento: '' });
                        } else {
                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, itemPresupuestario: local_Item, cntDespachado: local_CantDespachada, cntDevolver: local_CantDevuelta, PrecioUnitario: local_PrecioUnitario, loteSerie: local_Serie, fechaVencimiento: event.value_new });
                        }
                    }
                } // Fin editar columna 7
            },
            //-------------------------

            onDelete: function (event) {

                event.preventDefault();

                alert('NO puede elimiar los elementos en canje!');

            },

            // ================================
            /* saveForm, saveGrid */
            onSave: function (event) {

                // valida que la descripcion este escrita.
                if (w2ui['form'].record['descripcion']) {
                } else {
                    w2ui['form'].record['descripcion'] = '';
                    w2ui['form'].refresh();
                }

                /* controla que la cantidad a devolver no sea 0 */
                var sumaDevo = 0;
                for (var i = 0; i <= w2ui['grid'].records.length - 1; i++) {
                    var CntDevolucion = parseInt(w2ui['grid'].records[i].cntDevolver);
                    sumaDevo = sumaDevo + CntDevolucion;
                }

                if (sumaDevo == 0) {
                    w2alert('Ingresar las cantidades a devolver de cada producto.')
                } else {

                    if (w2ui['form'].record['NDonacion']) {
                        w2alert('Ud. NO puede grabar el Canje por que este ya EXISTE.')
                    } else {

                        // Se elimina la celda de codigo '', para poder guardar los datos actuales.
                        w2ui['grid'].remove('');

                        // Verifica que el Grid Contenga Datos.
                        if (w2ui['grid'].records.length > 0) {

                            var local_Serie;
                            var local_Fecha;


                            for (var i = 0; i < w2ui['grid'].records.length; i++) {

                                // para valiar que la serie o lote este ingresado.
                                if (w2ui['grid'].records[i].loteSerie == "") {
                                    local_Serie = "";
                                } else {
                                    local_Serie = w2ui['grid'].records[i].loteSerie;
                                }

                                // para valiar que la fecha este ingresada.
                                if (w2ui['grid'].records[i].fechaVencimiento == "") {
                                    local_Fecha = "";
                                } else {
                                    local_Fecha = w2ui['grid'].records[i].fechaVencimiento;
                                }

                            } // Fin for

                            if (local_Fecha == "" || local_Serie == "") {
                                alert('¡Error, Faltan Numeros de Serie o Fecha de Vencimiento!')
                                w2ui['form'].record['NDonacion'] = '';
                                w2ui['form'].refresh();
                            } else {


                                // ====================
                                // Graba el Movimiento    metodo antiguo de save de v3.8 atras.
                                // ====================

                                // Modifica el valor Total
                                var total = 0;
                                for (var i = 0; i <= w2ui['grid'].records.length - 1; i++) {
                                    total = total + parseInt(w2ui['grid'].records[i].total);
                                }

                                $.ajax({
                                    url: '../../clases/persistencia/controladores/Recepciones/RecepcionxCanje/saveRecepCanje.ashx',
                                    type: 'POST',
                                    dataType: 'json',
                                    data: { cmd: 'create-records', dataFormRecepCanje: w2ui['form'].record, tipoMovimiento: 'I' },
                                    success: function (response) {

                                        if (response.status == 'error') {
                                            w2alert(response.message);
                                        } else {

                                            var NroOperacion = response.cmvNumero;

                                            w2ui['form'].record['NDonacion'] = NroOperacion;
                                            w2ui['form'].refresh();

                                            // ===========================
                                            // Graba Detalle de Movimiento
                                            // ===========================

                                            var local_AnioCanje;
                                            var local_NCorrelativo;
                                            var local_CantDespachada;
                                            var local_BodCodigo;
                                            var local_CodigoMaterial;
                                            var local_ItemCod;
                                            var local_PrecioUnitario;
                                            var local_NSerielote;
                                            var local_fechaVencimiento;
                                            var exitoDetalle = 0;

                                            // Busca Materiales sometidos a Cambio.
                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/Recepciones/RecepcionxCanje/getHistorialArticulosRecepcionxCanje.ashx",
                                                async: false,
                                                data: { "Periodo": Global_Periodo, "Numero": Global_NDespacho },
                                                dataType: "json",
                                                success: function (response) {

                                                    for (var i = 0; i < response.articulo.length; i++) {

                                                        var codResponse = response.articulo[i].FLD_MATCODIGO;
                                                        var codGrid1 = w2ui['grid'].records[i].codMaterial;

                                                        if (codResponse == codGrid1) {

                                                            local_AnioCanje = w2ui['form'].record['anioDonacion'];
                                                            local_NCorrelativo = w2ui['form'].record['NDonacion'];
                                                            local_CantDespachada = response.articulo[i].FLD_MOVCANTIDAD;
                                                            local_BodCodigo = response.articulo[i].FLD_BODCODIGO;
                                                            local_CodigoMaterial = response.articulo[i].FLD_MATCODIGO;
                                                            local_ItemCod = response.articulo[i].FLD_ITECODIGO;
                                                            local_PrecioUnitario = response.articulo[i].FLD_PRECIOUNITARIO;
                                                            local_NSerielote = w2ui['grid'].records[i].loteSerie;
                                                            local_fechaVencimiento = w2ui['grid'].records[i].fechaVencimiento;

                                                            // ---------------------------------
                                                            // Graba el detalle de los artuculos.
                                                            // ---------------------------------
                                                            $.ajax({
                                                                type: "POST",
                                                                url: "../../clases/persistencia/controladores/Recepciones/RecepcionxCanje/saveDetalleMovimientoRecepcionXCanje.ashx",
                                                                async: false,
                                                                data: { "codigo": 'I', "Periodo": Global_Periodo, "Numero": w2ui['form'].record['NDonacion'], "MovCantidad": w2ui['grid'].records[i].cntDevolver, "codBodega": local_BodCodigo, "matCodigo": local_CodigoMaterial, "itemCodigo": local_ItemCod, "precioUnitario": local_PrecioUnitario, "NSerie": local_NSerielote, "fechaVencimiento": local_fechaVencimiento },
                                                                dataType: "json",
                                                                success: function (response) {

                                                                    if (response.item == "done") {
                                                                        exitoDetalle = 1;
                                                                    } // Fin Validador de codigo

                                                                } // Fin success
                                                            }); // fin ajax 

                                                        } // fin if (codResponse == codGrid1)
                                                    } // fin for recorre articulos en busqueda de bodega etc.. 

                                                } // Fin success
                                            }); // fin ajax 

                                            if (exitoDetalle == 1) {
                                                w2alert('¡Se creo la recepción por Recepcion por Canje Nº ' + w2ui['form'].record['NDonacion'] + ' con éxito!');
                                            } else {
                                                alert("Ha ocurrio un error en el detalle de la operación, vuelva intentarlo mas tarde.");
                                            }

                                        } // fin error

                                    }, // Fin success
                                    error: function (response) {
                                        alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                    } // fin error
                                }); // fin ajax

                            } // fin if grid.

                        } // Fin verifica si existe correlativo.

                    } // Fin, NO puede grabar el Canje por que este ya EXISTE.

                } // Fin, Ingresar las cantidades a devolver de cada producto.

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
		            '	<input type="button" value="Buscar Canjes" onclick="openPopup()" name="buscar" style="width: 132px;">' +
		            '	<input type="button" value="Grabar" name="saveForm" style="border-color: tomato;">' +
                    '	<input type="button" value="Imprimir" name="imprimir">' +
		            '	<input type="button" value="Limpiar" name="limpiar">' +
                    '	<input type="button" value="ImprimirQR" name="imprimirQR">' +
                    '</div>' +
		            '</div>',
            actions: {

                "saveForm": function () {
                    w2ui['grid'].save();
                },

                "limpiar": function () {
                    // Pagina Principal
                    w2ui['grid'].clear();
                    w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', itemPresupuestario: '', cntDespachado: '', cntDevolver: '', PrecioUnitario: '', loteSerie: '', fechaVencimiento: '' });
                    w2ui['form'].reload();
                    // Form Buscar
                    w2ui['form3'].clear();
                    w2ui['grid2'].clear();
                },

                /*===================================*/

                "imprimir": function () {
                    var CanjeDespachado;
                    var fechaTransaccion;
                    var CanjeRetornado;
                    var periodo;
                    var descripcion;

                    var numeroLinea;
                    var codMaterial;
                    var nombreMaterial;
                    var cantMaterial;
                    var valorUnitario;

                    // Identifica ID de busqueda.
                    if (w2ui['form'].record['NCanjeDespacho']) { /* comprende al canje despachado */
                        CanjeDespachado = w2ui['form'].record['NCanjeDespacho'];

                        if (w2ui['form'].record['fechaServidor']) {
                            fechaTransaccion = w2ui['form'].record['fechaServidor'];

                            if (w2ui['form'].record['NDonacion']) { /* comprende a la transacción de devolución */
                                CanjeRetornado = w2ui['form'].record['NDonacion'];

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
                                        CantidadMovimiento = w2ui['grid'].records[i].cntDevolver;
                                        PrecioUnitario = w2ui['grid'].records[i].PrecioUnitario;

                                        $.ajax({
                                            type: "POST",
                                            url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                                            async: false,
                                            data: { "cmd": 'RPTInforme', "NTransaccion": CanjeRetornado, "periodo": periodo, "codTransaccion": 'I', "Linea": cont, "codMaterial": CodigoMaterial, "nombreMaterial": NombreMaterial, "CodItem": '', "cantMaterial": CantidadMovimiento, "precioMaterial": PrecioUnitario, "bodega": CanjeDespachado, "descripcion": w2ui['form'].record['descripcion'], "fechaMovimieno": fechaTransaccion, "proveedor": '', "ordenCompra": '0', "ordenCompraEstado": '', "numeroDocumento": '0', "Institucion": '', "centroCosto": '', "tipoDocumento": '', "tituloMenu": 'RECEPCIÓN POR CANJE', "descuento": '0', "impuesto": '0', "diferenciaPeso": '0', "usuario": '' },
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
                                        window.open('../../reportes/Recepciones/RecepXCanje/RptVentana_xCanje.aspx?CMVCodigo=' + CanjeRetornado + '&PERCodigo=' + periodo + '&TMVCodigo=' + 'I' + '&usuario=' + ReportUsuario);
                                    } else {
                                        alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                    }

                                } else { alert("Faltan datos para imprimir."); } // Fin nombre anio donacion.
                            } else { alert("Faltan datos para imprimir."); } // Fin nombre Bodega.
                        } else { alert("Faltan datos para imprimir."); } // Fin fechaTransaccion.
                    } else { // alerta de mensaje por no ingresar nada.
                        alert("Primero Identifique la Donación");
                    }

                }, // fin imprimir

                /*===================================*/

                "imprimirQR": function () {

                    // Identifica ID de busqueda.
                    if (w2ui['form'].record['NDonacion']) {
                        openPopup3();
                    } else { // alerta de mensaje por no ingresar nada.
                        w2alert("Primero identifique la recepción.");
                    }      
/*
                    // Identifica ID de busqueda.
                    if (w2ui['form'].record['NDonacion']) {

                        window.open('../../generadorQR/Recepcion/RecepcionXCanje/QR_RecepcionXCanje.aspx?TMVCodigo=' + 'I' + '&PerCodigo=' + w2ui['form'].record['anioDonacion'] + '&ID=' + w2ui['form'].record['NDonacion'] + '&fechaOperacion=' + w2ui['form'].record['fechaServidor']);

                    } else { // alerta de mensaje por no ingresar nada.
                        alert("Primero Identifique Recepción que desea Imprimir");
                    }
*/
                } // Fin Imprimir
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
                    header: 'Criterio de Búsqueda',
                    name: 'form3',
                    fields: [
			        { name: 'NDonacion', type: 'text', required: true, html: { caption: 'N° Canje', attr: 'size="10" maxlength="10"'} },
			        { name: 'FDonacion', type: 'list', required: true, html: { caption: 'Periodo' },
			            options: {
			                url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/BuscarDonaciones.ashx',
			                showNone: true
			            }
			        }
		        ],
                    record: {
                        NDonacion: ''
                    },
                    actions: {
                        Buscar: function () {

                            // Busqueda por fecha.
                            if (w2ui['form3'].record.FDonacion >= 0) {
                                w2ui['grid2'].url = '../../clases/persistencia/controladores/Recepciones/RecepcionxCanje/cargaHistorialxFechaRecepcionXCanje.ashx?FechaCanje=' + w2ui['form3'].record.FDonacion;
                                w2ui['grid2'].reload();
                            }
                            // Busqueda por numero de donación.
                            else if (w2ui['form3'].record.NDonacion != '') {
                                w2ui['grid2'].url = '../../clases/persistencia/controladores/Recepciones/RecepcionxCanje/cargaHistorialxNumeroRecepcionXCanje.ashx?NumeroCanje=' + w2ui['form3'].record.NDonacion;
                                w2ui['grid2'].reload();
                            }
                            // Alerta de mensaje por no ingresar nada.
                            else {
                                alert("Ingrese Elemento de Búsqueda");
                            }

                        },
                        Limpiar: function () {
                            this.clear();
                            w2ui['grid2'].clear();
                        },
                        Aceptar: function () {

                            // Limpia el grid para buscar nuevos datos.
                            w2ui['grid'].clear();

                            var local_Anio;
                            var local_NCanje;
                            var local_Fecha;
                            var local_Descripcion;
                            var local_total;
                            var local_Proveedor;

                            var local_Bodega;

                            var local_NRxCanje;
                            var fechaServi_siExistenDatos = w2ui['form'].record['fechaServidor'];

                            Global_Periodo = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO;
                            Global_NDespacho = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO;

                            // Busca Materiales sometidos a Cambio.
                            $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Recepciones/RecepcionxCanje/getHistorialArticulosRecepcionxCanje.ashx",
                                async: false,
                                data: { "Periodo": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO, "Numero": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO },
                                dataType: "json",
                                success: function (response) {

                                    // Se elimina la celda de codigo '', para transcribir los articulos de la busqueda.
                                    w2ui['grid'].remove('');

                                    var recidID = 1;

                                    for (var i = 0; i < response.articulo.length; i++) {

                                        $('#Nombre_Bodega').val(response.articulo[i].FLD_BODCODIGO);
                                        w2ui['grid'].add({ recid: recidID, codMaterial: response.articulo[i].FLD_MATCODIGO, nombreMaterial: response.articulo[i].FLD_MATNOMBRE, itemPresupuestario: response.articulo[i].FLD_ITEDENOMINACION, cntDespachado: response.articulo[i].FLD_MOVCANTIDAD, cntDevolver: response.articulo[i].CNT_DEVOLVER, PrecioUnitario: response.articulo[i].FLD_PRECIOUNITARIO, loteSerie: '', fechaVencimiento: '' });
                                        recidID = recidID + 1;
                                    }

                                } // Fin success
                            }); // fin ajax


                            //---------------------------------------
                            // Busca si el artculo ya fue ingresado.
                            $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Recepciones/RecepcionxCanje/CheckRecepcionxCanje.ashx",
                                async: false,
                                data: { "codigo": 'I', "Periodo": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO, "Numero": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO },
                                dataType: "json",
                                success: function (response) {

                                    var largo = response.check.length;

                                    if (largo >= 1) {
                                        // Regstrado.

                                        fechaServi_siExistenDatos = response.check[0].FechaVto;
                                        local_NRxCanje = response.check[0].RCanje;
                                        local_Descripcion = response.check[0].RDescripcion;
                                    } else {
                                        // NO Registrado.
                                        //fechaServi_siExistenDatos = '';
                                        local_NRxCanje = '';
                                        local_Descripcion = '';
                                    } // Fin Validador de codigo


                                    var local_ID;
                                    var local_Codigo;
                                    var local_Nombre;
                                    var local_Item;
                                    var local_CantDespachada;
                                    var local_CantDevuelta;
                                    var local_PrecioUnitario;


                                    for (var i = 0; i < response.check.length; i++) {

                                        for (var j = 0; j < w2ui['grid'].records.length; j++) {

                                            if (response.check[i].codigo == w2ui['grid'].records[j].codMaterial) {

                                                local_ID = w2ui['grid'].records[j].recid;
                                                local_Codigo = w2ui['grid'].records[j].codMaterial;
                                                local_Nombre = w2ui['grid'].records[j].nombreMaterial;
                                                local_Item = w2ui['grid'].records[j].itemPresupuestario;
                                                local_CantDespachada = w2ui['grid'].records[j].cntDespachado;
                                                local_CantDevuelta = w2ui['grid'].records[j].cntDevolver;
                                                local_PrecioUnitario = w2ui['grid'].records[j].PrecioUnitario;

                                                w2ui['grid'].remove(local_ID);

                                                w2ui['grid'].add({ recid: local_ID, codMaterial: local_Codigo, nombreMaterial: local_Nombre, itemPresupuestario: local_Item, cntDespachado: local_CantDespachada, cntDevolver: local_CantDevuelta, PrecioUnitario: local_PrecioUnitario, loteSerie: response.check[i].NSerie, fechaVencimiento: response.check[i].FechaVto });

                                            } // fin if
                                        } // fin for 1
                                    } // fin for 2

                                } // Fin success
                            }); // fin ajax
                            //---------------------------------------

                            local_NCanje = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO

                            w2ui['form'].record['NDonacion'] = local_NRxCanje;
                            w2ui['form'].record['fechaServidor'] = fechaServi_siExistenDatos;
                            w2ui['form'].record['anioDonacion'] = Global_Periodo;
                            w2ui['form'].record['descripcion'] = local_Descripcion;
                            w2ui['form'].record['NCanjeDespacho'] = local_NCanje;
                            w2ui['form'].refresh();

                            // Limpia el popUp
                            this.clear();
                            w2ui['grid2'].clear();
                            this.record['NDonacion'] = '';
                            this.refresh();
                            w2popup.close();

                        } // Fin boton Aceptar
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
		        title 	: 'Historial - Recepciones Por Canje',
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

        //================
        // Cantidad QR
        //================

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
                            $("#QRNumero").val($('#NCanjeDespacho').val());

                            // recorre el grid en busca de los materiales ingresados para preguntar cuantas equiquetas se imprimiran de cada uno.
                            for (var i = 0; i < w2ui['grid'].records.length; i++) {
                                w2ui['grid5'].add({ recid: w2ui['grid'].records[i].recid, FLD_MATCODIGO: w2ui['grid'].records[i].codMaterial, CANTIDAD_OFICIAL: w2ui['grid'].records[i].cntDespachado, FLD_NERIE: w2ui['grid'].records[i].loteSerie, FLD_CANTIDAD: 0 });
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
                            data: { cmd: 'INSCantidadQR', GridQR: w2ui['grid5'].records, largoGrid: w2ui['grid5'].records.length, Periodo: w2ui['form'].record['anioDonacion'], NumMov: w2ui['form'].record['NDonacion'], CodMov: 'I' },
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
                        window.open('../../generadorQR/Recepcion/RecepcionXCanje/QR_RecepcionXCanje.aspx?TMVCodigo=' + 'I' + '&PerCodigo=' + w2ui['form'].record['anioDonacion'] + '&ID=' + w2ui['form'].record['NDonacion'] + '&fechaOperacion=' + w2ui['form'].record['fechaServidor']);
                        //window.open('../../generadorQR/Recepcion/ProgramaxMinsal/QR_ProgramaxMinsal.aspx?TMVCodigo=' + 'I' + '&PerCodigo=' + w2ui['form'].record['anioDonacion'] + '&ID=' + w2ui['form'].record['NCanjeDespacho'] + '&fechaOperacion=' + w2ui['form'].record['fechaServidor'] + '&Proveedor=' + programaMinsal);

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

// console.log(w2ui['grid2'].getSelection());

    </script>

    <script type="text/javascript">

        function controlNserie(codBodega, matCod, Nserie) {

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
                        cambio = 0;
                    }
                },
                error: function (response) {
                    alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                }
            });

            if (cambio == 1) {
                return 1;
            } else {
                return 0;
            }
        }
    </script>

</asp:Content>
