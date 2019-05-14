<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="summaries_list.aspx.vb" Inherits="InformationSharingPortal.summaries_list" %>

<%@ Register Assembly="DevExpress.Web.Bootstrap.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>
<%@ Register assembly="DevExpress.Web.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>
<%@ Register Src="~/GridviewControlPanel.ascx" TagPrefix="uc1" TagName="GridviewControlPanel" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="server">

    <h1>Data Sharing</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ObjectDataSource ID="dsSummaries" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.DataFlowSummary_GetForOrgTableAdapter">
        <SelectParameters>
            <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
            <asp:ControlParameter ControlID="cbIncludeArchived" Name="IncludeArchived" PropertyName="Checked" Type="Boolean" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsFlowsForSummary" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataBySummary" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.GetDataFlowsForOrganisationTableAdapter">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="SummaryID" SessionField="nSummaryID" Type="Int32" />
            <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
            <asp:ControlParameter ControlID="cbIncludeArchived" Name="IncludeArchived" PropertyName="Checked" Type="Boolean" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <h3>Sharing Summaries<asp:CheckBox ID="cbIncludeArchived" AutoPostBack="true" CssClass="pull-right no-bold-label small" Font-Bold="false" runat="server" Text=" Include Archived" /></h3>
    <asp:Panel ID="pnlFreeLicenceMessage" Visible="false" runat="server" CSSClass="alert alert-danger alert-dismissible" role="alert">     
        <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                <asp:Label ID="Label16" runat="server" Text="Label">You are accessing the DPIA under a "free" licence, as such you are unable to:<ul><li>Export the Sharing Summaries list to Excel</li><li>Export data flows to PDF</li></ul>  To discuss licencing options for your organisation please contact <a href='mailto:isg@mbhci.nhs.uk'>isg@mbhci.nhs.uk</a>.</asp:Label>                                
