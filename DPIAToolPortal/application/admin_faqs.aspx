<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="admin_faqs.aspx.vb" Inherits="InformationSharingPortal.admin_faqs" %>

<%@ Register Assembly="DevExpress.Web.ASPxHtmlEditor.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHtmlEditor" TagPrefix="dx" %>
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
    <h1>Frequently Asked Questions</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ObjectDataSource ID="dsFAQs" runat="server" DeleteMethod="Delete" InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByAdminGroup" TypeName="InformationSharingPortal.TicketsTableAdapters.FAQsTableAdapter" UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_FAQID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="QAnchor" Type="String" />
            <asp:Parameter Name="QText" Type="String" />
            <asp:Parameter Name="AHTML" Type="String" />
            <asp:Parameter Name="Published" Type="Boolean" />
            <asp:Parameter Name="AdminGroupID" Type="Int32" />
        </InsertParameters>
        <SelectParameters>
            <asp:SessionParameter DefaultValue="False" Name="IsCentralSA" SessionField="IsCentralSA" Type="Boolean" />
            <asp:SessionParameter DefaultValue="0" Name="SuperAdminID" SessionField="SuperAdminID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="CreatedDate" Type="DateTime" />
            <asp:Parameter Name="ViewCount" Type="Int32" />
            <asp:Parameter Name="QAnchor" Type="String" />
            <asp:Parameter Name="QText" Type="String" />
            <asp:Parameter Name="AHTML" Type="String" />
            <asp:Parameter Name="Published" Type="Boolean" />
            <asp:Parameter Name="AdminGroupID" Type="Int32" />
            <asp:Parameter Name="Original_FAQID" Type="Int32" />
        </UpdateParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsAdminGroups" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActiveLimitedByAG" TypeName="InformationSharingPortal.adminTableAdapters.isp_AdminGroupsTableAdapter">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="False" Name="IsCentralSA" SessionField="IsCentralSA" Type="Boolean" />
            <asp:SessionParameter DefaultValue="0" Name="SuperAdminID" SessionField="SuperAdminID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:MultiView ID="mvFAQs" runat="server" ActiveViewIndex="0">
        <asp:View ID="vFAQList" runat="server">
            <asp:GridView ID="gvFAQs" runat="server"  CssClass="table table-striped" EmptyDataText="No FAQs found." HeaderStyle-CssClass="sorted-none" GridLines="None" AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="FAQID" DataSourceID="dsFAQs">
                <Columns>
                    <asp:TemplateField InsertVisible="False" ShowHeader="False">
                       
                        <ItemTemplate>
                            <asp:LinkButton ID="lbtEdit" runat="server" CssClass="btn btn-default btn-sm" CausesValidation="False" CommandName="EditFAQ" CommandArgument='<%# Container.DataItemIndex %>' Text=""><i aria-hidden="true" class="icon-pencil"></i></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="CreatedDate" DataFormatString="{0:d}" HeaderText="Created" SortExpression="CreatedDate" />
                    <asp:BoundField DataField="ViewCount" HeaderText="View Count" SortExpression="ViewCount" />
                    <asp:BoundField DataField="QAnchor" HeaderText="Anchor" SortExpression="QAnchor" />
                    <asp:BoundField DataField="QText" HeaderText="Question" SortExpression="QText" />
                    <asp:BoundField DataField="AdminGroup" HeaderText="Admin Group" SortExpression="AdminGroup" />
                    <asp:CheckBoxField DataField="Published" HeaderText="Active" SortExpression="Published" />
                    <asp:TemplateField InsertVisible="False" ShowHeader="False">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbtDelete" OnClientClick="return confirm('Are you sure that you wish to remove this FAQ?');" CssClass="btn btn-danger btn-xs" runat="server" CausesValidation="False" CommandName="Delete" Text=""><i aria-hidden="true" class="icon-minus"></i></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="sorted-none" />
            </asp:GridView>
            <div class="clearfix"></div>
            <asp:LinkButton ID="lbtAddNewFAQ" CssClass="btn btn-primary pull-right" runat="server">Add FAQ</asp:LinkButton>
        </asp:View>
        <asp:View ID="vAddEditFAQ" runat="server">
            <asp:FormView ID="fvFAQs" RenderOuterTable="False" runat="server" DataKeyNames="FAQID" DataSourceID="dsFAQs">
                <EditItemTemplate>
                    <div class="panel panel-primary">
                        <div class="panel-heading"><h4>Edit FAQ</h4></div>
                        <div class="panel-body">
<div class="form-horizontal">
                    <div class="form-group">
                   <asp:Label ID="lblDomainAdd" AssociatedControlID="tbCreatedDate" CssClass="col-md-4 control-label" runat="server" Text="Created:"></asp:Label>
                     <div class="col-md-8">
                    <asp:TextBox ID="tbCreatedDate" CssClass="form-control" Enabled="false" runat="server" Text='<%# Bind("CreatedDate") %>' />
                         </div></div>
     <div class="form-group">
<asp:Label ID="Label1" AssociatedControlID="tbViewCount" CssClass="col-md-4 control-label" runat="server" Text="View Count:"></asp:Label>
                   <div class="col-md-8">
                    <asp:TextBox ID="tbViewCount" Enabled="false" CssClass="form-control" runat="server" Text='<%# Bind("ViewCount") %>' TextMode="Number" />
                    </div></div>
    <div class="form-group">
<asp:Label ID="Label2" AssociatedControlID="tbQAnchor" CssClass="col-md-4 control-label" runat="server" Text="Anchor Text:"></asp:Label>
<div class="col-md-8">
                    <asp:TextBox ID="tbQAnchor" CssClass="form-control" runat="server" Text='<%# Bind("QAnchor") %>' />
