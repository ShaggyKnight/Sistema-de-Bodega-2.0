<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RptVentana_ProgramaMinsal.aspx.vb" Inherits="Bodega_WebApp.RptVentana_ProgramaMinsal" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>
<script src="../../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
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
            <LocalReport ReportPath="reportes/Recepciones/ProgramaxMinsal/RPT_ProgramaMinsal.rdlc">
                <DataSources>
                    <rsweb:ReportDataSource DataSourceId="ObjectDataSource1" Name="DataSet1" />
                </DataSources>
            </LocalReport>
        </rsweb:ReportViewer>
        <!-- TypeName: Nombre del Proyecto "." nombre del DataSet "." Nombre de la tabla al que van destinados los valores ingresados-->
        <!-- Name: es el nombre de la variable del Procedimiento -->
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
            SelectMethod="GetData" 
            TypeName="Bodega_WebApp.dsRPT_ProgramaMinsalTableAdapters.PRO_INFORME_TRANSACCIONES_SEL_netTableAdapter" 
            OldValuesParameterFormatString="original_{0}">
            <SelectParameters>
                <asp:Parameter Name="FLD_CMVNUMERO" Type="String"/>
                <asp:Parameter Name="FLD_PERCODIGO" Type="String"/>
                <asp:Parameter Name="FLD_TMVCODIGO" Type="String"/>
                <asp:Parameter Name="FLD_USUARIO" Type="String"/>
            </SelectParameters>
        </asp:ObjectDataSource>
    </div>
    </form>

</body>
</html>
