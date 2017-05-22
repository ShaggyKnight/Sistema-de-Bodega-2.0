<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="Stock_Min_Max.aspx.vb" Inherits="Bodega_WebApp.Stock_Min_Max" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportStockMinimoMaximo%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:8px; height: 190px; width: 57%; margin-left: 20%; top: 10px; margin-bottom:8px;">
    </div>

    <div id="form2" style="height: 52px; background-color: rgb(245, 246, 247); width: 57%; margin-left: 20%;"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        /*  
          *Correcciones:
            Se disminuyo el tamaño del form para el ancho de los botones
            Correccion de TimeOut.
        */

        var Global_ID = 0;

        $('#form').w2form({
            name: 'form',
            style: 'background-color: #f5f6f7;', //#777 #f5f6f7
            recid: 10,
            header: 'Stock Critico - Minimo - Maximo',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 488px; margin-left: 26px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 104px;">'+

				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 8px;">Bodega</div>'+
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Bodega" name="Nombre_Bodega" type="text" Style=" margin-left: 3%;"/>' +
		            '	</div>' + 

				    '<div class="w2ui-label w2ui-span4" style="margin-top: 4%; margin-left: -8px; width: 140px;">Cod. Familia del Prod.</div>'+
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Familia" name="Nombre_Familia" type="text" style="width: 26%; margin-top: 10px; margin-left: 14px;"/>' +
		            '	</div>' + 

			       '</div>'+
		        '</div>' +
              '</div>'
                    ,
            fields: [
                    { name: 'Nombre_Bodega', type: 'list',
                        options: {
                            url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getLista.ashx',
                            showNone: true
                        }
                    },
                    {name: 'Nombre_Familia', type: 'list',
                    options: {
                        url: '../../clases/persistencia/controladores/StockEmergencia/getListaFamliaProductos.ashx',
                        showNone: true
                    }
                    },

	        ],

        }); // Fin Form1


        // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: 'background-color: #f5f6f7',
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


                    // =============================
                    // Obtiene Numero Correlativo
                    // =============================
                    $.ajax({
                        type: "POST",
                        url: "../../clases/persistencia/controladores/Reportes/Stock_Min_Max/getCorrelativo_Stock_CriMinMax.ashx",
                        async: false,
                        data: { "tipoBusqueda": 'BuscaCorrelativo' },
                        dataType: "json",
                        success: function (response) {

                            if (response.item == "null") {

                                alert('¡Error, Correlativo no encontrado!')

                            } else {
                                    Global_ID = response.Correlativo;
                            } // Fin Validador de codigo

                        } // Fin success
                    }); // fin ajax

                    var id_Temp = Global_ID;
                    var bodega = w2ui['form'].record.Nombre_Bodega;
                    var codFamilia = w2ui['form'].record.Nombre_Familia;


                    if (bodega && codFamilia) {

                        if(codFamilia == "todas"){
//                        alert(Global_ID)
                            window.open('../../reportes/Reportes/Stock_Min_Max/Repot_StockCritico_MinMax.aspx?id_Temp=' + id_Temp + '&codigoBodega='+ bodega + '&familia=' + '%' );
                        }else{
//                        alert(Global_ID)
                            window.open('../../reportes/Reportes/Stock_Min_Max/Repot_StockCritico_MinMax.aspx?id_Temp=' + id_Temp + '&codigoBodega='+ bodega + '&familia=' + codFamilia );
                        }


                        setTimeout(function () {

                            // Elimina la busqueda establecida
                            $.ajax({
                                type: "POST",
                                url: "../../clases/persistencia/controladores/Reportes/Stock_Min_Max/getCorrelativo_Stock_CriMinMax.ashx",
                                async: false,
                                data: { "Global_ID": Global_ID, "tipoBusqueda": 'DeleteTEMP' },
                                dataType: "json",
                                success: function (response) {

                                } // Fin success

                            }); // fin ajax }

                        }, 10000);

                    } else {
                            alert("Debe Especificar la BODEGA  y  el CODIGO FAMILIA")
                    } // fin if bodega && codFamilia

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
