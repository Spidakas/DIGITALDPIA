<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="home_reports.aspx.vb" Inherits="InformationSharingPortal.home_reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="server">
    <h1>Reports</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <asp:MultiView ID="mvReports" runat="server" ActiveViewIndex="0">
        <asp:View ID="vReportMenu" runat="server">
            <h3>Report menu <small>(click to select)</small></h3>
            <div class="list-group">
                <asp:LinkButton ID="lbtSharingPartnersList" ToolTip="Export to Excel" CssClass="list-group-item" runat="server">
                    <div class="row">
                        <div class="col-sm-1" style="font-size:40px;margin-top:20px"><i aria-hidden="true" class="icon-file-excel-o"></i></div>
                    <div class="col-xs-4"><h4 class="list-group-item-heading" style="margin-top:27px">Sharing Partners List</h4></div>
                    <div class="col-xs-7"><p class="list-group-item-text">List of all sharing partners, including:</p>
                    <ul>
                        <li>Basic organisation details</li>
                        <li>Organisation status (lead or sponsored)</li>
                        <li>IG assurance status</li>
                        <li>Type of information shared</li>
                        <li>Purpose of information sharing</li>
                        <li>List of safeguards / controls in place.</li>
                    </ul></div></div>
                </asp:LinkButton>
                 <asp:LinkButton ID="lbtDataAssetsReport" ToolTip="Export to Excel" CssClass="list-group-item" runat="server">
                    <div class="row">
                        <div class="col-sm-1" style="font-size:40px;margin-top:20px"><i aria-hidden="true" class="icon-file-excel-o"></i></div>
                    <div class="col-xs-4"><h4 class="list-group-item-heading" style="margin-top:27px">Data Assets List</h4></div>
                    <div class="col-xs-7"><p class="list-group-item-text">List of data assets registered on the DPIA for your organisation, including:</p>
                         <ul>
                             <li>Asset name</li>
                             <li>Description</li>
                             <li>Identifier</li>
                             <li>Data types</li>
                             <li>Data subjects</li>
                             <li>Formats.</li>
                         </ul></div></div>
                </asp:LinkButton>
               <%-- <asp:LinkButton ID="lbtSharingSummaries" ToolTip="Export to Excel" CssClass="list-group-item" runat="server">
                    <div class="row">
                        <div class="col-sm-1" style="font-size:40px;margin-top:20px"><i aria-hidden="true" class="icon-file-excel-o"></i></div>
                    <div class="col-xs-4"><h4 class="list-group-item-heading" style="margin-top:27px">Data Sharing Summaries List</h4></div>
                    <div class="col-xs-7"><p class="list-group-item-text">List of all active data sharing summaries, including:</p>
                    <ul>
                        <li>Number of organisations involved</li>
                        <li>Overall risk rating</li>
                        <li>Direction of flow</li>
                        <li>Frequency</li>
                        <li>Number of records</li>
                        <li>Flow status</li>
                        <li>Sign off status</li>
                        <li>Review date.</li>
                    </ul></div></div>
                </asp:LinkButton>--%>
                <asp:LinkButton ID="lbtDataFlows" ToolTip="Export to Excel" CssClass="list-group-item" runat="server">
                    <div class="row">
                        <div class="col-sm-1" style="font-size:40px;margin-top:20px"><i aria-hidden="true" class="icon-file-excel-o"></i></div>
                    <div class="col-xs-4"><h4 class="list-group-item-heading" style="margin-top:27px">Data Flows List</h4></div>
                    <div class="col-xs-7"><p class="list-group-item-text">List of all active data flows, including:</p>
                    <ul>
                        <li>Number of organisations involved</li>
                        <li>Overall risk rating</li>
                        <li>Direction of flow</li>
                        <li>Frequency</li>
                        <li>Number of records</li>
                        <li>Flow status</li>
                        <li>Sign off status</li>
                        <li>Review date.</li>
                    </ul></div></div>
                </asp:LinkButton>
               
            </div>
        </asp:View>
        
        <asp:View ID="vNoAdminGroup" runat="server">
            
    <h2>Reports Unavailable</h2>
       <p>Your organisation has a free usage licence.</p>
        <p>Some server intensive features of the Data Protection Impact Assessment Tool are unavailable to organisations have only a free usage licence. These include:</p>
                <ul>
                    <li>Reports</li>
                    <li>Document uploading</li>
                </ul>
                <p>In addition, support is only provided to these organisations on a "best endeavours" basis rather than according to a Service Level Agreement.</p>
        <p>If you would like more information on organisation licensing options, please contact us using the <asp:LinkButton ID="lbtContact" runat="server" PostBackUrl="~/Contact.aspx">Contact page</asp:LinkButton>.</p>

        </asp:View>
    </asp:MultiView>
</asp:Content>
