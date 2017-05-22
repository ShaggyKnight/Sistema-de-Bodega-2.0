<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="Inventario_RealExistencia.aspx.vb" Inherits="Bodega_WebApp.Inventario_RealExistencia" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportInventarioREAL%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:8px; height: 278px; width: 57%; margin-left: 20%; margin-top: 10px;">
    </div>

    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247); width: 57%; margin-left: 20%;"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        /*  
          *Correcciones:
            Se disminuyo el tamaño del form para el ancho de los botones.
            Correccion de TimeOut.
        */

        $('#form').w2form({
            name: 'form',
            style: 'background-color: #f5f6f7;', //#777 #f5f6f7
            recid: 10,
            header: 'Inventario Real de Existencia',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 488px; margin-left: 26px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 192px;">' +

				    '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px; width: 98px;">Establecimiento</div>' +
		            '	<div class="w2ui-field w2ui-span5" >' +
		            '		<select name="Nombre_Establecimiento" type="text" style="width: 92%;" />' +
		            '	</div>' +

				    '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px;">Bodega</div>' +
		            '	<div class="w2ui-field w2ui-span5" >' +
		            '		<select id="Nombre_Bodega" name="Nombre_Bodega" type="text" />' +
		            '	</div>' +

                    '<div class="w2ui-label w2ui-span5" style="text-align: left; margin-left: 10px;">Ordenar Por:</div>' +
		            '	<div class="w2ui-field w2ui-span5" >' +
		            '		<select id="OrdenarX" name="OrdenarX" type="text" />' +
		            '	</div>' +

				    '<div class="w2ui-label w2ui-span7" style="margin-top: 3%; text-align: left; margin-left: 10px;">Cod. Familia del Prod.</div>' +
		            '	<div class="w2ui-field w2ui-span7" >' +
		            '		<select id="Nombre_Familia" name="Nombre_Familia" type="text" style=" margin-top: 6px;"/>' +
		            '	</div>' +

                    '<div class="w2ui-label w2ui-span7" style="margin-top: 3%; margin-left: -9px;">Incluir Stock = CERO </div>' +
                    '	<div class="w2ui-field w2ui-span6" >' +
		            '	    <input name="IncluirSN" class="form-control" type=checkbox style="margin-top: 10px; margin-left: 22px;"/>' +
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
                    { name: 'OrdenarX', type: 'list',
                        options: { items: [{ id: '1', text: 'Codigo' }, { id: '2', text: 'Nombre' }, ]
                        }
                    },
                    { name: 'Nombre_Familia', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/StockEmergencia/getListaFamliaProductos.ashx',
                            showNone: true
                        }
                    },
                    { name: 'IncluirSN', type: 'checkbox' },

	        ]

        });  // Fin Form1


        // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: 'border: 0px; background-color: #f5f6f7',
            formHTML:
            '</div>' +
		        '<div class="w2ui-buttons">' +
		        '	<input type="button" value="Imprimir" name="imprimir">' +
                '	<input type="button" value="Busca Materiales" onclick="openPopup2()" name="buscar2" style="width: 116px;">' +
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
                    var ordenar = w2ui['form'].record.OrdenarX;
                    var codFamilia = w2ui['form'].record.Nombre_Familia;
                    var isChecked = $("#IncluirSN")[0].checked;


                    if (establecimiento && bodega) {

                        if (codFamilia) {

                            /* Como se debe ordenar, si es 1. "Codigo" o 2. "Nombre"*/
                            if (ordenar) {

                                if (isChecked) {
                                    window.open('../../../reportes/Reportes/Inventario/InventarioRealExistencia/Report_InveRealExistencia.aspx?codigoBodega=' + bodega + '&familia=' + codFamilia + '&IncluirCero=' + 'S' + '&orden=' + ordenar + '&Establecimiento=' + establecimiento);
                                } else {
                                    window.open('../../../reportes/Reportes/Inventario/InventarioRealExistencia/Report_InveRealExistencia.aspx?codigoBodega=' + bodega + '&familia=' + codFamilia + '&IncluirCero=' + 'N' + '&orden=' + ordenar + '&Establecimiento=' + establecimiento);
                                }

                            } else {

                                // Si el Orden no esta especificado se tomo como valor Defecto el 1. "Codigo"
                                window.open('../../../reportes/Reportes/Inventario/InventarioRealExistencia/Report_InveRealExistencia.aspx?codigoBodega=' + bodega + '&familia=' + codFamilia + '&IncluirCero=' + 'N' + '&orden=' + ordenar + '&Establecimiento=' + establecimiento);

                            } // fin if Ordenar

                        } else {
                            alert("Debe Especificar la FAMILIA DE PRODUCTOS")
                        } // fin if Familia.

                    } else {
                        alert("Debe Especificar el ESTABLECIMIENTO  y  la BODEGA")
                    } // fin if establecimiento

                }
            }
        });


        //===========================================
        //              BUSCA MATERIALES
        //===========================================

        var config2 = {
            layout2: {
                name: 'layout2',
                padding: 4,
                panels: [
			        { type: 'left', size: '60%', resizable: true, minSize: 200 },
			        { type: 'main', minSize: 200 }
		        ]
            },

            // GRID DEL POPUP
            grid3: {
                name: 'grid3',
                columns: [
			        { field: 'FLD_MATCODIGO', caption: 'Mat. Codigo', size: '16%', sortable: true, searchable: true, editable: { type: 'text', inTag: 'maxlength=12'} },
                    { field: 'FLD_MATNOMBRE', caption: 'Nombre', size: '48%', sortable: true, searchable: true },
			        { field: 'FLD_EXIPRECIOUNITARIO', caption: 'Valor', size: '17%', sortable: true, searchable: true },
			        { field: 'FLD_ITECODIGO', caption: 'Item', size: '16%' }
		        ]
            },

            // FORM DEL POPUP
            form4: {
                header: 'Nombre Material',
                name: 'form4',
                fields: [
                    { name: 'NombreMat', type: 'text', required: true, html: { caption: 'Nombre', attr: 'size="20" maxlength="20"'} }
		        ],
                record: {
                    NombreMat: ''
                },
                actions: {
                    Buscar: function () {

                        var NombreMaterial = w2ui['form4'].record.NombreMat;
                        NombreMaterial = NombreMaterial.toUpperCase();

                        // Busqueda por fecha.
                        if (w2ui['form4'].record.NombreMat != '') {
                            w2ui['grid3'].url = '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/BuscarInfo_Materiales_RecepxDonacion.ashx?NombreMat=' + NombreMaterial;
                            w2ui['grid3'].reload();
                        } else { // alerta de mensaje por no ingresar nada.
                            alert("Ingrese Elemento de Busqueda");
                        }

                    },
                    Limpiar: function () {
                        this.clear();
                        w2ui['grid3'].clear();
                    }
                }// Fin Acciones
            }// fin Form3, Grid2
        } // Fin Config.

        $(function () {
            // initialization in memory
            $().w2layout(config2.layout2);
            $().w2grid(config2.grid3);
            $().w2form(config2.form4);
        });

        function openPopup2() {
            w2popup.open({
                title: 'Busqueda de Materiales',
                width: 850,
                height: 390,
                showMax: true,
                body: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
                onOpen: function (event) {
                    event.onComplete = function () {
                        $('#w2ui-popup #main').w2render('layout2');
                        w2ui.layout2.content('left', w2ui.grid3);
                        w2ui.layout2.content('main', w2ui.form4);
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

        // console.log(response);
 
    </script>
</asp:Content>
