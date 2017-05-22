<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="EstadosOrdenCompra.aspx.vb" Inherits="Bodega_WebApp.EstadosOrdenCompra" %>


<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportOrdenesCompra%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div id="form" style="margin-bottom:8px; height: 330px; width: 57%; margin-left: 20%; margin-top: 10px;">
    </div>
    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247); width: 57%; margin-left: 20%;"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        /*  
        *Correcciones:
            Se disminuyo el tamaño del form para el ancho de los botones
            Correccion de TimeOut
        */

        $('#form').w2form({
            name: 'form',
            style: 'background-color: #f5f6f7;', //#777 #f5f6f7
            recid: 10,
            header: 'Reporte de Ordenes de Compras',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 488px; margin-left: 26px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 240px;">' +

            // Fecha Inicio
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; width: 98px;">Fecha Inicio: </div>' +
		            '	<div class="w2ui-field" >' +
            //   '		<input name="Fecha_Inicio" type="date" style="width: 38%;" />' +
                    '   <input name="Fecha_Inicio" type="text" maxlength="100" size="16" id="field_date" placeholder="dd/mm/yyyy" class="w2field" style="box-sizing: border-box;" onkeypress="return justFecha(event);">' +
		            '	</div>' +

            //Fecha Termino
				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; width: 98px;">Fecha Termino: </div>' +
		            '	<div class="w2ui-field" >' +
            //  '		<input name="Fecha_Termino" type="date" style="width: 38%;" />' +
                    '   <input name="Fecha_Termino" type="text" maxlength="100" size="16" id="field_date" placeholder="dd/mm/yyyy" class="w2field" style="box-sizing: border-box;" onkeypress="return justFecha(event);">' +
		            '	</div>' +

				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px;">Bodega: </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Bodega" name="Nombre_Bodega" type="text" />' +
		            '	</div>' +
                    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 10px;">Estado: </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Estado" name="Estado" type="text" />' +
		            '	</div>' +

		            '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: -78px; margin-top: 18px;">Proveedor: </div>' +

                    '	<div class="w2ui-field" >' +
		            '	    <input name="ProveSN" class="form-control" type=checkbox style="margin-top: 16px;"/>' +
                    '	</div>' +

				    '<div class="w2ui-label w2ui-span4" style="margin-top: 3%; margin-left: 7px; width: 102px;">Selec. Proveedor: </div>' +
				    '<div class="w2ui-field w2ui-span4">' +
					    '<input name="Select_Proveedor" type="text" style="margin-top: 4px; margin-left: 6%; width: 40%;" disabled />' +
				    '</div>' +
			       '</div>' +
		        '</div>' +

              '</div>'
                    ,
            fields: [

		            { name: 'Fecha_Inicio', type: 'date' },
                    { name: 'Fecha_Termino', type: 'date' },

                    { name: 'Nombre_Bodega', type: 'list',
                        options: {
                            url: '../../clases/persistencia/controladores/Reportes/EstadosOrdenCompra/getListaBodegas_EstadosOC.ashx',
                            showNone: true
                        }
                    },
                    { name: 'Estado', type: 'list',
                        options: {
                            url: '../../clases/persistencia/controladores/Reportes/EstadosOrdenCompra/getListaEstados_EstadosOC.ashx',
                            showNone: true
                        }
                    },
                    { name: 'ProveSN', type: 'checkbox' },

                    { name: 'Select_Proveedor', type: 'text'}
	        ],
            onChange: function (event) {

                if (event.target == "ProveSN") {
                    if ($("#ProveSN")[0].checked) {
                        $('#Select_Proveedor').prop('disabled', false);
                        $('#id_BOT').prop('disabled', false);
                    } else {
                        $('#Select_Proveedor').prop('disabled', true);
                        $('#id_BOT').prop('disabled', true);
                    }
                }
            },
            onLoad: function (event) {

            }

        });   // Fin Form1


        // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: 'border: 0px; background-color: #f5f6f7',
            formHTML:
            '</div>' +
		        '<div class="w2ui-buttons">' +
		        '	<input type="button" value="Imprimir" name="imprimir">' +
                '	<input type="button" id="id_BOT" value="Busca Proveedor" onclick="openPopup2()" name="buscar2" style="width: 116px;" disabled >' +
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

                    var fechaInicio = w2ui['form'].record.Fecha_Inicio;
                    var fechaTermino = w2ui['form'].record.Fecha_Termino;
                    var bodega = w2ui['form'].record.Nombre_Bodega;
                    var estado = w2ui['form'].record.Estado;
                    var isChecked = $("#ProveSN")[0].checked;
                    var proveedor = w2ui['form'].record.Select_Proveedor;

                    if (fechaInicio && fechaTermino) {

                        if (bodega && estado) {

                            /* controla que el check este activado */
                            if (isChecked) {

                                var res = proveedor.split("-");

                                if (res[1]) {

                                    // TODAS LAS BODEGAS
                                    if (bodega == "TODAS") {
                                        // TODOS LOS ESTADOS
                                        if (estado == "TODOS") {
                                            window.open('../../reportes/Reportes/EstadosOrdenCompra/Report_EstadosOC.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&Estado=' + estado + '&Proveedor=' + res[0] + '&TipoBusqueda=' + 8);
                                        } else {
                                            window.open('../../reportes/Reportes/EstadosOrdenCompra/Report_EstadosOC.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&Estado=' + estado + '&Proveedor=' + res[0] + '&TipoBusqueda=' + 7);
                                        }
                                     } else {

                                        // UNICA BODEGA
                                        // TODOS LOS ESTADOS
                                        if (estado == "TODOS") {
                                            window.open('../../reportes/Reportes/EstadosOrdenCompra/Report_EstadosOC.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&Estado=' + estado + '&Proveedor=' + res[0] + '&TipoBusqueda=' + 6);
                                        } else {
                                            // UNICO ESTADO
                                            window.open('../../reportes/Reportes/EstadosOrdenCompra/Report_EstadosOC.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&Estado=' + estado + '&Proveedor=' + res[0] + '&TipoBusqueda=' + 5);
                                        }

                                    }

                                } else {
                                    alert("RUT Incorrecto...");
                                }

                            } else {

                                // TODAS LAS BODEGAS
                                if (bodega == "TODAS") {
                                    // TODOS LOS ESTADOS
                                    if (estado == "TODOS") {
                                        window.open('../../reportes/Reportes/EstadosOrdenCompra/Report_EstadosOC.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&Estado=' + estado + '&Proveedor=' + proveedor + '&TipoBusqueda=' + 4);
                                    } else {
                                        window.open('../../reportes/Reportes/EstadosOrdenCompra/Report_EstadosOC.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&Estado=' + estado + '&Proveedor=' + proveedor + '&TipoBusqueda=' + 3);
                                    }
                                } else {

                                    // UNICA BODEGA
                                    // TODOS LOS ESTADOS
                                    if (estado == "TODOS") {
                                        window.open('../../reportes/Reportes/EstadosOrdenCompra/Report_EstadosOC.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&Estado=' + estado + '&Proveedor=' + proveedor + '&TipoBusqueda=' + 2);
                                    } else {
                                        // UNICO ESTADO
                                        window.open('../../reportes/Reportes/EstadosOrdenCompra/Report_EstadosOC.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&Estado=' + estado + '&Proveedor=' + proveedor + '&TipoBusqueda=' + 1);
                                    }

                                }

                                //alert(fechaInicio + " " + fechaTermino + " " + bodega + " " + estado )
                                //window.open('../../reportes/Reportes/EstadosOrdenCompra/Report_EstadosOC.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&Estado=' + estado + '&Proveedor=' + proveedor + '&TipoBusqueda=' + 1);

                            } // fin if, isChecked

                        } else {
                            alert("Error, Se debe definir la BODEGA y el ESTADO de la Orden")
                        } // fin if, bodega && estado

                    } else {
                        alert("Error, Se deben definir el periodo de INICIO y TERMINO ")
                    } // fin if, fechaInicio && fechaTermino
                }
            },
            onLoad: function (event) {

            }
        });


        //===========================================
        //              BUSCA PROVEEDORES
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
			        { field: 'FULL_RUT', caption: 'RUT', size: '18%', sortable: true, searchable: true, editable: { type: 'text', inTag: 'maxlength=12'} },
                    { field: 'FLD_PRORAZONSOC', caption: 'RAZON SOCIAL', size: '22%', sortable: true, searchable: true },
			        { field: 'FLD_PRODIRECCION', caption: 'DIRECCION', size: '22%', sortable: true, searchable: true },
                    { field: 'FLD_PROFONO', caption: 'FONO', size: '16%' },
			        { field: 'FLD_PROCIUDAD', caption: 'CIUDAD', size: '18%' },
                    { field: 'FLD_PROCONTACTO', caption: 'CONTACTO', size: '18%' }
		        ]
            },

            // FORM DEL POPUP
            form4: {
                header: 'Ingrese criterio de Búsqueda',
                name: 'form4',
                fields: [
                    { name: 'rut', type: 'text', required: true, html: { caption: 'RUT', attr: 'size="10" maxlength="12"'} },
                    { name: 'razon', type: 'text', required: true, html: { caption: 'Razón Social', attr: 'size="20" maxlength="20"'} }
		        ],
                record: {
                    rut: '',
                    razon: ''
                },
                actions: {

                    Buscar: function () {

                        // Busqueda por RUT.
                        if (w2ui['form4'].record.rut != '') {

                            var RUT = w2ui['form4'].record.rut;
                            //RUT = RUT.toUpperCase();

                            var res = RUT.split("-");
                            

                            // si existe  "-", valida el rut y separa el digito verificador
                            if (res[1]) {

                                if (valrut(RUT)) {

                                    w2ui['grid3'].url = '../../clases/persistencia/controladores/Reportes/EstadosOrdenCompra/getProveedores_EstadosOC.ashx?tipoBusqueda=' + 'ConRut' + '&RUT=' + res[0];
                                    w2ui['grid3'].reload();

                                } else {
                                    alert("RUT Incorrecto...");
                                }
                            } else {

                                w2ui['grid3'].url = '../../clases/persistencia/controladores/Reportes/EstadosOrdenCompra/getProveedores_EstadosOC.ashx?tipoBusqueda=' + 'ConRut' + '&RUT=' + res[0];
                                w2ui['grid3'].reload();
                            }
                        }
                        // Busqueda por Razón Social.
                        else if (w2ui['form4'].record.razon != '') {

                            var RazonSocial = w2ui['form4'].record.razon;
                            RazonSocial = RazonSocial.toUpperCase();

                            w2ui['grid3'].url = '../../clases/persistencia/controladores/Reportes/EstadosOrdenCompra/getProveedores_EstadosOC.ashx?tipoBusqueda=' + 'ConRazonSocial' + '&razonSocial=' + RazonSocial;
                            w2ui['grid3'].reload();

                        }
                        // Alerta de mensaje por no ingresar nada.
                        else {
                            alert("Ingrese Elemento de Busqueda");
                        }

                    },
                    Seleccionar: function () {

                        w2ui['form'].record['Select_Proveedor'] = w2ui['grid3'].records[w2ui['grid3'].getSelection() - 1].FULL_RUT;
                        w2ui['form'].refresh();
                        w2popup.close();

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
                title: 'Búsqueda de Proveedores',
                width: 900,
                height: 420,
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

        function valrut(objeto) {
            var i, s, f, bueno;
            f = "32765432";
            r = objeto;
            largo = r.length - 2;
            bueno = false;
            s = 0;
            for (i = 0; i < largo; i++) {
                s = s + (parseInt(r.charAt(i)) * parseInt(f.charAt(i)));
            }
            dv = 11 - (s % 11);
            if (dv == 10 && (r.charAt(9) == 'K' || r.charAt(9) == 'k')) {
                bueno = true;
            } else {
                if (dv == 11 && r.charAt(9) == '0') {
                    bueno = true;
                } else {
                    if (dv == parseInt(r.charAt(9))) {
                        bueno = true;
                    } else {
                        bueno = false;
                    }
                }
            }
            return bueno;
        }

        function justFecha(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 46) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;

            return /\d/.test(String.fromCharCode(keynum));
        } 
    </script>
</asp:Content>
