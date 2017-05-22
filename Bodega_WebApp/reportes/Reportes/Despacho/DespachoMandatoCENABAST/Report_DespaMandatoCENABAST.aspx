<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Report_DespaMandatoCENABAST.aspx.vb"
 Inherits="Bodega_WebApp.Report_DespaMandatoCENABAST" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Reporte Despacho v/s Mandato CENABAST</title>
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
            <LocalReport ReportPath="reportes/Reportes/Despacho/DespachoMandatoCENABAST/RPT_DespaMandatoCENABAST2.rdlc">
                <DataSources>
                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                </DataSources>
            </LocalReport>
        </rsweb:ReportViewer>
        <!-- TypeName: Nombre del Proyecto "." nombre del DataSet "." Nombre de la tabla al que van destinados los valores ingresados-->
        <!-- Name: es el nombre de la variable del Procedimiento -->
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
            SelectMethod="GetData" 
            TypeName="Bodega_WebApp.dsRPT_DespaMandatoCENABASTTableAdapters.PRO_RPT_DESPACHOXPAUTA_Y_MANDATOCENABAST_NET2014TableAdapter" 
            OldValuesParameterFormatString="original_{0}">
            <SelectParameters>

                <asp:Parameter Name="Fld_Fecha" Type="String"/>
                <asp:Parameter Name="Fld_FechaFin" Type="String"/>
                <asp:Parameter Name="Fld_BodegaCodigo" Type="String"/>
                <asp:Parameter Name="EST_CEN_Codigo" Type="String"/>

            </SelectParameters>
        </asp:ObjectDataSource>
    </div>
    </form>

</body>
</html>