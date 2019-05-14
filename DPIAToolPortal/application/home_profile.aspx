<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="home_profile.aspx.vb" Inherits="InformationSharingPortal.home_profile" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="server">
    <h1>My DPIA User Profile</h1>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <link href="../Content/bootstrap-toggle.min.css" rel="stylesheet" />
    <script src="../Scripts/bootstrap-toggle.min.js"></script>
    <script>
        function BindEvents() {
            doPopover()

            function doPopover(s, e) {
                $('[data-toggle="popover"]').popover();
            }

            $('.bs-toggle').bootstrapToggle({
                on: 'Subscribed',
                off: 'Unsubscribed',
                onstyle: 'success',
                offstyle: 'danger'
            });

            $('.unsub-toggle').change(function () {
                if ($(this).prop('checked')) {
                    $('#modalSubscribe').modal('show');
                }
                else {
                    $('#modalUnsubscribe').modal('show');
                }
            });
        }
    </script>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3>Organisation Access Roles <small>(to change these, contact your DPIA administrator)</small></h3>
        </div>

        <asp:ObjectDataSource ID="dsRoles" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByEmail" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_OrganisationUsersTableAdapter" DeleteMethod="Delete">
            <DeleteParameters>
                <asp:Parameter Name="Original_OrganisationUserID" Type="Int32" />
            </DeleteParameters>
            <SelectParameters>
                <asp:SessionParameter Name="UserEmail" SessionField="UserEmail" Type="String" />
                <asp:SessionParameter DefaultValue="" Name="orgid" SessionField="UserOrganisationID" Type="Int32" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:GridView ID="gvRoles" CssClass="table table-striped" runat="server" AutoGenerateColumns="False" DataSourceID="dsRoles" AllowSorting="True" HeaderStyle-CssClass="sorted-none" GridLines="None" DataKeyNames="OrganisationUserID">
                    <Columns>
                        <asp:BoundField DataField="OrganisationUserName" HeaderText="User Name" SortExpression="OrganisationUserName" />
                        <asp:BoundField DataField="Role" HeaderText="Role" SortExpression="Role" />
                        <asp:TemplateField HeaderText="Role delegated to">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtDelegate" Visible='<%# Eval("DelegateRoleTo").ToString.Length = 0 AND  CInt(Eval("RoleID")) <= 3%>' CssClass="btn btn-default" runat="server" CausesValidation="false" CommandName="Delegate" CommandArgument='<%# Eval("Role")%>'><i aria-hidden="true" class="icon-point-down"></i> Delegate</asp:LinkButton>
                                <asp:Label ID="lblDelegatedTo" runat="server" Text='<%# Eval("DelegateRoleTo")%>'></asp:Label>&nbsp;<asp:LinkButton ID="lbtClear" CssClass="btn btn-default" runat="server" CommandName="Clear" Visible='<%# Eval("DelegateRoleTo").ToString.Length > 0 %>' CommandArgument='<%# Eval("Role")%>'><i aria-hidden="true" class="icon-cancel-circle"></i>Clear</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Resign role" ShowHeader="false">
                            <ItemTemplate>
                                <asp:LinkButton CssClass="btn btn-info" ID="lbtResignRole" ToolTip="Resign role" runat="server" CommandName="Resign" CommandArgument='<%# Eval("Role")%>'><i aria-hidden="true" class="icon-flag"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="sorted-none" />
                    <PagerSettings Mode="NumericFirstLast" PageButtonCount="6" />
                    <SortedAscendingHeaderStyle CssClass="sorted-ascending" />
                    <SortedDescendingHeaderStyle CssClass="sorted-descending" />
                </asp:GridView>
                <asp:ObjectDataSource ID="dsAdmins" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DelegatesTableAdapter">
                    <SelectParameters>
                        <asp:SessionParameter DefaultValue="" Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                        <asp:SessionParameter Name="UserEmail" SessionField="UserEmail" Type="String" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <div id="modalDelegate" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="lblModalText" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h4 class="modal-title">
                                    <asp:Label ID="lblModalHeading" runat="server" Text="Delegate Role"></asp:Label></h4>
                            </div>
                            <div class="modal-body">
                                <p>
                                    <asp:Label ID="lblModalText" runat="server" Text="I hereby give my permission for the following user to act on my behalf as"></asp:Label>
                                    <asp:DropDownList ID="ddDelegateToAdmin" CssClass="form-control" runat="server" DataSourceID="dsAdmins" DataTextField="OrganisationUserName" DataValueField="OrganisationUserEmail"></asp:DropDownList>
                                </p>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="btnConfirmDelegate" CssClass="btn btn-primary" runat="server" CausesValidation="True" CommandName="Update"><i aria-hidden="true" class="icon-checkmark"></i> Confirm</asp:LinkButton>
                                &nbsp;<asp:LinkButton ID="btnCancelDelegate" CssClass="btn btn-default" data-dismiss="modal" runat="server" CausesValidation="False"><i aria-hidden="true" class="icon-close"></i> Cancel</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="modalClear" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="lblModalClearText" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h4 class="modal-title">
                                    <asp:Label ID="lblModalClearHeader" runat="server" Text="Cancel Role Delegation?"></asp:Label></h4>
                            </div>
                            <div class="modal-body">
                                <p>
                                    <asp:Label ID="lblModalClearText" runat="server" Text="Are you sure that you would like to cancel the delegation of this role?"></asp:Label>
                                </p>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="lbtCancelYes" CssClass="btn btn-primary" runat="server" CausesValidation="True" CommandName="Update"><i aria-hidden="true" class="icon-checkmark"></i> Yes</asp:LinkButton>
                                &nbsp;<asp:LinkButton ID="lbtCancelNo" CssClass="btn btn-default" data-dismiss="modal" runat="server" CausesValidation="False"><i aria-hidden="true" class="icon-close"></i> No</asp:LinkButton>

                            </div>
                        </div>
                    </div>
                </div>
                <div id="modalResign" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalResignLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h4 class="modal-title"><asp:Label ID="modalResignTitle" runat="server" Text="Resign role?"></asp:Label></h4>
                            </div>
                            <div class="modal-body">
                                <p><asp:Label ID="modalResignLabel" runat="server" Text="Are you sure that you would like to resign this role?"></asp:Label></p>
                                <div class="form-group">
                                    <asp:Label ID="lblReason" runat="server" Text="Reason:" AssociatedControlID="tbReason"></asp:Label><asp:TextBox CssClass="form-control" ID="tbReason" runat="server" TextMode="MultiLine" Rows="2" MaxLength="255"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:LinkButton ID="lbtResignConfirm" CssClass="btn btn-primary" runat="server" CausesValidation="True" CommandName="Update"><i aria-hidden="true" class="icon-checkmark"></i> Yes</asp:LinkButton>
                                &nbsp;<asp:LinkButton ID="lbtResignCancel" CssClass="btn btn-default" data-dismiss="modal" runat="server" CausesValidation="False"><i aria-hidden="true" class="icon-close"></i> No</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <ul class="list-group">
            <li class="list-group-item">
                <asp:LinkButton ID="lbtManage" runat="server" ToolTip="Click to change password" PostBackUrl="~/application/Manage.aspx">
                        Click here
                </asp:LinkButton>
                to change your password.</li>
        </ul>
    </div>
    
    <div class="panel panel-default">
        <div class="panel-heading">
            <div class="row">
                <div class="col-sm-7">
                    <h3>DPIA Email Notifications</h3>
                 </div>
                 <div class="col-sm-5">
                     <input type="checkbox" id="cbActivate" runat="server" class="pull-right unsub-toggle" checked='<%# Eval("UserSubscribed")%>' data-toggle="toggle" data-on="Activated" data-off="Inactivated" data-size="large" data-onstyle="success pull-right" data-offstyle="danger pull-right">
                 </div>
            </div>
        </div>
        <asp:Panel ID="pnlNotifications" runat="server">
            <asp:ObjectDataSource ID="dsUserNotifications" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.NotificationsTableAdapters.GetNotificationsForUserTableAdapter">
                <SelectParameters>
                    <asp:SessionParameter Name="UserEmail" SessionField="UserEmail" Type="String" />
                    <asp:SessionParameter Name="UserRoleViewer" SessionField="UserRoleViewer" Type="Boolean" />
                    <asp:SessionParameter Name="UserRoleAO" SessionField="UserRoleAO" Type="Boolean" />
                    <asp:SessionParameter Name="UserRoleAdmin" SessionField="UserRoleAdmin" Type="Boolean" />
                    <asp:SessionParameter Name="UserRoleCSO" SessionField="UserRoleCSO" Type="Boolean" />
                    <asp:SessionParameter Name="UserRoleIAO" SessionField="UserRoleIAO" Type="Boolean" />
                    <asp:SessionParameter Name="UserRoleIGO" SessionField="UserRoleIGO" Type="Boolean" />
                    <asp:SessionParameter Name="UserRoleDPO" SessionField="UserRoleDPO" Type="Boolean" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <ul class="list-group">
                <asp:Repeater ID="rptNotifications" DataSourceID="dsUserNotifications" runat="server">
                    <ItemTemplate>
                        <li class="list-group-item clearfix">
                            <asp:Label ID="lblNotificationName" runat="server" Text='<%# Eval("NotificationName") %>'></asp:Label>
                            <%--notification description tooltip:--%>
                            <span runat="server" enableviewstate="false"><a id="A1" enableviewstate="false" tabindex="0" title='<%# Eval("NotificationName")%>' runat="server" class="btn" role="button" data-html="true" data-toggle="popover" data-trigger="focus" data-placement="top" data-content='<%# Eval("BodyHTML") + "<p>Applicable to roles:</p><ul>" + Eval("RolesList") + "</ul>" %>'><i aria-hidden="true" class="icon-info"></i></a></span>
                            <asp:HiddenField ID="hfNotificationID" Value='<%# Eval("NotificationID")%>' runat="server" />
                            <input type="checkbox" id="cbYesNo" runat="server" class="pull-right" checked='<%# Eval("UserSubscribed")%>' data-toggle="toggle" data-on="Subscribed" data-off="Unsubscribed" data-onstyle="success pull-right" data-size="small" data-offstyle="danger pull-right">
                        </li> 
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
            <div class="panel-footer clearfix">
                <div class="row">
                    <div class="col-sm-9">
                        <div class="alert alert-warning"><b>NOTE:</b> Notification settings will be applied to all of your DPIA roles, including those at other organisations.</div>
                    </div>
                    <div class="col-sm-3">
                        <asp:LinkButton ID="lbtSaveNotificationSettings" CssClass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-check"></i> Save Preferences</asp:LinkButton>
                    </div>
                </div>
            </div>
        </asp:Panel>
       <%-- <asp:GridView ID="gvUserNotifications"  CssClass="table table-striped" GridLines="None" runat="server" AutoGenerateColumns="False" DataKeyNames="NotificationID" DataSourceID="dsUserNotifications">
            <Columns>
                <asp:BoundField DataField="NotificationName" HeaderText="NotificationName" SortExpression="NotificationName" />
                <asp:TemplateField HeaderText="UserSubscribed" SortExpression="UserSubscribed">
                    <ItemTemplate>
                        <asp:CheckBox ID="cbSubscribed" runat="server" class="pull-right" Checked='<%# Eval("UserSubscribed") %>' Enabled="false" data-toggle="toggle" data-on="Yes" data-off="No" data-onstyle="success pull-right" data-offstyle="danger pull-right" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
         </asp:GridView>--%>
    </div>
    <!-- Standard Modal Message  -->
    <div id="modalMessage" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><asp:Label ID="modalTitle" runat="server"></asp:Label></h4>
                </div>
                <div class="modal-body">
                    <p><asp:Label ID="modalText" runat="server"></asp:Label></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>
     <!-- Unsubscribe Modal Message  -->
    <div id="modalUnsubscribe" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Unsubscribe from ALL DPIA Email Notifications?</h4>
                </div>
                <div class="modal-body">
                    <p>Unsubscribing from all DPIA e-mail notifications will stop you from receiving essential DPIA workflow messages and may hamper your ability to fulfil your duties in an efficient way.</p>
                    <p>Are you sure that you wish to unsubscribe from ALL DPIA e-mail notifications?</p>
                </div>
                <div class="modal-footer">
                    <asp:LinkButton ID="LinkButton2" class="btn btn-default pull-left" runat="server">No</asp:LinkButton>
                    <asp:LinkButton ID="lbtConfirmUnsubscribe" CssClass="btn btn-primary pull-right"  runat="server">Yes</asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
      <!-- Unsubscribe Modal Message  -->
    <div id="modalSubscribe" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Reactivate DPIA E-mail Notifications?</h4>
                </div>
                <div class="modal-body">
                    <p>You currently have all DPIA e-mail notifications disabled.</p><p>Once reactivated, you will be able to control the notifications you receive using the Notification panel.</p>
                    <p>Would you like to reactivate e-mail notifications?</p>                    
                </div>
                <div class="modal-footer">
                    <asp:LinkButton ID="LinkButton1" class="btn btn-default pull-left" runat="server">No</asp:LinkButton>
                    <asp:LinkButton ID="lbtConfirmSubscribe" CssClass="btn btn-primary pull-right"  runat="server">Yes</asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        Sys.Application.add_load(BindEvents);
    </script>
</asp:Content>
