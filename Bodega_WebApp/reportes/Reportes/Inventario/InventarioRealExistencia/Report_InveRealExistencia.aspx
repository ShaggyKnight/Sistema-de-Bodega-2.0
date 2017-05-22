<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Report_InveRealExistencia.aspx.vb"
 Inherits="Bodega_WebApp.Report_InveRealExistencia" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Reporte Inventario Real Existencias</title>
</head>
<body onload="load()">
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager" runat="server">
    </asp:ScriptManager>
    <div align="center">
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Font-Names="Verdana" 
            Font-Size="8pt" InteractiveDeviceInfos="(Colección)" 
            WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" Width="780px" 
            Height="700px">
            <LocalReport ReportPath="reportes/Reportes/Inventario/InventarioRealExistencia/RPT_InveRealExistencia.rdlc">
                <DataSources>
                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                </DataSources>
            </LocalReport>
        </rsweb:ReportViewer>
        <!-- TypeName: Nombre del Proyecto "." nombre del DataSet "." Nombre de la tabla al que van destinados los valores ingresados-->
        <!-- Name: es el nombre de la variable del Procedimiento -->
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
            SelectMethod="GetData" 
            TypeName="Bodega_WebApp.dsRPT_InveRealExistenciaTableAdapters.PRO_RPT_EXISTENCIA_REALXFAMILIA_NET2014TableAdapter" 
            OldValuesParameterFormatString="original_{0}">
            <SelectParameters>

                <asp:Parameter Name="Fld_BodCodigo" Type="String"/>
                <asp:Parameter Name="Fld_MatCodigo" Type="String"/>
                <asp:Parameter Name="IncluirCero" Type="String"/>
                <asp:Parameter Name="OrdenarPor" Type="String"/>
                <asp:Parameter Name="Fld_CodEstable" Type="String"/>

            </SelectParameters>
        </asp:ObjectDataSource>
    </div>
    </form>

</body>
</html>

