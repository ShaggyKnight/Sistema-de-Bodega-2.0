<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Report_StockEmergencia.aspx.vb" 
Inherits="Bodega_WebApp.Report_StockEmergencia" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>
<script src="../../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>StockEmergencia</title>
</head>
<body onload="load()">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager" runat="server">
    </asp:ScriptManager>
    <div align="center">
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Font-Names="Verdana" 
            Font-Size="8pt" InteractiveDeviceInfos="(Colección)" 
            WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" Width="730px" 
            Height="850px">
            <LocalReport ReportPath="reportes/StockEmergencia/RPT_StockEmergencia.rdlc">
                <DataSources>
                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                </DataSources>
            </LocalReport>
        </rsweb:ReportViewer>
        <!-- TypeName: Nombre del Proyecto "." nombre del DataSet "." Nombre de la tabla al que van destinados los valores ingresados-->
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
            SelectMethod="GetData" 
            TypeName="Bodega_WebApp.dsStockEmergenciaTableAdapters.PRO_STOCK_EMERGENCIA_NET2014TableAdapter" 
            OldValuesParameterFormatString="original_{0}">
            <SelectParameters>

                <asp:Parameter Name="FLD_BODCodigo" Type="String"/>
                <asp:Parameter Name="Par_MATCODIGO" Type="String" />
                <asp:Parameter Name="Porcentaje" Type="String" />
                <asp:Parameter Name="OrdenarPor" Type="String" />

            </SelectParameters>
        </asp:ObjectDataSource>
    </div>
    </form>

</body>
</html>