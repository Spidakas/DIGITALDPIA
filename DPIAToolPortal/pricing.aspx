<%@ Page Title="Pricing" Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="pricing.aspx.vb" Inherits="InformationSharingPortal.pricing" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PageContent" runat="server">
  <%--  <style>
         table.plan td{ 
  text-align: left;
}

table.plan tr:first-child { 
  text-align: left;
 }
    </style>--%>
    <div class="headline-bg pricing-headline-bg">
    </div><!--//headline-bg-->
    
    <!-- ******Pricing Section****** -->
    <section class="pricing section section-on-bg">
        <div class="container">
            <h2 class="title text-center">Prices from FREE</h2>
            <p class="intro text-center">Our pricing options are kept deliberately simple. If you can't see a plan you like, contact us to discuss.</p>
             <div class="price-cols row">
                <div class="items-wrapper col-md-10 col-sm-12 col-xs-12 col-md-offset-1 col-sm-offset-0 col-xs-offset-0">
                    <div class="item price-1 col-md-4 col-sm-4 col-xs-12 text-center">
                        <div class="item-inner">
                            <div class="heading">
                            <h3 class="title">Free</h3>
                                <p class="price-figure"><span class="price-figure-inner"><span class="currency">£</span><span class="number">FREE</span><br /><br /></span></p>
                            </div>
                            <div class="content">
                                <ul class="list-unstyled feature-list">
                                    <li><i class="fa fa-check"></i>Ideal for ISA signatory orgs</li>
                                    <li><i class="fa fa-check"></i>1 organisation</li>
                                    
                                    <li><i class="fa fa-check"></i>3 users</li>
                                    <li class="disabled"><i class="fa fa-times"></i>Super administrators</li>
                                    <li class="disabled"><i class="fa fa-times"></i>Technical support</li>
                                    <li class="disabled"><i class="fa fa-times"></i>User support</li>
                                    <li class="disabled"><i class="fa fa-times"></i>File upload / download</li>
                                    <li class="disabled"><i class="fa fa-times"></i>Guaranteed return of data</li>
                                </ul>
                                <a class="btn btn-cta btn-cta-primary" href="Account/Register">Register</a>
   
                            </div><!--//content-->
                        </div><!--//item-inner-->
                    </div><!--//item--> 
                    
                    <div class="item price-2 col-md-4 col-sm-4 col-xs-12 text-center best-buy">
                        <div class="item-inner">
                            <div class="heading">
                            <h3 class="title">Single Organisation</h3>
                                <p class="price-figure"><span class="price-figure-inner"><span class="currency">£</span><span class="number">1,000</span><br /><span class="unit">per year <small>(+ £500 setup)</small></span></span></p>
                            </div>
                            <div class="content">
                                <ul class="list-unstyled feature-list">
                                    <li><i class="fa fa-check"></i>Best for sharing organisations</li>
                                    <li><i class="fa fa-check"></i>1 organisation</li>
                                    
