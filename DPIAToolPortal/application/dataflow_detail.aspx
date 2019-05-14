<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Application.Master" CodeBehind="dataflow_detail.aspx.vb" Inherits="InformationSharingPortal.data_in_request" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.Bootstrap.v17.2, Version=17.2.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   
    <link href="../Content/bootstrap-multiselect.css" rel="stylesheet" />
    <style>
        .clickable:hover {
            color: #333;
            background-color: #e6e6e6;
            border-color: #adadad;
        }

        .panel-nomargin {
            margin-bottom: 2px;
        }
       
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="server">    
    <div class="well well-sm">
        <b>
            <asp:Literal ID="litStatusSymbol" runat="server"><i aria-hidden="true" class="icon-pencil"></i></asp:Literal>
            <asp:Label ID="lblDataFlowHeader" runat="server" Text="Add Data Flow"></asp:Label>
        </b>
        <hr />
        <h4><small><asp:Label ID="lblSummaryName" runat="server" Text=""></asp:Label></small></h4>
        <h3>
            <asp:Label ID="lblDFSubHeader" runat="server" Text="New"></asp:Label>
            &nbsp;&nbsp;
            <button runat="server" id="btnHistory" title="View Transaction History" type="button" class="btn btn-default show-history"><i aria-hidden="true" class="icon-clock"></i></button>
        </h3>
        <hr />
        <div class="row">
            <div class="col-lg-1 col-sm-2">Status:</div>
            <div class="col-sm-2">
                <b>
                    <asp:Label ID="lblDFStatus" runat="server" Text="Draft"></asp:Label>
                </b>
            </div>
            <div class="col-lg-1 col-sm-2">Added By: <i aria-hidden="true" class="fa fa-arrow-circle-right"></i></div>
            <div class="col-lg-8 col-sm-6">
                <b>
                    <asp:Label ID="lblAddedByOrganisation" runat="server" Text="My Organisation"></asp:Label>
                </b>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script src="../Scripts/bootstrap/bootstrap-multiselect.js"></script>
    <script src="../Scripts/bsasper.js"></script>
    <script src="../Scripts/autosize.min.js"></script>
    <script>
        function doMultiSelect() {
            $('.multiselector').multiselect();
            $('.multiselector-all').multiselect({
                includeSelectAllOption: true
            });
        };
        function CheckAllSignees(Checkbox) {
            var gvSelectSignees = document.getElementById("<%=gvSelectSignees.ClientID%>");
            for (i = 1; i < gvSelectSignees.rows.length; i++) {
                gvSelectSignees.rows[i].cells[0].getElementsByTagName("INPUT")[0].checked = Checkbox.checked;
            }
            return false;
        }
        function CheckAllReviewers(Checkbox) {
            var gvDPOReviewers = document.getElementById("<%=gvDPOReviewers.ClientID%>");
            for (i = 1; i < gvDPOReviewers.rows.length; i++) {
                gvDPOReviewers.rows[i].cells[0].getElementsByTagName("INPUT")[0].checked = Checkbox.checked;
            }
            return false;
        }
        //$(document).ready(function () {
        //    $('.multiselect_once').multiselect();
        //});
    </script>

    <script type="text/javascript">
        function BindEvents() {
            $(document).ready(function () {
                autosize($('input, textarea'));
                $("input, textarea").bsasper({
                    placement: "right", createContent: function (errors) {
                        return '<span class="text-danger">' + errors[0] + '</span>';
                    }
                });
                doMultiSelect();
                //DoMultiSelect();
                $(".date-picker").datepicker({ dateFormat: 'dd/mm/yy' });
                //$("body").scrollspy({ target: "#MainContent_myScrollNav" })
                $('[data-toggle="popover"]').popover();
                $('.btn-file :file').on('fileselect', function (event, numFiles, label) {

                    var input = $(this).parents('.input-group').find(':text'),
                        log = numFiles > 1 ? numFiles + ' files selected' : label;

                    if (input.length) {
                        input.val(log);
                    } else {
                        if (log) alert(log);
                    }

                });
                //$('.toggleme').bootstrapToggle();
                //$("body").scrollspy({ target: "#MainContent_myScrollNav" })
            });
            $(document).on('change', '.btn-file :file', function () {
                var input = $(this),
                    numFiles = input.get(0).files ? input.get(0).files.length : 1,
                    label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
                input.trigger('fileselect', [numFiles, label]);
            });
        };
    </script>

    <asp:HiddenField ID="hfReadOnly" runat="server" Value="0" />
    <asp:HiddenField ID="hfFrequency" runat="server" />
    <asp:HiddenField ID="hfFlowDirection" runat="server" />
    <asp:HiddenField ID="hfNumberOfRecords" runat="server" />
    <asp:HiddenField ID="hfTransferSystemPlatform" runat="server" />
    <asp:HiddenField ID="hfFlowDetailID" runat="server" Value="0" />
    <asp:HiddenField ID="hfFlowFileGroupID" runat="server" />
    <asp:HiddenField ID="hfFlowDocsFileGroupID" runat="server" />
    <asp:HiddenField ID="hfSummaryID" runat="server" Value="0" />
    <asp:HiddenField ID="hfDADataFlowContact" runat="server" />
    <asp:HiddenField ID="hfOriginalDetailID" runat="server" />
    <asp:ObjectDataSource ID="dsDFDAccessedAfterTransfer" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDAccessedAfterTransferTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDBusinessContinuity" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDBusinessContinuityTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDConsentModel" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDConsentModelTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDDirectionOfFlow" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDDirectionOfFlowTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDDisasterRecovery" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDDisasterRecoveryTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDElectronicAccessedOnSite" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDElectronicAccessedOnSiteTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDElectronicByAutomated" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDElectronicByAutomatedTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDElectronicByEmail" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDElectronicByEmailTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDElectronicByManual" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDElectronicByManualTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDElectronicViaText" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDElectronicViaTextTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDFrequencyOfTransfer" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDFrequencyOfTransferTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDIncidentManagement" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDIncidentManagementTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDInformationAccess" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDInformationAccessTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDNonEEAExemptionsDerogations" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDNonEEAExemptionsDerogationsTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDNumberOfRecords" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDNumberOfRecordsTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDPaperByCourier" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDPaperByCourierTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDPaperByDataSubject" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDPaperByDataSubjectTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDPaperByFax" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDPaperByFaxTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDPaperByStaff" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDPaperByStaffTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDPaperByStandardPost" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDPaperByStandardPostTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDPoliciesProcessesSOPs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDPoliciesProcessesSOPsTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDPrivacyChanges" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDPrivacyChangesTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDRemovableByCourier" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDRemovableByCourierTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDRemovableByStaff" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDRemovableByStaffTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDRemovableByStandardPost" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDRemovableByStandardPostTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDRetentionDisposal" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDRetentionDisposalTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDSecuredAfterTransfer" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDSecuredAfterTransferTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDSecuredReceivingOrg" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDSecuredReceivingOrgTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDStorageAfterTransfer" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDStorageAfterTransferTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDSubjectAccessRequests" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDSubjectAccessRequestsTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDTrainingSystemData" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDTrainingSystemDataTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDUptodateAccurateComplete" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDUptodateAccurateCompleteTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDWhatTransferred" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDWhatTransferredTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfReadOnly" Name="IncludeInactive" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDTransferSystemPlatform" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActive" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.DFDTransferSystemPlatformTableAdapter"></asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsOrganisations" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByDFSummaryID" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DF_OrganisationsTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfSummaryID" DefaultValue="0" Name="DFSummaryID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsFurtherProvidingOrgs" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.FurtherProvidingOrganisationsTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="hfSummaryID" DefaultValue="0" Name="DFSummaryID" Type="Int32" />
            <asp:ControlParameter ControlID="hfFlowDetailID" DefaultValue="0" Name="DataFlowDetailID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsDFDInformationByVoice" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DFDInformationByVoiceTableAdapter"></asp:ObjectDataSource>
   <asp:ObjectDataSource ID="dsPIDItems" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetBySummary" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_PIDItemsTableAdapter">
               
                  <SelectParameters>
                    <asp:Parameter DefaultValue="False" Name="IsSensitive" Type="Boolean" />
                    <asp:ControlParameter ControlID="hfSummaryID" DefaultValue="0" Name="SummaryID" Type="Int32" />
                </SelectParameters>
               
            </asp:ObjectDataSource>
     <asp:ObjectDataSource ID="dsPIDSensitiveItems" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetBySummary" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_PIDItemsTableAdapter">
                <SelectParameters>
                    <asp:Parameter DefaultValue="True" Name="IsSensitive" Type="Boolean" />
                    <asp:ControlParameter ControlID="hfSummaryID" DefaultValue="0" Name="SummaryID" Type="Int32" />
                </SelectParameters>
            </asp:ObjectDataSource>
    <div id="divFreeWarning" runat="server" class="alert alert-danger alert-dismissible" visible="false" role="alert">
        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <asp:Label ID="Label14" runat="server" Text="Label"><b>WARNING:</b> Organisations accessing under a "free" licence Data Protection Impact Assessments at risk. There are no guarantees of continued access to your Data Protection Impact Assessment when using the DPIA under a "free" licence. To discuss licencing options for your organisation please contact <a href=',ailto:isg@mbhci.nhs.uk'>isg@mbhci.nhs.uk</a>.</asp:Label>
    </div>
    <ul class="nav nav-tabs">
        <li runat="server" id="liDataFlow" role="presentation">
            <asp:LinkButton ID="lbtDataFlow" runat="server" CausesValidation="False">Data Flow</asp:LinkButton>
        </li>
        <li runat="server" id="liPrivacy" role="presentation">
            <asp:LinkButton ID="lbtPrivacy" CausesValidation="False" runat="server">Privacy</asp:LinkButton>
        </li>
        <li runat="server" id="liOutcome" role="presentation">
            <asp:LinkButton ID="lbtOutcome" CausesValidation="False" runat="server">Risk Assessment</asp:LinkButton>
        </li>
        
        <li runat="server" id="liContacts" role="presentation">
            <asp:LinkButton ID="lbtContacts" CausesValidation="False" runat="server">Contacts</asp:LinkButton>
        </li>
        <li runat="server" id="liDocuments" role="presentation">
            <asp:LinkButton ID="lbtDocuments" CausesValidation="False" runat="server" Text="Additional Documents"></asp:LinkButton>
        </li>
        <li runat="server" id="liDPOReview" role="presentation">
            <asp:LinkButton CssClass="disabled" ID="lbtDPOReview" CausesValidation="False" runat="server">DPO Review</asp:LinkButton>
        </li>
        <li runat="server" id="liSignOff" role="presentation">
            <asp:LinkButton ID="lbtSignOff" CausesValidation="False" runat="server">Sign-off</asp:LinkButton>
        </li>
    </ul>
    <div class="container">
        <div class="row">
            <asp:ObjectDataSource ID="dsPrivacyStatus" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.PrivacyStatusTableAdapter"></asp:ObjectDataSource>

            <div id="form-content" class="col-xs-12 scroll-area">
                <div class="form-horizontal">
                    <asp:MultiView ID="mvDataFlow" runat="server" ActiveViewIndex="0">
                        <asp:View ID="vDataFlow" runat="server">
                            <asp:Panel ID="pnlDFD" runat="server">
                                <h2 id="dataflow">Data Flow Details 
                                </h2>

                                <div class="form-group">
                                    <asp:Label ID="lblDFDIdentifier" CssClass="control-label col-xs-5" runat="server" Text="Data flow name / identifier:" AssociatedControlID="tbDFDIdentifier"></asp:Label>
                                    <div class="col-xs-7">
                                        <div class="input-group">
                                            <asp:TextBox CssClass="form-control" ID="tbDFDIdentifier" runat="server"></asp:TextBox><span class="input-group-btn">
                                                <a tabindex="0" title="Name / identifier" class="btn btn-default btn-tooltip" role="button" data-toggle="popover" data-container="body" data-trigger="focus" data-placement="auto" data-content="The name / identifier should enable you and your colleagues to identify the data flow at a glance. Using a consistent approach will aid in locating the data flow at a later date. Your organisation may have a policy on naming conventions which could be relevant to your choice of name / identifier."><i aria-hidden="true" class="icon-info"></i></a>
                                            </span>

                                        </div>
                                        <asp:RegularExpressionValidator Display="Dynamic" ValidationGroup="vgDataFlowDetail" ControlToValidate="tbDFDIdentifier" ID="rxvDFDIdentifier" ValidationExpression="^[\s\S]{0,100}$" runat="server" ErrorMessage="Maximum 100 characters."></asp:RegularExpressionValidator>

                                        <asp:RequiredFieldValidator ValidationGroup="vgDataFlowDetail" ID="rfvDFDIdentifier" runat="server" ControlToValidate="tbDFDIdentifier"
                                            CssClass="bg-danger" ErrorMessage="The data flow name /identifier field is required." SetFocusOnError="True" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label30" runat="server" CssClass="control-label col-xs-5" AssociatedControlID="ddPrivacyStatus">Discoverability level:</asp:Label>
                                    <div class="col-xs-7">
                                        <div class="input-group">

                                            <span class="input-group-btn" id="discoverabilitytip">
                                                <a tabindex="0" title="Discoverability level" class="btn btn-default btn-tooltip" role="button" data-toggle="popover" data-container="body" data-trigger="focus" data-placement="auto" data-content="This will be used to set the discoverability of this data flow by other users. Public = details can be viewed by unauthenticated users. Authenticated DPIA = details can be viewed by logged in users any DPIA organisation. Private = details can only be viewed by users with roles at sharing partner organisations."><i aria-hidden="true" class="icon-info"></i></a>
                                            </span>
                                            <asp:DropDownList ID="ddPrivacyStatus" CssClass="form-control freeze-on-sign" runat="server" DataSourceID="dsPrivacyStatus" DataTextField="PrivacyStatus" DataValueField="PrivacyStatusID"></asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblDFDOrgsInvoled" CssClass="control-label col-xs-5" runat="server" AssociatedControlID="listOrganisations" Text="Organisations involved in this data flow:"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listOrganisations" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector-all" DataSourceID="dsOrganisations" DataTextField="OrganisationName" DataValueField="DF_OrgID"></asp:ListBox>

                                    </div>

                                </div>
                            </asp:Panel>
                            <asp:Panel ID="pnlAddProvidingOrgs" CssClass="form-group alert-warning" Enabled="true" runat="server">

                                <asp:Label ID="lblQuickAddOrg" CssClass="control-label col-xs-5" AssociatedControlID="listProvidingOrgs" runat="server" Text="Add further organisations (organisations receiving data cannot be added):"></asp:Label>
                                <div class="col-xs-7">
                                    <asp:ListBox ID="listProvidingOrgs" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector small no-freeze" runat="server" DataSourceID="dsFurtherProvidingOrgs" DataTextField="OrganisationName" DataValueField="DF_OrgID"></asp:ListBox>
                                    <asp:LinkButton ID="lbtAddSelected" CausesValidation="false" ToolTip="Add selected organisations" CssClass="btn btn-success pull-right" runat="server"><i aria-hidden="true" class="icon-plus"></i> <b>Add</b></asp:LinkButton>
                                </div>
                            </asp:Panel>
                            <asp:Panel ID="pnlDFD2" runat="server">
                                <div class="form-group">
                                    <asp:Label ID="lblDirectionOfFlow" CssClass="control-label col-xs-5" runat="server" Text="What is the direction of the data flow?" AssociatedControlID="ddDataFlowDirection"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                            <ContentTemplate>
                                                <asp:DropDownList AppendDataBoundItems="true" CssClass="form-control" AutoPostBack="true" ID="ddDataFlowDirection" runat="server" DataSourceID="dsDFDDirectionOfFlow" DataTextField="DirectionOfFlow" DataValueField="DFDDirectionOfFlowID">
                                                    <asp:ListItem Value="0">Please select...</asp:ListItem>
                                                </asp:DropDownList>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <asp:Label ID="lblFrequencyOfTransfer" CssClass="control-label col-xs-5" runat="server" Text="What is the frequency of the transfer?" AssociatedControlID="ddFrequencyOfTransfer"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:DropDownList AppendDataBoundItems="true" CssClass="form-control" ID="ddFrequencyOfTransfer" runat="server" DataSourceID="dsDFDFrequencyOfTransfer" DataTextField="FrequencyOfTransfer" DataValueField="DFDFrequencyOfTransferID">
                                            <asp:ListItem Value="0">Please select...</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:TextBox CssClass="form-control" ID="tbFrequencyOther" runat="server" PlaceHolder="Other - please specify"></asp:TextBox>
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbFrequencyOther" ID="rxvFrequencyOther" ValidationExpression="^[\s\S]{0,255}$" runat="server" ErrorMessage="Maximum 255 characters."></asp:RegularExpressionValidator>

                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblNumberOfRecords" CssClass="control-label col-xs-5" runat="server" Text="How many records are being transferred?" AssociatedControlID="ddNumberOfRecords"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:DropDownList AppendDataBoundItems="true" CssClass="form-control" ID="ddNumberOfRecords" runat="server" DataSourceID="dsDFDNumberOfRecords" DataTextField="NumberOfRecords" DataValueField="DFDNumberOfRecordsID">
                                            <asp:ListItem Value="0">Please select...</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <hr id="transfer" />
                                <h3>Transfer Modes and Controls</h3>

                                <asp:UpdatePanel ID="upnlWhatTransferred" runat="server">
                                    <ContentTemplate>
                                        <div class="form-group">

                                            <asp:Label ID="lblDFDWhatTransferred" CssClass="control-label col-xs-5" runat="server" AssociatedControlID="gridTransferModesControls">What is being transferred and how? <a tabindex="0" title="Transfer Modes and Controls" class="btn btn-xs" role="button" data-toggle="popover"  data-container="body" data-trigger="focus" data-placement="auto" data-content="Please tick all modes of data transfer that apply. Then use the drop downs to select all of the controls that are in place for each."><i aria-hidden="true" class="icon-info"></i></a></asp:Label>
                                            <div id="gridTransferModesControls" runat="server" class="col-xs-7">


                                                <asp:Label ID="lblDFDPaperByCourier" runat="server" AssociatedControlID="cbDFDPaperByCourier">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDPaperByCourier" runat="server" />
                                                    Paper delivered by courier</asp:Label>
                                            </div>

                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDPaperByCourier">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDPaperByCourier" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDPaperByCourier" DataTextField="PaperByCourier" DataValueField="DFDPaperByCourierID"></asp:ListBox>
                                            </asp:Panel>

                                            <div class="col-xs-offset-5 col-xs-7">

                                                <asp:Label ID="lblDFDPaperByStaff" runat="server" AssociatedControlID="cbDFDPaperByStaff">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDPaperByStaff" runat="server" />
                                                    Paper hand delivered by staff</asp:Label>
                                            </div>
                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDPaperByStaff">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDPaperByStaff" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDPaperByStaff" DataTextField="PaperByStaff" DataValueField="DFDPaperByStaffID"></asp:ListBox>
                                            </asp:Panel>

                                            <div class="col-xs-offset-5 col-xs-7">

                                                <asp:Label ID="lblDFDPaperByStandardPost" runat="server" AssociatedControlID="cbDFDPaperByStandardPost">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDPaperByStandardPost" runat="server" />
                                                    Paper delivered by standard post</asp:Label>
                                            </div>
                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDPaperByStandardPost">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDPaperByStandardPost" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDPaperByStandardPost" DataTextField="PaperByStandardPost" DataValueField="DFDPaperByStandardPostID"></asp:ListBox>
                                            </asp:Panel>

                                            <div class="col-xs-offset-5 col-xs-7">

                                                <asp:Label ID="lblDFDPaperByFax" runat="server" AssociatedControlID="cbDFDPaperByFax">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDPaperByFax" runat="server" />
                                                    Paper transferred by fax</asp:Label>
                                            </div>
                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDPaperByFax">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDPaperByFax" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDPaperByFax" DataTextField="PaperByFax" DataValueField="DFDPaperByFaxID"></asp:ListBox>
                                            </asp:Panel>

                                            <div class="col-xs-offset-5 col-xs-7">

                                                <asp:Label ID="lblDFDPaperByDataSubject" runat="server" AssociatedControlID="cbDFDPaperByDataSubject">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDPaperByDataSubject" runat="server" />
                                                    Paper transferred by data subject</asp:Label>
                                            </div>
                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDPaperByDataSubject">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDPaperByDataSubject" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDPaperByDataSubject" DataTextField="PaperByDataSubject" DataValueField="DFDPaperByDataSubjectID"></asp:ListBox>
                                            </asp:Panel>

                                            <div class="col-xs-offset-5 col-xs-7">

                                                <asp:Label ID="lblDFDRemovableByStaff" runat="server" AssociatedControlID="cbDFDRemovableByStaff">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDRemovableByStaff" runat="server" />
                                                    Removable media hand delivered by staff</asp:Label>
                                            </div>
                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDRemovableByStaff">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDRemovableByStaff" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDRemovableByStaff" DataTextField="RemovableByStaff" DataValueField="DFDRemovableByStaffID"></asp:ListBox>
                                            </asp:Panel>

                                            <div class="col-xs-offset-5 col-xs-7">

                                                <asp:Label ID="lblDFDRemovableByStandardPost" runat="server" AssociatedControlID="cbDFDRemovableByStandardPost">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDRemovableByStandardPost" runat="server" />
                                                    Removable media delivered by standard post</asp:Label>
                                            </div>
                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDRemovableByStandardPost">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDRemovableByStandardPost" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDRemovableByStandardPost" DataTextField="RemovableByStandardPost" DataValueField="DFDRemovableByStandardPostID"></asp:ListBox>
                                            </asp:Panel>

                                            <div class="col-xs-offset-5 col-xs-7">

                                                <asp:Label ID="lblDFDElectronicByEmail" runat="server" AssociatedControlID="cbDFDElectronicByEmail">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDElectronicByEmail" runat="server" />
                                                    Electronic data transferred by email</asp:Label>
                                            </div>
                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDElectronicByEmail">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDElectronicByEmail" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDElectronicByEmail" DataTextField="ElectronicByEmail" DataValueField="DFDElectronicByEmailID"></asp:ListBox>
                                            </asp:Panel>
                                            <div class="col-xs-offset-5 col-xs-7">

                                                <asp:Label ID="Label12" runat="server" AssociatedControlID="cbDFDInformationByVoice">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDInformationByVoice" runat="server" />
                                                    Information delivered by voice</asp:Label>
                                            </div>
                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDInformationByVoice">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDInformationByVoice" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDInformationByVoice" DataTextField="InformationByVoice" DataValueField="DFDInformationByVoiceID"></asp:ListBox>
                                            </asp:Panel>
                                            <div class="col-xs-offset-5 col-xs-7">

                                                <asp:Label ID="lblDFDElectronicByAutomated" runat="server" AssociatedControlID="cbDFDElectronicByAutomated">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDElectronicByAutomated" runat="server" />
                                                    Electronic data transferred via automated system to system</asp:Label>
                                            </div>
                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDElectronicByAutomated">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDElectronicByAutomated" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDElectronicByAutomated" DataTextField="ElectronicByAutomated" DataValueField="DFDElectronicByAutomatedID"></asp:ListBox>
                                            </asp:Panel>

                                            <div class="col-xs-offset-5 col-xs-7">

                                                <asp:Label ID="lblDFDElectronicByManual" runat="server" AssociatedControlID="cbDFDElectronicByManual">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDElectronicByManual" runat="server" />
                                                    Electronic data transferred via manual system transfer (uploaded or downloaded)</asp:Label>
                                            </div>
                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDElectronicByManual">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDElectronicByManual" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDElectronicByManual" DataTextField="ElectronicByManual" DataValueField="DFDElectronicByManualID"></asp:ListBox>
                                            </asp:Panel>

                                            <div class="col-xs-offset-5 col-xs-7">

                                                <asp:Label ID="lblDFDElectronicAccessedOnSite" runat="server" AssociatedControlID="cbDFDElectronicAccessedOnSite">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDElectronicAccessedOnSite" runat="server" />
                                                    Electronic data accessed on-site by staff working for partner organisations</asp:Label>
                                            </div>
                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDElectronicAccessedOnSite">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDElectronicAccessedOnSite" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDElectronicAccessedOnSite" DataTextField="ElectronicAccessedOnSite" DataValueField="DFDElectronicAccessedOnSiteID"></asp:ListBox>
                                            </asp:Panel>

                                            <div class="col-xs-offset-5 col-xs-7">

                                                <asp:Label ID="lblDFDElectronicViaText" runat="server" AssociatedControlID="cbDFDElectronicViaText">
                                                    <asp:CheckBox AutoPostBack="true" ID="cbDFDElectronicViaText" runat="server" />
                                                    Electronic data transferred via text</asp:Label>
                                            </div>
                                            <asp:Panel runat="server" CssClass="col-xs-offset-5 col-xs-7 well" Visible="false" ID="divDFDElectronicViaText">
                                                Controls:<br />
                                                <asp:ListBox ID="listDFDElectronicViaText" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDElectronicViaText" DataTextField="ElectronicViaText" DataValueField="DFDElectronicViaTextID"></asp:ListBox>
                                            </asp:Panel>



                                        </div>
                                        <div class="form-group">
                                            <asp:Label ID="lblTransferSystem" CssClass="control-label col-xs-5" runat="server" AssociatedControlID="ddDFDTransferSystemPlatform">Which electronic system or platform is being used to share data?</asp:Label>
                                            <div runat="server" class="col-xs-7">
                                                <div class="input-group">

                                                    <span class="input-group-btn" id="transfersystemtip">
                                                        <a tabindex="0" title="Transfer System or Platform" class="btn btn-default btn-tooltip" role="button" data-toggle="popover" data-container="body" data-trigger="focus" data-placement="auto" data-content="This will be used to identify data sharing arrangements associated with the sharing system or platform using the DPIA API, allowing the system to check for the existence of a sharing agreement before allowing data to be shared."><i aria-hidden="true" class="icon-info"></i></a>
                                                    </span>

                                                    <asp:DropDownList AppendDataBoundItems="true" CssClass="form-control" AutoPostBack="true" ID="ddDFDTransferSystemPlatform" runat="server" DataSourceID="dsDFDTransferSystemPlatform" DataTextField="TransferSystemPlatform" DataValueField="DFDTransferSystemPlatformID">
                                                        <asp:ListItem Value="0">None selected</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>


                                        <hr id="post-transfer" />
                                        <h3>Post Transfer Security</h3>

                                        <div class="form-group">
                                            <asp:Label ID="lblDFDStorageAfterTransfer" AssociatedControlID="listDFDStorageAfterTransfer" CssClass="control-label col-xs-5" runat="server" Text="Where will the information be stored after transfer?"></asp:Label>
                                            <div class="col-xs-7">
                                                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                                    <ContentTemplate>
                                                        <asp:ListBox AutoPostBack="true" ID="listDFDStorageAfterTransfer" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDStorageAfterTransfer" DataTextField="StorageAfterTransfer" DataValueField="DFDStorageAfterTransferID"></asp:ListBox>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <asp:Label ID="lblDFDSecuredAfterTransfer" AssociatedControlID="listDFDSecuredAfterTransfer" CssClass="control-label col-xs-5" runat="server" Text="How will the information be secured?"></asp:Label>
                                            <div class="col-xs-7">
                                                <asp:ListBox ID="listDFDSecuredAfterTransfer" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDSecuredAfterTransfer" DataTextField="SecuredAfterTransfer" DataValueField="DFDSecuredAfterTransferID"></asp:ListBox>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <asp:Label ID="lblDFDAccessedAfterTransfer" AssociatedControlID="listDFDAccessedAfterTransfer" CssClass="control-label col-xs-5" runat="server" Text="How will the Information be accessed?"></asp:Label>
                                            <div class="col-xs-7">
                                                <asp:ListBox ID="listDFDAccessedAfterTransfer" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDAccessedAfterTransfer" DataTextField="AccessedAfterTransfer" DataValueField="DFDAccessedAfterTransferID"></asp:ListBox>
                                            </div>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>


                            </asp:Panel>
                        </asp:View>
                        <asp:View ID="vPrivacy" runat="server">

                            <h2>Data Protection Impact Assessment</h2>


                            <hr id="dpa1" />
                            <h3>Assess the lawfulness, fairness and transparency</h3>

                            <div class="form-group">
                                <asp:Label ID="Label1" AssociatedControlID="listDFDAccessedAfterTransfer" CssClass="control-label col-xs-5" runat="server" Text="If there is a Privacy Notice in place, please upload:"></asp:Label>
                                <div class="col-xs-7">
                                    <div class="panel panel-default">
                                        <asp:ObjectDataSource ID="dsFlowFiles" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_FilesByGroupTableAdapter">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hfFlowFileGroupID" DefaultValue="-1" Name="FileGroupID"  Type="Int32" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>

                                        <table class="table table-striped">
                                            <asp:Repeater ID="rptFiles" runat="server" DataSourceID="dsFlowFiles">
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
                                                        <td style="width: 20px">
                                                            <asp:LinkButton ID="lbtDelete" Visible='<%# Eval("OrganisationID") = Session("UserOrganisationID") Or Session("IsSuperAdmin")%>' OnClientClick="return confirm('Are you sure you want delete this file?');" runat="server" CommandName="Delete" CommandArgument='<%# Eval("FileID")%>' CssClass="btn btn-danger btn-xs" ToolTip="Delete File" CausesValidation="false"><i aria-hidden="true" class="icon-minus"></i><!--[if lt IE 8]>Delete<![endif]--></asp:LinkButton></td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></div></FooterTemplate>
                                            </asp:Repeater>
                                        </table>
                                    </div>
                                    <asp:Panel ID="pnlFreeLicenceMessage" Visible="false" runat="server" CssClass="alert alert-danger alert-dismissible" role="alert">
                                        <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                                        <asp:Label ID="Label15" runat="server" Text="Label">You are accessing the DPIA under a "free" licence, as such you are unable to upload documents to a data flow. To discuss licencing options for your organisation please contact <a href='mailto:isg@mbhci.nhs.uk'>isg@mbhci.nhs.uk</a>.</asp:Label>

                                    </asp:Panel>
                                    <asp:Panel ID="pnlUpload" CssClass="input-group" runat="server">
                                        <span class="input-group-btn">
                                            <span class="btn btn-default btn-file">Browse&hellip;
                                                <asp:FileUpload AllowMultiple="true" ID="filEvidence" runat="server" />
                                            </span>
                                        </span>
                                        <input type="text" placeholder="Optional (max 5 MB)" class="form-control" >
                                        <span class="input-group-btn">
                                            <asp:LinkButton ID="lbtUpload" CausesValidation="false" CssClass="btn btn-default" runat="server"><i aria-hidden="true" class="icon-upload2"></i>  Upload</asp:LinkButton>
                                        </span>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlPIAExtra" runat="server">
                                        <asp:TextBox CssClass="form-control" ID="tbFairProcessingURL" runat="server" placeholder="Upload a file above or enter URL here"></asp:TextBox>
                                    </asp:Panel>
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="lblPrivacyNoticeAmends" AssociatedControlID="tbPrivacyNoticeAmends" CssClass="control-label col-xs-5" runat="server" Text="Is there a requirement to update / amend the host organisation's Privacy Notice?"></asp:Label>
                                <div class="col-xs-7">
                                    <asp:TextBox CssClass="form-control" ID="tbPrivacyNoticeAmends" runat="server" PlaceHolder="If 'yes', detail the amendments"></asp:TextBox>
                                    <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbPrivacyNoticeAmends" ID="rxvPrivacyNoticeAmends" ValidationExpression="^[\s\S]{0,500}$" runat="server" ErrorMessage="Maximum 500 characters."></asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <asp:Panel ID="pnlPIA" runat="server">
                                <div class="form-group">
                                    <asp:Label ID="lblDFDPrivacyChanges" AssociatedControlID="listDFDPrivacyChanges" CssClass="control-label col-xs-5" runat="server" Text="Select one or more statements that indicate a change to the privacy of the asset / data:"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listDFDPrivacyChanges" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDPrivacyChanges" DataTextField="PrivacyChanges" DataValueField="DFDPrivacyChangesID"></asp:ListBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblPurpose" AssociatedControlID="tbPurpose" CssClass="control-label col-xs-5" runat="server" Text="Purpose of the sharing:<br/><small class='text-muted'>(from summary)</small>"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:TextBox CssClass="form-control" ID="tbPurpose" Enabled="false" runat="server" TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblDFDConsentModel" AssociatedControlID="listDFDConsentModel" CssClass="control-label col-xs-5" runat="server" Text="Select one or more statements to describe the consent model used:"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listDFDConsentModel" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDConsentModel" DataTextField="ConsentModel" DataValueField="DFDConsentModelID"></asp:ListBox>
                                        <asp:TextBox CssClass="form-control" ID="tbConsentExemption" TextMode="MultiLine" runat="server" PlaceHolder="Provide evidence of consent model / justification for  consent exemption "></asp:TextBox>
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbConsentExemption" ID="rxvConsentExemption" ValidationExpression="^[\s\S]{0,500}$" runat="server" ErrorMessage="Maximum 500 characters."></asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblLegalGateways" AssociatedControlID="tbLegalGateways" CssClass="control-label col-xs-5" runat="server" Text="Legal gateways for the sharing of personal data:<br/><small class='text-muted'>(from summary)</small>"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:TextBox CssClass="form-control" ID="tbLegalGateways" Enabled="false" runat="server" TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label18" AssociatedControlID="tbDFSpecificLegalGateways" CssClass="control-label col-xs-5" runat="server" Text="Legal gateways specific to data flow:"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:TextBox MaxLength="1000" CssClass="form-control" ID="tbDFSpecificLegalGateways" Placeholder="if more specific than above" runat="server" TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                </div>
                                
                                <asp:Panel ID="pnlArticleSix" runat="server">
