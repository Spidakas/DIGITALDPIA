Public Class DSAExport
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Page.Request.Item("DFDID") Is Nothing Then
            Response.Redirect("Default.aspx")
        Else
            Dim taTOU As New adminTableAdapters.isp_TermsOfUseTableAdapter
            Dim tTOU As New admin.isp_TermsOfUseDataTable
            tTOU = taTOU.GetCurrent("MOU")
            If tTOU.Count > 0 Then
                litMOUText.Text = tTOU.First.TermsHTML.ToString().Replace("pre-scrollable", "")
            End If
            Dim taQ As New DataFlowDetailTableAdapters.QueriesTableAdapter
            Dim nDFDID As Integer = CInt(Page.Request.Item("DFDID"))

            Dim nSummaryID As Integer = taQ.GetSummaryIDForFlow(nDFDID)
            Dim taISA As New DSAExportDataTableAdapters.ISADetailTableAdapter
            Dim tISA As New DSAExportData.ISADetailDataTable
            tISA = taISA.GetData(nDFDID)
            Dim taRA As New DataFlowDetailTableAdapters.isp_RiskAssessmentTableAdapter
            Dim tRA As New DataFlowDetail.isp_RiskAssessmentDataTable
            tRA = taRA.GetByDataFlowDetailID(nDFDID)
            If tRA.Count > 0 Then
                dsRisks.SelectParameters(0).DefaultValue = tRA.First.RiskAssessmentID
            Else
                pnlRiskAssessment.Visible = False
            End If
            lblBenefits.Text = BlankIsNone(tISA.First.SummaryBenefits)
            lblDataFields.Text = BlankIsNone(tISA.First.SummaryDataItems)



            If tISA.First.FlowLegalGateways.Length > 0 Then
                lblLegalBasis.Text = BlankIsNone(tISA.First.FlowLegalGateways)
            Else
                lblLegalBasis.Text = BlankIsNone(tISA.First.SummaryLegalGateway)
            End If
            lblPurposeForSharing.Text = BlankIsNone(tISA.First.SummaryPurpose)
            lblDSATitle.Text = tISA.First.SummaryName & " - " & tISA.First.DFDIdentifier
            lblSchedule2.Text = BlankIsNone(tISA.First.SummarySchedule2s)
            lblSchedule3.Text = BlankIsNone(tISA.First.SummarySchedule3s)
            lblTypesOfInformation.Text = BlankIsNone(tISA.First.SummaryInformationShared)
            lblDataSubjects.Text = BlankIsNone(tISA.First.SummaryDataSubjects)
            lblFrequency.Text = BlankIsNone(tISA.First.DFFrequency)
            lblNumberOfRecords.Text = BlankIsNone(tISA.First.DFNumberOfRecords)
            lblStorageAfterTransfer.Text = BlankIsNone(tISA.First.StorageAfterTransfer)
            lblPostTransferSecurity.Text = BlankIsNone(tISA.First.SecuredAfterTransfer)
            lblAccessControlsAfterTransfer.Text = BlankIsNone(tISA.First.AccessedAfterTransfer)
            lblConsentModels.Text = BlankIsNone(tISA.First.ConsentModel)
            If tISA.First.ConsentExemption.Length > 0 Then
                lblConsentModels.Text = lblConsentModels.Text & " Exemption reason / justification: " & tISA.First.ConsentExemption
            End If
            lblPrivacyNotice.Text = BlankIsNone(tISA.First.PrivacyNoticeAmends)
            lblAdequacy.Text = BlankIsNone(tISA.First.DPAChecksForAsset)
            lblAccurateComplete.Text = BlankIsNone(tISA.First.AccuracyProvisions)
            lblRetentionDisposal.Text = BlankIsNone(tISA.First.RetentionDisposal)
            lblSubjectAccessRequests.Text = BlankIsNone(tISA.First.SubjectAccessRequests)
            lblReceivingPoliciesSOPs.Text = BlankIsNone(tISA.First.PoliciesProcesses)
            lblReceivingIncidentManagement.Text = BlankIsNone(tISA.First.IncidentManagement)
            lblReceivingTraining.Text = BlankIsNone(tISA.First.TrainingSystemData)
            lblReceivingSecurityControl.Text = BlankIsNone(tISA.First.RecOrgSecurity)
            lblReceivingBusinessContinuity.Text = BlankIsNone(tISA.First.BusinessContinuity)
            lblReceivingDisasterRecovery.Text = BlankIsNone(tISA.First.DisasterRecovery)
            lblReceivingContracts.Text = BlankIsNone(tISA.First.ThirdPartContractIGClauses)
            lblPersonalItems.Text = BlankIsNone(tISA.First.PIDItems)
            lblPersonalSensitiveItems.Text = BlankIsNone(tISA.First.PIDSensitiveItems)
            lblSharingPlatform.Text = BlankIsNone(tISA.First.TransferSystemPlatform)
            If tISA.First.TransferSystemPlatform = "" Then
                pnlPlatform.Visible = False
            End If
            If tISA.First.IsNonEEA Then
                lblNonEEAExemptions.Text = BlankIsNone(tISA.First.NonEEAExemptions)
                lblNonEEACoCo.Text = BlankIsNone(tISA.First.NonEEACountryCoCo)
                lblNonEEACountryOfOrigin.Text = BlankIsNone(tISA.First.NonEEADataCountryOrigin)
                lblNonEEADestinationCountry.Text = BlankIsNone(tISA.First.NonEEADataCountryDestinsation)
                lblNonEEALaw.Text = BlankIsNone(tISA.First.NonEEACountryLaws)
                lblNonEEAObligations.Text = BlankIsNone(tISA.First.NonEEACountryObligations)
                If Not tISA.First.IsNonEEAProcessingStartDateNull() And Not tISA.First.IsNonEEAProcessingEndDateNull() Then
                    lblNonEEAProcessingPeriod.Text = CDate(tISA.First.NonEEAProcessingStartDate) & " to " & CDate(tISA.First.NonEEAProcessingEndDate)
                Else
                    lblNonEEAProcessingPeriod.Text = "Not specified."
                End If
                lblNonEEASecurity.Text = BlankIsNone(tISA.First.NonEEASecurityMeasures)
            Else
                pnlOutsideEEA.Visible = False
            End If
            If Not tISA.First.IsSignedDateNull() Then
                lblFromDate.Text = tISA.First.SignedDate.ToString("dd/MM/yyyy")
            Else
                lblFromDate.Text = "To be defined."
            End If
            If Not tISA.First.IsReviewDateNull() Then
                lblToDate.Text = tISA.First.ReviewDate.ToString("dd/MM/yyyy")
            Else
                lblToDate.Text = "To be defined."
            End If
            lblReviewMonths.Text = (tISA.First.SummaryReviewCycle * 12).ToString
        End If
        
    End Sub

    Protected Function BlankIsNone(ByVal sString As String) As String
        If sString = "" Then
            sString = "None specified."
        End If
        If String.IsNullOrEmpty(sString) Then Return String.Empty
        sString = sString.Replace(vbCr & vbLf, "<br />")
        sString = sString.Replace(vbLf, "<br />")
        Return sString.Replace(Environment.NewLine, "<br />")
    End Function


End Class