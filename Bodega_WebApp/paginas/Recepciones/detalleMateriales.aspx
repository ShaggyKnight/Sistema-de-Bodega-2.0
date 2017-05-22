<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="detalleMateriales.aspx.vb"
    Inherits="Bodega_WebApp.detalleMateriales" %>

<%@ Import Namespace="Bodega_WebApp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../componentes/nivoslider/nivo-slider.css" rel="stylesheet" type="text/css" />
    <link href="../../componentes/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../../componentes/jquery.ui/css/ui-lightness/jquery-ui-1.10.3.custom.css"
        rel="stylesheet" type="text/css" />
    <link href="../../componentes/jquery.ui/css/ui-lightness/jquery-ui-1.10.3.custom.min.css"
        rel="stylesheet" type="text/css" />
    <link href="../../componentes/bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="../../componentes/bootstrap/css/bootstrap-glyphicons.css" rel="stylesheet"
        type="text/css" />
    <link href="../../Styles/Site.css" rel="stylesheet" type="text/css" />
    <style>

        html
        {
            height: auto;
        }
        body
        {
            background-color: #eeeeee;
        }
        button.ui-dialog-titlebar-close:after
        {
            content: "\e014";
            font-family: 'Glyphicons Halflings' !important;
            font-style: normal;
            font-weight: 400;
            line-height: 1;
            -webkit-font-smoothing: antialiased;
            color: #006dd9;
        }
        
        button.ui-dialog-titlebar-close
        {
            background-color: transparent;
            border: 0;
        }
        
        .detalleMaterial
        {
            background-color: Transparent;
            border: 0;
        }
        .ui-widget-header
        {
            border: 0;
            background: transparent;
            color: #006dd9;
            font-weight: bold;
        }
        .detalleMaterialModal
        {
            position: absolute;
            height: auto;
            width: 100%;
            top: 311px;
            left: 334px;
            display: block;
            max-width: 500px;
        }
        .estiloGrilla
        {
            width: 100%;
        }
        
        .estiloGrilla input
        {
            color: #006dd9;
            width: 100% !important;
            text-align: center;
        }
        
        .estiloGrilla select
        {
            color: #006dd9;
            width: 100%;
        }
        .cabeceraGrilla
        {
            background-color: #006dd9;
            border-color: #006dd9;
        }
        .cabeceraRecepciones
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
        }
        .cabeceraRecepcionesTotal
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
            width: 8%;
        }
        .cabeceraRecepcionesValor
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
            width: 9%;
        }
        .cabeceraRecepcionesNMaterial
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
            width: 39%;
        }
        .cabeceraRecepcionesCantidad
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
        }
        .cabeceraRecepcionesCodigo
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
            width: 11%;
        }
        .cabeceraRecepcionesARecibir
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
            width: 50px;
        }
        .cabeceraRecepcionesRecepcionado
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
        }
        .cabeceraRecepcionesRecepXFact
        {
            font-family: Arial Rounded MT bold;
            color: white;
            text-align: center;
            width: 132px;
        }
        .contenidoGrilla
        {
            font-family: Arial Rounded MT bold;
            color: #006dd9;
            text-align: center;
        }
        #contenedorGrilla
        {
            overflow: hidden;
            -webkit-border-top-left-radius: 5px;
            -webkit-border-top-right-radius: 5px;
            -moz-border-radius-topleft: 5px;
            -moz-border-radius-topright: 5px;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            background-color: white;
            padding: 0;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <form id="Form1" runat="server" style="height: 100%;">
    <div id="contenedorGrilla" runat="server">
        <table class="estiloGrilla" cellspacing="0" rules="all" border="1" id="detalleMaterialGrid"
            style="border-collapse: collapse;">
            <thead>
                <tr class="cabeceraGrilla">
                    <td class="cabeceraRecepciones">
                    </td>
                    <td class="cabeceraRecepciones">
                        Cantidad
                    </td>
                    <td class="cabeceraRecepciones">
                        Nro Serie
                    </td>
                    <td class="cabeceraRecepciones">
                        Nro Lote
                    </td>
                    <td class="cabeceraRecepciones">
                        Fecha de Vencimiento
                    </td>
                </tr>
            </thead>
            <tbody id="bodyTabla">
                    <% For Each detalle As IngresoProductoDetalle In listaDetallesMaterial%>
                        <tr>
                            <td class="contenidoGrillaInput">
                                <button type="button" class="borrarDetalleMaterial detalleMaterial glyphicon glyphicon-minus-sign">
                                </button>
                            </td>
                            <td class="contenidoGrillaInput">
                                <input name="cantidadDetalleMat" type="text" id="cantidadDetalleMat" class="Input"
                                    onkeypress="sinpostback()" value="<% Response.Write(detalle.cantidad)%>" placeholder = "000">
                            </td>
                            <td class="contenidoGrillaInput">
                                <input name="nroSerieDetalleMat" type="text" id="nroSerieDetalleMat" class="Input"
                                    onkeypress="sinpostback()" value="<% Response.Write(detalle.numeroDeSerie)%>" placeholder = "000000">
                            </td>
                            <td class="contenidoGrillaInput">
                                <input name="nroLoteDetalleMat" type="text" id="nroLoteDetalleMat" class="Input"
                                    onkeypress="letrasLote()" value="<% Response.Write(detalle.numeroDeLote)%>" placeholder = "X000000">
                            </td>
                            <td class="contenidoGrillaInput">
                                <input class="datepicker" name="fechaVencimiento" type="text" value="<% Response.Write(detalle.fechaVencimiento)%>" placeholder = "dd/mm/yyyy">
                            </td>
                        </tr>
                    <% Next%>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="5" style="text-align: center">
                        <button id="btnAgregarColumna" type="button" class="detalleMaterial glyphicon glyphicon-plus-sign"
                            onclick="addRow()">
                        </button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
    <input type="submit" id="postback" name="postback" value="<% Response.Write(Me.idPadre)%>" style="display: none;" />

    <script src="../../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-1.4.1-vsdoc.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <script src="../../componentes/jquery.ui/js/jquery-1.9.1.js" type="text/javascript"></script>
    <script src="../../componentes/jquery.ui/js/jquery-ui-1.10.3.custom.js" type="text/javascript"></script>
    <script src="../../componentes/jquery/jquery.js" type="text/javascript"></script>
    <script src="../../componentes/bootstrap/js/bootstrap.js" type="text/javascript"></script>
    <script src="../../componentes/jquery.ui/js/jquery-ui-1.10.3.custom.min.js" type="text/javascript"></script>
    <script src="../../componentes/nivoslider/jquery.nivo.slider.pack.js" type="text/javascript"></script>
    <script src="../../componentes/jquery.form/jquery.form.js" type="text/javascript"></script>
    <script type="text/javascript">

        function sinpostback() {
            if ((event.keyCode < 48 || event.keyCode > 57) && event.keyCode != 46 && event.keyCode != 45) {
                event.returnValue = false;
            }
        }

        function letrasLote() {
            if ((event.keyCode < 48 || event.keyCode > 90) && event.keyCode != 46 && event.keyCode != 45) {
                event.returnValue = false;
            }
        }

        $(".datepicker").datepicker({ dateFormat: 'dd-mm-yy' });

        function postBack() {
            document.getElementById("postback").click();
        }

        $('#Form1').ajaxForm();

        function addRow() {
            $('#detalleMaterialGrid tbody>tr:last').clone(true).insertAfter('#detalleMaterialGrid tbody>tr:last');
            $agregado = $('#detalleMaterialGrid tbody>tr:last');
            $agregado.find('input[name="cantidadDetalleMat"]').val("");
            $agregado.find('input[name="nroSerieDetalleMat"]').val("");
            $agregado.find('input[name="nroLoteDetalleMat"]').val("");
            $('#detalleMaterialGrid tbody>tr:last>td:last').remove();
            $('#detalleMaterialGrid tbody>tr:last').append("<td class='contenidoGrillaInput'><input class='datepicker' name='fechaVencimiento' type='text' placeholder = 'dd/mm/yyyy'></td>");
            $agregado.find('input[name="cantidadDetalleMat"]').focus();
            $($agregado.find('input[name="fechaVencimiento"]')).datepicker({ dateFormat: 'dd-mm-yy' });
        }
        $(".borrarDetalleMaterial").click(function () {
            var rowCount = $('#detalleMaterialGrid tbody tr').length;
            if (rowCount != 1) {
                $(this).parent().parent().remove();

            }
            else {
                alert("Debe existir, a lo menos, 1 detalle");
            }
            $('#detalleMaterialGrid tbody>tr:last').find('input[name="cantidadDetalleMat"]').focus();
        });

        window.onload = function () { $('#detalleMaterialGrid tbody>tr:last').find('input[name="cantidadDetalleMat"]').focus(); }

//        $(document).jkey('ctrl+enter', true, function () {
//            addRow();
//        });

        function sumarCantidades() {
            $sumaCantidades = 0;
            $("#bodyTabla > tr").each(function () {
                var fields = $(this).find(":text");
                var cantidad = fields.eq(0).val();
                $sumaCantidades += parseInt(cantidad);
            });
            return $sumaCantidades;
        }

        function datosCompletados() {
            var validar = false;
            $("#bodyTabla > tr").each(function () {
                var fields = $(this).find(":text");
                var cantidad = fields.eq(0).val();
                var nroSerie = fields.eq(1).val();
                var nroLote = fields.eq(2).val();
                var date = fields.eq(3).val();
                var $isCantidadValida = (cantidad == "");
                var $isIdValido = (nroSerie == "" && nroLote == "");
                var $isDateValido = (date == "");
                if ($isCantidadValida || $isIdValido || $isDateValido) {
                    validar = false;
                } else {
                    validar = true;
                }
            });
            return validar
        }

    </script>
    </form>
</body>
</html>
