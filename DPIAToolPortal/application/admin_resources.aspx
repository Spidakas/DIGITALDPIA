<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="admin_resources.aspx.vb" Inherits="InformationSharingPortal.admin_resources" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="server">
    <h1>Manage Resources</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <script src="../Scripts/bsasper.js"></script>
    <script type="text/javascript">
        function BindEvents() {
            $(document).ready(function () {
                $('.bs-pagination td table').each(function (index, obj) {
                    convertToPagination(obj)
                });
                $('[data-toggle="popover"]').popover();
            });
            $("input, textarea").bsasper({
                placement: "right", createContent: function (errors) {
                    return '<span class="text-danger">' + errors[0] + '</span>';
                }
            });
            $(document).on('change', '.btn-file :file', function () {
                var input = $(this),
                    numFiles = input.get(0).files ? input.get(0).files.length : 1;
                label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
                input.trigger('fileselect', [numFiles, label]);
            });
            $('.btn-file :file').on('fileselect', function (event, numFiles, label) {

                var input = $(this).parents('.input-group').find(':text'),
                    log = numFiles > 1 ? numFiles + ' files selected' : label;

                if (input.length) {
                    input.val(log);
                } else {
                    if (log) alert(log);
                }

            });
          
        };
    </script>
    <script src="../Scripts/bs.pagination.js"></script>
    <asp:ObjectDataSource ID="dsResources" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByAdminGroupSA" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_ResourcesTableAdapter">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="False" Name="IsCentralSA" SessionField="IsCentralSA" Type="Boolean" />
            <asp:SessionParameter DefaultValue="0" Name="SuperAdminID" SessionField="SuperAdminID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:GridView ID="gvResources" CssClass="table table-striped" EmptyDataText="There are no resources to show. Please check back soon." AllowSorting="True" HeaderStyle-CssClass="sorted-none" GridLines="None" runat="server" AutoGenerateColumns="False" DataKeyNames="ResourceID" DataSourceID="dsResources">
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <ItemTemplate>
                    <asp:LinkButton ID="lbtEdit" CssClass="button-small btn btn-default" runat="server" CausesValidation="False" ToolTip="Edit" CommandArgument='<%# Eval("ResourceID")%>' CommandName="EditResource"><i aria-hidden="true" class="icon-pencil"></i><!--[if lt IE 8]>Edit<![endif]--></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Resource" SortExpression="ResourceName">
                <ItemTemplate>
                    <%--resource name with link:--%>
                    <a id="A1" runat="server" target="_blank" href='<%# Eval("URL") %>'><i id="I1" aria-hidden="true" class='<%# Eval("Type")%>' runat="server"></i>
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("ResourceName")%>'></asp:Label></a>
                    <%--resource description tooltip:--%>
                    <span id="Span1" runat="server" visible='<%# Eval("ResourceDescription").ToString.Length > 0%>'><a id="A2" tabindex="0" title='<%# Eval("ResourceName")%>' runat="server" class="btn" role="button" data-toggle="popover" data-trigger="focus" data-placement="top" data-content='<%# Eval("ResourceDescription")%>'><i aria-hidden="true" class="icon-info"></i></a>
                    </span>
                    <%--"new" icon:--%>
                     <asp:Label EnableViewState="false" ID="lblNewBadge" Visible='<%# Eval("NewResource") %>' cssclass="label label-success" runat="server"><i class="glyphicon glyphicon-star" aria-hidden="true"></i> New &nbsp;<i class="glyphicon glyphicon-star" aria-hidden="true"></i></asp:Label>
               <asp:Label EnableViewState="false" ID="lblUpdatedBadge" Visible='<%# Eval("UpdatedResource") And Not Eval("NewResource") %>' cssclass="label label-warning" runat="server"><i class="glyphicon glyphicon-star" aria-hidden="true"></i> Updated &nbsp;<i class="glyphicon glyphicon-star" aria-hidden="true"></i></asp:Label>
                 </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Updated" SortExpression="Updated">
                <ItemTemplate>
                    <asp:Label ID="lblUpdated" runat="server" Text='<%# Bind("Updated", "{0:d}") %>' CssClass="btn"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Type" SortExpression="Type">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Type") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblType" runat="server" Text='<%# Bind("Type") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Admin Group" SortExpression="AdminGroup">
                <ItemTemplate>
                    <asp:Label ID="lblAG" runat="server" Text='<%# Eval("AdminGroup") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Category" HeaderText="Category" SortExpression="Category" />
            <asp:BoundField DataField="RequiresFullLicence" HeaderText="Req Lic" SortExpression="RequiresFullLicence" />
            <asp:BoundField DataField="Active" HeaderText="Active" SortExpression="Active" />
            <asp:TemplateField ShowHeader="False">
                <ItemTemplate>
                    <asp:LinkButton ID="lbtRemoveResource" CausesValidation="false" CommandName="DeleteResource" CommandArgument='<%# Eval("ResourceID")%>' ToolTip="Delete Resource" OnClientClick="return confirm('Are you sure that you wish to COMPLETELY remove this resource?');" CssClass="btn btn-danger btn-sm" runat="server"><i aria-hidden="true" class="icon-remove"></i></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>

        <HeaderStyle CssClass="sorted-none"></HeaderStyle>
    </asp:GridView>
    <asp:ObjectDataSource ID="dsResourceTypes" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.adminTableAdapters.isp_ResourceTypesTableAdapter"></asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsAdminGroups" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActiveLimitedByAG" TypeName="InformationSharingPortal.adminTableAdapters.isp_AdminGroupsTableAdapter">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="False" Name="IsCentralSA" SessionField="IsCentralSA" Type="Boolean" />
            <asp:SessionParameter DefaultValue="0" Name="SuperAdminID" SessionField="SuperAdminID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4>Add Resource</h4>
        </div>
        <div class="panel-body">
            <div class="form-horizontal">
                <div class="form-group">
                    <asp:Label ID="lblResourceName" AssociatedControlID="tbResourceName" CssClass="col-md-4 control-label" runat="server" Text="Resource name:"></asp:Label>
                    <div class="col-xs-8">
                        <asp:TextBox ID="tbResourceName" CssClass="form-control" ValidationGroup="vgAddResource" runat="server"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvResourceName" ValidationGroup="vgAddResource" ControlToValidate="tbResourceName" runat="server" ErrorMessage="Required"></asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <asp:Label ID="lblResource" CssClass="col-md-4 control-label" AssociatedControlID="ResourcePathTextBox" Display="Dynamic" runat="server" Text="Resource URL:"></asp:Label>
                    <div class="col-xs-8">
                        <asp:TextBox ID="ResourcePathTextBox" Placeholder="Either type URL here..." ValidationGroup="vgAddResource" runat="server" Text='<%# Bind("ResourcePath")%>' CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvResourcePath" ValidationGroup="vgAddResource" ControlToValidate="ResourcePathTextBox" runat="server" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        <div class="input-group">
                            
                            
                            <span class="input-group-btn">
                                <span class="btn btn-default btn-file">Browse&hellip;
                                   <asp:FileUpload AllowMultiple="false" ID="fupResource" runat="server" />
                                </span>
                            </span>
                            <input type="text" placeholder="... or upload a file here" class="form-control" readonly="true">
                            <span class="input-group-btn">
                                <asp:LinkButton ID="lbtUploadResource" CausesValidation="true" ValidationGroup="vgResourceUpload" CssClass="btn btn-default" ToolTip="Upload Resource" runat="server"><i aria-hidden="true" class="icon-upload"></i> Upload</asp:LinkButton>
                            </span>