</asp:Panel>
    <dx:ASPxGridViewExporter ID="bsgvExporter" GridViewID="bsgvSummaries" FileName="DPIA Sharing Summaries" runat="server"></dx:ASPxGridViewExporter>
    
    <dx:BootstrapGridView ID="bsgvSummaries" Settings-GridLines="None" runat="server" AutoGenerateColumns="False" DataSourceID="dsSummaries" KeyFieldName="DataFlowID" OnToolbarItemClick="GridViewCustomToolbar_ToolbarItemClick" SettingsCustomizationDialog-Enabled="true">
                        <ClientSideEvents ToolbarItemClick="onToolbarItemClick" />
         <CssClasses Table="table table-striped table-condensed" />
        <SettingsPager PageSize="10" />
        <SettingsDetail ShowDetailRow="true" AllowOnlyOneMasterRowExpanded="true" />
        <Settings ShowHeaderFilterButton="True" />
        <SettingsCookies Enabled="True" Version="0.125" StoreSearchPanelFiltering="False" StorePaging="False" />
        <Columns> 
            
            <dx:BootstrapGridViewTextColumn ShowInCustomizationDialog="false" Caption="" Name="View / Edit" VisibleIndex="0">
                <DataItemTemplate>
                    <asp:LinkButton ID="lbtEdit" EnableViewState="false" visible='<%#Eval("SignedFlows") = 0 And Eval("FinalisedFlows") = 0 %>' runat="server" CssClass="btn btn-default btn-sm" CausesValidation="False" ToolTip="Edit Sharing Summary" OnCommand="EditShare" CommandArgument='<%#Eval("DataFlowID")%>' Text=""><i aria-hidden="true" class="icon-pencil"></i></asp:LinkButton>
                    <asp:LinkButton ID="lbtView" EnableViewState="false" visible='<%#Eval("SignedFlows") > 0 Or Eval("FinalisedFlows") > 0 %>' runat="server" CssClass="btn btn-default btn-sm" CausesValidation="False" ToolTip="View Sharing Summary" OnCommand="EditShare" CommandArgument='<%#Eval("DataFlowID")%>' Text=""><i aria-hidden="true" class="icon-stack"></i></asp:LinkButton>
                </DataItemTemplate>
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn Caption="ISGID" FieldName="DataFlowID" HorizontalAlign="left" Name="ISGID" ReadOnly="True" VisibleIndex="1">
                <SettingsEditForm Visible="False" />
                <DataItemTemplate>
                <asp:Label EnableViewState="false" Font-Bold="true" ID="Label3" runat="server" Text='<%# PadID(Eval("DataFlowID"))%>'></asp:Label>
                    </DataItemTemplate>
                <Settings AllowHeaderFilter="False" />
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn Caption="Sharing Summary" FieldName="DFName"  HorizontalAlign="left" Name="Summary Name" ReadOnly="True" VisibleIndex="2">   
                            <Settings AllowHeaderFilter="False" />
            </dx:BootstrapGridViewTextColumn>  
            <dx:BootstrapGridViewTextColumn Name="Status" ShowInCustomizationDialog="false" VisibleIndex="3">
                <DataItemTemplate>
                    <asp:Label ID="lblLocked" EnableViewState="false" runat="server" Visible='<%#Eval("SignedFlows") > 0 Or Eval("FinalisedFlows") > 0 %>'  ToolTip="Locked for editing - data flows finalised"><i aria-hidden="true" class="icon-lock"></i></asp:Label>
                </DataItemTemplate>
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn ShowInCustomizationDialog="false" Name="Data Flows" ReadOnly="True" VisibleIndex="4">
                <DataItemTemplate>
                    <asp:PlaceHolder EnableViewState="false" ID="PlaceHolder1" runat="server">
                        <asp:Label EnableViewState="false" ID="lblSharesBadge" ToolTip='<%#Eval("DataFlowCount").ToString & " flows"%>' CssClass="badge" runat="server" Text='<%#Eval("DataFlowCount")%>'></asp:Label></asp:PlaceHolder>
                </DataItemTemplate>
                            <Settings AllowHeaderFilter="False" />
            </dx:BootstrapGridViewTextColumn> 
          
            <dx:BootstrapGridViewTextColumn Caption="Asset Name" FieldName="DataAssetName" Name="Asset Name" Visible="false" ReadOnly="True" VisibleIndex="6">
                <CssClasses DataCell="small" />
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewDateColumn Caption="Added" FieldName="DFSummaryAdded" Name="Added" Visible="false" VisibleIndex="7">
                <CssClasses DataCell="small" />
            </dx:BootstrapGridViewDateColumn>
            <dx:BootstrapGridViewTextColumn FieldName="DFAddedBy" Visible="False" VisibleIndex="8" Caption="Added By User" Name="Added By User">
                <CssClasses DataCell="small" />
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn FieldName="AddedByOrg" ReadOnly="True" VisibleIndex="9" Caption="Added By Organisation" Name="Added By Organisation">
                <CssClasses DataCell="small" />
            </dx:BootstrapGridViewTextColumn>            
            <dx:BootstrapGridViewDateColumn FieldName="ReviewDate" ReadOnly="True" VisibleIndex="10">
                <DataItemTemplate>
                     <asp:Label EnableViewState="false" ID="Label1" runat="server" Text='<%# Eval("ReviewDate", "{0:d}")%>' CssClass='<%# IIf(Eval("OverDue") = 2 And Eval("DFArchivedDate").ToString.Length = 0, "small alert-danger", "small")%>'></asp:Label>
                </DataItemTemplate>
            </dx:BootstrapGridViewDateColumn>
            <dx:BootstrapGridViewDateColumn Caption="Archived" FieldName="DFArchivedDate" Name="Archived" VisibleIndex="11">
                <DataItemTemplate>
                    <asp:LinkButton EnableViewState="false" ID="lbtArchive" runat="server" CssClass="btn btn-danger btn-sm" CausesValidation="False" ToolTip="Archive Sharing Summary" OnCommand="ArchiveSummary" visible='<%# (((Session("UserRoleAdmin") Or Session("UserRoleSIRO") Or Session("UserRoleIAO") Or Session("UserRoleIGO")) And Eval("DFAddedByOrgID") = Session("UserOrganisationID")) Or Session("IsSuperAdmin")) And Eval("DFArchivedDate").ToString.Length = 0  %>' CommandArgument='<%#Eval("DataFlowID")%>'><i aria-hidden="true" class="icon-remove"></i></asp:LinkButton>
                    <div runat="server" enableviewstate="false" visible='<%#Eval("DFArchivedDate").ToString.Length > 0 %>' class="small"><asp:Label EnableViewState="false" ID="Label2" runat="server" CssClass="small" Text='<%# "Archived:<br/>" & Eval("DFArchivedDate", "{0:d}")%>'></asp:Label></div>
                </DataItemTemplate>
            </dx:BootstrapGridViewDateColumn>
            <dx:BootstrapGridViewTextColumn Caption="Orgs Inv." FieldName="OrgCount" Name="Organisations Involved" ReadOnly="True" Visible="False" VisibleIndex="5" HorizontalAlign="Center" >
                <Settings AllowHeaderFilter="False" />
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
        <Templates>
            <DetailRow>
                <div class="panel panel-default">
                    
                    <div class="panel-body">
                         <dx:BootstrapGridView Settings-GridLines="None" ID="bsgvFlowsForSummary" OnHtmlRowPrepared="bsgvFlowsForSummary_HtmlRowPrepared" OnBeforePerformDataSelect="bsgvFlowsForSummary_DataSelect" runat="server" AutoGenerateColumns="False" DataSourceID="dsFlowsForSummary" KeyFieldName="DataFlowID">
                     <CssClasses Table="table table-striped table-condensed" />
        <SettingsPager PageSize="10" />
                    <Columns>
                        <dx:BootstrapGridViewTextColumn Name="View / Edit" Caption="" VisibleIndex="0">
                            <DataItemTemplate>
                                 <asp:LinkButton EnableViewState="false" ID="lbtEdit" Visible='<%# Eval("Signatures") = 0 And Eval("Archived").ToString.Length = 0 And Eval("InDraft") And (Eval("InvolvesMyOrg") Or Eval("AddedByOrgID") = Session("UserOrganisationID"))%>' OnCommand="Edit_Click" CssClass="btn btn-default btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Edit data flow" runat="server"><i aria-hidden="true" class="icon-pencil"></i></asp:LinkButton>
                                <asp:LinkButton EnableViewState="false" ID="lbtView" Visible='<%# (Eval("Signatures") > 0 Or Not Eval("InDraft") Or Eval("Archived").ToString.Length > 0) And (Eval("InvolvesMyOrg") Or Eval("AddedByOrgID") = Session("UserOrganisationID"))%>' OnCommand="View_Click" CssClass="btn btn-default btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="View data flow" runat="server"><i aria-hidden="true" class="icon-file"></i></asp:LinkButton>

                            </DataItemTemplate>
                        </dx:BootstrapGridViewTextColumn>
                        <dx:BootstrapGridViewTextColumn FieldName="DataFlowID" HorizontalAlign="Left" Caption="Data Flow" Name="ISGID" ReadOnly="True" VisibleIndex="1">
                            <SettingsEditForm Visible="False" />
                            <DataItemTemplate>
                                <asp:Label EnableViewState="false" ID="Label1" Font-Bold="true"  runat="server" Text='<%# PadDFID(Eval("DataFlowID"))%>'></asp:Label> <asp:Label EnableViewState="false" ID="Label5" Font-Bold="false"  runat="server" Text='<%# Eval("DataFlowIdentifier")%>'></asp:Label>
                            </DataItemTemplate>
                           
                        </dx:BootstrapGridViewTextColumn>
                        <dx:BootstrapGridViewTextColumn Caption="DPO Review" FieldName="DPOReviewStatus" VisibleIndex="2">
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
                        <dx:BootstrapGridViewTextColumn Name="Status" VisibleIndex="3">
                            <DataItemTemplate>
                                <asp:label EnableViewState="false" runat="server" ID="lblStatusDraft" Visible='<%#Eval("InDraft") And Eval("Signatures") = 0%>' Tooltip="Draft"><i aria-hidden="true" class="icon-unlocked"></i></asp:label>
                               <asp:label EnableViewState="false"  runat="server" ID="lblStatusFinal" Visible='<%#Not Eval("InDraft") Or Eval("Signatures") > 0%>' Tooltip="Final"><i aria-hidden="true" class="icon-lock"></i></asp:label>
                                  
                            </DataItemTemplate>
                        </dx:BootstrapGridViewTextColumn>
                         <dx:BootstrapGridViewTextColumn Name="Status2" VisibleIndex="4">
                             <DataItemTemplate>
                                 <asp:label EnableViewState="false"  runat="server" ID="Label2" Visible='<%#Eval("AddedByOrganisation") = Session("UserOrganisationName")%>' Tooltip="Created By My Organisation"><i aria-hidden="true" class="icon-home"></i></asp:label>
                             
                             </DataItemTemplate>
                         </dx:BootstrapGridViewTextColumn>
                        <dx:BootstrapGridViewTextColumn Name="Status3" VisibleIndex="5">
                             <DataItemTemplate>
                                 <asp:label EnableViewState="false"  runat="server" ID="Label3" Visible='<%#Eval("MyOrgSigned") > 0%>' Tooltip="Signed Off By My Organisation"><i aria-hidden="true" class="icon-quill"></i> </asp:label>
                             </DataItemTemplate>
                         </dx:BootstrapGridViewTextColumn>
                        <dx:BootstrapGridViewTextColumn Name="Status4" VisibleIndex="6">
                             <DataItemTemplate>
                                 <span>
                                <asp:Label  ID="lblLocked" Font-Size="Smaller" EnableViewState="false"  Font-Bold="true" runat="server" Visible='<%#Not Eval("InDraft") Or Eval("Signatures") > 0%>' ToolTip='<%# Eval("Signatures") & "/" & (CInt(Eval("OrgsInvolved"))).ToString & " organisations signed"%>'><%# Eval("Signatures") & "/" & (CInt(Eval("OrgsInvolved"))).ToString%></asp:Label></span>
                             </DataItemTemplate>
                         </dx:BootstrapGridViewTextColumn>
                        <dx:BootstrapGridViewTextColumn Name="GDPR non-compliant" Caption="GDPR non-compliant" CssClasses-HeaderCell="icon-notification header-link hidden-header" FieldName="NonGDPRCompliant" VisibleIndex="7">
                <DataItemTemplate>
                    <asp:Label EnableViewState="false" runat="server" ID="Label3" Visible='<%#Eval("NonGDPRCompliant") = True %>' ToolTip="GDPR non-compliant consent model or conditions for sharing"><span class="text-danger"><i aria-hidden="true" class="icon-notification"></i></span> </asp:Label>
                </DataItemTemplate>
