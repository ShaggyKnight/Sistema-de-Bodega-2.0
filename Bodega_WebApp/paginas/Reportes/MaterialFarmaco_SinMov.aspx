<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="MaterialFarmaco_SinMov.aspx.vb" Inherits="Bodega_WebApp.MaterialFarmaco_SinMov" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportMaterialesFarmacos%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div id="form" style="margin-bottom:1px; height: 240px; width: 60%; margin-left: 20%;">
    </div>
    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247);">
    </div>
    <div id="grid" style="width: 100%; height: 320px; margin-top: 2px;">
    </div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        $('#form').w2form({
            name: 'form',
            style: 'background-color: #f5f6f7;', //#777 #f5f6f7
            recid: 10,
            url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
            header: 'Material / Fármaco Sin Movimiento',
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
                    '   <input name="fechaServidor" type="text" maxlength="100" size="16" id="field_date" placeholder="dd/mm/yyyy" class="w2field" style="box-sizing: border-box;" onkeypress="return justFecha(event);">' +
		            '	</div>' +

				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Bodega: </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Bodega" name="Nombre_Bodega" type="text" />' +
		            '	</div>' +

                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 10px;">C/S Stock: </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Stock" name="Stock" type="text" style="width: 40%;"/>' +
		            '	</div>' +

			       '</div>' +
		        '</div>' +

              '</div>'
                    ,
            fields: [

		            { name: 'Fecha_Inicio', type: 'date' },
                    { name: 'fechaServidor', type: 'date' },

                    { name: 'Nombre_Bodega', type: 'list',
                        options: {
                            url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getLista.ashx',
                            showNone: true
                        }
                    },
                    { name: 'Stock', type: 'list',
                        options: { items: [{ id: 'P', text: 'Con Stock' }, { id: '0', text: 'Sin Stock' }, { id: 'T', text: 'TODOS'}]
                        }
                    }
	        ],
            // Cambio en el Form.
            onChange: function (event) {

            },
            //-------------------------
            onLoad: function (event) {

            }

        });   // Fin Form1

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
			        { field: 'codigo', caption: 'Codigo', size: '10%'},
			        { field: 'nombre', caption: 'Nombre', size: '20%' },
			        { field: 'stock', caption: 'Stock', size: '10%' },
                    { field: 'fecha', caption: 'Fecha', size: '10%', type: 'date' },
                    { field: 'NumUltimoMov', caption: 'N° Ultimo Mov.', size: '10%' },
                    { field: 'tipoMov', caption: 'Tipo Mov.', size: '10%' },
                    { field: 'tipoStock', caption: 'Tipo Stock', size: '10%' }
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

                    var fechaInicio = w2ui['form'].record.Fecha_Inicio;
                    var fechaTermino = w2ui['form'].record.fechaServidor;
                    var bodega = w2ui['form'].record.Nombre_Bodega;
                    var stock = w2ui['form'].record.Stock;

                    w2ui['grid'].url = '../../clases/persistencia/controladores/Reportes/MaterialFarmaco_SinMov/getListaArticulos_MatFar_SinMov.ashx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&Stock=' + stock;
                    w2ui['grid'].reload();
                },

                "imprimir": function () {

                    var fechaInicio = w2ui['form'].record.Fecha_Inicio;
                    var fechaTermino = w2ui['form'].record.fechaServidor;
                    var bodega = w2ui['form'].record.Nombre_Bodega;
                    var stock = w2ui['form'].record.Stock;

                    /* Controla que el tiempo sea mayor a 8 meses */
                    if (calcularFecha(fechaInicio, fechaTermino)) {

                        if (fechaInicio && fechaTermino) {

                            if (bodega && Stock) {

                                window.open('../../reportes/Reportes/MaterialFarmaco_SinMov/Report_MatFar_SinMov.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&Stock=' + stock);

                            } else {
                                alert("Error, Se debe definir la BODEGA y el STOCK ")
                            } // fin if, bodega && estado

                        } else {
                            alert("Error, Se deben definir el periodo de INICIO y TERMINO ")
                        } // fin if, fechaInicio && fechaTermino

                    } else {

                        w2popup.open({
                            title: 'Tiempo De Busqueda',
                            body: '<div class="w2ui-centered"><div><div><span class="glyphicons circle_exclamation_mark" style="color: goldenrod; zoom: 3; margin-bottom: 28px; margin-left: 22px;"/></div>En Intervalos muy cortos de tiempo existe mayor cantidad de materiales que no efectuaron transacciones. Se recomienda un año como minimo para realizar esta operación debido al prolongado tiempo de espera en la operación, ¿Desea realizar la busqueda de todas Maneras?</div></div>',
                            buttons: '<input type="button" value="Aceptar" onclick="cargarDatos(); w2popup.close();"> ' +
                            '<input type="button" value="Cancelar" onclick="w2popup.close();"> ',
                            modal: true
                        });

                    } // fin valida tiempo

                }, // fin Imprimir

                "limpiar": function () {
                    w2ui['form'].clear();
                    w2ui['form'].record['factorTransferencia'] = 30;
                    w2ui['form'].refresh();
                }
            },
            onLoad: function (event) {

            }
        });

        function cargarDatos() {
            alert("hola.")
        }

        function calcularFecha(fecha1, fecha2) {

            FechaActual = fecha2.split("/");
            var diaActual = FechaActual[0];
            var mmActual = FechaActual[1];
            var yyyyActual = FechaActual[2];

            FechaNac = fecha1.split("/");
            var diaCumple = FechaNac[0];
            var mmCumple = FechaNac[1];
            var yyyyCumple = FechaNac[2];

            //retiramos el primer cero de la izquierda
            if (mmCumple.substr(0, 1) == 0) {
                mmCumple = mmCumple.substring(1, 2);
            }
            //retiramos el primer cero de la izquierda
            if (diaCumple.substr(0, 1) == 0) {
                diaCumple = diaCumple.substring(1, 2);
            }
            var edad = yyyyActual - yyyyCumple;

            //validamos si el mes de cumpleaños es menor al actual
            //o si el mes de cumpleaños es igual al actual
            //y el dia actual es menor al del nacimiento
            //De ser asi, se resta un año
            if ((mmActual < mmCumple) || (mmActual == mmCumple && diaActual < diaCumple)) {
                edad--;
            }

            if (edad <= 0) {

                var mmInicio = parseInt(mmCumple)
                var mmTermino = parseInt(mmActual)

                if (mmInicio >= mmTermino) {

                    var mm = mmInicio - mmTermino;

                    var mm2 = 12 - mm;

                    if (mm2 >= 10) {
                        return true;
                    } else {
                        return false;
                    }

                } else {

                    var mm = mmTermino - mmInicio;

                    if (mm >= 10) {
                        return true;
                    } else {
                        return false;
                    }
                }

            } else {
                return true;
            }

        };

        function justFecha(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 46) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;

            return /\d/.test(String.fromCharCode(keynum));
        } 

    </script>
</asp:Content>
