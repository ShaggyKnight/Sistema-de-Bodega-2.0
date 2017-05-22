<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="modificacionDespacho.aspx.vb" Inherits="Bodega_WebApp.modificacionDespacho" %>
<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%  CType(Me.Page.Master, Bodega_WebApp.Site).idePagina = Bodega_WebApp.Pagina.despaModificacionDespacho%>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="formModDesp" style="width: 100%;"></div>
    <div id="main" style="width: 100%; height: 400px;"></div>
</asp:Content>
<asp:Content ID="FooterContent" ContentPlaceHolderID="FooterPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="JavaScriptContent" ContentPlaceHolderID="contenedorJavascript" runat="server">
<script type="text/javascript">
    var periodoDespacho = 0;
    var numeroDespacho = 0;
    var contador = 0;
</script>
<script type="text/javascript">

    /*
     *Solicitudes:

     *Correcciones:
        Arreglo en el procedimiento para el buscador de despachos. (PRO_TB_DESPACHOS_BODEGA_SEL_LIMITE_NEW2014)
        Arreglo en la busqueda y la carga de datos.       
    */

    $('#formModDesp').w2form({
        name: 'formModDesp',
        header: 'Modificación de Despachos',
        recid: 10,
        formHTML: '<div class="w2ui-page page-0">' +
		                '<div style="width: 340px; float: left; ">' +
			                '<div class="w2ui-group" style="height: 90px;">' +
				                '<div class="w2ui-label w2ui-span4">Período:</div>' +
				                '<div class="w2ui-field w2ui-span4">' +
					                '<select name="periodoDespacho" type="text"  />' +
				                '</div>' +
                                '<div class="w2ui-label w2ui-span4">Despacho:</div>' +
				                '<div class="w2ui-field w2ui-span4">' +
					                '<input name="numeroDespacho" type="text" />' +
				                '</div>' +
			                '</div>' +
		                '</div>' +
	                '</div>' +
	                '<div class="w2ui-buttons">' +
		                '<input type="button" value="Buscar Despacho" name="buscarDespacho" style="width: 10%;">' +
		                '<input type="button" value="Limpiar" name="limpiar" style="width: 10%;">' +
	                '</div>',
        fields: [
			{ name: 'periodoDespacho', type: 'list',
			    options: { url: '../../clases/persistencia/controladores/Despachos/ModificacionDespachos/DataModificacionDespacho.ashx?tipoBusqueda=ListaPeriodos', showNone: false }
			},
            { name: 'numeroDespacho', type: 'int' }
		],
        actions: {
            buscarDespacho: function () {
                periodoDespacho = $('#periodoDespacho').val();
                numeroDespacho = $('#numeroDespacho').val();
                if (periodoDespacho == '' || periodoDespacho == undefined) {
                    w2alert('¡Debe seleccionar un período para la búsqueda!');
                } else {
                    if (numeroDespacho == '' || numeroDespacho == undefined) {
                        numeroDespacho = 0;
                    }
                    contador = 0;
                    w2ui.grid.clear();
                    w2ui.grid.url = '../../clases/persistencia/controladores/Despachos/ModificacionDespachos/DataModificacionDespacho.ashx?tipoBusqueda=buscaDespachos' + '&periodo=' + periodoDespacho + '&numeroDespacho=' + numeroDespacho + '&contador=' + contador + '&limit=' + 100;
                    w2ui.grid.reload();
                }

            },
            limpiar: function () {
                this.clear();
                w2ui.grid.clear();
            }
        }
    });
</script>
<script type="text/javascript">
    var config = {
        grid: {
            name: 'grid',
            url: '../../clases/persistencia/controladores/Despachos/ModificacionDespachos/DataModificacionDespacho.ashx?tipoBusqueda=buscaDespachos' + '&periodo=' + 0 + '&numeroDespacho=' + 0 + '&contador=' + contador + '&limit=' + 100,
            autoload: true,
            show: {
                footer: true,
                toolbar: false
            },
            columns: [
                { field: 'periodo', caption: 'Periodo', size: '10%' },
                { field: 'nroDespacho', caption: 'Nº Despacho', size: '10%' },
                { field: 'fechaDespacho', caption: 'Fecha Despacho', size: '12%' },
                { field: 'descripcion', caption: 'Descripción Despacho', size: '50%', editable: { type: 'text'} },
                { field: 'nroPedido', caption: 'Nº Pedido', size: '10%' }
            ],
            onLoad: function (event) {
                
                contador = contador + 1;
                this.url = '../../clases/persistencia/controladores/Despachos/ModificacionDespachos/DataModificacionDespacho.ashx?tipoBusqueda=buscaDespachos' + '&periodo=' + periodoDespacho + '&numeroDespacho=' + numeroDespacho + '&contador=' + contador + '&limit=' + 100;
            },
            onChange: function (event) {
                if (event.column == 3) {
                    periodoDespacho = this.records[event.recid - 1].periodo;
                    numeroDespacho = this.records[event.recid - 1].nroDespacho;
                    var descripcion = event.value_new;
                    if (descripcion == '' || descripcion == undefined) {
                        descripcion = 'SIN DESCRIPCIÓN'
                    }
                    this.request('save-records', { 'periodo': periodoDespacho, 'nroDespacho': numeroDespacho, 'descipcion': descripcion }, '../../clases/persistencia/controladores/Despachos/ModificacionDespachos/DataModificacionDespacho.ashx?tipoBusqueda=guardaCambios');
                    this.requestComplete('success', 'save-records', function () {
                        w2alert('¡Datos actualizados!');
                    });
                }
            }
        }
    }

    $(function () {
        $('#main').w2grid(config.grid);
        
    });
</script>
</asp:Content>
