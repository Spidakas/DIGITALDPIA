<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="flows_list.aspx.vb" Inherits="InformationSharingPortal.flows_list" %>

<%@ Register Assembly="DevExpress.Web.Bootstrap.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<%@ Register Src="~/GridviewControlPanel.ascx" TagPrefix="uc1" TagName="GridviewControlPanel" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <style>
        .btn-group{
  display: flex;
}
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="server">
    <h1>Data Flow List</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ObjectDataSource ID="dsFlows" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.GetDataFlowsForOrganisationTableAdapter">
        <SelectParameters>
            <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
            <asp:ControlParameter ControlID="ddSharingOrgs" Name="SharingOrganisationID" PropertyName="SelectedValue" Type="Int32" />
            <asp:ControlParameter ControlID="cbIncludeArchived" Name="IncludeArchived" PropertyName="Checked" Type="Boolean" />
        </SelectParameters>
    </asp:ObjectDataSource>
     <h3>Data Flows<%--<asp:CheckBox ID="cbIncludeArchived" AutoPostBack="true" CssClass="pull-right no-bold-label small" Font-Bold="false" runat="server" Text=" Include Archived" />--%></h3>
    <asp:ObjectDataSource ID="dsOrgsSharing" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.dashboardTableAdapters.isp_OrganisationsSharingTableAdapter">
                            <SelectParameters>
                                <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource> 
    <asp:Panel ID="pnlFreeLicenceMessage" Visible="false" runat="server" CSSClass="alert alert-danger alert-dismissible" role="alert">     
        <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                <asp:Label ID="Label16" runat="server" Text="Label">You are accessing the DPIA under a "free" licence, as such you are unable to:<ul><li>Export the Data Flows list to Excel</li><li>Export data flows to PDF</li></ul>  To discuss licencing options for your organisation please contact <a href='mailto:isg@mbhci.nhs.uk'>isg@mbhci.nhs.uk</a>.</asp:Label>                                