</div></div>
    <div class="form-group">
<asp:Label ID="lblQText" AssociatedControlID="tbQText" CssClass="col-md-4 control-label" runat="server" Text="Question:"></asp:Label>
<div class="col-md-8">
                    <asp:TextBox ID="tbQText" CssClass="form-control" runat="server" Text='<%# Bind("QText") %>' />
    </div></div>
    <div class="form-group">
                    <asp:Label ID="lblAHTML" AssociatedControlID="tbQText" CssClass="col-md-4 control-label" runat="server" Text="Answer:"></asp:Label>
                    <div class="col-md-8">
                        <dx:ASPxHtmlEditor ID="htmlAnswerEdit" OnHtmlCorrecting="htmlFAQCorrecting" Html='<%# Bind("AHTML") %>' runat="server" Height="300px" Width="100%"></dx:ASPxHtmlEditor>
                    
                        </div></div>
    <div class="form-group">
                   <asp:Label ID="lblPublished" AssociatedControlID="cbPublished" CssClass="col-md-4 control-label" runat="server" Text="Active:"></asp:Label>
                  <div class="col-xs-8">
                    <asp:CheckBox ID="cbPublished" runat="server" Checked='<%# Bind("Published") %>' />
                    </div></div>
    <div class="form-group">
                    <asp:Label ID="Label9" AssociatedControlID="ddAdminGroupEdit" CssClass="col-md-4 control-label" runat="server" Text="Admin group:"></asp:Label>
                    <div class="col-xs-8">
                        <asp:DropDownList ID="ddAdminGroupEdit" SelectedValue='<%# Bind("AdminGroupID") %>' OnDataBound="ddAdminGroup_DataBound" AppendDataBoundItems="true" CssClass="form-control input-sm" runat="server" DataSourceID="dsAdminGroups" DataTextField="GroupName" DataValueField="AdminGroupID">      
                            <asp:ListItem Text="All" Value="0"></asp:ListItem>        
               </asp:DropDownList>
                        </div></div>
                        
                        
                    </div>
                            </div>
                        <div class="panel-footer clearfix">
 <asp:LinkButton ID="UpdateButton" runat="server" CssClass="btn btn-primary pull-right" CausesValidation="True" CommandName="Update" Text="Update" />
                    &nbsp;<asp:LinkButton ID="UpdateCancelButton" CssClass="btn btn-primary pull-left" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                        </div>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <div class="panel panel-primary">
                        <div class="panel-heading"><h4>Add FAQ</h4></div>
                        <div class="panel-body">
<div class="form-horizontal">
                    <div class="form-group">
                   

<asp:Label ID="Label2" AssociatedControlID="tbQAnchor" CssClass="col-md-4 control-label" runat="server" Text="Anchor Text:"></asp:Label>
<div class="col-xs-8">
                    <asp:TextBox ID="tbQAnchor" CssClass="form-control" runat="server" Text='<%# Bind("QAnchor") %>' />
</div></div><div class="form-group">
<asp:Label ID="lblQText" AssociatedControlID="tbQText" CssClass="col-md-4 control-label" runat="server" Text="Question:"></asp:Label>
<div class="col-xs-8">
                    <asp:TextBox ID="tbQText" CssClass="form-control" runat="server" Text='<%# Bind("QText") %>' />
    </div></div><div class="form-group">
                    <asp:Label ID="lblAHTML"  OnHtmlCorrecting="htmlFAQCorrecting" AssociatedControlID="tbQText" CssClass="col-md-4 control-label" runat="server" Text="Answer:"></asp:Label>
                    <div class="col-xs-8">
                    <dx:ASPxHtmlEditor ID="htmlAnswerAdd" Html='<%# Bind("AHTML") %>' runat="server" Height="300px" Width="100%"></dx:ASPxHtmlEditor>
                        </div></div>
    <div class="form-group">
                    <asp:Label ID="Label9" AssociatedControlID="ddAdminGroup" CssClass="col-md-4 control-label" runat="server" Text="Admin group:"></asp:Label>
                    <div class="col-xs-8">
                        <asp:DropDownList ID="ddAdminGroup" OnDataBound="ddAdminGroup_DataBound" SelectedValue='<%# Bind("AdminGroupID") %>' AppendDataBoundItems="true" CssClass="form-control input-sm" runat="server" DataSourceID="dsAdminGroups" DataTextField="GroupName" DataValueField="AdminGroupID">      
                            <asp:ListItem Text="All" Value="0"></asp:ListItem>        
               </asp:DropDownList>
                        </div></div>
    <div class="form-group">
                   <asp:Label ID="lblPublished" AssociatedControlID="cbPublished" CssClass="col-md-4 control-label" runat="server" Text="Active:"></asp:Label>
                  <div class="col-xs-8">
                    <asp:CheckBox ID="cbPublished" runat="server" Checked='<%# Bind("Published") %>' />
                    </div>

                        </div>
                    </div>
                            </div>
                        <div class="panel-footer clearfix">
 <asp:LinkButton ID="InsertButton" runat="server" CssClass="btn btn-primary pull-right" CausesValidation="True" CommandName="Insert" Text="Add" />
                    &nbsp;<asp:LinkButton ID="InsertCancelButton" CssClass="btn btn-primary pull-left" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                        </div>
                </InsertItemTemplate>
              
            </asp:FormView>
        </asp:View>
        <%--<asp:View ID="vAddFAQ" runat="server">

        </asp:View>--%>
    </asp:MultiView>
</asp:Content>
