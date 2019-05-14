<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="home_intray.aspx.vb" Inherits="InformationSharingPortal.home_intray" %>

<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="server">
    <h1>Welcome</h1>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h4>
        Welcome
        <asp:Label ID="lblUserName" CssClass="text-capitalize" runat="server" Text="" />
    </h4>
    <hr />
    <div id="Div1" runat="server"  class="row">
        <div class="col-sm-12">
            <asp:Panel ID="Panel1" runat="server" cssclass="panel panel-default">                       
                <asp:Panel ID="Panel2" runat="server" cssclass="panel-heading">
                    <h4>Organisation Setup Progress</h4>
                </asp:Panel>
                <asp:Panel ID="pnlOrgSetup" CssClass="panel-body" runat="server">
                    <div class="progress">
                        <div id="orgprog" runat="server" class="progress-bar" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width:40%">
                            <asp:Label ID="lblOrgPercent" runat="server" Text="40%"></asp:Label>
                        </div>
                    </div>
                    <asp:Panel ID="pnlActionList" runat="server">
                        <ul class="list-group">
                            <li class="list-group-item"><i runat="server" id="firstIcon" class="glyphicon glyphicon-ok text-success" aria-hidden="true"></i> &nbsp;Register your organisation &nbsp;</li>
                            <li class="list-group-item"><i runat="server" id="eighthIcon" class="glyphicon glyphicon-ok text-success" aria-hidden="true"></i> &nbsp;Provide organisation contact e-mail address &nbsp;<asp:LinkButton ID="lbtAddContact" Visible="false" CssClass="btn btn-default" ToolTip="Go to Organisation Details to provide contact e-mail" runat="server" PostBackUrl="~/application/org_details.aspx">Go</asp:LinkButton></li>                                 
                            <li class="list-group-item"><i runat="server" id="secondIcon" class="glyphicon glyphicon-ok text-success" aria-hidden="true"></i> &nbsp; Register an administrator &nbsp;<asp:LinkButton ID="lbtRegAdmin" Visible="false" CssClass="btn btn-default" ToolTip="Go to Organisation Users to register an Administrator" runat="server" PostBackUrl="~/application/org_users.aspx">Go</asp:LinkButton></li> 
                            <li class="list-group-item"><i runat="server" id="thirdIcon" class="glyphicon glyphicon-ok text-success" aria-hidden="true"></i> &nbsp; Register a Senior Officer &nbsp;<asp:LinkButton ID="lbtRegSenior" Visible="false" CssClass="btn btn-default" ToolTip="Go to Organisation Users to register an Senior Officer" runat="server" PostBackUrl="~/application/org_users.aspx">Go</asp:LinkButton><asp:LinkButton ID="lbtRegSeniorVideo" CssClass="btn btn-default pull-right" runat="server" Visible="False"><i aria-hidden="true" class="glyphicon glyphicon-film"></i></asp:LinkButton></li>
                            <li runat="server" id="liDPO" class="list-group-item"><i runat="server" id="ninthIcon" class="glyphicon glyphicon-ok text-success" aria-hidden="true"></i> &nbsp; Register a Data Protection Officer &nbsp;<asp:LinkButton ID="lbtRegDPO" Visible="false" CssClass="btn btn-default" ToolTip="Go to Organisation Users to register a DPO" runat="server" PostBackUrl="~/application/org_users.aspx">Go</asp:LinkButton></li>
                            <li class="list-group-item"><i runat="server" id="fourthIcon" class="glyphicon glyphicon-ok text-success" aria-hidden="true"></i> &nbsp; Submit organisation assurance &nbsp;<asp:LinkButton ID="lbtAssurance" Visible="false" CssClass="btn btn-default" ToolTip="Go to Organisation Assurance to submit" runat="server" PostBackUrl="~/application/org_assurance.aspx">Go</asp:LinkButton><asp:LinkButton ID="lbtAssuranceVideo" CssClass="btn btn-default pull-right" runat="server" Visible="False"><i aria-hidden="true" class="glyphicon glyphicon-film"></i></asp:LinkButton></li>
                            <li class="list-group-item"><i runat="server" id="fifthIcon" class="glyphicon glyphicon-ok text-success" aria-hidden="true"></i> &nbsp; Sign off the MOU (Senior Officer only) &nbsp;<asp:LinkButton ID="lbtMOU" Visible="false" CssClass="btn btn-default" ToolTip="Go to Organisation Assurance to sign MOU (Senior Officers only)" runat="server" PostBackUrl="~/application/org_assurance.aspx">Go</asp:LinkButton><asp:LinkButton ID="lbtMOUVideo" CssClass="btn btn-default pull-right" runat="server" Visible="False"><i aria-hidden="true" class="glyphicon glyphicon-film"></i></asp:LinkButton></li>
                        </ul>
                    </asp:Panel>
                </asp:Panel>
            </asp:Panel>
        </div>
    </div>
    <hr />
    <asp:ObjectDataSource ID="dsNotices" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetCurrentForUserEmail" TypeName="InformationSharingPortal.adminTableAdapters.SANotificationsTableAdapter">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="UserEmail" SessionField="UserEmail" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:Panel ID="pnlNotices" runat="server">
        <div class="panel panel-warning">
            <div class="panel-heading"><h4>You have <asp:Label ID="lblNotificationCount" runat="server" Text="0"></asp:Label> new notification(s). </h4></div>
            <div class="panel-body">
                <asp:Repeater ID="rptNotifications" runat="server" DataSourceID="dsNotices">
                    <ItemTemplate>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <asp:Label ID="lblSubject" Font-Bold="true" runat="server" Text='<%# Eval("SubjectLine")%>'></asp:Label><asp:Label CssClass="pull-right" ID="Label6" runat="server" Text='<%# Eval("DateAdded", "{0:d}")%>'></asp:Label>
                            </div>
                            <div class="panel-body">
                                <asp:Literal ID="litNotification" Text='<%# Eval("BodyHTML")%>' runat="server"></asp:Literal>
                                <div class="clearfix">
                                    <asp:LinkButton ID="lbtAcknowledge" CssClass="btn btn-default pull-right" CommandArgument='<%# Eval("SANotificationID")%>' CommandName="AcknowledgeNotice" runat="server"><i aria-hidden="true" class="icon-checkmark"></i> Acknowledge</asp:LinkButton>
                                </div>
                            </div>                
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="panel-footer clearfix">
                <div class="checkbox pull-right">
                    <asp:CheckBox AutoPostBack="true" ID="cbSubSANotifications" CssClass="small" ToolTip="send me an e-mail when I receive a new notification" Text="subscribe to e-mail notification" runat="server" />
                </div>
            </div>
        </div>       
    <hr />
    </asp:Panel>
    <h4>
        There are
        <asp:Label ID="lblForAttention" runat="server" Text="0"></asp:Label>
        items needing your attention.
    </h4>
    <div class="container-fluid">
        <asp:Panel id="TOUAcknowledge" runat="server"  class="row">
            <div class="col-sm-12">
                <div class="panel panel-warning">                       
                    <div class="panel-heading">                            
                        <h4><asp:Label ID="Label2" runat="server" Text="Changes to DPIA Terms and Conditions of Use"></asp:Label></h4>
                    </div>
                    <div class="panel-body">
                        <p>We have updated the ISG Terms and Conditions of Use. The summary of changes is as follows:</p>
                        <div class="well">
                            <asp:Literal ID="litTOUSummary" runat="server"></asp:Literal>
                        </div>
                        <p>Click to view the full <a style="cursor:pointer;" data-toggle="modal" data-target="#termsMessage">  Terms and Conditions of Use </a>.</p>
                        <p>If you have any querires about the changes to the Terms and Conditions of Use, please raise a support ticket using the <asp:LinkButton ID="LinkButton1" PostBackUrl="~/application/support_tickets.aspx" runat="server">Help tab</asp:LinkButton> above.</p>
                        <asp:LinkButton ID="lbtAgreeTOU" CssClass="btn btn-primary pull-right" runat="server">Agree to Updated Terms of Use</asp:LinkButton>
                    </div>
                </div>
            </div>
        </asp:Panel>
        <div id="ICOExpired" runat="server"  class="row">
            <div class="col-sm-12">
                <asp:Panel ID="pnlIcoExpiry" runat="server" cssclass="panel panel-default">                      
                    <asp:Panel ID="pnlIcoExpiryHead" runat="server" cssclass="panel-heading">                           
                        <h4><asp:Label ID="lblICOExpiryHeader" runat="server" Text="Label"></asp:Label></h4>
                    </asp:Panel>
                           
                    <asp:Panel ID="pnlExpiryBody" CssClass="panel-body" runat="server">
                        <p><asp:Label ID="lblICOExpiryBody" runat="server" Text="Label"></asp:Label></p>
                        <p><asp:LinkButton ID="lbtOrgAssurance" PostBackUrl="~/application/org_assurance.aspx" ToolTip="Submit new assurance" runat="server" CssClass="btn btn-default pull-right">Review assurance</asp:LinkButton></p>
                    </asp:Panel>
                    <%--<div class="panel-footer clearfix">
                            <div class="checkbox pull-right">
                                <asp:CheckBox AutoPostBack="true" ID="CheckBox1" CssClass="small" ToolTip="send me an e-mail when my ICO registration is about to expire" Text="subscribe to e-mail notification" runat="server" />
                            </div>
                        </div>--%>                        
                </asp:Panel>
            </div>
        </div>
        <asp:ObjectDataSource ID="dsNewAssurance" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.InTrayTableAdapters.isp_AssuranceSubmissionsTableAdapter">
            <SelectParameters>
                <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
            </SelectParameters>
        </asp:ObjectDataSource>

        <div class="row">
            <div class="col-sm-12">
                <div id="divNewSubmissions" runat="server" class="panel panel-default">
                    <div class="panel-heading">
                        <h4>New Assurance Submissions from Supported Organisations</h4>
                    </div>
                    <div class="table-responsive">
                        <asp:GridView ID="gvNewAssuranceSubs" CssClass="table table-striped" runat="server" AutoGenerateColumns="False" DataKeyNames="AssuranceSubmissionID" DataSourceID="dsNewAssurance" HeaderStyle-CssClass="sorted-none" GridLines="None" AllowSorting="True" EmptyDataText="There are no outstanding sponsorship requests requiring your attention.">
                            <Columns>
                                <asp:BoundField DataField="OrganisationName" HeaderText="OrganisationName" ReadOnly="True" SortExpression="OrganisationName" />
                                <asp:BoundField DataField="SubmittedByUserName" HeaderText="Submitted By" SortExpression="SubmittedByUserName" />
                                <asp:BoundField DataField="SubmittedDate" HeaderText="Date" SortExpression="SubmittedDate" />
                                <asp:TemplateField HeaderText="Assurance" SortExpression="Assurance">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSignificant" Width="85px" runat="server" CssClass="label label-success" Visible='<%# Eval("Assurance") = 0%>'>Significant</asp:Label>
                                        <asp:Label ID="Label3" Width="85px" runat="server" CssClass="label label-warning" Visible='<%# Eval("Assurance") = 1%>'>Limited</asp:Label>
                                        <asp:Label ID="Label4" Width="85px" runat="server" CssClass="label label-danger" Visible='<%# Eval("Assurance") > 1%>'>None</asp:Label>
                                        <asp:Label ID="Label5" Width="85px" runat="server" CssClass="label label-default" Visible='<%# Eval("Assurance") = -1%>'>Not submitted</asp:Label>
                                        <asp:Label ID="Label7" Width="85px" runat="server" CssClass="label label-default" Visible='<%# Eval("Assurance") = -11%>'>ISG Inactive</asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Acknowledge" ShowHeader="True">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtAcknowledge" CommandName="Acknowledge" CommandArgument='<%# Eval("AssuranceSubmissionID")%>' CssClass="btn btn-primary button-small" ToolTip="Acknowledge assurance" runat="server"><i aria-hidden="true" class="icon-checkmark"></i></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="sorted-none" />
                        </asp:GridView>
                    </div>
                    <div class="panel-footer clearfix">
                        <div class="checkbox pull-right">
                            <asp:CheckBox AutoPostBack="true" ID="cbNewAssuranceNotifications" CssClass="small" ToolTip="send me an e-mail when supported organisations submit assurance" Text="subscribe to e-mail notification" runat="server" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12">
                <asp:Panel ID="pnlSignatureRequests" runat="server" CssClass="panel panel-default">
                    <div class="panel-heading">
                        <h4>Data Flow Sign-off Requests</h4>
                    </div>
                    <asp:ObjectDataSource ID="dsSignOffRequests" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataNew" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_MySignOffRequestsTableAdapter">
                        <SelectParameters>
                            <asp:SessionParameter Name="Email" SessionField="UserEmail" Type="String" />
                            <asp:SessionParameter DefaultValue="" Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <div class="table-responsive">
                        <asp:GridView ID="gvSignOffRequests" CssClass="table table-striped" runat="server" AutoGenerateColumns="False" DataKeyNames="SignOffRequestID" DataSourceID="dsSignOffRequests" HeaderStyle-CssClass="sorted-none" GridLines="None" AllowSorting="True" EmptyDataText="There are no data flow sign-off requests requiring your attention.">
                            <Columns>
                                <asp:BoundField DataField="DataFlowName" HeaderText="Data Flow" ReadOnly="True" SortExpression="DataFlowName" />
                                <asp:BoundField DataField="SummaryName" HeaderText="Summary" ReadOnly="True" SortExpression="SummaryName" />
                                <asp:BoundField DataField="Asset" HeaderText="Asset" ReadOnly="True" SortExpression="Asset" />                                       
                                <asp:TemplateField HeaderText="Requestor" SortExpression="RequestedBy">
                                    <ItemTemplate><a runat="server" href='<%# "mailto:" & Eval("RequestedBy") %>'>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("RequestedBy") %>'></asp:Label></a>
                                    </ItemTemplate>
                                </asp:TemplateField> 
                                <asp:BoundField DataField="RequestedDate" HeaderText="Requested" SortExpression="RequestedDate" DataFormatString="{0:d}" />
                                <asp:BoundField DataField="SignByDate" HeaderText="Sign By" SortExpression="SignByDate"  ItemStyle-CssClass="text-danger" DataFormatString="{0:d}" />
                                <asp:TemplateField HeaderText="" ShowHeader="False">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtReview" CommandName="ReviewFlow" CommandArgument='<%#Eval("DataFlowID")%>' CssClass="btn btn-default button-small" ToolTip="Review / Sign" runat="server"><i aria-hidden="true" class="icon-search"></i> Review</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="sorted-none" />
                        </asp:GridView>
                    </div>
                    <div class="panel-footer clearfix">
                        <div class="checkbox pull-right">
                            <asp:CheckBox ID="cbDataFlowSignOffRequests" AutoPostBack="true" CssClass="small" ToolTip="send me an e-mail when I receive a new Data Flow Sign-off request" Text="subscribe to e-mail notification" runat="server" />
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12">
                <asp:Panel ID="pnlDPOReviewRequests" runat="server" CssClass="panel panel-default">
                    <div class="panel-heading">
                        <h4>Data Flow DPO Review Requests</h4>
                    </div>
                    <asp:ObjectDataSource ID="dsDPOReviewRequests" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.InTrayTableAdapters.MyDPOReviewsTableAdapter">
                        <SelectParameters>
                            <asp:SessionParameter Name="DPOEmail" SessionField="UserEmail" Type="String" />
                            <asp:SessionParameter DefaultValue="" Name="DPOOrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <div class="table-responsive">
                        <asp:GridView ID="gvDPOReviewRequests" CssClass="table table-striped" runat="server" AutoGenerateColumns="False" HeaderStyle-CssClass="sorted-none" GridLines="None" AllowSorting="True" EmptyDataText="There are no data flow sign-off requests requiring your attention." DataKeyNames="DPOReviewID" DataSourceID="dsDPOReviewRequests">                                    
                            <Columns>
                                <asp:BoundField DataField="DataFlow" HeaderText="Data Flow" ReadOnly="True" SortExpression="DataFlow" />
                                <asp:BoundField DataField="Organisation" HeaderText="Data Flow Organisation" SortExpression="Organisation" />
                                <asp:TemplateField HeaderText="Requestor" SortExpression="RequestUserEmail">
                                    <ItemTemplate><a runat="server" href='<%# "mailto:" & Eval("RequestUserEmail") %>'>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("RequestUserEmail") %>'></asp:Label></a>
                                    </ItemTemplate>
                                </asp:TemplateField>                                         
                                <asp:BoundField DataField="RequestedDTT" DataFormatString="{0:d}" HeaderText="Requested" SortExpression="RequestedDTT" />
                                <asp:BoundField DataField="ReviewByDTT" DataFormatString="{0:d}" HeaderText="Review By" SortExpression="ReviewByDTT" />
                                <asp:TemplateField HeaderText="Review">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtReview" CommandName="ReviewFlow" CommandArgument='<%#Eval("DataFlowDetailID")%>' CssClass="btn btn-default button-small" ToolTip="Review data flow" runat="server"><i aria-hidden="true" class="icon-search"></i> Review</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="sorted-none" />                                    
                        </asp:GridView>
                    </div>
                    <div class="panel-footer clearfix">
                        <div class="checkbox pull-right">
                            <asp:CheckBox ID="cbDPOReviewRequests" AutoPostBack="true" CssClass="small" ToolTip="send me an e-mail when I receive a new Data Flow DPO Review request" Text="subscribe to e-mail notification" runat="server" />
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12">
                <asp:Panel ID="pnlDPOReviewsCompleted" runat="server" CssClass="panel panel-default">
                    <div class="panel-heading">
                        <h4>DPO Reviews Completed</h4>
                    </div>
                    <asp:ObjectDataSource ID="dsDPOReviewsCompleted" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetForRequestor" TypeName="InformationSharingPortal.InTrayTableAdapters.MyDPOReviewsTableAdapter">
                        <SelectParameters>
                            <asp:SessionParameter Name="RequestorEmail" SessionField="UserEmail" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <div class="table-responsive">
                        <asp:GridView ID="gvDPOReviewsCompleted" CssClass="table table-striped" runat="server" AutoGenerateColumns="False" HeaderStyle-CssClass="sorted-none" GridLines="None" AllowSorting="True" EmptyDataText="There are no data flow sign-off requests requiring your attention." DataKeyNames="DPOReviewID" DataSourceID="dsDPOReviewsCompleted">
                            <Columns>
                                <asp:BoundField DataField="DataFlow" HeaderText="Data Flow" ReadOnly="True" SortExpression="DataFlow" />
                                <asp:TemplateField HeaderText="Reviewer" SortExpression="DPOEmail">
                                    <ItemTemplate><a runat="server" href='<%# "mailto:" & Eval("DPOEmail") %>'>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("DPOEmail") %>'></asp:Label></a>
                                    </ItemTemplate>
                                </asp:TemplateField> 
                                <asp:BoundField DataField="RequestedDTT" DataFormatString="{0:d}" HeaderText="Requested" SortExpression="RequestedDTT" />
                                <asp:BoundField DataField="ReviewedDTT" DataFormatString="{0:d}" HeaderText="Reviewed" SortExpression="ReviewedDTT" />
                                <asp:TemplateField HeaderText="Outcome" SortExpression="Approved">
                                    <ItemTemplate>
                                        <asp:Label ID="lblApproved" Width="85px" runat="server" CssClass="label label-success" Visible='<%# Eval("Approved") %>'>Approved</asp:Label>
                                        <asp:Label ID="Label4" Width="85px" runat="server" CssClass="label label-danger" Visible='<%# Not Eval("Approved") %>'>Rejected</asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Review">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtReview" CommandName="ReviewFlow" CommandArgument='<%#Eval("DataFlowDetailID")%>' CssClass="btn btn-default button-small" ToolTip="Review data flow" runat="server"><i aria-hidden="true" class="icon-search"></i> Review</asp:LinkButton>&nbsp;&nbsp;
                                        <asp:LinkButton ID="lbtAcknowledge" CommandName="Acknowledge" CommandArgument='<%#Eval("DPOReviewID")%>' CssClass="btn btn-info button-small" ToolTip="Acknowledge and clear from in-tray" runat="server"><i aria-hidden="true" class="icon-checkmark"></i> Acknowledge</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="sorted-none" />                                    
                        </asp:GridView>
                    </div>
                    <div class="panel-footer clearfix">
                        <div class="checkbox pull-right">
                            <asp:Label ID="lblReviewsCompleteNotice" runat="server" CssClass="small" Text="DPO Reviews completeted e-mail notifications are mandatory unless you have unsubscribed from e-mails"></asp:Label>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12">
                <asp:Panel ID="pnlAckReviewSignOff" runat="server" CssClass="panel panel-default">
                    <div class="panel-heading">
                        <h4>Acknowledge Sign Off Requests</h4>
                    </div>
                    <asp:ObjectDataSource ID="dsAckReviewSignOff" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetForRequestor" TypeName="InformationSharingPortal.InTrayTableAdapters.MyAckRequestSignOffTableAdapter">
                        <SelectParameters>
                            <asp:SessionParameter DefaultValue="" Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                            <asp:SessionParameter Name="RequestorEmail" SessionField="UserEmail" Type="String" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <div class="table-responsive">
                        <asp:GridView ID="gvAckReviewSignOff" CssClass="table table-striped" runat="server" AutoGenerateColumns="False" HeaderStyle-CssClass="sorted-none" GridLines="None" AllowSorting="True" EmptyDataText="There are no data flow sign-off requests requiring your acknowledgement." DataKeyNames="DPOAckID" DataSourceID="dsAckReviewSignOff">
                            <Columns>
                                <asp:BoundField DataField="DataFlow" HeaderText="Data Flow" ReadOnly="True" SortExpression="DataFlow" />
                                <asp:TemplateField HeaderText="Requested By" SortExpression="SignOffRequestedBy">
                                    <ItemTemplate><a runat="server" href='<%# "mailto:" & Eval("SignOffRequestedBy") %>'>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("SignOffRequestedBy") %>'></asp:Label></a>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="RequestedDTT" DataFormatString="{0:d}" HeaderText="Requested On" SortExpression="RequestedDTT" />
                                <asp:TemplateField HeaderText="Acknowledge">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtAcknowledge" CommandName="Acknowledge" CommandArgument='<%#Eval("DPOAckID")%>' CssClass="btn btn-info button-small" ToolTip="Acknowledge and clear from in-tray" runat="server"><i aria-hidden="true" class="icon-checkmark"></i> Acknowledge</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Review">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtReview" CommandName="ReviewFlow" CommandArgument='<%#Eval("DataFlowDetailID")%>' CssClass="btn btn-default button-small" ToolTip="Review data flow" runat="server"><i aria-hidden="true" class="icon-search"></i> Review</asp:LinkButton>&nbsp;&nbsp;
                                    </ItemTemplate>
                                </asp:TemplateField>        
                            </Columns>
                            <HeaderStyle CssClass="sorted-none" />                                    
                        </asp:GridView>
                    </div>
                </asp:Panel>
            </div>
        </div>


    </div>




    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <%--<h4 class="modal-title" id="myModalLabel"><asp:Label ID="lblVideo" runat="server" Text="Label"></asp:Label></h4>--%>
                </div>
                <div class="modal-body">
                    <div class="embed-responsive embed-responsive-4by3">
                        <video controls="controls" autoplay="autoplay">
                            <source src="" id="videosrc" runat="server" type="video/mp4" />
                            <object type="application/x-shockwave-flash" data="swf/VideoPlayer.swf" width="640" height="480">
                                <param name="movie" value="swf/VideoPlayer.swf">
                                <param name="allowFullScreen" value="true"><param name="wmode" value="transparent">
                                <param id="vidparm" runat="server" name="flashVars" value=""/>
                                <span>Video not supported</span>
                            </object>
                        </video>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $('#myModal').on('hidden.bs.modal', function () {
            $('video').trigger('pause');
        })
    </script>

</asp:Content>