</asp:Panel>
    <div class="panel panel-default">
                <div class="panel-body">
                    <div class="form-inline small pull-right" role="form">
                    <div class="form-group">
                            <asp:Label ID="lblHideArchived" CssClass="filter-col" runat="server" Text="" AssociatedControlID="cbIncludeArchived"> &nbsp;Include archived?</asp:Label><asp:CheckBox ID="cbIncludeArchived" AutoPostBack="true" runat="server" Checked="False" />
                        </div>
                        <asp:Panel ID="pnlShareOrg" runat="server" CssClass="form-group">
                            <asp:Label ID="lblSharedWith" CssClass="control-label filter-col" runat="server" AssociatedControlID="ddSharingOrgs" Text="Sharing Organisation:"></asp:Label><asp:DropDownList AutoPostBack="true" ID="ddSharingOrgs" AppendDataBoundItems="true" runat="server" DataSourceID="dsOrgsSharing" CssClass="form-control input-sm" DataTextField="OrganisationName" DataValueField="OrganisationID">
                                <asp:ListItem Selected="True" Text="Any" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </asp:Panel>
                </div>
                    </div>
     </div>
    <%--<div class="row">
        <div class="col-sm-12">
            <div class="btn-group pull-right" role="group" aria-label="...">

                 <asp:LinkButton ID="lbtClearFilters" CausesValidation="false" CssClass="btn btn-default" ToolTip="Clear filters of Data Asset grid" runat="server"><i aria-hidden="true" class="icon-filter"></i>Clear Filters</asp:LinkButton>
                <uc1:GridviewControlPanel runat="server" ID="daGridviewControlPanel" HeaderText="Show / Hide Columns" LinkText="Choose Columns" GridID="bsgvFlows" />

                <asp:LinkButton ID="lbtExportList" CssClass="btn btn-success" ToolTip="Export filtered data assets to Excel" CausesValidation="false" runat="server"><i aria-hidden="true" class="icon-file-excel"></i> <b>Export to Excel</b> </asp:LinkButton>
            </div>
        </div>
    </div>--%>

    <dx:ASPxGridViewExporter ID="bsgvExporter" GridViewID="bsgvFlows" FileName="DPIA Data Flows" runat="server"></dx:ASPxGridViewExporter>
    <dx:BootstrapGridView Settings-GridLines="None" ID="bsgvFlows" OnHtmlRowPrepared="bsgvFlowsForSummary_HtmlRowPrepared" runat="server" AutoGenerateColumns="False" DataSourceID="dsFlows" KeyFieldName="DataFlowID" OnToolbarItemClick="GridViewCustomToolbar_ToolbarItemClick" SettingsCustomizationDialog-Enabled="true">
         <ClientSideEvents ToolbarItemClick="onToolbarItemClick" />
        <CssClasses Table="table table-striped table-condensed" />
        <SettingsPager PageSize="15" />
        <Settings ShowHeaderFilterButton="True" />
        <SettingsCookies Enabled="True" Version="0.122" StoreSearchPanelFiltering="False" StorePaging="False"/>
        <Columns>
            <dx:BootstrapGridViewTextColumn Name="View / Edit" Caption="" VisibleIndex="0" ShowInCustomizationDialog="False">
                <DataItemTemplate>
                    <asp:LinkButton EnableViewState="false" ID="lbtEdit" Visible='<%# Eval("Signatures") = 0 And Eval("Archived").ToString.Length = 0 And Eval("InDraft") And (Eval("InvolvesMyOrg") Or Eval("AddedByOrgID") = Session("UserOrganisationID"))%>' OnCommand="Edit_Click" CssClass="btn btn-default btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Edit data flow" runat="server"><i aria-hidden="true" class="icon-pencil"></i></asp:LinkButton>
                    <asp:LinkButton EnableViewState="false" ID="lbtView" Visible='<%# (Eval("Signatures") > 0 Or Not Eval("InDraft") Or Eval("Archived").ToString.Length > 0) And (Eval("InvolvesMyOrg") Or Eval("AddedByOrgID") = Session("UserOrganisationID"))%>' OnCommand="View_Click" CssClass="btn btn-default btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="View data flow" runat="server"><i aria-hidden="true" class="icon-file"></i></asp:LinkButton>
                </DataItemTemplate>
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn FieldName="DataFlowID" Caption="ISGID" Name="ISGID" VisibleIndex="1">
                <SettingsEditForm Visible="False" />
                <DataItemTemplate>
                    <asp:Label EnableViewState="false" ID="Label1" Font-Bold="true" runat="server" Text='<%# PadDFID(Eval("DataFlowID"))%>'></asp:Label>
                </DataItemTemplate>
                <Settings AllowHeaderFilter="False" />
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn FieldName="DataFlowIdentifier" HorizontalAlign="Left" Caption="Data Flow" Name="ISGID" ReadOnly="True" VisibleIndex="2">
                <Settings AllowHeaderFilter="False" />
                 <DataItemTemplate>
                    <asp:Label EnableViewState="false" ID="Label1" Font-Bold="true" runat="server" Text='<%# Eval("DataFlowIdentifier")%>'></asp:Label>
                </DataItemTemplate>
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn FieldName="SummaryName" Caption="Summary" Name="Summary" VisibleIndex="4">
                <CssClasses DataCell="small" />
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn Caption="DPO Review" FieldName="DPOReviewStatus" VisibleIndex="5">
                <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                <DataItemTemplate>
                    <asp:Label EnableViewState="false" Width="90px" ID="lblNotReq" Visible='<%# Eval("DPOReviewStatus") = "Not required" %>' runat="server" CssClass="label label-default" Text="Not required"></asp:Label>
                    <asp:Label EnableViewState="false" Width="90px" ID="lblNotStarted" Visible='<%# Eval("DPOReviewStatus") = "Not started" %>' runat="server" CssClass="label label-default" Text="Not started"></asp:Label>
                    <asp:Label EnableViewState="false" Width="90px" ID="lblRequested" Visible='<%# Eval("DPOReviewStatus") = "Requested" %>' runat="server" CssClass="label label-info" Text="Requested"></asp:Label>
                    <asp:Label EnableViewState="false" Width="90px" ID="lblOverdue" Visible='<%# Eval("DPOReviewStatus") = "Overdue" %>' runat="server" CssClass="label label-warning" Text="Overdue"></asp:Label>
                    <asp:Label EnableViewState="false" Width="90px" ID="Label5" Visible='<%# Eval("DPOReviewStatus") = "Not completed" %>' runat="server" CssClass="label label-warning" Text="Not completed"></asp:Label>
                    <asp:Label EnableViewState="false" Width="90px" ID="lblApproved" Visible='<%# Eval("DPOReviewStatus") = "Approved" %>' runat="server" CssClass="label label-success" Text="Approved"></asp:Label>
                    <asp:Label EnableViewState="false" Width="90px" ID="lblRejected" Visible='<%# Eval("DPOReviewStatus") = "Rejected" %>' runat="server" CssClass="label label-danger" Text="Rejected"></asp:Label>
                </DataItemTemplate>
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn Name="Status"  Caption="In Draft" CssClasses-HeaderCell="icon-unlocked header-link hidden-header" fieldName="InDraft" VisibleIndex="6">
              
                <DataItemTemplate>
                    <asp:Label EnableViewState="false" runat="server" ID="lblStatusDraft" Visible='<%#Eval("InDraft") And Eval("Signatures") = 0%>' ToolTip="Draft"><i aria-hidden="true" class="icon-unlocked"></i></asp:Label>
                    <asp:Label EnableViewState="false" runat="server" ID="lblStatusFinal" Visible='<%#Not Eval("InDraft") Or Eval("Signatures") > 0%>' ToolTip="Final"><i aria-hidden="true" class="icon-lock"></i></asp:Label>
                </DataItemTemplate>
