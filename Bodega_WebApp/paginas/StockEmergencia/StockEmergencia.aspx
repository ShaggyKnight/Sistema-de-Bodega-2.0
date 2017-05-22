<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="StockEmergencia.aspx.vb" Inherits="Bodega_WebApp.StockEmergencia" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.stockEmergencia%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div id="grid" style="width: 100%; height: 15px;">
    </div>
    <div id="form" style="margin-bottom:8px; height: 310px; width: 60%; margin-left: 20%;">
    </div>
    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247); width: 60%; margin-left: 20%;"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        /*  
          *Correcciones:
            viendo reparacion de tabla temp, correccion de tabla temp.
            eliminado cod doc antiguo
            se da vuelta el buscador entre codigo y nombre
            se disminuyo el tamaño del form para el ancho de los botones
        */

        $('#form').w2form({
            name: 'form',
            style: 'background-color: #f5f6f7;', //#777 #f5f6f7
            recid: 10,
            header: 'Stock De Emergencia',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 488px; margin-left: 26px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 225px;">'+
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; width: 98px;">Establecimiento</div>' +
		            '	<div class="w2ui-field" >' +

		            '		<select name="Nombre_Establecimiento" type="text" style="width: 92%;" />' +
		            '	</div>' +
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Bodega</div>'+
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Bodega" name="Nombre_Bodega" type="text" />' +
		            '	</div>' + 

                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Ordenar Por:</div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="OrdenarX" name="OrdenarX" type="text" />' +
		            '	</div>' +
				    '<div class="w2ui-label w2ui-span7" style="text-align: left; margin-top: 4%; margin-left: 10px;">Cod. Familia del Prod.</div>' +

		            '	<div class="w2ui-field w2ui-span4" >' +
		            '		<select id="Nombre_Familia" name="Nombre_Familia" type="text" style="margin-top: 10px;"/>' +
		            '	</div>' + 

				    '<div class="w2ui-label w2ui-span6" style="margin-top: 4%;">Factor Transferencia</div>' +
				    '<div class="w2ui-field w2ui-span6">'+
					    '<input id="factorTransferencia" name="factorTransferencia" type="int" maxlength="10" style="width: 26%; margin-top: 10px;"/>' +
				    '</div>' +
			       '</div>'+
		        '</div>' +
              '</div>'
                    ,
            fields: [
		            {name: 'Nombre_Establecimiento', type: 'list',
		                options: {
		                    url: '../../clases/persistencia/controladores/StockEmergencia/getListaEstablecimientos_StockEmergencia.ashx',
		                    showNone: true
		                }
		            },
                    { name: 'Nombre_Bodega', type: 'list',
		                options: {
		                    url: '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getLista.ashx',
		                    showNone: true
		                }
		            },
                    { name: 'OrdenarX', type: 'list',
                        options: { items: [{ id: '1', text: 'Nombre' }, { id: '2', text: 'Codigo' } ] }
                    },
                    {name: 'Nombre_Familia', type: 'list',
                        options: {
                            url: '../../clases/persistencia/controladores/StockEmergencia/getListaFamliaProductos.ashx',
                            showNone: true
                        }
                    },
                    { name: 'factorTransferencia', type: 'int' }

	        ],
            record: {
                factorTransferencia: 30
            },
            postData: {
                codigoBodega: $("#Nombre_Bodega").val(),
                familia: $("#Nombre_Familia").val(),
                factorTrasf: $("#factorTransferencia").val(),
                orden: $("#OrdenarX").val()
            }
        }); // Fin Form1


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
                    w2ui['form'].record['factorTransferencia'] = 30;
                    w2ui['form'].refresh();
                },
                "imprimir": function () {

                    var establecimiento = w2ui['form'].record.Nombre_Establecimiento;
                    var bodega = w2ui['form'].record.Nombre_Bodega;
                    var ordenar = w2ui['form'].record.OrdenarX;
                    var codFamilia = w2ui['form'].record.Nombre_Familia;
                    var factorTrans = w2ui['form'].record.factorTransferencia;


                    if (factorTrans) {

                        if (establecimiento && bodega) {

                            // Si esta ordenar se ordena por la seleccion, de no estar se ordena por defeto (CODIGO)
                            if (codFamilia) {

                                /* Como se debe ordenar 1. "Codigo" 2. "Nombre"*/
                                if (ordenar) {

                                    // Si se busca por Codigo selección = 1.
                                    if (ordenar == "1") {

                                        window.open('../../reportes/StockEmergencia/Report_StockEmergencia.aspx?codigoBodega=' + bodega + '&familia=' + codFamilia + '&factorTras=' + factorTrans + '&orden=' + 1);

                                    } else {

                                        window.open('../../reportes/StockEmergencia/Report_StockEmergencia.aspx?codigoBodega=' + bodega + '&familia=' + codFamilia + '&factorTras=' + factorTrans + '&orden=' + 2);

                                    }// fin if ordenar = 1

                                } else {

                                    // Si el Orden no esta especificado se tomo como valor Defecto el 1. "Codigo"
                                    window.open('../../reportes/StockEmergencia/Report_StockEmergencia.aspx?codigoBodega=' + bodega + '&familia=' + codFamilia + '&factorTras=' + factorTrans + '&orden=' + 1);

                                } // fin if Ordenar

                            } else {
                                alert("Debe Especificar la FAMILIA DE PRODUCTOS")
                            } // fin if Familia.

                        } else {
                            alert("Debe Especificar el ESTABLECIMIENTO  y  la BODEGA")
                        } // fin if establecimiento

                    } else {
                        alert("Error, el Factor de Tranferencia debe estar entre 1 y 99 ")
                    } // fin if factor de transferencia

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
			        { field: 'FLD_MATCODIGO', caption: 'Mat. Codigo', size: '16%', sortable: true, searchable: true, editable: { type: 'text', inTag: 'maxlength=12' } },
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
                    { name: 'NombreMat', type: 'text', required: true, html: { caption: 'Nombre', attr: 'size="20" maxlength="20"' } }
		        ],
		        record: { 
			        NombreMat	: ''
		        },
		        actions: {
			        Buscar: function () { 

                        var NombreMaterial = w2ui['form4'].record.NombreMat;
                        NombreMaterial = NombreMaterial.toUpperCase();

                        // Busqueda por fecha.
                        if (w2ui['form4'].record.NombreMat != ''){
                            w2ui['grid3'].url = '../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/BuscarInfo_Materiales_RecepxDonacion.ashx?NombreMat=' + NombreMaterial;
                            w2ui['grid3'].reload();
                        }else{ // alerta de mensaje por no ingresar nada.
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
		        title 	: 'Busqueda de Materiales',
		        width	: 850,
		        height	: 390,
		        showMax : true,
		        body 	: '<div id="main" style="position: absolute; left: 5px; top: 5px; right: 5px; bottom: 5px;"></div>',
		        onOpen  : function (event) {
			        event.onComplete = function () {
				        $('#w2ui-popup #main').w2render('layout2');
                        w2ui.layout2.content('left', w2ui.grid3);
				        w2ui.layout2.content('main', w2ui.form4);
			        };
		        },
		        onMax : function (event) { 
			        event.onComplete = function () {
				        w2ui.layout2.resize();
			        }
		        },
		        onMin : function (event) {
			        event.onComplete = function () {
				        w2ui.layout2.resize();
			        }
		        }
	        });
        }

// console.log(response);
 
    </script>
</asp:Content>
