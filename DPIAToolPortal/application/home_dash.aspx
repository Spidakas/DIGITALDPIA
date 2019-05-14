<%@ Page Title="" Language="vb" AutoEventWireup="false" ValidateRequest="false" MasterPageFile="~/Application.Master" CodeBehind="home_dash.aspx.vb" Inherits="InformationSharingPortal.home_dash" %>

<%@ Register Assembly="DevExpress.Web.Bootstrap.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>

<%@ Register Src="~/OrgDetailsModal.ascx" TagPrefix="uc1" TagName="OrgDetailsModal" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--data sharing grid--%>
    <script src="ammap/ammap.js"></script>
    <script src="ammap/maps/js/unitedKingdomLow.js"></script>
    <script src="ammap/themes/dark.js"></script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="server">
    <script src="../Scripts/bs.pagination.js"></script>
    <script src="../Scripts/jquery.loading.min.js"></script>
    <script type="text/javascript">
        function BindEvents() {
            $(document).ready(function () {
                $('.bs-pagination td table').each(function (index, obj) {
                    convertToPagination(obj)
                });
                $('[data-toggle="popover"]').popover();
            });
        };
    </script>
    <h1>Dashboard</h1>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="_mask" style="position: fixed; top: 0; left: 0; bottom: 0; right: 0; overflow: hidden; z-index: 99998; background-color: #000; opacity: .6; zoom: 1;"></div>
            <div id="_loading" class="line-pulse" style="position: absolute; width: 100px; height: 20px; top: 50%; left: 49%; z-index: 99999; text-align: center"></div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:HiddenField ID="hfOrgID" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="hfRegionID" ClientIDMode="Static" runat="server" />
    <asp:Panel ID="pnlPlaceholder" runat="server">
        <div class="row">
            <div class="col-md-6">
                <h3>Summary</h3>
                <asp:ObjectDataSource ID="dsDashboardSummary" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.dashboardTableAdapters.DashboardSummaryTableAdapter">
                    <SelectParameters>
                        <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <asp:DetailsView ID="dvDashboardSummary" runat="server" CssClass="table table-striped" GridLines="None" AutoGenerateRows="False" DataSourceID="dsDashboardSummary">
                    <Fields>
                        <asp:TemplateField HeaderText="Number of Supported Organisations:" SortExpression="SponsoredOrganisations">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtSponsoredOrg" runat="server" Text='<%# Eval("SponsoredOrganisations")%>' PostBackUrl="~/application/org_sponsored.aspx"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Number of Data Assets Registered:" SortExpression="DataAssets">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtAssets" runat="server" Text='<%# Eval("DataAssets")%>' PostBackUrl="~/application/inv_dataset_list.aspx"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Number of Organisations Sharing With:" SortExpression="SharingOrganisations">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtSharingOrgs" runat="server" Text='<%# IIf(Eval("ISGSharingOrganisations") < 0, "0", Eval("ISGSharingOrganisations"))%>' ToolTip='<%# Eval("ISGSharingOrganisations").ToString & " DPIA registered organisations" %>' PostBackUrl="~/application/summaries_list.aspx"></asp:LinkButton>
                                <small class="text-muted">(+<asp:Label ToolTip='<%# Eval("NonISGSharingOrganisations").ToString & " organisations not DPIA registered" %>' ID="Label6" runat="server" Text='<%# Eval("NonISGSharingOrganisations").ToString & " non-DPIA)"%>'></asp:Label></small>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Number of Data Sharing Summaries:" SortExpression="SharingSummaries">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtSharingSummaries" runat="server" Text='<%# Eval("SharingSummaries")%>' ToolTip='<%# Eval("SharingSummaries").ToString & " sharing summaries involving my organisation" %>' PostBackUrl="~/application/summaries_list.aspx"></asp:LinkButton>
                                <small class="text-muted">(<asp:Label ToolTip='<%# Eval("SummariesOwned").ToString & " summaries created by my organisation" %>' ID="Label6" runat="server" Text='<%# Eval("SummariesOwned").ToString & " owned)" %>'></asp:Label></small>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Number of Data Flows:" SortExpression="DataFlows">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtFlows" runat="server" Text='<%# Eval("DataFlows")%>' ToolTip='<%# Eval("DataFlows").ToString & " data flows involving my organisation" %>' PostBackUrl="~/application/flows_list.aspx?filter=0"></asp:LinkButton>
                                <small class="text-muted">(<asp:Label ToolTip='<%# Eval("FlowsOwned").ToString & " flows created by my organisation" %>' ID="Label6" runat="server" Text='<%# Eval("FlowsOwned").ToString & " owned)"%>'></asp:Label></small>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Draft Data Flows:" SortExpression="InDevelopment">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtFlows" runat="server" Text='<%# Eval("InDevelopment")%>' PostBackUrl="~/application/flows_list.aspx?filter=1"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Final Data Flows (unsigned or with sign-off requests):" SortExpression="CollectingSignatures">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtFlows" runat="server" Text='<%# Eval("DataFlows") - Eval("InDevelopment") - Eval("FullySigned")%>' PostBackUrl="~/application/flows_list.aspx?filter=2"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Final Signed Data Flows (no outstanding requests):" SortExpression="FullySigned">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtFlows" runat="server" Text='<%# Eval("FullySigned")%>' PostBackUrl="~/application/flows_list.aspx?filter=3"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Potentially Non-GDPR Compliant Flows" SortExpression="NonGDPRFlows">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtFlowsGDPR" runat="server" Text='<%# Eval("NonGDPRFlows")%>' PostBackUrl="~/application/flows_list.aspx?filter=4"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Fields>
                </asp:DetailsView>
                <!--[if lte IE 8]>
        <style>        #mapouter
        {
            display: none;
        }
    </style></div><div class="col-md-6">
<![endif]-->
                <%--data sharing grid--%>

                <h3>Data Sharing Matrix</h3>
                <asp:ObjectDataSource ID="dsOrgsSharing" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.dashboardTableAdapters.SharingOrgsTableAdapter">
                    <SelectParameters>
                        <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <div class="col-xs-12">
                  <div class="btn-group" role="group" aria-label="...">
              <asp:LinkButton ID="lbtClearFilters" CausesValidation="false" CssClass="btn btn-default" ToolTip="Clear table filters" runat="server"><i aria-hidden="true" class="image glyphicon glyphicon-remove"></i> Clear Filters</asp:LinkButton>&nbsp;&nbsp;
      
                 <asp:LinkButton ID="lbtExportDAList" CssClass="btn btn-success" ToolTip="Export table to Excel" CausesValidation="false" runat="server"><i aria-hidden="true" class="icon-file-excel"></i> <b>Export to Excel</b> </asp:LinkButton>
                   </div>
           </div>
                <div class="col-xs-12">
                    <dx:ASPxGridViewExporter ID="bsgvExporter" runat="server" GridViewID="bsgvOrgsSharing" Landscape="true" FileName="ISGSharingOrgsExport"></dx:ASPxGridViewExporter>

                    <div class="table-responsive">
                                <dx:BootstrapGridView Settings-GridLines="Horizontal" ID="bsgvOrgsSharing" runat="server" AutoGenerateColumns="False" DataSourceID="dsOrgsSharing" KeyFieldName="OrganisationID" SettingsPager-PageSize="15" SettingsBootstrap-Striped="True">
                                    <ClientSideEvents ToolbarItemClick="onToolbarItemClick" />
                                    <Settings ShowHeaderFilterButton="True" />
                                    <SettingsCookies Enabled="True" Version="0.12" StoreSearchPanelFiltering="False" StorePaging="False" />
                                    <SettingsBootstrap Striped="True" />
                                    <Settings GridLines="Horizontal" />
                                    <SettingsPager PageSize="15">
                                    </SettingsPager>
                                    <Columns>
                                        <dx:BootstrapGridViewTextColumn FieldName="ISGID" Visible="False" VisibleIndex="0">
                                        </dx:BootstrapGridViewTextColumn>
                                        <dx:BootstrapGridViewTextColumn Caption="Organisation" FieldName="OrganisationName" Name="Organisation" VisibleIndex="1">
                                            <Settings AllowHeaderFilter="False" />
                                        </dx:BootstrapGridViewTextColumn>
                                        <dx:BootstrapGridViewTextColumn Caption="Type" FieldName="OrgType" Name="Type" Visible="False" VisibleIndex="2">
                                        </dx:BootstrapGridViewTextColumn>
                                        <dx:BootstrapGridViewTextColumn Caption="ICO Num" FieldName="ICORegistrationNumber" Name="ICO Num" Visible="False" VisibleIndex="3">
                                        </dx:BootstrapGridViewTextColumn>
                                        <dx:BootstrapGridViewTextColumn Caption="MOU Signed" FieldName="TierZeroSigned" Name="MOU Signed" Visible="False" VisibleIndex="4">
                                        </dx:BootstrapGridViewTextColumn>
                                        <dx:BootstrapGridViewTextColumn FieldName="Flows" HorizontalAlign="Center" ReadOnly="True" VisibleIndex="5">
                                            <Settings AllowHeaderFilter="False" />
                                            <DataItemTemplate>
                                                <asp:LinkButton ID="lbtFlow" runat="server" EnableViewState="false" PostBackUrl='<%# "~/application/flows_list.aspx?orgid=" + Eval("OrganisationID").ToString()%>' Text='<%# Eval("Flows")%>'></asp:LinkButton>
                                            </DataItemTemplate>
                                        </dx:BootstrapGridViewTextColumn>
                                        <dx:BootstrapGridViewTextColumn FieldName="Assurance" ReadOnly="True" VisibleIndex="6">

                                            <DataItemTemplate>
                                                <div style="white-space: nowrap;">
                                                <asp:LinkButton ID="lbtViewOrgDetails" runat="server" CommandArgument='<%# Eval("OrganisationID")%>' Enabled='<%# Not Eval("OrganisationID") Is Nothing%>' EnableViewState="false" OnCommand="ViewOrgDetails_Click" ToolTip="View organisation details">
                                                    <asp:Label EnableViewState="false" Width="100px" ID="lblSignificant" runat="server" CssClass="label label-success" Visible='<%# Eval("Assurance") = "Significant"%>'>Significant</asp:Label>
                                                    <asp:Label EnableViewState="false" Width="100px" ID="Label3" runat="server" CssClass="label label-warning" Visible='<%# Eval("Assurance") = "Limited"%>'>Limited</asp:Label>
                                                    <asp:Label EnableViewState="false" Width="100px" ID="Label4" runat="server" CssClass="label label-danger" Visible='<%# Eval("Assurance") = "None"%>'>None</asp:Label>
                                                    <asp:Label EnableViewState="false" Width="100px" ID="Label1" runat="server" CssClass="label label-default" Visible='<%# Eval("Assurance") = "Expired"%>'>Expired</asp:Label>
                                                    <asp:Label EnableViewState="false" Width="100px" ID="Label5" runat="server" CssClass="label label-default" Visible='<%# Eval("Assurance") = "Not submitted"%>'>Not submitted</asp:Label>
                                                    <asp:Label EnableViewState="false" visible='<%# Eval("NewAssurance") = 1 %>' ID="lblNewBadge" ToolTip="New assurance in the last 3 months" cssclass="text-success" runat="server"> <i class="glyphicon glyphicon-flag" aria-hidden="true"></i></asp:Label>
                                                </asp:LinkButton></div>
                                                
                                                    <asp:Label EnableViewState="false" Width="100px" ID="Label2" runat="server" CssClass="label label-default" Visible='<%# Eval("Assurance") = "DPIA Inactive"%>'>DPIA Inactive</asp:Label>
                                            </DataItemTemplate>
                                        </dx:BootstrapGridViewTextColumn>

                                        <dx:BootstrapGridViewTextColumn FieldName="AssuranceType" Visible="False" VisibleIndex="7">
                                        </dx:BootstrapGridViewTextColumn>
                                        <dx:BootstrapGridViewTextColumn Caption="ICO Review" FieldName="ICORegReviewDate" Name="ICO Review" Visible="False" VisibleIndex="8">
                                        </dx:BootstrapGridViewTextColumn>
                                        <dx:BootstrapGridViewTextColumn Caption="IG Framework Vers" FieldName="IGComplianceVersion" Name="IG Framework Vers" Visible="False" VisibleIndex="9">
                                        </dx:BootstrapGridViewTextColumn>
                                        <dx:BootstrapGridViewTextColumn Caption="Compliance Score" FieldName="IGComplianceScore" Name="Compliance Score" Visible="False" VisibleIndex="10">
                                        </dx:BootstrapGridViewTextColumn>

                                    </Columns>
                                 
                                    <SettingsSearchPanel Visible="True" AllowTextInputTimer="false" />
                                </dx:BootstrapGridView>
                           </div>
                </div>
            </div>

            <div id="mapouter" class="col-md-6">
                <h3>Data Sharing Map</h3>
                <div id="mapdiv" style="background: #3f3f4f; color: #ffffff; width: 100%; height: 600px; font-size: 11px;">
                </div>
                <div class="well">


                    <div class="key-circle" style="background-color: #3ca9ff"></div>
                    = your organisation. 
                        <div class="key-circle" style="background-color: #62eafc"></div>
                    = supported organisations.
                        <div class="key-circle" style="background-color: #fa13ad"></div>
                    = data sharing partner organisations.
     <div class="key-circle" style="background-color: #62eafc; border-style: solid; border-width: 3px; border-color: #fa13ad;"></div>
                    = supported sharing partner.
                        <div class="key-circle" style="background-color: #050505"></div>
                    = other organisations.

                </div>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="false">
                    <ContentTemplate>
                        <asp:Button ID="btnGetOrgInfo" ClientIDMode="Static" runat="server" Text="Button" CssClass="hidden" />
                        <uc1:OrgDetailsModal runat="server" ID="OrgDetailsModal" />
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnGetOrgInfo" />
                        <asp:AsyncPostBackTrigger ControlID="bsgvOrgsSharing" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </asp:Panel>


    <asp:HiddenField ID="hfMapOrgID" ClientIDMode="Static" runat="server" />
    <script type="text/javascript">
        Sys.Application.add_load(BindEvents);
    </script>
    <script src="../Scripts/orgmap.js"></script>
</asp:Content>
