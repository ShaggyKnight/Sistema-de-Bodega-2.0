<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="DespachoXPauta.aspx.vb" Inherits="Bodega_WebApp.DespachoXPauta" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reporXPauta%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:8px; height: 234px; width: 55%; margin-left: 20%;  margin-top: 10px;">
    </div>

    <div id="form2" style="height: 52px; border: 0px; background-color: rgb(245, 246, 247); width: 55%; margin-left: 20%;"></div>

</asp:Content>
<asp:Content ID="scriptCotent" ContentPlaceHolderID="contenedorJavascript" runat="server">
    <script type="text/javascript">

        /*  
          *Correcciones:
            Se disminuyo el tamaño del form para el ancho de los botones.
        */

        $('#form').w2form({
            name: 'form',
            style: 'background-color: #f5f6f7;', //#777 #f5f6f7
            recid: 10,
            url: '../../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getFechaServidor.ashx',
            header: 'Despacho v/s Pauta',
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

                    '<div class="w2ui-label w2ui-span4" style="width: 94px; text-align: left; margin-left: 10px;">Centro de Costo: </div>' +
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_CentroC" name="Nombre_CentroC" type="text" />' +
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
                            url: '../../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getLista.ashx',
                            showNone: true
                        }
                    },

                    { name: 'Nombre_CentroC', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Reportes/Despacho/DespachoXPauta/getListaCentroCosto.ashx',
                            showNone: true
                        }
                    }
	        ]

        });   // Fin Form1


        // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: 'border: 0px; background-color: #f5f6f7',
            formHTML:
            '</div>' +
		        '<div class="w2ui-buttons">' +
		        '	<input type="button" value="Imprimir" name="imprimir">' +
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
                    var fechaTermino = w2ui['form'].record.fechaServidor;
                    var bodega = w2ui['form'].record.Nombre_Bodega;
                    var cc = w2ui['form'].record.Nombre_CentroC;

                    if (fechaInicio && fechaTermino) {

                        if (bodega && cc) {

                            window.open('../../../reportes/Reportes/Despacho/DespachoXPauta/Report_DespachoXPauta.aspx?FechaInicio=' + fechaInicio + '&FechaTermino=' + fechaTermino + '&Bodega=' + bodega + '&CentroCosto=' + cc );

                        } else {
                            alert("Error, Se debe definir la BODEGA y el CENTRO DE COSTO")
                        } // fin if, bodega && estado

                    } else {
                        alert("Error, Se deben definir el periodo de INICIO y TERMINO ")
                    } // fin if, fechaInicio && fechaTermino
                }
            }
        });

        function justFecha(e) {
            var KeyAscii = window.event ? window.event.keyCode : e.which;
            if ((KeyAscii >= 0) && (KeyAscii <= 46) || (KeyAscii >= 58) && (KeyAscii <= 127) || (KeyAscii >= 160) && (KeyAscii <= 255))
                return false;

            return /\d/.test(String.fromCharCode(keynum));
        } 

    </script>
</asp:Content>