<li><i class="fa fa-check"></i>Unlimited users</li>
                                    <li class="disabled"><i class="fa fa-times"></i>Super administrators</li>
                                    <li><i class="fa fa-check"></i>Technical support</li>
                                    <li><i class="fa fa-check"></i>User support</li>
                                    <li><i class="fa fa-check"></i>File upload / download</li>
                                    <li><i class="fa fa-check"></i>Guaranteed return of data</li>
                                </ul>
                                <a class="btn btn-cta btn-cta-primary" href="contact">Enquire</a>
                            </div><!--//content-->
                           <%-- <div class="ribbon">
                                <div class="text">New</div>
                            </div><!--//ribbon-->--%>
                        </div><!--//item-inner-->
                    </div><!--//item-->  
                    
                    <div class="item price-3 col-md-4 col-sm-4 col-xs-12 text-center">
                        <div class="item-inner">
                            <div class="heading">
                                <h3 class="title">Group Licence</h3>
                                <p class="price-figure"><span class="price-figure-inner"><span class="currency">£</span><span class="number">3,500</span><br /><span class="unit">per year <small>(+£2,500 setup)</small></span></span></p>
                            </div>
                            <div class="content">
                                <ul class="list-unstyled feature-list">
                                    <li><i class="fa fa-check"></i>Best for sharing communities</li>
                                    <li><i class="fa fa-check"></i>100 organisations</li>
                                    
                                    <li title=""><i class="fa fa-check"></i>Unlimited users</li>
                                    <li title=""><i class="fa fa-check"></i>Up to 3 super administrators</li>
                                    <li><i class="fa fa-check"></i>Technical support</li>
                                    <li class="disabled"><i class="fa fa-times"></i>User support</li>
                                    
                                    <li><i class="fa fa-check"></i>File upload / download</li>
                                    <li><i class="fa fa-check"></i>Guaranteed return of data</li>                            
                                </ul>
                                <a class="btn btn-cta btn-cta-primary" href="contact">Enquire</a>
                                
                            </div><!--//content-->
                        </div><!--//item-inner-->
                    </div><!--//item-->  
                    
                </div><!--//items-wrapper-->                 
            </div><!--//row-->
            <div class="row">
                <div class="col-md-10 col-sm-12 col-xs-12 col-md-offset-1 col-sm-offset-0 col-xs-offset-0">
                     <div class="small text-center"><strong>Note:</strong> Prices are reviewed annually. The prices above are valid for public and voluntary sector organisations for FY 2018-19.</div> 
                    </div>
                </div>
        </div><!--//container-->
    </section><!--//pricing-->
    
    <!-- ******FAQ Section****** --> 
    <section class="faq section has-bg-color">
        <div class="container">
            <h2 class="title text-center">Frequently Asked Questions</h2>
            <div class="row">
                <div class="col-md-8 col-sm-10 col-xs-12 col-md-offset-2 col-sm-offset-1 col-xs-offset-0">
                    <div class="panel">
                        <div class="panel-heading">
                            <h4 class="panel-title"><a data-parent="#accordion"
                            data-toggle="collapse" class="panel-toggle" href="#faq0"><i class="fa fa-plus-square"></i>Once we have a contract in place, will the price go up?</a></h4>
                        </div>
            
                        <div class="panel-collapse collapse" id="faq0">
                            <div class="panel-body">
                               The yearly subscription charge can only increase by a maximum of 5% per year for subscription renewals.
                            </div>
                        </div>
                    </div><!--//panel-->
                    <div class="panel">
                        <div class="panel-heading">
                            <h4 class="panel-title"><a data-parent="#accordion"
                            data-toggle="collapse" class="panel-toggle" href="#faq1"><i class="fa fa-plus-square"></i>If I am covered by a group franchise, can I purchase user support separately?</a></h4>
                        </div>
            
                        <div class="panel-collapse collapse" id="faq1">
                            <div class="panel-body">
                                Yes. If your organisation is licenced to use the DPIA but you would prefer to receive direct user support from the central DPIA team, this can be arranged on request. The cost per year for this service is £xxx.
                            </div>
                        </div>
                    </div><!--//panel-->
           
                    <div class="panel">
                        <div class="panel-heading">
                            <h4 class="panel-title"><a data-parent="#accordion"
                            data-toggle="collapse" class="panel-toggle" href="#faq2"><i class="fa fa-plus-square"></i>Why doesn't the group franchise include user support?</a></h4>
                        </div>
            
                        <div class="panel-collapse collapse" id="faq2">
                            <div class="panel-body">
                                In many cases, group franchises prefer to make local arrangements for user support and the DPIA help system allows locally identified super administrators to deliver this support. If you would are interested in purchasing a group franchise, but would prefer the central DPIA team to support your users, please contact us to discuss your requirements and we will provide you with a quote.
                            </div>
                        </div>
                    </div><!--//panel-->
            
                    <div class="panel">
                        <div class="panel-heading">
                            <h4 class="panel-title"><a data-parent="#accordion"
                            data-toggle="collapse" class="panel-toggle" href="#faq3"><i class="fa fa-plus-square"></i>Who will the contract be with if we purchase access to the system?</a></h4>
                        </div>
            
                        <div class="panel-collapse collapse" id="faq3">
                            <div class="panel-body">
                                Your contract for access to the system will be with the organisation chosen by the DPIA Governance Group to host the DPIA project team. This is currently University Hospitals of Morecambe Bay NHS Foundation Trust.
                            </div>
                        </div>
                    </div><!--//panel-->
                    
                    <div class="panel">
                        <div class="panel-heading">
                            <h4 class="panel-title"><a data-parent="#accordion"
                            data-toggle="collapse" class="panel-toggle" href="#faq4"><i class="fa fa-plus-square"></i>None of the above licence models suit my needs. Can a bespoke contract be arranged?</a></h4>
                        </div>
            
                        <div class="panel-collapse collapse" id="faq4">
                            <div class="panel-body">
                               Yes. These pricing models are kept deliberately simple and represent the most common usage models. If you have different requirements, please contact us to discuss.
                            </div>
                        </div>
                    </div><!--//panel--> 
                    
                    <div class="panel">
                        <div class="panel-heading">
                            <h4 class="panel-title"><a data-parent="#accordion"
                            data-toggle="collapse" class="panel-toggle" href="#faq5"><i class="fa fa-plus-square"></i>What happens to my data if my organisation wishes to leave the DPIA in the future?</a></h4>
                        </div>
            
                        <div class="panel-collapse collapse" id="faq5">
                            <div class="panel-body">
                                You will be given a grace period of three months at the end of any contract to retrieve your data from the system. After this period you will be able to request specific data from the system for a period of 12 months.
                            </div>
                        </div>
                    </div><!--//panel-->
                    
                    <div class="panel">
                        <div class="panel-heading">
                            <h4 class="panel-title"><a data-parent="#accordion"
                            data-toggle="collapse" class="panel-toggle" href="#faq6"><i class="fa fa-plus-square"></i>Why shouldn't I just use the DPIA for free?</a></h4>
                        </div>
            
                        <div class="panel-collapse collapse" id="faq6">
                            <div class="panel-body">
                                In some cases, you should. If your organisation is not going to be involved in setting up sharing agreements but only in signing them off, the free model is probably the best for you. It will mean that you don't have access to support, uploads to or downloads from the system, though. If any of these are important to you, you should consider another pricing model.
                            </div>
                        </div>
                    </div><!--//panel-->
                    
                    <div class="panel">
                        <div class="panel-heading">
                            <h4 class="panel-title"><a data-parent="#accordion"
                            data-toggle="collapse" class="panel-toggle" href="#faq7"><i class="fa fa-plus-square"></i>Where does the money go? Who profits from the system?</a></h4>
                        </div>
            
                        <div class="panel-collapse collapse" id="faq7">
                            <div class="panel-body">
                                The Data Protection Impact Assessment Tool was developed and is supported by a project team in the public sector. The DPIA Governance Group has an explicitly stated intention to reinvest income acquired from sales of the system into the continued development and maintenance of the system. The development roadmap for the DPIA is very ambitious and all users should benefit from the continued development of the system.
                            </div>
                        </div>
                    </div><!--//panel-->
                     <div class="panel">
                        <div class="panel-heading">
                            <h4 class="panel-title"><a data-parent="#accordion"
                            data-toggle="collapse" class="panel-toggle" href="#faq8"><i class="fa fa-plus-square"></i>I work for a private company, can we use the system?</a></h4>
                        </div>
            
                        <div class="panel-collapse collapse" id="faq8">
                            <div class="panel-body">
                               Yes. Please contact us using the Contact tab above to discuss requirements and pricing.
                            </div>
                        </div>
                    </div><!--//panel-->
                                  
                </div>
            </div><!--//row-->
            <div class="contact-lead text-center">
                <h4 class="title">Have more questions?</h4>
                <a class="btn btn-cta btn-cta-secondary" href="contact">Get in touch</a>
            </div>
        </div><!--//container-->        
    </section><!--//faq-->
