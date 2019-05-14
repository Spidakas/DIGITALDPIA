<%@ Page Title="" Language="vb" AutoEventWireup="false" ValidateRequest="false" MasterPageFile="~/Application.Master" CodeBehind="org_supported.aspx.vb" Inherits="InformationSharingPortal.org_supported" %>

<%@ Register Assembly="DevExpress.Web.Bootstrap.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>

<%@ Register Src="~/OrgDetailsModal.ascx" TagPrefix="uc1" TagName="OrgDetailsModal" %>

<%@ Register assembly="DevExpress.Web.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>
<%@ Register Src="~/GridviewControlPanel.ascx" TagPrefix="uc1" TagName="GridviewControlPanel" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="server">
    <h1>Supported Organisations</h1>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script>
        function onToolbarItemClickSO(s, e) {
            switch (e.item.name) {
                case "ExportSO":
                    var btn = document.getElementById('lbtExportDAList');
                   
                    btn.click();
            }
        }
        
    </script>
            
                    <asp:ObjectDataSource ID="dsSponsoredOrgs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.SponsorshipGridTableAdapter">
                       
                        <SelectParameters>
                            <asp:SessionParameter Name="UserEmail" SessionField="UserEmail" Type="String" />
                            <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                        </SelectParameters>
                       
                    </asp:ObjectDataSource>
                    <div class="row">
                <div class="col-sm-12">  
                    <div class="clearfix">
             <h3><asp:LinkButton ID="lbtExportDAList" ClientIDMode="Static" CssClass="hidden" ToolTip="Export table to Excel"  CausesValidation="false" runat="server"><i aria-hidden="true" class="icon-file-excel"></i> <b>Export to Excel</b> </asp:LinkButton></h3>
            </div>
                </div></div>
                    <dx:ASPxGridViewExporter ID="bsgvExporter" runat="server" GridViewID="bsgvSponsored" Landscape="true" FileName="ISGSponsoredOrgExport"></dx:ASPxGridViewExporter>
                    <div class="table-responsive">
                    <dx:BootstrapGridView ID="bsgvSponsored" runat="server" DataSourceID="dsSponsoredOrgs" KeyFieldName="SponsoredOrganisationID" EnableCallbackAnimation="True" CssClasses-Table="table table-striped" AutoGenerateColumns="False" SettingsCookies-Enabled="True" OnToolbarItemClick="GridViewCustomToolbar_ToolbarItemClick" SettingsCustomizationDialog-Enabled="true">
                        <ClientSideEvents ToolbarItemClick="onToolbarItemClickSO" />
                         <CssClasses Table="table table-striped" />
                        <SettingsPager PageSize="15"/>
                         <Settings ShowHeaderFilterButton="True" />
                        <SettingsCookies Enabled="True" Version="0.11" StoreSearchPanelFiltering="False" StorePaging="False" />
                        <Columns>
                            <dx:BootstrapGridViewTextColumn Caption="Organisation" FieldName="OrganisationName" Name="Organisation" ReadOnly="True" VisibleIndex="0">
                                <DataItemTemplate>
                                    <asp:Label ID="Label7" ToolTip="You do not have a user role at this organisation" Visible='<%# Not Eval("HasRole")%>' runat="server" Text='<%# Eval("OrganisationName")%>'></asp:Label>
                                            <asp:LinkButton EnableViewState="false" ToolTip="Switch to this organisation" OnCommand="lbtViewOrg_ClickCommand" ID="lbtGoToOrg" Visible='<%# Eval("HasRole")%>' runat="server" CommandArgument='<%# Eval("SponsoredOrganisationID")%>' Text='<%# Eval("OrganisationName")%>'></asp:LinkButton>
                                </DataItemTemplate>
                                <SettingsHeaderFilter Mode="CheckedList">
                                </SettingsHeaderFilter>
                            </dx:BootstrapGridViewTextColumn>
                            <dx:BootstrapGridViewDateColumn Caption="Registered" FieldName="Registered" Name="Registered" ReadOnly="True" VisibleIndex="1">
                                <SettingsHeaderFilter Mode="DateRangePicker">
                                </SettingsHeaderFilter>
                            </dx:BootstrapGridViewDateColumn>
                            <dx:BootstrapGridViewTextColumn Caption="Setup %" FieldName="OrganisationSetupPercent" Name="Setup Percent" ReadOnly="True" VisibleIndex="3">
                                <DataItemTemplate>
                                    <div class="progress" style="min-width: 100px;">
                                                <div id="Div1" runat="server" class='<%# GetProgClass((Eval("OrganisationSetupPercent")))%>' role="progressbar" aria-valuenow='<%# Eval("OrganisationSetupPercent")%>'
                                                    aria-valuemin="0" aria-valuemax="100" style='<%# "Width:" & Eval("OrganisationSetupPercent") & "%;"%>'>
                                                    <asp:Label ID="lblSetupPercent" runat="server" Text='<%# Eval("OrganisationSetupPercent") & "%"%>' ToolTip='<%# "DPIA organisation setup " & Eval("OrganisationSetupPercent") & "% complete."%>'></asp:Label>
                                                </div>
                                            </div>
                                </DataItemTemplate>
                            </dx:BootstrapGridViewTextColumn>
                            <dx:BootstrapGridViewDateColumn Caption="Requested" FieldName="RequestedOn" Name="Requested" VisibleIndex="4">
                                <SettingsHeaderFilter Mode="DateRangePicker">
                                </SettingsHeaderFilter>
                            </dx:BootstrapGridViewDateColumn>
                            
                            <dx:BootstrapGridViewTextColumn Caption="Assurance" FieldName="Assurance" Name="Assurance" ReadOnly="True" VisibleIndex="6">
                                <SettingsHeaderFilter Mode="CheckedList">
                                </SettingsHeaderFilter>
                                <DataItemTemplate>
                                    <asp:LinkButton EnableViewState="false" Enabled='<%# Not Eval("SponsoredOrganisationID") Is Nothing%>' ID="lbtViewOrgDetails" ToolTip="View organisation details" runat="server" OnCommand="ViewOrgDetails_Click" CommandArgument='<%# Eval("SponsoredOrganisationID")%>'>
                                                <asp:Label EnableViewState="false" ID="lblSignificant" Width="85px" runat="server" CssClass="label label-success" Visible='<%# Eval("Assurance") = "Significant"%>'>Significant</asp:Label>
                                                <asp:Label EnableViewState="false" ID="Label3" Width="85px" runat="server" CssClass="label label-warning" Visible='<%# Eval("Assurance") = "Limited"%>'>Limited</asp:Label>
                                                <asp:Label EnableViewState="false" ID="Label4" Width="85px" runat="server" CssClass="label label-danger" Visible='<%# Eval("Assurance") = "None"%>'>None</asp:Label>
                                                <asp:Label EnableViewState="false" ID="Label5" Width="85px" runat="server" CssClass="label label-default" Visible='<%# Eval("Assurance") = "Not submitted"%>'>Not submitted</asp:Label>
                                                <asp:Label EnableViewState="false" ID="Label6" Width="85px" runat="server" CssClass="label label-default" Visible='<%# Eval("Assurance") = "Expired"%>'>Expired</asp:Label>
                                        
                                            </asp:LinkButton>
                                    <asp:Label EnableViewState="false" ID="Label8" Width="85px" runat="server" CssClass="label label-default" Visible='<%# Eval("Assurance") = "DPIA Inactive"%>'>DPIA Inactive</asp:Label>
                                </DataItemTemplate>
                            </dx:BootstrapGridViewTextColumn>
                            <dx:BootstrapGridViewCheckColumn Caption="MOU Signed" FieldName="TierZeroSigned" Name="MOU Signed" ReadOnly="True" VisibleIndex="7">
                            </dx:BootstrapGridViewCheckColumn>
                            <dx:BootstrapGridViewCheckColumn Caption="Senior Officer" FieldName="HasSeniorUser" Name="Senior Officer" ReadOnly="True" VisibleIndex="8">
                            </dx:BootstrapGridViewCheckColumn>
                           
                        </Columns>
                         <Toolbars>
        <dx:BootstrapGridViewToolbar>
            <Items>
                <dx:BootstrapGridViewToolbarItem Command="ClearFilter" IconCssClass="glyphicon glyphicon-remove" Text="Clear filters" />
                <dx:BootstrapGridViewToolbarItem Command="ShowCustomizationDialog" Text="Customise Grid" IconCssClass="glyphicon glyphicon-list-alt" />
                <dx:BootstrapGridViewToolbarItem Command="Custom" Name="ExportSO" CssClass="btn btn-success" Text ="Export to Excel" IconCssClass="icon-file-excel" ToolTip="Export grid to Excel"/>
            </Items>
        </dx:BootstrapGridViewToolbar>
    </Toolbars>
                        <SettingsSearchPanel Visible="True" AllowTextInputTimer="false" />
                    </dx:BootstrapGridView>
                        </div>
   

                        
                    <div class="row clearfix">
                        <div class="col-xs-12">
                        <div class="clearfix">
                    <asp:LinkButton ID="lbtAddSponsored" CssClass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-signup"></i> Register New Supported Organisation</asp:LinkButton>
                     </div></div></div>

            <!-- Standard Modal Message  -->
            <div id="modalMessage" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="lblModalText" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <asp:Label ID="lblModalHeading" runat="server" Text="label"></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <p>
                                <asp:Label ID="lblModalText" runat="server" Text="label"></asp:Label></p>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                        </div>
                    </div>
                </div>
            </div>


        
    <asp:UpdatePanel ID="UpdatePanel3" UpdateMode="Conditional" ChildrenAsTriggers="false" runat="server">
        <ContentTemplate>
            <uc1:OrgDetailsModal runat="server" ID="OrgDetailsModal" />
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="bsgvSponsored" />
           
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
