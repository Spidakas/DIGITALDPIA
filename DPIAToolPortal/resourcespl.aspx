<%--<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="resourcespl.aspx.vb" Inherits="InformationSharingPortal.resourcespl" %>--%>
<%@ Register Assembly="DevExpress.Web.Bootstrap.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>
<%@ Register assembly="DevExpress.Web.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="server">
    <h1>Useful resources</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
     <script type="text/javascript">

         $(document).ready(function () {

             $('[data-toggle="popover"]').popover()

         });

    </script>
    <asp:ObjectDataSource ID="dsResources" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByAdminGroup" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_ResourcesTableAdapter">
        <SelectParameters>
            <asp:SessionParameter Name="AdminGroupID" DefaultValue="0" SessionField="OrgAdminGroupID" Type="Int32" />
            <asp:Parameter DefaultValue="True" Name="LoggedIn" Type="Boolean" />
            <asp:Parameter DefaultValue="False" Name="HasLicence" Type="Boolean" />
        </SelectParameters>
     </asp:ObjectDataSource>
     <dx:BootstrapGridView ID="bsgvResources" SettingsBehavior-AutoExpandAllGroups="true" Settings-GridLines="None" runat="server" AutoGenerateColumns="False" DataSourceID="dsResources" KeyFieldName="ResourceID" ClientSideEvents-EndCallback="doPopover" Settings-GroupFormat="{1} {2}">
        <SettingsBootstrap Striped="True" />
        <Settings ShowColumnHeaders="false" />
        <SettingsPager Visible="False" PageSize="1000">
        </SettingsPager>
        <Columns>
             <dx:BootstrapGridViewTextColumn FieldName="Category" GroupIndex="0" SortIndex="0" SortOrder="Ascending" VisibleIndex="0">
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn FieldName="ResourceName" Caption="Resource" VisibleIndex="1">
                
                <DataItemTemplate>
                      <%--resource name with link:--%>
                    <a runat="server" target="_blank" href='<%# Eval("URL") %>'><i aria-hidden="true" class='<%# Eval("Type")%>' runat="server"></i> <asp:Label ID="Label1" EnableViewState="false" runat="server" Text='<%# Eval("ResourceName")%>'></asp:Label></a>
                    <%--resource description tooltip:--%>
                    <span runat="server" enableviewstate="false" visible='<%# Eval("ResourceDescription").ToString.Length > 0%>'><a id="A1" enableviewstate="false" tabindex="0" title='<%# Eval("ResourceName")%>' runat="server" class="btn" role="button" data-toggle="popover" data-trigger="focus" data-placement="top" data-content='<%# Eval("ResourceDescription")%>'><i aria-hidden="true" class="icon-info"></i></a>
                    </span>
                    <%--"new" icon:--%>
                        <asp:Label EnableViewState="false" ID="lblNewBadge" Visible='<%# Eval("NewResource") %>' cssclass="label label-success" runat="server"><i class="glyphicon glyphicon-star" aria-hidden="true"></i> New &nbsp;<i class="glyphicon glyphicon-star" aria-hidden="true"></i></asp:Label>
               <asp:Label EnableViewState="false" ID="lblUpdatedBadge" Visible='<%# Eval("UpdatedResource") And Not Eval("NewResource") %>' cssclass="label label-warning" runat="server"><i class="glyphicon glyphicon-star" aria-hidden="true"></i> Updated &nbsp;<i class="glyphicon glyphicon-star" aria-hidden="true"></i></asp:Label>
                </DataItemTemplate>
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewDateColumn FieldName="Updated" VisibleIndex="3">
                <DataItemTemplate>
                     <asp:Label ID="Label2" EnableViewState="false" runat="server" Text='<%# Bind("Updated", "{0:d}") %>' CssClass="btn"></asp:Label><asp:LinkButton EnableViewState="false" ID="LinkButton1" OnCommand="ReportBroken_Click" CommandArgument='<%# Eval("ResourceID")%>' runat="server" ToolTip="Report broken link"><i aria-hidden="true" class="icon-unlink" runat="server"></i></asp:LinkButton>
                </DataItemTemplate>
            </dx:BootstrapGridViewDateColumn>
        </Columns>
        <SettingsSearchPanel Visible="True"/>
     </dx:BootstrapGridView>
   <div class="well well-sm">
    <h3>Disclaimer</h3>
     <p>Every effort is made to ensure that the information provided on this site is accurate and up to date, but no legal responsibility is accepted for any errors, omissions or misleading statements.</p>
<p>We do not accept any liability for the use made by you of the information; neither do we warrant that the supply of the information will be uninterrupted. The resource section is provided on an "as is" basis. All material accessed or downloaded from the resource section is obtained at your own risk. It is your responsibility to use appropriate anti-virus software.</p>
<p>Contextual links are provided to such sites where appropriate. The Data Protection Impact Assessment Tool is not responsible for, and cannot guarantee the accuracy of, information on sites that we do not manage; nor should the inclusion of a hyperlink be taken to mean we endorse the sites to which it points.</p>
</div>
     <!-- Standard Modal Message  -->
        <div id="modalMessage" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">
                            <asp:Label ID="lblModalHeading" runat="server" Text="Broken Link Reported"></asp:Label></h4>
                    </div>
                    <div class="modal-body">
                        <p>
                            Thank you for reporting this broken link. The DPIA Support Team have been alerted and will attempt to resolve as soon as possible.
                        </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                    </div>
                </div>
            </div>
        </div>


</asp:Content>