</div>
                    </div>
                </div>
                <div class="form-group">
                    <asp:Label ID="lblResourceType" AssociatedControlID="ddType" CssClass="col-md-4 control-label" runat="server" Text="Type:"></asp:Label>
                    <div class="col-xs-8">
                        <asp:DropDownList ID="ddType" CssClass="form-control" runat="server" DataSourceID="dsResourceTypes" DataTextField="TypeName" DataValueField="TypeCode"></asp:DropDownList>
                    </div>
                </div>
                <div class="form-group">
                    <asp:Label ID="lblResourceDesc" AssociatedControlID="tbResourceDesc" CssClass="col-md-4 control-label" runat="server" Text="Description (tooltip):"></asp:Label>
                    <div class="col-xs-8">
                        <asp:TextBox ID="tbResourceDesc" CssClass="form-control" TextMode="MultiLine" MaxLength="500" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="form-group">
                    <asp:Label ID="lblCategory" AssociatedControlID="tbCategory" CssClass="col-md-4 control-label" runat="server" Text="Category:"></asp:Label>
                    <div class="col-xs-8">
                        <asp:TextBox ID="tbCategory" CssClass="form-control" Text="Uncategorised" MaxLength="100" runat="server"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvCategory" ValidationGroup="vgAddResource" ControlToValidate="tbCategory" runat="server" ErrorMessage="Required"></asp:RequiredFieldValidator>
                </div>
                <div class="form-group">
                    <asp:Label ID="lblPrelogin" AssociatedControlID="cbPreLogin" CssClass="col-md-4 control-label" runat="server" Text="Available pre-login?"></asp:Label>
                    <div class="col-xs-8">
                        <asp:CheckBox ID="cbPreLogin" Checked="true" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <asp:Label ID="lblRequiresFullLicence" AssociatedControlID="cbRequiresFullLicence" CssClass="col-md-4 control-label" runat="server" Text="Requires full licence?"></asp:Label>
                    <div class="col-xs-8">
                        <asp:CheckBox ID="cbRequiresFullLicence" runat="server" />
                    </div>
                </div>
                <asp:Panel ID="pnlAGAdd" runat="server">
                    <div class="form-group">
                        <asp:Label ID="Label10" AssociatedControlID="ddAdminGroup" CssClass="col-md-4 control-label" runat="server" Text="Admin group:"></asp:Label>
                        <div class="col-xs-8">
                            <asp:DropDownList ID="ddAdminGroup" CssClass="form-control input-sm" AppendDataBoundItems="true" runat="server" DataSourceID="dsAdminGroups" DataTextField="GroupName" DataValueField="AdminGroupID">
                                <asp:ListItem Value="0" Text="All"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
        <div class="panel-footer clearfix">
            <asp:LinkButton ID="lbtUploadConfirm" CssClass="btn btn-primary pull-right" runat="server" CausesValidation="True" Text="+ Add" ValidationGroup="vgAddResource" />
        </div>
    </div>
    <div id="modalEditResource" class="modal fade">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Edit Resource</h4>
                </div>
                <div class="modal-body">
                  
                    <asp:HiddenField ID="hfResourceIDEdit" runat="server" />
                    <div class="form-horizontal">
                        <div class="form-group">
                            <asp:Label CssClass="col-md-4 control-label" ID="Label4" runat="server" Text="Name:" AssociatedControlID="tbResourceNameEdit"></asp:Label>
                            <div class="col-xs-8">
                                <asp:TextBox ID="tbResourceNameEdit" CssClass="form-control" ValidationGroup="vgEditResource" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvResNameEdit" ControlToValidate="tbResourceNameEdit" runat="server" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label CssClass="col-md-4 control-label" ID="Label5" runat="server" Text="URL:" AssociatedControlID="tbResourcePathEdit"></asp:Label>
                            <div class="col-xs-8">
                                <asp:TextBox ID="tbResourcePathEdit" CssClass="form-control" ValidationGroup="vgEditResource" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvResourcePathEdit" ControlToValidate="tbResourcePathEdit" runat="server" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                                <div class="input-group">
                            
                            
                            <span class="input-group-btn">
                                <span class="btn btn-default btn-file">Browse&hellip;
                                   <asp:FileUpload AllowMultiple="false" ID="fupResourceEdit" runat="server" />
                                </span>
                            </span>
                            <input type="text" placeholder="Upload a new file here" class="form-control" readonly="true">
                            <span class="input-group-btn">
                                <asp:LinkButton ID="lbtUploadResourceEdit" CausesValidation="true" ValidationGroup="vgResourceUpload" CssClass="btn btn-default" ToolTip="Upload Resource" runat="server"><i aria-hidden="true" class="icon-upload"></i> Upload</asp:LinkButton>
                            </span>