<div class="form-group">
                                    <asp:Label ID="lblArticleSixConditions" AssociatedControlID="tbArticleSixConditions" CssClass="control-label col-xs-5" runat="server" Text="Article 6 conditions for sharing personal data:<br/><small class='text-muted'>(from summary)</small>"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:TextBox CssClass="form-control" ID="tbArticleSixConditions" Enabled="false" runat="server" TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                </div>
                                </asp:Panel>
                                <asp:Panel ID="pnlPIDItems" runat="server">
                                <div class="form-group">
                                        <asp:Label ID="Label34" CssClass="control-label col-xs-5" runat="server" AssociatedControlID="listDFDPersonalItems">Personal data items:</asp:Label>
                        <div class="col-xs-7">
                            <asp:ListBox ID="listDFDPersonalItems" runat="server" DataSourceID="dsPIDItems" DataTextField="PIDItem" DataValueField="PIDItemID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector"></asp:ListBox>
                        </div>
                                        </div></asp:Panel>
                                
                                 <asp:Panel ID="pnlArticleNine" runat="server">
<div class="form-group">
                                    <asp:Label ID="Label27" AssociatedControlID="tbArticleNineConditions" CssClass="control-label col-xs-5" runat="server" Text="Article 9 conditions for sharing personal data:<br/><small class='text-muted'>(from summary)</small>"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:TextBox CssClass="form-control" ID="tbArticleNineConditions" Enabled="false" runat="server" TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                </div>
                                </asp:Panel>
                                 <asp:Panel ID="pnlSpecialCategory" runat="server"><div class="form-group">
                                        <asp:Label ID="Label35" CssClass="control-label col-xs-5" runat="server" AssociatedControlID="listDFDPersonalSensitiveItems">Special Category data items:</asp:Label>
                        <div class="col-xs-7">
                            <asp:ListBox ID="listDFDPersonalSensitiveItems" runat="server" DataSourceID="dsPIDSensitiveItems" DataTextField="PIDItem" DataValueField="PIDItemID" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector"></asp:ListBox>
                        </div>
                                 </div></asp:Panel>
                                <hr id="dpa3" />
                                <h3>Assess the adequacy, relevance, necessity</h3>
                                <div class="form-group">
                                    <asp:Label ID="lblDPAChecksForAsset" AssociatedControlID="tbDPAChecksForAsset" CssClass="control-label col-xs-5" runat="server" Text="What checks have been made regarding the adequacy, relevance and necessity for the collection of personal and / or sensitive data for this asset?"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:TextBox CssClass="form-control" ID="tbDPAChecksForAsset" runat="server" MaxLength="500" TextMode="MultiLine"></asp:TextBox>
                                        <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbDPAChecksForAsset" ID="rxvDPAChecksForAsset" ValidationExpression="^[\s\S]{0,500}$" runat="server" ErrorMessage="Maximum 500 characters."></asp:RegularExpressionValidator>

                                    </div>
                                </div>
                                <hr id="dpa4" />
                                <h3>Assess the provisions for the accuracy of the data</h3>
                                <div class="form-group">
                                    <asp:Label ID="lblDFDUptodateAccurateComplete" AssociatedControlID="listDFDUptodateAccurateComplete" CssClass="control-label col-xs-5" runat="server" Text="Select one or more statements that describe how the information will be kept up to date and checked for accuracy and completeness by all organisations:"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listDFDUptodateAccurateComplete" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDUptodateAccurateComplete" DataTextField="UptodateAccurateComplete" DataValueField="DFDUptodateAccurateCompleteID"></asp:ListBox>
                                    </div>
                                </div>
                                <hr id="dpa5" />
                                <h3>Assess the retention and disposal requirements</h3>
                                <div class="form-group">
                                    <asp:Label ID="lblDFDRetentionDisposal" AssociatedControlID="listDFDRetentionDisposal" CssClass="control-label col-xs-5" runat="server" Text="Select one or more statements to describe your management of the retention and dispoal of data by all organisations:"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listDFDRetentionDisposal" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDRetentionDisposal" DataTextField="RetentionDisposal" DataValueField="DFDRetentionDisposalID"></asp:ListBox>
                                    </div>
                                </div>
                                <hr id="dpa6" />
                                <h3>Assess the requirements for individuals exercise their rights with regard to their data</h3>
                                <div class="form-group">
                                    <asp:Label ID="lblDFDSubjectAccessRequests" AssociatedControlID="listDFDSubjectAccessRequests" CssClass="control-label col-xs-5" runat="server" Text="Select one or more statements to describe how you deal with Subject Access Requests for individual records and how you rectify / block / erase / destroy as necessary by individual request or court order by the data controller (host organisation):"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listDFDSubjectAccessRequests" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDSubjectAccessRequests" DataTextField="SubjectAccessRequests" DataValueField="DFDSubjectAccessRequestsID"></asp:ListBox>
                                    </div>
                                </div>
                                <hr id="dpa7" />
                                <h3>Assess the technical and organisational measures</h3>
                                <div class="form-group">
                                    <asp:Label ID="lblDFDPoliciesProcessesSOPs" AssociatedControlID="listDFDPoliciesProcessesSOPs" CssClass="control-label col-xs-5" runat="server" Text="Select one or more statements to describe  the receiving organisation's policies, processes and standard operating procedures:"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listDFDPoliciesProcessesSOPs" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDPoliciesProcessesSOPs" DataTextField="PoliciesProcessesSOPs" DataValueField="DFDPoliciesProcessesSOPsID"></asp:ListBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblDFDIncidentManagement" AssociatedControlID="listDFDIncidentManagement" CssClass="control-label col-xs-5" runat="server" Text="Select one or more statements that describe the receiving organisation's management of incidents:"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listDFDIncidentManagement" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDIncidentManagement" DataTextField="IncidentManagement" DataValueField="DFDIncidentManagementID"></asp:ListBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblDFDTrainingSystemData" AssociatedControlID="listDFDTrainingSystemData" CssClass="control-label col-xs-5" runat="server" Text="Select one or more statements that describe the receiving organisation's training for both the system and data:"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listDFDTrainingSystemData" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDTrainingSystemData" DataTextField="TrainingSystemData" DataValueField="DFDTrainingSystemDataID"></asp:ListBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblDFDSecuredReceivingOrg" AssociatedControlID="listDFDSecuredReceivingOrg" CssClass="control-label col-xs-5" runat="server" Text="Select one or more statements that describe the receiving organisation's security of the asset:"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listDFDSecuredReceivingOrg" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDSecuredReceivingOrg" DataTextField="SecuredReceivingOrg" DataValueField="DFDSecuredReceivingOrgID"></asp:ListBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblDFDBusinessContinuity" AssociatedControlID="listDFDBusinessContinuity" CssClass="control-label col-xs-5" runat="server" Text="Select one or more statements that describe the receiving organisation's business continuity arrangements:"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listDFDBusinessContinuity" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDBusinessContinuity" DataTextField="BusinessContinuity" DataValueField="DFDBusinessContinuityID"></asp:ListBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblDFDDisasterRecovery" AssociatedControlID="listDFDDisasterRecovery" CssClass="control-label col-xs-5" runat="server" Text="Select one or more statements that describe the receiving organisation's disaster recovery arrangements:"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:ListBox ID="listDFDDisasterRecovery" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDDisasterRecovery" DataTextField="DisasterRecovery" DataValueField="DFDDisasterRecoveryID"></asp:ListBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblThirdPartContractIGClauses" AssociatedControlID="rblThirdPartContractIGClauses" CssClass="control-label col-xs-5" runat="server" Text="Where applicable, do the third party / supplier contracts contain all the necessary Information Governance clauses including information about  Data Protection (2018) and Freedom of Information (2000)?"></asp:Label>
                                    <div class="col-xs-7">
                                        <asp:RadioButtonList ID="rblThirdPartContractIGClauses" runat="server">
                                            <asp:ListItem Text="Yes" Value="1" />
                                            <asp:ListItem Text="No" Value="0" />
                                            <asp:ListItem Text="N/A" Value="2" Selected="True" />
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                
                                <hr id="dpa8" />
                                <h3>Assess the requirements of the data if it is being transferred outside of the EEA</h3>
                                <asp:UpdatePanel ID="upnlEEA" runat="server">
                                    <ContentTemplate>
                                        <div class="form-group">
                                            <asp:Label ID="lblOutsideEEA" AssociatedControlID="rblOutsideEEA" CssClass="control-label col-xs-5" runat="server" Text="Will personal and / or sensitive data be transferred to or from a country outside the European Economic Area (EEA)?"></asp:Label>
                                            <div class="col-xs-7">
                                                <asp:RadioButtonList ID="rblOutsideEEA" runat="server" Enabled="False">
                                                    <asp:ListItem Text="Yes" Value="1" />
                                                    <asp:ListItem Text="No" Value="0" Selected="True" />
                                                </asp:RadioButtonList>
                                            </div>
                                        </div>
                                        <asp:Panel ID="pnlOutsideEAA" runat="server">
                                            <h3><small>Please complete the following 'Adequacy Rules':</small></h3>
                                            <div class="form-group">
                                                <asp:Label ID="lblDFDNonEEAExemptionsDerogations" AssociatedControlID="listDFDNonEEAExemptionsDerogations" CssClass="control-label col-xs-5" runat="server" Text="If applicable select one or more exemptions (derogations) that may legitimise the transfer:"></asp:Label>
                                                <div class="col-xs-7">
                                                    <asp:ListBox ID="listDFDNonEEAExemptionsDerogations" runat="server" SelectionMode="Multiple" ClientIDMode="Static" CssClass="multiselector" DataSourceID="dsDFDNonEEAExemptionsDerogations" DataTextField="NonEEAExemptionsDerogations" DataValueField="DFDNonEEAExemptionsDerogationsID"></asp:ListBox>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="lblNatureOfData" AssociatedControlID="tbNatureOfData" CssClass="control-label col-xs-5" runat="server" Text="Nature of the personal data:"></asp:Label>
                                                <div class="col-xs-7">
                                                    <asp:TextBox CssClass="form-control" ID="tbNatureOfData" Enabled="false" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="lblNonEEADataCountryOrigin" AssociatedControlID="tbNonEEADataCountryOrigin" CssClass="control-label col-xs-5" runat="server" Text="Country or territory of origin of the data:"></asp:Label>
                                                <div class="col-xs-7">
                                                    <asp:TextBox CssClass="form-control" ID="tbNonEEADataCountryOrigin" runat="server" MaxLength="50" TextMode="SingleLine"></asp:TextBox>
                                                    <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbNonEEADataCountryOrigin" ID="rxvNonEEADataCountryOrigin" ValidationExpression="^[\s\S]{0,50$" runat="server" ErrorMessage="Maximum 50 characters."></asp:RegularExpressionValidator>

                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="lblNonEEADataCountryDestinsation" AssociatedControlID="tbNonEEADataCountryDestinsation" CssClass="control-label col-xs-5" runat="server" Text="Country or territory of final destination of the data:"></asp:Label>
                                                <div class="col-xs-7">
                                                    <asp:TextBox CssClass="form-control" ID="tbNonEEADataCountryDestinsation" runat="server" MaxLength="50" TextMode="SingleLine"></asp:TextBox>
                                                    <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbNonEEADataCountryDestinsation" ID="rxvNonEEADataCountryDestinsation" ValidationExpression="^[\s\S]{0,50$" runat="server" ErrorMessage="Maximum 50 characters."></asp:RegularExpressionValidator>

                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="lblPurposeNonEAA" AssociatedControlID="tbPurposeNonEAA" CssClass="control-label col-xs-5" runat="server" Text="The purposes for which the data are intended to be processed:"></asp:Label>
                                                <div class="col-xs-7">
                                                    <asp:TextBox CssClass="form-control" ID="tbPurposeNonEAA" Enabled="false" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="lblNonEEAProcessingDates" AssociatedControlID="tbNonEEAProcessingStartDate" CssClass="control-label col-xs-5" runat="server" Text="Period during which the data are intended to be processed:"></asp:Label>
                                                <div class="col-xs-7 input-group" style="padding-left: 15px;">
                                                    <asp:TextBox CssClass="form-control date-picker" ID="tbNonEEAProcessingStartDate" placeholder="From (dd/mm/yyyy)" runat="server" MaxLength="50" TextMode="DateTime"></asp:TextBox><asp:TextBox CssClass="form-control date-picker" ID="tbNonEEAProcessingEndDate" placeholder="To (dd/mm/yyyy)" runat="server" MaxLength="50" TextMode="DateTime"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="lblNonEEACountryLaws" AssociatedControlID="tbNonEEACountryLaws" CssClass="control-label col-xs-5" runat="server" Text="The law in force in the Non-EEA country or territory:"></asp:Label>
                                                <div class="col-xs-7">
                                                    <asp:TextBox CssClass="form-control" ID="tbNonEEACountryLaws" runat="server" MaxLength="500" TextMode="MultiLine"></asp:TextBox>
                                                    <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbNonEEACountryLaws" ID="rxvNonEEACountryLaws" ValidationExpression="^[\s\S]{0,500$" runat="server" ErrorMessage="Maximum 500 characters."></asp:RegularExpressionValidator>

                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="lblNonEEACountryObligations" AssociatedControlID="tbNonEEACountryObligations" CssClass="control-label col-xs-5" runat="server" Text="The international obligations of that country or territory:"></asp:Label>
                                                <div class="col-xs-7">
                                                    <asp:TextBox CssClass="form-control" ID="tbNonEEACountryObligations" runat="server" MaxLength="500" TextMode="MultiLine"></asp:TextBox>
                                                    <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbNonEEACountryObligations" ID="rxvNonEEACountryObligations" ValidationExpression="^[\s\S]{0,500$" runat="server" ErrorMessage="Maximum 500 characters."></asp:RegularExpressionValidator>

                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="lblNonEEACountryCoCo" AssociatedControlID="tbNonEEACountryCoCo" CssClass="control-label col-xs-5" runat="server" Text="Any relevant codes of conduct or other rules which are enforceable in the country or territor:"></asp:Label>
                                                <div class="col-xs-7">
                                                    <asp:TextBox CssClass="form-control" ID="tbNonEEACountryCoCo" placeholder="Which either generally apply or have been arranged for this particular case" runat="server" MaxLength="500" TextMode="MultiLine"></asp:TextBox>
                                                    <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbNonEEACountryCoCo" ID="rxvNonEEACountryCoCo" ValidationExpression="^[\s\S]{0,500$" runat="server" ErrorMessage="Maximum 500 characters."></asp:RegularExpressionValidator>

                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="lblNonEEASecurityMeasures" AssociatedControlID="tbNonEEASecurityMeasures" CssClass="control-label col-xs-5" runat="server" Text="Any security measures taken in respect of the data in that country or territory:"></asp:Label>
                                                <div class="col-xs-7">
                                                    <asp:TextBox CssClass="form-control" ID="tbNonEEASecurityMeasures" runat="server" MaxLength="500" TextMode="Multiline"></asp:TextBox>
                                                    <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="tbNonEEASecurityMeasures" ID="rxvNonEEASecurityMeasures" ValidationExpression="^[\s\S]{0,500$" runat="server" ErrorMessage="Maximum 500 characters."></asp:RegularExpressionValidator>

                                                </div>
                                            </div>
                                        </asp:Panel>
                                    </ContentTemplate>
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddDataFlowDirection" EventName="SelectedIndexChanged" />
                                        <asp:AsyncPostBackTrigger ControlID="listDFDStorageAfterTransfer" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                </asp:UpdatePanel>
                            </asp:Panel>
                        </asp:View>
                        <asp:View ID="vOutcome" runat="server">
                            <h2>Risk Assessment</h2>
                            <div class="panel panel-default">

                                <asp:MultiView ID="mvOutcome" runat="server">
                                    <asp:View ID="vSaveFirst" runat="server">
                                        <div class="panel-body">
                                            <p class="alert alert-danger clearfix">Before generating a Risk Assessment, this data flow must be saved. Once saved, return here to generate your risk assessment.</p>
                                        </div>
                                    </asp:View>
                                    <asp:View ID="vGenerateAssessment" runat="server">
                                        <div class="panel-body">
                                            <h3>Generate Risk Assessment</h3>
                                            <div class="alert alert-warning clearfix">
                                                <p>We recommend that you complete as much of the data flow detail and, if applicable, privacy impact assessment for this data flow before generating a risk assessment.</p>
                                                <p>System generated risk assessments will not be updated to reflect and changes you make to the data flow after generating them.</p>
                                                <p>Please ensure that the risk assessment accurately captures the risks associated with the data flow before finalising.</p>
                                            </div>
                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <asp:Label ID="lblAutoGenerate" CssClass="col-md-5 control-label" runat="server" Text="Automatically generate risks of what level:" AssociatedControlID="ddAutoGenerateLevel"></asp:Label>
                                                    <div class="col-md-7">
                                                        <asp:DropDownList CssClass="form-control" ID="ddAutoGenerateLevel" runat="server">
                                                            <asp:ListItem Text="None - I will add my own" Value="0"></asp:ListItem>
                                                            <asp:ListItem Text="High only" Value="3"></asp:ListItem>
                                                            <asp:ListItem Text="High and significant only" Value="2"></asp:ListItem>
                                                            <asp:ListItem Text="High, significant and low (All)" Value="1" Selected="True"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="col-md-7 col-md-offset-5">
                                                        <asp:LinkButton ID="lbtGenerate" CausesValidation="false" CssClass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-flash"></i> Generate</asp:LinkButton>
                                                    </div>
                                                </div>
                                            </div>
                                            <hr />
                                            <h3>Import Risk Assessment</h3>
                                            <div class="alert alert-info clearfix">
                                                <p>You may wish to import a risk assessment from another data flow if:</p>
                                                <ul>
                                                    <li>you have copied a data flow and the risk assessment remains the same</li>
                                                    <li>you have added a risk assessment to another data flow that is also applicable to this one</li>
                                                </ul>
                                            </div>

                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <asp:Label ID="Label10" CssClass="col-md-5 control-label" runat="server" Text="Import risk assessment from data flow:" AssociatedControlID="ddAutoGenerateLevel"></asp:Label>

                                                    <div class="col-md-7">
                                                        <asp:ObjectDataSource ID="dsImportFromDF" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DataFlowPickRATableAdapter">
                                                            <SelectParameters>
                                                                <asp:SessionParameter Name="OrgID" SessionField="UserOrganisationID" Type="Int32" />
                                                            </SelectParameters>
                                                        </asp:ObjectDataSource>
                                                        <asp:DropDownList CssClass="form-control" ID="ddImportFromDF" runat="server" DataSourceID="dsImportFromDF" DataTextField="DFDIdentifier" DataValueField="DataFlowDetailID">
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="col-md-7 col-md-offset-5">
                                                        <asp:LinkButton ID="lbtImportRA" CausesValidation="false" CssClass="btn btn-default pull-right" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-import"></i> Import</asp:LinkButton>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="alert alert-danger clearfix">
                                                <p><strong>NOTE:</strong> When importing a risk assessment from another data flow, each system generated risk will be imported "as is" and won't be updated or changed in any way to reflect the data flow they are imported to.</p>
                                            </div>
                                        </div>
                                    </asp:View>
                                    <asp:View ID="vRiskAssessment" runat="server">

                                        <div class="panel-body">
                                            <asp:LinkButton ID="lbtDeleteRiskAssessment" CssClass="btn btn-danger pull-right" ToolTip="Delete risks and risk assessment" runat="server" CausesValidation="False">Delete Risk Assessment</asp:LinkButton>
                                            <h3>Risks</h3>

                                            <asp:ObjectDataSource ID="dsRisks" runat="server" DeleteMethod="DeleteRisk" InsertMethod="InsertRisk" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByRiskAssessmentID" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_RisksTableAdapter" UpdateMethod="UpdateRisk">
                                                <DeleteParameters>
                                                    <asp:Parameter Name="Original_RiskID" Type="Int32" />
                                                </DeleteParameters>
                                                <InsertParameters>
                                                    <asp:SessionParameter DefaultValue="0" Name="RiskAssessmentID" SessionField="RiskAssessmentID" Type="Int32" />
                                                    <asp:Parameter Name="RiskDescription" Type="String" />
                                                    <asp:Parameter Name="Controls" Type="String" />
                                                    <asp:Parameter Name="RiskRating" Type="Int32" />
                                                    <asp:Parameter Name="Actions" Type="String" />
                                                    <asp:Parameter Name="ActionTypeID" Type="Int32" />
                                                    <asp:Parameter Name="FinalRiskRating" Type="Int32" />
                                                </InsertParameters>
                                                <SelectParameters>
                                                    <asp:SessionParameter DefaultValue="0" Name="RiskAssessmentID" SessionField="RiskAssessmentID" Type="Int32" />
                                                </SelectParameters>
                                                <UpdateParameters>
                                                    <asp:Parameter Name="RiskAssessmentID" Type="Int32" />
                                                    <asp:Parameter Name="RiskDescription" Type="String" />
                                                    <asp:Parameter Name="Controls" Type="String" />
                                                    <asp:Parameter Name="RiskRating" Type="Int32" />
                                                    <asp:Parameter Name="Actions" Type="String" />
                                                    <asp:Parameter Name="ActionTypeID" Type="Int32" />
                                                    <asp:Parameter Name="FinalRiskRating" Type="Int32" />
                                                    <asp:Parameter Name="Original_RiskID" Type="Int32" />
                                                </UpdateParameters>
                                            </asp:ObjectDataSource>
                                            <asp:ObjectDataSource ID="dsActionTypes" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActive" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_RiskActionTypesTableAdapter"></asp:ObjectDataSource>
                                            <div class="panel panel-default">
                                                <div class="table-responsive">
                                                    <dx:ASPxGridViewExporter ID="bsgvExporter" GridViewID="bsgvRisks" FileName="DPIA-Risk-Assessment" runat="server"></dx:ASPxGridViewExporter>
                                                    <dx:BootstrapGridView ID="bsgvRisks" runat="server" OnToolbarItemClick="GridViewCustomToolbar_ToolbarItemClick" SettingsPager-Visible="False" AutoGenerateColumns="False" DataSourceID="dsRisks" KeyFieldName="RiskID" Settings-GridLines="Horizontal" SettingsEditing-EditFormColumnSpan="12" SettingsBootstrap-Striped="True" SettingsCookies-StorePaging="False" SettingsCookies-StoreSearchPanelFiltering="False" SettingsCustomizationDialog-Enabled="True" SettingsDataSecurity-AllowEdit="True" SettingsDataSecurity-AllowDelete="True">
                                                        <SettingsCookies Enabled="false" StorePaging="False" StoreSearchPanelFiltering="False" />
                                                        <SettingsPager PageSize="30">
                                                        </SettingsPager>
                                                        <SettingsSearchPanel Visible="true" AllowTextInputTimer="false" />
                                                        <ClientSideEvents ToolbarItemClick="onToolbarItemClick" />
                                                        <CssClasses Table="table table-striped" />
                                                        <SettingsBootstrap Striped="True" />
                                                        <Settings ShowHeaderFilterButton="True" />
                                                        <SettingsEditing EditFormColumnSpan="12">
                                                        </SettingsEditing>
                                                        <SettingsDataSecurity AllowDelete="True" AllowEdit="True" />
                                                        <SettingsBehavior ConfirmDelete="true" />
                                                        <Columns>

                                                            <dx:BootstrapGridViewCheckColumn Caption=" " Name="SysGenerated" Settings-AllowHeaderFilter="False" ShowInCustomizationDialog="False" FieldName="SysGenerated" ReadOnly="True" VisibleIndex="0">
                                                                <Settings AllowHeaderFilter="False" />
                                                                <DataItemTemplate>
                                                                    <div class="text-muted">
                                                                        <i runat="server" aria-hidden="true" class='<%# IIf(Eval("SysGenerated"), "glyphicon glyphicon-cog", "glyphicon glyphicon-user")%>' enableviewstate="false" title='<%# IIf(Eval("SysGenerated"), "System Generated", "Added by User")%>'></i>
                                                                    </div>
                                                                </DataItemTemplate>
                                                                <EditItemTemplate></EditItemTemplate>
                                                            </dx:BootstrapGridViewCheckColumn>
                                                            <dx:BootstrapGridViewTextColumn Caption="Description" Width="25%" FieldName="RiskDescription" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                                <Settings AllowHeaderFilter="False" />
                                                                <EditItemTemplate>
                                                                    <asp:HiddenField ID="hfRiskID" runat="server" Value='<%# Eval("RiskID")%>' />
                                                                    <asp:HiddenField ID="hfRiskAssessmentID" runat="server" Value='<%# Bind("RiskAssessmentID")%>' />
                                                                    <asp:Label EnableViewState="false" ID="Label1" Visible='<%# Eval("SysGenerated")%>' runat="server" Text='<%# Bind("RiskDescription") %>'></asp:Label>
                                                                    <asp:TextBox EnableViewState="false" TextMode="MultiLine" Rows="4" ID="TextBox1" Visible='<%# Not Eval("SysGenerated")%>' Text='<%# Bind("RiskDescription") %>' CssClass="form-control" runat="server"></asp:TextBox>
                                                                </EditItemTemplate>
                                                                <DataItemTemplate>
                                                                    <asp:Label ID="Label1" runat="server" EnableViewState="false" Text='<%# Bind("RiskDescription") %>'></asp:Label>
                                                                </DataItemTemplate>
                                                            </dx:BootstrapGridViewTextColumn>
                                                            <dx:BootstrapGridViewTextColumn FieldName="Controls" Width="25%" Settings-AllowHeaderFilter="False" VisibleIndex="2">
                                                                <Settings AllowHeaderFilter="False" />
                                                                <DataItemTemplate>
                                                                    <asp:Label ID="Label3" runat="server" EnableViewState="false" Text='<%# Bind("Controls") %>'></asp:Label>
                                                                </DataItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:Label EnableViewState="false" Visible='<%# Eval("SysGenerated")%>' ID="Label3" runat="server" Text='<%# Bind("Controls") %>'></asp:Label>
                                                                    <asp:TextBox EnableViewState="false" TextMode="MultiLine" Rows="4" ID="TextBox2" Visible='<%# Not Eval("SysGenerated")%>' Text='<%# Bind("Controls") %>' CssClass="form-control" runat="server"></asp:TextBox>

                                                                </EditItemTemplate>
                                                            </dx:BootstrapGridViewTextColumn>
                                                            <dx:BootstrapGridViewTextColumn Caption="Initial Rating" FieldName="RiskRating" VisibleIndex="3">
                                                                <DataItemTemplate>
                                                                    <asp:Label ID="lblLow" runat="server" CssClass="label label-success ragblob" EnableViewState="false" Visible='<%# Eval("RiskRating") = 1%>' Width="90%">Low</asp:Label>
                                                                    <asp:Label ID="lblSignificant" runat="server" CssClass="label label-warning ragblob" EnableViewState="false" Visible='<%# Eval("RiskRating") = 2%>' Width="90%">Significant</asp:Label>
                                                                    <asp:Label ID="lblHigh" runat="server" CssClass="label label-danger ragblob" EnableViewState="false" Visible='<%# Eval("RiskRating") = 3%>' Width="90%">High</asp:Label>
                                                                </DataItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:Label EnableViewState="false" ID="lblLow" runat="server" Width="90px" CssClass="label label-success ragblob" Visible='<%# Eval("RiskRating") = 1%>'>Low</asp:Label>
                                                                    <asp:Label EnableViewState="false" ID="lblSignificant" Width="90px" runat="server" CssClass="label label-warning ragblob" Visible='<%# Eval("RiskRating") = 2%>'>Significant</asp:Label>
                                                                    <asp:Label EnableViewState="false" ID="lblHigh" Width="90px" runat="server" CssClass="label label-danger ragblob" Visible='<%# Eval("RiskRating") = 3%>'>High</asp:Label>
                                                                    <asp:HiddenField EnableViewState="false" ID="HiddenField2" runat="server" Value='<%# Bind("RiskRating")%>' />
                                                                </EditItemTemplate>
                                                            </dx:BootstrapGridViewTextColumn>
                                                            <dx:BootstrapGridViewTextColumn FieldName="ActionType" Visible="false" Name="ActionTypeEx" VisibleIndex="5">
                                                            </dx:BootstrapGridViewTextColumn>
                                                            <dx:BootstrapGridViewTextColumn FieldName="Actions" Caption="Actions" Visible="false" Name="ActionsEx" VisibleIndex="6">
                                                            </dx:BootstrapGridViewTextColumn>
                                                            <dx:BootstrapGridViewTextColumn Caption="Actions" FieldName="ActionType" Name="Actions" VisibleIndex="7">
                                                                <DataItemTemplate>
                                                                    <asp:DropDownList ID="ddActionTypeEdit" runat="server" AppendDataBoundItems="true" CssClass="form-control" DataSourceID="dsActionTypes" DataTextField="RiskActionType" DataValueField="RiskActionTypeID" Enabled="false" EnableViewState="false" SelectedValue='<%# Bind("ActionTypeID")%>' Width="200px">
                                                                        <asp:ListItem Text="Not yet specified." Value="0"></asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    <br />
                                                                    <asp:Label ID="Label4" runat="server" EnableViewState="false" Text='<%# Bind("Actions") %>'></asp:Label>
                                                                </DataItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:DropDownList EnableViewState="false" ID="ddActionTypeEdit" AppendDataBoundItems="true" CssClass="form-control" runat="server" DataSourceID="dsActionTypes" DataTextField="RiskActionType" DataValueField="RiskActionTypeID" SelectedValue='<%# Bind("ActionTypeID")%>'>
                                                                        <asp:ListItem Text="Type. Please select" Selected="True" Value="0"></asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    <br />
                                                                    <asp:TextBox EnableViewState="false" ID="TextBox3" TextMode="MultiLine" Rows="4" MaxLength="500" CssClass="form-control" runat="server" Text='<%# Bind("Actions") %>'></asp:TextBox>

                                                                </EditItemTemplate>
                                                            </dx:BootstrapGridViewTextColumn>
                                                            <dx:BootstrapGridViewTextColumn Caption="Final Rating" FieldName="FinalRiskRating" VisibleIndex="8">
                                                                <DataItemTemplate>
                                                                    <asp:Label ID="Label6" runat="server" CssClass="label label-default ragblob" EnableViewState="false" Visible='<%# Eval("FinalRiskRating") = 0%>' Width="90%">Not set</asp:Label>
                                                                    <asp:Label ID="lblLowFinal" runat="server" CssClass="label label-success ragblob" EnableViewState="false" Visible='<%# Eval("FinalRiskRating") = 1%>' Width="90%">Low</asp:Label>
                                                                    <asp:Label ID="lblSignificantFinal" runat="server" CssClass="label label-warning ragblob" EnableViewState="false" Visible='<%# Eval("FinalRiskRating") = 2%>' Width="90%">Significant</asp:Label>
                                                                    <asp:Label ID="lblHighFinal" runat="server" CssClass="label label-danger ragblob" EnableViewState="false" Visible='<%# Eval("FinalRiskRating") = 3%>' Width="90%">High</asp:Label>
                                                                </DataItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:DropDownList EnableViewState="false" CssClass="form-control" ID="ddFinalRiskRatingEdit" SelectedValue='<%# Bind("FinalRiskRating")%>' runat="server">
                                                                        <asp:ListItem Text="Not set" Value="0"></asp:ListItem>
                                                                        <asp:ListItem Text="Low" Value="1"></asp:ListItem>
                                                                        <asp:ListItem Text="Significant" Value="2"></asp:ListItem>
                                                                        <asp:ListItem Text="High" Value="3"></asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </EditItemTemplate>
                                                            </dx:BootstrapGridViewTextColumn>
                                                            <dx:BootstrapGridViewCommandColumn Caption="Tools" ButtonRenderMode="Button" ShowInCustomizationDialog="false" Name="Tools" ShowDeleteButton="True" ShowEditButton="True" VisibleIndex="9">
                                                            </dx:BootstrapGridViewCommandColumn>
                                                            <dx:BootstrapGridViewTextColumn Caption="Initial Rating" FieldName="RiskRatingText" Name="RiskRatingText" Visible="False" VisibleIndex="4">
                                                            </dx:BootstrapGridViewTextColumn>
                                                            <dx:BootstrapGridViewTextColumn FieldName="FinalRiskRatingText" Caption="Final Risk Rating" Visible="False" VisibleIndex="8">
                                                            </dx:BootstrapGridViewTextColumn>
                                                        </Columns>
                                                        <SettingsText ConfirmDelete="Are you sure you want delete this risk?" />
                                                        <SettingsCommandButton>
                                                            <EditButton CssClass="btn-primary btn-sm" IconCssClass="icon-pencil" Text=" " />
                                                            <DeleteButton CssClass="btn-danger btn-sm" IconCssClass="icon-remove" Text=" " />
                                                            <UpdateButton CssClass="pull-right btn-success btn-sm" IconCssClass="icon-checkmark" />
                                                            <CancelButton CssClass="pull-left btn-danger btn-sm" IconCssClass="icon-cross" />
                                                        </SettingsCommandButton>

                                                        <Toolbars>
                                                            <dx:BootstrapGridViewToolbar>
                                                                <Items>
                                                                    <dx:BootstrapGridViewToolbarItem Command="ClearFilter" IconCssClass="glyphicon glyphicon-remove" Text="Clear filters" />
                                                                    <dx:BootstrapGridViewToolbarItem Command="Custom" Name="Export" CssClass="btn btn-success" Text="Export to Excel" IconCssClass="icon-file-excel" ToolTip="Export grid to Excel" />
                                                                </Items>
                                                            </dx:BootstrapGridViewToolbar>
                                                        </Toolbars>
                                                        <SettingsCustomizationDialog Enabled="True" />
                                                    </dx:BootstrapGridView>

                                                </div>
                                            </div>
                                        </div>
                                        <div class="panel-footer clearfix">
                                            <asp:LinkButton ID="lbtAddRisk" CausesValidation="false" CssClass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-plus"></i> Add Risk</asp:LinkButton>
                                        </div>
                                    </asp:View>
                                    <asp:View ID="vAddRisk" runat="server">
                                        <asp:FormView RenderOuterTable="False" ID="fvAddRisk" runat="server" DefaultMode="Insert" DataKeyNames="RiskID" DataSourceID="dsRisks">
                                            <InsertItemTemplate>
                                                <div class="panel-body">
                                                    <h3>Add Risk</h3>
                                                    <div class="form-group">
                                                        <asp:Label ID="lblRiskDesc" CssClass="control-label col-xs-3" runat="server" Text="Risk Description:" AssociatedControlID="RiskDescriptionTextBox"></asp:Label>
                                                        <div class="col-xs-9">
                                                            <asp:TextBox ID="RiskDescriptionTextBox" TextMode="MultiLine" CssClass="form-control" runat="server" Text='<%# Bind("RiskDescription") %>' MaxLength="1000" />
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <asp:Label ID="lblControls" CssClass="control-label col-xs-3" runat="server" Text="Controls:" AssociatedControlID="ControlsTextBox"></asp:Label>
                                                        <div class="col-xs-9">
                                                            <asp:TextBox ID="ControlsTextBox" TextMode="MultiLine" MaxLength="1000" CssClass="form-control" runat="server" Text='<%# Bind("Controls") %>' />
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <asp:Label ID="lblRating" CssClass="control-label col-xs-3" runat="server" Text="Rating:" AssociatedControlID="ddAutoGenerateLevelAdd"></asp:Label>
                                                        <div class="col-xs-9">
                                                            <asp:DropDownList CssClass="form-control" ID="ddAutoGenerateLevelAdd" SelectedValue='<%# Bind("RiskRating") %>' runat="server">
                                                                <asp:ListItem Text="Low" Value="1"></asp:ListItem>
                                                                <asp:ListItem Text="Significant" Value="2"></asp:ListItem>
                                                                <asp:ListItem Text="High" Value="3"></asp:ListItem>

                                                            </asp:DropDownList>

                                                        </div>
                                                    </div>
                                                    <div class="form-group">

                                                        <asp:Label ID="lblActionType" CssClass="control-label col-xs-3" AssociatedControlID="ddActionType" runat="server" Text="Action Type:"></asp:Label>
                                                        <div class="col-xs-9">
                                                            <asp:DropDownList ID="ddActionType" AppendDataBoundItems="true" CssClass="form-control" runat="server" DataSourceID="dsActionTypes" DataTextField="RiskActionType" DataValueField="RiskActionTypeID" SelectedValue='<%# Bind("ActionTypeID")%>'>
                                                                <asp:ListItem Text="Please select" Selected="True" Value="0"></asp:ListItem>
                                                            </asp:DropDownList>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <asp:Label ID="lblActionsAdd" CssClass="control-label col-xs-3" runat="server" Text="Actions:" AssociatedControlID="ActionsTextBox"></asp:Label>
                                                        <div class="col-xs-9">
                                                            <asp:TextBox ID="ActionsTextBox" CssClass="form-control" MaxLength="1000" TextMode="MultiLine" runat="server" Text='<%# Bind("Actions") %>' />
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <asp:Label ID="lblFinalRiskRating" CssClass="control-label col-xs-3" AssociatedControlID="ddFinalRiskRating" runat="server" Text="Final Risk Rating:"></asp:Label>
                                                        <div class="col-xs-9">
                                                            <asp:DropDownList CssClass="form-control" ID="ddFinalRiskRating" SelectedValue='<%# Bind("FinalRiskRating")%>' runat="server">
                                                                <asp:ListItem Text="Low" Value="1"></asp:ListItem>
                                                                <asp:ListItem Text="Significant" Value="2"></asp:ListItem>
                                                                <asp:ListItem Text="High" Value="3"></asp:ListItem>

                                                            </asp:DropDownList>

                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="panel-footer clearfix">
                                                    <asp:LinkButton ID="InsertButton" CssClass="btn btn-primary pull-right" ValidationGroup="vgAddRisk" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" />
                                                    &nbsp;<asp:LinkButton ID="InsertCancelButton" CssClass="btn btn-default pull-left" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                                                </div>
                                            </InsertItemTemplate>
                                        </asp:FormView>
                                    </asp:View>
                                </asp:MultiView>
                            </div>
                        </asp:View>

                        <asp:View ID="vDocuments" runat="server">
                            <h2>Additional Documents</h2>
                            <div class="panel panel-default">
                                <asp:ObjectDataSource ID="dsFlowDocsFiles" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_FilesByGroupTableAdapter">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="hfFlowDocsFileGroupID" DefaultValue="-1" Name="FileGroupID" Type="Int32" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>

                                <table class="table table-striped">
                                    <asp:Repeater ID="rptFlowDocsFiles" runat="server" DataSourceID="dsFlowDocsFiles">
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
                                                <td style="width: 20px">
                                                    <asp:LinkButton ID="lbtDeleteFlowDocs" Visible='<%# Eval("OrganisationID") = Session("UserOrganisationID") Or Session("IsSuperAdmin")%>' OnClientClick="return confirm('Are you sure you want delete this file?');" runat="server" CommandName="Delete" CommandArgument='<%# Eval("FileID")%>' CssClass="btn btn-danger btn-xs" ToolTip="Delete File" CausesValidation="false"><i aria-hidden="true" class="icon-minus"></i><!--[if lt IE 8]>Delete<![endif]--></asp:LinkButton></td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate></div></FooterTemplate>
                                    </asp:Repeater>
                                </table>
                            </div>
                            <asp:Panel ID="pnlFreeLicenceMessage2" Visible="false" runat="server" CssClass="alert alert-danger alert-dismissible" role="alert">
                                <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                                <asp:Label ID="Label16" runat="server" Text="Label">You are accessing the DPIA under a "free" licence, as such you are unable to upload documents to a data flow. To discuss licencing options for your organisation please contact <a href='mailto:isg@mbhci.nhs.uk'>isg@mbhci.nhs.uk</a>.</asp:Label>

                            </asp:Panel>
                            <asp:Panel ID="pnlFileUpload" CssClass="input-group" runat="server">
                                <span class="input-group-btn">
                                    <span class="btn btn-default btn-file">Browse&hellip;
                                                <asp:FileUpload AllowMultiple="true" ID="filFlowDocs" runat="server" />
                                    </span>
                                </span>
                                <input type="text" placeholder="Optional (max 5 MB)" class="form-control" >
                                <span class="input-group-btn">
                                    <asp:LinkButton ID="lbtUploadFlowDocs" CausesValidation="false" CssClass="btn btn-default pull-right" runat="server"><i aria-hidden="true" class="icon-upload2"></i>  Upload</asp:LinkButton>
                                </span>
                            </asp:Panel>
                        </asp:View>
                        <asp:View ID="vContacts" runat="server">

                            <h2>Contacts</h2>
                            <asp:ObjectDataSource ID="dsDFContacts" runat="server" DeleteMethod="Delete" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_DataFlowContactsTableAdapter" UpdateMethod="Update">
                                <DeleteParameters>
                                    <asp:Parameter Name="Original_DataFlowContactID" Type="Int32" />
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfDADataFlowContact" Name="DFContactGroupID" Type="Int32" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="DataFlowContactGroupID" Type="Int32" />
                                    <asp:Parameter Name="ContactName" Type="String" />
                                    <asp:Parameter Name="ContactEmail" Type="String" />
                                    <asp:Parameter Name="Role" Type="String" />
                                    <asp:Parameter Name="IsIAO" Type="Boolean" />
                                    <asp:Parameter Name="PhoneNumber" Type="String" />
                                    <asp:Parameter Name="Original_DataFlowContactID" Type="Int32" />
                                </UpdateParameters>
                            </asp:ObjectDataSource>
                            <div class="panel panel-default">

                                <asp:GridView CssClass="table table-striped" HeaderStyle-CssClass="sorted-none" GridLines="None" EmptyDataText="No contacts have been added for this data flow. Click Add, below, to add some." ID="gvDataFlowContacts" runat="server" AllowSorting="True" AutoGenerateColumns="False" DataSourceID="dsDFContacts" DataKeyNames="DataFlowContactID">
                                    <Columns>
                                        <asp:TemplateField ShowHeader="False">
                                            <EditItemTemplate>
                                                <asp:LinkButton ID="lbtUpdate" runat="server" CssClass="btn btn-default btn-xs" CausesValidation="True" CommandName="Update" ToolTip="Update"><i aria-hidden="true" class="icon-checkmark"></i></asp:LinkButton>
                                                &nbsp;<asp:LinkButton ID="lbtCancel" runat="server" CssClass="btn btn-default btn-xs" CausesValidation="False" CommandName="Cancel" ToolTip="Cancel"><i aria-hidden="true" class="icon-close"></i></asp:LinkButton>
                                                <%--<asp:HiddenField ID="hfAssetContactID" runat="server" Value='<%# Bind("DataAssetContactID") %>' />--%>
                                                <asp:HiddenField ID="hfDataAssetContactGroupID" runat="server" Value='<%# Bind("DataFlowContactGroupID")%>' />
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtEdit" CssClass="btn btn-default btn-xs" runat="server" CausesValidation="False" CommandName="Edit"><i aria-hidden="true" class="icon-pencil"></i><!--[if lt IE 8]>Edit<![endif]--></asp:LinkButton>

                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ContactName" ControlStyle-CssClass="form-control" HeaderText="Name" SortExpression="ContactName">
                                            <ControlStyle CssClass="form-control" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Email" SortExpression="ContactEmail">
                                            <EditItemTemplate>
                                                <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Bind("IsIAO") %>' />
                                                <asp:TextBox ID="tbEmailEdit" CssClass="form-control" runat="server" Text='<%# Bind("ContactEmail") %>'></asp:TextBox>
                                                <asp:RequiredFieldValidator ValidationGroup="vgAddContact" ID="rfvEmail" Display="Dynamic" runat="server" ControlToValidate="tbEmailEdit" CssClass="bg-danger" ErrorMessage="The user name field is required." ToolTip="The user name field is required." Text="*" SetFocusOnError="true" />
                                                <asp:RegularExpressionValidator runat="server" ValidationGroup="vgAddContact" ID="revEmail" Display="Dynamic" CssClass="bg-danger" SetFocusOnError="true"
                                                    ControlToValidate="tbEmailEdit" ValidationExpression="(?:[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*|'(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*')@(?:(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"
                                                    ErrorMessage="A valid email address must be provided." ToolTip="A valid email address must be provided." Text="*" />
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <a id="A1" runat="server" href='<%# "Mailto:" + Eval("ContactEmail")%>'>
                                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("ContactEmail") %>'></asp:Label></a>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="PhoneNumber" HeaderText="PhoneNumber" SortExpression="PhoneNumber" />
                                        <asp:BoundField DataField="Role" ControlStyle-CssClass="form-control" HeaderText="Role" SortExpression="Role">
                                            <ControlStyle CssClass="form-control" />
                                        </asp:BoundField>

                                        <asp:TemplateField ShowHeader="False">

                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtDelete" runat="server" CausesValidation="False" CssClass="btn btn-danger btn-xs" CommandName="Delete" Text="Delete"><i aria-hidden="true" class="icon-minus"></i></asp:LinkButton>
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                            </EditItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <HeaderStyle CssClass="sorted-none" />
                                </asp:GridView>
                                <div class="panel-footer clearfix">
                                    <asp:LinkButton ValidationGroup="vgAddContact" CausesValidation="false" ID="lbtContactAdd" min-width="25%" CssClass="btn btn-default pull-right" runat="server"><i aria-hidden="true" class="icon-user-add"></i> <b>Add contact</b> </asp:LinkButton>
                                </div>
                            </div>
                        </asp:View>
                        <asp:View ID="vSignOff" runat="server">
                            <asp:HiddenField ID="hfInDraft" runat="server" />
                            <asp:MultiView ID="mvSignOff" runat="server">
                                <asp:View ID="vSignOffInner" runat="server">
                                    <asp:ObjectDataSource ID="dsOrgSigStatus" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataBySP" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.OrgsSignOffStateTableAdapter">

                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfFlowDetailID" DefaultValue="0" Name="DataFlowDetailID" Type="Int32" />
                                        </SelectParameters>

                                    </asp:ObjectDataSource>

                                    <h2>Sign-off</h2>
                                    <hr />
                                    <asp:Panel ID="pnlSignOff" Visible="false" CssClass="panel panel-primary" runat="server">
                                        <div class="panel-heading">
                                            <h4>You have Outstanding Sign-off Requests for this Data Flow</h4>
                                        </div>

                                        <asp:ObjectDataSource ID="dsMyRequests" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.MySignOffRequestsTableAdapter">
                                            <SelectParameters>
                                                <asp:SessionParameter Name="OrgUserEmail" SessionField="UserEmail" Type="String" />
                                                <asp:ControlParameter ControlID="hfFlowDetailID" DefaultValue="0" Name="DataFlowID" Type="Int32" />
                                            </SelectParameters>
                                        </asp:ObjectDataSource>
                                        <asp:GridView ID="gvMyRequests" runat="server" CssClass="table table-striped small" HeaderStyle-CssClass="sorted-none" GridLines="None" AutoGenerateColumns="False" DataKeyNames="SignOffRequestID" DataSourceID="dsMyRequests">
                                            <Columns>
                                                <asp:BoundField DataField="OrganisationName" HeaderText="Organisation" SortExpression="OrganisationName" />
                                                <asp:TemplateField HeaderText="Role" SortExpression="Role">

                                                    <ItemTemplate>
                                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("Role")%>'></asp:Label><asp:Label ToolTip="This role has been delegated to you" Visible='<%# Session("UserEmail") = Eval("DelegateRoleTo").ToString()%>' ID="Label8" runat="server"> <i aria-hidden="true" class="icon-point-down"></i></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="RequestedDate" HeaderText="Requested" SortExpression="RequestedDate" DataFormatString="{0:d}" />
                                                <asp:TemplateField HeaderText="By" SortExpression="RequestedBy">

                                                    <ItemTemplate>
                                                        <a href='<%# "mailto:" & Eval("RequestedBy")%>' runat="server">
                                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("RequestedBy")%>'></asp:Label></a>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="SignByDate" HeaderText="Sign By" SortExpression="SignByDate" DataFormatString="{0:d}" />

                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lbtReviewAndSign" CausesValidation="false" CommandName="Review" CommandArgument='<%# Eval("OrganisationUserID")%>' CssClass="btn btn-primary btn-sm" runat="server">Review and Sign</asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                            <HeaderStyle CssClass="sorted-none" />
                                        </asp:GridView>

                                    </asp:Panel>
                                    <asp:Panel ID="pnlAllSigned" Visible="false" CssClass="panel panel-default" runat="server">
                                        <div class="panel-heading">
                                            <h4>You have no Outstanding Sign-off Requests</h4>
                                        </div>
                                        <div class="panel-body">
                                            <p>
                                                You have no outstanding sign-off requests for this data flow.                              
                                            </p>
                                            <p>This is either because you have already signed the data flow off or somebody else from your organisation has signed it off for you.</p>

                                        </div>
                                    </asp:Panel>
                                    <h3>Sign off Status by Organisation</h3>
                                    <div class="row">
                                        <div class="container">
                                            <div style="margin-left: 15px; margin-right: 15px;">
                                                <div class="row">
                                                    <div class="col-sm-7">
                                                        <b>Organisation</b>
                                                    </div>
                                                    <div class="col-xs-2"><b>Requested</b></div>
                                                    <div class="col-xs-1"><b>Signed</b></div>
                                                    <div class="col-xs-1"><b>Rejected</b></div>
                                                    <div class="col-xs-1"><b>Withdrawn</b></div>
                                                </div>
                                            </div>
                                            <hr />
                                            <asp:LinkButton ID="LinkButton1" CssClass="btn btn-default btn-sm" OnClientClick="$('#signoffview .collapse').collapse('toggle');return false;" runat="server">Expand / collapse all</asp:LinkButton>
                                            <asp:Repeater ID="rptSignOffByOrg" runat="server" DataSourceID="dsOrgSigStatus">
                                                <ItemTemplate>
                                                    <asp:ObjectDataSource ID="dsUserSignOffStatus" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetBySP" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.OrgUserSignOffTableAdapter">
                                                        <SelectParameters>
                                                            <asp:Parameter DefaultValue="0" Name="DFD_DFDOrganisationID" Type="Int32" />
                                                        </SelectParameters>
                                                    </asp:ObjectDataSource>
                                                    <asp:HiddenField ID="hfDFD_DFDOrganisationID" runat="server" Value='<%# Eval("DFD_DFDOrganisationID")%>' />
                                                    <div id="signoffview" class="panel <%# Eval("StatusCSSClass")%> panel-nomargin">
                                                        <div runat="server" title="Click to view requests / signatures" visible='<%# Eval("Signed").ToString.Length > 0 Or Eval("Requested").ToString.Length > 0 Or Eval("Refused").ToString.Length > 0 Or Eval("Withdrawn").ToString.Length > 0%>' class="panel-heading clickable" data-toggle="collapse" data-target='<%# "#accordion" & Eval("DFD_DFDOrganisationID").ToString()%>'>
                                                            <div class="row">
                                                                <div class="col-sm-7">
                                                                    <span class="glyphicon glyphicon-plus"></span>&nbsp;&nbsp;
                                                                    <asp:Label ID="lblOrg" ToolTip='<%# "DPIA OrgID: " & Eval("OrganisationID") & ", ICO: " & Eval("ICONumber")%>' runat="server" Text='<%# Eval("OrganisationName") & IIf(Eval("Signed").ToString.Length = 0 And Eval("Refused").ToString.Length = 0 And Eval("Refused").ToString.Length = 0, "(" & Eval("AvailableSignatories") & "<span class=""hidden-sm hidden-xs""> available signatories</span>)", "")%>'></asp:Label>
                                                                </div>
                                                                <div class="col-sm-2">
                                                                    <asp:Label ID="lblRequested" runat="server" ToolTip="Requested Date" Text='<%# Eval("Requested", "{0:dd/M/yyyy}")%>'></asp:Label>
                                                                </div>
                                                                <div class="col-sm-1">
                                                                    <asp:Label ID="lblSigned" runat="server" ToolTip="Signed Date" Text='<%# Eval("Signed", "{0:dd/M/yyyy}")%>'></asp:Label>
                                                                </div>
                                                                <div class="col-sm-1">
                                                                    <asp:Label ID="lblRejected" runat="server" ToolTip="Refused Date" Text='<%# Eval("Refused", "{0:dd/M/yyyy}")%>'></asp:Label>
                                                                </div>
                                                                <div class="col-sm-1">
                                                                    <asp:Label ID="lblWithdrawn" runat="server" ToolTip="Withdrawn Date" Text='<%# Eval("Withdrawn", "{0:dd/M/yyyy}")%>'></asp:Label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div id="Div1" runat="server" visible='<%# Eval("Signed").ToString.Length = 0 And Eval("Requested").ToString.Length = 0 And Eval("Refused").ToString.Length = 0 And Eval("Withdrawn").ToString.Length = 0%>' class="panel-heading">
                                                            <div class="row">
                                                                <div class="col-sm-12">
                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    <asp:Label ID="Label11" runat="server" CssClass="text-muted" Text='<%# Eval("OrganisationName") & " (" & Eval("AvailableSignatories") & "<span class=""hidden-sm hidden-xs""> available signatories</span>)"%>'></asp:Label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <asp:Panel ID="Panel1" runat="server" Visible='<%# Eval("AvailableSignatories") > 0 Or Eval("Signed").ToString.Length > 0%>'>
                                                            <div class="collapse" id='<%# "accordion" & Eval("DFD_DFDOrganisationID").ToString()%>'>
                                                                <div class="panel-body">
                                                                    <asp:Repeater ID="rptSignatories" runat="server" OnItemCommand="rptSignatoriesItemCommand">
                                                                        <ItemTemplate>
                                                                            <div class="row">
                                                                                <div class="col-sm-7">
                                                                                    <asp:Label ID="lblUser" runat="server" Text='<%# Eval("OrgUser")%>'></asp:Label>
                                                                                    <a id="A2" runat="server" visible='<%# Eval("SignOffComments").ToString.Length > 0%>' tabindex="0" title="Signatory Comments" class="btn" role="button" data-html="true" data-toggle="popover" data-container="body" data-trigger="focus" data-placement="auto" data-content='<%# Eval("SignOffComments")%>'><i aria-hidden="true" class="icon-bubbles"></i></a>
                                                                                    <a id="A3" runat="server" visible='<%# Not Eval("Active")%>' tabindex="0" title="User Inactive" class="btn" role="button" data-html="true" data-toggle="popover" data-container="body" data-trigger="focus" data-placement="auto" data-content='This user has been inactivated since signing off this data flow.'><i aria-hidden="true" class="icon-notification"></i></a>
                                                                                </div>
                                                                                <div class="col-sm-2">
                                                                                    <div class="row">
                                                                                        <div class="col-sm-6">
<asp:Label ID="lblRequested" runat="server" ToolTip='<%# "Requested by " & Eval("RequestedBy")%>' Text='<%# Eval("RequestedDate", "{0:dd/M/yyyy}") & IIf(Eval("LastReminderSent").ToString.Length > 0, "<br/><span class=""text-muted small"">Reminder: " & Eval("LastReminderSent", "{0:dd/M/yyyy}") & "</span>", "") %>'></asp:Label>
                                                                                        </div>
                                                                                        <div class="col-sm-6">
                                                                                             <asp:LinkButton ID="lbtReminder" Visible='<%# Eval("RequestedDate").ToString.Length > 0 And Eval("SignedDate").ToString.Length = 0 And Eval("RefusedDate").ToString.Length = 0 And Eval("WithdrawnDate").ToString.Length = 0%>' ToolTip="Send reminder" CssClass="btn btn-info btn-sm" CausesValidation="false" CommandName="SendReminder" CommandArgument='<%# Eval("OrganisationUserID")%>' runat="server"><i aria-hidden="true" class="glyphicon glyphicon-envelope"></i></asp:LinkButton>
                                                                                        </div>
                                                                                    </div>
                                                                                   
                                                                                </div>
                                                                                <div class="col-sm-1">
                                                                                    <asp:Label ID="lblSigned" runat="server" Text='<%# Eval("SignedDate", "{0:dd/M/yyyy}")%>'></asp:Label>
                                                                                </div>
                                                                                <div class="col-sm-1">
                                                                                    <asp:Label ID="lblRejected" runat="server" Text='<%# Eval("RefusedDate", "{0:dd/M/yyyy}")%>'></asp:Label>
                                                                                </div>
                                                                                <div class="col-sm-1">
                                                                                    <asp:Label ID="lblWithdrawn" runat="server" Text='<%# Eval("WithdrawnDate", "{0:dd/M/yyyy}")%>'></asp:Label>
                                                                                    <%--<asp:LinkButton ID="lbtWithdraw" CausesValidation="false" CommandName="withdraw" CommandArgument='<%# Eval("DataFlowSignatureID")%>' CssClass="btn btn-danger btn-sm" Visible='<%# Eval("WithdrawnDate").ToString.Length = 0 And Eval("SignedDate").ToString.Length > 0 And Eval("RefusedDate").ToString.Length = 0 And Session("IsSuperAdmin")%>' runat="server">Withdraw</asp:LinkButton>--%>
                                                                                
                                                                                    <asp:LinkButton ID="lbtWithdraw" CausesValidation="false" CommandName="withdraw" CommandArgument='<%# Eval("DataFlowSignatureID") & "|" & Eval("OrganisationUserID")%>' CssClass="btn btn-danger btn-sm" Visible='<%# Eval("WithdrawnDate").ToString.Length = 0 And Eval("SignedDate").ToString.Length > 0 And Eval("RefusedDate").ToString.Length = 0 And Session("IsSuperAdmin")%>' runat="server">Withdraw</asp:LinkButton>
                                                                                
                                                                                </div>
                                                                            </div>
                                                                        </ItemTemplate>
                                                                        <SeparatorTemplate>
                                                                            <hr />
                                                                        </SeparatorTemplate>
                                                                    </asp:Repeater>
                                                                </div>
                                                            </div>
                                                        </asp:Panel>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                            <script>$('.collapse').on('shown.bs.collapse', function () {
                                                    $(this).parent().parent().find(".glyphicon-plus").removeClass("glyphicon-plus").addClass("glyphicon-minus");
                                                }).on('hidden.bs.collapse', function () {
                                                    $(this).parent().parent().find(".glyphicon-minus").removeClass("glyphicon-minus").addClass("glyphicon-plus");
                                                });</script>
                                        </div>
                                    </div>
                                    <div id="divSignOffCommands" class="row" style="margin-top: 20px;">
                                        <asp:LinkButton ID="lbtExportToExcel" ToolTip="Export sign off details to Excel" CausesValidation="false" CssClass="btn btn-default pull-left" runat="server"><i aria-hidden="true" class="icon-file-excel"></i> Export to Excel</asp:LinkButton>
                                        <asp:LinkButton ID="lbtRequestSignOff" CssClass="btn btn-primary pull-right" CausesValidation="false" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-flag"></i> Request Sign Off</asp:LinkButton>
                                    </div>
                                </asp:View>
                                <asp:View ID="vSaveFirstSO" runat="server">
                                    <div class="panel-body">
                                        <p class="alert alert-danger clearfix">Before requesting sign off, this data flow must be saved. Once saved, return here to request sign off.</p>
                                    </div>
                                </asp:View>

                                <asp:View ID="vInDraftFinalise" runat="server">

                                    <div class="panel-body">
                                        <h3>This data flow is in draft</h3>
                                        <p>Sign off and requests for sign off are unavailable until it is finalised.</p>
                                        <asp:Panel ID="pnlFinalise" runat="server">
                                            <asp:Panel ID="pnlFinaliseDPOMessage" CssClass="alert alert-info" runat="server">
                                                <asp:Label ID="lblFinaliseDPOMessage" runat="server" Text=""></asp:Label>
                                            </asp:Panel>
                                            <p class="clearfix">To finalise this data flow, click <b>Finalise</b>.</p>
                                            <asp:LinkButton ID="btnFinalise" CssClass="btn btn-primary" CausesValidation="false" runat="server"><i aria-hidden="true" class="icon-checkmark"></i> Finalise</asp:LinkButton>

                                        </asp:Panel>
                                        <asp:Panel ID="pnlCannotFinalise" Visible="false" runat="server">
                                            <p class="alert alert-warning clearfix">
                                                <asp:Label ID="lblCannotFinaliseReason" runat="server" Text="Label"></asp:Label></p>
                                        </asp:Panel>
                                    </div>
                                </asp:View>
                            </asp:MultiView>
                        </asp:View>
                        <asp:View ID="vDPOReview" runat="server">
                            <asp:ObjectDataSource ID="dsDPOReviews" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetByDFDID" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_DPOReviewsTableAdapter" DeleteMethod="Delete" InsertMethod="Insert" UpdateMethod="Update">
                                <DeleteParameters>
                                    <asp:Parameter Name="Original_DPOReviewID" Type="Int32" />
                                </DeleteParameters>
                                <InsertParameters>
                                    <asp:Parameter Name="DataFlowDetailID" Type="Int32" />
                                    <asp:Parameter Name="RequestUserEmail" Type="String" />
                                    <asp:Parameter Name="RequestedDTT" Type="DateTime" />
                                    <asp:Parameter Name="DPOOrganisationUserID" Type="Int32" />
                                    <asp:Parameter Name="DPOEmail" Type="String" />
                                    <asp:Parameter Name="DPOOrganisationID" Type="Int32" />
                                    <asp:Parameter Name="ReviewedDTT" Type="DateTime" />
                                    <asp:Parameter Name="Approved" Type="Boolean" />
                                    <asp:Parameter Name="DFComments" Type="String" />
                                    <asp:Parameter Name="DPIAComments" Type="String" />
                                    <asp:Parameter Name="RAComments" Type="String" />
                                    <asp:Parameter Name="ArchivedDTT" Type="DateTime" />
                                    <asp:Parameter Name="ReviewByDTT" Type="DateTime" />
                                </InsertParameters>
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="hfFlowDetailID" DefaultValue="0" Name="DFDID" PropertyName="Value" Type="Int32" />
                                    <asp:ControlParameter ControlID="cbIncludeArchived" DefaultValue="" Name="IncludeArchived" PropertyName="Checked" Type="Boolean" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="DataFlowDetailID" Type="Int32" />
                                    <asp:Parameter Name="RequestUserEmail" Type="String" />
                                    <asp:Parameter Name="RequestedDTT" Type="DateTime" />
                                    <asp:Parameter Name="DPOOrganisationUserID" Type="Int32" />
                                    <asp:Parameter Name="DPOEmail" Type="String" />
                                    <asp:Parameter Name="DPOOrganisationID" Type="Int32" />
                                    <asp:Parameter Name="ReviewedDTT" Type="DateTime" />
                                    <asp:Parameter Name="Approved" Type="Boolean" />
                                    <asp:Parameter Name="DFComments" Type="String" />
                                    <asp:Parameter Name="DPIAComments" Type="String" />
                                    <asp:Parameter Name="RAComments" Type="String" />
                                    <asp:Parameter Name="ArchivedDTT" Type="DateTime" />
                                    <asp:Parameter Name="ReviewByDTT" Type="DateTime" />
                                    <asp:Parameter Name="Original_DPOReviewID" Type="Int32" />
                                </UpdateParameters>
                            </asp:ObjectDataSource>
                            <h3>DPO Review Requests and Responses</h3>
                            <div class="clearfix">
                                <h3>
                                    <asp:CheckBox ID="cbIncludeArchived" Checked="false" AutoPostBack="true" CssClass="pull-right no-bold-label small" Font-Bold="false" runat="server" Text=" Include Archived" />
                                </h3>
                            </div>
                            <div class="panel panel-default">
                            <div class="table-responsive">

                                <asp:GridView ID="gvDPOReview" GridLines="None" AllowSorting="True" EmptyDataText="No DPO review requests have been submitted, click Request DPO Review to add some." CssClass="table table-striped" runat="server" AutoGenerateColumns="False" DataKeyNames="DPOReviewID" DataSourceID="dsDPOReviews">
                                    <Columns>
                                        <asp:TemplateField HeaderText="DPO" SortExpression="DPOEmail">
                                            <ItemTemplate>
                                                <asp:HyperLink ID="HyperLink1" NavigateUrl='<%# "mailto:" & Eval("DPOEmail") %>' Text='<%# Eval("DPOEmail") %>' runat="server"></asp:HyperLink>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        
                                        <asp:BoundField DataField="Organisation" HeaderText="Organisation" />
                                        <asp:TemplateField HeaderText="Requested" SortExpression="RequestedDTT" >
                                            <ItemTemplate>
                                                <asp:Label ID="lblRequested" runat="server"  Text='<%# Eval("RequestedDTT", "{0:dd/M/yyyy}") & IIf(Eval("LastReminderSent").ToString.Length > 0, "<br/><span class=""text-muted small"">Reminder: " & Eval("LastReminderSent", "{0:dd/M/yyyy}") & "</span>", "")  %>'></asp:Label>
                                                <asp:LinkButton ID="lbtDPOReminder" Visible='<%# Eval("RequestedDTT").ToString.Length > 0 And Eval("ReviewedDTT").ToString.Length = 0 %>' ToolTip="Send reminder" CssClass="btn btn-info btn-sm" CausesValidation="false" CommandName="DPOSendReminder" CommandArgument='<%# Eval("DPOReviewID")%>' runat="server"><i aria-hidden="true" class="glyphicon glyphicon-envelope"></i></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:BoundField DataField="ReviewByDTT" HeaderText="Review By" SortExpression="ReviewByDTT" DataFormatString="{0:d}" /> 
                                        <asp:TemplateField HeaderText="Reviewed" SortExpression="ReviewedDTT">
                                            <ItemTemplate>
                                                <asp:Label ID="Label2" Visible='<%# Eval("ReviewedDTT").ToString.Length > 0 %>' runat="server" Text='<%# Eval("ReviewedDTT", "{0:d}") %>'></asp:Label>  <asp:LinkButton CssClass="btn btn-warning btn-sm" ID="LinkButton2" Visible='<%# Eval("ReviewedDTT").ToString.Length > 0 %>' CausesValidation="false" CommandName="ViewDPOComments" CommandArgument='<%# Eval("DPOReviewID") %>' runat="server"><i aria-hidden="true" class="icon-search"></i></asp:LinkButton>
                                                <asp:LinkButton CssClass="btn btn-info" ID="lbtReview" Visible='<%# Eval("ReviewedDTT").ToString.Length = 0 And Eval("ArchivedDTT").ToString.Length = 0 And Eval("DPOEmail").ToString.ToLower = Session("UserEmail").ToString.ToLower %>' CausesValidation="false" CommandName="DPOReview" CommandArgument='<%# Eval("DPOReviewID") %>' runat="server"><i aria-hidden="true" class="icon-search"></i> Review</asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Outcome" SortExpression="Approved">
                                            <ItemTemplate>
                                                <asp:HiddenField ID="hfArchived" Value='<%# Eval("ArchivedDTT").ToString.Length > 0 %>' runat="server" />
                                                <asp:Label ID="Label22" CssClass="label label-success" Visible='<%# Eval("Approved") %>' runat="server" Text="Approved"></asp:Label>
                                                <asp:Panel ID="Panel2" Visible='<%# Not Eval("Approved") And Eval("ReviewedDTT").ToString.Length > 0 %>'  runat="server">
                                                    <asp:Label ID="Label24" CssClass="label label-danger" runat="server" Text="Rejected"></asp:Label> 
                                                     <asp:LinkButton Visible='<%# Eval("ArchivedDTT").ToString.Length = 0 %>'  CssClass="btn btn-info btn-sm" CausesValidation="false" ID="lbtRequestReReview" CommandName="ReReview" ToolTip="Request Re-review" CommandArgument='<%# Eval("DPOOrganisationUserID") %>' runat="server"><i aria-hidden="true" class="glyphicon glyphicon-flag"></i></asp:LinkButton>
                                                </asp:Panel>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div></div>
                            <div id="divDPOCommands" class="row" style="margin-top: 20px;">
                                        
                                        <asp:LinkButton ID="lbtRequestDPOSignOff" CssClass="btn btn-primary pull-right" CausesValidation="false" runat="server"><i aria-hidden="true" class="glyphicon glyphicon-flag"></i> Request DPO Review</asp:LinkButton>
                                    </div>
                        </asp:View>
                    </asp:MultiView>
                    <hr />
                    <div class="row">
                        <asp:LinkButton ID="lbtUpdateDataFlow" ValidationGroup="vgDataFlowDetail" CssClass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-checkmark"></i> Update Data Flow / PIA</asp:LinkButton>
                        <asp:LinkButton ID="lbtSaveDataFlow" ValidationGroup="vgDataFlowDetail" CssClass="btn btn-primary pull-right" runat="server"><i aria-hidden="true" class="icon-checkmark"></i> Save Data Flow / PIA</asp:LinkButton>
                    </div>
                </div>
            </div>
            <div id="modalAddcontact" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <asp:Label ID="lblAddContactHeading" runat="server" Text="Add Data Flow Contact"></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-horizontal">
                                <div class="form-group">
                                    <asp:Label ID="lblContactName" CssClass="col-md-4 control-label" runat="server" Text="Contact name:" AssociatedControlID="tbContactName"></asp:Label>
                                    <div class="col-md-8">
                                        <asp:TextBox ID="tbContactName" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblContactEmail" CssClass="col-md-4 control-label" runat="server" Text="E-mail address:" AssociatedControlID="tbContactEmail"></asp:Label>
                                    <div class="col-md-8">
                                        <asp:TextBox ID="tbContactEmail" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                    <div class="col-md-1">
                                        <asp:RequiredFieldValidator ID="rfvEmailAdd" Display="Dynamic" SetFocusOnError="true" runat="server" ControlToValidate="tbContactEmail" CssClass="bg-danger" ErrorMessage="The user name field is required." ToolTip="The user name field is required." Text="*" />
                                        <asp:RegularExpressionValidator runat="server" ID="revEmailAdd" Display="Dynamic" CssClass="bg-danger" SetFocusOnError="true"
                                            ControlToValidate="tbContactEmail" ValidationExpression="(?:[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*|'(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*')@(?:(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"
                                            ErrorMessage="A valid email address must be provided." ToolTip="A valid email address must be provided." Text="*" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblPhoneNumber" CssClass="col-md-4 control-label" runat="server" Text="Phone number:" AssociatedControlID="tbPhoneNumber"></asp:Label>
                                    <div class="col-md-8">
                                        <asp:TextBox ID="tbPhoneNumber" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lblRole" CssClass="col-md-4 control-label" runat="server" Text="Role:" AssociatedControlID="tbRole"></asp:Label>
                                    <div class="col-md-8">
                                        <asp:TextBox ID="tbRole" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Cancel</button>
                            <asp:LinkButton CausesValidation="true" CssClass="btn btn-primary pull-right" ID="lbtAddConfirm" runat="server">Add</asp:LinkButton>

                        </div>
                    </div>
                </div>
            </div>
            <div id="modalMessage" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <asp:Label ID="lblModalHeading" runat="server"></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <p>
                                <asp:Label ID="lblModalText" runat="server"></asp:Label>
                            </p>

                        </div>
                        <div class="modal-footer">
                            <asp:LinkButton ID="lbtAddedReturn" CssClass="btn btn-default pull-left" runat="server" CausesValidation="False"><i aria-hidden="true" class="icon-list"></i> Return to List</asp:LinkButton>
                            <asp:LinkButton ID="lbtOKLoadForEdit" CssClass="btn btn-primary pull-right" runat="server" CausesValidation="False">OK</asp:LinkButton>
                            <button id="ModalOK" runat="server" type="button" class="btn btn-primary pull-right" data-dismiss="modal">OK</button>
                        </div>
                    </div>
                </div>
            </div>

            <div id="modalDeleteRAConfirm" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="Label2" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <asp:Label ID="Label2" runat="server">Are you sure you wish to delete this risk assessment?</asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure that you wish to delete this risk assessment and all of the risks it contains?</p>
                            <p>If you delete it, you will not be able to get it back but you will be able to generate a new one.</p>
                            <p>Once a data flow has been signed off, the risk assessment and its risks cannot be removed.</p>
                        </div>
                        <div class="modal-footer">
                            <asp:LinkButton ID="lbtConfirm" CssClass="btn btn-primary pull-right" runat="server" CausesValidation="False"><i aria-hidden="true" class="icon-checkmark"></i> Yes, Delete</asp:LinkButton>
                            <button id="Button1" runat="server" type="button" class="btn btn-default pull-left" data-dismiss="modal"><i aria-hidden="true" class="icon-close"></i>No</button>
                        </div>
                    </div>
                </div>
            </div>
            <div id="modalRequestSignOff" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="Label7" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <asp:Label ID="Label7" runat="server">Request Sign Off</asp:Label></h4>
                        </div>
                        <%-- <div class="modal-body">--%>
                        <asp:ObjectDataSource ID="dsSeniorRoles" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.ispdatasetTableAdapters.DataFlow_GetSeniorUsersTableAdapter">
                            <SelectParameters>
                                                <asp:ControlParameter ControlID="hfFlowDetailID" DefaultValue="0" Name="DataFlowDetailID" Type="Int32" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                        <asp:GridView ID="gvSelectSignees" CssClass="table table-striped" HeaderStyle-CssClass="sorted-none" GridLines="None" EmptyDataText="There are no active, confirmed users in a senior role at organisations involved in this data flow who have not already received a sign off request or whose organisation has not already signed off the data flow." runat="server" AutoGenerateColumns="False" DataKeyNames="OrganisationUserID" DataSourceID="dsSeniorRoles">
                            <Columns>
                                <asp:TemplateField HeaderText="Select">
                                    <HeaderTemplate>
                                        <asp:CheckBox ID="chkboxSelectAll" ToolTip="Select / deselect all" runat="server" onclick="CheckAllSignees(this);" />
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:CheckBox ID="cbSelectUser" runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="User" SortExpression="OrganisationUserName">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="hfOrgUserID" runat="server" Value='<%# Eval("OrganisationUserID")%>' />
                                        <asp:Label ID="lblUsername" runat="server" ToolTip='<%# Eval("OrganisationUserEmail")%>' Text='<%# Eval("OrganisationUserName")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField DataField="Role" HeaderText="Role" ReadOnly="True" SortExpression="Role" />
                                <%--<asp:BoundField DataField="DelegateRoleTo" HeaderText="Delegate" SortExpression="DelegateRoleTo" />--%>

                                <asp:BoundField DataField="Organisation" HeaderText="Organisation" SortExpression="Organisation" />
                                <asp:TemplateField HeaderText="Organisation" SortExpression="Organisation">
                                    <ItemTemplate>
                                        <asp:Label ID="lblOrganisation" runat="server" ToolTip='<%# Eval("Organisation")%>' Text='<%# Eval("Organisation") & " (" & Eval("OrgDFRole") & ")"%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>

                            <HeaderStyle CssClass="sorted-none"></HeaderStyle>
                        </asp:GridView>
                        <div class="clearfix">
                            <a class="btn btn-default pull-right" role="button" data-toggle="collapse" href="#optionalText" aria-expanded="false" aria-controls="optionalText">
                                <label id="lblOptions">More options</label>
                                &nbsp;<span class="glyphicon glyphicon-chevron-down"></span></a>
                        </div>
                        <div class="collapse" id="optionalText">
                            <div class="well">
                                <div class="form-group">
                                    <asp:TextBox ID="tbOptionalText" CssClass="form-control" placeholder="Optional additional e-mail text / sign off instructions" TextMode="MultiLine" Height="80px" runat="server"></asp:TextBox>
                                </div>
                                <div class="form-inline small" role="form">
                                    <div class="form-group">
                                        <asp:Label ID="Label13" CssClass="control-label" AssociatedControlID="tbSignByDate" runat="server" Text="Sign by date:"></asp:Label>
                                        <asp:TextBox ID="tbSignByDate" CssClass="form-control date-input" runat="server"></asp:TextBox>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="lblEnforce" CssClass="control-label" runat="server" Text="Enforce? " AssociatedControlID="cbEnforce">
                                            <asp:CheckBox ID="cbEnforce" ToolTip="Enforcing a sign by date will prevent the user from signing the data flow off after the date" runat="server" />
                                        </asp:Label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script>
                            $('.date-input').datepicker({ dateFormat: 'dd/mm/yy' });
                            $('#optionalText').on('shown.bs.collapse', function () {
                                $(this).parent().find(".glyphicon-chevron-down").removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-up");
                                $(this).parent().find("#lblOptions").text("Less options");
                            }).on('hidden.bs.collapse', function () {
                                $(this).parent().find(".glyphicon-chevron-up").removeClass("glyphicon-chevron-up").addClass("glyphicon-chevron-down");
                                $(this).parent().find("#lblOptions").text("More options");
                            });</script>
                        <p class='alert  alert-warning' role='alert'><strong>Note:</strong> Once signed off, the data flow will become read only.</p>

                        <%-- </div>--%>
                        <div class="modal-footer">
                            <button id="Button3" runat="server" type="button" class="btn btn-default pull-left" causesvalidation="False" data-dismiss="modal">Cancel</button>
                            <asp:LinkButton ID="lbtSubmitSignOffRequest" CssClass="btn btn-primary pull-right" runat="server" CausesValidation="False">OK</asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>
            <div id="modalSignOffDataFlow" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="Label5" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <asp:Label ID="Label5" runat="server">Sign Off Data Flow</asp:Label></h4>
                        </div>
                        <asp:HiddenField ID="hfSignatoryOrgUserID" runat="server" />
                        <div class="modal-body">
                            <p>
                                To the best of my knowledge, the details captured here accurately describe the data sharing practices and the controls in place to govern them.
                            </p>
                            <p>
                                <asp:Label ID="lblAgreeOrganisation" runat="server" Text="Label"></asp:Label>
                                and its staff will make every effort to ensure that the controls are monitored and maintained and data sharing will only happen as described herein.
                            </p>
                            <p>
                                Should we wish to deviate from the practices and controls described here, we will review this data flow to ensure that these changes are captured.
                            </p>

                            <p class="well">
                                Signatory:
                                <asp:Label ID="lblAgreeUserName" runat="server" Text="User Name"></asp:Label>, in my position of
                                        <asp:Label ID="lblAgreeRole" runat="server" Text="Role"></asp:Label>.
                                        <asp:Label ID="lblOnBehalfOf" runat="server" Text=""></asp:Label>
                            </p>
                            <asp:TextBox ID="tbSignOffComments" CssClass="form-control" placeholder="Comments..." TextMode="MultiLine" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="tbSignOffComments" Display="Dynamic" runat="server" ValidationGroup="RejectSO" ErrorMessage="Required if refusing sign-off"></asp:RequiredFieldValidator>
                        </div>
                        <div class="modal-footer">
                            <button id="lbtCancel" runat="server" type="button" class="btn btn-default pull-left" data-dismiss="modal"><i aria-hidden="true" class="icon-close"></i>Cancel</button>
                            <asp:LinkButton ID="lbtRejectSignOffConfirm" CssClass="btn btn-danger pull-left" ToolTip="Reject agreement and refuse sign-off please explain in comments" CausesValidation="true" ValidationGroup="RejectSO" runat="server"><i aria-hidden="true" class="icon-thumbs-up2"></i> Refuse Sign-off</asp:LinkButton>
                            <asp:LinkButton ID="lbtSignOffFlowConfirm" CssClass="btn btn-success pull-right" runat="server" CausesValidation="False"><i aria-hidden="true" class="icon-quill"></i> Sign</asp:LinkButton>

                        </div>
                    </div>
                </div>
            </div>
            <div id="modalWithdrawSignature" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="Label5" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <asp:Label ID="Label9" runat="server">Withdraw Signature</asp:Label></h4>
                        </div>
                        <asp:HiddenField ID="hfSignatureID" runat="server" />
                        <asp:HiddenField ID="hfOrganisationUserID" runat="server" />
                        <div class="modal-body">
                            <p>
                                You may only withdraw a data flow signature if you have the express permission of the user who signed the data flow or another Senior Officer from their organisation.
                            </p>
                            <p>
                                There is no need to withdraw a signature if an organisation closes or merges. Simply close or request closure of the organisation instead.
                            </p>

                            <p>
                                I confirm that I have received appropriate authorisation to withdraw this data flow signature.
                            </p>

                            <p class="well">
                                Signatory:
                                <asp:Label ID="lblWithdrawUser" runat="server" Text="User Name"></asp:Label>, in my position of
                                        DPIA Super Administrator.
                                        
                            </p>
                            <asp:TextBox ID="tbWithdrawComments" CssClass="form-control" placeholder="Comments..." TextMode="MultiLine" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="tbWithdrawComments" Display="Dynamic" runat="server" ValidationGroup="WithdrawSO" ErrorMessage="Required"></asp:RequiredFieldValidator>
                        </div>
                        <div class="modal-footer">
                            <button id="Button4" runat="server" type="button" class="btn btn-default pull-left" data-dismiss="modal"><i aria-hidden="true" class="icon-close"></i>Cancel Withdrawal</button>
                            <asp:LinkButton ID="lbtWithdrawConfirm" CssClass="btn btn-danger pull-right" ToolTip="Withdraw signature from data flow." CausesValidation="true" ValidationGroup="WithdrawSO" runat="server"><i aria-hidden="true" class="icon-minus"></i> Withdraw Sign-off</asp:LinkButton>


                        </div>
                    </div>
                </div>
            </div>
            <%-- <asp:Panel CssClass="col-xs-3" ID="myScrollNav" runat="server">
                <ul class="nav nav-pills nav-stacked affix greyborder" data-spy="affix" data-offset-top="300">
                    <li class="active"><a href="#dataflow">Data Flow Details</a></li>
                    <li><a href="#transfer">- Transfer Modes and Controls</a></li>
                    <li><a href="#post-transfer">- Post Transfer Security</a></li>
                    <li><a href="#privacy">Privacy</a></li>
                    <li><a href="#dpa1">- DPA Principle 1</a></li>
                    <li><a href="#dpa2">- DPA Principle 2</a></li>
                    <li><a href="#dpa3">- DPA Principle 3</a></li>
                    <li><a href="#dpa4">- DPA Principle 4</a></li>
                    <li><a href="#dpa5">- DPA Principle 5</a></li>
                    <li><a href="#dpa6">- DPA Principle 6</a></li>
                    <li><a href="#dpa7">- DPA Principle 7</a></li>
                    <li><a href="#outcome">Outcome</a></li>
                    <li><a href="#contacts">Contact Details</a></li>
                    <li><a href="#signoff">Sign-off</a></li>
                </ul>
            </asp:Panel>--%>
        </div>
    </div>
    
    <div id="modalFinalise" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalResignLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">
                        <asp:Label ID="modalResignTitle" runat="server" Text="Finalise data flow?"></asp:Label></h4>
                </div>
                <div class="modal-body">
                    <p>Once it has been finalised:</p>
                    <ul>
                        <li>You will be able to request sign-off of the Data Flow</li>
                        <li>The Data Flow <b>cannot</b> be amended.</li>
                    </ul>
                </div>
                <div class="modal-footer">
                    <asp:LinkButton ID="lbtFinaliseConfirm" CssClass="btn btn-primary" runat="server" CausesValidation="False"><i aria-hidden="true" class="icon-checkmark"></i> Yes</asp:LinkButton>
                    &nbsp;<asp:LinkButton ID="lbtFinaliseCancel" CssClass="btn btn-default" data-dismiss="modal" runat="server" CausesValidation="False"><i aria-hidden="true" class="icon-close"></i> No</asp:LinkButton>

                </div>
            </div>
        </div>
    </div>
    <asp:ObjectDataSource ID="dsAuditDetail" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_AuditDetailTableAdapter">
        <SelectParameters>
            <asp:SessionParameter Name="DFAuditID" SessionField="dvDFAuditID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsAuditFields" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InformationSharingPortal.DataFlowDetailTableAdapters.isp_AuditDetailFieldListTableAdapter">
        <SelectParameters>
            <asp:Parameter DefaultValue="isp_DataFlowDetail" Name="TableName" Type="String" Size="100" />
            <asp:ControlParameter ControlID="hfFlowDetailID" DefaultValue="0" Name="ID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
        <dx:BootstrapPopupControl ID="bspHistory" runat="server" ShowOnPageLoad="false" PopupElementCssSelector=".show-history"
    PopupHorizontalAlign="Center" HeaderText="Data Flow Transaction Log" PopupVerticalAlign="Middle" CloseAction="CloseButton" Modal="True">
             <SettingsAdaptivity Mode="Always" MaxWidth="1024" SwitchAtWindowInnerWidth="1024" VerticalAlign="WindowCenter"
        FixedHeader="true" FixedFooter="true" />
    <ContentCollection>
        <dx:ContentControl>
           
                    <asp:ObjectDataSource ID="dsTransactionHistory" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetFiltered" TypeName="InformationSharingPortal.ispdatasetTableAdapters.TransactionHistoryTableAdapter">
        <SelectParameters>
            <asp:Parameter DefaultValue="isp_DataFlowDetail" Name="TableName" Type="String" Size="100" />
            <asp:ControlParameter ControlID="hfFlowDetailID" DefaultValue="0" Name="ID" Type="Int32" />
            <asp:ControlParameter ControlID="ddAuditFieldFilter" DefaultValue="" Name="FieldName" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
            <div class="form form-horizontal">
                <div class="form-group">
                    <asp:Label ID="lblFieldFilter" CssClass="control-label col-sm-4" AssociatedControlID="ddAuditFieldFilter" runat="server" Text="Show changes to field:"></asp:Label>
                    <div class="col-sm-8">
                        <asp:DropDownList ID="ddAuditFieldFilter" AppendDataBoundItems="true" CssClass="form-control" runat="server" AutoPostBack="true" DataSourceID="dsAuditFields" DataTextField="FieldName" DataValueField="FieldName">
                            <asp:ListItem Text="All" Value="All" Selected="True"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>
            <dx:BootstrapGridView ID="bsgvAuditHistory" Settings-GridLines="None" runat="server" AutoGenerateColumns="False" DataSourceID="dsTransactionHistory" KeyFieldName="DFAuditID">

<Settings GridLines="None"></Settings>

                <SettingsText EmptyDataRow="No transaction details available" />
                <CssClasses Table="table table-striped table-condensed" />
        <Columns>
            <dx:BootstrapGridViewDateColumn FieldName="TransactionDate" VisibleIndex="0">
            </dx:BootstrapGridViewDateColumn>
            <dx:BootstrapGridViewTextColumn FieldName="UserName" VisibleIndex="1">
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn FieldName="TransactionType" VisibleIndex="2">
            </dx:BootstrapGridViewTextColumn>
        </Columns>
        <Templates>
            <DetailRow>
 <dx:BootstrapGridView ID="bsgvAuditDetail" runat="server" OnBeforePerformDataSelect="bsgvAuditDetail_BeforePerformDataSelect" AutoGenerateColumns="False" DataSourceID="dsAuditDetail">
        <SettingsPager Visible="False">
        </SettingsPager>
        <Columns>
            <dx:BootstrapGridViewTextColumn Caption="Field Changed" FieldName="FieldName" VisibleIndex="2">
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn Caption="Old Value" FieldName="OldValues" VisibleIndex="3">
                <DataItemTemplate>
                    <asp:Literal ID="Literal1" runat="server" Text='<%# IIf(Eval("OldValues").ToString.StartsWith("<li>"), "<UL>" & Eval("OldValues") & "</UL>", Eval("OldValues"))%>'></asp:Literal>
                </DataItemTemplate>
            </dx:BootstrapGridViewTextColumn>
            <dx:BootstrapGridViewTextColumn Caption="New Value" FieldName="NewValues" VisibleIndex="4">
                <DataItemTemplate>
                    <asp:Literal ID="Literal2" runat="server" Text='<%# IIf(Eval("NewValues").ToString.StartsWith("<li>"), "<UL>" & Eval("NewValues") & "</UL>", Eval("NewValues"))%>'></asp:Literal>
                </DataItemTemplate>
            </dx:BootstrapGridViewTextColumn>
        </Columns>
    </dx:BootstrapGridView>
                </DetailRow></Templates>
        <SettingsDetail AllowOnlyOneMasterRowExpanded="True" ShowDetailRow="True" />
    </dx:BootstrapGridView>
                    
              
        </dx:ContentControl>
    </ContentCollection>
</dx:BootstrapPopupControl>
    <%--<div id="modalHistory" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Data Flow Transaction Log</h4>
                </div>
                <div class="modal-body">
                    <div style="max-height: 400px; overflow-y: auto;">
                        <table class="table table-striped">
    
                           <asp:Repeater ID="rptHistory" runat="server" DataSourceID="dsTransactionHistory">
                                <HeaderTemplate>
                                    <div class="table-responsive">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label17" runat="server" Text='<%# Eval("TransactionDate")%>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:HyperLink ID="hlUser" runat="server"
                                                NavigateUrl='<%# Eval("UserName", "mailto:{0}")%>'>
                                                <i aria-hidden="true" class="icon-envelope"></i>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("UserName")%>'></asp:Label>
                                            </asp:HyperLink>
                                        </td>
                                        <td>
                                            <asp:Label ID="Label23" runat="server" Text='<%# Eval("TransactionType")%>'></asp:Label>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate></div></FooterTemplate>
                            </asp:Repeater>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="Button2" runat="server" type="button" class="btn btn-primary" data-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>--%>
    <div id="modalDPOReviewRequest" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="Label7" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">
                        <asp:Label ID="Label20" runat="server">DPO Review Request</asp:Label></h4>
                </div>
                <%-- <div class="modal-body">--%>
                <asp:ObjectDataSource ID="dsDPOReviewers" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDPOs" TypeName="InformationSharingPortal.ispdatasetTableAdapters.DataFlow_GetSeniorUsersTableAdapter">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="hfFlowDetailID" DefaultValue="0" Name="DataFlowDetailID" Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <div class="modal-body">
                    <div class="alert alert-info">
                        If a data flow contains personal data, DPO approval is mandatory (at least one DPO must approve the flow). Once a DPO has approved the flow, it will be locked (unless another DPO subsequently rejects it). Do not request DPO review until the data flow details are complete and ready.
                    </div>
                <asp:GridView ID="gvDPOReviewers" CssClass="table table-striped" HeaderStyle-CssClass="sorted-none" GridLines="None" EmptyDataText="There are no active, confirmed users in a DPO role at organisations involved in this data flow who have not already received a request to review this data flow." runat="server" AutoGenerateColumns="False" DataKeyNames="OrganisationUserID" DataSourceID="dsDPOReviewers">
                    <Columns>
                        <asp:TemplateField HeaderText="Select">
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkboxSelectAll" ToolTip="Select / deselect all" runat="server" onclick="CheckAllReviewers(this);" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="cbSelectUser" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="User" SortExpression="OrganisationUserName">
                            <ItemTemplate>
                                <asp:HiddenField ID="hfOrgUserID" runat="server" Value='<%# Eval("OrganisationUserID")%>' />
                                <asp:Label ID="lblUsername" runat="server" ToolTip='<%# Eval("OrganisationUserEmail")%>' Text='<%# Eval("OrganisationUserName")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Role" HeaderText="Role" ReadOnly="True" SortExpression="Role" />
                        <%--<asp:BoundField DataField="DelegateRoleTo" HeaderText="Delegate" SortExpression="DelegateRoleTo" />--%>

                        <asp:TemplateField HeaderText="Organisation" SortExpression="Organisation">
                            <ItemTemplate>
                                <asp:Label ID="lblOrganisation" runat="server" ToolTip='<%# Eval("Organisation")%>' Text='<%# Eval("Organisation") & " (" & Eval("OrgDFRole") & ")"%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>

                    <HeaderStyle CssClass="sorted-none"></HeaderStyle>
                </asp:GridView>


               
                    <div class="form-group">
                                    <asp:TextBox ID="tbRequestDPOReviewComments" CssClass="form-control" placeholder="Optional additional e-mail text / review instructions" TextMode="MultiLine" Height="80px" runat="server"></asp:TextBox>
                                </div> <div class="form-inline small" role="form">
                    <div class="form-group">
                        <asp:Label ID="Label21" CssClass="control-label" AssociatedControlID="tbReviewByDT" runat="server" Text="Review by date:"></asp:Label>
                        <asp:TextBox ID="tbReviewByDT" CssClass="form-control date-input" runat="server"></asp:TextBox>
                        <asp:CompareValidator ID="cvDPOReviewDate" Operator="GreaterThan" Display="Dynamic" Type="Date" ControlToValidate="tbReviewByDT" runat="server" ErrorMessage="Date must be in future" ValidationGroup="vgDPOReviewReq"></asp:CompareValidator>
                        <asp:RequiredFieldValidator ID="rfvDPOReviewDate" Display="Dynamic"  runat="server" ControlToValidate="tbReviewByDT" ErrorMessage="Please specify a review by date" ValidationGroup="vgDPOReviewReq"></asp:RequiredFieldValidator></div>

                </div>
                    </div>
            


            <script>
                            $('.date-input').datepicker({ dateFormat: 'dd/mm/yy' });
                            $('#optionalText').on('shown.bs.collapse', function () {
                                $(this).parent().find('.glyphicon-chevron-down').removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up');
                                $(this).parent().find('#lblOptions').text('Less options');
                            }).on('hidden.bs.collapse', function () {
                                $(this).parent().find('.glyphicon-chevron-up').removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
                                $(this).parent().find('#lblOptions').text('More options');
                    });
            </script>


            <%-- </div>--%>
            <div class="modal-footer">
                <button id="Button5" runat="server" type="button" class="btn btn-default pull-left" causesvalidation="False" data-dismiss="modal">Cancel</button>
                <asp:LinkButton ID="lbtSubmitDPOReviewRequest" CssClass="btn btn-primary pull-right" runat="server" CausesValidation="True" ValidationGroup="vgDPOReviewReq">OK</asp:LinkButton>
            </div></div>
        </div>
    </div>
    <div id="modalDPOReviewfDataFlow" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="Label5" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">
                                <asp:Label ID="Label25" runat="server">DPO Review Data Flow</asp:Label></h4>
                        </div>
                        <asp:HiddenField ID="hfDPOReviewID" runat="server" />
                        <div class="modal-body">
                            <p>
                                Having reviewed the arrangements for safeguarding the privacy of personal information captured in this sharing agreement, I have made the following observations and recommendations:
                            </p>
                            
                            <div class="form-group">
                                    <asp:TextBox ID="tbDPIAComments" CssClass="form-control" placeholder="Comments relating specifically to the DPIA" TextMode="MultiLine" Rows="5" runat="server"></asp:TextBox>
                                <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ValidationGroup="vgDPOReview"
         ErrorMessage="Please provide reasons for rejecting the dataflow in at least one of the comment fields." 
         ControlToValidate="tbDPIAComments" 
         ClientValidationFunction="doCustomValidate"
         ValidateEmptyText="true" ></asp:CustomValidator>
                                </div>
                            <div class="form-group">
                                    <asp:TextBox ID="tbRAComments" CssClass="form-control" placeholder="Comments relating specifically to the Risk Assessment" TextMode="MultiLine" Rows="5" runat="server"></asp:TextBox>
                                </div>
                            <div class="form-group">
                                    <asp:TextBox ID="tbDFComments" CssClass="form-control" placeholder="Other general comments relating to the data flow" TextMode="MultiLine" Rows="5" runat="server"></asp:TextBox>
                                </div>
                            
                        </div>
                        <div class="modal-footer">
                            <%--<button id="Button6" runat="server" type="button" class="btn btn-default pull-left" data-dismiss="modal"><i aria-hidden="true" class="icon-close"></i>Cancel</button>--%>
                            <asp:LinkButton ID="lbtDPOReject" CssClass="btn btn-danger pull-left" ToolTip="Reject agreement please explain in comments" CausesValidation="true" ValidationGroup="vgDPOReview" runat="server"><i aria-hidden="true" class="icon-thumbs-up2"></i> Reject</asp:LinkButton>
                            <asp:LinkButton ID="lbtDPApprove" CssClass="btn btn-success pull-right" runat="server" CausesValidation="False"><i aria-hidden="true" class="icon-thumbs-up"></i> Approve</asp:LinkButton>

                        </div>
                    </div>
                </div>
        <script>
    function doCustomValidate(source, args) {

        args.IsValid = false;

        if (document.getElementById('<% =tbDPIAComments.ClientID %>').value.length > 0) {
            args.IsValid = true;
        }
        if (document.getElementById('<% =tbRAComments.ClientID %>').value.length > 0) {
            args.IsValid = true;
        }
        if (document.getElementById('<% =tbDFComments.ClientID %>').value.length > 0) {
            args.IsValid = true;
        }
    }
</script>
            </div>
    <div id="modalViewComments" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalResignLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">
                        <asp:Label ID="lblDPOReviewTitle" runat="server" Text="DPO Review Comments"></asp:Label></h4>
                </div>
                <div class="modal-body">
                     <div class="form-group">
                                    <asp:TextBox ID="tbDPIACommentsReview" CssClass="form-control" Enabled="false" placeholder="Comments relating specifically to the DPIA" TextMode="MultiLine" runat="server"></asp:TextBox>
                                
                                </div>
                            <div class="form-group">
                                    <asp:TextBox ID="tbRACommentsReview" CssClass="form-control" Enabled="false" placeholder="Comments relating specifically to the Risk Assessment" TextMode="MultiLine" runat="server"></asp:TextBox>
                                </div>
                            <div class="form-group">
                                    <asp:TextBox ID="tbDFCommentsReview" CssClass="form-control" Enabled="false" placeholder="Other general comments relating to the data flow" TextMode="MultiLine" runat="server"></asp:TextBox>
                                </div>
            <div class="form-group">
                <asp:Panel ID="pnlReviewOutcome" CssClass="alert text-center" runat="server">
                    <asp:Label ID="lblReviewOutcome" Font-Size="Larger" runat="server" Text="Label"></asp:Label></asp:Panel>
                </div>
                </div>
                <div class="modal-footer">
                    
                    <asp:LinkButton ID="LinkButton4" CssClass="btn btn-default pull-right" data-dismiss="modal" runat="server" CausesValidation="False">OK</asp:LinkButton>

                </div>
            </div>
        </div>
    </div>
    <div id="modalDPOReReviewRequest" class="modal fade" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="Label7" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <asp:HiddenField ID="hfRROrgUserID" runat="server" />
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">
                        <asp:Label ID="Label19" runat="server">DPO Re-Review Request</asp:Label></h4>
                </div>
               <div class="modal-body">
                   <div class="form-horizontal">
                    <div class="form-group">
                        <div class="col-sm-12">
                                    <asp:TextBox ID="tbReReviewComments" CssClass="form-control" Rows="5" placeholder="Optional additional e-mail text / re-review instructions" TextMode="MultiLine" Height="80px" runat="server"></asp:TextBox>
                            </div>
                                </div> 
                    <div class="form-group">
                        <asp:Label ID="Label26" CssClass="col-sm-6 control-label" AssociatedControlID="tbReviewByDT" runat="server" Text="Review by date:"></asp:Label>
                        <div class="col-sm-6">
                        <asp:TextBox ID="tbReReviewByDate" CssClass="form-control date-input" runat="server"></asp:TextBox>
                        <asp:CompareValidator ID="cvReReviewByDate" Operator="GreaterThan" Display="Dynamic" Type="Date" ControlToValidate="tbReReviewByDate" runat="server" ErrorMessage="Date must be in future" ValidationGroup="vgDPOReReviewReq"></asp:CompareValidator>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" Display="Dynamic" runat="server" ControlToValidate="tbReReviewByDate" ErrorMessage="Please specify a review by date" ValidationGroup="vgDPOReReviewReq"></asp:RequiredFieldValidator>
                    </div>
                    </div>
                    </div>
                   <script>
                 $('.date-input').datepicker({ dateFormat: 'dd/mm/yy' });
            </script>
                   </div>
            
            <%-- </div>--%>
            <div class="modal-footer">
                <button id="Button6" runat="server" type="button" class="btn btn-default pull-left" causesvalidation="False" data-dismiss="modal">Cancel</button>
                <asp:LinkButton ID="lbtSubmitReReviewReq" CssClass="btn btn-primary pull-right" runat="server" CausesValidation="True" ValidationGroup="vgDPOReReviewReq">Submit</asp:LinkButton>
            </div></div>
        </div></div>
    <script type="text/javascript">
                            Sys.Application.add_load(BindEvents);
    </script>
        
</asp:Content>
