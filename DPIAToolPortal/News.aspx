<%@ Page Title="News" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="News.aspx.vb" Inherits="InformationSharingPortal.News" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PageContent" runat="server">
    <asp:MultiView ID="mvNews" ActiveViewIndex="0" runat="server">
        <asp:View ID="vNewsList" runat="server">
            
             <asp:ObjectDataSource ID="dsNewsItems" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActiveForAdminGroup" TypeName="InformationSharingPortal.landingdataTableAdapters.isg_pl_NewsItemsTableAdapter">
                    <SelectParameters>
                        <asp:SessionParameter DefaultValue="0" Name="AdminGroupID" SessionField="plAdminGroupID" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            <!-- ******BLOG LIST****** --> 
                  <div class="headline-bg blog-headline-bg">
        </div><!--//headline-bg-->
            <section class="blog-section section section-on-bg">
    
         <div class="blog blog-category container">
            <h2 class="page-title text-center"><i class="fa fa-newspaper-o"></i> News</h2>
            <div class="row">
                <div class="col-sm-8">
                <div class="blog-list blog-category-list">
                <asp:Repeater ID="rptNews" runat="server" DataSourceID="dsNewsItems">
                    <ItemTemplate>
 <article class="post col-md-offset-1 col-sm-offset-0 col-xs-offset-0 col-xs-12 col-md-10">
      <div class="post-inner">
          <div class="content">
           <div class="post-preview">
                    <a id="A1" runat="server" href='<%# "News?ItemID=" & Eval("NewsItemID").ToString() %>' >
                        <h3 class="post-title">
                            <asp:Label ID="lblNewsTitle" runat="server" Text='<%# Eval("NewsTitle")%>'></asp:Label>
                        </h3>
                        <h4 id="H1" runat="server"  class="post-subtitle">
                            <asp:Label ID="lblNewsSubtitle" runat="server" Text='<%# Eval("NewsSubtitle")%>'></asp:Label>
                        </h4>
                    </a>
                    <p class="post-meta">Posted by <asp:Label ID="lblPostedBy" runat="server" Text='<%# Eval("PostedByUsername")%>'></asp:Label> on <asp:Label ID="lblPostedDate" runat="server" Text='<%# Eval("PostedDate", "{0:d}")%>'></asp:Label></p>
               </div></div>
          </div>
                </article>
                    </ItemTemplate>
                </asp:Repeater>
                    </div>
                </div>
                 <div class="col-sm-4">
                    <a class="twitter-timeline" data-height="800" href="https://twitter.com/DPIA_DataPrivacyImpactAssessments">Tweets by the DPIA</a> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
                </div>
                </div>
             </div></section>
        </asp:View>
        <asp:View ID="vNewsDetail" runat="server">
            <asp:ObjectDataSource ID="dsNewsItem" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByNewsItemID" TypeName="InformationSharingPortal.landingdataTableAdapters.isg_pl_NewsItemsTableAdapter">

                <SelectParameters>
                    <asp:QueryStringParameter DefaultValue="0" Name="NewsItemID" QueryStringField="ItemID" Type="Int32" />
                    <asp:SessionParameter Name="AdminGroupID" SessionField="lpAdminGroupID" Type="Int32" />
                </SelectParameters>

            </asp:ObjectDataSource>
            <asp:FormView ID="fvNewsItem" RenderOuterTable="false" runat="server" DataSourceID="dsNewsItem">
                <ItemTemplate>
<header class="intro-header" style="background-image: url('Images/landing/ag0/backgrounds/bg-footer-1.jpg')">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 col-lg-offset-2 col-md-10 col-md-offset-1">
                    <div class="post-heading">
                        <h1><asp:Label ID="lblNewsTitle" runat="server" Text='<%# Eval("NewsTitle")%>'></asp:Label></h1>
                        <h2 class="subheading"> <asp:Label ID="lblNewsSubtitle" runat="server" Text='<%# Eval("NewsSubtitle")%>'></asp:Label></h2>
                        <span class="meta">Posted by <asp:Label ID="lblPostedBy" runat="server" Text='<%# Eval("PostedByUsername")%>'></asp:Label> on <asp:Label ID="lblPostedDate" runat="server" Text='<%# Eval("PostedDate", "{0:d}")%>'></asp:Label></span>
                    </div>
                </div>
            </div>
        </div>
    </header>
            <article>
        <div class="container">
            <div class="row">
                <div class="col-lg-8 col-lg-offset-2 col-md-10 col-md-offset-1">
                    <asp:Literal ID="liContent" runat="server" Text='<%# Eval("NewsContent")%>'></asp:Literal>
 <ul class="pager">
                    <li class="next">
                        <a href="News">&larr; Back</a>
                    </li>
                </ul>
                     </div>
            </div>
        </div>
    </article>
                    
                </ItemTemplate>
            </asp:FormView>
             
        </asp:View>
    </asp:MultiView>
   
</asp:Content>