<CssClasses HeaderCell="icon-unlocked header-link hidden-header"></CssClasses>

                <Settings AllowHeaderFilter="False" />
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn Name="Added by Org" Caption="Added by Org" CssClasses-HeaderCell="icon-home header-link hidden-header" FieldName="AddedByOrganisation" VisibleIndex="7">
                <DataItemTemplate>
                    <asp:Label EnableViewState="false" runat="server" ID="Label2" Visible='<%#Eval("AddedByOrganisation") = Session("UserOrganisationName")%>' ToolTip="Created By My Organisation"><i aria-hidden="true" class="icon-home"></i></asp:Label>      
                </DataItemTemplate>
<CssClasses HeaderCell="icon-home header-link hidden-header"></CssClasses>

                <Settings AllowHeaderFilter="False" />
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn Name="Signed by Org" Caption="Signed by My Org" CssClasses-HeaderCell="icon-checkmark header-link hidden-header" FieldName="MyOrgSigned" VisibleIndex="8">
                <DataItemTemplate>
                    <asp:Label EnableViewState="false" runat="server" ID="Label3" Visible='<%#Eval("MyOrgSigned") = True %>' ToolTip="Signed Off By My Organisation"><i aria-hidden="true" class="icon-checkmark"></i> </asp:Label>
                </DataItemTemplate>
<CssClasses HeaderCell="icon-checkmark header-link hidden-header"></CssClasses>

                <Settings AllowHeaderFilter="False" />
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn Name="GDPR non-compliant" Caption="GDPR non-compliant" CssClasses-HeaderCell="icon-notification header-link hidden-header" FieldName="NonGDPRCompliant" VisibleIndex="9">
                <DataItemTemplate>
                    <asp:Label EnableViewState="false" runat="server" ID="Label3" Visible='<%#Eval("NonGDPRCompliant") = True %>' ToolTip="GDPR non-compliant consent model or conditions for sharing"><span class="text-danger"><i aria-hidden="true" class="icon-notification"></i></span> </asp:Label>
                </DataItemTemplate>
