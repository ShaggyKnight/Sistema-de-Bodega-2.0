<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" 
CodeBehind="ConsumoXBodegaStock.aspx.vb" Inherits="Bodega_WebApp.ConsumoXBodegaStock" %>


<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.reportConsumoXBodegaStock_CriMinMax%>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <div id="form" style="margin-bottom:8px; height: 145px; width: 60%; margin-left: 20%; top: 15px; margin-bottom:8px;">
    </div>

    <div id="form2" style="height: 52px; background-color: rgb(245, 246, 247); width: 60%; margin-left: 20%;"></div>

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
            header: 'Consumo Para Stock Cri-Min-Max',
            formHTML:
                '<div id="form" style="width: 780px;">' +
	               '<div class="w2ui-page page-0">' +
                    '<div style="width: 488px; margin-left: 26px; float: left;">' +
			        '<div style="padding: 3px; font-weight: bold; color: #030303;">General</div>' +
			        '<div class="w2ui-group" style="height: 58px;">'+

				    '<div class="w2ui-label w2ui-span4" style="text-align: left; margin-left: 10px; margin-top: 8px;">Bodega</div>'+
		            '	<div class="w2ui-field" >' +
		            '		<select id="Nombre_Bodega" name="Nombre_Bodega" type="text" Style=" margin-left: 3%;"/>' +
		            '	</div>' + 

			       '</div>'+
		        '</div>' +
              '</div>'
                    ,
            fields: [
                    { name: 'Nombre_Bodega', type: 'list',
                        options: {
                            url: '../../../clases/persistencia/controladores/Recepciones/RecepcionxDonacion/getLista.ashx',
                            showNone: true
                        }
                    }

	        ],

        }); // Fin Form1


        // ----- BOTONES ----   BUSCAR, LIMPIAR, IMPRIMIR -----
        $('#form2').w2form({
            name: 'form2',
            style: ' background-color: #f5f6f7',
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
                    w2ui['form'].refresh();
                },
                "imprimir": function () {

                    var bodega = w2ui['form'].record.Nombre_Bodega;

                    if (bodega) {

                        window.open('../../../reportes/Reportes/ConsumoMensual/ConsumoXBodegaStock/Report_ConsXBodegaStock.aspx?Bodega='+ bodega );

                    } else {
                            alert("Debe Especificar la BODEGA")
                    } // fin if bodega && codFamilia

                }
            }
        });

        // console.log(response);
 
    </script>
</asp:Content>
