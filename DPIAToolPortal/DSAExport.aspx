<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DSAExport.aspx.vb" Inherits="InformationSharingPortal.DSAExport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Data Protection Impact Assessment Tool - Data Sharing Agreement</title>
    <link href="../Content/bootstrap.css" rel="stylesheet" />
    <style>
        .new-page
        {
            page-break-before: always;
        }

        .avoid
        {
            page-break-inside:auto;
        }

        .well-label
        {
            font-size: 12px;
            font-weight: 400;
            color: #808080;
            font-style: italic;
            letter-spacing: 1px;
        }

        body 
        {
            color: #000 !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <table>
                <tr>
                    <td style="width: 50px">
                        <img src="Images/ISG_logo_med.png" alt="" /></td>
                    <td class="col-sm-11">
                        <h3>Data Protection Impact Assessment Tool</h3>
                    </td>
                </tr>
            </table>
            <div class="" style="margin-top: 35%;">
                <h1>
                    <asp:Label ID="lblDSATitle" runat="server" Text=""></asp:Label></h1>
                <hr />
                <h2>Information Sharing Agreement</h2>
            </div>
            <div class="new-page"></div>
            <div class="panel panel-default avoid">
                <div class="panel-heading">
                    <h3>Introduction</h3>
                </div>
                <div class="panel-body">

                    <p>The Parties to this Information Sharing Agreement (ISA), except where indicated under "Parties to this Agreement", are signatories to the Data Protection Impact Assessment Tool (DPIA) Memorandum of Understanding.</p>
                    <asp:Literal ID="litMOUText" runat="server"></asp:Literal>
                 
                </div>
            </div>
            <div class="new-page"></div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3>Parties named in this Agreement</h3>
                </div>
                <div class="panel-body">
                    The Parties listed below recognise their responsibilities for ensuring this agreement complies with all legislation and other requirements relevant to the personal data being shared, including the specific governance measures set out in this ISA.
                    <div class="panel"><asp:ObjectDataSource ID="dsISAParties" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetBySP" TypeName="InformationSharingPortal.DSAExportDataTableAdapters.ISAPartiesTableAdapter">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="DFDID" QueryStringField="DFDID" Type="Int32" />
                        </SelectParameters>
                        </asp:ObjectDataSource>
                        <table class="table table-striped small">
                            <tr>
                                <th>Organisation</th>
                                <th>DPIA Status</th>
                                <th>Senior Officer/Contact</th>
                            </tr>
                            
                            <asp:Repeater ID="rptOrgsList" runat="server" DataSourceID="dsISAParties"> 
                                <ItemTemplate>
                                    <tr>
                                        <td style="width:36%">
                                            <asp:Label ID="lblOrganisationName" runat="server" Text='<%# Eval("OrganisationName")%>'></asp:Label> <asp:Label ID="lblICO" Visible='<%# Eval("ICONumber").ToString.Length > 5%>' runat="server" Text='<%# "(ICO: " + Eval("ICONumber") + ")"%>'></asp:Label>
                                            <br />
                                            <small><i><asp:Label ID="lblProviding" Visible='<%# Eval("Providing")%>' runat="server" Text="Providing">
                                                <asp:Label ID="lblAnd" runat="server" Visible='<%# Eval("Providing") And Eval("Receiving")%>' Text=" and "></asp:Label></asp:Label><asp:Label ID="lblReceiving" Visible='<%# Eval("Receiving")%>' runat="server" Text="Receiving"></asp:Label> <asp:Label ID="lblData" Visible='<%# Eval("Providing") Or Eval("Receiving")%>' runat="server" Text="Data"></asp:Label></i></small>
                                        </td>
                                        <td style="width:25%">
                                            <asp:Table ID="Table1" runat="server">
                                                <asp:TableRow Visible='<%# Eval("SignedDate", "{0:d}").ToString.Length = 0%>'>
                                                    <asp:TableCell ColumnSpan="2">
                                                        Not signed up to DPIA MOU
                                                   </asp:TableCell>
                                                </asp:TableRow>
                                                <asp:TableRow Visible='<%# Eval("SignedDate", "{0:d}").ToString.Length > 0%>'>
                                                        <asp:TableCell>
<small>MoU Signed:&nbsp;</small>
                                                        </asp:TableCell>
                                                        <asp:TableCell>
<asp:Label ID="lblSigned" runat="server" Text='<%# Eval("SignedDate", "{0:d}")%>'></asp:Label>
                                                        </asp:TableCell>
                                                    </asp:TableRow>
                                                    <asp:TableRow>
                                                        <asp:TableCell>
<small>Assurance:&nbsp;&nbsp;&nbsp;</small>&nbsp;
                                                        </asp:TableCell>
                                                        <asp:TableCell>
<asp:Label ID="lblSignificant" Width="85px" runat="server" CssClass="label label-success" Visible='<%# Eval("Assurance") = 0%>'>Significant</asp:Label>
                                                <asp:Label ID="Label3" Width="85px" runat="server" CssClass="label label-warning" Visible='<%# Eval("Assurance") = 1%>'>Limited</asp:Label>
                                                <asp:Label ID="Label4" Width="85px" runat="server" CssClass="label label-danger" Visible='<%# Eval("Assurance") > 1%>'>None</asp:Label>
                                                <asp:Label ID="Label5" Width="85px" runat="server" CssClass="label label-default" Visible='<%# Eval("Assurance") = -1%>'>Not submitted</asp:Label>
                                                <asp:Label ID="Label6" Width="85px" runat="server" CssClass="label label-default" Visible='<%# Eval("Assurance") = -10%>'>Expired</asp:Label>
                                                            <asp:Label ID="Label7" Width="85px" runat="server" CssClass="label label-default" Visible='<%# Eval("Assurance") = -11%>'>DPIA Inactive</asp:Label>
                                                        </asp:TableCell>
                                                    </asp:TableRow>
                                                </asp:Table>
                                            </td>
                                        <td style="width:39%">
                                            <small>Senior&nbsp;Officer:</small> <asp:Label ID="lblRO" runat="server" Text='<%# Eval("SignedBy")%>'></asp:Label><br />
                                            <small>Org&nbsp;Contact:</small> <asp:Label ID="lblPositionContact" runat="server" Text='<%# Eval("OrgContactEmail")%>'></asp:Label></td>
                                    </tr>
                                </ItemTemplate>
                           </asp:Repeater>
                        </table>
                    </div>
                </div>
            </div>
            <div class="panel panel-default avoid">
                <div class="panel-heading">
                    <h3>Responsible Senior Officers</h3>
                </div>
                <div class="panel-body">
                    The Responsible Senior Officers named above provide assurance that:
                    <ul>
                        <li>The details captured in this Information Sharing Agreement accurately describe the data sharing practices and the controls in place to govern them.</li>
                        <li>Their organisation and its staff will make every effort to ensure that the controls are monitored and maintained and data sharing will only happen as described herein.</li>
                        <li>Should their organisation wish to deviate from the practices and controls described here, they will review this data flow to ensure that these changes are captured.</li>
                    </ul>
                </div>
            </div>
            <div class="panel panel-default avoid">
                <div class="panel-heading">
                    <h3>Purpose and Justification for Sharing</h3>
                </div>

                <div class="panel-body">

                    <h4>Purpose</h4>



                    <p>The Parties agree to use shared information only for the specific purposes set out in this document and to support the effective administration, audit, monitoring, regulatory inspection of services and reporting requirements.</p>
                    <p>The Parties accept that shared information shall not be regarded as general intelligence for the further use by recipient organisations unless that further purpose is defined in this agreement and respective service users have been informed of this intended change of use.</p>
                    <p class="well-label">The purpose, specific to this information sharing arrangement, is identified as:</p>
                    <div class="well">
                        <asp:Label ID="lblPurposeForSharing" runat="server" Text="Label"></asp:Label>
                    </div>
                    <h4>Benefits</h4>
                    <p class="well-label">The benefits derived from this information sharing arrangement, are identified as:</p>
                    <div class="well">
                        <asp:Label ID="lblBenefits" runat="server" Text="Label"></asp:Label>
                    </div>
                    <h4>Restrictions on other use and further disclosure</h4>
                    <p>
                        It is recognised that unless the law specifically requires or permits this, shared information will not be used for different purposes or further disclosed. Even where the law permits further disclosure, in line with good practice the originating data controller will be consulted first and depending on the circumstances, it may be necessary for the data subject to be informed of the disclosure.
                    </p>
                </div>
            </div>
            <div class="panel panel-default avoid">
                <div class="panel-heading">
                    <h3>The Information Being Shared</h3>
                </div>
                <div class="panel-body">
                    <h4>Types of Information</h4>
                    <p class="well-label">The types of information, to be shared under this agreement, are identified as:</p>
                    <div class="well">
                        <asp:Label ID="lblTypesOfInformation" runat="server" Text="Label"></asp:Label>
                    </div>
                    <h4>Data Subjects</h4>
                    <p class="well-label">The data subjects, whose information is to be shared under this agreement, are identified as:</p>
                    <div class="well">
                        <asp:Label ID="lblDataSubjects" runat="server" Text="Label"></asp:Label>
                    </div>
                    <h4>Data Fields to be Shared</h4>
                     <p class="well-label">The Personal data items, to be shared under this agreement, are:</p>
                                <div class="well">

                                    <asp:Label ID="lblPersonalItems" runat="server" Text="Label"></asp:Label>
                                </div>
                    <p class="well-label">The Special Category data items, to be shared under this agreement, are:</p>
                                    <div class="well">
                                        <asp:Label ID="lblPersonalSensitiveItems" runat="server" Text="Label"></asp:Label>
                                    </div>
                    
                    <p class="well-label">The other specific data fields, to be shared under this agreement, are:</p>
                    <div class="well">
                        <asp:Label ID="lblDataFields" runat="server" Text="Label"></asp:Label>
                    </div>


                </div>
            </div>
            <div class="panel panel-default avoid">
                <div class="panel-heading">
                    <h3>Information Security & Confidentiality </h3>
                </div>
                <div class="panel-body">
                    <h4>Organisational and technical measures</h4>
                    <p>The Parties shall take appropriate technical, security and organisational measures against unauthorised or unlawful processing of the personal data and against accidental loss or destruction of, or damage to, personal data.</p>
                   
                
                    <h4>Data Transfer Modes and Controls</h4>
                
                    <div class="panel">
                        <asp:ObjectDataSource ID="dsModesControls" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DSAExportDataTableAdapters.ModesControlsTableAdapter">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="DFDID" QueryStringField="DFDID" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                        <table class="table table-striped">
                            <tr>
                                <th>Transfer Mode</th>
                                <th>Controls</th>

                            </tr>
                            <asp:Repeater ID="Repeater1" runat="server" DataSourceID="dsModesControls">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblTransferMode" runat="server" Text='<%# Eval("WhatTransferred")%>'></asp:Label></td>
                                        <td>
                                            <asp:Label ID="lblControls" runat="server" Text='<%# Eval("Controls")%>'></asp:Label></td>

                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
                    </div>
                    <asp:Panel ID="pnlPlatform" runat="server">
                    <div class="well-label">Electronic system or platform used to share data:</div>
                    <div class="well">
                        <asp:Label ID="lblSharingPlatform" runat="server" Text="Label"></asp:Label>
                    </div>
                        </asp:Panel>
                    <div class="panel avoid">
                        <table class="table table-striped">
                            <tr>
                                <th>Frequency of Exchange</th>
                                <th>Number of Records</th>

                            </tr>

                            <tr>
                                <td>
                                    <asp:Label ID="lblFrequency" runat="server" Text="Label"></asp:Label></td>
                                <td>
                                    <asp:Label ID="lblNumberOfRecords" runat="server" Text="Label"></asp:Label></td>

                            </tr>
                        </table>
                    </div>
              
                    <h4>Post Transfer Storage and Security</h4>
               
                    <div class="well-label">Physical location and method of storage:</div>
                    <div class="well">
                        <asp:Label ID="lblStorageAfterTransfer" runat="server" Text="Label"></asp:Label>
                    </div>

                    <div class="well-label">Data security after transfer:</div>
                    <div class="well">
                        <asp:Label ID="lblPostTransferSecurity" runat="server" Text="Label"></asp:Label>
                    </div>
                    <div class="well-label">Access controls after transfer:</div>
                    <div class="well">
                        <asp:Label ID="lblAccessControlsAfterTransfer" runat="server" Text="Label"></asp:Label>
                    </div>
                </div>
            </div>
            <div class="new-page"></div>

            <asp:Panel  ID="pnlPIA" runat="server">
              
                    


                    <div class="panel panel-default">
                        <div class="panel-heading"><h3>Data Protection Impact Assessment</h3><hr />
                            <h4>Lawful basis for sharing personal information </h4>
                        </div>
                        <div class="panel-body">
                            <h4>Statutory duty / power to share</h4>
                            <p class="well-label">The legislation and/or regulations providing a mandatory duty or discretionary express or implied power for each of the relevant public authority partners to this agreement to share personal data for the purposes described in this agreement, are:</p>

                            <div class="well">

                                <asp:Label ID="lblLegalBasis" runat="server" Text="Label"></asp:Label>
                            </div>
                            <h4>Sharing on the basis of informed consent</h4>
                            <p class="well-label">The consent model(s) used for this sharing arrangement is / are:</p>
                            <div class="well">
                                <asp:Label ID="lblConsentModels" runat="server" Text="Label"></asp:Label>
                            </div>

                            <asp:Panel ID="pnlLegalOuter" runat="server">
                                <h4>GDPR legitimising conditions</h4>
                               
                                <p class="well-label">The Article 6 conditions relied on for this agreement are:</p>
                                <div class="well">

                                    <asp:Label ID="lblSchedule2" runat="server" Text="Label"></asp:Label>
                                </div>
                                 
                                <asp:Panel ID="pnlLegalS3" runat="server">
                                    
                                    <p class="well-label">The Article 9 conditions relied on for this agreement are:</p>
                                    <div class="well">
                                        <asp:Label ID="lblSchedule3" runat="server" Text="Label"></asp:Label>
                                    </div>
                                </asp:Panel>
                            </asp:Panel>

                            <h4>Informing Individuals</h4>
                            <p class="well-label">The privacy notice / amendments relevant to this data sharing arrangement are:</p>
                            <div class="well">
                                <asp:Label ID="lblPrivacyNotice" runat="server" Text="Label"></asp:Label>
                            </div>
                        </div>
                    </div>

                  <div class="panel panel-default avoid">
                        <div class="panel-heading">
                            <h4>Adequacy, relevance, necessity </h4>
                        </div>
                        <div class="panel-body">
                            <p class="well-label">The following checks have been made regarding the adequacy, relevance and necessity for the collection of personal and / or sensitive data:</p>
                            <div class="well">
                                <asp:Label ID="lblAdequacy" runat="server" Text="Label"></asp:Label></div>
                            </div>
                      </div>
                 <div class="panel panel-default avoid">
                        <div class="panel-heading">
                            <h4>Provisions for the accuracy of the data</h4>
                        </div>
                        <div class="panel-body">
 <p class="well-label">The following provisions have been made to ensure information will be kept up to date and checked for accuracy and completeness by all organisations:</p>
                            <div class="well">
                                <asp:Label ID="lblAccurateComplete" runat="server" Text="Label"></asp:Label></div>
                            
                            </div>
                     </div>
                    <div class="panel panel-default avoid">
                        <div class="panel-heading">
                            <h4>Retention and disposal requirements</h4>
                        </div>
                        <div class="panel-body">
 <p class="well-label">The following arrangements have been made to manage the retention and dispoal of data by all organisations:</p>
                            <div class="well">
                                <asp:Label ID="lblRetentionDisposal" runat="server" Text="Label"></asp:Label></div>
                            
                            </div>
                     </div>
                    <div class="panel panel-default avoid">
                        <div class="panel-heading">
                            <h4>Individual rights</h4>
                        </div>
                        <div class="panel-body">
 <p class="well-label">Subject Access Requests for individual records will be dealt with as follows:</p>
                            <div class="well">
                                <asp:Label ID="lblSubjectAccessRequests" runat="server" Text="Label"></asp:Label></div>
                            
                            </div>
                     </div>
                    <div class="panel panel-default avoid">
                        <div class="panel-heading">
                            <h4>Technical and organisational measures</h4>
                        </div>
                        <div class="panel-body avoid">
 <p class="well-label">The receiving organisation's policies, processes and standard operating procedures can be described as follows:</p>
                            <div class="well">
                                <asp:Label ID="lblReceivingPoliciesSOPs" runat="server" Text="Label"></asp:Label></div>
  <p class="well-label">The receiving organisation's manage incidents according to the following:</p>
                            <div class="well">
                                <asp:Label ID="lblReceivingIncidentManagement" runat="server" Text="Label"></asp:Label></div>
                             <p class="well-label">The receiving organisation's training for both the system and data can be described as:</p>
                            <div class="well">
                                <asp:Label ID="lblReceivingTraining" runat="server" Text="Label"></asp:Label></div>
                             <p class="well-label">The receiving organisation's security control for the asset can be described as:</p>
                            <div class="well">
                                <asp:Label ID="lblReceivingSecurityControl" runat="server" Text="Label"></asp:Label></div>
                             <p class="well-label">The receiving organisation's business continuity arrangements are:</p>
                            <div class="well">
                                <asp:Label ID="lblReceivingBusinessContinuity" runat="server" Text="Label"></asp:Label></div>
                             <p class="well-label">The receiving organisation's disaster recovery arrangements are:</p>
                            <div class="well">
                                <asp:Label ID="lblReceivingDisasterRecovery" runat="server" Text="Label"></asp:Label></div>                           
                             <p class="well-label">The third party / supplier contracts contain all the necessary Information Governance clauses including information about  Data Protection (2018) and Freedom of Information (2000):</p>
                            <div class="well">
                                <asp:Label ID="lblReceivingContracts" runat="server" Text="Label"></asp:Label></div>

                        </div>
                     </div>
                
                    <asp:panel runat="server" ID="pnlOutsideEEA" class="panel panel-danger avoid">
                        <div class="panel-heading">
                            <h4>Requirements pertaining to data being transferred outside of the EEA</h4>
                        </div>
                        <div class="panel-body">
                            <p class="well-label">Exemptions (derogations) that may legitimise the transfer:</p>
                            <div class="well">
                                <asp:Label ID="lblNonEEAExemptions" runat="server" Text="Label"></asp:Label></div>
                            <p class="well-label">Country or territory of origin of the data:</p>
                            <div class="well">
                                <asp:Label ID="lblNonEEACountryOfOrigin" runat="server" Text="Label"></asp:Label></div>
                            <p class="well-label">Country or territory of final destination of the data:</p>
                            <div class="well">
                                <asp:Label ID="lblNonEEADestinationCountry" runat="server" Text="Label"></asp:Label></div>
                            <p class="well-label">Period during which the data are intended to be processed:</p>
                            <div class="well">
                                <asp:Label ID="lblNonEEAProcessingPeriod" runat="server" Text="Label"></asp:Label></div>
                            <p class="well-label">The law in force in the Non-EEA country or territory:</p>
                            <div class="well">
                                <asp:Label ID="lblNonEEALaw" runat="server" Text="Label"></asp:Label></div>
                            <p class="well-label">The international obligations of that country or territory:</p>
                            <div class="well">
                                <asp:Label ID="lblNonEEAObligations" runat="server" Text="Label"></asp:Label></div>
                            <p class="well-label">Any relevant codes of conduct or other rules which are enforceable in the country or territory:</p>
                            <div class="well">
                                <asp:Label ID="lblNonEEACoCo" runat="server" Text="Label"></asp:Label></div>
                            <p class="well-label">Any security measures taken in respect of the data in that country or territory:</p>
                            <div class="well">
                                <asp:Label ID="lblNonEEASecurity" runat="server" Text="Label"></asp:Label></div>
                        </div>
                        </asp:panel>
            </asp:Panel>
            <div class="new-page"></div>
            <asp:Panel ID="pnlRiskAssessment" runat="server">
                <div class="panel panel-default avoid">
                    <div class="panel-heading"><h3>Risk Assessment</h3></div>
                    
                    <asp:ObjectDataSource ID="dsRisks" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DSAExportDataTableAdapters.isp_RisksTableAdapter">
                                              
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="0" Name="RiskAssessmentID" Type="Int32" />
                                                </SelectParameters>
                                               
                                            </asp:ObjectDataSource>
                                           
                    <div class="table-responsive">
                                                    <asp:GridView ID="gvRisks" EmptyDataText="No risks have been added to this risk assessment." CssClass="table table-striped" HeaderStyle-CssClass="sorted-none" GridLines="None" runat="server" AutoGenerateColumns="False" DataKeyNames="RiskID" DataSourceID="dsRisks">
                                                        <Columns>
                                                            
                                                            <asp:TemplateField HeaderText="Description" ItemStyle-Width="27%" SortExpression="RiskDescription">
                                                                
                                                                <ItemTemplate>
                                                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("RiskDescription") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Controls" ItemStyle-Width="27%" SortExpression="Controls">
                                                                
                                                                <ItemTemplate>
                                                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Controls") %>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Initial Rating" ItemStyle-Width="10%" SortExpression="RiskRating">
                                                              
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblLow" runat="server" Width="90%" CssClass="label label-success ragblob" Visible='<%# Eval("RiskRating") = 1%>'>Low</asp:Label>
                                                                    <asp:Label ID="lblSignificant" Width="90%" runat="server" CssClass="label label-warning ragblob" Visible='<%# Eval("RiskRating") = 2%>'>Significant</asp:Label>
                                                                    <asp:Label ID="lblHigh" Width="90%" runat="server" CssClass="label label-danger ragblob" Visible='<%# Eval("RiskRating") = 3%>'>High</asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Actions" ItemStyle-Width="22%" SortExpression="Actions">
                                                               
                                                                <ItemTemplate>
                                                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("ActionType")%>'></asp:Label>
                                                                    <br />
                                                                    <asp:Label ID="Label4" runat="server" Text='<%# Eval("Actions")%>'></asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Final Rating" ItemStyle-Width="10%" SortExpression="FinalRiskRating">
                                                               
                                                                <ItemTemplate>
                                                                    <%--<asp:Label ID="Label6" runat="server" Width="90%" CssClass="label label-default ragblob" Visible='<%# Eval("FinalRiskRating") = 0%>'>Not set</asp:Label>--%>
                                                                    <asp:Label ID="lblLowFinal" runat="server" Width="90%" CssClass="label label-success ragblob" Visible='<%# Eval("FinalRiskRating") = 1%>'>Low</asp:Label>
                                                                    <asp:Label ID="lblSignificantFinal" Width="90%" runat="server" CssClass="label label-warning ragblob" Visible='<%# Eval("FinalRiskRating") = 2%>'>Significant</asp:Label>
                                                                    <asp:Label ID="lblHighFinal" Width="90%" runat="server" CssClass="label label-danger ragblob" Visible='<%# Eval("FinalRiskRating") = 3%>'>High</asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            
                                                        </Columns>
                                                        <HeaderStyle CssClass="sorted-none" />
                                                    </asp:GridView>
                                                </div>
                </div>
            </asp:Panel>
            <div class="panel panel-default avoid">
                <div class="panel-heading">
                    Commencement, Termination and Review
                </div>
                <div class="panel-body">
                    <p>This agreement will be reviewed every <asp:Label ID="lblReviewMonths" runat="server" Text="Label"></asp:Label> months post commencement unless an earlier review for policy or legislative reasons is necessary. </p>
                    <p>The start date for this agreement is:</p>
                    <div class="well">
                        <asp:Label ID="lblFromDate" runat="server" Text="Label"></asp:Label></div>
                    <p>The scheduled review date for this agreement is:</p>
                    <div class="well"><asp:Label ID="lblToDate" runat="server" Text="Label"></asp:Label></div>
                    This ISA shall be effective from the start date indicated above and shall continue in force until such time as the data sharing ends, this ISA is terminated by either Party, or this ISA is replaced by a new one.
                </div>
            </div>

            <div class="panel panel-info">
                <div class="panel-heading">
                    Signatories
                </div>
                 <div class="panel-body">
                  
                 <asp:ObjectDataSource ID="dsSignatures" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DSAExportDataTableAdapters.SignaturesTableAdapter">
                                    <SelectParameters>
                                        <asp:QueryStringParameter Name="DataFlowDetailID" QueryStringField="DFDID" Type="Int32" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                                    <asp:Repeater ID="rptSignatories"  runat="server" DataSourceID="dsSignatures"><ItemTemplate>
                                    <div class="panel panel-default">
                                    <table class="table table-striped avoid">
                                        <tr><th style="width:25%;">Organisation:</th><td>
                                            <asp:Label ID="lblOrgSigned" runat="server" Text='<%# Eval("OrganisationName")%>'></asp:Label></td></tr>
                                        <tr><th style="width:25%;">Signed By:</th><td>
                                            <asp:Label ID="lblSigned" runat="server" Text='<%# Eval("OrganisationUserName")%>'></asp:Label></td></tr>
                                        <tr><th style="width:25%;">Position:</th><td>
                                            <asp:Label ID="lblPosition" runat="server" Text='<%# Eval("Role")%>'></asp:Label></td></tr>
                                        <tr><th style="width:25%;">Date:</th><td>
                                            <asp:Label ID="lblDate" runat="server" Text='<%# Eval("SignedDate", "{0:d}")%>'></asp:Label></td></tr>
                                        <tr runat="server" visible='<%# Eval("OnBehalfOf").ToString.Length > 1%>'><th>On Behalf Of:</th><td>
                                            <asp:Label ID="lblBehalfOf" runat="server" Text='<%# Eval("OnBehalfOf")%>'></asp:Label></td></tr>
                                        <tr runat="server" visible='<%# Eval("OnBehalfOf").ToString.Length > 1%>'><th>On Behalf Of Role:</th><td>
                                            <asp:Label ID="lblBehalfOfRole" runat="server" Text='<%# Eval("BehalfOfRole")%>'></asp:Label></td></tr>
                                    </table></div></ItemTemplate></asp:Repeater>
                       </div>
            </div>
        </div>
    </form>
</body>
</html>