<CssClasses HeaderCell="icon-notification  header-link hidden-header"></CssClasses>

                <Settings AllowHeaderFilter="False" />
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn Name="Signatures" Caption="Signatures" CssClasses-HeaderCell="icon-quill header-link hidden-header" VisibleIndex="11" FieldName="Signatures">
<CssClasses HeaderCell="icon-quill header-link hidden-header"></CssClasses>

               <Settings AllowHeaderFilter="False" />
                <DataItemTemplate>
                    <span>
                        <asp:Label ID="lblLocked" Font-Size="Smaller" EnableViewState="false" Font-Bold="true" runat="server" Visible='<%#Not Eval("InDraft") Or Eval("Signatures") > 0%>' ToolTip='<%# Eval("Signatures") & "/" & (CInt(Eval("OrgsInvolved"))).ToString & " organisations signed"%>'><%# Eval("Signatures") & "/" & (CInt(Eval("OrgsInvolved"))).ToString%></asp:Label>
                        <asp:Label ID="Label4" Font-Size="Smaller" EnableViewState="false" Font-Bold="true" runat="server" Visible='<%#Eval("InDraft") And Eval("Signatures") = 0%>' ToolTip='<%# (CInt(Eval("OrgsInvolved"))).ToString & " organisations involved"%>'><%# (CInt(Eval("OrgsInvolved"))).ToString%></asp:Label>
                    </span>
                </DataItemTemplate>
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn FieldName="RiskRating" VisibleIndex="12">
                <DataItemTemplate>
                    <asp:Label EnableViewState="false" Width="90px" ID="lblHigh" Visible='<%# Eval("RiskRating") = "High"%>' ToolTip="1 or more high risks identified or a significant number of medium risks" runat="server" CssClass="label label-danger" Text='<%# Eval("RiskRating")%>'></asp:Label>
                    <asp:Label EnableViewState="false" Width="90px" ID="lblSig" Visible='<%# Eval("RiskRating") = "Significant"%>' ToolTip="2 or more medium risks identified" runat="server" CssClass="label label-warning" Text='<%# Eval("RiskRating")%>'></asp:Label>
                    <asp:Label EnableViewState="false" Width="90px" ID="lblLow" Visible='<%# Eval("RiskRating") = "Low"%>' ToolTip="Only low risks and less than 3 medium risks identified" runat="server" CssClass="label label-success" Text='<%# Eval("RiskRating")%>'></asp:Label>
                    <asp:Label EnableViewState="false" Width="90px" ID="lblNone" Visible='<%# Eval("RiskRating") = "Not Assessed"%>' ToolTip="No risk assessment submitted" runat="server" CssClass="label label-default" Text='<%# Eval("RiskRating")%>'></asp:Label>
                </DataItemTemplate>
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewDateColumn FieldName="AddedDate" caption="Added" VisibleIndex="13">
                <CssClasses DataCell="small" />
            </dx:BootstrapGridViewDateColumn>
            <dx:BootstrapGridViewDateColumn FieldName="FirstSigned" VisibleIndex="14">
                <CssClasses DataCell="small" />
            </dx:BootstrapGridViewDateColumn>
            <dx:BootstrapGridViewTextColumn Name="Tools" Caption="Tools" VisibleIndex="17" ShowInCustomizationDialog="False">
                <DataItemTemplate>
                    <div class="btn-group pull-left" role="group" aria-label="...">
                        <asp:LinkButton EnableViewState="false" ID="lbtExport" Visible='<%# Not Session("orgLicenceType") = "Free, limited licence"%>' OnCommand="Export_Click" CssClass="btn btn-default btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Export Data Sharing Agreement to PDF" runat="server"><i aria-hidden="true" class="icon-file-pdf-o"></i></asp:LinkButton>
                        <asp:LinkButton EnableViewState="false" ID="lbtCopy" Visible='<%# Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO") %>' OnCommand="Copy_Click" CssClass="btn btn-info btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Copy data flow" runat="server"><i aria-hidden="true" class="icon-copy"></i></asp:LinkButton>
                        <asp:LinkButton EnableViewState="false" ID="lbtDelete" Visible='<%# (((Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO")) And Eval("AddedByOrgID") = Session("UserOrganisationID")) Or Session("IsSuperAdmin")) And Eval("Archived").ToString.Length = 0 And Eval("InDraft") And Eval("Signatures") = 0 %>' OnCommand="DeleteFlow_Click" OnClientClick="return confirm('Are you sure you want to delete this data flow?');" CssClass="btn btn-danger btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Delete data flow" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-remove"></i></asp:LinkButton>
                        <asp:LinkButton EnableViewState="false" ID="lbtArchive" Visible='<%# (((Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO")) And Eval("AddedByOrgID") = Session("UserOrganisationID")) Or Session("IsSuperAdmin")) And Eval("Archived").ToString.Length = 0 And (Not Eval("InDraft") Or Eval("Signatures") > 0)  %>' OnCommand="Archive_Click" OnClientClick="return confirm('Are you sure you want to archive this data flow? If the flow is due to be reviewed, you should archive the summary instead to generate copies of the summary and associated flows.');" CssClass="btn btn-danger btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Archive data flow" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-trash"></i></asp:LinkButton>
                    </div>
                </DataItemTemplate>
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn Caption="Signature Requests" FieldName="SignatureRequests" Name="Requests" Visible="False" VisibleIndex="15">
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn FieldName="Archived" PropertiesTextEdit-DisplayFormatString="dd/MM/yyyy" Visible="False" VisibleIndex="16">
<PropertiesTextEdit DisplayFormatString="dd/MM/yyyy"></PropertiesTextEdit>

                <CssClasses DataCell="small" />
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn FieldName="SummaryID" Visible="False" VisibleIndex="3">
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn FieldName="OrgsInvolved" Visible="False" VisibleIndex="10">
            </dx:BootstrapGridViewTextColumn>
        </Columns>
         <Toolbars>
        <dx:BootstrapGridViewToolbar>
            <Items>
                <dx:BootstrapGridViewToolbarItem Command="ClearFilter" IconCssClass="glyphicon glyphicon-remove" Text="Clear filters" />
                <dx:BootstrapGridViewToolbarItem Command="ShowCustomizationDialog" Text="Customise Grid" IconCssClass="glyphicon glyphicon-list-alt" />
                <dx:BootstrapGridViewToolbarItem Command="Custom" Name="Export" CssClass="btn btn-success" Text ="Export to Excel" IconCssClass="icon-file-excel" ToolTip="Export grid to Excel"/>
            </Items>
        </dx:BootstrapGridViewToolbar>
    </Toolbars>

<SettingsCustomizationDialog Enabled="True"></SettingsCustomizationDialog>

        <SettingsSearchPanel Visible="True" AllowTextInputTimer="false" />
    </dx:BootstrapGridView>
    <dx:BootstrapButton ID="bsbtnAdd" runat="server" AutoPostBack="True" CssClasses-Icon="icon-plus" CssClasses-Control="btn btn-primary pull-right" Text="Add Data Flow"></dx:BootstrapButton>
          
</asp:Content>
