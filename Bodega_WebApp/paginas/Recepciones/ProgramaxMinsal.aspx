<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="ProgramaxMinsal.aspx.vb" Inherits="Bodega_WebApp.ProgramaxMinsal" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.recepProgramaMinsal%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:3px; height: 250px; margin-bottom: 4px; margin-top: 2px;">
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
            Nuevo metodo de save en saveMinsal.ashx

         *Pruebas:
             Carga: 
             Save: 
             Imprime: 
             QR: 

         */

        // Variables Globales Grid
        var Id_Grid1;
        var Glo_Ndocumento = 1;

        $('#form').w2form({
            name: 'form',
            header: 'PROGRAMA MINSAL',
            style: 'background-color: #f5f6f7;',
            recid: 10,
            url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                        '<div style="width: 446px; margin-left: 20px; float: left;">' +
			                '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			                '<div class="w2ui-group" style="height: 175px;">'+
				                '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px;">Fecha</div>' +
				                '<div class="w2ui-field w2ui-span5">'+
					                '<input name="fechaServidor" type="text" maxlength="100" style="width: 40%" disabled/>' +
				                '</div>'+
				                '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px;">Bodega</div>'+
		                        '	<div class="w2ui-field w2ui-span5" >' +
		                        '		<select name="Nombre_Bodega" type="text" />' +
		                        '	</div>' +
				                '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px;">Programa Minsal</div>'+
		                        '	<div class="w2ui-field w2ui-span5" >' +
		                        '		<select name="Nombre_Programa" type="text" />' +
		                        '	</div>' +
				                '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px;">N° Documento</div>'+
				                '<div class="w2ui-field w2ui-span5">'+
				                '	<input name="NDocumento" type="text" maxlength="100" style="width: 32%;"/>' +
				                '</div>'+
                                '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px;">Valor</div>'+
				                '<div class="w2ui-field w2ui-span5">'+
				                '	<input name="valor" type="text" maxlength="100" style="width: 32%;" disabled/>' +
				                '</div>'+
			                '</div>'+
		           '</div>' +

		        '<div style="margin-left: 490px; width: 400px; width: 362px;">' +
			      '<div style="padding: 3px; font-weight: bold; color: #030303;">Recepción Generada</div>'+
			        '<div class="w2ui-group" style="height: 175px;">'+
				    '<div class="w2ui-label w2ui-span5" style="margin-top: 28px; text-align: left; margin-left: 12px;">Periodo</div>' +
				    '<div class="w2ui-field w2ui-span5">'+
					    '<input name="anioDonacion" type="text" maxlength="100" style="width: 70%; margin-top: 19px;" disabled/>' +
				    '</div>'+
				    '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 12px;">Número</div>'+
				    '<div class="w2ui-field w2ui-span5">'+
				    '	<input name="numero" type="text" maxlength="100" style="width: 70%" disabled/>' +
				    '</div>'+
				    '<div class="w2ui-label w2ui-span4">Descripción</div>'+
				    '<div class="w2ui-field w2ui-span4">'+
					    '<textarea name="descripcion" type="text" style="width: 88%; height: 64px; resize: none; margin-left: 20px;"></textarea>' +
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
		            { name: 'Nombre_Programa', type: 'list',
		                options: {
		                    url: '../../clases/persistencia/controladores/Recepciones/ProgramaxMinsal/getListaProgramas.ashx',
		                    showNone: true
		                }
		            },                    
                    { name: 'descripcion', type: 'text' },
                    { name: 'numero', type: 'text' },
                    { name: 'NDocumento', type: 'int' },
                    { name: 'valor', type: 'int' }
                    
	            ]
                ,
                onLoad: function(event) {
		            //console.log(event);
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
                toolbarDelete: true,
                toolbarSave: false,
                toolbarSearch: false
            },
            multiSearch: false,
            searches: [
			        { type: 'text', field: 'codMaterial', caption: 'Codigo Material' },
		        ],
            columns: [
			        { field: 'codMaterial', caption: 'Cod. Material', size: '16%', sortable: true, resizable: true,
			            editable: { type: 'text', inTag: 'maxlength=20' }, attr: "align=center"
			        },
			        { field: 'nombreMaterial', caption: 'Nombre Material', size: '40%' },
                    { field: 'item', caption: 'Item', size: '15%' },
			        { field: 'cantidad', caption: 'Cantidad', size: '15%', sortable: true, resizable: true,
			            editable: { type: 'int', inTag: 'maxlength=4' }, attr: "align=center"
			        },
                    { field: 'valor', caption: 'Valor', size: '20%' },
                    { field: 'total', caption: 'Total', size: '18%' },
                    { field: 'loteSerie', caption: 'Serie o Lote', size: '16%',
                        editable: { type: 'alphanumeric', inTag: 'maxlength=20' }, attr: "align=center"
                    },
                    { field: 'fechaVencimiento', caption: 'Fecha Vto.', size: '20%',
                        editable: { type: 'date', format: 'dd/mm/yy' }, attr: "align=center, onkeypress='return justFecha(event);'"
                    },
		        ],
            records: [
                { recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' }
	            ],

            // Agrega un nuevo elemento.
            onAdd: function (event) {

            },

            // Cambio en la grilla.
            onChange: function (event) {

                // Cambia el nuemero de documento.
                if (w2ui['form'].record['NDocumento'] > 1) {
                    Glo_Ndocumento = w2ui['form'].record['NDocumento'];
                } else {
                    Glo_Ndocumento = 1;
                    w2ui['form'].record['NDocumento'] = 1;
                    w2ui['form'].refresh();
                }

                // valida que la descripcion este escrita.
                if (w2ui['form'].record['descripcion']) {
                } else {
                    w2ui['form'].record['descripcion'] = '';
                    w2ui['form'].refresh();
                }

                // Verifica si modifica la columna ID.
                if (event.column == 0) {
                    if (event.value_original == "") {

                        $.ajax({
                            type: "POST",
                            url: "../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getBusquedaXCodigo.ashx",
                            async: false,
                            data: { "codigo": event.value_new.toUpperCase() },
                            dataType: "json",
                            success: function (response) {

                                if (response.item == "null") {

                                    alert('¡Error, código no valido!')
                                    w2ui['grid'].remove('');
                                    w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });

                                } else {

                                    var precio = parseInt(response.precio);
                                    var totalParcial = 1 * precio;

                                    // Ingresa un nuevo elemento al grid.
                                    Id_Grid1 = w2ui['grid'].records.length;
                                    w2ui['grid'].remove('');
                                    w2ui['grid'].add({ recid: Id_Grid1, codMaterial: event.value_new.toUpperCase(), nombreMaterial: response.descripcion, item: response.item, cantidad: 1, valor: response.precio, total: totalParcial, loteSerie: '', fechaVencimiento: '' });
                                    var totalNew = totalParcial.toString();

                                    var totalAcumulado = 0;
                                    if ($('#valor').val() == '') {
                                        totalAcumulado = totalNew;
                                    } else {
                                        for (var i = 0; i <= w2ui['grid'].records.length - 1; i++) {
                                            totalAcumulado = totalAcumulado + parseInt(w2ui['grid'].records[i].total);
                                        }
                                    }
                                    w2ui['form'].record['valor'] = totalAcumulado;
                                    w2ui['form'].refresh();
                                } // Fin Validador de codigo

                            } // fin success

                        }); // fin ajax

                    } // Fin iF ""
                } // Fin if 0



                // Verifica si se modifico la columna Valor.
                if (event.column == 3) {

                    var local_Codigo;
                    var local_Nombre;
                    var local_Item;
                    var local_Valor;
                    var local_Serie;
                    var local_Fecha;

                    if (event.recid == "") {
                        alert('¡Error, Primero ingresar el codigo.')
                        w2ui['grid'].remove(event.recid);
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });
                    } else {

                        if (event.value_new >= 1) {

                            for (var i = 0; i < w2ui['grid'].records.length; i++) {

                                if (event.recid == w2ui['grid'].records[i].recid) {

                                    local_Codigo = w2ui['grid'].records[i].codMaterial;
                                    local_nombre = w2ui['grid'].records[i].nombreMaterial;
                                    local_Item = w2ui['grid'].records[i].item;
                                    local_Valor = w2ui['grid'].records[i].valor;

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

                            w2ui['grid'].remove('');
                            w2ui['grid'].remove(event.recid);

                            // Para valiar que la fecha este ingresada.
                            if (local_Fecha == "" || local_Serie == "") {
                                w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cantidad: event.value_new, valor: local_Valor, total: total, loteSerie: local_Serie, fechaVencimiento: local_Fecha });
                            } else {
                                w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cantidad: event.value_new, valor: local_Valor, total: total, loteSerie: local_Serie, fechaVencimiento: local_Fecha });
                                w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });
                            }

                            // Modifica el valor Total
                            var finalGrid1 = w2ui['grid'].records.length - 1;
                            var totalCambio = 0;
                            for (var i = 0; i <= finalGrid1; i++) {
                                if (w2ui['grid'].records[i].recid == "") {
                                } else {
                                    totalCambio = totalCambio + parseInt(w2ui['grid'].records[i].total);
                                }
                            }

                            var totalNew = totalCambio.toString();
                            w2ui['form'].record['valor'] = totalNew;
                            w2ui['form'].refresh();

                        } // Fin if valor nuevo mayor a 1

                        if (event.value_new == 0) {

                            alert('¡Error, la cantidad no puede ser 0.')

                            for (var i = 0; i < w2ui['grid'].records.length; i++) {

                                if (event.recid == w2ui['grid'].records[i].recid) {

                                    local_Codigo = w2ui['grid'].records[i].codMaterial;
                                    local_nombre = w2ui['grid'].records[i].nombreMaterial;
                                    local_Item = w2ui['grid'].records[i].item;
                                    local_Valor = w2ui['grid'].records[i].valor;

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

                            w2ui['grid'].remove('');
                            w2ui['grid'].remove(event.recid);

                            var precio = parseInt(local_Valor)
                            var totalParcial = 1 * precio;
                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_nombre, item: local_Item, cantidad: 1, valor: local_Valor, total: total, loteSerie: local_Serie, fechaVencimiento: local_Fecha });
                            w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });
                        }

                    } // Fin if verificardor de recid vacio.
                } // Fin if 3

                // ------------------------
                // Modificar Lote o Serie.
                if (event.column == 6) {

                    var local_Codigo;
                    var local_Nombre;
                    var local_Item;
                    var local_Cantidad;
                    var local_Valor;
                    var local_Total;
                    var local_Fecha;

                    if (event.recid == "") {
                        alert('¡Error, Primero ingresar el codigo.')
                        w2ui['grid'].remove(event.recid);
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });
                    } else {

                        for (var i = 0; i < w2ui['grid'].records.length; i++) {
                            if (event.recid == w2ui['grid'].records[i].recid) {

                                local_Codigo = w2ui['grid'].records[i].codMaterial;
                                local_Nombre = w2ui['grid'].records[i].nombreMaterial;
                                local_Item = w2ui['grid'].records[i].item;
                                local_Cantidad = w2ui['grid'].records[i].cantidad;
                                local_Valor = w2ui['grid'].records[i].valor;

                                // para valiar que cantidad este ingresada.
                                if (w2ui['grid'].records[i].cantidad != 0) {
                                    local_Cantidad = w2ui['grid'].records[i].cantidad;
                                    local_Total = w2ui['grid'].records[i].total;
                                } else {
                                    local_Cantidad = 0;
                                    local_Total = "";
                                }

                                // para valiar que la fecha este ingresada.
                                if (w2ui['grid'].records[i].fechaVencimiento == "") {
                                    local_Fecha = "";
                                } else {
                                    local_Fecha = w2ui['grid'].records[i].fechaVencimiento;
                                }
                            }
                        }

                        /*
                        * eventos de cambio para grid principal
                        */
                        var codBodega = $('#Nombre_Bodega').val();
                        var matCod = local_Codigo;
                        var Nserie = event.value_new;
                        var cambio = 0;

                        setTimeout(function () {
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

                            w2ui['grid'].remove('');
                            w2ui['grid'].remove(event.recid);

                            // Para valiar que la fecha este ingresada.
                            if (local_Fecha == "" || local_Total == "") {
                                if (cambio == 1) {
                                    w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, item: local_Item, cantidad: local_Cantidad, valor: local_Valor, total: local_Total, loteSerie: '0', fechaVencimiento: local_Fecha });
                                } else {
                                    w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, item: local_Item, cantidad: local_Cantidad, valor: local_Valor, total: local_Total, loteSerie: event.value_new.toUpperCase(), fechaVencimiento: local_Fecha });
                                }
                            } else {
                                w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, item: local_Item, cantidad: local_Cantidad, valor: local_Valor, total: local_Total, loteSerie: event.value_new.toUpperCase(), fechaVencimiento: local_Fecha });
                                w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });
                            }

                        }, 80);

                    }
                } // Fin if 6
                // ------------------------

                // ------------------------
                // Modificar Fecha Vto.
                if (event.column == 7) {

                    var local_Codigo;
                    var local_Nombre;
                    var local_Item;
                    var local_Cantidad;
                    var local_Valor;
                    var local_Total;
                    var local_Serie;

                    if (event.recid == "") {
                        alert('¡Error, Primero ingresar el codigo.')
                        //w2ui['grid'].select(event.recid);
                        //w2ui['grid'].delete(true);
                        w2ui['grid'].remove(event.recid);
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });
                    } else {

                        for (var i = 0; i < w2ui['grid'].records.length; i++) {
                            if (event.recid == w2ui['grid'].records[i].recid) {

                                local_Codigo = w2ui['grid'].records[i].codMaterial;
                                local_Nombre = w2ui['grid'].records[i].nombreMaterial;
                                local_Item = w2ui['grid'].records[i].item;
                                local_Valor = w2ui['grid'].records[i].valor;


                                // para valiar que cantidad este ingresada.
                                if (w2ui['grid'].records[i].cantidad != 0) {
                                    local_Cantidad = w2ui['grid'].records[i].cantidad;
                                    local_Total = w2ui['grid'].records[i].total;
                                } else {
                                    local_Cantidad = 0;
                                    local_Total = "";
                                }

                                // para valiar que la serie o lote este ingresado.
                                if (w2ui['grid'].records[i].loteSerie == "") {
                                    local_Serie = "";
                                } else {
                                    local_Serie = w2ui['grid'].records[i].loteSerie;
                                }
                            }
                        }

                        w2ui['grid'].remove('');
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
                            w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, item: local_Item, cantidad: local_Cantidad, valor: local_Valor, total: local_Total, loteSerie: local_Serie, fechaVencimiento: '' });
                        } else {
                            // Para valiar que el total esta completo y agrega un articulo.
                            if (local_Total == "" || local_Serie == "") {
                                w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, item: local_Item, cantidad: local_Cantidad, valor: local_Valor, total: local_Total, loteSerie: local_Serie, fechaVencimiento: event.value_new });
                            } else {
                                w2ui['grid'].add({ recid: event.recid, codMaterial: local_Codigo, nombreMaterial: local_Nombre, item: local_Item, cantidad: local_Cantidad, valor: local_Valor, total: local_Total, loteSerie: local_Serie, fechaVencimiento: event.value_new });
                                w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });
                            }
                        } // fin validar fecha.
                    }
                } // Fin if 7
            },
            //-------------------------

            onDelete: function (event) {

                event.preventDefault();

                if (!w2ui['form'].record['numero']) {

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
                                NSerielote = w2ui['grid'].records[i].loteSerie;
                                fechaVencimiento = w2ui['grid'].records[i].fechaVencimiento;

                                cantData = cantData + 1;
                                w2ui['grid'].add({ recid: cantData, codMaterial: CodigoMaterial, nombreMaterial: NombreMaterial, item: ItemMaterial, cantidad: CantidadMovimiento, valor: PrecioUnitario, total: totalParcial, loteSerie: NSerielote, fechaVencimiento: fechaVencimiento });
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

                                CodigoMaterial = w2ui['grid'].records[z].codMaterial;
                                NombreMaterial = w2ui['grid'].records[z].nombreMaterial;
                                ItemMaterial = w2ui['grid'].records[z].item;
                                CantidadMovimiento = w2ui['grid'].records[z].cantidad;
                                PrecioUnitario = w2ui['grid'].records[z].valor;
                                totalParcial = w2ui['grid'].records[z].total;
                                NSerielote = w2ui['grid'].records[z].loteSerie;
                                fechaVencimiento = w2ui['grid'].records[z].fechaVencimiento;

                                newRecid = newRecid + 1;
                                w2ui['grid'].add({ recid: newRecid, codMaterial: CodigoMaterial, nombreMaterial: NombreMaterial, item: ItemMaterial, cantidad: CantidadMovimiento, valor: PrecioUnitario, total: totalParcial, loteSerie: NSerielote, fechaVencimiento: fechaVencimiento });
                                z = z + 1;
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

                    if (w2ui['grid'].records.length >= 1) {

                        controlVacio = w2ui['grid'].records.length - 1;

                        if ((w2ui['grid'].records[controlVacio].fechaVencimiento == "" || w2ui['grid'].records[controlVacio].loteSerie == "")) {

                        } else {
                            w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });
                        }
                    } else {
                        w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });
                    }

                } else {
                    alert('No se permite eliminar datos ya ingresados.')
                } // fin, verifica que no existan datos cargados.

            },

            // ================================
            /* saveForm, saveGrid */
            onSave: function (event) {

                // Cambia el nuemero de documento.
                if (w2ui['form'].record['NDocumento'] > 1) {
                    Glo_Ndocumento = w2ui['form'].record['NDocumento'];
                } else {
                    Glo_Ndocumento = 1;
                    w2ui['form'].record['NDocumento'] = 1;
                    w2ui['form'].refresh();
                }

                // valida que la descripcion este escrita.
                if (w2ui['form'].record['descripcion']) {
                } else {
                    w2ui['form'].record['descripcion'] = '';
                    w2ui['form'].refresh();
                }

                if (w2ui['form'].record['numero']) {
                    alert('Ud. NO puede grabar la Donación por que esta ya EXISTE.')
                } else {

                    // Se elimina la celda de codigo '', para poder guardar los datos actuales.
                    w2ui['grid'].remove('');

                    // Verifica que el Grid Contenga Datos.
                    if (w2ui['grid'].records.length > 0 && w2ui['form'].record['Nombre_Bodega'] && w2ui['form'].record['Nombre_Programa']) {


                        // ====================
                        // Graba el Movimiento    metodo antiguo de save de v3.8 atras.
                        // ====================

                        // Modifica el valor Total
                        var total = 0;
                        for (var i = 0; i <= w2ui['grid'].records.length - 1; i++) {
                            total = total + parseInt(w2ui['grid'].records[i].total);
                        }

                        $.ajax({
                            url: '../../clases/persistencia/controladores/Recepciones/ProgramaxMinsal/saveMinsal.ashx',
                            type: 'POST',
                            dataType: 'json',
                            data: { cmd: 'create-records', dataFormMinsal: w2ui['form'].record, tipoMovimiento: 'M', valor: total, numeroDoc: '1' },
                            success: function (response) {

                                if (response.status == 'error') {
                                    w2alert(response.message);
                                } else {

                                    var NroOperacion = response.cmvNumero;

                                    w2ui['form'].record['numero'] = NroOperacion;
                                    w2ui['form'].refresh();

                                    // ===========================
                                    // Graba Detalle de Movimiento
                                    // ===========================

                                    var cont = 1;
                                    var CodigoMaterial;
                                    var ItemMaterial;
                                    var CantidadMovimiento;
                                    var PrecioUnitario;
                                    var exitoDetalle = 0;

                                    for (var i = 0; i <= w2ui['grid'].records.length - 1; i++) {

                                        CodigoMaterial = w2ui['grid'].records[i].codMaterial;
                                        ItemMaterial = w2ui['grid'].records[i].item;
                                        CantidadMovimiento = w2ui['grid'].records[i].cantidad;
                                        PrecioUnitario = w2ui['grid'].records[i].valor;
                                        NSerielote = w2ui['grid'].records[i].loteSerie;
                                        fechaVencimiento = w2ui['grid'].records[i].fechaVencimiento;

                                        $.ajax({
                                            type: "POST",
                                            url: "../../clases/persistencia/controladores/Recepciones/ProgramaxMinsal/saveDetalleMovimientoMinsal.ashx",
                                            async: false,
                                            data: { "cont": cont, "programaMinsal": 'M', "fecha": w2ui['form'].record['anioDonacion'], "NumeroCorrelativo": NroOperacion, "CantidadMovimiento": CantidadMovimiento, "dbodega": w2ui['form'].record['Nombre_Bodega'], "CodigoMaterial": CodigoMaterial, "ItemMaterial": ItemMaterial, "null": 0, "null2": 0, "null3": 0, "PrecioUnitario": PrecioUnitario, "NSerie": NSerielote, "fechaVencimiento": fechaVencimiento },
                                            dataType: "json",
                                            success: function (response) {

                                                if (response.item == "done") {
                                                    exitoDetalle = 1;
                                                } // Fin Validador de codigo

                                            } // Fin success
                                        }); // fin ajax

                                        cont = cont + 1;

                                    } // Fin for.

                                    if (exitoDetalle == 1) {
                                        w2alert('¡Se creo la recepción MINSAL ' + w2ui['form'].record['numero'] + ' con éxito!');
                                    } else {
                                        alert("Ha ocurrio un error en el detalle de la operación, vuelva intentarlo mas tarde.");
                                    }

                                } // fin error

                            }, // Fin success
                            error: function (response) {
                                alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                            } // fin error
                        }); // fin ajax

                    } else {
                        alert('¡Error, Faltan datos en la tabla o en el formulario!');
                    } // fin if grid.

                } // Fin verifica si existe correlativo.


                // ===========================
            } // Fin Save.
            // ===========================
        });                                // Fin grid principal.


            // ----- BOTONES ----             BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: 'border: 0px; background-color: #f5f6f7',
            formHTML:
                '</div>' +
		            '<div class="w2ui-buttons">' +
		            '	<input type="button" value="Buscar Programas" onclick="openPopup()" name="buscar" style="width: 128px;">' +
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
                    w2ui['grid'].add({ recid: '', codMaterial: '', nombreMaterial: '', item: '', cantidad: '', valor: '', total: '', loteSerie: '', fechaVencimiento: '' });
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
                    if (w2ui['form'].record['numero']) {
                        NTransaccion = w2ui['form'].record['numero'];

                        if (w2ui['form'].record['fechaServidor']) {
                            fechaTransaccion = w2ui['form'].record['fechaServidor'];

                            if (w2ui['form'].record['Nombre_Bodega']) {
                                bodega = $('#Nombre_Bodega option:selected').text();
                                var div_bodega = bodega.split("-")
                                bodega = div_bodega[1];

                                if (w2ui['form'].record['Nombre_Programa']) {
                                    programaMinsal = $('#Nombre_Programa option:selected').text();
                                    var div_Minsal = programaMinsal.split("-")
                                    programaMinsal = div_Minsal[1];

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
                                            ItemMaterial = w2ui['grid'].records[i].item;
                                            CantidadMovimiento = w2ui['grid'].records[i].cantidad;
                                            PrecioUnitario = w2ui['grid'].records[i].valor;
                                            NSerielote = w2ui['grid'].records[i].loteSerie;
                                            fechaVencimiento = w2ui['grid'].records[i].fechaVencimiento;

                                            $.ajax({
                                                type: "POST",
                                                url: "../../clases/persistencia/controladores/GeneraInforme.ashx",
                                                async: false,
                                                data: { "cmd": 'RPTInforme', "NTransaccion": NTransaccion, "periodo": periodo, "codTransaccion": 'M', "Linea": cont, "codMaterial": CodigoMaterial, "nombreMaterial": NombreMaterial, "CodItem": '', "cantMaterial": CantidadMovimiento, "precioMaterial": PrecioUnitario, "bodega": bodega, "descripcion": w2ui['form'].record['descripcion'], "fechaMovimieno": fechaTransaccion, "proveedor": '', "ordenCompra": '0', "ordenCompraEstado": '', "numeroDocumento": '0', "Institucion": programaMinsal, "centroCosto": '', "tipoDocumento": '', "tituloMenu": 'RECEPCIÓN PROGRAMA MINSAL', "descuento": '0', "impuesto": '0', "diferenciaPeso": '0', "usuario": '' },
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
                                            window.open('../../reportes/Recepciones/ProgramaxMinsal/RptVentana_ProgramaMinsal.aspx?CMVCodigo=' + NTransaccion + '&PERCodigo=' + periodo + '&TMVCodigo=' + 'M' + '&usuario=' + ReportUsuario);
                                        } else {
                                            alert("Ha ocurrio un error en la operación vuelva intentarlo mas tarde.");
                                        }

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
                    if (w2ui['form'].record['numero']) {
                        openPopup3();
                    } else { // alerta de mensaje por no ingresar nada.
                        w2alert("Primero identifique el programa asociado.");
                    }                
                /*
                    // Identifica ID de busqueda.
                    if (w2ui['form'].record['numero']) {

                        var programaMinsal;

                        if (w2ui['form'].record['Nombre_Programa']) {
                            programaMinsal = $('#Nombre_Programa option:selected').text();
                            var div_Minsal = programaMinsal.split("-")
                            programaMinsal = div_Minsal[1];
                            window.open('../../generadorQR/Recepcion/ProgramaxMinsal/QR_ProgramaxMinsal.aspx?TMVCodigo=' + 'M' + '&PerCodigo=' + w2ui['form'].record['anioDonacion'] + '&ID=' + w2ui['form'].record['numero'] + '&fechaOperacion=' + w2ui['form'].record['fechaServidor'] + '&Proveedor=' + programaMinsal);
                        } else {
                            alert("Primero Identifique el Programa.");
                        }

                    } else { // alerta de mensaje por no ingresar nada.
                        alert("Primero Identifique la Donación");
                    }
                    */
                } // fin imprimir QR

            } // fin
        });                          // fin grid 2

		
        // --- POPUP BUSCAR ----              --- POPUP BUSCAR ----
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
			        { field: 'Fld_Minfecha', caption: 'Fecha', size: '19%', sortable: true, searchable: true },
			        { field: 'Fld_MinDescrip', caption: 'Descripción', size: '45%' }
		        ]
	        },

            // FORM DEL POPUP
	        form3: { 
		        header: 'Criterio de Búsqueda',
		        name: 'form3',
		        fields: [
			        { name: 'NDonacion', type: 'text', required: true, html: { caption: 'N° Programa', attr: 'size="10" maxlength="10"' } },
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
                            w2ui['grid2'].url = '../../clases/persistencia/controladores/Recepciones/ProgramaxMinsal/cargaHistorialxFechaPMinsal.ashx?FechaDonacion=' + w2ui['form3'].record.FDonacion;
                            w2ui['grid2'].reload();
                        }
                        // Busqueda por numero de donación.
                        else if (w2ui['form3'].record.NDonacion != ''){
                           w2ui['grid2'].url = '../../clases/persistencia/controladores/Recepciones/ProgramaxMinsal/cargaHistorialxNdonacionPMinsal.ashx?NumeroaDonacion=' + w2ui['form3'].record.NDonacion;
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
                        this.record['NDonacion'] = '';
                        this.refresh();
			        },
			        Aceptar: function () {

                      //------------------
                      //GUARDA VALORES
                      var nombrePrograma;
                      var fechaCompleta;
                      var anioDonacion;
                      var descripcion;
                      var numero;
                      var Ndocumento;
                      var valor;
                      //-------------------------------------------
                      // Busca valores asociados a lo seleccionado.
                      $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Recepciones/ProgramaxMinsal/cargaHistorialxNdonacionPMinsal.ashx",
                        async: false,
                        data: { "NumeroaDonacion": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO},
                        dataType: "json",
                        success: function (response) {

                            var fechaSelect = w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO

                            for (var i = 0; i < response.records.length; i++){ 
                                
                                if(response.records[i].FLD_PERCODIGO == fechaSelect){
                                // Traspado valores al principal.
                                nombrePrograma = response.records[i].Programa;
                                fechaCompleta = response.records[i].Fld_Minfecha;
                                anioDonacion = response.records[i].FLD_PERCODIGO;
                                descripcion = response.records[i].Fld_MinDescrip;
                                numero = response.records[i].FLD_CMVNUMERO;
                                Ndocumento = response.records[i].Fld_NroDoc;
                                valor = response.records[i].Fld_MovPrecio;

                                }// Fin if
                            }// Fin for
                         }// Fin success
                      });// fin ajax

                      //---------------------------------------
                      // Busca Bodega y Articulos Asociados.
                      $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getArticulosGrid2.ashx",
                        async: false,
                        data: { "codigo": "M", "Periodo": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_PERCODIGO, "Numero": w2ui['grid2'].records[w2ui['grid2'].getSelection() - 1].FLD_CMVNUMERO },
                        dataType: "json",
                        success: function (response) {

                            w2ui['grid'].clear();
                            var recidID = 1;

                            for (var i = 0; i < response.articulo.length; i++){ 
                                w2ui['grid'].add({ recid: recidID, codMaterial: response.articulo[i].recid, nombreMaterial: response.articulo[i].FLD_MATNOMBRE, item: response.articulo[i].FLD_ITECODIGO, cantidad: response.articulo[i].FLD_MOVCANTIDAD, valor: response.articulo[i].FLD_PRECIOUNITARIO, total: response.articulo[i].totalDonacion, loteSerie : response.articulo[i].Nserie, fechaVencimiento : response.articulo[i].fechaVto });
                                recidID = recidID + 1;
                            }

                            // Identifica la Bodega Bodega Nombre_Bodega
                            w2ui['form'].record['Nombre_Bodega'] = response.articulo[0].bodega;                    

                            // Traspado valores al principal.
                            w2ui['form'].record['Nombre_Programa'] = nombrePrograma;
                            w2ui['form'].record['fechaServidor'] = fechaCompleta;
                            w2ui['form'].record['anioDonacion'] = anioDonacion;
                            w2ui['form'].record['descripcion'] = descripcion;
                            w2ui['form'].record['numero'] = numero;
                            w2ui['form'].record['NDocumento'] = Ndocumento;
                            w2ui['form'].record['valor'] = valor;
                                
                            w2ui['form'].refresh();
                            w2popup.close();
                         }// Fin success
                      });// fin ajax

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
		        title 	: 'Historial Programa Minsal',
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
                            $("#QRNumero").val($('#numero').val());

                            // recorre el grid en busca de los materiales ingresados para preguntar cuantas equiquetas se imprimiran de cada uno.
                            for (var i = 0; i < w2ui['grid'].records.length; i++) {
                                w2ui['grid5'].add({ recid: w2ui['grid'].records[i].recid, FLD_MATCODIGO: w2ui['grid'].records[i].codMaterial, CANTIDAD_OFICIAL: w2ui['grid'].records[i].cantidad, FLD_NERIE: w2ui['grid'].records[i].loteSerie, FLD_CANTIDAD: 0 });
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
                            data: { cmd: 'INSCantidadQR', GridQR: w2ui['grid5'].records, largoGrid: w2ui['grid5'].records.length, Periodo: w2ui['form'].record['anioDonacion'], NumMov: w2ui['form'].record['numero'], CodMov: 'M' },
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

                        programaMinsal = $('#Nombre_Programa option:selected').text();
                        var div_Minsal = programaMinsal.split("-")
                        programaMinsal = div_Minsal[1];
                        // carga pestaña de codigos QR
                        window.open('../../generadorQR/Recepcion/ProgramaxMinsal/QR_ProgramaxMinsal.aspx?TMVCodigo=' + 'M' + '&PerCodigo=' + w2ui['form'].record['anioDonacion'] + '&ID=' + w2ui['form'].record['numero'] + '&fechaOperacion=' + w2ui['form'].record['fechaServidor'] + '&Proveedor=' + programaMinsal);

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

// console.log(event);

    </script>
</asp:Content>
