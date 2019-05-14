<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="support_help.aspx.vb" Inherits="InformationSharingPortal.support_help" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="server">
    <h1>Help</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <p>If you need support using the Data Protection Impact Assessment Tool, the following options are availble:</p>
    <ul><li>
<a href="../help/Information%20Sharing%20Gateway.html" target="_blank">Launch the help guide</a>
        </li>
        <li>
            <asp:LinkButton ID="lbtSupportFAQs" runat="server" PostBackUrl="~/application/support_faqs.aspx">Browse the Frequently Asked Questions</asp:LinkButton>
        </li>
        <li>
            <asp:LinkButton ID="lbtSupportTickets" runat="server" PostBackUrl="~/application/support_tickets.aspx">Raise a Support Ticket.</asp:LinkButton>
        </li>
    </ul>
    
    
        
</asp:Content>