<CssClasses HeaderCell="icon-notification  header-link hidden-header"></CssClasses>

                <Settings AllowHeaderFilter="False" />
            </dx:BootstrapGridViewTextColumn>
                         <dx:BootstrapGridViewTextColumn FieldName="RiskRating" VisibleIndex="8">
                             <DataItemTemplate>
                                  <asp:Label EnableViewState="false" Width="90px" ID="lblHigh" Visible='<%# Eval("RiskRating") = "High"%>' tooltip="1 or more high risks identified or a significant number of medium risks" runat="server" CssClass="label label-danger" Text='<%# Eval("RiskRating")%>'></asp:Label>
                                <asp:Label EnableViewState="false" Width="90px" ID="lblSig" Visible='<%# Eval("RiskRating") = "Significant"%>' ToolTip="2 or more medium risks identified" runat="server" CssClass="label label-warning" Text='<%# Eval("RiskRating")%>'></asp:Label>
                                <asp:Label EnableViewState="false" Width="90px" ID="lblLow" Visible='<%# Eval("RiskRating") = "Low"%>' ToolTip="Only low risks and less than 3 medium risks identified" runat="server" CssClass="label label-success" Text='<%# Eval("RiskRating")%>'></asp:Label>
                                <asp:Label EnableViewState="false" Width="90px" ID="lblNone" Visible='<%# Eval("RiskRating") = "Not Assessed"%>' ToolTip="No risk assessment submitted" runat="server" CssClass="label label-default" Text='<%# Eval("RiskRating")%>'></asp:Label>
                             </DataItemTemplate>
                        </dx:BootstrapGridViewTextColumn>
 <dx:BootstrapGridViewDateColumn FieldName="AddedDate" Name="Added" Caption="Added" VisibleIndex="9">
                        </dx:BootstrapGridViewDateColumn>
