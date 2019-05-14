<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="support_faqs.aspx.vb" Inherits="InformationSharingPortal.support_faqs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="server">
     <script src="../Scripts/bsasper.js"></script>
    <script src="../Scripts/faqs.js"></script>
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
    <asp:ObjectDataSource ID="dsFAQs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetFiltered" TypeName="InformationSharingPortal.TicketsTableAdapters.FAQsTableAdapter">
        <SelectParameters>
            <asp:SessionParameter Name="AdminGroupID" SessionField="OrgAdminGroupID" Type="Int32" />
            <asp:ControlParameter ControlID="tbSearch" Name="SearchTerm" PropertyName="Text" Type="String" DefaultValue="" ConvertEmptyStringToNull="False" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <div class="form-horizontal">
        <div class="form-group">
            <div class="col-md-4 col-md-offset-8">
    <div class="input-group">
        <asp:TextBox ID="tbSearch" cssclass="form-control"  placeholder="Search for..." runat="server"></asp:TextBox>
     
      <span class="input-group-btn">
          <asp:LinkButton ID="lbtSearchGo" cssclass="btn btn-primary" runat="server">Go</asp:LinkButton>
      </span>
    </div><!-- /input-group -->
  </div><!-- /.col-lg-6 -->
        </div>
    </div>

    <div class="panel-group" id="accordion">
    <asp:Repeater ID="rptFAQs" runat="server" DataSourceID="dsFAQs">
         <ItemTemplate>
                            <div class="panel panel-info">
                                <%--<a class="" data-toggle="collapse" data-parent="#accordion" href='<%# "#faq" + DataBinder.Eval(Container.DataItem, "FAQID").ToString()%>'>--%>
                                    <div class="panel-heading faq-header" data-toggle="collapse" onclick=' <%#"javascript:viewFAQ(""" + Eval("FAQID").ToString() + """);return false;"%>' data-parent="#accordion" href='<%# "#faq" + DataBinder.Eval(Container.DataItem, "FAQID").ToString()%>'>

                                        

                                            <asp:Label ID="lblQuestionRpt" CssClass="faq-header" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "QText")%>' />

                                    </div>
                                <%--</a>--%>

                                <div id='<%# "faq" + DataBinder.Eval(Container.DataItem, "FAQID").ToString()%>' class="panel-collapse collapse">
                                    <div class="panel-body">
                                        <asp:Literal ID="Literal1" runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "AHTML")%>'></asp:Literal>
                                    </div>
                                </div>
                            </div>

                        </ItemTemplate>
    </asp:Repeater>
          </div>
    <script>
        var url = document.location.toString();
        if (url.match('#')) {
            $('#' + url.split('#')[1]).addClass('in');
        }
    </script>
</asp:Content>
