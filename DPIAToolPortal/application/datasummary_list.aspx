<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="datasummary_list.aspx.vb" Inherits="InformationSharingPortal.data_in_list" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="server">
    <h1>Data Sharing
        <asp:LinkButton ID="LinkButton1" CssClass="pull-right btn btn-success" PostBackUrl="~/application/summaries_list.aspx" ToolTip="Preview the new Data Sharing grid interface and let us know what you think" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-gift"></i> Try the new Data Sharing interface</asp:LinkButton></h1>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
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
    <script src="../Scripts/bs.pagination.js"></script>
    <div class="clearfix">
        <button type="button" class="btn btn-default pull-right" data-toggle="collapse" data-target="#FilterPanel">
            <i class="glyphicon glyphicon glyphicon-filter"></i>Filter / search...
        </button>
    </div>
    <asp:Panel ID="FilterPanel" runat="server" class="collapse filter-panel" ClientIDMode="Static">
        <div class="panel panel-default">
            <div class="panel-body">
                <div class="form-inline small" role="form">
                    <asp:ObjectDataSource ID="dsOrgsSharing" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.dashboardTableAdapters.isp_OrganisationsSharingTableAdapter">
                        <SelectParameters>
                            <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                    <div class="form-group">
                        <asp:Label ID="lblSearch" CssClass="filter-col" runat="server" Text="Share name:" AssociatedControlID="tbSearch"></asp:Label>
                        <asp:TextBox ID="tbSearch" CssClass="form-control input-sm" runat="server" placeholder="contains"></asp:TextBox>
                    </div>
                    <asp:Panel ID="pnlShareOrg" runat="server" CssClass="form-group">
                        <asp:Label ID="lblSharedWith" CssClass="control-label filter-col" runat="server" AssociatedControlID="ddSharingOrgs" Text="Sharing Organisation:"></asp:Label><asp:DropDownList ID="ddSharingOrgs" AppendDataBoundItems="true" runat="server" DataSourceID="dsOrgsSharing" CssClass="form-control input-sm" DataTextField="OrganisationName" DataValueField="OrganisationID">
                            <asp:ListItem Selected="True" Text="All" Value="0"></asp:ListItem>

                        </asp:DropDownList>
                    </asp:Panel>
                    <div class="form-group">
                        <asp:Label ID="lblAddedByMe" CssClass="filter-col" runat="server" Text="" AssociatedControlID="cbAddedByMe"> &nbsp;Only added by me?</asp:Label><asp:CheckBox ID="cbAddedByMe" runat="server" />
                    </div>
                    <div class="form-group">
                        <asp:Label ID="lblAddedByOrg" CssClass="filter-col" runat="server" Text="" AssociatedControlID="cbAddedByMyOrg"> &nbsp;Only added by my org?</asp:Label><asp:CheckBox ID="cbAddedByMyOrg" runat="server" />
                    </div>
                    <div class="form-group">
                        <asp:Label ID="lblHideArchived" CssClass="filter-col" runat="server" Text="" AssociatedControlID="cbHideArchived"> &nbsp;Hide archived?</asp:Label><asp:CheckBox ID="cbHideArchived" runat="server" Checked="True" />
                    </div>

                    <asp:LinkButton CssClass="btn btn-success pull-right" ID="lbtUpdateFilter" runat="server"><i class="glyphicon glyphicon-cog"></i> Update</asp:LinkButton>

                </div>
            </div>
        </div>
    </asp:Panel>

    <asp:ObjectDataSource ID="dsDFSummaries" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="SPGetFiltered" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DataFlowSummariesTableAdapter">
        <SelectParameters>
            <asp:Parameter DefaultValue="True" Name="ApplyFilter" Type="Boolean" />
            <asp:SessionParameter DefaultValue="" Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
            <asp:SessionParameter DbType="Guid" Name="UserID" SessionField="UserID" />
            <asp:ControlParameter ControlID="cbAddedByMe" DefaultValue="" Name="UserOnly" PropertyName="Checked" Type="Boolean" />
            <asp:ControlParameter ControlID="cbHideArchived" DefaultValue="1" Name="ExcludeArchived" PropertyName="Checked" Type="Boolean" />
            <asp:ControlParameter ControlID="cbAddedByMyOrg" Name="OrganisationOnly" PropertyName="Checked" Type="Boolean" />
            <asp:ControlParameter ControlID="tbSearch" DefaultValue="" Name="Identifier" PropertyName="Text" Type="String" />

            <asp:ControlParameter ControlID="ddSharingOrgs" DefaultValue="0" Name="SharingOrganisationID" PropertyName="SelectedValue" Type="Int32" />

        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
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
            <asp:GridView ID="gvFlowSummaries" AllowPaging="True" PagerStyle-CssClass="bs-pagination" CssClass="table table-striped" EmptyDataText="No data sharing summaries have yet been added that involve this organisation." AllowSorting="True" HeaderStyle-CssClass="sorted-none" GridLines="None" runat="server" AutoGenerateColumns="False" DataKeyNames="DataFlowID" DataSourceID="dsDFSummaries" PagerStyle-HorizontalAlign="Right">
                <Columns>

                    <asp:TemplateField HeaderText="View / Edit">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbtEdit" Visible='<%#Eval("SignedFlows") = 0%>' runat="server" CssClass="btn btn-default btn-sm" CausesValidation="False" ToolTip="Edit Sharing Summary" CommandName="EditShare" CommandArgument='<%#Eval("DataFlowID")%>' Text=""><i aria-hidden="true" class="icon-pencil"></i></asp:LinkButton>
                            <asp:LinkButton ID="lbtView" Visible='<%#Eval("SignedFlows") > 0%>' runat="server" CssClass="btn btn-default btn-sm" CausesValidation="False" ToolTip="View Sharing Summary" CommandName="EditShare" CommandArgument='<%#Eval("DataFlowID")%>' Text=""><i aria-hidden="true" class="icon-stack"></i></asp:LinkButton>

                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ISGID" InsertVisible="False" SortExpression="DataFlowID">
                        <EditItemTemplate>
                            <asp:Label Font-Bold="true" ID="Label3" runat="server" Text='<%# PadID(Eval("DataFlowID"))%>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label Font-Bold="true" ID="Label3" runat="server" Text='<%# PadID(Eval("DataFlowID"))%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Data Flows" SortExpression="DataFlowCount">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbtViewShares" runat="server" CssClass="btn btn-primary" CausesValidation="False" ToolTip="View / Edit Data Flows" CommandName="ViewShare" CommandArgument='<%#Eval("DataFlowID")%>'>
                                <asp:PlaceHolder ID="PlaceHolder1" runat="server"><i aria-hidden="true" class="icon-list"></i>
                                    <asp:Label ID="lblSharesBadge" CssClass="badge" runat="server" Text='<%#Eval("DataFlowCount")%>'></asp:Label>&nbsp;<asp:Label ID="lblLocked" runat="server" Visible='<%#Eval("SignedFlows") > 0%>' ToolTip="Locked for editing - data flows signed off"><i aria-hidden="true" class="icon-lock"></i></asp:Label></asp:PlaceHolder>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="DFName" HeaderText="Data Share Name" SortExpression="DFName" ItemStyle-CssClass="small">

                        <ItemStyle CssClass="small" />
                    </asp:BoundField>

                    <asp:BoundField DataField="DataAssetName" HeaderText="Asset Name" ReadOnly="True" SortExpression="DataAssetName" ItemStyle-CssClass="small">
                        <ItemStyle CssClass="small" />
                    </asp:BoundField>
                    <asp:BoundField DataField="DFSummaryAdded" DataFormatString="{0:d}" HeaderText="Added" SortExpression="DFSummaryAdded" ItemStyle-CssClass="small">
                        <ItemStyle CssClass="small" />
                    </asp:BoundField>
                    <asp:BoundField DataField="AddedByOrg" HeaderText="Added By Organisation" ItemStyle-CssClass="small">
                        <ItemStyle CssClass="small" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Review Date" SortExpression="ReviewDate">

                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("ReviewDate", "{0:d}")%>' CssClass='<%# IIf(Eval("OverDue")=2 AND Eval("DFArchivedDate").ToString.Length = 0, "small alert-danger", "small")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField ShowHeader="False">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbtArchive" runat="server" CssClass="btn btn-danger btn-sm" CausesValidation="False" ToolTip="Archive Sharing Summary" CommandName="ArchiveSummary" Visible='<%# (Session("UserRoleAdmin") Or Session("UserRoleSIRO") Or Session("UserRoleIAO") Or Session("UserRoleIGO")) And Eval("DFArchivedDate").ToString.Length = 0 And Eval("DFAddedByOrgID") = Session("UserOrganisationID") %>' CommandArgument='<%#Eval("DataFlowID")%>'><i aria-hidden="true" class="icon-remove"></i></asp:LinkButton>
                            <div runat="server" visible='<%#Eval("DFArchivedDate").ToString.Length > 0 %>' class="small">
                                <asp:Label ID="Label2" runat="server" CssClass="small" Text='<%# "Archived:<br/>" & Eval("DFArchivedDate", "{0:d}")%>'></asp:Label></div>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

                <HeaderStyle CssClass="sorted-none"></HeaderStyle>

                <PagerStyle HorizontalAlign="Right" CssClass="bs-pagination"></PagerStyle>
            </asp:GridView>
            <div id="modalArchive" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">Archive Data Sharing Summary</h4>

                        </div>
                        <div class="modal-body">
                            <p style="font-weight: bold;">What would you like to do?</p>

                            <hr>
                            <div class="row">
                                <div class="col-sm-12">
                                    <p>If the data sharing is still taking place, and all of the data flows are still relevant, all should be archived and reviewed.</p>
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
                                <div class="col-sm-12">
                                    <p>If the data sharing is still taking place, but the data flows have changed significantly or no data flows are currently recorded, the sharing summary should be archived and reviewed.</p>
                                    <ul>
                                        <li>The sharing summary and any existing <b>data flows will be archived</b></li>
                                        <li>A copy of the summary will be created.</li>
                                    </ul>
                                </div>
                                <div class="col-sm-12">
                                    <asp:LinkButton ID="lbtRecycleSummary" CausesValidation="false" CommandArgument="2" CssClass="btn btn-warning" runat="server">Archive All and Review Summary</asp:LinkButton>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-sm-12">
                                    <p>If the data sharing is no longer taking place, the summary and all of its data flows should be archived.</p>
                                    <ul>
                                        <li>The sharing summary and all of its data flows should be archived.
                                        </li>
                                    </ul>
                                </div>
                                <div class="col-sm-12">
                                    <asp:LinkButton ID="lbtArchiveConfirm" CausesValidation="false" CommandArgument="0" CssClass="btn btn-danger" runat="server">Archive All</asp:LinkButton>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button id="Button2" runat="server" type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="lbtUpdateFilter" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="lbtArchiveConfirm" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="lbtRecycleAll" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="lbtRecycleSummary" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>

    <asp:LinkButton ID="lbtAdd" CssClass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-plus"></i> <b>Add Summary</b> </asp:LinkButton>


    <script type="text/javascript">
        Sys.Application.add_load(BindEvents);
    </script>
</asp:Content>