<dx:BootstrapGridViewDateColumn FieldName="FirstSigned" VisibleIndex="8">
                        </dx:BootstrapGridViewDateColumn>
                        <dx:BootstrapGridViewTextColumn Name="Tools" Caption="Tools" VisibleIndex="10">
                            <DataItemTemplate>
                                <div class="btn-group pull-left" role="group" aria-label="...">
                                      <asp:LinkButton EnableViewState="false" ID="lbtExport" Visible='<%# Not Session("orgLicenceType") = "Free, limited licence" And (Eval("InvolvesMyOrg") Or Eval("AddedByOrgID") = Session("UserOrganisationID"))%>' OnCommand="Export_Click" CssClass="btn btn-default btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Export Data Sharing Agreement to PDF" runat="server"><i aria-hidden="true" class="icon-file-pdf-o"></i></asp:LinkButton>                
                                    <asp:LinkButton EnableViewState="false" ID="lbtCopy" Visible='<%# Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO") %>' OnCommand="Copy_Click" CssClass="btn btn-info btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Copy data flow" runat="server"><i aria-hidden="true" class="icon-copy"></i></asp:LinkButton>
                            <asp:LinkButton EnableViewState="false" ID="lbtDelete" Visible='<%# (((Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO")) And Eval("AddedByOrgID") = Session("UserOrganisationID")) Or Session("IsSuperAdmin")) And Eval("Archived").ToString.Length = 0 And Eval("InDraft") And Eval("Signatures") = 0 %>' OnCommand="DeleteFlow_Click" OnClientClick="return confirm('Are you sure you want to delete this data flow?');" CssClass="btn btn-danger btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Delete data flow" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-remove"></i></asp:LinkButton>
                        <asp:LinkButton EnableViewState="false" ID="lbtArchive" Visible='<%# (((Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO")) And Eval("AddedByOrgID") = Session("UserOrganisationID")) Or Session("IsSuperAdmin")) And Eval("Archived").ToString.Length = 0 And (Not Eval("InDraft") Or Eval("Signatures") > 0)  %>' OnCommand="Archive_Click" OnClientClick="return confirm('Are you sure you want to archive this data flow? If the flow is due to be reviewed, you should archive the summary instead to generate copies of the summary and associated flows.');" CssClass="btn btn-danger btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Archive data flow" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-trash"></i></asp:LinkButton>
                           
                                    </div>
                            </DataItemTemplate>
                        </dx:BootstrapGridViewTextColumn>
                         
                        
                    </Columns>
                </dx:BootstrapGridView>
                    </div>
                    <div class="panel-footer clearfix">
                         <asp:LinkButton ID="lbtAdd" Visible='<%#Eval("DFArchivedDate").ToString.Length = 0 %>' OnCommand="lbtAddDF_Click" CssClass="btn btn-primary pull-right" runat="server" CausesValidation="True"><i aria-hidden="true" class="icon-plus"></i> <b>Add Data Flow</b> </asp:LinkButton>
    
                    </div>
                </div>
                
        
            </DetailRow>
        </Templates>