<%--    <section class="pricing section">
        <div class="container">
            <h2 class="text-center">Building the Business Case</h2>
            <br />
            <br />
             <h3>Efficiency Savings</h3>
            <div class="row">
                <table class=
    "plan table table-hover table-bordered table-striped text-center">
        <thead>
            <tr>
                <th>
                    <h3>ISA Related Tasks</h3>
                </th>
                <td>
                    <h4>Without DPIA</h4>
                    <p class="text-muted">Using paper, spreadsheets etc</p>
                </td>
                <td>
                    <h4>With DPIA</h4>
                    <p class="text-muted">Web based ISA management</p>
                </td>
                <td>
                    <h4>Efficiency Saving</h4>
                </td>
            </tr>
        </thead>

        <tbody>
            <tr>
                <th>Draw up a DSA 
</th>

                <td>2 days – 1 week</td>

                <td>1hr - 0.5 day</td>

                <td><span class="fa-2x text-success">500%</span></td>
            </tr>

            <tr>
                <th>List all sharing agreements</th>

                <td>100 hours</td>

                <td>2-3 mins</td>

                <td></td>
            </tr>

            <tr>
                <th>Retrieve a specific data sharing agreement (DSA)</th>

                <td>15 mins to > 1 days</td>

                <td>1 min</td>

                <td></td>
            </tr>

            <tr>
                <th>Provide a geographic breakdown of DSAs</th>

                <td>100 days</td>

                <td>1 min</td>

                <td></td>
            </tr>

            <tr>
                <th>Sign off an agreement</th>

                <td>100 hours</td>

                <td>1 day</td>

                <td><span class="fa-2x text-success">1,667%</span></td>
            </tr>

            <tr>
                <th>Find out if a DSA has expired</th>

                <td>10 mins to 1 day</td>

                <td>1 min</td>

                <td></td>
            </tr>

            <tr>
                <td colspan="6">AUTOMATED EMAIL DISTRIBUTION OF MEETING
                ASSIGNMENTS</td>

                <td colspan="2">✗</td>

                <td colspan="2">✔</td>

                <td colspan="2">✔</td>
            </tr>
        </tbody>
    </table>
             </div>
        </div>
        </section>--%>
</asp:Content>