</div>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label CssClass="col-md-4 control-label" ID="Label6" runat="server" AssociatedControlID="ddTypeEdit" Text="Type:"></asp:Label>
                            <div class="col-xs-8">
                                <asp:DropDownList ID="ddTypeEdit" CssClass="form-control" runat="server" DataSourceID="dsResourceTypes" DataTextField="TypeName" DataValueField="TypeCode"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label CssClass="col-md-4 control-label" ID="Label7" runat="server" AssociatedControlID="tbResourceDescriptionEdit" Text="Description:"></asp:Label>
                            <div class="col-xs-8">
                                <asp:TextBox ID="tbResourceDescriptionEdit" CssClass="form-control" TextMode="MultiLine" MaxLength="500" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group">
                    <asp:Label ID="Label2" AssociatedControlID="tbCategoryEdit" CssClass="col-md-4 control-label" runat="server" Text="Category:"></asp:Label>
                    <div class="col-xs-8">
                        <asp:TextBox ID="tbCategoryEdit" CssClass="form-control" MaxLength="100" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvCatEdit" ControlToValidate="tbCategoryEdit" runat="server" Display="Dynamic" ErrorMessage="Required"></asp:RequiredFieldValidator>
                    </div>
                </div>
                        <div class="form-group">
                            <asp:Label ID="Label8" AssociatedControlID="cbPreLoginEdit" CssClass="col-md-4 control-label" runat="server" Text="Available pre-login?"></asp:Label>
                            <div class="col-xs-8">
                                <asp:CheckBox ID="cbPreLoginEdit" runat="server" />
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="Label11" AssociatedControlID="cbRequiresFullLicenceEdit" CssClass="col-md-4 control-label" runat="server" Text="Requires full licence?"></asp:Label>
                            <div class="col-xs-8">
                                <asp:CheckBox ID="cbRequiresFullLicenceEdit" runat="server" />
                            </div>
                        </div>
                        <asp:Panel ID="pnlAGEdit" runat="server">
                            <div class="form-group">
                                <asp:Label ID="Label9" AssociatedControlID="ddAdminGroupEdit" CssClass="col-md-4 control-label" runat="server" Text="Admin group:"></asp:Label>
                                <div class="col-xs-8">
                                    <asp:DropDownList ID="ddAdminGroupEdit" AppendDataBoundItems="true" CssClass="form-control input-sm"  runat="server" DataSourceID="dsAdminGroups" DataTextField="GroupName" DataValueField="AdminGroupID">
                                        <asp:ListItem Text="All" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </asp:Panel>
                    </div>

                </div>
                <div class="modal-footer">
                    <asp:LinkButton ID="lbtEditOK" CausesValidation="True" ValidationGroup="vgEditResource" CssClass="btn btn-primary pull-right" runat="server">OK</asp:LinkButton>
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        
        Sys.Application.add_load(BindEvents);
    </script>
</asp:Content>
