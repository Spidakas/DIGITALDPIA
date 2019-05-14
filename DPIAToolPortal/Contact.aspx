<%@ Page Title="Contact us" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.vb" Inherits="InformationSharingPortal.Contact" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="PageContent">
   
         <script src="../Scripts/bsasper.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //Lets do bootstrap form validation:
            $("input, textarea").bsasper({
                placement: "right", createContent: function (errors) {
                    return '<span class="text-danger">' + errors[0] + '</span>';
                }
            });
        });
    </script>
             
    <div class="headline-bg contact-headline-bg">
    </div><!--//headline-bg-->
    <section class="contactus-section section section-on-bg">
        <h2 class="title container text-center">How to reach us</h2>
        <div class="contactus-container container text-center">
            <div class="contactus-container-inner" >  
                <div class="row">
                    <ul class="other-info list-unstyled col-md-6 col-sm-10 col-xs-12 col-md-offset-3 col-sm-offset-1 xs-offset-0" >
                        <li><i class="fa fa-envelope-o"></i><asp:HyperLink ID="hlEmail" runat="server" NavigateUrl="mailto:isg@mbhci.nhs.uk"><asp:Label ID="lblEmail" runat="server" Text="isg@mbhci.nhs.uk"></asp:Label></asp:HyperLink></li>
                        <li><i class="fa fa-twitter"></i><a href="https://twitter.com/ISG_InfoSharing" target="_blank">@ISG_InfoSharing</a></li>
                        <li><i class="fa fa-phone"></i><asp:Label ID="lblTelephone" runat="server" Text="01524 516040"></asp:Label></li>
                        <li><i class="fa fa-map-marker"></i><asp:Literal ID="litAddress" runat="server" Text="I3 Data Protection Impact Assessment Tool Office<br />Springville House<br />Royal Lancaster Infirmary<br />Ashton Road<br />Lancaster<br />LA1 4RP"></asp:Literal></li>
                    </ul>
                </div><!--//row-->
            </div> <!--//contactus-container-inner-->  
        </div><!--//contactus-container-->          
    </section><!--//contactus-section-->

</asp:Content>