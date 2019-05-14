<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="support_tickets.aspx.vb" Inherits="InformationSharingPortal.support_tickets" %>

<%@ Register Assembly="DevExpress.Web.ASPxHtmlEditor.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHtmlEditor" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.ASPxSpellChecker.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxSpellChecker" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="server">
    <script src="../Scripts/bsasper.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //Lets do bootstrap form validation:
            $('[data-toggle="popover"]').popover();
            $("input, textarea, select, radio").bsasper({
                placement: "right", createContent: function (errors) {
                    return '<span class="text-danger">' + errors[0] + '</span>';
                }
            });
        });
    </script>
    <h1>Support Tickets</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <asp:MultiView ID="mvSupportTickets" ActiveViewIndex="0" runat="server">
        <asp:View ID="vTicketList" runat="server">
            <asp:ObjectDataSource ID="dsTickets" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataBy" TypeName="InformationSharingPortal.TicketsTableAdapters.isp_SupportTicketsTableAdapter">
                <SelectParameters>
                    <asp:SessionParameter Name="ReporterEmail" SessionField="UserEmail" Type="String" />
                    <asp:SessionParameter DefaultValue="" Name="UserAdminGroupID" SessionField="OrgAdminGroupID" Type="Int32" />
                    <asp:Parameter DefaultValue="-1" Name="SuperAdminGroupID" Type="Int32" />
                    <asp:SessionParameter DefaultValue="0" Name="IsSuperAdmin" SessionField="IsSuperAdmin" Type="Boolean" />
                    <asp:SessionParameter DefaultValue="" Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                    <asp:ControlParameter ControlID="cbAddedByMyOrg" DefaultValue="0" Name="ShowOtherUsers" PropertyName="Checked" Type="Boolean" />
                    <asp:ControlParameter ControlID="cbShowClosed" DefaultValue="1" Name="ShowArchivedTickets" PropertyName="Checked" Type="Boolean" />
                    <asp:ControlParameter ControlID="cbShowAssigned" Name="ShowAssigned" PropertyName="Checked" Type="Boolean" />
                    <asp:ControlParameter ControlID="tbSearch" DefaultValue="" Name="searchString" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
           <asp:ObjectDataSource ID="dsAdminGroups" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActiveLimitedByAG" TypeName="InformationSharingPortal.adminTableAdapters.isp_AdminGroupsTableAdapter">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="False" Name="IsCentralSA" SessionField="IsCentralSA" Type="Boolean" />
            <asp:SessionParameter DefaultValue="0" Name="SuperAdminID" SessionField="SuperAdminID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
            <div class="clearfix">
                <button type="button" class="btn btn-default pull-right" data-toggle="collapse" data-target="#FilterPanel">
                    <i class="glyphicon glyphicon glyphicon-filter"></i>Filter / search...
                </button>
            </div>
            <asp:Panel ID="FilterPanel" runat="server" class="collapse filter-panel" ClientIDMode="Static">
                <div class="panel panel-default">
                    <div class="panel-body">
                        <div class="form-inline small" role="form">
                            <div class="form-group">
                                <asp:Label ID="lblSearch" CssClass="filter-col" runat="server" Text="Ticket contains:" AssociatedControlID="tbSearch"></asp:Label>
                                <asp:TextBox ID="tbSearch" CssClass="form-control input-sm" runat="server" placeholder="contains"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="lblShowClosed" CssClass="filter-col" runat="server" Text="" AssociatedControlID="cbShowClosed"> &nbsp;Show closed?</asp:Label><asp:CheckBox ID="cbShowClosed" runat="server" Checked="False" />
                            </div>
                            
                            <div class="form-group">
                                <asp:Label ID="lblAddedByOrg" CssClass="filter-col" runat="server" Text="" AssociatedControlID="cbAddedByMyOrg"> &nbsp;Added by others in my org?</asp:Label><asp:CheckBox ID="cbAddedByMyOrg" runat="server" />
                            </div>
                            <asp:Panel ID="pnlSAMine" CssClass="form-group" runat="server">
 <asp:Label ID="Label2" CssClass="filter-col" runat="server" Text="" AssociatedControlID="cbShowAssigned"> &nbsp;Only assigned to me?</asp:Label><asp:CheckBox ID="cbShowAssigned" runat="server" Checked="False" />
                            </asp:Panel>
                            <asp:Panel ID="pnlAdminGroup" runat="server" class="form-group">
                                <asp:Label ID="lblAdminGroup" CssClass="filter-col" runat="server" Text="" AssociatedControlID="ddAdminGroupFilter"> &nbsp;Admin group:</asp:Label>
                                <asp:DropDownList ID="ddAdminGroupFilter" CssClass="form-control input-sm" AppendDataBoundItems="true" runat="server" DataSourceID="dsAdminGroups" DataTextField="GroupName" DataValueField="AdminGroupID">
                   
                   <asp:ListItem text="Any" Value="0"></asp:ListItem>
               </asp:DropDownList>
                            </asp:Panel>
                            <div>
                            </div>
                            <asp:LinkButton CssClass="btn btn-success pull-right" ID="lbtUpdateFilter" runat="server"><i class="glyphicon glyphicon-cog"></i> Update</asp:LinkButton>
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <asp:GridView CssClass="table table-striped" AllowSorting="True" HeaderStyle-CssClass="sorted-none" GridLines="None" ID="gvTickets" runat="server" AutoGenerateColumns="False" EmptyDataText="There are no tickets matching your filter criteria." DataKeyNames="TicketID" DataSourceID="dsTickets">
                <Columns>
                    <asp:TemplateField HeaderText="Ticket" InsertVisible="False" SortExpression="TicketID">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbtOpenTicket" CausesValidation="false" runat="server" ToolTip='<%# "View ticket - Status: " & GetTicketStatus(Eval("TicketStatusID"))%>' CommandName="OpenTicket" CommandArgument='<%# Eval("TicketID")%>' CssClass='<%# GetTicketColourStatus(Eval("TicketStatusID"))%>'>
                                <i aria-hidden="true" class="icon-tag"></i>
                                <asp:Label ID="Label1" runat="server" Text='<%#  Eval("TicketID")%>'></asp:Label>
                            </asp:LinkButton>&nbsp;
                            <asp:Label ID="lblEscalated" Visible='<%#  Eval("Escalated")%>' runat="server" ToolTip="Escalated to DPIA central team"><i aria-hidden="true" class="glyphicon glyphicon-flag text-danger"></i></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Subject" HeaderText="Subject" SortExpression="Subject" />
                    <asp:BoundField DataField="ReporterOrganisationName" ControlStyle-CssClass="small" HeaderText="Organisation" SortExpression="ReporterOrganisationName">
                        <ControlStyle CssClass="small" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ReporterEmail" ControlStyle-CssClass="small" HeaderText="Reporter" SortExpression="ReporterEmail">
                        <ControlStyle CssClass="small" />
                    </asp:BoundField>
                    <asp:BoundField DataField="AdminGroup" HeaderText="AdminGroup" SortExpression="AdminGroup" />
                    <asp:BoundField DataField="AssignedToEmail" ControlStyle-CssClass="small" HeaderText="Assigned To" SortExpression="AssignedToEmail">
                        <ControlStyle CssClass="small" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Raised" ControlStyle-CssClass="small" HeaderText="Raised" SortExpression="Raised">
                        <ControlStyle CssClass="small" />
                    </asp:BoundField>
                    <asp:BoundField DataField="LastActivity" ControlStyle-CssClass="small" HeaderText="Last Activity" SortExpression="LastActivity">
                        <ControlStyle CssClass="small" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="SLA Target" SortExpression="TargetDate">
                        <ItemTemplate>
                            <asp:Label ID="lblTargetDateGV" runat="server" CssClass='<%# GetSLACSS(Eval("TargetDate"))%>' Text='<%# Eval("TargetDate", "{0:d}")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Archived" SortExpression="ClosedDate">
                        <ItemTemplate>
                            <asp:Label ID="lblClosedDateGV" runat="server" Text='<%# Eval("ClosedDate", "{0:d}")%>'></asp:Label>
                            <asp:LinkButton ID="lbtCloseTicket" CausesValidation="false" Visible='<%# Eval("ClosedDate").ToString() = ""%>' OnClientClick="return confirm('Are you sure you wish to archive this ticket?');" CommandName="CloseTicket" CommandArgument='<%# Eval("TicketID")%>' ToolTip="Archive ticket" CssClass="btn btn-default btn-sm" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-trash"></i> Archive</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="sorted-none" />
            </asp:GridView>
            <asp:LinkButton ID="lbtRaiseTicket" CssClass="btn btn-primary pull-right" ToolTip="Raise new support request" CausesValidation="false" runat="server"><i aria-hidden="true" class="icon-support"></i> <b>New Support Request</b> </asp:LinkButton>
        </asp:View>
        <asp:View ID="vAddTicket" runat="server">
            <div class="panel panel-primary" style="padding: 2%;">
                <h2>New Support Ticket</h2>
                <div class="form-horizontal">
                    <div class="form-group">
                        <asp:Label ID="lblSubject" CssClass="control-label col-xs-2" runat="server" AssociatedControlID="tbSubject">Subject:</asp:Label>
                        <div class="col-xs-10">
                            <asp:TextBox ID="tbSubject" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-group">
                        <asp:Label ID="Label3" CssClass="control-label col-xs-2" runat="server" AssociatedControlID="htmlNewTicket">Description:</asp:Label>
                        <div class="col-xs-10">
                            <dx:ASPxHtmlEditor ID="htmlNewTicket" Height="250px" SettingsDialogs-InsertImageDialog-SettingsImageUpload-UploadFolder="~/Resources/uploadedimages/" runat="server" Settings-AllowPreview="False" Settings-AllowHtmlView="false" Width="100%">
                            </dx:ASPxHtmlEditor>
                        </div>
                    </div>
                </div>
                <div class="clearfix">
                    <asp:LinkButton ID="lbtCancelNewTicket" CssClass="btn btn-default pull-left" runat="server">Cancel</asp:LinkButton>
                    <asp:LinkButton ID="lbtSubmitNewSupportTicket" CssClass="btn btn-primary pull-right" runat="server">Submit</asp:LinkButton>
                </div>
            </div>
        </asp:View>
        <asp:View ID="vManageTicket" runat="server">
            <asp:ObjectDataSource ID="dsTicketComments" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByTicketID" TypeName="InformationSharingPortal.TicketsTableAdapters.isp_SupportTicketCommentsTableAdapter">
                <SelectParameters>
                    <asp:Parameter DefaultValue="0" Name="TicketID" Type="Int32" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <asp:HiddenField ID="hfTicketID" runat="server" />
            <asp:HiddenField ID="hfReporterEmail" runat="server" />
            <div class="panel panel-primary" style="padding: 2%;">
                <div class="well well-sm">
                    <b>
                        <i aria-hidden="true" class="icon-tag"></i>
                        <asp:Label ID="lblTicketHeader" runat="server" Text="Ticket"></asp:Label></b>
                    <div class="btn-toolbar pull-right">
                        <div class="btn-group" role="group" aria-label="...">
                            <asp:LinkButton ID="lbtArchiveTicket" CssClass="btn btn-default" ToolTip="Archive Ticket" OnClientClick="return confirm('Are you sure you wish to archive this ticket?');" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-trash"></i> Archive</asp:LinkButton>

                            <asp:LinkButton ID="lbtEscalate" OnClientClick="return confirm('Are you sure you wish to escalate this ticket? This will move it from your in-tray and assign it to the ISG central team.');" Visible="false" CssClass="btn btn-default" ToolTip="Escalate to ISG Central Admin" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-arrow-up"></i> Escalate</asp:LinkButton>
                            <asp:Panel ID="pnlAssignTo" runat="server" CssClass="btn-group">
                                <button type="button" id="btnAssignTo" runat="server" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <asp:Label ID="lblAssignTo" runat="server" Text="Assign to"></asp:Label>
                                    <span class="caret"></span>
                                </button>
                                <asp:ObjectDataSource ID="dsReassigns" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByAdminGroupID" TypeName="InformationSharingPortal.adminTableAdapters.isp_SuperAdminsTableAdapter">
                                   
                                    <SelectParameters>
                                        <asp:Parameter DefaultValue="0" Name="AdminGroupID" Type="Int32" />
                                    </SelectParameters>
                                   
                                </asp:ObjectDataSource>
                                <ul class="dropdown-menu">
                                    <asp:Repeater DataSourceID="dsReassigns" ID="rptAssignTo" runat="server">
                                        <ItemTemplate>
                                            <li>
                                                <asp:LinkButton ID="lbtAssign" CommandName="AssignTo" CommandArgument='<%# Eval("SuperAdminEmail")%>' runat="server" Text='<%# Eval("SuperAdminEmail")%>'></asp:LinkButton></li>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <li role="separator" class="divider"></li>
                                    <li>
                                        <asp:LinkButton ID="lbtRemoveAssign" runat="server" Text="Remove Assignment"></asp:LinkButton></li>
                                </ul>

                            </asp:Panel>
                            <asp:Panel ID="pnlPriority" runat="server" CssClass="btn-group">
                                <button type="button" id="Button1" runat="server" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <asp:Label ID="lblResolveByDD" runat="server" Text="Resolve target"></asp:Label>
                                    <span class="caret"></span>
                                </button>
                                <ul class="dropdown-menu">
                                    <li>
                                        <asp:LinkButton ID="lbtSameDay" runat="server">Same day</asp:LinkButton></li>
                                    <li>
                                        <asp:LinkButton ID="lbtNextDay" runat="server">Next day</asp:LinkButton></li>
                                    <li>
                                        <asp:LinkButton ID="lbtOneWeek" runat="server">One week</asp:LinkButton></li>
                                    <li>
                                        <asp:LinkButton ID="lbtChangeRequest" runat="server">Change request</asp:LinkButton></li>
                                </ul>

                            </asp:Panel>
                        </div>
                        <div class="btn-group" role="group" aria-label="...">
                            <asp:LinkButton ID="lbtCloseTicket" CssClass="btn btn-default" CausesValidation="false" ToolTip="Close ticket" runat="server"><i aria-hidden="true" class="icon-close"></i></asp:LinkButton>
                        </div>
                    </div>
                    <h3>
                        <asp:Label ID="lblTicketSubject" runat="server" Text="New"></asp:Label></h3>

                    <hr />

                    <div class="row">
                        <div class="col-sm-4">
                            Status: <b>
                                <asp:Label ID="lblTicketStatus" runat="server" Text="New"></asp:Label></b>
                        </div>

                        <div class="col-sm-8">
                            Added&nbsp;By:  <b>
                                <asp:Label ID="lblAddedBy" runat="server" Text="My Organisation"></asp:Label></b>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-sm-4">
                            Added: <b>
                                <asp:Label ID="lblAddedDate" runat="server" Text="New"></asp:Label></b>
                        </div>

                        <div class="col-sm-4">
                            Last&nbsp;Updated: <b>
                                <asp:Label ID="lblLastUpdate" runat="server" Text="My Organisation"></asp:Label></b>
                        </div>

                        <div class="col-sm-4">
                            Estimated&nbsp;Resolve&nbsp;Date: <b>
                                <asp:Label ID="lblResolveBy" runat="server" Text="My Organisation"></asp:Label></b>
                        </div>

                    </div>

                </div>
                <h3>Ticket Comments</h3>
                <div class="panel panel-default">

                    <div class="panel-body">
                        <div class="clearfix">
                            <button type="button" class="btn btn-primary pull-right" data-toggle="collapse" data-target="#NewCommentPanel">
                                <i aria-hidden="true" class="icon-plus"></i>Add Comment
                            </button>
                        </div>
                        <asp:Panel ID="NewCommentPanel" runat="server" class="collapse filter-panel" ClientIDMode="Static">
                            <div class="panel panel-primary">
                                <div class="panel-heading">Add Comment</div>
                                <div class="panel-body">
                                    <dx:ASPxHtmlEditor ID="htmlAddComment" Height="200px" ClientVisible="false" ClientInstanceName="htmlAdd" SettingsDialogs-InsertImageDialog-SettingsImageUpload-UploadFolder="~/Resources/uploadedimages/" runat="server" Settings-AllowPreview="False" Settings-AllowHtmlView="false" Width="100%">
                                    </dx:ASPxHtmlEditor>
                                </div>
                                <div class="panel-footer clearfix">
                                    <button type="button" class="btn btn-default pull-left" data-toggle="collapse" data-target="#NewCommentPanel">
                                        Cancel
                                    </button>
                                    <asp:LinkButton ID="lbtSubmitNewComment" CssClass="btn btn-primary pull-right" runat="server">Submit</asp:LinkButton>
                                </div>
                            </div>
                        </asp:Panel>
                        <br />
                        <asp:Repeater ID="rptComments" runat="server" DataSourceID="dsTicketComments">
                            <ItemTemplate>

                                <div class='<%#IIf(Not Eval("IsUser"), "col-md-11 col-md-offset-1", "col-md-11") %>'>
                                <div class='<%# "panel panel-" & IIf(Not Eval("IsUser"), "success", "warning") %>'>
                                    <div class="panel-heading clearfix">
                                        <div class='<%# "pull-" & IIf(Not Eval("IsUser"), "right", "left") %>'>
                                        Comment added:
                                        <asp:Label ID="lblCommentAddedDate" Font-Bold="true" runat="server" Text='<%# Eval("TCAdded")%>'></asp:Label>
                                        by:
                                        <asp:Label Font-Bold="true" ID="lblCommentAddedBy" runat="server" Text='<%# Eval("TCUserEmail")%>'></asp:Label>
                                    </div>
                                        </div>
                                    <div class="panel-body">
                                        <asp:Literal ID="litComment" runat="server" Text='<%# Eval("TComment")%>'></asp:Literal>
                                    </div>

</div></div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </asp:View>
        <asp:View ID="vNoTickets" runat="server">
            <h2>Support Tickets Unavailable</h2>
       <p>Your organisation does not have an ISG licence that includes access to ticket based support.</p>
        
                <p>You may be able to request support from your sharing partners.</p>
        <p>If you would like more information on Data Protection Impact Assessment Tool licence options, please contact us using the <asp:LinkButton ID="lbtContact" runat="server" PostBackUrl="~/Contact.aspx">Contact page</asp:LinkButton>.</p>

        </asp:View>
    </asp:MultiView>
    <script>
        $('#NewCommentPanel').on('shown.bs.collapse', function () {
            htmlAdd.SetVisible(true);
        })
        $('#NewCommentPanel').on('hidden.bs.collapse', function () {
            htmlAdd.SetVisible(false);
            htmlAdd.SetHtml("");
        })
    </script>

</asp:Content>
