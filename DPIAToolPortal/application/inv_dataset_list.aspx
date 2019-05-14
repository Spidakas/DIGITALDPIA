<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="inv_dataset_list.aspx.vb" Inherits="InformationSharingPortal.inv_dataset_list" %>

<%@ Register Assembly="DevExpress.Web.Bootstrap.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<%@ Register Src="~/GridviewControlPanel.ascx" TagPrefix="uc1" TagName="GridviewControlPanel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/bootstrap-multiselect.css" rel="stylesheet" />

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="server">
    <h1>Data Inventory
       
    </h1>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  
    <script src="../Scripts/bsasper.js"></script>
    <script src="../Scripts/bootstrap/bootstrap-multiselect.js"></script>
    <script type="text/javascript">

        function BindEvents() {
            $(document).ready(function () {
                $('[data-toggle="popover"]').popover();
                $('.multiselect').multiselect();
                $('.multiselect-dt').multiselect(
                    {
                        onChange: function (option, checked, select) {
                            var opselected = $(option).val();
                            if (checked == true) {

                                if (opselected == '1') { $("#dvPersonal").collapse('show'); }
                                if (opselected == '2') { $("#dvPersonalSensitive").collapse('show'); }
                                
                            } else if (checked == false)
                                if (opselected == '1') { $("#dvPersonal").collapse('hide'); }
                            if (opselected == '2') { $("#dvPersonalSensitive").collapse('hide'); }
                        }
                    }
                   
                );
                $('.multiselect-dte').multiselect(
                    {
                        onChange: function (option, checked, select) {
                            var opselected = $(option).val();
                            if (checked == true) {

                                if (opselected == '1') { $("#dvPersonalEdit").collapse('show'); }
                                if (opselected == '2') { $("#dvPersonalSensitiveEdit").collapse('show'); }

                            } else if (checked == false)
                                if (opselected == '1') { $("#dvPersonalEdit").collapse('hide'); }
                            if (opselected == '2') { $("#dvPersonalSensitiveEdit").collapse('hide'); }
                        }
                    }

                );
                $("input, textarea").bsasper({
                    placement: "right", createContent: function (errors) {
                        return '<span class="text-danger">' + errors[0] + '</span>';
                    }
                });
            });
            $(document).on('change', '.btn-file :file', function () {
                var input = $(this),
                    numFiles = input.get(0).files ? input.get(0).files.length : 1,
                    label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
                input.trigger('fileselect', [numFiles, label]);
            });

            $(document).ready(function () {
                $('.btn-file :file').on('fileselect', function (event, numFiles, label) {
                    var input = $(this).parents('.input-group').find(':text'),
                        log = numFiles > 1 ? numFiles + ' files selected' : label;
                    if (input.length) {
                        input.val(log);
                    } else {
                        if (log) alert(log);
                    }
                });
            });
        };
        function pageLoad() {
            $('[data-toggle="tooltip"]').tooltip()
        }
    </script>
    <asp:HiddenField ID="hfIncludeInactive" Value="1" runat="server" />
    <asp:MultiView ID="mvInventory" runat="server" ActiveViewIndex="0">
               
        <asp:View ID="vInventoryList" runat="server">
            <div class="clearfix">
             <h3><asp:CheckBox ID="cbIncludeArchived" AutoPostBack="true" CssClass="pull-right no-bold-label small" Font-Bold="false" runat="server" Text=" Include Archived" /></h3>
            </div>
            <asp:HiddenField ID="hfCollapsibleState" runat="server" ClientIDMode="Static" />
           
            <asp:ObjectDataSource ID="dsOrganisationAssets" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ReportDataTableAdapters.isp_DataAssetInventoryTableAdapter">
                <SelectParameters>
                    <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                    <asp:ControlParameter ControlID="cbIncludeArchived" Name="IncludeInactive" PropertyName="Checked" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <asp:ObjectDataSource ID="dsSubjects" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActive" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DataSubjectsTableAdapter">
                
                <SelectParameters>
                    <asp:ControlParameter ControlID="hfIncludeInactive" Name="IncludeInactive" PropertyName="Value" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <asp:ObjectDataSource ID="dsFormats" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActive" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DataFormatTableAdapter" >
                <SelectParameters>
                    <asp:ControlParameter ControlID="hfIncludeInactive" Name="IncludeInactive" PropertyName="Value" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <asp:ObjectDataSource ID="dsTypes" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActive" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DataTypesTableAdapter">
                <SelectParameters>
                    <asp:ControlParameter ControlID="hfIncludeInactive" Name="IncludeInactive" PropertyName="Value" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <asp:ObjectDataSource ID="dsPIDItems" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByExcludeInactiveIsSensitive" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_PIDItemsTableAdapter">
                <SelectParameters>
                    <asp:Parameter DefaultValue="True" Name="ExcludeInactive" Type="Boolean" />
                    <asp:Parameter DefaultValue="False" Name="IsSensitive" Type="Boolean" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <asp:ObjectDataSource ID="dsPIDSensitiveItems" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByExcludeInactiveIsSensitive" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_PIDItemsTableAdapter">
                <SelectParameters>
                    <asp:Parameter DefaultValue="True" Name="ExcludeInactive" Type="Boolean" />
                    <asp:Parameter DefaultValue="True" Name="IsSensitive" Type="Boolean" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <asp:ObjectDataSource ID="dsPrivacyStatus" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.PrivacyStatusTableAdapter"></asp:ObjectDataSource>

            <div class="row">
                <div class="col-sm-12">
                    
                    <dx:BootstrapGridView ID="bsgvDataInventory" runat="server" DataSourceID="dsOrganisationAssets" PreviewFieldName="DataAssetName" KeyFieldName="DataAssetID" EnableCallbackAnimation="True" CssClasses-Table="table table-striped" AutoGenerateColumns="False" SettingsCookies-Enabled="True" OnToolbarItemClick="GridViewCustomToolbar_ToolbarItemClick" SettingsCustomizationDialog-Enabled="true">
                        <ClientSideEvents ToolbarItemClick="onToolbarItemClick" />
                        <CssClasses Table="table table-striped" />
                        <SettingsCookies Enabled="True" Version="0.113" StoreSearchPanelFiltering="False" StorePaging="False" />
                        <Columns>
                            <dx:BootstrapGridViewTextColumn ShowInCustomizationDialog="false" Name="Edit" VisibleIndex="0">
                                <DataItemTemplate>
                                    <asp:LinkButton ID="lbtEdit" runat="server" CausesValidation="False" visible='<%# Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO")%>' CommandArgument='<%# Eval("DataAssetID")%>' CommandName="Select" CssClass="btn btn-default" EnableViewState="false" OnCommand="lbtEdit_ClickCommand" ToolTip="Edit"><i aria-hidden="true" class="icon-pencil"></i><!--[if lt IE 8]>Edit<![endif]--></asp:LinkButton>
                                </DataItemTemplate>
                            </dx:BootstrapGridViewTextColumn>
                            <dx:BootstrapGridViewTextColumn Caption="ISGID" CssClasses-DataCell="text-bold" FieldName="ISGID" HorizontalAlign="Left" Name="ISGID" VisibleIndex="1">                          
                                <CssClasses DataCell="text-bold" />
                            </dx:BootstrapGridViewTextColumn>
                            <dx:BootstrapGridViewTextColumn Caption="Asset" FieldName="DataAssetName" Name="Asset" Settings-AllowHeaderFilter="True" VisibleIndex="2">
                                <Settings AllowHeaderFilter="True" />
                                <SettingsHeaderFilter Mode="CheckedList">
                                </SettingsHeaderFilter>
                                  <DataItemTemplate>
                                      <asp:Label ID="Label4" EnableViewState="false" runat="server" Text='<%# Eval("DataAssetName")%>'></asp:Label><asp:Label EnableViewState="false" ID="Label5" Visible='<%# Eval("AssetFiles") > 0%>' ToolTip='<%# Eval("AssetFiles") & " documents attached"%>' runat="server">&nbsp;&nbsp;<i aria-hidden="true" class="icon-attachment"></i> </asp:Label>
                                      </DataItemTemplate>
                            </dx:BootstrapGridViewTextColumn>
                            <dx:BootstrapGridViewTextColumn Caption="Unique Ref" Name="Unique Ref" FieldName="UniqueReference" Settings-AllowHeaderFilter="True" VisibleIndex="3">
                                <Settings AllowHeaderFilter="True" />
                                <SettingsHeaderFilter Mode="CheckedList">
                                </SettingsHeaderFilter>
                            </dx:BootstrapGridViewTextColumn>
                            <dx:BootstrapGridViewTextColumn FieldName="IAOEmail" Name="IAO Email" Caption="IAO Email" VisibleIndex="4">
                            </dx:BootstrapGridViewTextColumn>
                            <dx:BootstrapGridViewDateColumn Caption="Added" Name="Added" FieldName="AddedDate" Settings-AllowHeaderFilter="True" VisibleIndex="6">
                                <Settings AllowHeaderFilter="True" />
                                <SettingsHeaderFilter Mode="DateRangePicker">
                                </SettingsHeaderFilter>
                            </dx:BootstrapGridViewDateColumn>
                            
                            <dx:BootstrapGridViewTextColumn FieldName="DataTypes" Name="Data Types" Caption="Data Types" Visible="False" VisibleIndex="7">
                                 <Settings AllowHeaderFilter="True" />
                                <SettingsHeaderFilter Mode="CheckedList">
                                </SettingsHeaderFilter>
                            </dx:BootstrapGridViewTextColumn>
                            <dx:BootstrapGridViewTextColumn FieldName="Subjects" Name="Data Subjects" Caption="Data Subjects" Visible="False" VisibleIndex="8">
                                 <Settings AllowHeaderFilter="True" />
                                <SettingsHeaderFilter Mode="CheckedList">
                                </SettingsHeaderFilter>
                            </dx:BootstrapGridViewTextColumn>
                            <dx:BootstrapGridViewTextColumn FieldName="Formats" Name="Data Formats" Caption="Data Formats" Visible="False" VisibleIndex="9">
                                 <Settings AllowHeaderFilter="True" />
                                <SettingsHeaderFilter Mode="CheckedList">
                                </SettingsHeaderFilter>
                            </dx:BootstrapGridViewTextColumn>
                            <dx:BootstrapGridViewCheckColumn FieldName="Active" Settings-AllowHeaderFilter="True" VisibleIndex="10">
                                <Settings AllowHeaderFilter="False" />
                            </dx:BootstrapGridViewCheckColumn>
                            <dx:BootstrapGridViewTextColumn ShowInCustomizationDialog="false" Name="Archive" VisibleIndex="11">
                                <DataItemTemplate>
                                    <div runat="server" visible='<%# Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO")%>'>
                                        <asp:LinkButton ID="lbtArchive" runat="server" CausesValidation="False" CommandArgument='<%# Eval("DataAssetID")%>' CommandName="Archive" CssClass="btn btn-danger" EnableViewState="false" OnCommand="lbtArchive_ClickCommand" ToolTip="Archive" Visible='<%# Eval("Active")%>'><i aria-hidden="true" class="icon-remove"></i><!--[if lt IE 8]>Archive<![endif]--></asp:LinkButton>
                                        <asp:LinkButton ID="lbtUnarchive" runat="server" CausesValidation="False" CommandArgument='<%# Eval("DataAssetID")%>' CommandName="Unarchive" CssClass="btn btn-success" EnableViewState="false" OnCommand="lbtUnarchive_ClickCommand" ToolTip="Unarchive" Visible='<%# Not Eval("Active")%>'><i aria-hidden="true" class="icon-redo"></i><!--[if lt IE 8]>Archive<![endif]--></asp:LinkButton>
                                    </div>
                                </DataItemTemplate>
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
                        <SettingsCustomizationDialog Enabled="True" />
                        <SettingsSearchPanel Visible="True" AllowTextInputTimer="false" />
                    </dx:BootstrapGridView>
                    <dx:ASPxGridViewExporter ID="bsgvDataInventoryExporter" GridViewID="bsgvDataInventory" Landscape="true" FileName="DPIADataAssetExport"  runat="server">
                       
                    </dx:ASPxGridViewExporter>
                    <%--</ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="lbtUpdateFilter" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>--%>
                    <asp:LinkButton CausesValidation="false" ID="lbtAdd" min-width="25%" CssClass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-plus"></i> <b>Add Asset</b> </asp:LinkButton>

                </div>
            </div>

        </asp:View>
        <asp:View ID="vAddAsset" runat="server">


            <div class="panel panel-primary" style="padding: 2%;">
                <h2>Add Data Asset to Inventory</h2>
                <fieldset class="form-horizontal">


                    <div class="form-group">
                        <asp:Label ID="lblAssetName" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="tbAssetName">Asset Name:</asp:Label>

                        <div class="col-xs-8">
                            <asp:TextBox ID="tbAssetName" CssClass="form-control bsvalidate" runat="server" Text='<%# Bind("DataAssetName")%>' />
                            <asp:RequiredFieldValidator ValidationGroup="vgAddAsset" ID="rfvAssetName" runat="server" ErrorMessage="Required" ControlToValidate="tbAssetName" Text="*" SetFocusOnError="true" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="Label30" runat="server" CssClass="control-label col-xs-4" AssociatedControlID="ddPrivacyStatus">Discoverability:</asp:Label>
                        <div class="col-xs-8">
                            <div class="input-group">

                                <span class="input-group-btn" id="discoverabilitytip">
                                    <a tabindex="0" title="Discoverability" class="btn btn-default btn-tooltip" role="button" data-toggle="popover" data-container="body" data-trigger="focus" data-placement="auto" data-content="This will be used to set the discoverability of this data asset by other users. Public = details can be viewed by unauthenticated users. Authenticated DPIA / DPIA API Users = details can be viewed by logged in users any DPIA organisation and authenticated API requests. Private = details can only be viewed by users with roles at sharing partner organisations."><i aria-hidden="true" class="icon-info"></i></a>
                                </span>
                                <asp:DropDownList ID="ddPrivacyStatus" CssClass="form-control freeze-on-sign" runat="server" DataSourceID="dsPrivacyStatus" DataTextField="PrivacyStatus" DataValueField="PrivacyStatusID"></asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="lblArea" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="tbUniqueRef">Unique Reference:</asp:Label>
                        <div class="col-xs-8">
                            <asp:TextBox ID="tbUniqueRef" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="lblDescription" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="tbDescription">Description:</asp:Label>
                        <div class="col-xs-8">
                            <asp:TextBox ID="tbDescription" CssClass="form-control" runat="server" Rows="3" Text='<%# Bind("DataAssetDescription")%>' TextMode="MultiLine" />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="lblIAO" CssClass="control-label col-xs-4" runat="server" Text="Label" AssociatedControlID="gvAssetContacts">Asset contacts:</asp:Label>
                        <div class="col-xs-8">
                            <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Bind("InformationAssetOwnerEmail")%>' />
                            <asp:ObjectDataSource ID="dsAssetContacts" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DataAssetContactsTableAdapter" DeleteMethod="Delete" UpdateMethod="Update">
                                <DeleteParameters>
                                    <asp:Parameter Name="Original_DataAssetContactID" Type="Int32" />
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:SessionParameter Name="DAContactGroupID" SessionField="DAContactGroupID" Type="Int32" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="DataAssetContactGroupID" Type="Int32" />
                                    <asp:Parameter Name="ContactName" Type="String" />
                                    <asp:Parameter Name="ContactEmail" Type="String" />
                                    <asp:Parameter Name="Role" Type="String" />
                                    <asp:Parameter Name="IsIAO" Type="Boolean" />
                                    <asp:Parameter Name="PhoneNumber" Type="String" />
                                    <asp:Parameter Name="Original_DataAssetContactID" Type="Int32" />
                                </UpdateParameters>
                            </asp:ObjectDataSource>
                            <asp:GridView CssClass="table table-striped" HeaderStyle-CssClass="sorted-none" GridLines="None" EmptyDataText="No contacts have been added for this data asset. Click Add, below, to add some." ID="gvAssetContacts" runat="server" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="DataAssetContactID" DataSourceID="dsAssetContacts">
                                <Columns>
                                    <asp:TemplateField ShowHeader="False">
                                        <EditItemTemplate>
                                            <asp:LinkButton ID="lbtUpdate" runat="server" CssClass="btn btn-default btn-xs" ValidationGroup="vgEditContact" CausesValidation="True" CommandName="Update" ToolTip="Update"><i aria-hidden="true" class="icon-checkmark"></i></asp:LinkButton>
                                            &nbsp;<asp:LinkButton ID="lbtCancel" runat="server" CssClass="btn btn-default btn-xs" CausesValidation="False" CommandName="Cancel" ToolTip="Cancel"><i aria-hidden="true" class="icon-close"></i></asp:LinkButton>
                                            <%--<asp:HiddenField ID="hfAssetContactID" runat="server" Value='<%# Bind("DataAssetContactID") %>' />--%>
                                            <asp:HiddenField ID="hfDataAssetContactGroupID" runat="server" Value='<%# Bind("DataAssetContactGroupID")%>' />
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbtEdit" CssClass="btn btn-default btn-xs" runat="server" CausesValidation="False" ToolTip="Edit Contact" CommandName="Edit"><i aria-hidden="true" class="icon-pencil"></i><!--[if lt IE 8]>Edit<![endif]--></asp:LinkButton>

                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ContactName" ControlStyle-CssClass="form-control" HeaderText="Name" SortExpression="ContactName">
                                        <ControlStyle CssClass="form-control" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Email" SortExpression="ContactEmail">
                                        <EditItemTemplate>
                                            <asp:TextBox ID="tbEmailEdit" CssClass="form-control" runat="server" Text='<%# Bind("ContactEmail") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ValidationGroup="vgEditContact" ID="rfvEmail" Display="Dynamic" runat="server" ControlToValidate="tbEmailEdit" CssClass="bg-danger" ErrorMessage="The user name field is required." ToolTip="The user name field is required." Text="*" SetFocusOnError="true" />
                                            <asp:RegularExpressionValidator runat="server" ValidationGroup="vgEditContact" ID="revEmail" Display="Dynamic" CssClass="bg-danger" SetFocusOnError="true"
                                                ControlToValidate="tbEmailEdit" ValidationExpression="(?:[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*|'(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*')@(?:(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"
                                                ErrorMessage="A valid email address must be provided." ToolTip="A valid email address must be provided." Text="*" />
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <a runat="server" href='<%# "Mailto:" + Eval("ContactEmail")%>'>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("ContactEmail") %>'></asp:Label></a>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField SortExpression="PhoneNumber" DataField="PhoneNumber" HeaderText="Phone" ControlStyle-CssClass="form-control" />
                                    <asp:BoundField DataField="Role" ControlStyle-CssClass="form-control" HeaderText="Role" SortExpression="Role">
                                        <ControlStyle CssClass="form-control" />
                                    </asp:BoundField>
                                    <asp:CheckBoxField DataField="IsIAO" HeaderText="IAO" SortExpression="IsIAO" />
                                    <asp:TemplateField ShowHeader="False">

                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbtDelete" runat="server" CausesValidation="False" CssClass="btn btn-danger btn-xs" CommandName="Delete" ToolTip="Delete Contact"><i aria-hidden="true" class="icon-minus"></i></asp:LinkButton>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <HeaderStyle CssClass="sorted-none" />
                            </asp:GridView>
                            <asp:LinkButton ValidationGroup="vgAddContact" CausesValidation="false" ID="lbtContactAdd" min-width="25%" CssClass="btn btn-default pull-right" runat="server"><i aria-hidden="true" class="icon-user-add"></i> <b>Add contact</b> </asp:LinkButton>
                        </div>
                    </div>
                    <div class="form-group">
                          <asp:Label ID="Label3" AssociatedControlID="rptFiles" CssClass="control-label col-xs-4" runat="server" Text="Data asset documents:"></asp:Label>
                                <div class="col-xs-8">
                                    <div class="panel panel-default">
                                        <asp:ObjectDataSource ID="dsAssetFilesAdd" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_FilesByGroupTableAdapter">
                                <SelectParameters>
                                    <asp:SessionParameter Name="FileGroupID" SessionField="AssetFileGroupID" Type="Int32" />
                                </SelectParameters>
                            </asp:ObjectDataSource>

                                        <table class="table table-striped">
                                            <asp:Repeater ID="rptAssetFilesAdd" runat="server" DataSourceID="dsAssetFilesAdd">
                                                <HeaderTemplate>
                                                    <div class="table-responsive">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td>
                                                            <asp:HyperLink ID="hlFile" runat="server"
                                                                NavigateUrl='<%# Eval("FileID", "GetFile.aspx?FileID={0}")%>'>
                                                                <i id="I1" aria-hidden="true" class='<%# Eval("Type")%>' runat="server"></i>
                                                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("FileName")%>'></asp:Label>
                                                            </asp:HyperLink>
                                                        </td>
                                                        <td style="width: 20px">
                                                            <asp:LinkButton ID="lbtDelete" OnClientClick="return confirm('Are you sure you want delete this file?');" runat="server" CommandName="Delete" CommandArgument='<%# Eval("FileID")%>' CssClass="btn btn-danger btn-xs" ToolTip="Delete File" CausesValidation="false"><i aria-hidden="true" class="icon-minus"></i><!--[if lt IE 8]>Delete<![endif]--></asp:LinkButton></td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></div></FooterTemplate>
                                            </asp:Repeater>
                                            <tr runat="server" id="trNoFilesAdd" visible="false"><td>
                                                No files have been uploaded against this data asset. You may optionally use this feature to store data asset specific documents such as DPIAs.
                                                                                              </td></tr>
                                        </table>
                                    </div>
                                    <asp:Panel ID="Panel1" CssClass="input-group" runat="server">
                                        <span class="input-group-btn">
                                            <span class="btn btn-default btn-file">Browse&hellip;
                                                <asp:FileUpload AllowMultiple="true" ID="filAssetFileAdd" runat="server" />
                                            </span>
                                        </span>
                                        <input type="text" placeholder="Max 5 MB" class="form-control" readonly="readonly">
                                        <span class="input-group-btn">
                                            <asp:LinkButton ID="lbtUploadAssetFilesAdd" CausesValidation="false" CssClass="btn btn-default" runat="server"><i aria-hidden="true" class="icon-upload2"></i>  Upload</asp:LinkButton>
                                        </span>
                                    </asp:Panel>
                                    
                                </div>
                            </div>
                    <div class="form-group">
                        <asp:Label ID="lblTypes" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="listTypes">What types of data?</asp:Label>
                        <div class="col-xs-8">
                            <asp:ListBox ID="listTypes" runat="server" DataSourceID="dsTypes" DataTextField="DataType" DataValueField="DataTypeID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselect-dt"></asp:ListBox>
                        </div>
                    </div>
                    <asp:panel runat="server" ClientIDMode="Static" id="dvPersonal" CssClass="form-group collapse">
                        <div class="alert alert-warning clearfix">
                        <asp:Label ID="Label6" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="listTypes">Personal data items:</asp:Label>
                        <div class="col-xs-8">
                            <asp:ListBox ID="listPersonalItems" runat="server" DataSourceID="dsPIDItems" DataTextField="PIDItem" DataValueField="PIDItemID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselect"></asp:ListBox>
                        </div></div>
                    </asp:panel>
                    <asp:panel runat="server" ClientIDMode="Static" id="dvPersonalSensitive" CssClass="form-group collapse">
                        <div class="alert alert-danger clearfix">
                        <asp:Label ID="Label7" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="listPersonalSensitiveItems">Special Category data items:</asp:Label>
                        <div class="col-xs-8">
                            <asp:ListBox ID="listPersonalSensitiveItems" runat="server" DataSourceID="dsPIDSensitiveItems" DataTextField="PIDItem" DataValueField="PIDItemID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselect"></asp:ListBox>
                        </div></div>
                    </asp:panel>
                    <div class="form-group">
                        <asp:Label ID="lblSubjects" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="listSubjects">Who are the data subjects?</asp:Label>
                        <div class="col-xs-8">
                            <asp:ListBox ID="listSubjects" runat="server" DataSourceID="dsSubjects" DataTextField="DataSubject" DataValueField="DataSubjectID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselect"></asp:ListBox>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="lblFormats" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="listFormats">In what format is the data held?</asp:Label>
                        <div class="col-xs-8">
                            <asp:ListBox ID="listFormats" runat="server" DataSourceID="dsFormats" DataTextField="DataFormat" DataValueField="DataFormatID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselect"></asp:ListBox>
                        </div>
                    </div>

                    <div class="form-group">

                        <div class="col-xs-offset-4 col-xs-8">
                            <asp:LinkButton ID="lbtInsertAsset" ValidationGroup="vgAddAsset" CssClass="btn btn-primary" runat="server" CausesValidation="True" CommandName="Insert"><i aria-hidden="true" class="icon-plus"></i> Add asset</asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="lbtCancelInsert" CssClass="btn btn-default" runat="server" CausesValidation="False" CommandName="Cancel"><i aria-hidden="true" class="icon-close"></i> Cancel</asp:LinkButton>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="lblErrorHead" runat="server" Text="Error:" ForeColor="#CC3300" Font-Bold="True" Visible="False" /><asp:Label ID="lblErrorDetail" runat="server" Text="" ForeColor="#CC3300" Visible="False"></asp:Label>
                    </div>
                </fieldset>
            </div>

        </asp:View>
        <asp:View ID="vEdit" runat="server">

            <div class="panel panel-primary" style="padding: 2%;">
                <h3><small>Edit Data Asset Details</small></h3>
                <h2>
                    <asp:Label ID="lblAssetID" runat="server" Text="Label"></asp:Label></h2>
                <fieldset class="form-horizontal">

                    <div class="form-group">
                        <asp:Label ID="lblAssetNameEdit" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="tbAssetName">Asset Name:</asp:Label>

                        <div class="col-xs-8">
                            <asp:TextBox ID="tbAssetNameEdit" CssClass="form-control" runat="server" />
                            <asp:RequiredFieldValidator SetFocusOnError="true" Display="Dynamic" ID="rfvAssetNameEdit" runat="server" ValidationGroup="vgEditAsset" ErrorMessage="Required" ControlToValidate="tbAssetName" Text="*"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="Label2" runat="server" CssClass="control-label col-xs-4" AssociatedControlID="ddPrivacyStatusEdit">Discoverability:</asp:Label>
                        <div class="col-xs-8">
                            <div class="input-group">

                                <span class="input-group-btn" id="discoverabilitytip2">
                                    <a tabindex="0" title="Discoverability" class="btn btn-default btn-tooltip" role="button" data-toggle="popover" data-container="body" data-trigger="focus" data-placement="auto" data-content="This will be used to set the discoverability of this data asset by other users. Public = details can be viewed by unauthenticated users. Authenticated DPIA / DPIA API Users = details can be viewed by logged in users any DPIA organisation and authenticated API requests. Private = details can only be viewed by users with roles at sharing partner organisations."><i aria-hidden="true" class="icon-info"></i></a>
                                </span>
                                <asp:DropDownList ID="ddPrivacyStatusEdit" CssClass="form-control freeze-on-sign" runat="server" DataSourceID="dsPrivacyStatus" DataTextField="PrivacyStatus" DataValueField="PrivacyStatusID"></asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="Label2Edit" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="tbUniqueEdit">Unique identifier:</asp:Label>

                        <div class="col-xs-8">
                            <asp:TextBox ID="tbUniqueEdit" CssClass="form-control" runat="server" />
                            <asp:RequiredFieldValidator SetFocusOnError="true" Display="Dynamic" ID="RequiredFieldValidator1" runat="server" ValidationGroup="vgEditAsset" ErrorMessage="Required" ControlToValidate="tbAssetName" Text="*"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="lblDescriptionEdit" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="tbDescriptionEdit">Description:</asp:Label>
                        <div class="col-xs-8">
                            <asp:TextBox ID="tbDescriptionEdit" CssClass="form-control" runat="server" Rows="3" TextMode="MultiLine" />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="lblIAOEdit" CssClass="control-label col-xs-4" runat="server" Text="Label" AssociatedControlID="gvContactsEdit">IAO / Contacts:</asp:Label>
                        <div class="col-xs-8">
                            <asp:GridView CssClass="table table-striped" HeaderStyle-CssClass="sorted-none" GridLines="None" EmptyDataText="No contacts have been added for this data asset." ID="gvContactsEdit" runat="server" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="DataAssetContactID" DataSourceID="dsAssetContacts">
                                <Columns>
                                    <asp:TemplateField ShowHeader="False">
                                        <EditItemTemplate>
                                            <asp:LinkButton ID="lbtUpdate" runat="server" ValidationGroup="vgAddContactEdit" CssClass="btn btn-default btn-xs" CausesValidation="True" CommandName="Update" ToolTip="Update"><i aria-hidden="true" class="icon-checkmark"></i></asp:LinkButton>
                                            &nbsp;<asp:LinkButton ID="lbtCancel" runat="server" CssClass="btn btn-default btn-xs" CausesValidation="False" CommandName="Cancel" ToolTip="Cancel"><i aria-hidden="true" class="icon-close"></i></asp:LinkButton>
                                            <%--<asp:HiddenField ID="hfAssetContactID" runat="server" Value='<%# Bind("DataAssetContactID") %>' />--%>
                                            <asp:HiddenField ID="hfDataAssetContactGroupID" runat="server" Value='<%# Bind("DataAssetContactGroupID")%>' />
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbtEdit" CssClass="btn btn-default btn-xs" runat="server" CausesValidation="False" CommandName="Edit"><i aria-hidden="true" class="icon-pencil"></i><!--[if lt IE 8]>Edit<![endif]--></asp:LinkButton>

                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ContactName" ControlStyle-CssClass="form-control" HeaderText="ContactName" SortExpression="ContactName">
                                        <ControlStyle CssClass="form-control" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="ContactEmail" SortExpression="ContactEmail">
                                        <EditItemTemplate>
                                            <asp:TextBox ID="tbEmailEdit" CssClass="form-control" runat="server" Text='<%# Bind("ContactEmail") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ValidationGroup="vgAddContactEdit" ID="rfvEmail" SetFocusOnError="true" Display="Dynamic" runat="server" ControlToValidate="tbEmailEdit" CssClass="bg-danger" ErrorMessage="The user name field is required." ToolTip="The user name field is required." Text="*" />
                                            <asp:RegularExpressionValidator runat="server" ValidationGroup="vgAddContactEdit" ID="revEmail" SetFocusOnError="true" Display="Dynamic" CssClass="bg-danger"
                                                ControlToValidate="tbEmailEdit" ValidationExpression="(?:[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*|'(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*')@(?:(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"
                                                ErrorMessage="A valid email address must be provided." ToolTip="A valid email address must be provided." Text="*" />
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <a id="A1" runat="server" href='<%# "Mailto:" + Eval("ContactEmail")%>'>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("ContactEmail") %>'></asp:Label></a>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Role" ControlStyle-CssClass="form-control" HeaderText="Role" SortExpression="Role">
                                        <ControlStyle CssClass="form-control" />
                                    </asp:BoundField>
                                    <asp:CheckBoxField DataField="IsIAO" HeaderText="IsIAO" SortExpression="IsIAO" />
                                    <asp:TemplateField ShowHeader="False">

                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbtDelete" runat="server" CausesValidation="False" CssClass="btn btn-danger btn-xs" CommandName="Delete" Text="Delete"><i aria-hidden="true" class="icon-minus"></i></asp:LinkButton>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <HeaderStyle CssClass="sorted-none" />
                            </asp:GridView>
                            <asp:LinkButton ValidationGroup="vgAddContactEdit" CausesValidation="false" ID="lbtAddContactEdit" min-width="25%" CssClass="btn btn-default pull-right" runat="server"><i aria-hidden="true" class="icon-user-add"></i> <b>Add contact</b> </asp:LinkButton>
                        </div>
                    </div>
                    <div class="form-group">
                          <asp:Label ID="Label1" AssociatedControlID="rptFiles" CssClass="control-label col-xs-4" runat="server" Text="Data asset documents:"></asp:Label>
                                <div class="col-xs-8">
                                    <div class="panel panel-default">
                                        <asp:ObjectDataSource ID="dsAssetFiles" OnSelected="dsAssetFiles_Selected" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByGroupTypeAndID" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_FilesByGroupTableAdapter">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="assetfiles" Name="GroupType" Type="String" />
                                    <asp:SessionParameter Name="ID" SessionField="EditAssetID" Type="Int32" />
                                </SelectParameters>
                            </asp:ObjectDataSource>

                                        <table class="table table-striped">
                                            <asp:Repeater ID="rptFiles" runat="server" DataSourceID="dsAssetFiles">
                                                <HeaderTemplate>
                                                    <div class="table-responsive">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td>
                                                            <asp:HyperLink ID="hlFile" runat="server"
                                                                NavigateUrl='<%# Eval("FileID", "GetFile.aspx?FileID={0}")%>'>
                                                                <i id="I1" aria-hidden="true" class='<%# Eval("Type")%>' runat="server"></i>
                                                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("FileName")%>'></asp:Label>
                                                            </asp:HyperLink>
                                                        </td>
                                                        <td style="width: 20px">
                                                            <asp:LinkButton ID="lbtDelete" Visible='<%# Eval("OrganisationID") = Session("UserOrganisationID") Or Session("IsSuperAdmin")%>' OnClientClick="return confirm('Are you sure you want delete this file?');" runat="server" CommandName="Delete" CommandArgument='<%# Eval("FileID")%>' CssClass="btn btn-danger btn-xs" ToolTip="Delete File" CausesValidation="false"><i aria-hidden="true" class="icon-minus"></i><!--[if lt IE 8]>Delete<![endif]--></asp:LinkButton></td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></div></FooterTemplate>
                                            </asp:Repeater>
                                            <tr runat="server" id="trNoFiles" visible="false"><td>
                                                No files have been uploaded against this data asset. You may optionally use this feature to store data asset specific documents such as DPIAs.
                                                                                              </td></tr>
                                        </table>
                                    </div>
                                    <asp:Panel ID="pnlUpload" CssClass="input-group" runat="server">
                                        <span class="input-group-btn">
                                            <span class="btn btn-default btn-file">Browse&hellip;
                                                <asp:FileUpload AllowMultiple="true" ID="filAssetDocs" runat="server" />
                                            </span>
                                        </span>
                                        <input type="text" placeholder="Max 5 MB" class="form-control" readonly="readonly">
                                        <span class="input-group-btn">
                                            <asp:LinkButton ID="lbtUpload" CausesValidation="false" CssClass="btn btn-default" runat="server"><i aria-hidden="true" class="icon-upload2"></i>  Upload</asp:LinkButton>
                                        </span>
                                    </asp:Panel>
                                    
                                </div>
                            </div>
                   
                    <div class="form-group">
                        <asp:Label ID="lblTypesEdit" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="listTypesEdit">What types of data?</asp:Label>
                        <div class="col-xs-8">
                            <asp:ListBox ID="listTypesEdit" runat="server" DataSourceID="dsTypes" DataTextField="DataType" DataValueField="DataTypeID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselect-dte"></asp:ListBox>
                        </div>
                    </div>
                    <asp:panel runat="server" ClientIDMode="Static" id="dvPersonalEdit" CssClass="form-group collapse">
                        <div class="alert alert-warning clearfix">
                        <asp:Label ID="Label8" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="listPersonalItemsEdit">Personal data items:</asp:Label>
                        <div class="col-xs-8">
                            <asp:ListBox ID="listPersonalItemsEdit" runat="server" DataSourceID="dsPIDItems" DataTextField="PIDItem" DataValueField="PIDItemID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselect"></asp:ListBox>
                        </div></div>
                    </asp:panel>
                    <asp:panel runat="server" ClientIDMode="Static" id="dvPersonalSensitiveEdit" CssClass="form-group collapse">
                        <div class="alert alert-danger clearfix">
                        <asp:Label ID="Label9" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="listPersonalSensitiveItemsEdit">Special Category data items:</asp:Label>
                        <div class="col-xs-8">
                            <asp:ListBox ID="listPersonalSensitiveItemsEdit" runat="server" DataSourceID="dsPIDSensitiveItems" DataTextField="PIDItem" DataValueField="PIDItemID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselect"></asp:ListBox>
                        </div></div>
                    </asp:panel>
                    <div class="form-group">
                        <asp:Label ID="lblSubjectsEdit" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="listSubjectsEdit">Who are the data subjects?</asp:Label>
                        <div class="col-xs-8">
                            <asp:ListBox ID="listSubjectsEdit" runat="server" DataSourceID="dsSubjects" DataTextField="DataSubject" DataValueField="DataSubjectID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselect"></asp:ListBox>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="lblFormatsEdit" CssClass="control-label col-xs-4" runat="server" AssociatedControlID="listFormatsEdit">In what format is the data held?</asp:Label>
                        <div class="col-xs-8">
                            <asp:ListBox ID="listFormatsEdit" runat="server" DataSourceID="dsFormats" DataTextField="DataFormat" DataValueField="DataFormatID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselect"></asp:ListBox>
                        </div>
                    </div>


                    <div class="form-group">

                        <div class="col-xs-offset-4 col-xs-8">
                            <asp:LinkButton ID="lbtUpdateAsset" ValidationGroup="vgEditAsset" CssClass="btn btn-primary" runat="server" CausesValidation="True" CommandName="Insert"><i aria-hidden="true" class="icon-checkmark"></i> Update asset</asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="lbtCancelUpdate" CssClass="btn btn-default" runat="server" CausesValidation="False" CommandName="Cancel"><i aria-hidden="true" class="icon-close"></i> Cancel</asp:LinkButton>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="lblUpdateErrorHead" runat="server" Text="Error:" ForeColor="#CC3300" Font-Bold="True" Visible="False" /><asp:Label ID="lblUpdateErrorDetail" runat="server" Text="" ForeColor="#CC3300" Visible="False"></asp:Label>
                    </div>
                </fieldset>
            </div>

        </asp:View>
    </asp:MultiView>
    <div id="modalAddcontact" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">
                        <asp:Label ID="lblAddContactHeading" runat="server" Text="Add Asset Contact"></asp:Label></h4>
                </div>
                <div class="modal-body">
                    <div class="form-horizontal">
                        <div class="form-group">
                            <asp:Label ID="lblContactName" CssClass="col-md-4 control-label" runat="server" Text="Contact name:" AssociatedControlID="tbContactName"></asp:Label>
                            <div class="col-md-7">
                                <asp:TextBox ID="tbContactName" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblContactEmail" CssClass="col-md-4 control-label" runat="server" Text="E-mail address:" AssociatedControlID="tbContactEmail"></asp:Label>
                            <div class="col-md-7">
                                <asp:TextBox ID="tbContactEmail" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-md-1">
                                <asp:RequiredFieldValidator ID="rfvEmailAdd" SetFocusOnError="true" Display="Dynamic" runat="server" ControlToValidate="tbContactEmail" CssClass="bg-danger" ErrorMessage="The user name field is required." ToolTip="The user name field is required." Text="*" />
                                <asp:RegularExpressionValidator runat="server" ID="revEmailAdd" SetFocusOnError="true" Display="Dynamic" CssClass="bg-danger"
                                    ControlToValidate="tbContactEmail" ValidationExpression="(?:[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*|'(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*')@(?:(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"
                                    ErrorMessage="A valid email address must be provided." ValidationGroup="vgAddContact" ToolTip="A valid email address must be provided." Text="*" />
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblPhoneNumber" CssClass="col-md-4 control-label" runat="server" Text="Phone number:" AssociatedControlID="tbPhoneNumber"></asp:Label>
                            <div class="col-md-7">
                                <asp:TextBox ID="tbPhoneNumber" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblRole" CssClass="col-md-4 control-label" runat="server" Text="Role:" AssociatedControlID="tbRole"></asp:Label>
                            <div class="col-md-7">
                                <asp:TextBox ID="tbRole" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblIsIAO" CssClass="col-md-4 control-label" runat="server" Text="Is IAO?" AssociatedControlID="cbIsIAO"></asp:Label>
                            <div class="col-md-7">
                                <asp:CheckBox ID="cbIsIAO" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Cancel</button>
                    <asp:LinkButton CausesValidation="true" ValidationGroup="vgAddContact" CssClass="btn btn-primary pull-right" ID="lbtAddConfirm" runat="server">Add</asp:LinkButton>

                </div>
            </div>
        </div>
    </div>
    <!-- Standard Modal Message  -->
    <div id="modalMessage" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">
                        <asp:Label ID="lblModalHeading" runat="server" Text="Label"></asp:Label></h4>
                </div>
                <div class="modal-body">
                    <p>
                        <asp:Label ID="lblModalText" runat="server" Text="Label"></asp:Label>
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>
    <div id="modalConfirm" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="lblConfirmText" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">
                        <asp:Label ID="lblConfirmHeading" runat="server" Text="Archive Asset?"></asp:Label></h4>
                </div>
                <div class="modal-body">
                    <p>
                        <asp:Label ID="lblConfirmText" runat="server" Text="Are you sure that you wish to archive this asset?"></asp:Label>
                        <asp:HiddenField ID="hfAssetID" runat="server" />
                    </p>
                    <asp:Label ID="lblRemoveReason" AssociatedControlID="tbReason" CssClass="control-label" runat="server" Text="Comments:"></asp:Label>
                    <asp:TextBox ID="tbReason" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder="Reason for removal."></asp:TextBox>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><i aria-hidden="true" class="icon-close"></i>Cancel</button><asp:LinkButton ID="lbtConfirm" class="btn btn-primary" CausesValidation="false" runat="server"><i aria-hidden="true" class="icon-checkmark"></i> Confirm</asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        Sys.Application.add_load(BindEvents);

    </script>

</asp:Content>
