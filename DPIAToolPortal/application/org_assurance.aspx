<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="org_assurance.aspx.vb" Inherits="InformationSharingPortal.org_assurance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="server">
    <script src="../Scripts/bsasper.js"></script>
    <link href="https://gitcdn.github.io/bootstrap-toggle/2.2.0/css/bootstrap-toggle.min.css" rel="stylesheet">
    <script src="https://gitcdn.github.io/bootstrap-toggle/2.2.0/js/bootstrap-toggle.min.js"></script>
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
    <h1>Organisation Assurance</h1>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ObjectDataSource ID="dsCyberEssentials" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActive" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_Assurance_CyberEssentialsTableAdapter"></asp:ObjectDataSource>
    <div class="project-content-body">

        <asp:MultiView ID="mvAssurance" runat="server" ActiveViewIndex="0">
            <asp:View ID="vCurrentAssurance" runat="server">
                <asp:ObjectDataSource ID="dsCurrentAssurance" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActiveForOrganisation" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_AssuranceSubmissionsTableAdapter">
                    <SelectParameters>
                        <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-6">
                            <ul class="list-group">
                                <asp:FormView ID="fvCurrentAssurance" runat="server" DataKeyNames="AssuranceSubmissionID" DataSourceID="dsCurrentAssurance" RenderOuterTable="False">
                                    <ItemTemplate>
                                        <li class="list-group-item list-group-item-success" runat="server" visible='<%# Eval("Score") = 0%>'>
                                            <h3>Assurance Level: Significant Assurance</h3>
                                        </li>
                                        <li class="list-group-item list-group-item-warning" runat="server" visible='<%# Eval("Score") = 1%>'>
                                            <h3>Assurance Level: Limited Assurance</h3>
                                        </li>
                                        <li class="list-group-item list-group-item-danger" runat="server" visible='<%# Eval("Score") > 1%>'>
                                            <h3>Assurance Level: No Assurance</h3>
                                        </li>
                                        <li id="Li3" class="list-group-item list-group-item-danger" runat="server" visible='<%# Eval("Score") = -10%>'>
                                            <h3>Assurance Expired</h3>
                                        </li>

                                        <li class='<%# "list-group-item " + DoWarning(Eval("ICORegistered"))%>'>ICO Registered:
                        <asp:CheckBox ID="ICORegisteredCheckBox" runat="server" Checked='<%# Eval("ICORegistered")%>' Enabled="false" /></li>
                                        <li runat="server" visible='<%# Eval("ICORegistered") = "True" %>' class="list-group-item">ICO Registration Number:
                        <asp:Label ID="ICORegNumberLabel" runat="server" Text='<%# Eval("ICORegNumber")%>' Font-Bold="True" /></li>
                                        <li runat="server" class="list-group-item" visible='<%# Eval("ICORegistered") = "True" %>'>ICO Registration Expires:
                        <asp:Label ID="ICORegReviewDateLabel" runat="server" Text='<%# Eval("ICORegReviewDate", "{0:d}")%>' Font-Bold="True" />
                                        </li>
                                        <li runat="server" visible='<%# Eval("ICORegistered") = "False"%>' class="list-group-item">ICO Not Registered Reason:
                        <asp:Label ID="ICONotRegisteredReasonLabel" runat="server" Text='<%# Eval("ICONotRegisteredReason")%>' Font-Bold="True" /></li>

                                        <li class='<%# "list-group-item " + DoWarning(Eval("IGComplianceType") <> "None")%>'>IG Compliance Framework:
                        <asp:Label ID="IGComplianceTypeIDLabel" runat="server" Text='<%# Eval("IGComplianceType")%>' Font-Bold="True" /></li>
                                        <li runat="server" visible='<%# Eval("IGComplianceType") <> "None"%>' class="list-group-item">Framework Version:
                        <asp:Label ID="IGComplianceVersionLabel" runat="server" Text='<%# Eval("IGComplianceVersion")%>' Font-Bold="True" /></li>
                                        <li runat="server" visible='<%# Eval("IGComplianceType") <> "None"%>' class="list-group-item">Compliance Score:
                        <asp:Label ID="IGComplianceScoreLabel" runat="server" Text='<%# Eval("IGComplianceScore")%>' Font-Bold="True" /></li>
                                        <li runat="server" visible='<%# Eval("IGComplianceType") = "None"%>' class="list-group-item">IG Non-compliance Reason:
                        <asp:Label ID="IGNonComplianceReasonLabel" runat="server" Text='<%# Eval("IGNonComplianceReason")%>' Font-Bold="True" /></li>
                                        <li class='<%# "list-group-item " + DoWarning(Eval("StaffScreened"))%>'>Staff Screened:
                        <asp:CheckBox ID="StaffScreenedCheckBox" runat="server" Checked='<%# Eval("StaffScreened")%>' Enabled="false" /></li>
                                        <li runat="server" visible='<%# Eval("StaffScreened") = "True"%>' class="list-group-item">Screening Type:
                        <asp:Label ID="StaffScreeningDetailsLabel" runat="server" Text='<%# Eval("StaffScreeningDetails")%>' Font-Bold="True" /></li>
                                        <li runat="server" visible='<%# Eval("StaffScreened") = "False"%>' class="list-group-item">No Screening Reason:
                        <asp:Label ID="NoScreeningReasonLabel" runat="server" Text='<%# Eval("NoScreeningReason")%>' /></li>
                                        <li class='<%# "list-group-item " + DoWarning(Eval("IGTraining"))%>'>Staff IG Trained:
                        <asp:CheckBox ID="IGTrainingCheckBox" runat="server" Checked='<%# Eval("IGTraining")%>' Enabled="false" /></li>
                                        <li runat="server" visible='<%# Eval("IGTraining") = "True"%>' class="list-group-item">IG Training Type:
                        <asp:Label ID="IGTrainingTypeLabel" runat="server" Text='<%# Eval("IGTrainingType")%>' Font-Bold="True" /></li>
                                        <li runat="server" visible='<%# Eval("IGTraining") = "False"%>' class="list-group-item">No IG Training Reason:
                        <asp:Label ID="NoIGTrainingReasonLabel" runat="server" Text='<%# Eval("NoIGTrainingReason")%>' Font-Bold="True" /></li>
                                        <li runat="server" class="list-group-item">Cyber Essentials Status:  <asp:Label ID="Label3" runat="server" Text='<%# Eval("CyberEssentials")%>' Font-Bold="True" /></li>

                                        <li class='<%# "list-group-item " + DoWarning(Eval("HasPN"))%>'>Privacy Notice Supplied:
                        <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Eval("HasPN")%>' Enabled="false" />
                                             <a tabindex="0" title="Organisation Privacy Notice"" class="btn" role="button" data-toggle="popover" data-container="body" data-trigger="focus" data-placement="auto" data-content="Uploading or supplying a link to your organisation Privacy Notice allows it to be viewed and accessed by your sharing partners. You can supply your Privacy Notice using the Organisation / Organisation Details tab."><i aria-hidden="true" class="icon-info"></i></a>
                                        </li>

                                        <li class="list-group-item">Submitted By:
                        <asp:Label ID="SubmittedByUserNameLabel" runat="server" Text='<%# Eval("SubmittedByUserName")%>' Font-Bold="True" /></li>
                                        <li class="list-group-item">Submitted On:
                        <asp:Label ID="SubmittedDateLabel" runat="server" Text='<%# Eval("SubmittedDate", "{0:d}")%>' Font-Bold="True" /></li>
                                    </ItemTemplate>
                                    <EmptyDataTemplate>
                                        <li class="list-group-item">There is no active assurance submission for your organisation.
                                        </li>
                                    </EmptyDataTemplate>
                                </asp:FormView>
                            </ul>
                            <asp:LinkButton ID="lbtAddAssurance" CssClass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-plus"></i> New Assurance Submission</asp:LinkButton>
                        </div>
                        <div class="col-sm-6">
                            <div class="row">
                                <asp:ObjectDataSource ID="dsTierZero" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActiveForOrganisation" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_TierZeroSignaturesTableAdapter">
                                    <SelectParameters>
                                        <asp:SessionParameter Name="OrganisationID" SessionField="UserOrganisationID" Type="Int32" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>

                                <ul class="list-group">
                                    <li id="Li1" class="list-group-item" style="background-color: #e4e4e4" runat="server">
                                        <h3>Data Protection Impact Assessment Tool Usage Agreement (MoU)</h3>
                                    </li>
                                    <asp:FormView ID="fvUsageAgreement" runat="server" DataKeyNames="TierZeroID" DataSourceID="dsTierZero" RenderOuterTable="False">
                                        <ItemTemplate>
                                            <li class="list-group-item">Signed:<asp:Label ID="SignedDateLabel" runat="server" Text='<%# Eval("SignedDate")%>' Font-Bold="True" />
                                            </li>
                                            <li class="list-group-item">By:
                            <asp:Label ID="SignedByLabel" runat="server" Text='<%# Eval("SignedBy")%>' Font-Bold="True" />
                                            </li>
                                            <li class="list-group-item">Role:
                            <asp:Label ID="RoleIDLabel" runat="server" Text='<%# Eval("Role")%>' Font-Bold="True" />
                                            </li>
                                            <div id="divOnBehalf" runat="server" visible='<%# Eval("OnBehalfOf").ToString.Length > 0%>'>
                                                <li class="list-group-item">On Behalf Of:
                            <asp:Label ID="OnBehalfOfLabel" runat="server" Text='<%# Eval("OnBehalfOf")%>' Font-Bold="True" />
                                                </li>
                                                <li class="list-group-item">Role:
                            <asp:Label ID="OnBehalfOfRoleIDLabel" runat="server" Text='<%# Eval("BehalfOfRole")%>' Font-Bold="True" />
                                                </li>
                                            </div>
                                            <asp:HiddenField ID="hfUsageAgreementID" Value='<%# Eval("TierZeroID")%>' runat="server" />

                                            <li class="list-group-item">Evidence:
                                               <asp:ObjectDataSource ID="dsFiles" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByGroupTypeAndID" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_FilesByGroupTableAdapter">
                                                   <SelectParameters>
                                                       <asp:Parameter DefaultValue="agreement" Name="GroupType" Type="String" />
                                                       <asp:ControlParameter ControlID="hfUsageAgreementID" DefaultValue="0" Name="ID" PropertyName="Value" Type="Int32" />
                                                   </SelectParameters>
                                               </asp:ObjectDataSource>
                                                <div class="panel panel-default">
                                                    <table class="table table-striped">
                                                        <asp:Repeater ID="rptFiles" runat="server" DataSourceID="dsFiles">
                                                            <HeaderTemplate>
                                                                <div class="table-responsive">
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td>
                                                                        <asp:HyperLink ID="hlFile" runat="server"
                                                                            NavigateUrl='<%# Eval("FileID", "GetFile.aspx?FileID={0}")%>'>
                                                                            <i id="I1" aria-hidden="true" class='<%# Eval("Type")%>' runat="server"></i>
                                                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("FileName")%>'></asp:Label>
                                                                        </asp:HyperLink>
                                                                    </td>

                                                                </tr>
                                                            </ItemTemplate>
                                                            <FooterTemplate></div></FooterTemplate>
                                                        </asp:Repeater>
                                                    </table>
                                                </div>
                                            </li>
                                             <li class="list-group-item">
                                                 Download: <asp:LinkButton CssClass="btn btn-default btn-sm" ID="lbtDownload" CommandName="Download" runat="server"><i aria-hidden="true" class="icon-file-pdf-o"></i> MOU as PDF</asp:LinkButton>
                                             </li>
                                        </ItemTemplate>
                                        <EmptyDataTemplate>
                                            <li class="list-group-item">There is no signed Data Protection Impact Assessment Tool usage agreement (MoU) in place for this organisation.</li>
                                        </EmptyDataTemplate>
                                    </asp:FormView>
                                   
                                </ul>
                                 <div class="clearfix"><asp:LinkButton ID="lbtViewAgreement" CssClass="btn btn-default pull-left" runat="server"><span aria-hidden="true" class="icon-file"></span> View Agreement</asp:LinkButton></div>
                                <asp:Panel ID="pnlWhoCanSign"  CssClass="alert alert-warning" runat="server">
                                    <p>Only users with Senior Officer role or their delegates can sign the MoU.</p>
                                </asp:Panel>
                                
                                <asp:LinkButton ID="lbtSignAgreement" CssClass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-quill"></i> Review and Sign Usage Agreement</asp:LinkButton>
                            </div>
                           
                        </div>
                    </div>
                </div>
            </asp:View>
            <asp:View ID="vSubmitAssurance" runat="server">
                <div class="panel panel-primary" style="padding: 2%;">
                    <h2>New Assurance Submission</h2>
                    <fieldset class="form">

                        <asp:UpdatePanel ID="upnlICOReg" runat="server">
                            <ContentTemplate>
                                <div class="row-fluid">
                                    <div class="span2">
                                        <asp:Label ID="lblICOReg" runat="server" AssociatedControlID="rblICOReg">Are you registered with the Information Commissioners Office for processing Personal Information?
                                        </asp:Label>
                                    </div>
                                    <div class="span7">
                                        <asp:RadioButtonList class="radio-inline" ID="rblICOReg" runat="server" RepeatLayout="Flow" AutoPostBack="True">
                                            <asp:ListItem Text="Yes" Value="1" />
                                            <asp:ListItem Text="No" Value="0" />
                                        </asp:RadioButtonList>
                                    </div>
                                    <asp:RequiredFieldValidator Display="Dynamic" ID="rfvICOReg" runat="server" ErrorMessage="Required" ControlToValidate="rblICOReg" CssClass="field-validation-error help-inline" ToolTip="Required" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group" runat="server" id="divICODetails" visible="false">
                                    <div class="row">
                                        <div class="col-sm-7">
                                            <asp:Label ID="lblICORegNumber" runat="server" Text="Label" AssociatedControlID="tbICORegNumber">Registration number:</asp:Label>
                                            <asp:TextBox ID="tbICORegNumber" CssClass="form-control" runat="server" MaxLength="20"></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" ID="rfvICORegNumber" runat="server" ErrorMessage="ICO Registration Number Required" ToolTip="ICO Registration Number Required" ControlToValidate="tbICORegNumber" CssClass="field-validation-error help-inline" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </div>
                                        <div class="col-sm-5">
                                            <asp:Label ID="lblICORegReviewDate" runat="server" Text="Label" AssociatedControlID="tbICOReviewDate">Review date:</asp:Label>
                                            <asp:TextBox ID="tbICOReviewDate" CssClass="form-control" runat="server" ClientIDMode="Static"></asp:TextBox>
                                            <asp:RequiredFieldValidator Display="Dynamic" ID="rfvICOReviewDate" runat="server" ErrorMessage="ICO Registration Review Date Required" ToolTip="ICO Registration Review Date Required" ControlToValidate="tbICOReviewDate" CssClass="field-validation-error help-inline" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator runat="server" ID="revICOReviewDate" ControlToValidate="tbICOReviewDate" CssClass="field-validation-error help-inline" SetFocusOnError="True" ValidationExpression="^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d$"
    ErrorMessage="Please enter a valid date in the format dd/MM/yyyy" Tooltip="Please enter a valid date in the format dd/MM/yyyy" Display="Dynamic" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" runat="server" id="divICONotRegReason" visible="false">
                                    <asp:Label ID="lblICONotRegReason" runat="server" Text="Label" AssociatedControlID="tbICONotRegReason">Provide reason and details why you are not registered and / or if you intend to register:</asp:Label>
                                    <asp:TextBox ID="tbICONotRegReason" runat="server" MaxLength="1000" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                    <asp:RequiredFieldValidator Display="Dynamic" ID="rfvICONotRegReason" runat="server" ErrorMessage="Reason required" ControlToValidate="tbICONotRegReason" ToolTip="Reason required" CssClass="field-validation-error help-inline" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <asp:ObjectDataSource ID="dsComplianceTypes" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActive" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_IGComplianceTypesTableAdapter"></asp:ObjectDataSource>
                        <asp:UpdatePanel ID="upnlCompliance" runat="server">
                            <ContentTemplate>
                                <div class="form-group">
                                    <asp:Label ID="lblComplianceType" runat="server" AssociatedControlID="ddCompliance">Please select the most significant, recognised Information Governance compliance standards adhered to by your organisation?</asp:Label>
                                    <asp:DropDownList ID="ddCompliance" CssClass="form-control" AppendDataBoundItems="true" runat="server" DataSourceID="dsComplianceTypes" DataTextField="IGComplianceType" DataValueField="IGComplianceTypeID" AutoPostBack="True">
                                        <asp:ListItem Value="-1" Text="Please select..."></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator Display="Dynamic" ID="rfvCompliance" runat="server" ErrorMessage="Please select a standard or choose 'None'" ControlToValidate="ddCompliance" InitialValue="-1" ToolTip="Please select a standard or choose 'None'" CssClass="field-validation-error help-inline" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group" runat="server" id="divComplianceScoreVersion" visible="false">
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <asp:Label ID="lblScore" runat="server" AssociatedControlID="tbScore">Please indicate the score achieved:</asp:Label>
                                            <asp:TextBox ID="tbScore" CssClass="form-control" runat="server"></asp:TextBox>
                                        </div>
                                        <div class="col-sm-6">
                                            <asp:Label ID="lblToolkitVerion" runat="server" AssociatedControlID="tbToolkitVersion">Version of assessment tool:</asp:Label>
                                            <asp:TextBox ID="tbToolkitVersion" CssClass="form-control" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" runat="server" id="divNonComplianceReason" visible="false">
                                    <asp:Label ID="lblNonComplianceReason" AssociatedControlID="tbNonComplianceReason" runat="server">Provide details of other compliancy or reason why you are not compliant:</asp:Label>
                                    <asp:TextBox ID="tbNonComplianceReason" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <asp:UpdatePanel ID="upnlStaffScreened" runat="server">
                            <ContentTemplate>
                                <div class="row-fluid">
                                    <div class="span2">
                                        <asp:Label ID="lblScreened" runat="server" AssociatedControlID="rblScreened">Do all staff within your organisation go through appropriate screening prior to work e.g. identity checks, DBS checks and contracts?
                                        </asp:Label>
                                    </div>
                                    <div class="span7">
                                        <asp:RadioButtonList class="radio-inline" ID="rblScreened" runat="server" RepeatLayout="Flow" AutoPostBack="True">
                                            <asp:ListItem Text="Yes" Value="1" />
                                            <asp:ListItem Text="No" Value="0" />
                                        </asp:RadioButtonList>
                                    </div>
                                    <asp:RequiredFieldValidator Display="Dynamic" ID="rfvScreened" runat="server" ErrorMessage="Required" ControlToValidate="rblScreened" CssClass="field-validation-error help-inline" ToolTip="Required" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group" runat="server" id="divStaffScreeningDetails" visible="false">
                                    <asp:Label ID="lblStaffScreeningDetails" runat="server" AssociatedControlID="tbStaffScreeningDetails">Provide details of the type of checks e.g. identity, DBS</asp:Label>
                                    <asp:TextBox ID="tbStaffScreeningDetails" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                                <div class="form-group" runat="server" id="divNoScreeningReason" visible="false">
                                    <asp:Label ID="lblNoScreeningReason" runat="server" AssociatedControlID="tbNoScreeningReason">Please explain why staff are not screened and / or details of actions to implement screening with anticipated timescales:</asp:Label>
                                    <asp:TextBox ID="tbNoScreeningReason" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <asp:UpdatePanel ID="upnlStaffTrained" runat="server">
                            <ContentTemplate>
                                <div class="row-fluid">
                                    <div class="span2">
                                        <asp:Label ID="lblTrained" runat="server" AssociatedControlID="rblIGTrained">Are all staff within your organisation trained in confidentiality and data protection?
                                        </asp:Label>
                                    </div>
                                    <div class="span7">
                                        <asp:RadioButtonList class="radio-inline" ID="rblIGTrained" runat="server" RepeatLayout="Flow" AutoPostBack="True">
                                            <asp:ListItem Text="Yes" Value="1" />
                                            <asp:ListItem Text="No" Value="0" />
                                        </asp:RadioButtonList>
                                    </div>
                                    <asp:RequiredFieldValidator Display="Dynamic" ID="rfvTrained" runat="server" ErrorMessage="Required" ControlToValidate="rblIGTrained" CssClass="field-validation-error help-inline" ToolTip="Required" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group" runat="server" id="divStaffTrained" visible="false">
                                    <asp:Label ID="lblIGTrainingType" runat="server" AssociatedControlID="tbIGTrainingType">Provide details of training, if IGT Level 2 / PSN COCO etc:</asp:Label>
                                    <asp:TextBox ID="tbIGTrainingType" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                                <div class="form-group" runat="server" id="divStaffNotTrained" visible="false">
                                    <asp:Label ID="lblNoIGTrainingReason" runat="server" AssociatedControlID="tbNoIGTrainingReason">Provide explanation why staff are not trained in confidentiality and data protection and / or details of actions to amend this anticipated timescales:</asp:Label>
                                    <asp:TextBox ID="tbNoIGTrainingReason" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        <div class="form-group">
                            <asp:Label ID="lblCyberEssentials" runat="server" Text="Do you have or are you working towards Cyber Essentials" AssociatedControlID="ddCyberEssentials"></asp:Label>
                            <div class="input-group">
                                <span class="input-group-btn">
                                                <a tabindex="0" title="Cyber essentials"" class="btn btn-default btn-tooltip" role="button" data-toggle="popover" data-container="body" data-trigger="focus" data-placement="auto" data-content="Cyber Essentials is a government-backed, industry supported scheme to help organisations protect themselves against common cyber attacks. See the Resources tab for more info."><i aria-hidden="true" class="icon-info"></i></a>
                                            </span>
                            <asp:DropDownList ID="ddCyberEssentials" CssClass="form-control" runat="server" DataSourceID="dsCyberEssentials" DataTextField="CyberEssentialsType" DataValueField="CyberEssentialsID" AutoPostBack="True"></asp:DropDownList>
                                
                            </div>
                        </div>
                         <div class="form-group">
                            <asp:Label ID="lblPrivacyNotice" runat="server" Text="Have you supplied access to your organisation Privacy Notice?" AssociatedControlID="ddCyberEssentials"></asp:Label>
                            <div class="input-group">
                                <span class="input-group-btn">
                                                <a tabindex="0" title="Organisation Privacy Notice"" class="btn btn-default btn-tooltip" role="button" data-toggle="popover" data-container="body" data-trigger="focus" data-placement="auto" data-content="Uploading or supplying a link to your organisation Privacy Notice allows it to be viewed and accessed by your sharing partners. You can supply your Privacy Notice using the Organisation / Organisation Details tab."><i aria-hidden="true" class="icon-info"></i></a>
                                            </span>
                                <asp:TextBox ID="tbPN" CssClass="form-control" runat="server" Text="No" Enabled="false"></asp:TextBox>
                                
                            </div>
                        </div>
                        <div class="form-group">


                            <asp:LinkButton ID="lbtSubmitAssurance" CssClass="button-small btn btn-primary" runat="server" CausesValidation="True" CommandName="Insert"><i aria-hidden="true" class="icon-checkmark"></i> Submit</asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="lbtCancelInsert" CssClass="button-small btn btn-default" runat="server" CausesValidation="False" CommandName="Cancel"><i aria-hidden="true" class="icon-close"></i> Cancel</asp:LinkButton>

                        </div>

                    </fieldset>
                </div>
            </asp:View>
            <asp:View ID="vSignAgreement" runat="server">
                <div class="panel panel-primary" style="padding: 2%;">
                    <h2>Review and Sign DPIA Usage Agreement</h2>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">Data Protection Impact Assessment Tool – Memorandum of Understanding (Formerly Tier 0)</h3>
                        </div>
                        <asp:Literal ID="litMOUTextSO" runat="server"></asp:Literal>
                       
                    </div>
                    <div class="panel panel-primary" runat="server" id="divDecision">
                        <div class="panel-heading">
                            <h3 class="panel-title">Sign Agreement</h3>
                        </div>
                        <div class="panel-body">
                            <p>
                                By signing this MoU
                                <asp:Label ID="lblAgreeOrganisation" runat="server" Text="Label"></asp:Label>
                                gives an undertaking that it will abide by both the letter and the spirit of this document and will not, by the commission or omission of any action, do anything to damage the integrity of the group or bring it into disrepute.
                                         <asp:Label ID="lblAgreeOrganisation2" runat="server" Text="Label"></asp:Label>
                                also agrees to comply with any changes in form or function of the group, or in the criteria for membership or sponsorship as agreed by the group.
                                        We understand that organisations that do not abide by the terms set out in the MoU may be removed from the group.
                            </p>
                            <p>
                                Signatory:
                                <asp:Label ID="lblAgreeUserName" runat="server" Text="User Name"></asp:Label>, in my position of
                                        <asp:Label ID="lblAgreeRole" runat="server" Text="Role"></asp:Label>.
                                        <asp:Label ID="lblOnBehalfOf" runat="server" Text=""></asp:Label>
                            </p>
                            <div class="panel panel-default">
                                <asp:ObjectDataSource ID="dsAgreementFiles" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_FilesByGroupTableAdapter">
                                    <SelectParameters>
                                        <asp:SessionParameter DefaultValue="0" Name="FileGroupID" SessionField="AgreementFileGroupID" Type="Int32" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                                <table class="table table-striped">
                                    <asp:Repeater ID="rptFiles" runat="server" DataSourceID="dsAgreementFiles">
                                        <HeaderTemplate>
                                            <div class="table-responsive">
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <asp:HyperLink ID="hlFile" runat="server"
                                                        NavigateUrl='<%# Eval("FileID", "GetFile.aspx?FileID={0}")%>'>
                                                        <i id="I1" aria-hidden="true" class='<%# Eval("Type")%>' runat="server"></i>
                                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("FileName")%>'></asp:Label>
                                                    </asp:HyperLink>
                                                </td>
                                                <td style="width: 20px;">
                                                    <asp:LinkButton ID="lbtDelete" Visible='<%# Eval("OrganisationID") = Session("UserOrganisationID") Or Session("IsSuperAdmin")%>' OnClientClick="return confirm('Are you sure you want delete this file?');" runat="server" CommandName="Delete" CommandArgument='<%# Eval("FileID")%>' CssClass="btn btn-danger btn-xs" ToolTip="Delete File" CausesValidation="false"><i aria-hidden="true" class="icon-minus"></i><!--[if lt IE 8]>Delete<![endif]--></asp:LinkButton></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate></div></FooterTemplate>
                                    </asp:Repeater>
                                </table>
                            </div>
                            <asp:Panel ID="pnlFileUpload" runat="server">
                            <div class="input-group">
                                <span class="input-group-btn">
                                    <span class="btn btn-default btn-file">Browse&hellip;
                                            <asp:FileUpload AllowMultiple="true" ID="filEvidence" runat="server" />
                                    </span>
                                </span>
                                <input type="text" placeholder="Optional evidence file upload (max 1 MB)" class="form-control" readonly>
                                <span class="input-group-btn">
                                    <asp:LinkButton ID="lbtUpload" CausesValidation="false" CssClass="btn btn-default" runat="server"><i aria-hidden="true" class="icon-upload2"></i>  Upload</asp:LinkButton>
                                </span>
                            </div>
