<%@ Page Title="" Language="vb" ValidateRequest="false" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="dataflow_summary.aspx.vb" Inherits="InformationSharingPortal.dataflow_summary" MaintainScrollPositionOnPostback="true" %>

<%@ Register Src="~/OrgDetailsModal.ascx" TagPrefix="uc1" TagName="OrgDetailsModal" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/bootstrap-multiselect.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="server">
    <h1>Data Sharing Summary</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <script src="../Scripts/bs.pagination.js"></script>
    <script src="../Scripts/bootstrap/bootstrap-multiselect.js"></script>
    <link href="https://gitcdn.github.io/bootstrap-toggle/2.2.0/css/bootstrap-toggle.min.css" rel="stylesheet">
    <script src="https://gitcdn.github.io/bootstrap-toggle/2.2.0/js/bootstrap-toggle.min.js"></script>
    <script src="../Scripts/bsasper.js"></script>
    <script src="../Scripts/autosize.min.js"></script>
    <script>
        function doMultiSelect() {
            $('.multiselector').multiselect();
            $('.multiselect-dt').multiselect(
                {                    
                    onChange: function (option, checked, select) {
                        var pnl2 = false;
                        var pnl3 = false;
                        $.each($('.multiselect-dt > option:selected'), function () {
                            //alert($(this).text());
                            if ($(this).text() == 'Personal') {
                                pnl2 = true;
                            }
                            if ($(this).text() == 'Personal Sensitive' || $(this).text() == 'Special Category Personal Data') {
                                pnl2 = true;
                                pnl3 = true
                            }
                        });
                        if (pnl2) { $("#pnlSchedTwo").collapse('show'); } else { $("#pnlSchedTwo").collapse('hide');};
                        if (pnl3) { $("#pnlSchedThree").collapse('show'); } else { $("#pnlSchedThree").collapse('hide'); };;

                       }
                }

            );
        };
    </script>
    <script type="text/javascript">
        function BindEvents() {
            $("#pnlSchedTwo").collapse({ 'toggle': false });
            $("#pnlSchedThree").collapse({ 'toggle': false });
            $(document).ready(function () {
                $('.bs-pagination td table').each(function (index, obj) {
                    convertToPagination(obj)
                });
                autosize($('input, textarea'));
                //Lets do bootstrap form validation:
                $("input, textarea").bsasper({
                    placement: "right", createContent: function (errors) {
                        return '<span class="text-danger">' + errors[0] + '</span>';
                    }
                });
                
                doMultiSelect();
                $('[data-toggle="popover"]').popover();
                $(".date-picker").datepicker({ dateFormat: 'dd/mm/yy' });
                //$('input, textarea').placeholder({ customClass: 'my-placeholder' });
                $('.btn-file :file').on('fileselect', function (event, numFiles, label) {

                    var input = $(this).parents('.input-group').find(':text'),
                        log = numFiles > 1 ? numFiles + ' files selected' : label;

                    if (input.length) {
                        input.val(log);
                    } else {
                        if (log) alert(log);
                    }

                });
                //$('.toggleme').bootstrapToggle();
                //$("body").scrollspy({ target: "#MainContent_myScrollNav" })
            });
            $(document).on('change', '.btn-file :file', function () {
                var input = $(this),
                    numFiles = input.get(0).files ? input.get(0).files.length : 1,
                    label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
                input.trigger('fileselect', [numFiles, label]);
            });
        };
    </script>
    <asp:HiddenField ID="hfOwnedByOrganisationID" runat="server" />
    <asp:HiddenField ID="hfOrgGroupID" runat="server" />
    <asp:HiddenField ID="hfReadOnly" runat="server" Value="0" />
    <asp:HiddenField ID="hfSummaryID" runat="server" Value="0" />
    <asp:HiddenField ID="hfSummaryFileGroup" runat="server" Value="0" />
    <asp:HiddenField ID="hfDFFrozen" runat="server" />
    <div class="container">
        <div class="row">
            <div id="divFreeWarning" runat="server" class="alert alert-danger alert-dismissible" visible="false" role="alert"><button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span></button>
                <asp:Label ID="Label29" runat="server" Text="Label"><b>WARNING:</b> Organisations accessing under a "free" DPIA licence create data sharing agreements at risk. There are no guarantees of continued access to your sharing agreements when using the DPIA under a "free" licence. To discuss licencing options for your organisation please contact <a href=',ailto:isg@mbhci.nhs.uk'>isg@mbhci.nhs.uk</a>.</asp:Label>
            </div>
            <div id="form-content" class="col-xs-12 scroll-area">
                <asp:Panel ID="pnlSummary" runat="server">
                    <h2 id="summary">
                        <asp:Label ID="lblFormTitle" runat="server" Text="Add New Data Sharing Summary"></asp:Label>
                        <button runat="server" id="btnHistory" title="View Transaction History" type="button" class="btn btn-default" data-toggle="modal" data-target="#modalHistory"><i aria-hidden="true" class="icon-clock"></i></button>
                    </h2>
                    <hr />
                    <div class="form-horizontal">
                        <div class="form-group">
                            <asp:Label ID="Label1" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="tbDataflowName">Data share name / identifier:</asp:Label>
                            <div class="col-xs-7">
                                <div class="input-group">
                                    <asp:TextBox CssClass="form-control freeze-on-sign" runat="server" ID="tbDataflowName" MaxLength="100" /><span class="input-group-btn">
                                        <a tabindex="0" title="Name / identifier" class="btn btn-default btn-tooltip" role="button" data-toggle="popover" data-container="body" data-trigger="focus" data-placement="auto" data-content="The name / identifier should enable you and your colleagues to identify the data flow at a glance. Using a consistent approach will aid in locating the data flow at a later date. Your organisation may have a policy on naming conventions which could be relevant to your choice of name / identifier."><i aria-hidden="true" class="icon-info"></i></a>
                                    </span>
                                </div>
                                <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbDataflowName" ID="rxvDataflowName" ValidationExpression="^[\s\S]{0,100}$" runat="server" ErrorMessage="Maximum 100 characters."></asp:RegularExpressionValidator>
                                <asp:RequiredFieldValidator Display="Dynamic" ID="RequiredFieldValidator2" runat="server" ControlToValidate="tbDataflowName"
                                    CssClass="bg-danger" ErrorMessage="The data sharing summary name field is required." SetFocusOnError="True" />
                            </div>
                        </div>
                        <div class="form-group">
                              <asp:Label ID="Label30" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="ddPrivacyStatus">Discoverability level:</asp:Label>
                            <div class="col-xs-7">
                                <div class="input-group">
                                    <span class="input-group-btn" id="discoverabilitytip">
                                        <a tabindex="0" title="Discoverability level" class="btn btn-default btn-tooltip" role="button" data-toggle="popover"  data-container="body" data-trigger="focus" data-placement="auto" data-content="This will be used to set the discoverability of this sharing summary by other users. Public = details can be viewed by unauthenticated users. Authenticated DPIA / DPIA API Users = details can be viewed by logged in users any DPIA organisation and authenticated API requests. Private = details can only be viewed by users with roles at sharing partner organisations."><i aria-hidden="true" class="icon-info"></i></a>
                                    </span>
                                    <asp:DropDownList ID="ddPrivacyStatus" CssClass="form-control freeze-on-sign" runat="server" DataSourceID="dsPrivacyStatus" DataTextField="PrivacyStatus" DataValueField="PrivacyStatusID"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label ID="Label5" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="gvOrganisations">Organisations involved:</asp:Label>
                            <div class="col-xs-7">
                                <asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="true">
                                    <ContentTemplate>
                                        <div class="panel panel-default">
                                            <asp:ObjectDataSource ID="dsQuickSelectOrgs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetSoFarUnused" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_AssociatedOrganisationsTableAdapter">
                                                <SelectParameters>
                                                    <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                                                    <asp:ControlParameter Name="OrgGroupID" ControlID="hfOrgGroupID" DefaultValue="-1" Type="Int32" />