<SettingsCustomizationDialog Enabled="True"></SettingsCustomizationDialog>

         <SettingsSearchPanel Visible="True" AllowTextInputTimer="false" />
    </dx:BootstrapGridView>
    <br />
      <asp:LinkButton ID="lbtAdd" cssclass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-plus"></i> <b>Add Summary</b> </asp:LinkButton>
    <asp:HiddenField ID="hfArchiveSummaryID" runat="server" />
        <div id="modalMessage" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">
                        <asp:Label ID="lblModalHeading" runat="server"></asp:Label></h4>
                </div>
                <div class="modal-body">
                    <p>
                        <asp:Label ID="lblModalText" runat="server"></asp:Label>
                    </p>

                </div>
                <div class="modal-footer">
                    <button id="ModalOK" runat="server" type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>

    <div id="modalArchive" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Archive Data Sharing Summary</h4>
                    
                </div>
                <div class="modal-body">
                    <p style="font-weight:bold;">What would you like to do?</p>
                    
                    <hr>
                    <div class="row">
                    <div class="col-sm-12"><p>If the data sharing is still taking place, and all of the data flows are still relevant, all should be archived and reviewed.</p> 
                        <ul>
                            <li>The existing summary and all of its data flows will be archived</li>
                            <li>Copies of the summary and data flows will be created ready for review and sign off.</li>
                        </ul>
                    </div>
                     <div class="col-sm-12">
<asp:LinkButton ID="lbtRecycleAll" CausesValidation="false" CommandArgument="1" CssClass="btn btn-success" runat="server">Archive and Review All</asp:LinkButton>
                         </div>
                        </div>
                    <hr>
                    <div class="row">
                    <div class="col-sm-12"><p>If the data sharing is still taking place, but the data flows have changed significantly or no data flows are currently recorded, the sharing summary should be archived and reviewed.</p>
                         <ul>
                             <li>The sharing summary and any existing <b>data flows will be archived</b></li>
                             <li>A copy of the summary will be created.</li>
                         </ul></div>
                    <div class="col-sm-12"><asp:LinkButton ID="lbtRecycleSummary" CausesValidation="false" CommandArgument="2" CssClass="btn btn-warning" runat="server">Archive All and Review Summary</asp:LinkButton>
                        </div>
                        </div>
                    <hr>
                    <div class="row">
                    <div class="col-sm-12"><p>If the data sharing is no longer taking place, the summary and all of its data flows should be archived.</p>
                        <ul>
                            <li>
                                The sharing summary and all of its data flows should be archived.
                            </li>
                        </ul>
                    </div>
                    <div class="col-sm-12"><asp:LinkButton ID="lbtArchiveConfirm" CausesValidation="false" CommandArgument="0" CssClass="btn btn-danger" runat="server">Archive All</asp:LinkButton>
                    </div></div>
                </div>
                <div class="modal-footer">
                    <button id="Button2" runat="server" type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    
</asp:Content>
