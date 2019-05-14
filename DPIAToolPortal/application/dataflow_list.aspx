<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="dataflow_list.aspx.vb" Inherits="InformationSharingPortal.dataflow_list" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="server">
    <script src="../Scripts/bs.pagination.js"></script>
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
    <h1>Data Flow List</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container">
        <asp:ObjectDataSource ID="dsDFSummaries" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="SPGetFiltered" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DataFlowSummariesTableAdapter">
            <SelectParameters>
                <asp:Parameter DefaultValue="False" Name="ApplyFilter" Type="Boolean" />
                <asp:SessionParameter DefaultValue="" Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                <asp:SessionParameter DbType="Guid" Name="UserID" SessionField="UserID" />
                <asp:Parameter DefaultValue="False" Name="UserOnly" Type="Boolean" />
                <asp:Parameter DefaultValue="False" Name="ExcludeArchived" Type="Boolean" />
                <asp:Parameter DefaultValue="False" Name="OrganisationOnly" Type="Boolean" />
                <asp:Parameter DefaultValue="''" Name="Identifier" Type="String" />
                <asp:Parameter DefaultValue="0" Name="SharingOrganisationID" Type="Int32" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="dsDFStatus" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFStatusTableAdapter"></asp:ObjectDataSource>
        <%--<asp:ObjectDataSource ID="dsDataFlowDetailList" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetBySummaryID" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DataFlowDetailTableAdapter">
              <SelectParameters>
                  <asp:ControlParameter ControlID="ddSummarySelect" Name="DataSummaryID" PropertyName="SelectedValue" Type="Int32" />
              </SelectParameters>
          </asp:ObjectDataSource>--%>
        <asp:ObjectDataSource ID="dsDataFlowDetailList" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.DataFlowDetail_GetFilteredTableAdapter">
            <SelectParameters>
                <asp:Parameter DefaultValue="True" Name="ApplyFilter" Type="Boolean" />
                <asp:SessionParameter DefaultValue="" Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                <asp:ControlParameter ControlID="cbHideArchived" DefaultValue="" Name="ExcludeArchived" PropertyName="Checked" Type="Boolean" />
                <asp:ControlParameter ControlID="cbAddedByMyOrg" Name="OrganisationOnly" PropertyName="Checked" Type="Boolean" />
                <asp:ControlParameter ControlID="cbInvolvingMyOrg" Name="InvolvingMyOrg" PropertyName="Checked" Type="Boolean" />
                <asp:ControlParameter ControlID="tbSearch" Name="Identifier" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="ddSharingOrgs" Name="SharingOrganisationID" PropertyName="SelectedValue" Type="Int32" />
                <asp:ControlParameter ControlID="ddStatus" DefaultValue="0" Name="StatusID" PropertyName="SelectedValue" Type="Int32" />
                <asp:ControlParameter ControlID="ddSummarySelect" Name="SummaryID" PropertyName="SelectedValue" Type="Int32" />
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

                        <asp:ObjectDataSource ID="dsOrgsSharing" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.dashboardTableAdapters.isp_OrganisationsSharingTableAdapter">
                            <SelectParameters>
                                <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>

                        <div class="form-group">
                            <asp:Label ID="lblSearch" CssClass="filter-col" runat="server" Text="Share name:" AssociatedControlID="tbSearch"></asp:Label>
                            <asp:TextBox ID="tbSearch" CssClass="form-control input-sm" runat="server" placeholder="contains"></asp:TextBox>
                        </div>
                        <asp:Panel ID="pnlSummary" runat="server" CssClass="form-group">
                            <asp:Label ID="lblSelectSummary" CssClass="form-group" runat="server" Text="Choose summary:" AssociatedControlID="ddSummarySelect"></asp:Label>
                            <asp:DropDownList ID="ddSummarySelect" CssClass="form-control input-sm" AppendDataBoundItems="true" runat="server" DataSourceID="dsDFSummaries" DataTextField="DFName" DataValueField="DataFlowID" CausesValidation="False">
                                <asp:ListItem Selected="True" Value="-1" Text="Any"></asp:ListItem>
                            </asp:DropDownList>
                        </asp:Panel>
                        <asp:Panel ID="pnlStatus" runat="server" CssClass="form-group">
                            <asp:Label ID="lblStatus" CssClass="filter-col" AssociatedControlID="ddStatus" runat="server" Text="Flow status:"></asp:Label>
                            <asp:DropDownList CssClass="form-control input-sm" ID="ddStatus" AppendDataBoundItems="true" runat="server" DataSourceID="dsDFStatus" DataTextField="StatusText" DataValueField="DFStatusID">
                                <asp:ListItem Selected="True" Text="Any" Value="0" />
                            </asp:DropDownList>
                        </asp:Panel>
                        <div class="form-group">
                            <asp:Label ID="lblHideArchived" CssClass="filter-col" runat="server" Text="" AssociatedControlID="cbHideArchived"> &nbsp;Hide archived?</asp:Label><asp:CheckBox ID="cbHideArchived" runat="server" Checked="True" />
                        </div>
                        <asp:Panel ID="pnlShareOrg" runat="server" CssClass="form-group">
                            <asp:Label ID="lblSharedWith" CssClass="control-label filter-col" runat="server" AssociatedControlID="ddSharingOrgs" Text="Sharing Organisation:"></asp:Label><asp:DropDownList ID="ddSharingOrgs" AppendDataBoundItems="true" runat="server" DataSourceID="dsOrgsSharing" CssClass="form-control input-sm" DataTextField="OrganisationName" DataValueField="OrganisationID">
                                <asp:ListItem Selected="True" Text="All" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </asp:Panel>
                        <div class="form-group">
                            <asp:Label ID="lblInvolvingMyOrg" CssClass="filter-col" runat="server" Text="" AssociatedControlID="cbInvolvingMyOrg"> &nbsp;Only involving my org?</asp:Label><asp:CheckBox ID="cbInvolvingMyOrg" runat="server" Checked="True" />
                        </div>
                        <div class="form-group">
                            <asp:Label ID="lblAddedByOrg" CssClass="filter-col" runat="server" Text="" AssociatedControlID="cbAddedByMyOrg"> &nbsp;Only added by my org?</asp:Label><asp:CheckBox ID="cbAddedByMyOrg" runat="server" />
                        </div>
                        <asp:LinkButton CssClass="btn btn-success pull-right" ID="lbtUpdateFilter" runat="server"><i class="glyphicon glyphicon-cog"></i> Update</asp:LinkButton>
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:GridView ID="gvFlows" CssClass="table table-striped" AllowSorting="True" HeaderStyle-CssClass="sorted-none" GridLines="None" runat="server" DataSourceID="dsDataFlowDetailList" AutoGenerateColumns="False" DataKeyNames="DataFlowID" AllowPaging="true" PageSize="15" EmptyDataText="There are no data flows matching your filter criteria.">
                    <Columns>
                       
                        <asp:TemplateField HeaderText="View / Edit">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtEdit" Visible='<%# Eval("Signatures") = 0 And Eval("InDraft")%>' CommandName="Edit" CssClass="btn btn-default btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Edit data flow" runat="server"><i aria-hidden="true" class="icon-pencil"></i></asp:LinkButton>
                                <asp:LinkButton ID="lbtView" Visible='<%# Eval("Signatures") > 0 Or Not Eval("InDraft")%>' CommandName="Edit" CssClass="btn btn-default btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="View data flow" runat="server"><i aria-hidden="true" class="icon-file"></i></asp:LinkButton>

                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ISGID" InsertVisible="False" SortExpression="DataFlowID">
                            
                            <ItemTemplate>
                                <asp:Label ID="Label1" class="text-muted" Font-Bold="true"  runat="server" Text='<%# PadID(Eval("DataFlowID"))%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="Signatures">
                            <ItemTemplate>
                                <table>
                                    <tr>
                                        <td style="width:25%;"> <asp:label runat="server" ID="lblStatusDraft" Visible='<%#Eval("InDraft") And Eval("Signatures") = 0%>' Tooltip="Draft"><i aria-hidden="true" class="icon-unlocked"></i></asp:label>
                               <asp:label  runat="server" ID="lblStatusFinal" Visible='<%#Not Eval("InDraft") Or Eval("Signatures") > 0%>' Tooltip="Final"><i aria-hidden="true" class="icon-lock"></i></asp:label>
                               </td>
                                        
                                        <td style="width:25%;"> <asp:label  runat="server" ID="Label2" Visible='<%#Eval("AddedByOrganisation") = Session("UserOrganisationName")%>' Tooltip="Created By My Organisation"><i aria-hidden="true" class="icon-home"></i></asp:label>
                              </td>
                                        <td style="width:25%;"><asp:label  runat="server" ID="Label3" Visible='<%#Eval("MyOrgSigned") > 0%>' Tooltip="Signed Off By My Organisation"><i aria-hidden="true" class="icon-quill"></i> </asp:label></td>
                                        <td style="width:25%;"><span>
                                <asp:Label  ID="lblLocked" Font-Size="Smaller"  Font-Bold="true" runat="server" Visible='<%#Not Eval("InDraft") Or Eval("Signatures") > 0%>' ToolTip='<%# Eval("Signatures") & "/" & (CInt(Eval("OrgsInvolved")) + CInt(Eval("SignatureRequests"))).ToString & " organisations signed"%>'><%# Eval("Signatures") & "/" & (CInt(Eval("OrgsInvolved")) + CInt(Eval("SignatureRequests"))).ToString%></asp:Label></span></td>
                                    </tr>
                                </table>
                                 <br />
                                

                            </ItemTemplate>
                        </asp:TemplateField>
                         
                        <asp:BoundField DataField="SummaryName" HeaderText="Summary Name" SortExpression="SummaryName" />
                        <asp:BoundField DataField="DataFlowIdentifier" HeaderText="Data Flow Name / Identifier" SortExpression="DataFlowIdentifier" />
                        <asp:TemplateField HeaderText="Risk Rating" SortExpression="RiskRating">

                            <ItemTemplate>
                                <asp:Label Width="90px" ID="lblHigh" Visible='<%# Eval("RiskRating") = "High"%>' tooltip="1 or more high risks identified or a significant number of medium risks" runat="server" CssClass="label label-danger" Text='<%# Eval("RiskRating")%>'></asp:Label>
                                <asp:Label Width="90px" ID="lblSig" Visible='<%# Eval("RiskRating") = "Significant"%>' ToolTip="2 or more medium risks identified" runat="server" CssClass="label label-warning" Text='<%# Eval("RiskRating")%>'></asp:Label>
                                <asp:Label Width="90px" ID="lblLow" Visible='<%# Eval("RiskRating") = "Low"%>' ToolTip="Only low risks and less than 3 medium risks identified" runat="server" CssClass="label label-success" Text='<%# Eval("RiskRating")%>'></asp:Label>
                                <asp:Label Width="90px" ID="lblNone" Visible='<%# Eval("RiskRating") = "Not Assessed"%>' ToolTip="No risk assessment submitted" runat="server" CssClass="label label-default" Text='<%# Eval("RiskRating")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="AddedDate" DataFormatString="{0:d}" HeaderText="Added" SortExpression="AddedDate" />
                        <asp:BoundField DataField="FirstSigned" DataFormatString="{0:d}" HeaderText="First Signed" SortExpression="FirstSigned" />
                        <asp:BoundField DataField="Archived" DataFormatString="{0:d}" HeaderText="Archived" SortExpression="Archived" />
                        <asp:TemplateField HeaderText="Export">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtExport" Visible='<%# Not Session("orgLicenceType") = "Free, limited licence"%>' CommandName="Export" CssClass="btn btn-default btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Export Data Sharing Agreement to PDF" runat="server"><i aria-hidden="true" class="icon-file-pdf-o"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Copy">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtCopy" Visible='<%# Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO") %>' CommandName="Copy" CssClass="btn btn-info btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Copy data flow" runat="server"><i aria-hidden="true" class="icon-copy"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Archive / Delete">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtDelete" Visible='<%# (Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO")) And Eval("AddedByOrgID") = Session("UserOrganisationID") And Eval("InDraft") And Eval("Signatures") = 0 %>' CommandName="DeleteFlow" OnClientClick="return confirm('Are you sure you want to delete this data flow?');" CssClass="btn btn-danger btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Delete data flow" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-remove"></i></asp:LinkButton>
                                <asp:LinkButton ID="lbtArchive" Visible='<%# (Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO")) And Eval("Archived").ToString.Length = 0 And Eval("AddedByOrgID") = Session("UserOrganisationID") And (Not Eval("InDraft") Or Eval("Signatures") > 0)  %>' CommandName="Archive" OnClientClick="return confirm('Are you sure you want to archive this data flow? If the flow is due to be reviewed, you should archive the summary instead to generate copies of the summary and associated flows.');" CssClass="btn btn-danger btn-sm" CommandArgument='<%# Eval("DataFlowID")%>' ToolTip="Archive data flow" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-trash"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle HorizontalAlign="Right" CssClass="bs-pagination"></PagerStyle>
                    <HeaderStyle CssClass="sorted-none" />
                </asp:GridView>

                <asp:LinkButton ID="lbtAdd" CssClass="btn btn-primary pull-right" runat="server" ValidationGroup="vgSelectSummary" CausesValidation="True"><i aria-hidden="true" class="icon-plus"></i> <b>Add Data Flow</b> </asp:LinkButton>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="lbtUpdateFilter" EventName="Click" />
                <asp:PostBackTrigger ControlID="lbtExportDFList" />
                <asp:PostBackTrigger ControlID="gvFlows" />
            </Triggers>
        </asp:UpdatePanel>
        <asp:LinkButton ID="lbtExportDFList" CssClass="btn btn-default pull-left" ToolTip="Export filtered data flows to Excel" CausesValidation="false" runat="server"><i aria-hidden="true" class="icon-file-excel"></i> <b>Export to Excel</b> </asp:LinkButton>
    </div>
    <script type="text/javascript">
        Sys.Application.add_load(BindEvents);
    </script>
</asp:Content>
