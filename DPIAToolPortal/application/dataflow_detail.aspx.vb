Imports System.IO
Imports DevExpress.Web
Imports DevExpress.Web.Bootstrap
Imports DevExpress.Web.Data

Public Class data_in_request
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Set up role based access to edit dataflows
        If Not Page.IsPostBack Then
            If Not Session("FlowDetailID") Is Nothing Then
                hfFlowDetailID.Value = Session("FlowDetailID")
                Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
                Dim nFlowID As Integer = CInt(hfFlowDetailID.Value)
                Dim nSummaryID As Integer = taq.GetSummaryIDForFlow(nFlowID)
                hfSummaryID.Value = nSummaryID
            Else
                If Not Session("nSummaryID") Is Nothing Then
                    hfSummaryID.Value = Session("nSummaryID")
                End If
            End If
        End If

        Dim bInDraft As Boolean = True
        Dim nSignatures As Integer = 0
        Dim nDPOStatus As Integer = 0
        'Set future date compare validator compare date to today's date:
        cvDPOReviewDate.ValueToCompare = DateTime.Now.ToString("dd/MM/yyyy")
        cvReReviewByDate.ValueToCompare = DateTime.Now.ToString("dd/MM/yyyy")
        If Not hfFlowDetailID.Value Is Nothing And Not Page.Request.Item("Action") = "Copy" And Not Page.Request.Item("Action") = "Add" Then
            Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
            nDPOStatus = taq.CheckDFCanFinalise(hfFlowDetailID.Value)
            nSignatures = taq.GetDataFlowSignatures(hfFlowDetailID.Value)
            bInDraft = taq.DataFlowDetailGetInDraftStatus(hfFlowDetailID.Value)
        End If

        If nSignatures > 0 Or (Session("UserRoleAdmin") = False And Session("UserRoleIAO") = False And Session("UserRoleIGO") = False) Or (Not bInDraft) Or nDPOStatus = 2 Or nDPOStatus = 3 Then
            hfReadOnly.Value = 1
            pnlDFD.Enabled = False
            pnlDFD2.Enabled = False
            bsgvRisks.Columns("Tools").Visible = False
            'pnlAddProvidingOrgs.Visible = True
            If (Session("UserRoleAdmin") = False And Session("UserRoleIAO") = False And Session("UserRoleIGO") = False) Then
                pnlAddProvidingOrgs.Enabled = False
            End If
            pnlPIA.Enabled = False
            pnlPIAExtra.Enabled = False
            lbtUpdateDataFlow.Visible = False
            lbtContactAdd.Visible = False
            pnlUpload.Visible = False
            pnlFileUpload.Visible = False
            lblDataFlowHeader.Text = "Review Data Flow "
            litStatusSymbol.Text = "<i aria-hidden='true' class='icon-file'></i>"
            If nSignatures > 0 Then
                lblDFStatus.Text = "Signed"
            ElseIf Not bInDraft Then
                lblDFStatus.Text = "Final"
            ElseIf nDPOStatus = 2 Or nDPOStatus = 3 Then
                lblDFStatus.Text = "DPO Approved"
            End If

            Dim sBtnTextScript As String = My.Settings.DisableMultiselectShowAll.ToString
            'Page.ClientScript.RegisterStartupScript(Me.GetType(), "multiSelectDisable", "<script>function DoMultiSelect() {$('.multiselector').multiselect('disable');};</script>")
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "multiSelectDisable", "<script>function doMultiSelect() {$('.multiselector').not('.no-freeze').attr('disabled', 'disabled').multiselect(" & sBtnTextScript & ");$('.multiselector-all').not('.no-freeze').attr('disabled', 'disabled').multiselect(" & sBtnTextScript & ");$('.no-freeze').multiselect('enable', {buttonWidth: '75%'});}</script>")
            'Page.ClientScript.RegisterStartupScript(Me.GetType(), "multiSelectDisable", "<script>function doMultiSelectAll() {$('.multiselector-all').multiselect('disable');}</script>")
            'Page.ClientScript.RegisterStartupScript(Me.GetType(), "multiSelect", "<script>function DoMultiSelect() {$('.multiselector').multiselect();};</script>")
        ElseIf nSignatures = 0 And Session("UserRoleCSO") Then
            bsgvRisks.Columns("Tools").Visible = True
        Else
            If Session("orgLicenceType") = "Free, limited licence" Then
                pnlUpload.Visible = False
                pnlFileUpload.Visible = False
                lbtExportToExcel.Visible = False
                pnlFreeLicenceMessage.Visible = True
                pnlFreeLicenceMessage2.Visible = True
            End If
            'Page.ClientScript.RegisterStartupScript(Me.GetType(), "multiSelectEnable", "<script>function doMultiSelect() {$('.multiselector').multiselect('');}</script>")
            hfReadOnly.Value = 0
            pnlDFD.Enabled = True
            pnlDFD2.Enabled = True
            bsgvRisks.Columns("Tools").Visible = True
            pnlAddProvidingOrgs.Visible = False
            pnlPIA.Enabled = True
            pnlPIAExtra.Enabled = True
            lblDataFlowHeader.Text = "Edit Data Flow"
            litStatusSymbol.Text = "<i aria-hidden='true' class='icon-pencil'></i>"
        End If

        If Session("UserRoleAO") Or Session("UserRoleDELEG") Or Session("UserRoleIAO") Or Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO") Then
            'lbtSignAgreement.Visible = True
            lbtRequestSignOff.Visible = True
        Else
            'lbtSignAgreement.Visible = False
            lbtRequestSignOff.Visible = False
        End If
        If Not Page.IsPostBack Or ViewState("Reload") = True Then
            hfFlowFileGroupID.Value = 0
            hfFlowDocsFileGroupID.Value = 0
            If Not Page.Request.Item("Action") Is Nothing Then
                Dim nSummaryID As Integer = CInt(hfSummaryID.Value)
                dsOrganisations.SelectParameters(0).DefaultValue = nSummaryID
                Dim taSummary As New ispdatasetTableAdapters.isp_DataFlowSummariesFullTableAdapter
                Dim tSummary As New ispdataset.isp_DataFlowSummariesFullDataTable
                tSummary = taSummary.GetByID(nSummaryID)
                lblSummaryName.Text = PadSummaryID(nSummaryID) & " " & tSummary.First.DFName
                tbPurpose.Text = tSummary.First.DFPurpose
                tbPurposeNonEAA.Text = tSummary.First.DFPurpose
                tbLegalGateways.Text = tSummary.First.DFLegalGateway
                Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
                Dim sArtSix As String = taq.GetArticleSixConditions(nSummaryID)
                Dim sArtNine As String = taq.GetArticleNineConditions(nSummaryID)
                Dim taIS As New ispdatasetTableAdapters.isp_DF_InformationSharedTableAdapter
                Dim tIS As New ispdataset.isp_DF_InformationSharedDataTable
                tIS = taIS.GetByDataFlowID(nSummaryID)


                If sArtSix Is Nothing Then
                    pnlArticleSix.Visible = False
                Else
                    pnlArticleSix.Visible = True
                    tbArticleSixConditions.Text = sArtSix
                End If

                If sArtNine Is Nothing Then
                    pnlArticleNine.Visible = False
                Else
                    pnlArticleNine.Visible = True
                    tbArticleNineConditions.Text = sArtNine
                End If
                'Now double check if personal or special category are selected at summary level and show the panels anyway if so:
                For Each r As DataRow In tIS.Rows
                    If r.Item("InformationSharedID") = 1 Then
                        pnlArticleSix.Visible = True
                    ElseIf r.Item("InformationSharedID") = 2 Then
                        pnlArticleNine.Visible = True
                    End If
                Next


                tbNatureOfData.Text = taq.GetInformationSharedForSummary(nSummaryID)
                If Page.Request.Item("Action") = "Add" And Not ViewState("Reload") = True Then
                    If Session("orgLicenceType") = "Free, limited licence" Then
                        divFreeWarning.Visible = True
                    End If
                    'Set up the form for Adding:
                    hfFlowDetailID.Value = 0
                    btnHistory.Visible = False
                    hfDADataFlowContact.Value = 0
                    litStatusSymbol.Text = "<i aria-hidden='true' class='icon-plus'></i>"
                    lblDataFlowHeader.Text = "Add Data Flow"
                    pnlOutsideEAA.Visible = False
                    liDataFlow.Attributes.Add("class", "active")
                    lbtUpdateDataFlow.Visible = False
                    If Session("orgLicenceType") = "Free, limited licence" Then
                        pnlFileUpload.Visible = False
                        pnlUpload.Visible = False
                        pnlFileUpload.Visible = False
                    End If
                    If pnlDFD.Enabled Then
                        lbtSaveDataFlow.Visible = True
                    Else
                        lbtSaveDataFlow.Visible = False
                    End If
                ElseIf Page.Request.Item("Action") = "Copy" And Not ViewState("Reload") = True Then
                    If Session("orgLicenceType") = "Free, limited licence" Then
                        divFreeWarning.Visible = True
                    End If
                    btnHistory.Visible = False
                    hfDADataFlowContact.Value = 0
                    lblDataFlowHeader.Text = "Copy (Add) Data Flow"
                    litStatusSymbol.Text = "<i aria-hidden='true' class='icon-files-copy'></i>"
                    pnlOutsideEAA.Visible = False
                    liDataFlow.Attributes.Add("class", "active")
                    lbtUpdateDataFlow.Visible = False
                    hfOriginalDetailID.Value = hfFlowDetailID.Value
                    hfFlowDetailID.Value = 0
                    If pnlDFD.Enabled Then
                        lbtSaveDataFlow.Visible = True
                    Else
                        lbtSaveDataFlow.Visible = False
                    End If
                    LoadDetail(hfOriginalDetailID.Value)
                    tbDFDIdentifier.Text = tbDFDIdentifier.Text & " - COPY"
                    lblDFSubHeader.Text = PadID(hfOriginalDetailID.Value) & " " & tbDFDIdentifier.Text
                ElseIf Page.Request.Item("Action") = "Edit" Or ViewState("Reload") = True Then
                    ViewState("Reload") = False
                    'Set up the form for Editing:


                    liDataFlow.Attributes.Add("class", "active")
                    If pnlDFD.Enabled Then
                        lbtUpdateDataFlow.Visible = True
                    Else
                        lbtUpdateDataFlow.Visible = False
                    End If
                    lbtSaveDataFlow.Visible = False
                    Dim nDFDID = hfFlowDetailID.Value
                    'litStatusSymbol.Text = "<i aria-hidden='true' class='icon-pencil'></i>"

                    hfDADataFlowContact.Value = taq.GetDFContactGroupID(nDFDID)
                    hfFlowFileGroupID.Value = taq.GetFileGroupID("flow", nDFDID)
                    hfFlowDocsFileGroupID.Value = taq.GetFileGroupID("flowdocs", nDFDID)
                    LoadDetail(nDFDID)
                End If
            Else
                'Action is nothing - this shouldn't be possible, redirect to the dataflow-list:
                Response.Redirect("~/application/flows_list.aspx")
            End If
        End If
    End Sub
    Protected Function PadID(value As Integer) As String

        Dim fmt As String = "DF000000"
        Dim str As String = value.ToString(fmt)
        Return str
    End Function
    Protected Function PadSummaryID(value As Integer) As String

        Dim fmt As String = "DS000000"
        Dim str As String = value.ToString(fmt)
        Return str
    End Function

    Private Sub cb_CheckedChanged(sender As Object, e As EventArgs) Handles cbDFDElectronicAccessedOnSite.CheckedChanged, cbDFDElectronicByAutomated.CheckedChanged, cbDFDElectronicByEmail.CheckedChanged, cbDFDElectronicByManual.CheckedChanged, cbDFDElectronicViaText.CheckedChanged, cbDFDPaperByCourier.CheckedChanged, cbDFDPaperByDataSubject.CheckedChanged, cbDFDPaperByFax.CheckedChanged, cbDFDPaperByStaff.CheckedChanged, cbDFDPaperByStandardPost.CheckedChanged, cbDFDRemovableByStaff.CheckedChanged, cbDFDRemovableByStandardPost.CheckedChanged, cbDFDInformationByVoice.CheckedChanged
        Dim sDivControls As String = ""
        Dim cbSender As CheckBox = DirectCast(sender, CheckBox)
        Dim pnlControls As Panel = DirectCast(Me.divDFDElectronicAccessedOnSite, Panel)
        Select Case cbSender.ID
            Case "cbDFDElectronicAccessedOnSite"
                pnlControls = DirectCast(Me.divDFDElectronicAccessedOnSite, Panel)
            Case "cbDFDElectronicByAutomated"
                pnlControls = DirectCast(Me.divDFDElectronicByAutomated, Panel)
            Case "cbDFDElectronicByEmail"
                pnlControls = DirectCast(Me.divDFDElectronicByEmail, Panel)
            Case "cbDFDElectronicByManual"
                pnlControls = DirectCast(Me.divDFDElectronicByManual, Panel)
            Case "cbDFDElectronicViaText"
                pnlControls = DirectCast(Me.divDFDElectronicViaText, Panel)
            Case "cbDFDPaperByCourier"
                pnlControls = DirectCast(Me.divDFDPaperByCourier, Panel)
            Case "cbDFDPaperByDataSubject"
                pnlControls = DirectCast(Me.divDFDPaperByDataSubject, Panel)
            Case "cbDFDPaperByFax"
                pnlControls = DirectCast(Me.divDFDPaperByFax, Panel)
            Case "cbDFDPaperByStaff"
                pnlControls = DirectCast(Me.divDFDPaperByStaff, Panel)
            Case "cbDFDPaperByStandardPost"
                pnlControls = DirectCast(Me.divDFDPaperByStandardPost, Panel)
            Case "cbDFDRemovableByStaff"
                pnlControls = DirectCast(Me.divDFDRemovableByStaff, Panel)
            Case "cbDFDRemovableByStandardPost"
                pnlControls = DirectCast(Me.divDFDRemovableByStandardPost, Panel)
            Case "cbDFDInformationByVoice"
                pnlControls = DirectCast(Me.divDFDInformationByVoice, Panel)
        End Select

        If cbSender.Checked Then
            pnlControls.Visible = True
        Else
            pnlControls.Visible = False
        End If

    End Sub

    Private Sub ddDataFlowDirection_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddDataFlowDirection.SelectedIndexChanged, listDFDStorageAfterTransfer.SelectedIndexChanged
        Dim li As ListItem = listDFDStorageAfterTransfer.Items(4)
        If ddDataFlowDirection.SelectedValue = 5 Or ddDataFlowDirection.SelectedValue = 10 Or ddDataFlowDirection.SelectedValue = 15 Or li.Selected Then
            rblOutsideEEA.SelectedValue = 1
            pnlOutsideEAA.Visible = True
        Else
            rblOutsideEEA.SelectedValue = 0
            pnlOutsideEAA.Visible = False
        End If
        listOrganisations.DataBind()
    End Sub



    'Private Sub listDFDConsentModel_SelectedIndexChanged(sender As Object, e As EventArgs) Handles listDFDConsentModel.SelectedIndexChanged
    '    Dim li As ListItem = listDFDConsentModel.Items(1)
    '    Dim li2 As ListItem = listDFDConsentModel.Items(2)
    '    tbConsentExemption.Visible = (li.Selected Or li2.Selected)
    'End Sub
    Protected Sub RemoveActiveClasses()
        liOutcome.Attributes.Remove("class")
        liDataFlow.Attributes.Remove("class")
        liPrivacy.Attributes.Remove("class")
        liSignOff.Attributes.Remove("class")
        liDocuments.Attributes.Remove("class")
        liContacts.Attributes.Remove("class")
        liDPOReview.Attributes.Remove("class")
    End Sub
    Private Sub lbtDataFlow_Click(sender As Object, e As EventArgs) Handles lbtDataFlow.Click
        RemoveActiveClasses()
        mvDataFlow.SetActiveView(vDataFlow)
        liDataFlow.Attributes.Add("class", "active")
    End Sub

    Private Sub lbtOutcome_Click(sender As Object, e As EventArgs) Handles lbtOutcome.Click
        RemoveActiveClasses()
        mvDataFlow.SetActiveView(vOutcome)
        liOutcome.Attributes.Add("class", "active")
    End Sub

    Private Sub lbtPrivacy_Click(sender As Object, e As EventArgs) Handles lbtPrivacy.Click
        RemoveActiveClasses()
        mvDataFlow.SetActiveView(vPrivacy)
        liPrivacy.Attributes.Add("class", "active")
    End Sub

    Private Sub lbtSignOff_Click(sender As Object, e As EventArgs) Handles lbtSignOff.Click
        RemoveActiveClasses()
        mvDataFlow.SetActiveView(vSignOff)
        liSignOff.Attributes.Add("class", "active")
    End Sub

    Private Sub lbtDocuments_Click(sender As Object, e As EventArgs) Handles lbtDocuments.Click
        RemoveActiveClasses()
        mvDataFlow.SetActiveView(vDocuments)
        liDocuments.Attributes.Add("class", "active")
    End Sub

    Private Sub lbtContacts_Click(sender As Object, e As EventArgs) Handles lbtContacts.Click
        RemoveActiveClasses()
        mvDataFlow.SetActiveView(vContacts)
        liContacts.Attributes.Add("class", "active")
    End Sub


    Private Sub lbtSaveDataFlow_Click(sender As Object, e As EventArgs) Handles lbtSaveDataFlow.Click
        Dim nSummaryID As Integer = hfSummaryID.Value
        Dim sDFDWhatTransferredCSV As String = ""
        Dim sDFDPaperByCourierCSV As String = ""
        Dim sDFDPaperByStaffCSV As String = ""
        Dim sDFDPaperByStandardPostCSV As String = ""
        Dim sDFDPaperByFaxCSV As String = ""
        Dim sDFDPaperByDataSubjectCSV As String = ""
        Dim sDFDRemovableByStaffCSV As String = ""
        Dim sDFDRemovableByStandardPostCSV As String = ""
        Dim sDFDElectronicByEmailCSV As String = ""
        Dim sDFDElectronicByAutomatedCSV As String = ""
        Dim sDFDElectronicByManualCSV As String = ""
        Dim sDFDElectronicAccessedOnSiteCSV As String = ""
        Dim sDFDElectronicViaTextCSV As String = ""
        Dim sDFDStorageAfterTransferCSV As String = ""
        Dim sDFDSecuredAfterTransferCSV As String = ""
        Dim sDFDAccessedAfterTransferCSV As String = ""
        Dim sDFDPrivacyChangesCSV As String = ""
        Dim sDFDConsentModelCSV As String = ""
        Dim sDFDUptodateAccurateCompleteCSV As String = ""
        Dim sDFDRetentionDisposalCSV As String = ""
        Dim sDFDSubjectAccessRequestsCSV As String = ""
        Dim sDFDPoliciesProcessesSOPsCSV As String = ""
        Dim sDFDIncidentManagementCSV As String = ""
        Dim sDFDTrainingSystemDataCSV As String = ""
        Dim sDFDSecuredReceivingOrgCSV As String = ""
        Dim sDFDBusinessContinuityCSV As String = ""
        Dim sDFDDisasterRecoveryCSV As String = ""
        Dim sDFDNonEEAExemptionsDerogationsCSV As String = ""
        Dim sDFDOrganisationsCSV As String = ""
        Dim sDFDInformationByVoiceCSV As String = ""
        Dim sDFDPersonalDataItemsCSV As String = ""
        If cbDFDPaperByCourier.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "1, "
        End If
        If cbDFDPaperByStaff.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "2, "
        End If
        If cbDFDPaperByStandardPost.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "3, "
        End If
        If cbDFDPaperByFax.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "4, "
        End If
        If cbDFDPaperByDataSubject.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "5, "
        End If
        If cbDFDRemovableByStaff.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "6, "
        End If
        If cbDFDRemovableByStandardPost.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "7, "
        End If
        If cbDFDElectronicByEmail.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "8, "
        End If
        If cbDFDElectronicByAutomated.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "9, "
        End If
        If cbDFDElectronicByManual.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "10, "
        End If
        If cbDFDElectronicAccessedOnSite.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "11, "
        End If
        If cbDFDElectronicViaText.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "12, "
        End If
        If cbDFDInformationByVoice.Checked Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "13, "
        End If
        If sDFDWhatTransferredCSV.Length > 2 Then
            sDFDWhatTransferredCSV = sDFDWhatTransferredCSV.Substring(0, sDFDWhatTransferredCSV.Length - 2)
        End If
        'Generate PaperByCourier CSV
        For Each li As ListItem In listDFDPaperByCourier.Items
            If li.Selected Then
                sDFDPaperByCourierCSV = sDFDPaperByCourierCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDPaperByCourierCSV.Length > 2 Then
            sDFDPaperByCourierCSV = sDFDPaperByCourierCSV.Substring(0, sDFDPaperByCourierCSV.Length - 2)
        End If
        'Generate PaperByStaff CSV
        For Each li As ListItem In listDFDPaperByStaff.Items
            If li.Selected Then
                sDFDPaperByStaffCSV = sDFDPaperByStaffCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDPaperByStaffCSV.Length > 2 Then
            sDFDPaperByStaffCSV = sDFDPaperByStaffCSV.Substring(0, sDFDPaperByStaffCSV.Length - 2)
        End If
        'Generate PaperByStandardPost CSV
        For Each li As ListItem In listDFDPaperByStandardPost.Items
            If li.Selected Then
                sDFDPaperByStandardPostCSV = sDFDPaperByStandardPostCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDPaperByStandardPostCSV.Length > 2 Then
            sDFDPaperByStandardPostCSV = sDFDPaperByStandardPostCSV.Substring(0, sDFDPaperByStandardPostCSV.Length - 2)
        End If
        'Generate PaperByFax CSV
        For Each li As ListItem In listDFDPaperByFax.Items
            If li.Selected Then
                sDFDPaperByFaxCSV = sDFDPaperByFaxCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDPaperByFaxCSV.Length > 2 Then
            sDFDPaperByFaxCSV = sDFDPaperByFaxCSV.Substring(0, sDFDPaperByFaxCSV.Length - 2)
        End If
        'Generate PaperByDataSubject CSV
        For Each li As ListItem In listDFDPaperByDataSubject.Items
            If li.Selected Then
                sDFDPaperByDataSubjectCSV = sDFDPaperByDataSubjectCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDPaperByDataSubjectCSV.Length > 2 Then
            sDFDPaperByDataSubjectCSV = sDFDPaperByDataSubjectCSV.Substring(0, sDFDPaperByDataSubjectCSV.Length - 2)
        End If
        'Generate RemovableByStaff CSV
        For Each li As ListItem In listDFDRemovableByStaff.Items
            If li.Selected Then
                sDFDRemovableByStaffCSV = sDFDRemovableByStaffCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDRemovableByStaffCSV.Length > 2 Then
            sDFDRemovableByStaffCSV = sDFDRemovableByStaffCSV.Substring(0, sDFDRemovableByStaffCSV.Length - 2)
        End If
        'Generate RemovableByStandardPost CSV
        For Each li As ListItem In listDFDRemovableByStandardPost.Items
            If li.Selected Then
                sDFDRemovableByStandardPostCSV = sDFDRemovableByStandardPostCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDRemovableByStandardPostCSV.Length > 2 Then
            sDFDRemovableByStandardPostCSV = sDFDRemovableByStandardPostCSV.Substring(0, sDFDRemovableByStandardPostCSV.Length - 2)
        End If
        'Generate ElectronicByEmail CSV
        For Each li As ListItem In listDFDElectronicByEmail.Items
            If li.Selected Then
                sDFDElectronicByEmailCSV = sDFDElectronicByEmailCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDElectronicByEmailCSV.Length > 2 Then
            sDFDElectronicByEmailCSV = sDFDElectronicByEmailCSV.Substring(0, sDFDElectronicByEmailCSV.Length - 2)
        End If
        'Generate ElectronicByAutomated CSV
        For Each li As ListItem In listDFDElectronicByAutomated.Items
            If li.Selected Then
                sDFDElectronicByAutomatedCSV = sDFDElectronicByAutomatedCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDElectronicByAutomatedCSV.Length > 2 Then
            sDFDElectronicByAutomatedCSV = sDFDElectronicByAutomatedCSV.Substring(0, sDFDElectronicByAutomatedCSV.Length - 2)
        End If
        'Generate ElectronicByManual CSV
        For Each li As ListItem In listDFDElectronicByManual.Items
            If li.Selected Then
                sDFDElectronicByManualCSV = sDFDElectronicByManualCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDElectronicByManualCSV.Length > 2 Then
            sDFDElectronicByManualCSV = sDFDElectronicByManualCSV.Substring(0, sDFDElectronicByManualCSV.Length - 2)
        End If
        'Generate ElectronicAccessedOnSite CSV
        For Each li As ListItem In listDFDElectronicAccessedOnSite.Items
            If li.Selected Then
                sDFDElectronicAccessedOnSiteCSV = sDFDElectronicAccessedOnSiteCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDElectronicAccessedOnSiteCSV.Length > 2 Then
            sDFDElectronicAccessedOnSiteCSV = sDFDElectronicAccessedOnSiteCSV.Substring(0, sDFDElectronicAccessedOnSiteCSV.Length - 2)
        End If
        'Generate ElectronicViaText CSV
        For Each li As ListItem In listDFDElectronicViaText.Items
            If li.Selected Then
                sDFDElectronicViaTextCSV = sDFDElectronicViaTextCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDElectronicViaTextCSV.Length > 2 Then
            sDFDElectronicViaTextCSV = sDFDElectronicViaTextCSV.Substring(0, sDFDElectronicViaTextCSV.Length - 2)
        End If
        'Generate InformationByVoice CSV
        For Each li As ListItem In listDFDInformationByVoice.Items
            If li.Selected Then
                sDFDInformationByVoiceCSV = sDFDInformationByVoiceCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDInformationByVoiceCSV.Length > 2 Then
            sDFDInformationByVoiceCSV = sDFDInformationByVoiceCSV.Substring(0, sDFDInformationByVoiceCSV.Length - 2)
        End If
        'Generate StorageAfterTransfer CSV
        For Each li As ListItem In listDFDStorageAfterTransfer.Items
            If li.Selected Then
                sDFDStorageAfterTransferCSV = sDFDStorageAfterTransferCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDStorageAfterTransferCSV.Length > 2 Then
            sDFDStorageAfterTransferCSV = sDFDStorageAfterTransferCSV.Substring(0, sDFDStorageAfterTransferCSV.Length - 2)
        End If
        'Generate SecuredAfterTransfer CSV
        For Each li As ListItem In listDFDSecuredAfterTransfer.Items
            If li.Selected Then
                sDFDSecuredAfterTransferCSV = sDFDSecuredAfterTransferCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDSecuredAfterTransferCSV.Length > 2 Then
            sDFDSecuredAfterTransferCSV = sDFDSecuredAfterTransferCSV.Substring(0, sDFDSecuredAfterTransferCSV.Length - 2)
        End If
        'Generate AccessedAfterTransfer CSV
        For Each li As ListItem In listDFDAccessedAfterTransfer.Items
            If li.Selected Then
                sDFDAccessedAfterTransferCSV = sDFDAccessedAfterTransferCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDAccessedAfterTransferCSV.Length > 2 Then
            sDFDAccessedAfterTransferCSV = sDFDAccessedAfterTransferCSV.Substring(0, sDFDAccessedAfterTransferCSV.Length - 2)
        End If
        'Generate PrivacyChanges CSV
        For Each li As ListItem In listDFDPrivacyChanges.Items
            If li.Selected Then
                sDFDPrivacyChangesCSV = sDFDPrivacyChangesCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDPrivacyChangesCSV.Length > 2 Then
            sDFDPrivacyChangesCSV = sDFDPrivacyChangesCSV.Substring(0, sDFDPrivacyChangesCSV.Length - 2)
        End If
        'Generate ConsentModel CSV
        For Each li As ListItem In listDFDConsentModel.Items
            If li.Selected Then
                sDFDConsentModelCSV = sDFDConsentModelCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDConsentModelCSV.Length > 2 Then
            sDFDConsentModelCSV = sDFDConsentModelCSV.Substring(0, sDFDConsentModelCSV.Length - 2)
        End If
        'Generate UptodateAccurateComplete CSV
        For Each li As ListItem In listDFDUptodateAccurateComplete.Items
            If li.Selected Then
                sDFDUptodateAccurateCompleteCSV = sDFDUptodateAccurateCompleteCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDUptodateAccurateCompleteCSV.Length > 2 Then
            sDFDUptodateAccurateCompleteCSV = sDFDUptodateAccurateCompleteCSV.Substring(0, sDFDUptodateAccurateCompleteCSV.Length - 2)
        End If
        'Generate RetentionDisposal CSV
        For Each li As ListItem In listDFDRetentionDisposal.Items
            If li.Selected Then
                sDFDRetentionDisposalCSV = sDFDRetentionDisposalCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDRetentionDisposalCSV.Length > 2 Then
            sDFDRetentionDisposalCSV = sDFDRetentionDisposalCSV.Substring(0, sDFDRetentionDisposalCSV.Length - 2)
        End If
        'Generate SubjectAccessRequests CSV
        For Each li As ListItem In listDFDSubjectAccessRequests.Items
            If li.Selected Then
                sDFDSubjectAccessRequestsCSV = sDFDSubjectAccessRequestsCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDSubjectAccessRequestsCSV.Length > 2 Then
            sDFDSubjectAccessRequestsCSV = sDFDSubjectAccessRequestsCSV.Substring(0, sDFDSubjectAccessRequestsCSV.Length - 2)
        End If
        'Generate PoliciesProcessesSOPs CSV
        For Each li As ListItem In listDFDPoliciesProcessesSOPs.Items
            If li.Selected Then
                sDFDPoliciesProcessesSOPsCSV = sDFDPoliciesProcessesSOPsCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDPoliciesProcessesSOPsCSV.Length > 2 Then
            sDFDPoliciesProcessesSOPsCSV = sDFDPoliciesProcessesSOPsCSV.Substring(0, sDFDPoliciesProcessesSOPsCSV.Length - 2)
        End If
        'Generate IncidentManagement CSV
        For Each li As ListItem In listDFDIncidentManagement.Items
            If li.Selected Then
                sDFDIncidentManagementCSV = sDFDIncidentManagementCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDIncidentManagementCSV.Length > 2 Then
            sDFDIncidentManagementCSV = sDFDIncidentManagementCSV.Substring(0, sDFDIncidentManagementCSV.Length - 2)
        End If
        'Generate TrainingSystemData CSV
        For Each li As ListItem In listDFDTrainingSystemData.Items
            If li.Selected Then
                sDFDTrainingSystemDataCSV = sDFDTrainingSystemDataCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDTrainingSystemDataCSV.Length > 2 Then
            sDFDTrainingSystemDataCSV = sDFDTrainingSystemDataCSV.Substring(0, sDFDTrainingSystemDataCSV.Length - 2)
        End If
        'Generate SecuredReceivingOrg CSV
        For Each li As ListItem In listDFDSecuredReceivingOrg.Items
            If li.Selected Then
                sDFDSecuredReceivingOrgCSV = sDFDSecuredReceivingOrgCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDSecuredReceivingOrgCSV.Length > 2 Then
            sDFDSecuredReceivingOrgCSV = sDFDSecuredReceivingOrgCSV.Substring(0, sDFDSecuredReceivingOrgCSV.Length - 2)
        End If
        'Generate BusinessContinuity CSV
        For Each li As ListItem In listDFDBusinessContinuity.Items
            If li.Selected Then
                sDFDBusinessContinuityCSV = sDFDBusinessContinuityCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDBusinessContinuityCSV.Length > 2 Then
            sDFDBusinessContinuityCSV = sDFDBusinessContinuityCSV.Substring(0, sDFDBusinessContinuityCSV.Length - 2)
        End If
        'Generate DisasterRecovery CSV
        For Each li As ListItem In listDFDDisasterRecovery.Items
            If li.Selected Then
                sDFDDisasterRecoveryCSV = sDFDDisasterRecoveryCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDDisasterRecoveryCSV.Length > 2 Then
            sDFDDisasterRecoveryCSV = sDFDDisasterRecoveryCSV.Substring(0, sDFDDisasterRecoveryCSV.Length - 2)
        End If
        'Generate NonEEAExemptionsDerogations CSV
        For Each li As ListItem In listDFDNonEEAExemptionsDerogations.Items
            If li.Selected Then
                sDFDNonEEAExemptionsDerogationsCSV = sDFDNonEEAExemptionsDerogationsCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDNonEEAExemptionsDerogationsCSV.Length > 2 Then
            sDFDNonEEAExemptionsDerogationsCSV = sDFDNonEEAExemptionsDerogationsCSV.Substring(0, sDFDNonEEAExemptionsDerogationsCSV.Length - 2)
        End If
        'Generate Organisations CSV
        For Each li As ListItem In listOrganisations.Items
            If li.Selected Then
                sDFDOrganisationsCSV = sDFDOrganisationsCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDOrganisationsCSV.Length > 2 Then
            sDFDOrganisationsCSV = sDFDOrganisationsCSV.Substring(0, sDFDOrganisationsCSV.Length - 2)
        End If
        'Generate PID Items CSV
        For Each li As ListItem In listDFDPersonalItems.Items
            If li.Selected Then
                sDFDPersonalDataItemsCSV = sDFDPersonalDataItemsCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listDFDPersonalSensitiveItems.Items
            If li.Selected Then
                sDFDPersonalDataItemsCSV = sDFDPersonalDataItemsCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDPersonalDataItemsCSV.Length > 2 Then
            sDFDPersonalDataItemsCSV = sDFDPersonalDataItemsCSV.Substring(0, sDFDPersonalDataItemsCSV.Length - 2)
        End If

        Dim currentUser As MembershipUser = Membership.GetUser()
        Dim currentUserId As Guid = DirectCast(currentUser.ProviderUserKey, Guid)
        Dim dtStart As Nullable(Of DateTime)
        If tbNonEEAProcessingStartDate.Text.Length = 0 Then
            dtStart = Nothing
        Else
            dtStart = DateTime.ParseExact(tbNonEEAProcessingStartDate.Text, "d/M/yyyy", Globalization.CultureInfo.InvariantCulture, Globalization.DateTimeStyles.None)
        End If
        Dim dtEnd As Nullable(Of DateTime)
        If tbNonEEAProcessingEndDate.Text.Length = 0 Then
            dtEnd = Nothing
        Else
            dtEnd = DateTime.ParseExact(tbNonEEAProcessingEndDate.Text, "d/M/yyyy", Globalization.CultureInfo.InvariantCulture, Globalization.DateTimeStyles.None)
        End If
        Dim nFlowDirection As Integer = ddDataFlowDirection.SelectedValue
        Dim nNumberOfRecords As Integer = ddNumberOfRecords.SelectedValue

        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        Dim nInserted As Integer = taq.DataFlowDetail_Insert(nSummaryID,
                                                             tbDFDIdentifier.Text,
                                                             nFlowDirection,
                                                             nNumberOfRecords,
                                                             ddFrequencyOfTransfer.SelectedValue,
                                                             tbFrequencyOther.Text, "",
                                                             tbFairProcessingURL.Text,
                                                             tbConsentExemption.Text,
                                                             tbPrivacyNoticeAmends.Text,
                                                             tbDPAChecksForAsset.Text,
                                                             rblThirdPartContractIGClauses.SelectedValue,
                                                             tbNonEEADataCountryOrigin.Text,
                                                             tbNonEEADataCountryDestinsation.Text,
                                                             dtStart,
                                                             dtEnd,
                                                             tbNonEEACountryLaws.Text,
                                                             tbNonEEACountryObligations.Text,
                                                             tbNonEEACountryCoCo.Text,
                                                             tbNonEEASecurityMeasures.Text,
                                                             currentUserId,
                                                             Session("UserOrganisationID"),
                                                             ddDFDTransferSystemPlatform.SelectedValue,
                                                             sDFDBusinessContinuityCSV,
                                                             sDFDConsentModelCSV,
                                                             sDFDDisasterRecoveryCSV,
                                                             sDFDElectronicAccessedOnSiteCSV,
                                                             sDFDElectronicByAutomatedCSV,
                                                             sDFDElectronicByEmailCSV,
                                                             sDFDElectronicByManualCSV,
                                                             sDFDElectronicViaTextCSV,
                                                             sDFDIncidentManagementCSV,
                                                             sDFDNonEEAExemptionsDerogationsCSV,
                                                             sDFDPaperByCourierCSV,
                                                             sDFDPaperByFaxCSV,
                                                             sDFDPaperByStaffCSV,
                                                             sDFDPaperByDataSubjectCSV,
                                                             sDFDPaperByStandardPostCSV,
                                                             sDFDPoliciesProcessesSOPsCSV,
                                                             sDFDPrivacyChangesCSV,
                                                             sDFDRemovableByStaffCSV,
                                                             sDFDRemovableByStaffCSV,
                                                             sDFDRemovableByStandardPostCSV,
                                                             sDFDRetentionDisposalCSV,
                                                             sDFDStorageAfterTransferCSV,
                                                             sDFDSubjectAccessRequestsCSV,
                                                             sDFDTrainingSystemDataCSV,
                                                             sDFDUptodateAccurateCompleteCSV,
                                                             sDFDWhatTransferredCSV,
                                                             sDFDSecuredAfterTransferCSV,
                                                             sDFDAccessedAfterTransferCSV,
                                                             sDFDSecuredReceivingOrgCSV,
                                                             sDFDOrganisationsCSV,
                                                             sDFDInformationByVoiceCSV,
                                                             sDFDPersonalDataItemsCSV,
                                                             ddPrivacyStatus.SelectedValue,
                                                             tbDFSpecificLegalGateways.Text)
        If nInserted > 0 Then
            Session("FlowDetailID") = nInserted
            Dim taq2 As New ispdatasetTableAdapters.QueriesTableAdapter
            taq2.FileGroups_UpdateID(nInserted, hfFlowFileGroupID.Value)
            taq2.FileGroups_UpdateID(nInserted, hfFlowDocsFileGroupID.Value)
            'update the contact group with the asset id:
            If hfDADataFlowContact.Value > 0 Then

                taq2.isp_DataFlowContactGroup_UpdateFlowID(nInserted, hfDADataFlowContact.Value)
            End If
            lblModalHeading.Text = "Data Flow Detail Added"
            Me.lblModalText.Text = "Your data flow details have been saved successfully."
            lbtAddedReturn.PostBackUrl = "~/application/summaries_list.aspx"
            ViewState("Reload") = True
            hfFlowDetailID.Value = nInserted
            lbtOKLoadForEdit.PostBackUrl = "~/application/dataflow_detail.aspx?Action=Edit"
            ShowMessage(True)
        ElseIf nInserted = -10 Then
            lblModalHeading.Text = "Data Flow Identifier Must Be Unique"
            Me.lblModalText.Text = "Your data flow details were not saved successfully. Another data flow already exists with the same name / identifier."
            lbtAddedReturn.PostBackUrl = "~/application/summaries_list.aspx"
            ShowMessage(False)
        End If
    End Sub
    Protected Sub ShowMessage(Optional ByVal ShowOptions As Boolean = False)
        If ShowOptions Then
            lbtAddedReturn.Visible = True
            lbtOKLoadForEdit.Visible = True
            ModalOK.Visible = False
        Else
            lbtAddedReturn.Visible = False
            lbtOKLoadForEdit.Visible = False
            ModalOK.Visible = True
        End If
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalMessage", "<script>$('#modalMessage').modal('show');</script>")
        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalMessage", "$('#modalMessage').modal('show');", True)
    End Sub
    Protected Sub LoadDetail(ByVal dfdid As Integer)
        Session("DFLoaded") = False
        Dim taDFD As New DataFlowDetailTableAdapters.isp_DataFlowDetailTableAdapter
        Dim tDFD As New DataFlowDetail.isp_DataFlowDetailDataTable
        tDFD = taDFD.GetByDFDID(dfdid)

        lblAddedByOrganisation.Text = tDFD.First.OrganisationName
        hfInDraft.Value = tDFD.First.InDraft
        If Not CBool(tDFD.First.InDraft) And lblDFStatus.Text <> "Signed" Then
            lblDFStatus.Text = "Final"
        End If


        ddPrivacyStatus.SelectedValue = tDFD.First.PrivacyStatusID



        tbDFDIdentifier.Text = tDFD.First.DFDIdentifier
        lblDFSubHeader.Text = PadID(tDFD.First.DataFlowDetailID) & " " & tDFD.First.DFDIdentifier
        tbFrequencyOther.Text = tDFD.First.FrequencyOther
        tbFairProcessingURL.Text = tDFD.First.FairProccessingURL
        tbConsentExemption.Text = tDFD.First.ConsentExemption
        tbPrivacyNoticeAmends.Text = tDFD.First.PrivacyNoticeAmends
        tbDPAChecksForAsset.Text = tDFD.First.DPAChecksForAsset
        tbNonEEADataCountryOrigin.Text = tDFD.First.NonEEADataCountryOrigin
        tbNonEEADataCountryDestinsation.Text = tDFD.First.NonEEADataCountryDestinsation
        Dim dDateStart As System.Nullable(Of DateTime) = Nothing
        If Not tDFD.First.IsNonEEAProcessingStartDateNull() Then
            dDateStart = tDFD.First.NonEEAProcessingStartDate
            tbNonEEAProcessingStartDate.Text = dDateStart.ToString().Substring(0, 10)
        End If
        Dim dDateEnd As System.Nullable(Of DateTime) = Nothing
        If Not tDFD.First.IsNonEEAProcessingEndDateNull() Then
            dDateEnd = tDFD.First.NonEEAProcessingEndDate
            tbNonEEAProcessingEndDate.Text = dDateEnd.ToString().Substring(0, 10)
        End If
        tbNonEEACountryLaws.Text = tDFD.First.NonEEACountryLaws
        tbNonEEACountryObligations.Text = tDFD.First.NonEEACountryObligations
        tbNonEEACountryCoCo.Text = tDFD.First.NonEEACountryCoCo
        tbNonEEASecurityMeasures.Text = tDFD.First.NonEEASecurityMeasures
        lbtDocuments.Text = "Additional Documents (" & tDFD.First.AdditionalDocs.ToString & ")"
        'The following values will be stored in hiddenfields for now and applied as selected values after databinding of the appropriate drop downs.
        hfFlowDirection.Value = tDFD.First.DataFlowDirection
        hfFrequency.Value = tDFD.First.FrequencyOfTransfer
        hfNumberOfRecords.Value = tDFD.First.NumberOfRecords
        hfTransferSystemPlatform.Value = tDFD.First.DFDTransferSystemPlatformID

        'Dim nNumRecs As Integer = tDFD.First.NumberOfRecords
        'If nNumRecs < 11 Then nNumRecs = nNumRecs + 10
        'ddNumberOfRecords.SelectedValue = nNumRecs
        If Not ddDFDTransferSystemPlatform.Items.FindByValue(tDFD.First.DFDTransferSystemPlatformID) Is Nothing Then
            ddDFDTransferSystemPlatform.SelectedValue = tDFD.First.DFDTransferSystemPlatformID
        End If



        rblThirdPartContractIGClauses.SelectedValue = tDFD.First.ThirdPartContractIGClauses
        tbDFSpecificLegalGateways.Text = tDFD.First.FlowLegalGateways
        If tDFD.First.DataFlowDirection = 5 Or tDFD.First.DataFlowDirection = 10 Then
            rblOutsideEEA.SelectedValue = 1
            pnlOutsideEAA.Visible = True
        Else
            rblOutsideEEA.SelectedValue = 0
            pnlOutsideEAA.Visible = False
        End If
        'Load up checkboxes
        Dim taWhatTransferred As New DataFlowDetailTableAdapters.isp_DFD_DFDWhatTransferredTableAdapter
        Dim tWhatTransferred As New DataFlowDetail.isp_DFD_DFDWhatTransferredDataTable
        tWhatTransferred = taWhatTransferred.GetByDataFlowDetailID(dfdid)
        For Each r As DataRow In tWhatTransferred.Rows
            Select Case r.Item("DFDWhatTransferredID")
                Case 1
                    cbDFDPaperByCourier.Checked = True
                    divDFDPaperByCourier.Visible = True
                Case 2
                    cbDFDPaperByStaff.Checked = True
                    divDFDPaperByStaff.Visible = True
                Case 3
                    cbDFDPaperByStandardPost.Checked = True
                    divDFDPaperByStandardPost.Visible = True
                Case 4
                    cbDFDPaperByFax.Checked = True
                    divDFDPaperByFax.Visible = True
                Case 5
                    cbDFDPaperByDataSubject.Checked = True
                    divDFDPaperByDataSubject.Visible = True
                Case 6
                    cbDFDRemovableByStaff.Checked = True
                    divDFDRemovableByStaff.Visible = True
                Case 7
                    cbDFDRemovableByStandardPost.Checked = True
                    divDFDRemovableByStandardPost.Visible = True
                Case 8
                    cbDFDElectronicByEmail.Checked = True
                    divDFDElectronicByEmail.Visible = True
                Case 9
                    cbDFDElectronicByAutomated.Checked = True
                    divDFDElectronicByAutomated.Visible = True
                Case 10
                    cbDFDElectronicByManual.Checked = True
                    divDFDElectronicByManual.Visible = True
                Case 11
                    cbDFDElectronicAccessedOnSite.Checked = True
                    divDFDElectronicAccessedOnSite.Visible = True
                Case 12
                    cbDFDElectronicViaText.Checked = True
                    divDFDElectronicViaText.Visible = True
                Case 13
                    cbDFDInformationByVoice.Checked = True
                    divDFDInformationByVoice.Visible = True
            End Select
        Next
        DoDPOReviewVis()
    End Sub

    Private Sub lbtUpdateDataFlow_Click(sender As Object, e As EventArgs) Handles lbtUpdateDataFlow.Click
        Dim nUpdated As Integer = UpdateDataFlow()
        If nUpdated > 0 Then
            'check if pdf exists on server and remove:
            RemovePDFIfExists()
            lblModalHeading.Text = "Data Flow Detail Updated"
            Me.lblModalText.Text = "Your data flow details have been saved successfully."
            lbtAddedReturn.PostBackUrl = "~/application/summaries_list.aspx"
            ShowMessage(True)
        ElseIf nUpdated = 0 Then
            lblModalHeading.Text = "Data Flow Detail Not Updated"
            Me.lblModalText.Text = "No changes were made to the data flow."
            lbtAddedReturn.PostBackUrl = "~/application/summaries_list.aspx"
            ShowMessage(False)
        ElseIf nUpdated = -10 Then
            lblModalHeading.Text = "Data Flow Identifier Must Be Unique"
            Me.lblModalText.Text = "Your data flow details were not saved successfully. Another data flow already exists with the same name / identifier."
            lbtAddedReturn.PostBackUrl = "~/application/summaries_list.aspx"
            ShowMessage(False)
        Else
            lblModalHeading.Text = "Data Flow Detail Not Updated"
            Me.lblModalText.Text = "Your data flow details were not saved successfully."
            lbtAddedReturn.PostBackUrl = "~/application/summaries_list.aspx"
            ShowMessage(False)

        End If
    End Sub
    Protected Sub RemovePDFIfExists()
        Dim nFlowID As Integer = CInt(hfFlowDetailID.Value)
        Dim pdfName As String = Server.MapPath("~/application/pdfout/") + "DPIA_ISA_" & nFlowID.ToString & ".pdf"
        If File.Exists(pdfName) Then
            File.Delete(pdfName)
        End If
    End Sub
    Protected Function UpdateDataFlow() As Integer
        Dim nUpdated As Integer = -1

        If Not Session("DFLoaded") Is Nothing Then

            Dim sDFDWhatTransferredCSV As String = ""
            Dim sDFDPaperByCourierCSV As String = ""
            Dim sDFDPaperByStaffCSV As String = ""
            Dim sDFDPaperByStandardPostCSV As String = ""
            Dim sDFDPaperByFaxCSV As String = ""
            Dim sDFDPaperByDataSubjectCSV As String = ""
            Dim sDFDRemovableByStaffCSV As String = ""
            Dim sDFDRemovableByStandardPostCSV As String = ""
            Dim sDFDElectronicByEmailCSV As String = ""
            Dim sDFDElectronicByAutomatedCSV As String = ""
            Dim sDFDElectronicByManualCSV As String = ""
            Dim sDFDElectronicAccessedOnSiteCSV As String = ""
            Dim sDFDElectronicViaTextCSV As String = ""
            Dim sDFDInformationByVoiceCSV As String = ""
            Dim sDFDStorageAfterTransferCSV As String = ""
            Dim sDFDSecuredAfterTransferCSV As String = ""
            Dim sDFDAccessedAfterTransferCSV As String = ""
            Dim sDFDPrivacyChangesCSV As String = ""
            Dim sDFDConsentModelCSV As String = ""
            Dim sDFDUptodateAccurateCompleteCSV As String = ""
            Dim sDFDRetentionDisposalCSV As String = ""
            Dim sDFDSubjectAccessRequestsCSV As String = ""
            Dim sDFDPoliciesProcessesSOPsCSV As String = ""
            Dim sDFDIncidentManagementCSV As String = ""
            Dim sDFDTrainingSystemDataCSV As String = ""
            Dim sDFDSecuredReceivingOrgCSV As String = ""
            Dim sDFDBusinessContinuityCSV As String = ""
            Dim sDFDDisasterRecoveryCSV As String = ""
            Dim sDFDNonEEAExemptionsDerogationsCSV As String = ""
            Dim sDFDOrganisationsCSV As String = ""
            Dim sDFDPersonalDataItemsCSV As String = ""
            ' the following is done using hard coded values to make up the what transfered CSV string because the checkboxes are also hard-coded. This isn't ideal.
            If cbDFDPaperByCourier.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "1, "
            End If
            If cbDFDPaperByStaff.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "2, "
            End If
            If cbDFDPaperByStandardPost.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "3, "
            End If
            If cbDFDPaperByFax.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "4, "
            End If
            If cbDFDPaperByDataSubject.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "5, "
            End If
            If cbDFDRemovableByStaff.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "6, "
            End If
            If cbDFDRemovableByStandardPost.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "7, "
            End If
            If cbDFDElectronicByEmail.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "8, "
            End If
            If cbDFDElectronicByAutomated.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "9, "
            End If
            If cbDFDElectronicByManual.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "10, "
            End If
            If cbDFDElectronicAccessedOnSite.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "11, "
            End If
            If cbDFDElectronicViaText.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "12, "
            End If
            If cbDFDInformationByVoice.Checked Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV + "13, "
            End If

            If sDFDWhatTransferredCSV.Length > 2 Then
                sDFDWhatTransferredCSV = sDFDWhatTransferredCSV.Substring(0, sDFDWhatTransferredCSV.Length - 2)
            End If
            'Generate PaperByCourier CSV
            For Each li As ListItem In listDFDPaperByCourier.Items
                If li.Selected Then
                    sDFDPaperByCourierCSV = sDFDPaperByCourierCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDPaperByCourierCSV.Length > 2 Then
                sDFDPaperByCourierCSV = sDFDPaperByCourierCSV.Substring(0, sDFDPaperByCourierCSV.Length - 2)
            End If
            'Generate PaperByStaff CSV
            For Each li As ListItem In listDFDPaperByStaff.Items
                If li.Selected Then
                    sDFDPaperByStaffCSV = sDFDPaperByStaffCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDPaperByStaffCSV.Length > 2 Then
                sDFDPaperByStaffCSV = sDFDPaperByStaffCSV.Substring(0, sDFDPaperByStaffCSV.Length - 2)
            End If
            'Generate PaperByStandardPost CSV
            For Each li As ListItem In listDFDPaperByStandardPost.Items
                If li.Selected Then
                    sDFDPaperByStandardPostCSV = sDFDPaperByStandardPostCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDPaperByStandardPostCSV.Length > 2 Then
                sDFDPaperByStandardPostCSV = sDFDPaperByStandardPostCSV.Substring(0, sDFDPaperByStandardPostCSV.Length - 2)
            End If
            'Generate PaperByFax CSV
            For Each li As ListItem In listDFDPaperByFax.Items
                If li.Selected Then
                    sDFDPaperByFaxCSV = sDFDPaperByFaxCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDPaperByFaxCSV.Length > 2 Then
                sDFDPaperByFaxCSV = sDFDPaperByFaxCSV.Substring(0, sDFDPaperByFaxCSV.Length - 2)
            End If
            'Generate PaperByDataSubject CSV
            For Each li As ListItem In listDFDPaperByDataSubject.Items
                If li.Selected Then
                    sDFDPaperByDataSubjectCSV = sDFDPaperByDataSubjectCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDPaperByDataSubjectCSV.Length > 2 Then
                sDFDPaperByDataSubjectCSV = sDFDPaperByDataSubjectCSV.Substring(0, sDFDPaperByDataSubjectCSV.Length - 2)
            End If
            'Generate RemovableByStaff CSV
            For Each li As ListItem In listDFDRemovableByStaff.Items
                If li.Selected Then
                    sDFDRemovableByStaffCSV = sDFDRemovableByStaffCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDRemovableByStaffCSV.Length > 2 Then
                sDFDRemovableByStaffCSV = sDFDRemovableByStaffCSV.Substring(0, sDFDRemovableByStaffCSV.Length - 2)
            End If
            'Generate RemovableByStandardPost CSV
            For Each li As ListItem In listDFDRemovableByStandardPost.Items
                If li.Selected Then
                    sDFDRemovableByStandardPostCSV = sDFDRemovableByStandardPostCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDRemovableByStandardPostCSV.Length > 2 Then
                sDFDRemovableByStandardPostCSV = sDFDRemovableByStandardPostCSV.Substring(0, sDFDRemovableByStandardPostCSV.Length - 2)
            End If
            'Generate ElectronicByEmail CSV
            For Each li As ListItem In listDFDElectronicByEmail.Items
                If li.Selected Then
                    sDFDElectronicByEmailCSV = sDFDElectronicByEmailCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDElectronicByEmailCSV.Length > 2 Then
                sDFDElectronicByEmailCSV = sDFDElectronicByEmailCSV.Substring(0, sDFDElectronicByEmailCSV.Length - 2)
            End If
            'Generate ElectronicByAutomated CSV
            For Each li As ListItem In listDFDElectronicByAutomated.Items
                If li.Selected Then
                    sDFDElectronicByAutomatedCSV = sDFDElectronicByAutomatedCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDElectronicByAutomatedCSV.Length > 2 Then
                sDFDElectronicByAutomatedCSV = sDFDElectronicByAutomatedCSV.Substring(0, sDFDElectronicByAutomatedCSV.Length - 2)
            End If
            'Generate ElectronicByManual CSV
            For Each li As ListItem In listDFDElectronicByManual.Items
                If li.Selected Then
                    sDFDElectronicByManualCSV = sDFDElectronicByManualCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDElectronicByManualCSV.Length > 2 Then
                sDFDElectronicByManualCSV = sDFDElectronicByManualCSV.Substring(0, sDFDElectronicByManualCSV.Length - 2)
            End If
            'Generate ElectronicAccessedOnSite CSV
            For Each li As ListItem In listDFDElectronicAccessedOnSite.Items
                If li.Selected Then
                    sDFDElectronicAccessedOnSiteCSV = sDFDElectronicAccessedOnSiteCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDElectronicAccessedOnSiteCSV.Length > 2 Then
                sDFDElectronicAccessedOnSiteCSV = sDFDElectronicAccessedOnSiteCSV.Substring(0, sDFDElectronicAccessedOnSiteCSV.Length - 2)
            End If
            'Generate ElectronicViaText CSV
            For Each li As ListItem In listDFDElectronicViaText.Items
                If li.Selected Then
                    sDFDElectronicViaTextCSV = sDFDElectronicViaTextCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDElectronicViaTextCSV.Length > 2 Then
                sDFDElectronicViaTextCSV = sDFDElectronicViaTextCSV.Substring(0, sDFDElectronicViaTextCSV.Length - 2)
            End If
            'Generate InformationByVoice CSV
            For Each li As ListItem In listDFDInformationByVoice.Items
                If li.Selected Then
                    sDFDInformationByVoiceCSV = sDFDInformationByVoiceCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDInformationByVoiceCSV.Length > 2 Then
                sDFDInformationByVoiceCSV = sDFDInformationByVoiceCSV.Substring(0, sDFDInformationByVoiceCSV.Length - 2)
            End If
            'Generate StorageAfterTransfer CSV
            For Each li As ListItem In listDFDStorageAfterTransfer.Items
                If li.Selected Then
                    sDFDStorageAfterTransferCSV = sDFDStorageAfterTransferCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDStorageAfterTransferCSV.Length > 2 Then
                sDFDStorageAfterTransferCSV = sDFDStorageAfterTransferCSV.Substring(0, sDFDStorageAfterTransferCSV.Length - 2)
            End If
            'Generate SecuredAfterTransfer CSV
            For Each li As ListItem In listDFDSecuredAfterTransfer.Items
                If li.Selected Then
                    sDFDSecuredAfterTransferCSV = sDFDSecuredAfterTransferCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDSecuredAfterTransferCSV.Length > 2 Then
                sDFDSecuredAfterTransferCSV = sDFDSecuredAfterTransferCSV.Substring(0, sDFDSecuredAfterTransferCSV.Length - 2)
            End If
            'Generate AccessedAfterTransfer CSV
            For Each li As ListItem In listDFDAccessedAfterTransfer.Items
                If li.Selected Then
                    sDFDAccessedAfterTransferCSV = sDFDAccessedAfterTransferCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDAccessedAfterTransferCSV.Length > 2 Then
                sDFDAccessedAfterTransferCSV = sDFDAccessedAfterTransferCSV.Substring(0, sDFDAccessedAfterTransferCSV.Length - 2)
            End If
            'Generate PrivacyChanges CSV
            For Each li As ListItem In listDFDPrivacyChanges.Items
                If li.Selected Then
                    sDFDPrivacyChangesCSV = sDFDPrivacyChangesCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDPrivacyChangesCSV.Length > 2 Then
                sDFDPrivacyChangesCSV = sDFDPrivacyChangesCSV.Substring(0, sDFDPrivacyChangesCSV.Length - 2)
            End If
            'Generate ConsentModel CSV
            For Each li As ListItem In listDFDConsentModel.Items
                If li.Selected Then
                    sDFDConsentModelCSV = sDFDConsentModelCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDConsentModelCSV.Length > 2 Then
                sDFDConsentModelCSV = sDFDConsentModelCSV.Substring(0, sDFDConsentModelCSV.Length - 2)
            End If
            'Generate UptodateAccurateComplete CSV
            For Each li As ListItem In listDFDUptodateAccurateComplete.Items
                If li.Selected Then
                    sDFDUptodateAccurateCompleteCSV = sDFDUptodateAccurateCompleteCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDUptodateAccurateCompleteCSV.Length > 2 Then
                sDFDUptodateAccurateCompleteCSV = sDFDUptodateAccurateCompleteCSV.Substring(0, sDFDUptodateAccurateCompleteCSV.Length - 2)
            End If
            'Generate RetentionDisposal CSV
            For Each li As ListItem In listDFDRetentionDisposal.Items
                If li.Selected Then
                    sDFDRetentionDisposalCSV = sDFDRetentionDisposalCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDRetentionDisposalCSV.Length > 2 Then
                sDFDRetentionDisposalCSV = sDFDRetentionDisposalCSV.Substring(0, sDFDRetentionDisposalCSV.Length - 2)
            End If
            'Generate SubjectAccessRequests CSV
            For Each li As ListItem In listDFDSubjectAccessRequests.Items
                If li.Selected Then
                    sDFDSubjectAccessRequestsCSV = sDFDSubjectAccessRequestsCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDSubjectAccessRequestsCSV.Length > 2 Then
                sDFDSubjectAccessRequestsCSV = sDFDSubjectAccessRequestsCSV.Substring(0, sDFDSubjectAccessRequestsCSV.Length - 2)
            End If
            'Generate PoliciesProcessesSOPs CSV
            For Each li As ListItem In listDFDPoliciesProcessesSOPs.Items
                If li.Selected Then
                    sDFDPoliciesProcessesSOPsCSV = sDFDPoliciesProcessesSOPsCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDPoliciesProcessesSOPsCSV.Length > 2 Then
                sDFDPoliciesProcessesSOPsCSV = sDFDPoliciesProcessesSOPsCSV.Substring(0, sDFDPoliciesProcessesSOPsCSV.Length - 2)
            End If
            'Generate IncidentManagement CSV
            For Each li As ListItem In listDFDIncidentManagement.Items
                If li.Selected Then
                    sDFDIncidentManagementCSV = sDFDIncidentManagementCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDIncidentManagementCSV.Length > 2 Then
                sDFDIncidentManagementCSV = sDFDIncidentManagementCSV.Substring(0, sDFDIncidentManagementCSV.Length - 2)
            End If
            'Generate TrainingSystemData CSV
            For Each li As ListItem In listDFDTrainingSystemData.Items
                If li.Selected Then
                    sDFDTrainingSystemDataCSV = sDFDTrainingSystemDataCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDTrainingSystemDataCSV.Length > 2 Then
                sDFDTrainingSystemDataCSV = sDFDTrainingSystemDataCSV.Substring(0, sDFDTrainingSystemDataCSV.Length - 2)
            End If
            'Generate SecuredReceivingOrg CSV
            For Each li As ListItem In listDFDSecuredReceivingOrg.Items
                If li.Selected Then
                    sDFDSecuredReceivingOrgCSV = sDFDSecuredReceivingOrgCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDSecuredReceivingOrgCSV.Length > 2 Then
                sDFDSecuredReceivingOrgCSV = sDFDSecuredReceivingOrgCSV.Substring(0, sDFDSecuredReceivingOrgCSV.Length - 2)
            End If
            'Generate BusinessContinuity CSV
            For Each li As ListItem In listDFDBusinessContinuity.Items
                If li.Selected Then
                    sDFDBusinessContinuityCSV = sDFDBusinessContinuityCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDBusinessContinuityCSV.Length > 2 Then
                sDFDBusinessContinuityCSV = sDFDBusinessContinuityCSV.Substring(0, sDFDBusinessContinuityCSV.Length - 2)
            End If
            'Generate DisasterRecovery CSV
            For Each li As ListItem In listDFDDisasterRecovery.Items
                If li.Selected Then
                    sDFDDisasterRecoveryCSV = sDFDDisasterRecoveryCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDDisasterRecoveryCSV.Length > 2 Then
                sDFDDisasterRecoveryCSV = sDFDDisasterRecoveryCSV.Substring(0, sDFDDisasterRecoveryCSV.Length - 2)
            End If
            'Generate NonEEAExemptionsDerogations CSV
            For Each li As ListItem In listDFDNonEEAExemptionsDerogations.Items
                If li.Selected Then
                    sDFDNonEEAExemptionsDerogationsCSV = sDFDNonEEAExemptionsDerogationsCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDNonEEAExemptionsDerogationsCSV.Length > 2 Then
                sDFDNonEEAExemptionsDerogationsCSV = sDFDNonEEAExemptionsDerogationsCSV.Substring(0, sDFDNonEEAExemptionsDerogationsCSV.Length - 2)
            End If
            'Generate Organisation CSV
            For Each li As ListItem In listOrganisations.Items
                If li.Selected Then
                    sDFDOrganisationsCSV = sDFDOrganisationsCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDOrganisationsCSV.Length > 2 Then
                sDFDOrganisationsCSV = sDFDOrganisationsCSV.Substring(0, sDFDOrganisationsCSV.Length - 2)
            End If
            'Generate PID Items CSV
            For Each li As ListItem In listDFDPersonalItems.Items
                If li.Selected Then
                    sDFDPersonalDataItemsCSV = sDFDPersonalDataItemsCSV + li.Value.ToString() + ", "
                End If
            Next
            For Each li As ListItem In listDFDPersonalSensitiveItems.Items
                If li.Selected Then
                    sDFDPersonalDataItemsCSV = sDFDPersonalDataItemsCSV + li.Value.ToString() + ", "
                End If
            Next
            If sDFDPersonalDataItemsCSV.Length > 2 Then
                sDFDPersonalDataItemsCSV = sDFDPersonalDataItemsCSV.Substring(0, sDFDPersonalDataItemsCSV.Length - 2)
            End If
            Dim currentUser As MembershipUser = Membership.GetUser()
            Dim currentUserId As Guid = DirectCast(currentUser.ProviderUserKey, Guid)
            Dim dtStart As Nullable(Of DateTime)
            If tbNonEEAProcessingStartDate.Text.Length = 0 Then
                dtStart = Nothing
            Else
                dtStart = DateTime.ParseExact(tbNonEEAProcessingStartDate.Text, "d/M/yyyy", Globalization.CultureInfo.InvariantCulture, Globalization.DateTimeStyles.None)
            End If
            Dim dtEnd As Nullable(Of DateTime)
            If tbNonEEAProcessingEndDate.Text.Length = 0 Then
                dtEnd = Nothing
            Else
                dtEnd = DateTime.ParseExact(tbNonEEAProcessingEndDate.Text, "d/M/yyyy", Globalization.CultureInfo.InvariantCulture, Globalization.DateTimeStyles.None)
            End If
            Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
            nUpdated = taq.DataFlowDetail_Update(hfFlowDetailID.Value,
                                                                tbDFDIdentifier.Text,
                                                                 ddDataFlowDirection.SelectedValue,
                                                                 ddNumberOfRecords.SelectedValue,
                                                                 ddFrequencyOfTransfer.SelectedValue,
                                                                 tbFrequencyOther.Text,
                                                                 tbFairProcessingURL.Text,
                                                                 tbConsentExemption.Text,
                                                                 tbPrivacyNoticeAmends.Text,
                                                                 tbDPAChecksForAsset.Text,
                                                                 rblThirdPartContractIGClauses.SelectedValue,
                                                                 tbNonEEADataCountryOrigin.Text,
                                                                 tbNonEEADataCountryDestinsation.Text,
                                                                 dtStart,
                                                                 dtEnd,
                                                                 tbNonEEACountryLaws.Text,
                                                                 tbNonEEACountryObligations.Text,
                                                                 tbNonEEACountryCoCo.Text,
                                                                 tbNonEEASecurityMeasures.Text,
                                                                 currentUserId,
                                                                 Session("UserOrganisationID"),
            ddDFDTransferSystemPlatform.SelectedValue,
                                                                 sDFDBusinessContinuityCSV,
                                                                 sDFDConsentModelCSV,
                                                                 sDFDDisasterRecoveryCSV,
                                                                 sDFDElectronicAccessedOnSiteCSV,
                                                                 sDFDElectronicByAutomatedCSV,
                                                                 sDFDElectronicByEmailCSV,
                                                                 sDFDElectronicByManualCSV,
                                                                 sDFDElectronicViaTextCSV,
                                                                 sDFDIncidentManagementCSV,
                                                                 sDFDNonEEAExemptionsDerogationsCSV,
                                                                 sDFDPaperByCourierCSV,
                                                                 sDFDPaperByFaxCSV,
                                                                 sDFDPaperByStaffCSV,
                                                                 sDFDPaperByDataSubjectCSV,
                                                                 sDFDPaperByStandardPostCSV,
                                                                 sDFDPoliciesProcessesSOPsCSV,
                                                                 sDFDPrivacyChangesCSV,
                                                                 sDFDRemovableByStaffCSV,
                                                                 sDFDRemovableByStaffCSV,
                                                                 sDFDRemovableByStandardPostCSV,
                                                                 sDFDRetentionDisposalCSV,
                                                                 sDFDStorageAfterTransferCSV,
                                                                 sDFDSubjectAccessRequestsCSV,
                                                                 sDFDTrainingSystemDataCSV,
                                                                 sDFDUptodateAccurateCompleteCSV,
                                                                 sDFDWhatTransferredCSV,
                                                                 sDFDSecuredAfterTransferCSV,
                                                                 sDFDAccessedAfterTransferCSV,
                                                                 sDFDSecuredReceivingOrgCSV,
                                                 sDFDPersonalDataItemsCSV,
                                                                 sDFDOrganisationsCSV,
                                                                 CBool(Session("DFLoaded")),
                                                                sDFDInformationByVoiceCSV,
                                                 ddPrivacyStatus.SelectedValue,
                                                 tbDFSpecificLegalGateways.Text)
        End If
        If nUpdated > 0 Then
            bsgvAuditHistory.DataBind()
        End If
        Return nUpdated
    End Function
    Private Sub listOrganisations_DataBound(sender As Object, e As EventArgs) Handles listOrganisations.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up Organisations selections:
            Dim taOrganisations As New DataFlowDetailTableAdapters.isp_DFD_DFDOrganisationsTableAdapter
            Dim tOrganisations As New DataFlowDetail.isp_DFD_DFDOrganisationsDataTable
            tOrganisations = taOrganisations.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tOrganisations.Rows
                For Each li As ListItem In listOrganisations.Items
                    If li.Value = r.Item("DF_OrgID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub
    Private Sub listDFDAccessedAfterTransfer_DataBound(sender As Object, e As EventArgs) Handles listDFDAccessedAfterTransfer.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up AccessedAfterTransfer selections:
            Dim taAccessedAfterTransfer As New DataFlowDetailTableAdapters.isp_DFD_DFDAccessedAfterTransferTableAdapter
            Dim tAccessedAfterTransfer As New DataFlowDetail.isp_DFD_DFDAccessedAfterTransferDataTable
            tAccessedAfterTransfer = taAccessedAfterTransfer.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tAccessedAfterTransfer.Rows
                For Each li As ListItem In listDFDAccessedAfterTransfer.Items
                    If li.Value = r.Item("DFDAccessedAfterTransferID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDBusinessContinuity_DataBound(sender As Object, e As EventArgs) Handles listDFDBusinessContinuity.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up BusinessContinuity selections:
            Dim taBusinessContinuity As New DataFlowDetailTableAdapters.isp_DFD_DFDBusinessContinuityTableAdapter
            Dim tBusinessContinuity As New DataFlowDetail.isp_DFD_DFDBusinessContinuityDataTable
            tBusinessContinuity = taBusinessContinuity.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tBusinessContinuity.Rows
                For Each li As ListItem In listDFDBusinessContinuity.Items
                    If li.Value = r.Item("DFDBusinessContinuityID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub
    Private Sub listDFDConsentModel_DataBound(sender As Object, e As EventArgs) Handles listDFDConsentModel.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up ConsentModel selections:
            Dim taConsentModel As New DataFlowDetailTableAdapters.isp_DFD_DFDConsentModelTableAdapter
            Dim tConsentModel As New DataFlowDetail.isp_DFD_DFDConsentModelDataTable
            tConsentModel = taConsentModel.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tConsentModel.Rows
                For Each li As ListItem In listDFDConsentModel.Items
                    If li.Value = r.Item("DFDConsentModelID") Then
                        If li.Text.Contains("Not required") Then
                            tbConsentExemption.Visible = True
                        End If
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDDisasterRecovery_DataBound(sender As Object, e As EventArgs) Handles listDFDDisasterRecovery.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up DisasterRecovery selections:
            Dim taDisasterRecovery As New DataFlowDetailTableAdapters.isp_DFD_DFDDisasterRecoveryTableAdapter
            Dim tDisasterRecovery As New DataFlowDetail.isp_DFD_DFDDisasterRecoveryDataTable
            tDisasterRecovery = taDisasterRecovery.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tDisasterRecovery.Rows
                For Each li As ListItem In listDFDDisasterRecovery.Items
                    If li.Value = r.Item("DFDDisasterRecoveryID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
        Session("DFLoaded") = True
    End Sub

    Private Sub listDFDElectronicAccessedOnSite_DataBound(sender As Object, e As EventArgs) Handles listDFDElectronicAccessedOnSite.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up ElectronicAccessedOnSite selections:
            Dim taElectronicAccessedOnSite As New DataFlowDetailTableAdapters.isp_DFD_DFDElectronicAccessedOnSiteTableAdapter
            Dim tElectronicAccessedOnSite As New DataFlowDetail.isp_DFD_DFDElectronicAccessedOnSiteDataTable
            tElectronicAccessedOnSite = taElectronicAccessedOnSite.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tElectronicAccessedOnSite.Rows
                For Each li As ListItem In listDFDElectronicAccessedOnSite.Items
                    If li.Value = r.Item("DFDElectronicAccessedOnSiteID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDElectronicByAutomated_DataBound(sender As Object, e As EventArgs) Handles listDFDElectronicByAutomated.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up ElectronicByAutomated selections:
            Dim taElectronicByAutomated As New DataFlowDetailTableAdapters.isp_DFD_DFDElectronicByAutomatedTableAdapter
            Dim tElectronicByAutomated As New DataFlowDetail.isp_DFD_DFDElectronicByAutomatedDataTable
            tElectronicByAutomated = taElectronicByAutomated.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tElectronicByAutomated.Rows
                For Each li As ListItem In listDFDElectronicByAutomated.Items
                    If li.Value = r.Item("DFDElectronicByAutomatedID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDElectronicByEmail_DataBound(sender As Object, e As EventArgs) Handles listDFDElectronicByEmail.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up ElectronicByEmail selections:
            Dim taElectronicByEmail As New DataFlowDetailTableAdapters.isp_DFD_DFDElectronicByEmailTableAdapter
            Dim tElectronicByEmail As New DataFlowDetail.isp_DFD_DFDElectronicByEmailDataTable
            tElectronicByEmail = taElectronicByEmail.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tElectronicByEmail.Rows
                For Each li As ListItem In listDFDElectronicByEmail.Items
                    If li.Value = r.Item("DFDElectronicByEmailID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDElectronicByManual_DataBound(sender As Object, e As EventArgs) Handles listDFDElectronicByManual.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up ElectronicByManual selections:
            Dim taElectronicByManual As New DataFlowDetailTableAdapters.isp_DFD_DFDElectronicByManualTableAdapter
            Dim tElectronicByManual As New DataFlowDetail.isp_DFD_DFDElectronicByManualDataTable
            tElectronicByManual = taElectronicByManual.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tElectronicByManual.Rows
                For Each li As ListItem In listDFDElectronicByManual.Items
                    If li.Value = r.Item("DFDElectronicByManualID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDElectronicViaText_DataBound(sender As Object, e As EventArgs) Handles listDFDElectronicViaText.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up ElectronicViaText selections:
            Dim taElectronicViaText As New DataFlowDetailTableAdapters.isp_DFD_DFDElectronicViaTextTableAdapter
            Dim tElectronicViaText As New DataFlowDetail.isp_DFD_DFDElectronicViaTextDataTable
            tElectronicViaText = taElectronicViaText.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tElectronicViaText.Rows
                For Each li As ListItem In listDFDElectronicViaText.Items
                    If li.Value = r.Item("DFDElectronicViaTextID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDIncidentManagement_DataBound(sender As Object, e As EventArgs) Handles listDFDIncidentManagement.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up IncidentManagement selections:
            Dim taIncidentManagement As New DataFlowDetailTableAdapters.isp_DFD_DFDIncidentManagementTableAdapter
            Dim tIncidentManagement As New DataFlowDetail.isp_DFD_DFDIncidentManagementDataTable
            tIncidentManagement = taIncidentManagement.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tIncidentManagement.Rows
                For Each li As ListItem In listDFDIncidentManagement.Items
                    If li.Value = r.Item("DFDIncidentManagementID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDNonEEAExemptionsDerogations_DataBound(sender As Object, e As EventArgs) Handles listDFDNonEEAExemptionsDerogations.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up NonEEAExemptionsDerogations selections:
            Dim taNonEEAExemptionsDerogations As New DataFlowDetailTableAdapters.isp_DFD_DFDNonEEAExemptionsDerogationsTableAdapter
            Dim tNonEEAExemptionsDerogations As New DataFlowDetail.isp_DFD_DFDNonEEAExemptionsDerogationsDataTable
            tNonEEAExemptionsDerogations = taNonEEAExemptionsDerogations.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tNonEEAExemptionsDerogations.Rows
                For Each li As ListItem In listDFDNonEEAExemptionsDerogations.Items
                    If li.Value = r.Item("DFDNonEEAExemptionsDerogationsID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDPaperByCourier_DataBound(sender As Object, e As EventArgs) Handles listDFDPaperByCourier.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up PaperByCourier selections:
            Dim taPaperByCourier As New DataFlowDetailTableAdapters.isp_DFD_DFDPaperByCourierTableAdapter
            Dim tPaperByCourier As New DataFlowDetail.isp_DFD_DFDPaperByCourierDataTable
            tPaperByCourier = taPaperByCourier.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tPaperByCourier.Rows
                For Each li As ListItem In listDFDPaperByCourier.Items
                    If li.Value = r.Item("DFDPaperByCourierID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDPaperByDataSubject_DataBound(sender As Object, e As EventArgs) Handles listDFDPaperByDataSubject.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up PaperByDataSubject selections:
            Dim taPaperByDataSubject As New DataFlowDetailTableAdapters.isp_DFD_DFDPaperByDataSubjectTableAdapter
            Dim tPaperByDataSubject As New DataFlowDetail.isp_DFD_DFDPaperByDataSubjectDataTable
            tPaperByDataSubject = taPaperByDataSubject.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tPaperByDataSubject.Rows
                For Each li As ListItem In listDFDPaperByDataSubject.Items
                    If li.Value = r.Item("DFDPaperByDataSubjectID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDPaperByFax_DataBound(sender As Object, e As EventArgs) Handles listDFDPaperByFax.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up PaperByFax selections:
            Dim taPaperByFax As New DataFlowDetailTableAdapters.isp_DFD_DFDPaperByFaxTableAdapter
            Dim tPaperByFax As New DataFlowDetail.isp_DFD_DFDPaperByFaxDataTable
            tPaperByFax = taPaperByFax.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tPaperByFax.Rows
                For Each li As ListItem In listDFDPaperByFax.Items
                    If li.Value = r.Item("DFDPaperByFaxID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDPaperByStaff_DataBound(sender As Object, e As EventArgs) Handles listDFDPaperByStaff.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up PaperByStaff selections:
            Dim taPaperByStaff As New DataFlowDetailTableAdapters.isp_DFD_DFDPaperByStaffTableAdapter
            Dim tPaperByStaff As New DataFlowDetail.isp_DFD_DFDPaperByStaffDataTable
            tPaperByStaff = taPaperByStaff.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tPaperByStaff.Rows
                For Each li As ListItem In listDFDPaperByStaff.Items
                    If li.Value = r.Item("DFDPaperByStaffID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDPaperByStandardPost_DataBound(sender As Object, e As EventArgs) Handles listDFDPaperByStandardPost.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up PaperByStandardPost selections:
            Dim taPaperByStandardPost As New DataFlowDetailTableAdapters.isp_DFD_DFDPaperByStandardPostTableAdapter
            Dim tPaperByStandardPost As New DataFlowDetail.isp_DFD_DFDPaperByStandardPostDataTable
            tPaperByStandardPost = taPaperByStandardPost.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tPaperByStandardPost.Rows
                For Each li As ListItem In listDFDPaperByStandardPost.Items
                    If li.Value = r.Item("DFDPaperByStandardPostID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDPoliciesProcessesSOPs_DataBound(sender As Object, e As EventArgs) Handles listDFDPoliciesProcessesSOPs.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up PoliciesProcessesSOPs selections:
            Dim taPoliciesProcessesSOPs As New DataFlowDetailTableAdapters.isp_DFD_DFDPoliciesProcessesSOPsTableAdapter
            Dim tPoliciesProcessesSOPs As New DataFlowDetail.isp_DFD_DFDPoliciesProcessesSOPsDataTable
            tPoliciesProcessesSOPs = taPoliciesProcessesSOPs.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tPoliciesProcessesSOPs.Rows
                For Each li As ListItem In listDFDPoliciesProcessesSOPs.Items
                    If li.Value = r.Item("DFDPoliciesProcessesSOPsID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDPrivacyChanges_DataBound(sender As Object, e As EventArgs) Handles listDFDPrivacyChanges.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up PrivacyChanges selections:
            Dim taPrivacyChanges As New DataFlowDetailTableAdapters.isp_DFD_DFDPrivacyChangesTableAdapter
            Dim tPrivacyChanges As New DataFlowDetail.isp_DFD_DFDPrivacyChangesDataTable
            tPrivacyChanges = taPrivacyChanges.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tPrivacyChanges.Rows
                For Each li As ListItem In listDFDPrivacyChanges.Items
                    If li.Value = r.Item("DFDPrivacyChangesID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDRemovableByStaff_DataBound(sender As Object, e As EventArgs) Handles listDFDRemovableByStaff.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up RemovableByStaff selections:
            Dim taRemovableByStaff As New DataFlowDetailTableAdapters.isp_DFD_DFDRemovableByStaffTableAdapter
            Dim tRemovableByStaff As New DataFlowDetail.isp_DFD_DFDRemovableByStaffDataTable
            tRemovableByStaff = taRemovableByStaff.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tRemovableByStaff.Rows
                For Each li As ListItem In listDFDRemovableByStaff.Items
                    If li.Value = r.Item("DFDRemovableByStaffID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDRemovableByStandardPost_DataBound(sender As Object, e As EventArgs) Handles listDFDRemovableByStandardPost.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up RemovableByStandardPost selections:
            Dim taRemovableByStandardPost As New DataFlowDetailTableAdapters.isp_DFD_DFDRemovableByStandardPostTableAdapter
            Dim tRemovableByStandardPost As New DataFlowDetail.isp_DFD_DFDRemovableByStandardPostDataTable
            tRemovableByStandardPost = taRemovableByStandardPost.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tRemovableByStandardPost.Rows
                For Each li As ListItem In listDFDRemovableByStandardPost.Items
                    If li.Value = r.Item("DFDRemovableByStandardPostID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDInformationByVoice_DataBound(sender As Object, e As EventArgs) Handles listDFDInformationByVoice.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up InformationByVoice selections:
            Dim taInformationByVoice As New DataFlowDetailTableAdapters.isp_DFD_DFDInformationByVoiceTableAdapter
            Dim tInformationByVoice As New DataFlowDetail.isp_DFD_DFDInformationByVoiceDataTable
            tInformationByVoice = taInformationByVoice.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tInformationByVoice.Rows
                For Each li As ListItem In listDFDInformationByVoice.Items
                    If li.Value = r.Item("DFDInformationByVoiceID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDRetentionDisposal_DataBound(sender As Object, e As EventArgs) Handles listDFDRetentionDisposal.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up RetentionDisposal selections:
            Dim taRetentionDisposal As New DataFlowDetailTableAdapters.isp_DFD_DFDRetentionDisposalTableAdapter
            Dim tRetentionDisposal As New DataFlowDetail.isp_DFD_DFDRetentionDisposalDataTable
            tRetentionDisposal = taRetentionDisposal.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tRetentionDisposal.Rows
                For Each li As ListItem In listDFDRetentionDisposal.Items
                    If li.Value = r.Item("DFDRetentionDisposalID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDSecuredAfterTransfer_DataBound(sender As Object, e As EventArgs) Handles listDFDSecuredAfterTransfer.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up SecuredAfterTransfer selections:
            Dim taSecuredAfterTransfer As New DataFlowDetailTableAdapters.isp_DFD_DFDSecuredAfterTransferTableAdapter
            Dim tSecuredAfterTransfer As New DataFlowDetail.isp_DFD_DFDSecuredAfterTransferDataTable
            tSecuredAfterTransfer = taSecuredAfterTransfer.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tSecuredAfterTransfer.Rows
                For Each li As ListItem In listDFDSecuredAfterTransfer.Items
                    If li.Value = r.Item("DFDSecuredAfterTransferID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDSecuredReceivingOrg_DataBound(sender As Object, e As EventArgs) Handles listDFDSecuredReceivingOrg.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up SecuredReceivingOrg selections:
            Dim taSecuredReceivingOrg As New DataFlowDetailTableAdapters.isp_DFD_DFDSecuredReceivingOrgTableAdapter
            Dim tSecuredReceivingOrg As New DataFlowDetail.isp_DFD_DFDSecuredReceivingOrgDataTable
            tSecuredReceivingOrg = taSecuredReceivingOrg.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tSecuredReceivingOrg.Rows
                For Each li As ListItem In listDFDSecuredReceivingOrg.Items
                    If li.Value = r.Item("DFDSecuredReceivingOrgID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDStorageAfterTransfer_DataBound(sender As Object, e As EventArgs) Handles listDFDStorageAfterTransfer.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up StorageAfterTransfer selections:
            Dim taStorageAfterTransfer As New DataFlowDetailTableAdapters.isp_DFD_DFDStorageAfterTransferTableAdapter
            Dim tStorageAfterTransfer As New DataFlowDetail.isp_DFD_DFDStorageAfterTransferDataTable
            tStorageAfterTransfer = taStorageAfterTransfer.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tStorageAfterTransfer.Rows
                For Each li As ListItem In listDFDStorageAfterTransfer.Items
                    If li.Value = r.Item("DFDStorageAfterTransferID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDSubjectAccessRequests_DataBound(sender As Object, e As EventArgs) Handles listDFDSubjectAccessRequests.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up SubjectAccessRequests selections:
            Dim taSubjectAccessRequests As New DataFlowDetailTableAdapters.isp_DFD_DFDSubjectAccessRequestsTableAdapter
            Dim tSubjectAccessRequests As New DataFlowDetail.isp_DFD_DFDSubjectAccessRequestsDataTable
            tSubjectAccessRequests = taSubjectAccessRequests.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tSubjectAccessRequests.Rows
                For Each li As ListItem In listDFDSubjectAccessRequests.Items
                    If li.Value = r.Item("DFDSubjectAccessRequestsID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDTrainingSystemData_DataBound(sender As Object, e As EventArgs) Handles listDFDTrainingSystemData.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up TrainingSystemData selections:
            Dim taTrainingSystemData As New DataFlowDetailTableAdapters.isp_DFD_DFDTrainingSystemDataTableAdapter
            Dim tTrainingSystemData As New DataFlowDetail.isp_DFD_DFDTrainingSystemDataDataTable
            tTrainingSystemData = taTrainingSystemData.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tTrainingSystemData.Rows
                For Each li As ListItem In listDFDTrainingSystemData.Items
                    If li.Value = r.Item("DFDTrainingSystemDataID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listDFDUptodateAccurateComplete_DataBound(sender As Object, e As EventArgs) Handles listDFDUptodateAccurateComplete.DataBound
        Dim dfdid As Integer = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        ElseIf Page.Request.Item("Action") = "Copy" Then
            dfdid = hfOriginalDetailID.Value
        End If
        If dfdid > 0 Then
            'Load up UptodateAccurateComplete selections:
            Dim taUptodateAccurateComplete As New DataFlowDetailTableAdapters.isp_DFD_DFDUptodateAccurateCompleteTableAdapter
            Dim tUptodateAccurateComplete As New DataFlowDetail.isp_DFD_DFDUptodateAccurateCompleteDataTable
            tUptodateAccurateComplete = taUptodateAccurateComplete.GetByDataFlowDetailID(dfdid)
            For Each r As DataRow In tUptodateAccurateComplete.Rows
                For Each li As ListItem In listDFDUptodateAccurateComplete.Items
                    If li.Value = r.Item("DFDUptodateAccurateCompleteID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub
    Private Sub listDFDPersonalItems_DataBound(sender As Object, e As EventArgs) Handles listDFDPersonalItems.DataBound
        If listDFDPersonalItems.Items.Count > 0 Then
            Dim dfdid As Integer = 0
            If Page.Request.Item("Action") = "Edit" Then
                dfdid = hfFlowDetailID.Value
            ElseIf Page.Request.Item("Action") = "Copy" Then
                dfdid = hfOriginalDetailID.Value
            End If
            If dfdid > 0 Then
                Dim taPID As New DataFlowDetailTableAdapters.isp_DFD_DFDPIDItemsTableAdapter
                Dim tPID As New DataFlowDetail.isp_DFD_DFDPIDItemsDataTable
                tPID = taPID.GetData(dfdid, False)
                For Each r As DataRow In tPID.Rows
                    For Each li As ListItem In listDFDPersonalItems.Items
                        If li.Value = r.Item("PIDItemsID") Then
                            li.Selected = True
                        End If
                    Next
                Next
            Else
                For Each li As ListItem In listDFDPersonalItems.Items
                    li.Selected = True
                Next
            End If
        End If


    End Sub
    Private Sub listDFDPersonalSensitive_DataBound(sender As Object, e As EventArgs) Handles listDFDPersonalSensitiveItems.DataBound
        If listDFDPersonalSensitiveItems.Items.Count > 0 Then

            Dim dfdid As Integer = 0
            If Page.Request.Item("Action") = "Edit" Then
                dfdid = hfFlowDetailID.Value
            ElseIf Page.Request.Item("Action") = "Copy" Then
                dfdid = hfOriginalDetailID.Value
            End If
            If dfdid > 0 Then
                Dim taPID As New DataFlowDetailTableAdapters.isp_DFD_DFDPIDItemsTableAdapter
                Dim tPID As New DataFlowDetail.isp_DFD_DFDPIDItemsDataTable
                tPID = taPID.GetData(dfdid, True)
                For Each r As DataRow In tPID.Rows
                    For Each li As ListItem In listDFDPersonalSensitiveItems.Items
                        If li.Value = r.Item("PIDItemsID") Then
                            li.Selected = True
                        End If
                    Next
                Next
            Else
                For Each li As ListItem In listDFDPersonalSensitiveItems.Items
                    li.Selected = True
                Next
            End If
        End If


    End Sub

    Private Sub lbtAddConfirm_Click(sender As Object, e As EventArgs) Handles lbtAddConfirm.Click
        Dim dfdid = 0
        If Page.Request.Item("Action") = "Edit" Then
            dfdid = hfFlowDetailID.Value
        End If
        Dim taQ As New ispdatasetTableAdapters.QueriesTableAdapter
        If hfDADataFlowContact.Value = 0 Then

            hfDADataFlowContact.Value = taQ.isp_DataFlowContactGroups_Insert()
            If dfdid > 0 Then
                taQ.isp_DataFlowContactGroup_UpdateFlowID(dfdid, hfDADataFlowContact.Value)
            End If
        End If
        Dim nAdded As Integer = taQ.DataFlowContact_Add(hfDADataFlowContact.Value, tbContactName.Text, tbContactEmail.Text, tbRole.Text, False, tbPhoneNumber.Text)
        If nAdded = -10 Then
            Dim sDomains As String = taQ.GetDomainsCSVShort
            lblModalHeading.Text = "Cannot add Contact - Invalid E-mail Domain"
            Dim sMess = "<p>The contact could not be added because their e-mail address was not from the approved list of ""safe"" domains.</p>"
            sMess = sMess + "<p>Valid e-mail addresses should end with one of the following: <b>" & sDomains & "</b>.</p>"
            lblModalText.Text = sMess
            ShowMessage(False)
        End If
        gvDataFlowContacts.DataBind()
    End Sub

    Private Sub lbtContactAdd_Click(sender As Object, e As EventArgs) Handles lbtContactAdd.Click
        tbContactName.Text = ""
        tbContactEmail.Text = ""
        tbRole.Text = ""
        tbPhoneNumber.Text = ""
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalAddContact", "<script>$('#modalAddcontact').modal('show');</script>")
        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalAddContact", "$('#modalAddcontact').modal('show');", True)
    End Sub

    Private Sub vOutcome_Activate(sender As Object, e As EventArgs) Handles vOutcome.Activate
        Dim dfdid As Integer = hfFlowDetailID.Value
        Dim taRA As New DataFlowDetailTableAdapters.isp_RiskAssessmentTableAdapter
        Dim tRA As New DataFlowDetail.isp_RiskAssessmentDataTable
        lbtDeleteRiskAssessment.Visible = pnlDFD.Enabled
        lbtAddRisk.Visible = pnlDFD.Enabled
        If Session("UserRoleCSO") Then
            lbtAddRisk.Visible = True
        End If
        If Page.Request.Item("Action") = "Edit" And pnlPIA.Enabled Then
            UpdateDataFlow()
            tRA = taRA.GetByDataFlowDetailID(dfdid)
            If tRA.Count = 0 And pnlDFD.Enabled Then
                mvOutcome.SetActiveView(vGenerateAssessment)
            Else
                If tRA.Count > 0 Then
                    Session("RiskAssessmentID") = tRA.First.RiskAssessmentID
                End If
                bsgvRisks.DataBind()
                mvOutcome.SetActiveView(vRiskAssessment)
            End If
        ElseIf pnlPIA.Enabled Then
            mvOutcome.SetActiveView(vSaveFirst)
        Else
            tRA = taRA.GetByDataFlowDetailID(dfdid)
            If tRA.Count > 0 Then
                Session("RiskAssessmentID") = tRA.First.RiskAssessmentID
                bsgvRisks.DataBind()
                mvOutcome.SetActiveView(vRiskAssessment)
            End If
        End If
    End Sub

    Private Sub lbtGenerate_Click(sender As Object, e As EventArgs) Handles lbtGenerate.Click
        Dim currentUser As MembershipUser = Membership.GetUser()
        Dim currentUserId As Guid = DirectCast(currentUser.ProviderUserKey, Guid)
        Dim dfdid = hfFlowDetailID.Value
        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        Dim nRiskAssessment As Integer = taq.GenerateRiskAssessment(dfdid, currentUserId, Session("UserOrganisationID"), CInt(ddAutoGenerateLevel.SelectedValue))
        Session("RiskAssessmentID") = nRiskAssessment
        bsgvRisks.DataBind()
        mvOutcome.SetActiveView(vRiskAssessment)
    End Sub

    Private Sub lbtAddRisk_Click(sender As Object, e As EventArgs) Handles lbtAddRisk.Click
        mvOutcome.SetActiveView(vAddRisk)
    End Sub

    Private Sub fvAddRisk_ItemCommand(sender As Object, e As FormViewCommandEventArgs) Handles fvAddRisk.ItemCommand
        If e.CommandName = "Cancel" Then
            fvAddRisk.DataSource = Nothing
            fvAddRisk.DataBind()
            mvOutcome.SetActiveView(vRiskAssessment)
        End If
    End Sub

    Private Sub fvAddRisk_ItemInserted(sender As Object, e As FormViewInsertedEventArgs) Handles fvAddRisk.ItemInserted
        fvAddRisk.DataSource = Nothing
        fvAddRisk.DataBind()
        'bsgvRisks.DataBind()
        UpdateOverallRisks()
        mvOutcome.SetActiveView(vRiskAssessment)
    End Sub

    Private Sub lbtDeleteRiskAssessment_Click(sender As Object, e As EventArgs) Handles lbtDeleteRiskAssessment.Click
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "modalDeleteRAConfirm", "<script>$('#modalDeleteRAConfirm').modal('show');</script>")
    End Sub

    Private Sub lbtConfirm_Click(sender As Object, e As EventArgs) Handles lbtConfirm.Click
        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        taq.DeleteRiskAssessmentAndRisks(hfFlowDetailID.Value)
        mvOutcome.SetActiveView(vGenerateAssessment)
    End Sub

    Private Sub lbtUpload_Click(sender As Object, e As EventArgs) Handles lbtUpload.Click
        Dim nFlowID = 0
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        If Not hfFlowDetailID.Value Is Nothing Then
            nFlowID = hfFlowDetailID.Value
        End If
        If hfFlowFileGroupID.Value <= 0 Then
            hfFlowFileGroupID.Value = taq.isp_FileGroup_Insert("flow", nFlowID)
        End If

        If filEvidence.PostedFiles.Count > 0 Then
            Dim bShowWarning As Boolean = 0
            Me.lblModalText.Text = ""
            Dim nFileID As Nullable(Of Integer)
            Dim sFilename As String = ""
            For Each pFile As HttpPostedFile In filEvidence.PostedFiles
                'Dim sExtension As String = System.IO.Path.GetExtension(Me.filEvidence.PostedFile.FileName).ToLower()
                sFilename = System.IO.Path.GetFileName(pFile.FileName)
                Dim nMaxKB As Integer = 5120
                If pFile.InputStream.Length > nMaxKB * 1024 Then
                    lblModalHeading.Text = "Error: File too big"
                    Me.lblModalText.Text = Me.lblModalText.Text + "<p>" + sFilename + " is too big. Maximum file size is " + nMaxKB.ToString() + "K." + "</p>"
                    bShowWarning = True
                Else
                    Dim size As Integer = pFile.ContentLength
                    Dim sContentType As String = pFile.ContentType
                    Dim fileData As Byte() = New Byte(size - 1) {}
                    pFile.InputStream.Read(fileData, 0, size)
                    nFileID = taq.InsertFile(sFilename, sContentType, pFile.InputStream.Length / 1024, fileData, Session("UserOrganisationID"), Session("UserEmail"))
                    If nFileID > 0 Then
                        taq.FileGroupFile_Insert(hfFlowFileGroupID.Value, nFileID)
                    Else
                        lblModalHeading.Text = "File upload error"
                        Me.lblModalText.Text = Me.lblModalText.Text + "<p>" + sFilename + " failed to upload due to an unknown error. </p>"
                        bShowWarning = True
                    End If
                End If
            Next
            rptFiles.DataBind()
            If bShowWarning Then
                ShowMessage()
            End If
        End If
    End Sub
    Private Sub lbtUploadFlowDocs_Click(sender As Object, e As EventArgs) Handles lbtUploadFlowDocs.Click
        If Not Session("UserOrganisationID") Is Nothing Then
            Dim nFlowID = 0
            Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
            If Not hfFlowDetailID.Value Is Nothing Then
                nFlowID = hfFlowDetailID.Value
            End If
            If hfFlowDocsFileGroupID.Value <= 0 Then
                hfFlowDocsFileGroupID.Value = taq.isp_FileGroup_Insert("flowdocs", nFlowID)
            End If

            If filFlowDocs.PostedFiles.Count > 0 Then
                Dim bShowWarning As Boolean = 0
                Me.lblModalText.Text = ""
                Dim nFileID As Nullable(Of Integer)
                Dim sFilename As String = ""
                Dim sFileList As String = ""
                For Each pFile As HttpPostedFile In filFlowDocs.PostedFiles
                    'Dim sExtension As String = System.IO.Path.GetExtension(Me.filEvidence.PostedFile.FileName).ToLower()
                    sFilename = System.IO.Path.GetFileName(pFile.FileName)

                    Dim nMaxKB As Integer = 5120
                    If pFile.InputStream.Length > nMaxKB * 1024 Then
                        lblModalHeading.Text = "Error: File too big"
                        Me.lblModalText.Text = Me.lblModalText.Text + "<p>" + sFilename + " is too big. Maximum file size is " + (nMaxKB / 1024).ToString() + "MB." + "</p>"
                        bShowWarning = True
                    Else
                        Dim size As Integer = pFile.ContentLength
                        Dim sContentType As String = pFile.ContentType
                        Dim fileData As Byte() = New Byte(size - 1) {}
                        pFile.InputStream.Read(fileData, 0, size)
                        nFileID = taq.InsertFile(sFilename, sContentType, pFile.InputStream.Length / 1024, fileData, Session("UserOrganisationID"), Session("UserEmail"))
                        If nFileID > 0 Then
                            If sFileList.Length > 0 Then
                                sFileList = sFileList & ", "
                            End If
                            sFileList = sFileList & sFilename & " (ID: " & nFileID.ToString & ")"
                            taq.FileGroupFile_Insert(hfFlowDocsFileGroupID.Value, nFileID)
                        Else
                            lblModalHeading.Text = "File upload error"
                            Me.lblModalText.Text = Me.lblModalText.Text + "<p>" + sFilename + " failed to upload due to an unknown error. </p>"
                            bShowWarning = True
                        End If
                    End If
                Next
                If Not sFileList = "" Then
                    taq.InsertTransactionLogEntry(Membership.GetUser.ProviderUserKey, "isp_DataFlowDetail", "UPLOAD FILES", "FileGroupFile_Insert", nFlowID, sFileList)
                    bsgvAuditHistory.DataBind()
                    'rptHistory.DataBind()
                End If
                rptFlowDocsFiles.DataBind()
                If bShowWarning Then
                    ShowMessage()
                End If
            End If
        Else
            Utility.Logout()
        End If
    End Sub
    Private Sub rptFiles_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptFiles.ItemCommand
        If e.CommandName = "Delete" Then
            Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
            taq.File_Delete(CInt(e.CommandArgument))
            rptFiles.DataBind()
        End If
    End Sub

    Private Sub rptFiles_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptFiles.ItemDataBound
        If pnlPIA.Enabled = False Then
            Dim lbt As LinkButton = e.Item.FindControl("lbtDelete")
            If Not lbt Is Nothing Then
                lbt.Visible = False
            End If
        End If
    End Sub
    Private Sub rptFlowDocs_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptFlowDocsFiles.ItemCommand
        If e.CommandName = "Delete" Then
            Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
            Dim sFileName As String = taq.GetFilenameByID(e.CommandArgument)
            taq.File_Delete(CInt(e.CommandArgument))
            taq.InsertTransactionLogEntry(Membership.GetUser.ProviderUserKey, "isp_DataFlowDetail", "DELETE FILE", "File_Delete", hfFlowDetailID.Value, sFileName)
            rptFlowDocsFiles.DataBind()
            bsgvAuditHistory.DataBind()
            'rptHistory.DataBind()
        End If
    End Sub

    Private Sub rptFlowDocs_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptFlowDocsFiles.ItemDataBound
        If pnlPIA.Enabled = False Then
            Dim lbt As LinkButton = e.Item.FindControl("lbtDeleteFlowDocs")
            If Not lbt Is Nothing Then
                lbt.Visible = False
            End If
        End If
    End Sub

    Private Sub lbtSignOffFlowConfirm_Click(sender As Object, e As EventArgs) Handles lbtSignOffFlowConfirm.Click
        Dim sComments As String = tbSignOffComments.Text.Trim()
        Dim nOrgUserID As Integer = CInt(hfSignatoryOrgUserID.Value)
        Dim taOrgUsers As New ispdatasetTableAdapters.isp_OrganisationUsersTableAdapter
        Dim tOrgUsers As New ispdataset.isp_OrganisationUsersDataTable
        tOrgUsers = taOrgUsers.GetByOrganisationUserID(nOrgUserID)
        Dim taQ As New DataFlowDetailTableAdapters.QueriesTableAdapter
        Dim nReturn As Integer = taQ.DataFlowSignature_Insert(hfFlowDetailID.Value, tOrgUsers.First.OrganisationUserName, tOrgUsers.First.OrganisationUserEmail, tOrgUsers.First.RoleID, tOrgUsers.First.OrganisationID, True, sComments, nOrgUserID)
        If nReturn > 0 Then
            taQ.MarkSignOffRequestsAsActioned(hfFlowDetailID.Value, nOrgUserID)
            If Not taQ.CheckSignOffWithinDate(hfSignatoryOrgUserID.Value, hfFlowDetailID.Value) = 1 Then
                Dim taRequest As New DataFlowDetailTableAdapters.MySignOffRequestsTableAdapter
                Dim tRequest As New DataFlowDetail.MySignOffRequestsDataTable
                tRequest = taRequest.GetDataByDataFlowAndOrgUserID(hfFlowDetailID.Value, nOrgUserID)
                If tRequest.Count > 0 Then
                    Dim sEmail As String = tRequest.First.RequestedBy
                    Dim taNots As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
                    Dim nRequestEmails As Integer = taNots.GetByNotificationEmail(5, sEmail)
                    If nRequestEmails > 0 And Not Session("SuppressEmails") Then
                        Dim sMailMessage As String = ""
                        sMailMessage += "<p>Dear colleague</p>"
                        sMailMessage += "<p>The user " + tOrgUsers.First.OrganisationUserName + " from " + Session("UserOrganisationName") + " has signed off the data flow " + lblDFSubHeader.Text + ". The sign by date you set when requesting sign off has now passed.</p>"
                        Dim sSubject As String = "ISG Data Flow Signed off After Sign By Date"
                        Utility.SendEmail(sEmail, sSubject, sMailMessage, True)
                    End If
                End If
            Else
                Dim taRequest As New DataFlowDetailTableAdapters.MySignOffRequestsTableAdapter
                Dim tRequest As New DataFlowDetail.MySignOffRequestsDataTable
                tRequest = taRequest.GetDataByDataFlowAndOrgUserID(hfFlowDetailID.Value, nOrgUserID)
                If tRequest.Count > 0 Then
                    Dim sEmail As String = tRequest.First.RequestedBy
                    Dim taNots As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
                    Dim nRequestEmails As Integer = taNots.GetByNotificationEmail(10, sEmail)
                    If nRequestEmails > 0 And Not Session("SuppressEmails") Then
                        Dim sMailMessage As String = ""
                        sMailMessage += "<p>Dear colleague</p>"
                        sMailMessage += "<p>The user " + tOrgUsers.First.OrganisationUserName + " from " + Session("UserOrganisationName") + " has signed off the data flow " + lblDFSubHeader.Text + "."
                        Dim sSubject As String = "ISG Data Flow Signed off"
                        Utility.SendEmail(sEmail, sSubject, sMailMessage, True)
                    End If
                End If
            End If
            RemovePDFIfExists()
            lblModalHeading.Text = "Thank you"
            lblModalText.Text = "You have signed off this data flow. If, at a later date, you wish to withdraw from this agreement, please raise a support ticket requesting withdrawal."
            ShowMessage(False)
            tbSignOffComments.Text = ""
            ShowHideMySigs()
            rptSignOffByOrg.DataBind()
            gvMyRequests.DataBind()
            gvSelectSignees.DataBind()
        End If
    End Sub
    Private Sub lbtRejectSignOffConfirm_Click(sender As Object, e As EventArgs) Handles lbtRejectSignOffConfirm.Click
        Dim sComments As String = tbSignOffComments.Text.Trim()
        Dim nOrgUserID As Integer = CInt(hfSignatoryOrgUserID.Value)
        Dim taOrgUsers As New ispdatasetTableAdapters.isp_OrganisationUsersTableAdapter
        Dim tOrgUsers As New ispdataset.isp_OrganisationUsersDataTable
        tOrgUsers = taOrgUsers.GetByOrganisationUserID(nOrgUserID)
        Dim taQ As New DataFlowDetailTableAdapters.QueriesTableAdapter
        Dim nReturn As Integer = taQ.DataFlowSignature_Insert(hfFlowDetailID.Value, tOrgUsers.First.OrganisationUserName, tOrgUsers.First.OrganisationUserEmail, tOrgUsers.First.RoleID, tOrgUsers.First.OrganisationID, False, sComments, nOrgUserID)
        If nReturn > 0 Then
            taQ.MarkSignOffRequestsAsActioned(hfFlowDetailID.Value, nOrgUserID)
            Dim taRequest As New DataFlowDetailTableAdapters.MySignOffRequestsTableAdapter
            Dim tRequest As New DataFlowDetail.MySignOffRequestsDataTable
            tRequest = taRequest.GetDataByDataFlowAndOrgUserID(hfFlowDetailID.Value, nOrgUserID)
            If tRequest.Count > 0 Then
                Dim sEmail As String = tRequest.First.RequestedBy
                Dim taNots As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
                Dim nRequestEmails As Integer = taNots.GetByNotificationEmail(11, sEmail)
                If nRequestEmails > 0 And Not Session("SuppressEmails") Then
                    Dim sMailMessage As String = ""
                    sMailMessage += "<p>Dear colleague</p>"
                    sMailMessage += "<p>The user " + tOrgUsers.First.OrganisationUserName + " from " + Session("UserOrganisationName") + " has refused to sign off this data flow " + lblDFSubHeader.Text + "."
                    Dim sSubject As String = "ISG Data Flow Sign Off Rejected"
                    Utility.SendEmail(sEmail, sSubject, sMailMessage, True)
                End If
            End If
            lblModalHeading.Text = "Data Flow Sign Off Rejected"
            lblModalText.Text = "You have refused sign off of this data flow. The data flow will now be read only."
            ShowMessage(False)
            tbSignOffComments.Text = ""
            ShowHideMySigs()
            gvMyRequests.DataBind()
            rptSignOffByOrg.DataBind()
            gvSelectSignees.DataBind()
        End If

    End Sub


    Private Sub lbtRequestSignOff_Click(sender As Object, e As EventArgs) Handles lbtRequestSignOff.Click
        gvSelectSignees.DataBind()
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "modalRequestSignOffScrpt", "<script>$('#modalRequestSignOff').modal('show');</script>")
    End Sub
    Private Sub lbtSubmitSignOffRequest_Click(sender As Object, e As EventArgs) Handles lbtSubmitSignOffRequest.Click
        Dim taAdmin As New DataFlowDetailTableAdapters.isp_DPOAckTableAdapter
        Dim tadfdrequest As New DataFlowDetailTableAdapters.isp_MySignOffRequestsTableAdapter
        'set up counter for number of users requested:
        Dim nCountUsers As Integer = 0
        Dim nReturn As Integer = 0
        Dim taDFD As New DataFlowDetailTableAdapters.isp_DataFlowDetailTableAdapter
        Dim tDFD As New DataFlowDetail.isp_DataFlowDetailDataTable
        tDFD = taDFD.GetByDFDID(hfFlowDetailID.Value)
        'iterate through rows in sign off request gridview
        For Each r As GridViewRow In gvSelectSignees.Rows
            Try


                Dim cb As CheckBox = r.FindControl("cbSelectUser")
                Dim sSubject As String = "ISG Data Flow Sign Off Request - " & tDFD.First.SummaryName & " / " & tDFD.First.DFDIdentifier
                Dim sPageName As String = HttpContext.Current.Request.UrlReferrer.GetLeftPart(UriPartial.Authority) & HttpContext.Current.Request.ApplicationPath & "Account/login.aspx"
                If Not cb Is Nothing Then
                    If cb.Checked Then
                        'insert a record in isp_DataFlowSignOffRequests for checked users
                        Dim hfUser As HiddenField = r.FindControl("hfOrgUserID")
                        Dim nOrgUserID As Integer = hfUser.Value
                        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
                        Dim sCC As String = taq.GetDeelegateEmailForOrgUserID(nOrgUserID)
                        Dim dtOverride As Nullable(Of DateTime)
                        If tbSignByDate.Text.Length = 0 Then
                            dtOverride = Nothing
                        Else
                            dtOverride = DateTime.ParseExact(tbSignByDate.Text, "d/M/yyyy", Globalization.CultureInfo.InvariantCulture, Globalization.DateTimeStyles.None)
                        End If

                        nReturn = tadfdrequest.DataFlowSignOffRequests_Insert(nOrgUserID, hfFlowDetailID.Value, Session("UserEmail"), dtOverride, cbEnforce.Checked, tbOptionalText.Text)


                        If nReturn > 0 Then
                            nCountUsers = nCountUsers + 1
                            'e-mail user if signed up for thois notification
                            Dim lbl As Label = r.FindControl("lblUsername")
                            Dim lblOrg As Label = r.FindControl("lblOrganisation")
                            If Not lbl Is Nothing Then
                                'user e-mail address is used as the tooltip on the username label - let's get it
                                Dim sEmail As String = lbl.ToolTip
                                Dim sUsername As String = lbl.Text
                                Dim taNots As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
                                Dim nRequestEmails As Integer = taNots.GetByNotificationEmail(2, sEmail)
                                If nRequestEmails > 0 And Not Session("SuppressEmails") Then
                                    Dim sMailMessage As String = ""
                                    sMailMessage = sMailMessage & "<p>Dear " & sUsername & ",</p>"
                                    sMailMessage = sMailMessage & "<p><a href='mailto:" & Session("UserEmail") & "'>" & Session("UserOrgUserName") & " (" & Session("UserEmail") & ")</a> has requested that you sign off a data flow - " & tDFD.First.SummaryName & " / " & tDFD.First.DFDIdentifier & " - in the Data Protection Impact Assessment Tool (ISG) for your organisation " & lblOrg.Text & ". This request will be on your In-Tray the next time you login to the ISG for " & lblOrg.Text & ".</p>"
                                    If Not tbOptionalText.Text.Trim = "" Then
                                        sMailMessage += "<p>When generating this request, " + Session("UserOrgUserName") + " added the following comments:</p>"
                                        sMailMessage += "<hr/><p>" + tbOptionalText.Text + "</p><hr/>"
                                    End If
                                    If tbSignByDate.Text.Trim.Length > 0 Then
                                        If cbEnforce.Checked Then
                                            sMailMessage += "<p>You must respond to this sign off request before " + tbSignByDate.Text + ". The request will be removed from your in-tray after this date.<p>"
                                        Else
                                            sMailMessage += "<p>Please respond to this sign off request no later than " + tbSignByDate.Text + ".<p>"
                                        End If
                                    End If
                                    sMailMessage = sMailMessage & "<p>Signing off the data flow gives your authorisation for the sharing of data detailed in the flow.</p>"
                                    sMailMessage = sMailMessage & "<p>If you have delegated your ISG role, your delegate will receive a copy of this e-mail and can complete the sign-off on your behalf.</p>"
                                    sMailMessage = sMailMessage & "<p>To login to the gateway and sign off the data flow, <a href='" & sPageName & "'>click here</a>.</p>"
                                    Utility.SendEmail(sEmail, sSubject, sMailMessage, True, , sCC)
                                End If
                            End If
                        End If

                    End If
                End If
            Catch ex As Exception

            End Try
        Next

        'Get a list of all administrator within all of the organisations involved in the dataflow.
        'For each administrator place an acknowledge message on the in-tray (but only if they have not had a previous intray massage).
        If nCountUsers > 0 Then
            Try
                Dim taSU As New ispdatasetTableAdapters.DataFlow_GetSeniorUsersTableAdapter
                Dim tSU As New ispdataset.DataFlow_GetSeniorUsersDataTable
                tSU = taSU.GetAdministrators(hfFlowDetailID.Value)

                'iterate through each admin user involved within the dataflow
                For Each r As DataRow In tSU.Rows
                    nReturn = 0
                    nReturn = taAdmin.DataFlowDPOAck_Insert(hfFlowDetailID.Value, r.Item("OrganisationID"), r.Item("OrganisationUserEmail"), Session("UserEmail"))
                Next
            Catch ex As Exception

            End Try
        End If



        If nCountUsers > 0 Then
            'message to confirm what has been done:
            lblModalHeading.Text = "Requests for Sign Off Submitted"
            Dim sMessage As String
            sMessage = "<p>" & nCountUsers.ToString() & " sign off requests have been submitted.</p>"
            sMessage = sMessage & "<p>This sign off request will appear on the in-tray of these users when they next access the Data Protection Impact Assessment Tool.</p>"
            sMessage = sMessage & "<p>Depending on their notification setting, each user may also receive an e-mail prompting them to sign off the data flow.</p>"
            sMessage = sMessage & "<p class='alert  alert-warning' role='alert'><strong>Note:</strong> Once signed off, the data flow will become read only.</p>"
            lblModalText.Text = sMessage
            ShowMessage(False)
            ShowHideMySigs()

            gvMyRequests.DataBind()
            rptSignOffByOrg.DataBind()
            gvSelectSignees.DataBind()
        End If
        tbSignByDate.Text = ""
        tbOptionalText.Text = ""
        cbEnforce.Checked = False
    End Sub
    Private Sub vSignOff_Activate(sender As Object, e As EventArgs) Handles vSignOff.Activate
        ShowHideMySigs()
        If Page.Request.Item("Action") = "Edit" And pnlPIA.Enabled Then
            UpdateDataFlow()
            rptSignOffByOrg.DataBind()
            If CBool(hfInDraft.Value) = True Then
                CheckCanFinalise()
                mvSignOff.SetActiveView(vInDraftFinalise)
            Else
                mvSignOff.SetActiveView(vSignOffInner)
            End If

        ElseIf pnlPIA.Enabled Then
            mvSignOff.SetActiveView(vSaveFirstSO)
        ElseIf lblDFStatus.Text = "Draft" Or lblDFStatus.Text = "DPO Approved" Then
            CheckCanFinalise()
            mvSignOff.SetActiveView(vInDraftFinalise)
        Else
            mvSignOff.SetActiveView(vSignOffInner)
        End If

    End Sub
    Protected Sub ShowHideMySigs()
        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        'get count of open requests for user and display sign off panel if > 0
        Dim nOpenRequests As Integer = taq.CountOpenRequestsForUserForDFDID(Session("UserEmail"), hfFlowDetailID.Value)
        If nOpenRequests > 0 Then
            pnlSignOff.Visible = True
        Else
            pnlSignOff.Visible = False
            'get count of closed requests and show no actions panel if > 0
            Dim nClosedRequests As Integer = taq.CountClosedRequestsForUserForDFDID(Session("UserEmail"), hfFlowDetailID.Value)
            If nClosedRequests > 0 Then
                pnlAllSigned.Visible = True
            End If
        End If
    End Sub
    Protected Sub lbtImportRA_Click(sender As Object, e As EventArgs) Handles lbtImportRA.Click
        Dim FromDFDID As Integer = ddImportFromDF.SelectedValue
        If FromDFDID > 0 Then
            Dim currentUser As MembershipUser = Membership.GetUser()
            Dim currentUserId As Guid = DirectCast(currentUser.ProviderUserKey, Guid)
            Dim dfdid = hfFlowDetailID.Value
            Dim taQ As New InformationSharingPortal.DataFlowDetailTableAdapters.QueriesTableAdapter
            Dim RAID As Integer = taQ.ImportRiskAssessmentFromDataFlow(FromDFDID, dfdid, currentUserId, Session("UserOrganisationID"))
            Session("RiskAssessmentID") = RAID
            'gvRisks.DataBind()
            mvOutcome.SetActiveView(vRiskAssessment)
        End If
    End Sub
    Private Sub lbtFinaliseConfirm_Click(sender As Object, e As EventArgs) Handles lbtFinaliseConfirm.Click
        Dim taQ As New DataFlowDetailTableAdapters.QueriesTableAdapter
        taQ.FinaliseDataFlow(hfFlowDetailID.Value)
        hfInDraft.Value = 0
        mvSignOff.ActiveViewIndex = -1
        If Page.Request.Item("Action") = "Edit" Then
            UpdateDataFlow()
            rptSignOffByOrg.DataBind()
            If CBool(hfInDraft.Value) = True Then
                mvSignOff.SetActiveView(vInDraftFinalise)
            Else
                mvSignOff.SetActiveView(vSignOffInner)
            End If

        ElseIf pnlPIA.Enabled Then
            mvSignOff.SetActiveView(vSaveFirstSO)
        End If
    End Sub
    Private Sub btnFinalise_Click(sender As Object, e As EventArgs) Handles btnFinalise.Click
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "modalFinaliseDataFlowScrpt", "<script>$('#modalFinalise').modal('show');</script>")
    End Sub
    Private Sub listProvidingOrgs_DataBound(sender As Object, e As EventArgs) Handles listProvidingOrgs.DataBound
        If listProvidingOrgs.Items.Count = 0 Then
            pnlAddProvidingOrgs.Visible = False
        Else
            If Not pnlPIA.Enabled Then
                pnlAddProvidingOrgs.Visible = True
            End If
        End If
    End Sub
    Private Sub lbtAddSelected_Click(sender As Object, e As EventArgs) Handles lbtAddSelected.Click
        Dim sDFDOrganisationsCSV As String = ""
        'Generate Organisation CSV
        For Each li As ListItem In listProvidingOrgs.Items
            If li.Selected Then
                sDFDOrganisationsCSV = sDFDOrganisationsCSV + li.Value.ToString() + ", "
            End If
        Next
        If sDFDOrganisationsCSV.Length > 2 Then
            sDFDOrganisationsCSV = sDFDOrganisationsCSV.Substring(0, sDFDOrganisationsCSV.Length - 2)
        End If
        If sDFDOrganisationsCSV <> "" Then
            Dim taq As New InformationSharingPortal.DataFlowDetailTableAdapters.QueriesTableAdapter
            Dim nAdded As Integer = taq.DataFlowDetail_AddProvidingOrgs(hfFlowDetailID.Value, sDFDOrganisationsCSV)
            If nAdded > 0 Then
                lblModalHeading.Text = "Organisations Added"
                Dim sMessage As String
                sMessage = "<p>The selected organisations have been added to this data flow.</p>"
                lblModalText.Text = sMessage
                ShowMessage(False)

            End If
            listOrganisations.DataBind()
            listProvidingOrgs.DataBind()
            RemovePDFIfExists()
        End If
    End Sub
    Private Sub rptSignOffByOrg_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptSignOffByOrg.ItemDataBound
        Dim rptItem As RepeaterItem = DirectCast(e.Item, RepeaterItem)
        Dim hfDFD_DFDOrganisationID As HiddenField = rptItem.FindControl("hfDFD_DFDOrganisationID")
        If Not hfDFD_DFDOrganisationID Is Nothing Then
            Dim nDFDOID As Integer = hfDFD_DFDOrganisationID.Value
            Dim rptSignatories As Repeater = rptItem.FindControl("rptSignatories")
            If Not rptSignatories Is Nothing Then
                Dim dsSig As ObjectDataSource = rptItem.FindControl("dsUserSignOffStatus")
                If Not dsSig Is Nothing Then
                    dsSig.SelectParameters(0).DefaultValue = nDFDOID
                End If
                rptSignatories.DataSource = dsSig
                rptSignatories.DataBind()
            End If
        End If
    End Sub
    Private Sub gvMyRequests_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvMyRequests.RowCommand
        If e.CommandName = "Review" Then
            Dim nOrgUserID As Integer = CInt(e.CommandArgument)
            hfSignatoryOrgUserID.Value = nOrgUserID
            Dim taOrgUsers As New ispdatasetTableAdapters.isp_OrganisationUsersTableAdapter
            Dim tOrgUsers As New ispdataset.isp_OrganisationUsersDataTable
            tOrgUsers = taOrgUsers.GetByOrganisationUserID(nOrgUserID)
            If tOrgUsers.Count > 0 Then
                lblAgreeUserName.Text = Session("UserOrgUserName")
                lblAgreeOrganisation.Text = tOrgUsers.First.Organisation
                If Session("UserEmail") = tOrgUsers.First.OrganisationUserEmail Then
                    lblAgreeRole.Text = tOrgUsers.First.Role
                Else
                    lblOnBehalfOf.Text = "acting on behalf of my " & tOrgUsers.First.Role & "."
                End If
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "modalSignOffDataFlowScrpt", "<script>$('#modalSignOffDataFlow').modal('show');</script>")
            End If
        End If
    End Sub

    Protected Sub rptSignatoriesItemCommand(source As Object, e As RepeaterCommandEventArgs)
        If e.CommandName = "withdraw" Then
            Dim strAttributes As String()
            strAttributes = e.CommandArgument.ToString().Split("|")
            Dim nSigID As Integer = CInt(strAttributes(0))
            Dim nOrgUserID As Integer = CInt(strAttributes(1))
            hfSignatureID.Value = nSigID
            hfOrganisationUserID.Value = nOrgUserID
            lblWithdrawUser.Text = Session("UserOrgUserName")
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "modalSignOffWithdrawScrpt", "<script>$('#modalWithdrawSignature').modal('show');</script>")
        ElseIf e.CommandName = "SendReminder" Then
            Dim taDFD As New DataFlowDetailTableAdapters.isp_DataFlowDetailTableAdapter
            Dim tDFD As New DataFlowDetail.isp_DataFlowDetailDataTable
            tDFD = taDFD.GetByDFDID(hfFlowDetailID.Value)
            Dim sSubject As String = "ISG Data Flow Sign Off Request Reminder - " & tDFD.First.SummaryName & " / " & tDFD.First.DFDIdentifier
            Dim nOrgUserID As Integer = e.CommandArgument
            Dim taorgusers As New ispdatasetTableAdapters.isp_OrganisationUsersTableAdapter
            Dim tOrgUser As New ispdataset.isp_OrganisationUsersDataTable
            tOrgUser = taorgusers.GetByOrganisationUserID(nOrgUserID)
            Dim sEmail As String = tOrgUser.First.OrganisationUserEmail
            Dim sUsername As String = tOrgUser.First.OrganisationUserName
            Dim taNots As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
            Dim nRequestEmails As Integer = taNots.GetByNotificationEmail(2, sEmail)
            Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
            Dim sCC As String = taq.GetDeelegateEmailForOrgUserID(nOrgUserID)
            'update last reminder date:
            taq.UpdateLastReminderDate(nOrgUserID, hfFlowDetailID.Value)
            Dim sPageName As String = HttpContext.Current.Request.UrlReferrer.GetLeftPart(UriPartial.Authority) & HttpContext.Current.Request.ApplicationPath & "Account/login.aspx"
            Dim sMessage As String

            If nRequestEmails > 0 And Not Session("SuppressEmails") Then
                Dim sMailMessage As String = ""
                sMailMessage = sMailMessage & "<p>Dear " & sUsername & ",</p>"
                sMailMessage = sMailMessage & "<p><a href='mailto:" & Session("UserEmail") & "'>" & Session("UserOrgUserName") & " (" & Session("UserEmail") & ")</a> has requested that you sign off a data flow - " & tDFD.First.SummaryName & " / " & tDFD.First.DFDIdentifier & " - in the Data Protection Impact Assessment Tool (ISG). This request will be on your In-Tray the next time you login to the ISG.</p>"
                sMailMessage = sMailMessage & "<p>Signing off the data flow gives your authorisation for the sharing of data detailed in the flow.</p>"
                sMailMessage = sMailMessage & "<p>If you have delegated your ISG role, your delegate will receive a copy of this e-mail and can complete the sign-off on your behalf.</p>"
                sMailMessage = sMailMessage & "<p>To login to the gateway and sign off the data flow, <a href='" & sPageName & "'>click here</a>.</p>"
                Utility.SendEmail(sEmail, sSubject, sMailMessage, True, , sCC)
                lblModalHeading.Text = "Sign Off Reminder sent"

                sMessage = "<p>A sign off request reminder has been sent.</p>"
                sMessage = sMessage & "<p>The user should receive an e-mail prompting them to sign off the data flow.</p>"
                sMessage = sMessage & "<p class='alert  alert-warning' role='alert'><strong>Note:</strong> Once signed off, the data flow will become read only.</p>"
            Else
                lblModalHeading.Text = "No Sign Off Reminder sent"

                sMessage = "<p>A sign off request reminder could not be sent because this user has disabled e-mail notifications for sign-off reminders.</p>"
            End If
            lblModalText.Text = sMessage
            ShowMessage(False)
            rptSignOffByOrg.DataBind()
        End If
    End Sub
    Private Sub lbtWithdrawConfirm_Click(sender As Object, e As EventArgs) Handles lbtWithdrawConfirm.Click
        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        taq.WithdrawDataFlowSignature(Session("UserOrgUserName"), tbWithdrawComments.Text.Trim(), hfSignatureID.Value)
        Dim nOrgUserID As Integer = CInt(hfOrganisationUserID.Value)
        Dim taOrgUsers As New ispdatasetTableAdapters.isp_OrganisationUsersTableAdapter
        Dim tOrgUsers As New ispdataset.isp_OrganisationUsersDataTable
        tOrgUsers = taOrgUsers.GetByOrganisationUserID(nOrgUserID)
        Dim taRequest As New DataFlowDetailTableAdapters.MySignOffRequestsTableAdapter
        Dim tRequest As New DataFlowDetail.MySignOffRequestsDataTable
        tRequest = taRequest.GetDataByDataFlowAndOrgUserID(hfFlowDetailID.Value, nOrgUserID)
        If tRequest.Count > 0 Then
            Dim sEmail As String = tRequest.First.RequestedBy
            Dim taNots As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
            Dim nRequestEmails As Integer = taNots.GetByNotificationEmail(12, sEmail)
            If nRequestEmails > 0 And Not Session("SuppressEmails") Then
                Dim sMailMessage As String = ""
                sMailMessage += "<p>Dear colleague</p>"
                sMailMessage += "<p>The user " + tOrgUsers.First.OrganisationUserName + " from " + Session("UserOrganisationName") + " has been withdrawn from this signed off data flow " + lblDFSubHeader.Text + "."
                Dim sSubject As String = "ISG Sign Off Data Flow Withdrawal"
                Utility.SendEmail(sEmail, sSubject, sMailMessage, True)
            End If
        End If
        rptSignOffByOrg.DataBind()
        gvSelectSignees.DataBind()
    End Sub
    Private Sub lbtExportToExcel_Click(sender As Object, e As EventArgs) Handles lbtExportToExcel.Click
        Dim SignOff_Export As New DataSet("ISG Dataflow Sign Off Export")
        Dim dfdid As Integer = hfFlowDetailID.Value
        Dim taSO As New DataFlowDetailTableAdapters.GetOrganisationUserSignOffStatusExportTableAdapter
        Dim tSO As New DataFlowDetail.GetOrganisationUserSignOffStatusExportDataTable
        tSO = taSO.GetData(dfdid)
        tSO.TableName = "ISG Signoff - DF" + dfdid.ToString()
        SignOff_Export.Tables.Add(tSO)
        Dim sDate As String = Date.Now.Day.ToString() & "-" & Date.Now.Month.ToString() & "-" & Date.Now.Year.ToString()
        OpenXMLExport.ExportToExcel(SignOff_Export, "ISG SignOff List - DF" + dfdid.ToString() + " (" + sDate + ").xlsx", Page.Response)
    End Sub
    Private Sub dsFlowDocsFiles_Selected(sender As Object, e As ObjectDataSourceStatusEventArgs) Handles dsFlowDocsFiles.Selected
        If e.Exception Is Nothing Then
            lbtDocuments.Text = "Additional Documents (" & DirectCast(e.ReturnValue, DataTable).Rows.Count.ToString() & ")"
        End If

    End Sub
    Protected Sub UpdateOverallRisks()
        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        taq.UpdateOverallRiskRating(hfFlowDetailID.Value)
    End Sub
    Protected Sub GridViewCustomToolbar_ToolbarItemClick(ByVal source As Object, ByVal e As BootstrapGridViewToolbarItemClickEventArgs)
        Select Case e.Item.Name
            Case "Export"
                Dim bsgv As BootstrapGridView = bsgvRisks
                Dim bToolsVis As Boolean = bsgv.Columns("Tools").Visible
                bsgv.Columns("SysGenerated").Visible = False
                bsgv.Columns("Tools").Visible = False
                bsgv.Columns("ActionTypeEx").Visible = True
                bsgv.Columns("ActionsEx").Visible = True
                bsgv.Columns("Actions").Visible = False
                bsgv.Columns("RiskRating").Visible = False
                bsgv.Columns("FinalRiskRating").Visible = False
                bsgv.Columns("RiskRatingText").Visible = True
                bsgv.Columns("FinalRiskRatingText").Visible = True
                bsgvExporter.WriteXlsxToResponse()
                bsgv.Columns("SysGenerated").Visible = True
                bsgv.Columns("Tools").Visible = bToolsVis
                bsgv.Columns("ActionTypeEx").Visible = False

                bsgv.Columns("RiskRatingText").Visible = False
                bsgv.Columns("FinalRiskRatingText").Visible = False
                bsgv.Columns("RiskRating").Visible = True
                bsgv.Columns("FinalRiskRating").Visible = True
                'bsgv.Columns("Delete").Visible = bDelVis
            Case Else
        End Select
    End Sub
    Private Sub bsgvRisks_RowDeleted(sender As Object, e As ASPxDataDeletedEventArgs) Handles bsgvRisks.RowDeleted
        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        taq.UpdateOverallRiskRating(hfFlowDetailID.Value)
    End Sub
    Private Sub bsgvRisks_RowUpdated(sender As Object, e As ASPxDataUpdatedEventArgs) Handles bsgvRisks.RowUpdated
        UpdateOverallRisks()
    End Sub
    Private Sub lbtDPOReview_Click(sender As Object, e As EventArgs) Handles lbtDPOReview.Click
        RemoveActiveClasses()
        mvDataFlow.SetActiveView(vDPOReview)
        liDPOReview.Attributes.Add("class", "active")
    End Sub
    Private Sub lbtRequestDPOSignOff_Click(sender As Object, e As EventArgs) Handles lbtRequestDPOSignOff.Click
        gvDPOReviewers.DataBind()
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "modalDPOReviewRequest", "<script>$('#modalDPOReviewRequest').modal('show');</script>")
    End Sub
    Private Sub lbtSubmitDPOReviewRequest_Click(sender As Object, e As EventArgs) Handles lbtSubmitDPOReviewRequest.Click
        Dim taDPO As New DataFlowDetailTableAdapters.isp_DPOReviewsTableAdapter
        Dim nCountUsers As Integer = 0
        Dim nReturn As Integer = 0
        Dim taDFD As New DataFlowDetailTableAdapters.isp_DataFlowDetailTableAdapter
        Dim tDFD As New DataFlowDetail.isp_DataFlowDetailDataTable
        tDFD = taDFD.GetByDFDID(hfFlowDetailID.Value)
        'iterate through rows in sign off request gridview
        For Each r As GridViewRow In gvDPOReviewers.Rows
            Try
                Dim cb As CheckBox = r.FindControl("cbSelectUser")
                Dim sSubject As String = "ISG Data Flow DPO Review Request - " & tDFD.First.SummaryName & " / " & tDFD.First.DFDIdentifier
                Dim sPageName As String = HttpContext.Current.Request.UrlReferrer.GetLeftPart(UriPartial.Authority) & HttpContext.Current.Request.ApplicationPath & "Account/login.aspx"
                If Not cb Is Nothing Then
                    If cb.Checked Then
                        Dim hfUser As HiddenField = r.FindControl("hfOrgUserID")
                        Dim nOrgUserID As Integer = hfUser.Value
                        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
                        Dim sCC As String = taq.GetDeelegateEmailForOrgUserID(nOrgUserID)
                        Dim dtOverride As Nullable(Of DateTime)
                        If tbReviewByDT.Text.Length = 0 Then
                            dtOverride = Nothing
                        Else
                            dtOverride = DateTime.ParseExact(tbReviewByDT.Text, "d/M/yyyy", Globalization.CultureInfo.InvariantCulture, Globalization.DateTimeStyles.None)
                        End If
                        nReturn = taDPO.DataFlowDPOReview_Insert(hfFlowDetailID.Value, nOrgUserID, Session("UserEmail"), dtOverride)
                        If nReturn > 0 Then
                            nCountUsers = nCountUsers + 1
                            'e-mail user if signed up for thois notification
                            Dim lbl As Label = r.FindControl("lblUsername")
                            Dim lblOrg As Label = r.FindControl("lblOrganisation")
                            If Not lbl Is Nothing Then
                                'user e-mail address is used as the tooltip on the username label - let's get it
                                Dim sEmail As String = lbl.ToolTip
                                Dim sUsername As String = lbl.Text
                                Dim taNots As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
                                Dim nRequestEmails As Integer = taNots.GetByNotificationEmail(6, sEmail)
                                If nRequestEmails > 0 And Not Session("SuppressEmails") Then
                                    Dim sMailMessage As String = ""
                                    sMailMessage = sMailMessage & "<p>Dear " & sUsername & ",</p>"
                                    sMailMessage = sMailMessage & "<p><a href='mailto:" & Session("UserEmail") & "'>" & Session("UserOrgUserName") & " (" & Session("UserEmail") & ")</a> has requested that you review a data flow - " & tDFD.First.SummaryName & " / " & tDFD.First.DFDIdentifier & " - in the Data Protection Impact Assessment Tool (DPIA). This request will be on your In-Tray the next time you login to the ISG under " & lblOrg.Text & ".</p>"
                                    If Not tbRequestDPOReviewComments.Text.Trim = "" Then
                                        sMailMessage += "<p>When generating this request, " + Session("UserOrgUserName") + " added the following comments:</p>"
                                        sMailMessage += "<hr/><p>" + tbRequestDPOReviewComments.Text + "</p><hr/>"
                                    End If
                                    If tbReviewByDT.Text.Trim.Length > 0 Then

                                        sMailMessage += "<p>Please respond to this sign off request no later than " + tbReviewByDT.Text + ".<p>"

                                    End If
                                    sMailMessage = sMailMessage & "<p>Reviewing the data flow in your role as Data Protection Officer allows you to comment on and accept or reject the flow.</p>"
                                    'sMailMessage = sMailMessage & "<p>If you have delegated your ISG role, your delegate will receive a copy of this e-mail and can complete the sign-off on your behalf.</p>"
                                    sMailMessage = sMailMessage & "<p>To login to the gateway and review the data flow, <a href='" & sPageName & "'>click here</a>.</p>"
                                    Utility.SendEmail(sEmail, sSubject, sMailMessage, True, , sCC)
                                End If
                            End If
                        End If
                    End If
                End If
            Catch ex As Exception
                Dim sEx As String = ex.Message
            End Try
        Next
        If nCountUsers > 0 Then
            'message to confirm what has been done:
            lblModalHeading.Text = "Requests for DPO Review"
            Dim sMessage As String
            sMessage = "<p>" & nCountUsers.ToString() & " DPO Review requests have been submitted.</p>"
            sMessage = sMessage & "<p>This review request will appear on the in-tray of these users when they next access the Data Protection Impact Assessment Tool.</p>"
            sMessage = sMessage & "<p>Depending on their notification settings, each user may also receive an e-mail prompting them to review the data flow.</p>"
            lblModalText.Text = sMessage
            ShowMessage(False)
            gvDPOReview.DataBind()
            gvDPOReviewers.DataBind()
        End If
        tbSignByDate.Text = ""
        tbOptionalText.Text = ""
        cbEnforce.Checked = False

    End Sub

    Private Sub gvDPOReview_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDPOReview.RowCommand
        If e.CommandName = "DPOReview" Then
            hfDPOReviewID.Value = e.CommandArgument
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "modalDPOReviewfDataFlow", "<script>$('#modalDPOReviewfDataFlow').modal('show');</script>")
        ElseIf e.CommandName = "ViewDPOComments" Then
            Dim taDPO As New DataFlowDetailTableAdapters.isp_DPOReviewsTableAdapter
            Dim tDPOReview As New DataFlowDetail.isp_DPOReviewsDataTable
            tDPOReview = taDPO.GetByDPOReviewID(e.CommandArgument)
            tbDPIACommentsReview.Text = tDPOReview.First.DPIAComments
            tbRACommentsReview.Text = tDPOReview.First.RAComments
            tbDFCommentsReview.Text = tDPOReview.First.DFComments
            lblDPOReviewTitle.Text = "DPO Reviewer Comments (Submitted " & tDPOReview.First.ReviewedDTT & ")"
            If tDPOReview.First.Approved Then
                pnlReviewOutcome.CssClass = "alert alert-success text-center"
                lblReviewOutcome.Text = "APPROVED"
            Else
                pnlReviewOutcome.CssClass = "alert alert-danger text-center"
                lblReviewOutcome.Text = "REJECTED"
            End If
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "modalViewComments", "<script>$('#modalViewComments').modal('show');</script>")
        ElseIf e.CommandName = "DPOSendReminder" Then
            'Send a Reminder to user, Screen Message, Update DPOReview.LastReminder with current Date.
            Dim nReturn As Integer = 0
            Dim taDPO As New DataFlowDetailTableAdapters.isp_DPOReviewsTableAdapter
            Dim tDPOReview As New DataFlowDetail.isp_DPOReviewsDataTable
            tDPOReview = taDPO.GetByDPOReviewID(e.CommandArgument)
            Dim nOrgUserID As Integer = tDPOReview.First.DPOOrganisationUserID
            Dim taDFD As New DataFlowDetailTableAdapters.isp_DataFlowDetailTableAdapter
            Dim tDFD As New DataFlowDetail.isp_DataFlowDetailDataTable
            tDFD = taDFD.GetByDFDID(hfFlowDetailID.Value)
            Dim sSubject As String = "ISG Data Flow DPO Review Request Reminder - " & tDFD.First.SummaryName & " / " & tDFD.First.DFDIdentifier
            Dim sPageName As String = HttpContext.Current.Request.UrlReferrer.GetLeftPart(UriPartial.Authority) & HttpContext.Current.Request.ApplicationPath & "Account/login.aspx"
            Dim taorgusers As New ispdatasetTableAdapters.isp_OrganisationUsersTableAdapter
            Dim tOrgUser As New ispdataset.isp_OrganisationUsersDataTable
            Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
            Dim sCC As String = taq.GetDeelegateEmailForOrgUserID(nOrgUserID)
            tOrgUser = taorgusers.GetByOrganisationUserID(nOrgUserID)
            Dim sEmail As String = tOrgUser.First.OrganisationUserEmail
            Dim sUsername As String = tOrgUser.First.OrganisationUserName
            Dim sOrganisation As String = tOrgUser.First.Organisation
            Dim taNots As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
            'Dim nRequestEmails As Integer = taNots.GetByNotificationEmail(6, sEmail)
            'If nRequestEmails > 0 And Not Session("SuppressEmails") Then
            If Not Session("SuppressEmails") Then
                nReturn = taDPO.SubmitDPOReminder(e.CommandArgument)
                Dim sMailMessage As String = ""
                sMailMessage = sMailMessage & "<p>Dear " & sUsername & ",</p>"
                sMailMessage = sMailMessage & "<p><a href='mailto:" & Session("UserEmail") & "'>" & Session("UserOrgUserName") & " (" & Session("UserEmail") & ")</a> has requested that you review a data flow - " & tDFD.First.SummaryName & " / " & tDFD.First.DFDIdentifier & " - in the Data Protection Impact Assessment Tool (DPIA). This request will be on your In-Tray the next time you login to the ISG under " & sOrganisation & ".</p>"
                If Not tbRequestDPOReviewComments.Text.Trim = "" Then
                    sMailMessage += "<p>When generating this request, " + Session("UserOrgUserName") + " added the following comments:</p>"
                    sMailMessage += "<hr/><p>" + tbRequestDPOReviewComments.Text + "</p><hr/>"
                End If
                If tbReviewByDT.Text.Trim.Length > 0 Then
                    sMailMessage += "<p>Please respond to this sign off request no later than " + tbReviewByDT.Text + ".<p>"
                End If
                sMailMessage = sMailMessage & "<p>Reviewing the data flow in your role as Data Protection Officer allows you to comment on and accept or reject the flow.</p>"
                sMailMessage = sMailMessage & "<p>To login to the gateway and review the data flow, <a href='" & sPageName & "'>click here</a>.</p>"
                Utility.SendEmail(sEmail, sSubject, sMailMessage, True, , sCC)
            End If

            Dim sMessage As String = ""
            sMessage = "<p>A DPO review reminder has been sent.</p>"
            sMessage = sMessage & "<p>The user should receive an email prompting them to perform a DPO Review.</p>"
            lblModalText.Text = sMessage
            ShowMessage(False)
            gvDPOReview.DataBind()
        ElseIf e.CommandName = "ReReview" Then
            hfRROrgUserID.Value = e.CommandArgument
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "modalViewComments", "<script>$('#modalDPOReReviewRequest').modal('show');</script>")

        End If

    End Sub

    Private Sub lbtDPApprove_Click(sender As Object, e As EventArgs) Handles lbtDPApprove.Click
        StoreReview(True)
    End Sub

    Private Sub lbtDPOReject_Click(sender As Object, e As EventArgs) Handles lbtDPOReject.Click
        StoreReview(False)
    End Sub
    Protected Sub StoreReview(ByVal bApproved As Boolean)
        Dim taDPO As New DataFlowDetailTableAdapters.isp_DPOReviewsTableAdapter
        taDPO.SubmitDPOReview(bApproved, tbDFComments.Text, tbDPIAComments.Text, tbRAComments.Text, hfDPOReviewID.Value)
        Dim tDPOReview As New DataFlowDetail.isp_DPOReviewsDataTable
        tDPOReview = taDPO.GetByDPOReviewID(hfDPOReviewID.Value)
        'Send e-mail to reviewer indicating outcome:
        Dim taq As New TicketsTableAdapters.QueriesTableAdapter
        Dim sToName As String = taq.GetUsernameFromEmail(tDPOReview.First.RequestUserEmail)

        Dim taDFD As New DataFlowDetailTableAdapters.isp_DataFlowDetailTableAdapter
        Dim tDFD As New DataFlowDetail.isp_DataFlowDetailDataTable
        tDFD = taDFD.GetByDFDID(hfFlowDetailID.Value)

        Dim taNots As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
        Dim nRequestEmails As Integer = taNots.GetByNotificationEmail(9, tDPOReview.First.RequestUserEmail)

        If nRequestEmails > 0 And Not Session("SuppressEmails") Then
            Dim sSubject As String = "ISG Data Flow DPO Review Submitted - " & tDFD.First.SummaryName & " / " & tDFD.First.DFDIdentifier

            Dim sMailMessage As String = ""
            sMailMessage = sMailMessage + "Dear " & sToName
            sMailMessage = sMailMessage & "<p><a href='mailto:" & Session("UserEmail") & "'>" & Session("UserOrgUserName") & " (" & Session("UserEmail") & ")</a> has reviewed the data flow - " & tDFD.First.SummaryName & " / " & tDFD.First.DFDIdentifier & " - in the Data Protection Impact Assessment Tool (DPIA).</p>"
            If bApproved Then
                sMailMessage = sMailMessage & "<p>Having reviewed the data flow in their role as DPO, they have decided to <b>approve</b> it. Provided no other DPOs have rejected the data flow, you will be able to finalise the flow in the ISG and request sign-off."
            Else
                sMailMessage = sMailMessage & "<p>Having reviewed the data flow in their role as DPO, they have decided to <b>reject</b> it. You will be able to see the comments that they made explaining why they have rejected it when you visit the DPO review tab for the data flow. Once you have acted on those comments and revised the dataflow appropriately, you will be able to request a re-review."
            End If

            Utility.SendEmail(tDPOReview.First.RequestUserEmail, sSubject, sMailMessage, True)
        End If
        tbDFComments.Text = ""
        tbDPIAComments.Text = ""
        tbRAComments.Text = ""
        gvDPOReview.DataBind()
        lblModalHeading.Text = "DPO Review Submitted"
        Dim sMessage As String
        sMessage = "<p>Your review has been submitted.</p>"
        sMessage = sMessage & "<p>The requester will receive an e-mail indicating the outcome of the review.</p>"
        If Not bApproved Then
            sMessage = sMessage & "<p>They may request a re-review once they have acted on any recommendations that you made during your review.</p>"
        End If
        lblModalText.Text = sMessage
        ShowMessage(False)
    End Sub

    Private Sub gvDPOReview_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvDPOReview.RowDataBound
        If e.Row.Cells.Count > 1 Then
            Dim hf As HiddenField = e.Row.Cells(4).FindControl("hfArchived")
            If Not hf Is Nothing Then
                If CBool(hf.Value) Then
                    e.Row.CssClass = "text-muted"
                End If
            End If
        End If
    End Sub
    Protected Sub CheckCanFinalise()
        Dim taDFD As New DataFlowDetailTableAdapters.isp_DataFlowDetailTableAdapter
        Dim tDFD As New DataFlowDetail.isp_DataFlowDetailDataTable
        tDFD = taDFD.GetByDFDID(hfFlowDetailID.Value)

        lblAddedByOrganisation.Text = tDFD.First.OrganisationName
        If tDFD.First.DFAddedByOrgID = Session("UserOrganisationID") And (Session("UserRoleAO") Or Session("UserRoleDELEG") Or Session("UserRoleIAO") Or Session("UserRoleAdmin") Or Session("UserRoleIGO")) Then
            pnlCannotFinalise.Visible = False
            Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
            Dim nCanFinalise As Integer = taq.CheckDFCanFinalise(hfFlowDetailID.Value)
            Select Case nCanFinalise
                Case 1
                    lblFinaliseDPOMessage.Text = "This data flow does not involve personal data and does not require DPO review."
                    pnlFinalise.Visible = True
                Case 2
                    pnlFinaliseDPOMessage.CssClass = "alert alert-success"
                    lblFinaliseDPOMessage.Text = "This data flow involves personal data. All DPO Reviews are in a state of Approved. This dataflow is ready to be finalised."
                    pnlFinalise.Visible = True
                Case 3
                    pnlFinaliseDPOMessage.CssClass = "alert alert-warning"
                    lblFinaliseDPOMessage.Text = "This data flow involves personal data. At least one DPO Review is in a state of Approved. There are outstanding DPO review requests that have not been actioned. This data flow may be finalised if further DPO approval is not required."
                    pnlFinalise.Visible = True
                Case 4
                    pnlFinaliseDPOMessage.CssClass = "alert alert-danger"
                    lblFinaliseDPOMessage.Text = "This data flow involves personal data. No DPO Reviews have been submitted but all review by dates are in the past. This data flow may be finalised only if DPO review cannot be obtained."
                    pnlFinalise.Visible = True
                Case -20
                    lblCannotFinaliseReason.Text = "This data flow involves personal data and does not have any DPO review requests. Go to the <b>DPO Review</b> tab and request a review before finalising this data flow."
                    pnlCannotFinalise.Visible = True
                    pnlFinalise.Visible = False
                Case -21
                    lblCannotFinaliseReason.Text = "This data flow has outstanding DPO rejections. Visit the <b>DPO Review</b> tab to see the comments made by DPOs that have rejected this flow. Once their comments have been actioned, request a re-review."
                    pnlCannotFinalise.Visible = True
                    pnlFinalise.Visible = False
                Case -22
                    lblCannotFinaliseReason.Text = "This data flow has no approved DPO reviews and outstanding review requests. Use the <b>DPO Review</b> tab to see DPO review status."
                    pnlCannotFinalise.Visible = True
                    pnlFinalise.Visible = False

            End Select

        Else
            lblCannotFinaliseReason.Text = "Only authorised users from the organisation that created the data flow (" & tDFD.First.OrganisationName & ") can finalise it."

            pnlCannotFinalise.Visible = True
            pnlFinalise.Visible = False
        End If
    End Sub

    Private Sub vDPOReview_Activate(sender As Object, e As EventArgs) Handles vDPOReview.Activate
        DoDPOReviewVis()
    End Sub
    Protected Sub DoDPOReviewVis()
        If Page.Request.Item("Action") = "Add" Then
            lbtRequestDPOSignOff.Visible = False
            gvDPOReview.EmptyDataText = "You must save this data flow before requesting DPO Review."
        ElseIf Page.Request.Item("Action") = "Edit" Then
            gvDPOReview.EmptyDataText = "No DPO review requests have been submitted, click Request DPO Review to add some."
            If pnlDFD.Enabled Then
                lbtRequestDPOSignOff.Visible = True
            Else
                If lblDFStatus.Text = "Final" Then
                    lbtRequestDPOSignOff.Visible = False
                Else
                    lbtRequestDPOSignOff.Visible = True
                End If

            End If

        End If
    End Sub

    Private Sub lbtSubmitReReviewReq_Click(sender As Object, e As EventArgs) Handles lbtSubmitReReviewReq.Click
        Dim taDFD As New DataFlowDetailTableAdapters.isp_DataFlowDetailTableAdapter
        Dim tDFD As New DataFlowDetail.isp_DataFlowDetailDataTable
        tDFD = taDFD.GetByDFDID(hfFlowDetailID.Value)
        Dim taDPO As New DataFlowDetailTableAdapters.isp_DPOReviewsTableAdapter
        Dim nOrgUserID As Integer = hfRROrgUserID.Value
        taDPO.ArchiveReview(nOrgUserID, hfFlowDetailID.Value)
        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        Dim sCC As String = taq.GetDeelegateEmailForOrgUserID(nOrgUserID)
        Dim sUsername As String = taq.GetUserNameFromOrgUserID(nOrgUserID)
        Dim dtOverride As Nullable(Of DateTime)
        Dim sPageName As String = HttpContext.Current.Request.UrlReferrer.GetLeftPart(UriPartial.Authority) & HttpContext.Current.Request.ApplicationPath & "Account/login.aspx"
        If tbReReviewByDate.Text.Length = 0 Then
            dtOverride = Nothing
        Else
            dtOverride = DateTime.ParseExact(tbReReviewByDate.Text, "d/M/yyyy", Globalization.CultureInfo.InvariantCulture, Globalization.DateTimeStyles.None)
        End If
        Dim sSubject As String = "ISG Data Flow DPO Re-Review Request - " & tDFD.First.SummaryName & " / " & tDFD.First.DFDIdentifier
        Dim nReturn As Integer = 0
        nReturn = taDPO.DataFlowDPOReview_Insert(hfFlowDetailID.Value, nOrgUserID, Session("UserEmail"), dtOverride)
        If nReturn > 0 Then

            'e-mail user if signed up for thois notification

            'user e-mail address is used as the tooltip on the username label - let's get it
            Dim sEmail As String = taq.GetEmailFromOrgUserID(nOrgUserID)

            Dim taNots As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
            Dim nRequestEmails As Integer = taNots.GetByNotificationEmail(6, sEmail)
            If nRequestEmails > 0 And Not Session("SuppressEmails") Then
                Dim sMailMessage As String = ""
                sMailMessage = sMailMessage & "<p>Dear " & sUsername & ",</p>"
                sMailMessage = sMailMessage & "<p><a href='mailto:" & Session("UserEmail") & "'>" & Session("UserOrgUserName") & " (" & Session("UserEmail") & ")</a> has requested that you review a data flow - " & tDFD.First.SummaryName & " / " & tDFD.First.DFDIdentifier & " - in the Data Protection Impact Assessment Tool (DPIA). This request will be on your In-Tray the next time you login to the ISG.</p>"

                If Not tbRequestDPOReviewComments.Text.Trim = "" Then
                    sMailMessage += "<p>When generating this request, " + Session("UserOrgUserName") + " added the following comments:</p>"
                    sMailMessage += "<hr/><p>" + tbReReviewComments.Text + "</p><hr/>"
                End If
                If tbReReviewByDate.Text.Trim.Length > 0 Then

                    sMailMessage += "<p>Please respond to this sign off request no later than " + tbReReviewByDate.Text + ".<p>"

                End If
                sMailMessage = sMailMessage & "<p>Reviewing the data flow in your role as Data Protection Officer allows you to comment on and accept or reject the flow.</p>"
                'sMailMessage = sMailMessage & "<p>If you have delegated your ISG role, your delegate will receive a copy of this e-mail and can complete the sign-off on your behalf.</p>"
                sMailMessage = sMailMessage & "<p>To login to the gateway and review the data flow, <a href='" & sPageName & "'>click here</a>.</p>"
                Utility.SendEmail(sEmail, sSubject, sMailMessage, True, , sCC)
            End If
        End If
        gvDPOReview.DataBind()
    End Sub

    Private Sub ddFrequencyOfTransfer_DataBound(sender As Object, e As EventArgs) Handles ddFrequencyOfTransfer.DataBound
        If Not ddFrequencyOfTransfer.Items.FindByValue(hfFrequency.Value) Is Nothing Then
            ddFrequencyOfTransfer.SelectedValue = hfFrequency.Value
        End If
    End Sub

    Private Sub ddNumberOfRecords_DataBound(sender As Object, e As EventArgs) Handles ddNumberOfRecords.DataBound
        If Not ddNumberOfRecords.Items.FindByValue(hfNumberOfRecords.Value) Is Nothing Then
            ddNumberOfRecords.SelectedValue = hfNumberOfRecords.Value
        End If
    End Sub

    Private Sub ddDataFlowDirection_DataBound(sender As Object, e As EventArgs) Handles ddDataFlowDirection.DataBound
        If Not ddDataFlowDirection.Items.FindByValue(hfFlowDirection.Value) Is Nothing Then
            ddDataFlowDirection.SelectedValue = hfFlowDirection.Value
        End If
    End Sub

    Private Sub ddDFDTransferSystemPlatform_DataBound(sender As Object, e As EventArgs) Handles ddDFDTransferSystemPlatform.DataBound
        If Not ddDFDTransferSystemPlatform.Items.FindByValue(hfTransferSystemPlatform.Value) Is Nothing Then
            ddDFDTransferSystemPlatform.SelectedValue = hfTransferSystemPlatform.Value
        End If
    End Sub

    Private Sub dsPIDItems_Selected(sender As Object, e As ObjectDataSourceStatusEventArgs) Handles dsPIDItems.Selected
        If e.AffectedRows > 0 Then
            pnlArticleSix.Visible = True
        End If
    End Sub

    Private Sub dsPIDSensitiveItems_Selected(sender As Object, e As ObjectDataSourceStatusEventArgs) Handles dsPIDSensitiveItems.Selected
        If e.AffectedRows > 0 Then
            pnlArticleSix.Visible = True
            pnlArticleNine.Visible = True
        End If
    End Sub

    Protected Sub bsgvAuditDetail_BeforePerformDataSelect(sender As Object, e As EventArgs)
        Session("dvDFAuditID") = (TryCast(sender, BootstrapGridView)).GetMasterRowKeyValue()
    End Sub

    Private Sub ddAuditFieldFilter_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddAuditFieldFilter.SelectedIndexChanged
        bsgvAuditHistory.DataBind()
    End Sub
End Class