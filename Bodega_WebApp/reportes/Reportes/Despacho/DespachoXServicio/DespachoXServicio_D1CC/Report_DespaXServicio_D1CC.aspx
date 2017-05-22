<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Report_DespaXServicio_D1CC.aspx.vb" 
Inherits="Bodega_WebApp.Report_DespaXServicio_D1CC" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Reporte Despacho x Servicio Detalle un CC</title>
</head>
<body onload="load()">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager" runat="server">
    </asp:ScriptManager>
    <div align="center">
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Font-Names="Verdana" 
            Font-Size="8pt" InteractiveDeviceInfos="(Colección)" 
            WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" Width="100%" 
            Height="700px">
            <LocalReport ReportPath="reportes/Reportes/Despacho/DespachoXServicio/DespachoXServicio_D1CC/RPT_DespaXServicio_D1CC.rdlc">
                <DataSources>
                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                </DataSources>
            </LocalReport>
        </rsweb:ReportViewer>
        <!-- TypeName: Nombre del Proyecto "." nombre del DataSet "." Nombre de la tabla al que van destinados los valores ingresados-->
        <!-- Name: es el nombre de la variable del Procedimiento -->
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
            SelectMethod="GetData" 
            TypeName="Bodega_WebApp.dsRPT_DespaXServicio_D1CCTableAdapters.PRO_RPT_DESPACHOSXSERVICIO_NET2014TableAdapter" 
            OldValuesParameterFormatString="original_{0}">
            <SelectParameters>

                <asp:Parameter Name="FLD_FECHAI" Type="String"/>
                <asp:Parameter Name="FLD_FECHAF" Type="String"/>
                <asp:Parameter Name="FLD_TIPODEINFORME" Type="String"/>
                <asp:Parameter Name="CENTRODECOSTOS" Type="String"/>

            </SelectParameters>
        </asp:ObjectDataSource>
    </div>
    </form>

</body>
</html>

