<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="InventarioXItem.aspx.vb" Inherits="Bodega_WebApp.InventarioXItem" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportInventarioXItem%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:8px; height: 240px; width: 57%; margin-left: 20%;  margin-top: 10px;">
    </div>

    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247); width: 57%; margin-left: 20%;"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        /*  
          *Correcciones:
            Se disminuyo el tamaño del form para el ancho de los botones
            Correccion de TimeOut para los 2 modos, Resumen y Detalle.
        */

        $('#form').w2form({
            name: 'form',
            style: 'background-color: #f5f6f7;', //#777 #f5f6f7
            recid: 10,
            header: 'Inventario Actualizado X Item',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 488px; margin-left: 26px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 150px;">' +

				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; width: 20%">Establecimiento: </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Establecimiento" name="Nombre_Establecimiento" type="text" style="width: 80%;" />' +
		            '	</div>' +

				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Bodega: </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Bodega" name="Nombre_Bodega" type="text" style="width: 75%;"/>' +
		            '	</div>' +

                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 10px;">Item: </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Item" name="Nombre_Item" type="text" style="width: 70%;"/>' +
		            '	</div>' +

                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: -80px; margin-top: 10px; width: 20%">Modo Busqueda: </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Metodo" name="Nombre_Metodo" type="text" style="width: 60%;"/>' +
		            '	</div>' +

			       '</div>' +
		        '</div>' +

              '</div>'
                    ,
            fields: [

                    { name: 'Nombre_Establecimiento', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/StockEmergencia/getListaEstablecimientos_StockEmergencia.ashx',
                            showNone: true
                        }
                    },
                    { name: 'Nombre_Bodega', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getLista.ashx',
                            showNone: true
                        }
                    },
                    { name: 'Nombre_Item', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Reportes/Inventario/InventarioXItem/getListaItems_InvenXItem.ashx',
                            showNone: true
                        }
                    },
                    { name: 'Nombre_Metodo', type: 'list',
                        options: { items: [{ id: '1', text: 'Resúmen' }, { id: '0', text: 'Detalle'}]
                        }
                    }

	        ],
            // Cambio en el Form.
            onChange: function (event) {

            },
            //-------------------------
            onLoad: function (event) {

            }

        });    // Fin Form1


        // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: 'border: 0px; background-color: #f5f6f7',
            formHTML:
            '</div>' +
		        '<div class="w2ui-buttons">' +
		        '	<input type="button" value="Imprimir" name="imprimir">' +
            //'	<input type="button" id="id_BOT" value="Busca Proveedor" onclick="openPopup2()" name="buscar2" style="width: 116px;" disabled >' +
		        '	<input type="button" value="Limpiar" name="limpiar">' +

                '</div>' +
		        '</div>',
            actions: {

                "limpiar": function () {
                    w2ui['form'].clear();
                    w2ui['form'].refresh();
                },
                "imprimir": function () {

                    var establecimiento = w2ui['form'].record.Nombre_Establecimiento;
                    var bodega = w2ui['form'].record.Nombre_Bodega;
                    var item = w2ui['form'].record.Nombre_Item;
                    var metodo = w2ui['form'].record.Nombre_Metodo;

                    if (establecimiento && bodega) {

                        if (item && metodo) {

                            /* Controla el RPT que se va a Imprimir, Son diferentes*/
                            if (metodo == '1') {
                                window.open('../../../reportes/Reportes/Inventario/InventarioXItem/XResumen/Report_InveXItem2.aspx?Bodega=' + bodega + '&Item=' + item + '&Metodo=' + '1' + '&Establecimiento=' + establecimiento);
                            } else {
                                window.open('../../../reportes/Reportes/Inventario/InventarioXItem/XDetalle/Report_InveXItem.aspx?Bodega=' + bodega + '&Item=' + item + '&Metodo=' + '0' + '&Establecimiento=' + establecimiento);
                            }

                        } else {
                            alert("Error, Se debe definir la Item y el METODO de búsqueda ")
                        } // fin if, bodega && estado

                    } else {
                        alert("Error, Se debe definir el ESTABLECIMIENTO y la Bodega")
                    } // fin if, fechaInicio && fechaTermino
                }
            },
            onLoad: function (event) {

            }
        });
 
    </script>
</asp:Content>