</asp:Panel>
                            <p></p>
                            <p>
                                <asp:LinkButton ID="lbtFinalSignAgreement" runat="server" CssClass="btn btn-success"><i aria-hidden="true" class="icon-quill"></i>Sign</asp:LinkButton>&nbsp;<asp:LinkButton ID="lbtCancelSign" runat="server" CssClass="btn btn-default"><i aria-hidden="true" class="icon-cancel-circle"></i>Cancel</asp:LinkButton>
                            </p>
                        </div>
                    </div>
                </div>
            </asp:View>
        </asp:MultiView>
        <!-- DPIA MOU Modal   -->
        <div id="modalMOU" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        
                            <h4 class="modal-title">Data Protection Impact Assessment Tool – Memorandum of Understanding (Formerly Tier 0)</h4>
                    </div>
                    <div class="modal-body">
                        <asp:Literal ID="litMOUView" runat="server"></asp:Literal>
                        
                    </div>
                   
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Standard Modal Message  -->
        <div id="modalMessage" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">
                            <asp:Label ID="lblModalHeading" runat="server" Text="Label"></asp:Label></h4>
                    </div>
                    <div class="modal-body">
                        <p>
                            <asp:Label ID="lblModalText" runat="server" Text="Label"></asp:Label>
                        </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <script type="text/javascript">

        $(document).on('change', '.btn-file :file', function () {
            var input = $(this),
                numFiles = input.get(0).files ? input.get(0).files.length : 1,
                label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
            input.trigger('fileselect', [numFiles, label]);
        });

        $(document).ready(function () {
            $('.btn-file :file').on('fileselect', function (event, numFiles, label) {

                var input = $(this).parents('.input-group').find(':text'),
                    log = numFiles > 1 ? numFiles + ' files selected' : label;

                if (input.length) {
                    input.val(log);
                } else {
                    if (log) alert(log);
                }

            });
        });
    </script>
</asp:Content>