<%--                                            <asp:SessionParameter DefaultValue="-1" Name="OrgGroupID" SessionField="OrgGroupID" Type="Int32" />--%>
                                                </SelectParameters>
                                            </asp:ObjectDataSource>
                                            <asp:Label ID="lblQuickAddOrg" AssociatedControlID="listQuickAccess" runat="server" CssClass="control-label small filter-col" Text="Quick add:"></asp:Label>
                                            <asp:ListBox ID="listQuickAccess" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector small no-freeze" runat="server" DataSourceID="dsQuickSelectOrgs" DataTextField="OrganisationName" DataValueField="OrganisationID"></asp:ListBox>
                                            <asp:Label ID="Label25" AssociatedControlID="cbProvidingQuickAdd" runat="server" CssClass="control-label small filter-col" Text="providing:"></asp:Label><asp:CheckBox ID="cbProvidingQuickAdd" ThreeState="true" CheckState="Indeterminate" runat="server" ToolTip="Providing" />
                                            <asp:Label ID="Label26" AssociatedControlID="cbReceivingQuickAdd" runat="server" CssClass="control-label small filter-col" Text="receiving:"></asp:Label><asp:CheckBox ID="cbReceivingQuickAdd" runat="server" ToolTip="Receiving" />
                                            <asp:LinkButton ID="lbtAddSelected" CausesValidation="false" ToolTip="Add selected organisations" CssClass="btn btn-success pull-right" runat="server"><i aria-hidden="true" class="icon-plus"></i> <b>Add</b></asp:LinkButton>
                                        </div>
                                        <div class="panel panel-default">
                                            <asp:ObjectDataSource ID="dsOrganisations" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DF_OrganisationsTableAdapter" UpdateMethod="UpdateDFOrg" DeleteMethod="DeleteDFOrg">
                                                <DeleteParameters>
                                                    <asp:Parameter Name="Original_DF_OrgID" Type="Int32" />
                                                </DeleteParameters>
                                                <SelectParameters>
                                                     <asp:ControlParameter Name="OrgGroupID" ControlID="hfOrgGroupID" DefaultValue="-1" Type="Int32" />
                                                    <%--<asp:SessionParameter DefaultValue="0" Name="OrgGroupID" SessionField="OrgGroupID" Type="Int32" />--%>
                                                </SelectParameters>
                                                <UpdateParameters>
                                                    <asp:Parameter Name="Providing" Type="Boolean" />
                                                    <asp:Parameter Name="Receiving" Type="Boolean" />
                                                    <asp:Parameter Name="Original_DF_OrgID" Type="Int32" />
                                                </UpdateParameters>
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
                                            <div style="font-size: 85%;" class="table-responsive">
                                                <asp:GridView ID="gvOrganisations" CssClass="table table-striped" EmptyDataText="There are no organisations associated with this data sharing summary. Click Add below to add some." AllowSorting="True" HeaderStyle-CssClass="sorted-none" GridLines="None" runat="server" AutoGenerateColumns="False" DataKeyNames="DF_OrgID" DataSourceID="dsOrganisations">
                                                    <Columns>
                                                        <asp:TemplateField ShowHeader="False">
                                                            <EditItemTemplate>
                                                                <asp:LinkButton ID="lbtUpdate" runat="server" CssClass="btn btn-success btn-sm" CausesValidation="False" CommandName="Update" Text="Update"><i aria-hidden="true" class="icon-checkmark"></i></asp:LinkButton>
                                                                &nbsp;
                                                                <asp:LinkButton ID="lbtCancel" runat="server" CssClass="btn btn-danger btn-sm" CausesValidation="False" CommandName="Cancel" Text="Cancel"><i aria-hidden="true" class="icon-cross"></i></asp:LinkButton>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtEdit" runat="server" CssClass="btn btn-default btn-sm freeze-on-sign" CausesValidation="False" CommandName="Edit" Text=""><i aria-hidden="true" class="icon-pencil"></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="DF_OrgID" HeaderText="DF_OrgID" InsertVisible="False" ReadOnly="True" SortExpression="DF_OrgID" />
                                                        <asp:BoundField DataField="DF_OrgGroupID" HeaderText="DF_OrgGroupID" ReadOnly="True" SortExpression="DF_OrgGroupID" />
                                                        <asp:BoundField DataField="OrganisationID" HeaderText="OrganisationID" ReadOnly="True" SortExpression="OrganisationID" />
                                                        <asp:TemplateField HeaderText="ICO #" SortExpression="OrganisationICONum">
                                                            <EditItemTemplate>
                                                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("OrganisationICONum")%>'></asp:Label>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("OrganisationICONum") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Organisation" SortExpression="OrganisationName">
                                                            <EditItemTemplate>
                                                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("OrganisationName") & "<br/><small>Added to summary:" & Eval("AddedDate", "{0:d}") & "</small>" %>'></asp:Label>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("OrganisationName") & "<br/><small>Added to summary:" & Eval("AddedDate", "{0:d}") & "</small>" %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Assurance" SortExpression="AssuranceScore">
                                                            <EditItemTemplate>
                                                                <asp:Label ID="Label28" runat="server" CssClass="label label-default" ToolTip="Organisation not registered on DPIA" Visible='<%# Eval("AssuranceScore") = -1 And Eval("OrganisationID").ToString() = ""%>'>Not registered</asp:Label>
                                                                <asp:Label ID="lblSignificant" runat="server" CssClass="label label-success" Visible='<%# Eval("AssuranceScore") = 0%>'>Significant</asp:Label>
                                                                <asp:Label ID="Label3" runat="server" CssClass="label label-warning" Visible='<%# Eval("AssuranceScore") = 1%>'>Limited</asp:Label>
                                                                <asp:Label ID="Label4" runat="server" CssClass="label label-danger" Visible='<%# Eval("AssuranceScore") > 1%>'>None</asp:Label>
                                                                <asp:Label ID="Label5" runat="server" CssClass="label label-default" Visible='<%# Eval("AssuranceScore") = -1 And Not Eval("OrganisationID").ToString() = ""%>'>Not submitted</asp:Label>
                                                                <asp:Label ID="Label27" runat="server" CssClass="label label-default" Visible='<%# Eval("AssuranceScore") = -10%>'>Expired</asp:Label>
                                                                <asp:Label ID="Label32" runat="server" CssClass="label label-default" Visible='<%# Eval("AssuranceScore") = -11%>'>DPIA Inactive</asp:Label>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label ID="Label28" runat="server" CssClass="label label-default" ToolTip="Organisation not registered on DPIA" Visible='<%# Eval("AssuranceScore") = -1 And Eval("OrganisationID").ToString() = ""%>'>Not registered</asp:Label>
                                                                <asp:LinkButton visible='<%# Not Eval("OrganisationID").ToString() = ""%>' ID="lbtViewOrgDetails" ToolTip="View organisation details" Enabled='<%# Not Eval("AssuranceScore") = -11 %>' runat="server" CommandName="ViewOrgDetails" CommandArgument='<%# Eval("OrganisationID")%>'>
                                                                    <asp:Label ID="lblSignificant" runat="server" CssClass="label label-success" Visible='<%# Eval("AssuranceScore") = 0%>'>Significant</asp:Label>
                                                                    <asp:Label ID="Label3" runat="server" CssClass="label label-warning" Visible='<%# Eval("AssuranceScore") = 1%>'>Limited</asp:Label>
                                                                    <asp:Label ID="Label4" runat="server" CssClass="label label-danger" Visible='<%# Eval("AssuranceScore") > 1%>'>None</asp:Label>
                                                                    <asp:Label ID="Label5" runat="server" CssClass="label label-default" Visible='<%# Eval("AssuranceScore") = -1%>'>Not submitted</asp:Label>
                                                                    <asp:Label ID="Label27" runat="server" CssClass="label label-default" Visible='<%# Eval("AssuranceScore") = -10%>'>Expired</asp:Label>
                                                                    <asp:Label ID="Label31" runat="server" CssClass="label label-default" Visible='<%# Eval("AssuranceScore") = -11%>'>DPIA Inactive</asp:Label>
                                                                </asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:CheckBoxField DataField="Providing" HeaderText="Prov" SortExpression="Providing">
                                                            <ItemStyle HorizontalAlign="Center" />
                                                        </asp:CheckBoxField>
                                                        <asp:CheckBoxField DataField="Receiving" HeaderText="Rec" SortExpression="Receiving">
                                                            <ItemStyle HorizontalAlign="Center" />
                                                        </asp:CheckBoxField>
                                                        <asp:TemplateField ShowHeader="False">
                                                            <EditItemTemplate>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lbtDeleteOrg" runat="server" CssClass="btn btn-danger btn-xs freeze-on-sign" CausesValidation="False" CommandName="Delete" Text="" ToolTip="Remove"><i aria-hidden="true" class="icon-minus"></i></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <HeaderStyle CssClass="sorted-none" />
                                                </asp:GridView>
                                            </div>
                                            <asp:LinkButton ID="lbtAddOrganisation" CausesValidation="false" ToolTip="Lookup organisation" CssClass="btn btn-primary pull-right" min-width="25%" runat="server"><i aria-hidden="true" class="icon-search"></i> <b>Lookup</b></asp:LinkButton>
                                            <div id="modalSearch" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="lblModalSearchHeading" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                                            <h4 class="modal-title"><asp:Label ID="lblModalSearchHeading" runat="server">Add Organisation</asp:Label></h4>
                                                        </div>
                                                        <asp:MultiView ID="mvSearch" runat="server" ActiveViewIndex="0">
                                                            <asp:View ID="vCriteria" runat="server">
                                                                <div class="modal-body">
                                                                    <h4><small>Step 1 - Search</small></h4>
                                                                    <div class="form-horizontal" style="padding: 5%">
                                                                        <div class="form-group">
                                                                            <asp:Label ID="lblICOSearch" runat="server" Text="Full ICO registration number:"></asp:Label>
                                                                            <asp:TextBox ID="tbICOSearch" CssClass="form-control" runat="server"></asp:TextBox>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <asp:Label ID="lblOrgNameSearch" runat="server" Text="OR part of organisation name:"></asp:Label>
                                                                            <asp:TextBox ID="tbOrgNameSearch" CssClass="form-control" runat="server"></asp:TextBox>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><i aria-hidden="true" class="icon-close"></i>Cancel</button>
                                                                    <asp:LinkButton ID="lbtSearch" CausesValidation="false" class="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-search"></i> Search</asp:LinkButton>
                                                                </div>
                                                            </asp:View>
                                                            <asp:View ID="vResults" runat="server">
                                                                <div class="modal-body">
                                                                    <h4><small>Step 2 - Select</small></h4>
                                                                    <h5>1. Data Protection Impact Assessment Tool results</h5>
                                                                    <div id="div3" runat="server" class="alert alert-success" role="alert">
                                                                        <asp:Label ID="Label18" runat="server" Text="Label">Please select an organisation from this list if it exists.</asp:Label>
                                                                    </div>
                                                                    <div class="table-responsive" style="max-height: 240px;">
                                                                        <asp:GridView ID="gvISSResults" ShowHeader="false" runat="server" CssClass="table table-striped small" GridLines="None" AutoGenerateColumns="False" DataKeyNames="OrganisationID" EmptyDataText="No results found.">
                                                                            <Columns>
                                                                                <asp:TemplateField ShowHeader="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:LinkButton CssClass="btn btn-primary" ID="lbtSelectISSOrg" runat="server" CausesValidation="False" CommandArgument='<%# Eval("OrganisationID")%>' CommandName="Select" Text="Select"></asp:LinkButton>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                                <asp:BoundField DataField="ICORegistrationNumber" HeaderText="ICO Reg Num" SortExpression="Registration_number" />
                                                                                <asp:BoundField DataField="OrganisationName" HeaderText="Organisation Name" SortExpression="Organisation_name" />
                                                                                <asp:TemplateField>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="Label4" runat="server" CssClass="label label-danger" Visible='<%# Eval("InactivatedDate").ToString.Length > 4 %>'>INACTIVE</asp:Label>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                            </Columns>
                                                                        </asp:GridView>
                                                                    </div>
                                                                    <h5>2. ICO Register results</h5>
                                                                    <div id="div4" runat="server" class="alert alert-warning" role="alert">
                                                                        <asp:Label ID="Label19" runat="server" Text="Label">If the organisation doesn't appear in the first list, please select it from the second list.</asp:Label>
                                                                    </div>
                                                                    <div class="table-responsive" style="max-height: 240px;">
                                                                        <asp:GridView ID="gvICORes" ShowHeader="false" runat="server" CssClass="table table-striped small" GridLines="None" AutoGenerateColumns="False" DataKeyNames="Registration_number" EmptyDataText="No results found.">
                                                                            <Columns>
                                                                                <asp:TemplateField ShowHeader="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:LinkButton CssClass="btn btn-primary" ID="lbtSelectICOOrg" runat="server" CausesValidation="False" CommandArgument='<%# Eval("Registration_number")%>' CommandName="Select" Text="Select"></asp:LinkButton>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                                <asp:BoundField DataField="Registration_number" HeaderText="ICO Reg Num" SortExpression="Registration_number" />
                                                                                <asp:TemplateField HeaderText="Organisation">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="lblOrgName" runat="server" Text='<%# Eval("Organisation_name") + ", " + Eval("Postcode")%>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                            </Columns>
                                                                        </asp:GridView>
                                                                    </div>
                                                                    <h5>3. Enter data manually</h5>
                                                                    <div id="div5" runat="server" class="alert alert-danger" role="alert">
                                                                        <asp:Label ID="Label20" runat="server" Text="Label">If the organisation doesn't appear in either list, please search again. Only if you are certain that the organisation doesn't exist in either system, manually enter the organisation details here:</asp:Label>
                                                                    </div>
                                                                    <div class="form-horizontal" style="padding-right: 5%; padding-left: 5%">
                                                                        <div class="form-group">
                                                                            <asp:Label ID="Label21" runat="server" Text="Full organisation name:" AssociatedControlID="tbOrgNameAdd"></asp:Label>
                                                                            <asp:TextBox ID="tbOrgNameAdd" CssClass="form-control" runat="server"></asp:TextBox>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <asp:Label ID="Label22" runat="server" Text="ICO registration number (if known):" AssociatedControlID="tbOrgICOAdd"></asp:Label>
                                                                            <asp:TextBox ID="tbOrgICOAdd" CssClass="form-control" runat="server"></asp:TextBox>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <asp:LinkButton ID="lbtSaveNewOrg" CausesValidation="false" class="btn btn-default pull-right" runat="server"><i aria-hidden="true" class="icon-reply"></i> Save</asp:LinkButton>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><i aria-hidden="true" class="icon-close"></i>Cancel</button>
                                                                    <asp:LinkButton ID="lbtSearchAgain" CausesValidation="false" class="btn btn-default pull-right" runat="server"><i aria-hidden="true" class="icon-reply"></i> Search again</asp:LinkButton>
                                                                </div>
                                                            </asp:View>
                                                            <asp:View ID="vDirection" runat="server">
                                                                <div class="modal-body">
                                                                    <h4><small>Step 3 - Set flow direction for organisation</small></h4>
                                                                    <table class="table table-striped">
                                                                        <tr>
                                                                            <th>Organisation</th>
                                                                            <th>Providing</th>
                                                                            <th>Receiving</th>
                                                                        </tr>
                                                                        <tr>
                                                                            <td><asp:Label ID="lblOrganisation" runat="server" Text="Label"></asp:Label></td>
                                                                            <td><asp:CheckBox ID="cbProviding" ThreeState="true" CheckState="Indeterminate" runat="server" ToolTip="Providing" /></td>
                                                                            <td><asp:CheckBox ID="cbReceiving" runat="server" ToolTip="Receiving" /></td>
                                                                        </tr>
                                                                    </table>
                                                                    <asp:Label Visible="false" ID="lblDirectionError" CssClass="bg-danger" runat="server" Text="Please select one or both directions"></asp:Label>
                                                                    <asp:HiddenField ID="hfOrganisationID" runat="server" />
                                                                    <asp:HiddenField ID="hfOrgName" runat="server" />
                                                                    <asp:HiddenField ID="hfICONum" runat="server" />
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><i aria-hidden="true" class="icon-close"></i>Cancel</button>
                                                                    <asp:LinkButton ID="lbtSearchAgain2" CausesValidation="false" cssclass="btn btn-default pull-left" runat="server"><i aria-hidden="true" class="icon-reply"></i> Search again</asp:LinkButton>
                                                                    <asp:LinkButton ID="lbtConfirmAddOrg" CausesValidation="false" cssclass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-reply"></i> Confirm</asp:LinkButton>
                                                                </div>
                                                            </asp:View>
                                                        </asp:MultiView>
                                                    </div>
                                                </div>
                                            </div>
                                        
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div>
                    </div>
                    <asp:ObjectDataSource ID="dsPrivacyStatus" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.PrivacyStatusTableAdapter"></asp:ObjectDataSource>
                    <asp:ObjectDataSource ID="dsAssets" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByOrgOrSummary" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DataAssetInventoryTableAdapter">
                        <SelectParameters>
                            <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                            <asp:ControlParameter ControlID="hfSummaryID" DefaultValue="0" Name="DataFlowID" Type="Int32" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <div class="form-group">
                                <asp:Label ID="Label6" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="ddAsset">Is an asset linked to the information sharing? If so, please specify:</asp:Label>
                                <div class="col-xs-7">
                                    <asp:DropDownList AutoPostBack="true" AppendDataBoundItems="true" CssClass="form-control freeze-on-sign" ID="ddAsset" runat="server" DataSourceID="dsAssets" DataTextField="DataAssetName" DataValueField="DataAssetID">
                                        <asp:ListItem Text="Not applicable" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <hr />
                            <div class="form-group">
                                <asp:Label ID="Label2" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="tbPurpose">For what purpose is the information being shared?</asp:Label>
                                <div class="col-xs-7">
                                    <asp:TextBox CssClass="form-control freeze-on-sign" TextMode="MultiLine" runat="server" ID="tbPurpose" />
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="Label4" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="tbLegal">What is the legal gateway for sharing?</asp:Label>
                                <div class="col-xs-7">
                                    <div class="input-group">
                                        <asp:TextBox CssClass="form-control freeze-on-sign" TextMode="MultiLine" runat="server" ID="tbLegal" /><div class="input-group-addon">
                                            <a tabindex="0" title="Legal Gateway" class="btn btn-xs" role="button" data-toggle="popover" data-trigger="focus" data-container="body" data-placement="auto" data-content="A legal gateway is any piece of legislation which requires or allows the movement of information from one organisation to another. It may place a statutory duty on the organisation or powers on behalf of the individuals concerned."><i aria-hidden="true" class="icon-info"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:ObjectDataSource ID="dsTypes" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActive" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DataTypesTableAdapter">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                                <asp:Label ID="Label9" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="listInformationShared">What information is being shared?</asp:Label>
                                <div class="col-xs-7">
                                    <asp:ListBox ID="listInformationShared" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselect-dt" DataSourceID="dsTypes" DataTextField="DataType" DataValueField="DataTypeID"></asp:ListBox>
                                </div>
                            </div>
                            <asp:panel runat="server" ClientIDMode="Static" class="alert alert-warning clearfix collapse" id="pnlSchedTwo">
                                <div class="form-group">
                                <asp:ObjectDataSource ID="dsScheduleTwos" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_ScheduleTwosTableAdapter">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                                <asp:Label ID="Label3" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="listSchedule2">Select at least one GDPR Article 6 condition:</asp:Label>
                                <div class="col-xs-7">
                                    <div class="input-group">
                                        <a tabindex="0" title="Article 6 Conditions" class="input-group-addon btn btn-default btn-tooltip" style="background-color: rgb(238, 238, 238); color: rgb(51, 122, 183); font-size: 12px;" role="button" data-toggle="popover" data-trigger="focus" data-container="body" data-placement="auto" data-content="For assistance with Article 6 or 9 conditions please see your organisations Data Protection or Information Governance Manager."><i aria-hidden="true" class="icon-info"></i></a>
                                        <asp:ListBox ID="listSchedule2" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsScheduleTwos" DataTextField="ScheduleTwoText" DataValueField="ScheduleTwoID"></asp:ListBox>
                                    </div>
                                </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label34" CssClass="control-label col-xs-5" runat="server" AssociatedControlID="listPersonalItemsEdit">Personal data items:</asp:Label>
                                        <div class="col-xs-7">
                                            <asp:ListBox ID="listPersonalItemsEdit" runat="server" DataSourceID="dsPIDItems" DataTextField="PIDItem" DataValueField="PIDItemID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector"></asp:ListBox>
                                        </div>
                                    </div>
                            </asp:panel>
                            <asp:panel class="alert alert-danger clearfix collapse" ClientIDMode="Static" id="pnlSchedThree" runat="server">
                                <div class="form-group">
                                <asp:ObjectDataSource ID="dsScheduleThrees" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_ScheduleThreesTableAdapter">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                                <asp:Label ID="Label7" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="listSchedule3">Select at least one GDPR Article 9 condition:</asp:Label>
                                <div class="col-xs-7">
                                    <div class="input-group">
                                        <a tabindex="0" title="Article 9 Conditions" class="input-group-addon btn btn-default btn-tooltip" style="background-color: rgb(238, 238, 238); color: rgb(51, 122, 183); font-size: 12px;" role="button" data-toggle="popover" data-trigger="focus" data-container="body" data-placement="auto" data-content="For assistance with Article 6 or 9 Conditions please see your organisation's Data Protection Officer or Information Governance Manager."><i aria-hidden="true" class="icon-info"></i></a>
                                        <asp:ListBox ID="listSchedule3" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsScheduleThrees" DataTextField="ScheduleThreeText" DataValueField="ScheduleThreeID"></asp:ListBox> 
                                    </div>
                                </div>
                    </div>
                                <div class="form-group">
                                    <asp:Label ID="Label35" CssClass="control-label col-xs-5" runat="server" AssociatedControlID="listPersonalSensitiveItems">Special Category data items:</asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listPersonalSensitiveItems" runat="server" DataSourceID="dsPIDSensitiveItems" DataTextField="PIDItem" DataValueField="PIDItemID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector"></asp:ListBox>
                                    </div>
                                </div>       
                            </asp:panel>
                            <div class="form-group">
                                <asp:Label ID="Label12" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="tbDataFields">Which specific data fields / items will be shared?</asp:Label>
                                <div class="col-xs-7">
                                    <div class="input-group">
                                        <asp:TextBox CssClass="form-control freeze-on-sign autosize-ta" TextMode="MultiLine" runat="server" ID="tbDataFields" Rows="6" /><span class="input-group-addon">
                                            <a tabindex="0" title="Which data fields" class="btn btn-xs" role="button" data-toggle="popover" data-trigger="focus" data-container="body" data-placement="auto" data-content="It may be that you are sharing the entire data asset, a proportion of the asset or just one data field. This box allows you to clarify how much of the asset is being shared."><i aria-hidden="true" class="icon-info"></i></a>
                                        </span>
                                    </div>
                                    <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbDataFields" ID="rxvDataFields" ValidationExpression="^[\s\S]{0,2500}$" runat="server" ErrorMessage="Maximum 2500 characters."></asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <hr />
                            <div class="form-group">
                                <asp:Label ID="Label8" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="tbBenefits">What are the benefits to sharing the information?</asp:Label>
                                <div class="col-xs-7">
                                    <asp:TextBox CssClass="form-control freeze-on-sign" TextMode="MultiLine" runat="server" ID="tbBenefits" />
                                    <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbBenefits" ID="rxvBenefits" ValidationExpression="^[\s\S]{0,2500}$" runat="server" ErrorMessage="Maximum 2500 characters."></asp:RegularExpressionValidator>
                                </div>
                            </div>                               
                            <div class="form-group">
                                <asp:ObjectDataSource ID="dsFormat" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActive" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DataFormatTableAdapter">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                                <asp:Label ID="Label13" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="listFormats">In what format is the data being shared?</asp:Label>
                                <div class="col-xs-7">
                                    <asp:ListBox ID="listFormats" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsFormat" DataTextField="DataFormat" DataValueField="DataFormatID"></asp:ListBox>
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:ObjectDataSource ID="dsSubjects" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActive" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DataSubjectsTableAdapter">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                                <asp:Label ID="Label11" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="listSubjects">Who are the Data Subjects?</asp:Label>
                                <div class="col-xs-7">
                                    <asp:ListBox ID="listSubjects" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsSubjects" DataTextField="DataSubject" DataValueField="DataSubjectID"></asp:ListBox>
                                    <asp:TextBox CssClass="form-control placeholder  freeze-on-sign" ID="tbSubjectsOther" runat="server" PlaceHolder="Others - please specify"></asp:TextBox>
                                    <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbSubjectsOther" ID="rxvSubjectsOther" ValidationExpression="^[\s\S]{0,2500}$" runat="server" ErrorMessage="Maximum 2500 characters."></asp:RegularExpressionValidator>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <div class="form-group">
                        <asp:ObjectDataSource ID="dsAccessors" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DFAccessorsTableAdapter">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                        <asp:Label ID="Label10" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="listAccessors">Who will access the information being shared in the receiving organisation?</asp:Label>
                        <div class="col-xs-7">
                            <asp:ListBox ID="listAccessors" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsAccessors" DataTextField="DFAccessorText" DataValueField="DFAccessorID"></asp:ListBox>
                            <asp:TextBox CssClass="form-control placeholder freeze-on-sign" ID="tbOtherAccessors" runat="server" PlaceHolder="Others - please specify"></asp:TextBox>
                            <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbOtherAccessors" ID="rxvOtherAccessors" ValidationExpression="^[\s\S]{0,2500}$" runat="server" ErrorMessage="Maximum 2500 characters."></asp:RegularExpressionValidator>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="Label16" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="ddReviewCycle">Review cycle:</asp:Label>
                        <div class="col-xs-7">
                            <asp:DropDownList CssClass="form-control freeze-on-sign" ID="ddReviewCycle" runat="server">
                                <asp:ListItem Text="One year" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Two year" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Three year" Value="3"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="Label24" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="ddReviewCycle">Override review date:</asp:Label>
                        <div class="col-xs-7">
                            <div class="input-group">
                                <span class="input-group-addon">
                                    <a tabindex="0" title="Override review date" class="btn btn-xs" role="button" data-toggle="popover" data-trigger="focus" data-container="body" data-placement="auto" data-content="The review date for a data sharing summary will be calculated as 1, 2 or 3 years (according to the review cycle) from the first sign off date unless an override date is provided here."><i aria-hidden="true" class="icon-info"></i></a>
                                </span>
                                <asp:TextBox CssClass="form-control date-picker freeze-on-sign" placeholder="dd/mm/yyyy (optional)" runat="server" ID="tbFixedReviewDate" />
                            </div>
                        </div>
                    </div>
                    <hr />
                    <div id="div1" runat="server" class="alert alert-warning" role="alert">
                        <asp:Label ID="Label14" runat="server" Text="Label">For pre-existing agreements please complete the following.</asp:Label>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="Label15" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="tbDateSigned">Date signed:</asp:Label>
                        <div class="col-xs-7">
                            <asp:TextBox CssClass="form-control date-picker freeze-on-sign" placeholder="dd/mm/yyyy (optional)" runat="server" ID="tbDateSigned" />
                        </div>
                    </div>
                </asp:Panel>
                <div class="form-group" id="divEvidence" runat="server">

                    <label for="filEvidence" class="control-label col-xs-5">
                        Additional files (optional):
                    </label>

                    <div class="col-xs-7">
                        <div class="panel panel-default">
                            <asp:ObjectDataSource ID="dsSummaryFiles" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_FilesByGroupTableAdapter">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfSummaryFileGroup" DefaultValue="0" Name="FileGroupID" Type="Int32" />
                                </SelectParameters>
                            </asp:ObjectDataSource>
                            <table class="table table-striped">
                                <asp:Repeater ID="rptFiles" runat="server" DataSourceID="dsSummaryFiles">
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
                                            <td style="width: 20px"><asp:LinkButton ID="lbtDelete" Visible='<%# Eval("OrganisationID") = Session("UserOrganisationID") Or Session("IsSuperAdmin")%>' OnClientClick="return confirm('Are you sure you want to delete this file?');" runat="server" CommandName="Delete" CommandArgument='<%# Eval("FileID")%>' CssClass="btn btn-danger btn-xs" ToolTip="Delete File" CausesValidation="false"><i aria-hidden="true" class="icon-minus"></i><!--[if lt IE 8]>Delete<![endif]--></asp:LinkButton></td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate></div></FooterTemplate>
                                </asp:Repeater>
                            </table>
                        </div>
                        <asp:Panel ID="pnlFreeLicenceMessage" Visible="false" runat="server" CSSClass="alert alert-danger alert-dismissible" role="alert">     
                            <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                            <asp:Label ID="Label33" runat="server" Text="Label">You are accessing the DPIA under a "free" licence, as such you are unable to upload documents to a data flow. To discuss licencing options for your organisation please contact <a href='mailto:isg@mbhci.nhs.uk'>isg@mbhci.nhs.uk</a>.</asp:Label>
                        </asp:Panel>
                        <asp:Panel ID="pnlFileUpload" runat="server" CssClass="input-group">
                            <span class="input-group-btn">
                                <span class="btn btn-default btn-file">Browse&hellip;
                                        <asp:FileUpload AllowMultiple="true" ID="filEvidence" runat="server" />
                                </span>
                            </span>
                            <input type="text" placeholder="Optional (max 5 MB)" class="form-control freeze-on-sign">
                            <span class="input-group-btn">
                                <asp:LinkButton ID="lbtUpload" CausesValidation="false" CssClass="btn btn-default" runat="server"><i aria-hidden="true" class="icon-upload2"></i>  Upload</asp:LinkButton>
                            </span>
                        </asp:Panel>
                    </div>
                </div>                                                                      
            </div>
            <hr />
            <div class="form-group">
                <asp:LinkButton Visible="false" ID="lbtUpdateSummary" CssClass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-checkmark"></i> Update Summary</asp:LinkButton>
                <asp:LinkButton ID="lbtSaveSummary" CssClass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-checkmark"></i> Save Summary</asp:LinkButton>
            </div>
        </div>
    </div>
    <div id="modalMessage" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" runat="server" id="btnCloseModal" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><asp:Label ID="lblModalHeading" runat="server"></asp:Label></h4>
                </div>
                <div class="modal-body">
                    <p><asp:Label ID="lblModalText" runat="server"></asp:Label></p>
                </div>
                <div class="modal-footer">
                    <asp:LinkButton ID="lbtAddedReturn" CausesValidation="false" CssClass="btn btn-default pull-left" runat="server" PostBackUrl="~/application/summaries_list.aspx">Return to List</asp:LinkButton>
                    <asp:LinkButton ID="lbtAddDetail" CausesValidation="false" CommandArgument="0" CssClass="btn btn-default pull-right" runat="server" PostBackUrl="~/application/dataflow_detail?action=Add">Add Data Flow Detail</asp:LinkButton>
                    <button id="ModalOK" runat="server" type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>
    <asp:ObjectDataSource ID="dsTransactionHistory" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.TransactionHistoryTableAdapter">
        <SelectParameters>
            <asp:Parameter DefaultValue="isp_DataFlowSummaries" Name="TableName" Type="String" Size="100" />
            <asp:ControlParameter ControlID="hfSummaryID" DefaultValue="1" Name="ID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <div id="modalHistory" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><asp:Label ID="lblLogTitle" runat="server" Text="Data Sharing Summary Transaction Log"></asp:Label></h4>
                </div>
                <div class="modal-body">
                    <div style="max-height: 400px; overflow-y: auto;">
                        <table class="table table-striped">
                            <asp:Repeater ID="rptHistory" runat="server" DataSourceID="dsTransactionHistory">
                                <HeaderTemplate>
                                    <div class="table-responsive">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><asp:Label ID="Label17" runat="server" Text='<%# Eval("TransactionDate")%>'></asp:Label></td>
                                        <td>
                                            <asp:HyperLink ID="hlUser" runat="server"
                                                NavigateUrl='<%# Eval("UserName", "mailto:{0}")%>'>
                                                <i aria-hidden="true" class="icon-envelope"></i>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("UserName")%>'></asp:Label>
                                            </asp:HyperLink>
                                        </td>
                                        <td><asp:Label ID="Label23" runat="server" Text='<%# Eval("TransactionType")%>'></asp:Label></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate></div></FooterTemplate>
                            </asp:Repeater>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="Button1" runat="server" type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel3" UpdateMode="Conditional" ChildrenAsTriggers="false" runat="server">
        <ContentTemplate>
            <uc1:OrgDetailsModal runat="server" ID="OrgDetailsModal" />
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="gvOrganisations" />
        </Triggers>
    </asp:UpdatePanel>

    <script type="text/javascript">
        Sys.Application.add_load(BindEvents);
    </script>


</asp:Content>
