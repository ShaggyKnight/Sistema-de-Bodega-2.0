<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="InventarioXFamilia.aspx.vb" Inherits="Bodega_WebApp.InventarioXFamilia" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportInventarioXFamilia%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:8px; height: 250px; width: 57%; margin-left: 20%; margin-top: 10px;">
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
            url: '../../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
            header: 'Inventario X Familia',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 488px; margin-left: 26px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 170px;">' +

				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; width: 98px;">Establecimiento</div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select name="Nombre_Establecimiento" type="text" style="width: 92%;" />' +
		            '	</div>' +

				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Bodega</div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Bodega" name="Nombre_Bodega" type="text" />' +
		            '	</div>' +
				    '<div class="w2ui-label w2ui-span4" style="margin-top: 4%; margin-left: -6px; width: 140px;">Cod. Familia del Prod.</div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Familia" name="Nombre_Familia" type="text" style="width: 26%; margin-top: 10px; margin-left: 10px;"/>' +
		            '	</div>' +

                    //Fecha Termino
				    '<div class="w2ui-label w2ui-span5" style=" margin-top: 16px;">Fecha Termino: </div>' +
		            '	<div class="w2ui-field w2ui-span6" >' +
                    '   <input name="fechaServidor" style="margin-top: 5px;" type="text" maxlength="100" size="16" id="field_date" placeholder="dd/mm/yyyy" class="w2field" style="box-sizing: border-box;" onkeypress="return justFecha(event);">' +
		            '	</div>' +
			       '</div>' +
		        '</div>' +

              '</div>'
                    ,
            fields: [

		            {name: 'Nombre_Establecimiento', type: 'list',
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

                    {name: 'Nombre_Familia', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Reportes/Inventario/InventarioXFamilia/getListaFamilia_InveXFami.ashx',
                            showNone: true
                        }
                    },
                    { name: 'fechaServidor', type: 'date' },

	        ]
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
                    w2ui['form'].refresh();
                },
                "imprimir": function () {
                    var establecimiento = w2ui['form'].record.Nombre_Establecimiento;
                    var bodega = w2ui['form'].record.Nombre_Bodega;
                    var codFamilia = w2ui['form'].record.Nombre_Familia;
                    var fechaActual = w2ui['form'].record.fechaServidor;
                    fechaActual.toString();


                    if (establecimiento && bodega) {

                        // Si esta ordenar se ordena por la seleccion, de no estar se ordena por defeto (CODIGO)
                        if (codFamilia && fechaActual) {

                            window.open('../../../reportes/Reportes/Inventario/InventarioXFamilia/Report_InveXFamilia.aspx?CodBodega=' + bodega + '&CodFamilia=' + codFamilia + '&FechaActual=' + fechaActual + '&Establecimiento=' + establecimiento);

                        } else {
                            alert("Debe Especificar la FAMILIA DE PRODUCTOS y FECHA")
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

        function justFecha(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 46) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;

            return /\d/.test(String.fromCharCode(keynum));
        } 

        // console.log(response);
 
    </script>
</asp:Content>