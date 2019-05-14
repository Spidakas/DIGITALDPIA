<%@ Page Title="Features" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="features.aspx.vb" Inherits="InformationSharingPortal.features" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PageContent" runat="server">
    <div class="headline-bg">
    </div><!--//headline-bg-->   
     <!-- ******Video Section****** --> 
    <section class="features-video section section-on-bg">
        <div class="container text-center">          
            <h2 class="title">Take a quick tour to see how it works</h2>
            <div class="video-container">
                <iframe width="560" height="325" src="https://www.youtube.com/embed/i34l_8-SmLc" frameborder="0" allowfullscreen></iframe>
                <%--<iframe src="//player.vimeo.com/video/90299717?title=0&amp;byline=0&amp;portrait=0&amp;color=ffffff" width="720" height="405" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>--%>
            </div><!--//video-container--> 
        </div><!--//container-->
    </section><!--//feature-video-->
   <!-- ******Why Section****** -->
        <section id="why" class="section why">
            <div class="container">   
    <asp:ObjectDataSource ID="dsBenefits" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByAdminGroupID" TypeName="InformationSharingPortal.landingdataTableAdapters.isg_pl_BenefitsTableAdapter">
                    <SelectParameters>
                        <asp:SessionParameter DefaultValue="1" Name="AdminGroupID" SessionField="plAdminGroupID" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
        <asp:Repeater ID="rptBenefits" runat="server" DataSourceID="dsBenefits">
            <ItemTemplate>
                <div class="row item">
                    <div id="Div1" runat="server" class='<%# getContentCSSOdd(Eval("ScreenImageURL"))%>'>
                        <h3 class="title">
                            <asp:Label ID="lblBenefitTitle" runat="server" Text='<%# Eval("BenefitTitle")%>'></asp:Label></h3>
                        <div class="desc">
                            <asp:Literal ID="litBenefitDesc" runat="server" Text='<%# Eval("BenefitDesc")%>'></asp:Literal>
                              </div>
                        <div class="quote">
                            <div class="quote-profile">
                                <img class="img-responsive img-circle" src='<%# Eval("QuoteImageURL")%>' alt="" />
                            </div><!--//profile-->
                            
                            <div class="quote-content">
                                <blockquote><p><asp:Label ID="Label1" runat="server" Text='<%# Eval("BenefitQuote")%>'></asp:Label></p></blockquote>
                                <p class="source">
                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("BQuoteAttributedTo")%>'></asp:Label></p>
                            </div><!--//quote-content-->                                     
                        </div><!--//quote-->                        
                    </div><!--//content-->
                     <figure id="Figure1" runat="server" visible='<%# Eval("ScreenImageURL").ToString.Length > 0%>' class="figure col-md-offset-1 col-sm-offset-0 col-xs-offset-0 col-xs-12 col-md-7">
                        <img class="img-responsive" src='<%# Eval("ScreenImageURL")%>' alt="" />
                        
                            <asp:Panel ID="pnlVidLaunch" Visible='<%# Eval("VideoLinkURL").ToString.Length > 0%>' runat="server" cssclass="control text-center">
                                <%--need some way to get this to set the url of the video:--%>
                            <button type="button" class="play-trigger" data-vidurl='<%# Eval("VideoLinkURL")%>' data-toggle="modal" data-target="#modal-video"><i class="fa fa-play"></i></button>                    
                        </asp:Panel><!--//control-->
                        <figcaption id="Figcaption1" runat="server" visible='<%# Eval("ScreenImageCaption").ToString.Length > 0%>' class="figure-caption"><%# Eval("ScreenImageCaption")%></figcaption>
                    </figure>
                </div><!--//item-->
            </ItemTemplate>
            <AlternatingItemTemplate>
                <div class="row item">
                    <div id="Div2" runat="server" class='<%# getContentCSSEven(Eval("ScreenImageURL"))%>'>
                       <h3 class="title">
                            <asp:Label ID="lblBenefitTitle" runat="server" Text='<%# Eval("BenefitTitle")%>'></asp:Label></h3>
                        <div class="desc">
                            <asp:Literal ID="litBenefitDesc" runat="server" Text='<%# Eval("BenefitDesc")%>'></asp:Literal>
                              </div>
                        <div class="quote">
                            <div class="quote-profile">
                                <img class="img-responsive img-circle" src='<%# Eval("QuoteImageURL")%>' alt="" />
                            </div><!--//profile-->
                            
                            <div class="quote-content">
                                <blockquote><p><asp:Label ID="Label1" runat="server" Text='<%# Eval("BenefitQuote")%>'></asp:Label></p></blockquote>
                                <p class="source">
                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("BQuoteAttributedTo")%>'></asp:Label></p>
                            </div><!--//quote-content-->                                     
                        </div><!--//quote-->                          
                    </div><!--//content-->
                    <figure id="Figure2" runat="server" visible='<%# Eval("ScreenImageURL").ToString.Length > 0%>' class="figure col-md-pull-4 col-sm-pull-0 col-xs-pull-0 col-xs-12 col-md-7">
                        <img class="img-responsive" src='<%# Eval("ScreenImageURL")%>' alt="" />
                        
                            <asp:Panel ID="pnlVidLaunch" Visible='<%# Eval("VideoLinkURL").ToString.Length > 0%>' runat="server" cssclass="control text-center">
                                <%--need some way to get this to set the url of the video:--%>
                            <button type="button" class="play-trigger" data-vidurl='<%# Eval("VideoLinkURL")%>' data-toggle="modal" data-target="#modal-video"><i class="fa fa-play"></i></button>                    
                        </asp:Panel><!--//control-->
                        <figcaption id="Figcaption2" runat="server" visible='<%# Eval("ScreenImageCaption").ToString.Length > 0%>' class="figure-caption"><%# Eval("ScreenImageCaption")%></figcaption>
                    </figure>
                </div><!--//item-->
            </AlternatingItemTemplate>
        </asp:Repeater>
                </div>
        </section>
</asp:Content>
