<%@ Page Title="About" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.vb" Inherits="InformationSharingPortal.About" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="PageContent">
    <div class="headline-bg about-headline-bg">
    </div><!--//headline-bg-->         
    
    <!-- ******Video Section****** --> 
    <section class="story-section section section-on-bg">
        <h2 class="title container text-center">The Data Protection Impact Assessment Tool</h2>
        <div class="story-container container text-center"> 
            <div class="story-container-inner" >                    
                <div class="about">
                    <h3>About</h3>
                    <p>The Data Protection Impact Assessment Tool (DPIA) has been developed by a .... in order to improve and modernise the administration and risk assessment of information sharing. It has been designed by IG specialists, to support their IG reporting on data protection impact assessments.</p>
        <p>The development was initially funded by the GMCA.  It is a generic tool and is not ‘tied’ to use with GMCA. It centralises and shares key resources in a way that is accessible and transparent.</p>
               
               
        <h3>Acknowledgements</h3>
        <p>The following organisations helped develop the Data Protection Impact Assessment Tool:</p>
        <ul>
            <li>Greater Manchester Combined Authority</li>
            <li>University Hospitals of Morecambe Bay NHS Foundation Trust</li>
        </ul>
    
                 <%--<div class="row">
                     <br />
       <div class="col-sm-6"><a href="http://www.northwestsis.nhs.uk/" target="_blank"><img src="Images/logo_nwiss.png" alt="North West Shared Infrastructure Service Logo" /></a></div>
<div class="col-sm-6"><a href="http://www.northwestsis.nhs.uk/information-governance" target="_blank"><img src="Images/logo_ig_lg.png" alt="NWSIS Information Governance Logo" /></a></div>
        </div> --%></div>
    
        <asp:ObjectDataSource ID="dsTeamMembers" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActiveByAdminGroupID" TypeName="InformationSharingPortal.landingdataTableAdapters.isg_pl_TeamMembersTableAdapter">
            <SelectParameters>
                <asp:SessionParameter DefaultValue="0" Name="AdminGroupID" SessionField="plAdminGroupID" Type="Int32" />
            </SelectParameters>
                </asp:ObjectDataSource>

                <div class="team row">
                    <h3 class="title">Meet the team</h3>
<asp:Repeater ID="rptTeamMembers" runat="server" DataSourceID="dsTeamMembers">
    <ItemTemplate>
<div class="member col-md-4 col-sm-6 col-xs-12">
                        <div class="member-inner">
                            <figure class="profile">
                                <img class="img-responsive" src='<%# Eval("PortraitURL")%>' alt=""/>
                                <figcaption class="info">
                                    <span class="name">
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("TMName")%>'></asp:Label>
                                        </span>
                                    <br />
                                    <span class="job-title">
                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("JobTitle")%>'></asp:Label></span>
                                    
                                </figcaption>
                            </figure><!--//profile-->
                            <div class="social">
                                <ul class="social-list list-inline">
                                    <li>
                                        <asp:HyperLink ID="HyperLink1" visible='<%# Eval("LinkedInURL").ToString.Length > 1%>' Target="_blank" NavigateUrl='<%# Eval("LinkedInURL")%>' runat="server"><i class="fa fa-linkedin"></i></asp:HyperLink>
                                        </li>
                                    <li>
                                        <asp:HyperLink visible='<%# Eval("TwitterURL").ToString.Length > 1%>' ID="HyperLink2" Target="_blank" NavigateUrl='<%# Eval("TwitterURL")%>' runat="server"><i class="fa fa-twitter"></i></asp:HyperLink>
                                       </li>
                                </ul><!--//social-list-->
                            </div><!--//social-->
                        </div><!--//member-inner-->
                    </div><!--//member-->
    </ItemTemplate>
</asp:Repeater>
                </div><!--//team-->
                <div class="row">
                     <br />
       <div class="col-sm-6"><a href="http://www.northwestsis.nhs.uk/" target="_blank"><img src="Images/logo_nwiss.png" alt="North West Shared Infrastructure Service Logo" /></a></div>
<div class="col-sm-6"><a href="http://www.northwestsis.nhs.uk/information-governance" target="_blank"><img src="Images/logo_ig_lg.png" alt="NWSIS Information Governance Logo" /></a></div>
        </div>
            </div><!--//story-container--> 
        </div><!--//container-->
    </section><!--//story-video-->
  
</asp:Content>
