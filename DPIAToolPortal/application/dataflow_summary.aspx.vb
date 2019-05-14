Imports System.IO

Public Class dataflow_summary
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim sBtnTextScript As String = My.Settings.DisableMultiselectShowAll.ToString
        If Not Page.IsPostBack Then
            Session("FlowDetailID") = Nothing
            If Not Session("nSummaryID") Is Nothing Then
                hfSummaryID.Value = Session("nSummaryID")
            End If
            hfDFFrozen.Value = 0
            If Not Page.Request.Item("action") Is Nothing Then
                If Page.Request.Item("action") = "add" Then
                    hfSummaryID.Value = 0
                End If
            End If
            'Set up role based access options
            If Session("UserRoleAdmin") = False And Session("UserRoleIAO") = False And Session("UserRoleIGO") = False Then
                pnlSummary.Enabled = False
                hfReadOnly.Value = 1
                'pnlSummary2.Enabled = False
                pnlFileUpload.Visible = False
                lbtAddOrganisation.Visible = False
                lbtSaveSummary.Visible = False
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "multiSelectDisable", "<script>function doMultiSelect() {$('.multiselector, .multiselect-dt').not('.no-freeze').attr('disabled', 'disabled').multiselect(" & sBtnTextScript & ");</script>")
                lblFormTitle.Text = "View Data Sharing Summary"
                lblFormTitle.ToolTip = "Locked because you do not have permission to edit"
            Else
                'Page.ClientScript.RegisterStartupScript(Me.GetType(), "multiSelectEnable", "<script>function doMultiSelect() {$('.multiselector').multiselect();}</script>")
                lblFormTitle.Text = "Edit Data Sharing Summary"
                hfReadOnly.Value = 0
                'pnlSummary.Enabled = True
                'pnlSummary2.Enabled = True
            End If
            hfSummaryFileGroup.Value = 0
            'Check if we have a summary id in the page request, if so, open it for editing.
            If Not hfSummaryID.Value = 0 Then
                'check if any flows have been signed off and lock the form if so:
                Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter

                lblLogTitle.Text = PadID(hfSummaryID.Value) & " Change Log"
                'Bind the multiselect lists:
                listSubjects.DataBind()
                listSchedule2.DataBind()
                listSchedule3.DataBind()
                listInformationShared.DataBind()
                listAccessors.DataBind()
                rptHistory.DataBind()
                'Load the summary details:
                Dim nFinalisedFlows As Integer = taq.GetCountFinalisedFlowsForSummary(hfSummaryID.Value)
                hfDFFrozen.Value = nFinalisedFlows
                LoadSummary(hfSummaryID.Value)
                lblFormTitle.Text = "Edit Data Sharing Summary " & PadID(hfSummaryID.Value)
                If nFinalisedFlows > 0 Then
                    lblFormTitle.Text = "View Data Sharing Summary " & PadID(hfSummaryID.Value)
                    lblFormTitle.ToolTip = "Locked because associated flows have been finalised"
                    'pnlSummary.Enabled = False
                    'pnlSummary2.Enabled = False
                    hfReadOnly.Value = 1
                    pnlFileUpload.Visible = False
                    Page.ClientScript.RegisterStartupScript(Me.GetType(), "multiSelectDisable", "<script>function doMultiSelect() {$('.multiselector, .multiselect-dt').not('.no-freeze').attr('disabled', 'disabled').multiselect(" & sBtnTextScript & "); $('.no-freeze').multiselect('enable'); $('.freeze-on-sign, .freeze-on-sign input').attr('disabled', true);}</script>")
                    'lbtAddOrganisation.Visible = False
                    lbtSaveSummary.Visible = False
                    'Else
                    'Page.ClientScript.RegisterStartupScript(Me.GetType(), "multiSelectEnable", "<script>function doMultiSelect() {$('.multiselector').multiselect();}</script>")
                ElseIf Session("orgLicenceType") = "Free, limited licence" Then
                    pnlFileUpload.Visible = False
                    pnlFreeLicenceMessage.Visible = True
                End If

                If lbtSaveSummary.Visible Then
                    'Hide the save button:
                    lbtSaveSummary.Visible = False
                    'Display the update button:
                    lbtUpdateSummary.Visible = True
                End If
                'Check if the summary has just been added
                If Not Page.Request.Item("added") Is Nothing Then
                    'It has, so show a modal popup with choices:
                    'lblModalHeading.Text = "Data Sharing Summary Added"
                    'Me.lblModalText.Text = "Your summary has been added successfully. What would you like to do?"
                    'ShowMessage(True)
                End If
                'Check if it has been updated:
                If Not Page.Request.Item("updated") Is Nothing And Not Page.IsPostBack Then
                    If CInt(Page.Request.Item("updated")) = 1 Then
                        'It has, so show a modal popup with choices:
                        lblModalHeading.Text = "Data Sharing Summary Updated"
                        Me.lblModalText.Text = "Your summary has been updated successfully."
                        ShowMessage(False)
                    Else
                        lblModalHeading.Text = "Error Updating Sharing Summary"
                        Me.lblModalText.Text = "The most likely reason for this is that another summary already exists with the same name."
                        ShowMessage(False)
                    End If
                End If
            Else
                btnHistory.Visible = False
                ClearSummary()
                lblFormTitle.Text = "Add New Data Sharing Summary"
                'Show the save button:
                lbtSaveSummary.Visible = True
                'Hide the update button:
                lbtUpdateSummary.Visible = False
                If Session("orgLicenceType") = "Free, limited licence" Then
                    pnlFileUpload.Visible = False
                    divFreeWarning.Visible = True
                End If
                'Add the user's organisation as a providing organisation by default:

                Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter

                Dim nOrgGroupID As Integer = taq.isp_DF_OrganisationGroups_Insert()
                'Session("OrgGroupID") = nOrgGroupID
                hfOrgGroupID.Value = nOrgGroupID
                Dim taDFOrgs As New ispdatasetTableAdapters.isp_DF_OrganisationsTableAdapter
                taDFOrgs.InsertQuery(nOrgGroupID, Session("UserOrganisationID"), Session("UserOrgICONum"), Session("UserOrganisationName"), True, False)
                gvOrganisations.DataBind()
                listQuickAccess.DataBind()
            End If
        Else
            If Not hfSummaryID.Value Is Nothing Then
                Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter

                Dim nSignedFlows As Integer = taq.GetSignedFlowCountForSummary(hfSummaryID.Value)
                If nSignedFlows > 0 Then
                    lblFormTitle.Text = "View Data Sharing Summary " & PadID(hfSummaryID.Value)
                    lblFormTitle.ToolTip = "Locked because associated flows have been signed off"
                    'pnlSummary.Enabled = False
                    'pnlSummary2.Enabled = False
                    pnlFileUpload.Visible = False
                    Page.ClientScript.RegisterStartupScript(Me.GetType(), "multiSelectDisable", "<script>function doMultiSelect() {$('.multiselector').not('.no-freeze').attr('disabled', 'disabled').multiselect(" & sBtnTextScript & "); $('.no-freeze').multiselect('enable'); $('.freeze-on-sign, .freeze-on-sign input').attr('disabled', true);}</script>")
                    'lbtAddOrganisation.Visible = False
                    lbtSaveSummary.Visible = False
                    'Else
                    'Page.ClientScript.RegisterStartupScript(Me.GetType(), "multiSelectEnable", "<script>function doMultiSelect() {$('.multiselector').multiselect();}</script>")
                End If
            End If
        End If
    End Sub
    Protected Function PadID(value As Integer) As String

        Dim fmt As String = "DS000000"
        Dim str As String = value.ToString(fmt)
        Return str
    End Function
    Protected Sub SizeTextBox(ByVal tb As TextBox)

    End Sub
    Protected Sub LoadSummary(ByVal sid As Integer)
        If sid = 0 Then
            Response.Redirect("summaries_list")
        End If
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        hfSummaryFileGroup.Value = taq.GetFileGroupID("summary", sid)
        Dim taS As New ispdatasetTableAdapters.isp_DataFlowSummariesFullTableAdapter
        Dim tS As New ispdataset.isp_DataFlowSummariesFullDataTable
        tS = taS.GetByID(sid)
        hfOwnedByOrganisationID.Value = tS.First.DFAddedByOrgID
        tbDataflowName.Text = tS.First.DFName
        Session("SelectedSummaryID") = sid
        tbBenefits.Text = tS.First.DFBenefits
        tbDataFields.Text = tS.First.DFDataItems
        SizeTextBox(tbDataFields)
        SizeTextBox(tbBenefits)
        ddPrivacyStatus.SelectedValue = tS.First.PrivacyStatusID
        Dim lines As String() = Me.tbDataFields.Text.Split(New [Char]() {ControlChars.Lf}, StringSplitOptions.RemoveEmptyEntries)
        Dim count As Integer = lines.Length
        tbDataFields.Rows = count
        Dim tR As ispdataset.isp_DataFlowSummariesFullRow
        tR = tS.Rows(0)
        If Not tR.IsNull("DFPreExistSigned") Then
            Dim dDateSigned As Nullable(Of Date) = tS.First.DFPreExistSigned
            tbDateSigned.Text = dDateSigned.ToString().Substring(0, 10)
        End If
        If Not tR.IsNull("OverrideReviewDate") Then
            Dim dOverrideDate As Nullable(Of Date) = tS.First.OverrideReviewDate
            tbFixedReviewDate.Text = dOverrideDate.ToString().Substring(0, 10)
        End If
        tbSubjectsOther.Text = tS.First.DFSubjectsOthers
        SizeTextBox(tbSubjectsOther)
        tbLegal.Text = tS.First.DFLegalGateway
        SizeTextBox(tbLegal)
        tbOtherAccessors.Text = tS.First.DFAccessOthers
        SizeTextBox(tbOtherAccessors)
        tbPurpose.Text = tS.First.DFPurpose
        SizeTextBox(tbPurpose)
        Dim nOrgGroupID As Integer = tS.First.DF_OrgGroupID
        'Session("OrgGroupID") = nOrgGroupID
        hfOrgGroupID.Value = nOrgGroupID
        gvOrganisations.DataBind()
        listQuickAccess.DataBind()
        ddAsset.DataBind()
        ddReviewCycle.DataBind()
        listSubjects.DataBind()
        listSchedule2.DataBind()
        listSchedule3.DataBind()
        listInformationShared.DataBind()
        listAccessors.DataBind()
        listFormats.DataBind()
        listPersonalItemsEdit.DataBind()
        listPersonalSensitiveItems.DataBind()
        'ddFormat.SelectedValue = tS.First.DFStructure
        ddAsset.SelectedValue = tS.First.DataAssetID
        ddReviewCycle.SelectedValue = tS.First.DFReviewCycle

    End Sub
    Protected Sub ClearSummary()
        tbDataflowName.Text = ""
        tbBenefits.Text = ""
        tbDataFields.Text = ""
        tbDateSigned.Text = ""
        tbLegal.Text = ""
        tbOtherAccessors.Text = ""
        tbPurpose.Text = ""
        tbSubjectsOther.Text = ""
    End Sub

    Private Sub gvOrganisations_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvOrganisations.RowCommand
        If e.CommandName = "ViewOrgDetails" Then
            Dim orgd As OrgDetailsModal = OrgDetailsModal
            If Not e.CommandArgument Is Nothing Then
                Dim nOrgID As Integer = CInt(e.CommandArgument)
                Dim ds As ObjectDataSource = orgd.FindControl("dsOrganisationDetails")
                ds.SelectParameters(0).DefaultValue = nOrgID
                Dim fv As FormView = orgd.FindControl("fvOrgDetails")
                fv.DataBind()
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "orgDetailsModalOpen", "$('#modalOrgDetails').modal('show');", True)
            End If
        End If
    End Sub
    Private Sub gvOrganisations_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvOrganisations.RowDataBound
        If e.Row.Cells.Count > 1 Then
            'e.Row.Cells(0).CssClass = "hiddencol"
            e.Row.Cells(1).CssClass = "hiddencol"
            e.Row.Cells(2).CssClass = "hiddencol"
            e.Row.Cells(3).CssClass = "hiddencol"
            If hfDFFrozen.Value > 0 Then
                e.Row.Cells(0).CssClass = "hiddencol"
                e.Row.Cells(9).CssClass = "hiddencol"
            End If
        End If
    End Sub

    Private Sub lbtAddOrganisation_Click(sender As Object, e As EventArgs) Handles lbtAddOrganisation.Click
        tbICOSearch.Text = ""
        tbOrgNameSearch.Text = ""
        mvSearch.SetActiveView(vCriteria)
        ShowSearch()
    End Sub

    Private Sub lbtSearch_Click(sender As Object, e As EventArgs) Handles lbtSearch.Click
        Dim sRegNum As String = tbICOSearch.Text
        Dim sOrgSearch As String = tbOrgNameSearch.Text.Replace(" ", "%")
        Dim taOrg As New ispdatasetTableAdapters.isp_OrganisationsTableAdapter
        Dim tOrg As New ispdataset.isp_OrganisationsDataTable
        Dim taICO As New ispdatasetTableAdapters.isp_ICO_RegisterTableAdapter
        Dim tICO As New ispdataset.isp_ICO_RegisterDataTable
        If sRegNum.Length > 1 Then
            tOrg = taOrg.GetDataByICONumber(sRegNum)
            tICO = taICO.GetDataByRegNum(sRegNum)
        Else
            tOrg = taOrg.GetDataByOrgName(sOrgSearch)
            tICO = taICO.GetDataByOrgName(sOrgSearch)
        End If
        gvISSResults.DataSource = tOrg
        gvISSResults.DataBind()
        gvICORes.DataSource = tICO
        gvICORes.DataBind()
        mvSearch.SetActiveView(vResults)
        ShowSearch()
    End Sub

    Private Sub lbtSearchAgain_Click(sender As Object, e As EventArgs) Handles lbtSearchAgain.Click, lbtSearchAgain2.Click
        mvSearch.SetActiveView(vCriteria)
        ShowSearch()
    End Sub
    Protected Sub ShowSearch()
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalSearch", "$('#modalSearch').modal('show');", True)
    End Sub
    Protected Sub ShowMessage(Optional ByVal ShowOptions As Boolean = False)
        If ShowOptions Then
            btnCloseModal.Visible = False
            lbtAddedReturn.Visible = True
            lbtAddDetail.Visible = True
            ModalOK.Visible = False
        Else
            lbtAddedReturn.Visible = False
            lbtAddDetail.Visible = False
            ModalOK.Visible = True
        End If
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalMessage", "<script>$('#modalMessage').modal('show');</script>")
        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalMessage", "$('#modalMessage').modal('show');", True)
    End Sub
    Private Sub gvICORes_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvICORes.RowCommand
        If e.CommandName = "Select" Then
            Dim gvr As GridViewRow = DirectCast(DirectCast(e.CommandSource, Control).Parent.Parent, GridViewRow)
            Dim sICO As String = gvr.Cells.Item(1).Text
            Dim tb As Label = gvr.FindControl("lblOrgName")
            Dim sOrgName As String = tb.Text
            hfICONum.Value = sICO
            hfOrgName.Value = Server.HtmlEncode(sOrgName)
            hfOrganisationID.Value = Nothing
            lblOrganisation.Text = sOrgName
            cbProviding.Checked = False
            cbReceiving.Checked = False
            mvSearch.SetActiveView(vDirection)
            ShowSearch()
        End If
    End Sub

    Private Sub gvISSResults_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvISSResults.RowCommand
        If e.CommandName = "Select" Then
            Dim gvr As GridViewRow = DirectCast(DirectCast(e.CommandSource, Control).Parent.Parent, GridViewRow)
            Dim sICO As String = gvr.Cells.Item(1).Text
            Dim sOrgName As String = gvr.Cells.Item(2).Text
            hfICONum.Value = sICO
            hfOrgName.Value = Server.HtmlEncode(sOrgName)
            hfOrganisationID.Value = e.CommandArgument
            lblOrganisation.Text = sOrgName
            cbProviding.Checked = False
            cbReceiving.Checked = False
            mvSearch.SetActiveView(vDirection)
            ShowSearch()
        End If
    End Sub

    Private Sub lbtConfirmAddOrg_Click(sender As Object, e As EventArgs) Handles lbtConfirmAddOrg.Click
        'If cbProviding.Checked = False And cbReceiving.Checked = False Then
        '    lblDirectionError.Visible = True
        '    ShowSearch()
        'Else
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        If hfOrgGroupID.Value = 0 Then
            Dim nOrgGroupID As Integer = taq.isp_DF_OrganisationGroups_Insert()
            'Session("OrgGroupID") = nOrgGroupID
            hfOrgGroupID.Value = nOrgGroupID
        End If
        Dim taDFOrgs As New ispdatasetTableAdapters.isp_DF_OrganisationsTableAdapter
        Dim nOrgID As Nullable(Of Integer)
        If hfOrganisationID.Value = "" Then
            nOrgID = Nothing
        Else
            nOrgID = hfOrganisationID.Value
        End If
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "RemoveModalClass", "<script>$('body').removeClass('modal-open');</script>")
        taDFOrgs.InsertQuery(hfOrgGroupID.Value, nOrgID, hfICONum.Value, Server.HtmlDecode(hfOrgName.Value), cbProviding.Checked, cbReceiving.Checked)
        gvOrganisations.DataBind()
        listQuickAccess.DataBind()
        'End If
    End Sub

    Private Sub lbtSaveNewOrg_Click(sender As Object, e As EventArgs) Handles lbtSaveNewOrg.Click
        hfICONum.Value = tbOrgICOAdd.Text
        hfOrgName.Value = Server.HtmlEncode(tbOrgNameAdd.Text)
        hfOrganisationID.Value = Nothing
        lblOrganisation.Text = tbOrgNameAdd.Text
        cbProviding.Checked = False
        cbReceiving.Checked = False
        mvSearch.SetActiveView(vDirection)
        ShowSearch()
    End Sub

    Private Sub listInformationShared_SelectedIndexChanged(sender As Object, e As EventArgs) Handles listInformationShared.SelectedIndexChanged
        'ShowHideScheduleTwoThree()
    End Sub
    'Protected Sub ShowHideScheduleTwoThree()
    '    Dim li As ListItem = listInformationShared.Items(0)
    '    Dim liTwo As ListItem = listInformationShared.Items(1)
    '    If li.Selected Or liTwo.Selected Then
    '        divSchedTwo.Visible = True
    '    Else
    '        divSchedTwo.Visible = False
    '    End If

    '    If liTwo.Selected Then
    '        divSchedThree.Visible = True
    '    Else
    '        divSchedThree.Visible = False
    '    End If
    'End Sub
    Private Sub lbtSaveSummary_Click(sender As Object, e As EventArgs) Handles lbtSaveSummary.Click
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        'Set up the CSVs:
        Dim sAccessorsCSV As String = ""
        Dim sInformationSharedCSV As String = ""
        Dim sSubjectsCSV As String = ""
        Dim sSchedule2CSV As String = ""
        Dim sSchedule3CSV As String = ""
        Dim sFormatsCSV As String = ""
        Dim sPIDItemsCSV As String = ""
        'Go through list boxes and populate CSV strings:
        For Each li As ListItem In listInformationShared.Items
            If li.Selected Then
                sInformationSharedCSV = sInformationSharedCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listSubjects.Items
            If li.Selected Then
                sSubjectsCSV = sSubjectsCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listAccessors.Items
            If li.Selected Then
                sAccessorsCSV = sAccessorsCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listSchedule2.Items
            If li.Selected Then
                sSchedule2CSV = sSchedule2CSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listSchedule3.Items
            If li.Selected Then
                sSchedule3CSV = sSchedule3CSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listFormats.Items
            If li.Selected Then
                sFormatsCSV = sFormatsCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listPersonalItemsEdit.Items
            If li.Selected Then
                sPIDItemsCSV = sPIDItemsCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listPersonalSensitiveItems.Items
            If li.Selected Then
                sPIDItemsCSV = sPIDItemsCSV + li.Value.ToString() + ", "
            End If
        Next
        'Trim the trailing , from the CSV string:
        If sAccessorsCSV.Length > 2 Then
            sAccessorsCSV = sAccessorsCSV.Substring(0, sAccessorsCSV.Length - 2)
        End If
        If sSubjectsCSV.Length > 2 Then
            sSubjectsCSV = sSubjectsCSV.Substring(0, sSubjectsCSV.Length - 2)
        End If
        If sInformationSharedCSV.Length > 2 Then
            sInformationSharedCSV = sInformationSharedCSV.Substring(0, sInformationSharedCSV.Length - 2)
        End If
        If sSchedule2CSV.Length > 2 Then
            sSchedule2CSV = sSchedule2CSV.Substring(0, sSchedule2CSV.Length - 2)
        End If
        If sSchedule3CSV.Length > 2 Then
            sSchedule3CSV = sSchedule3CSV.Substring(0, sSchedule3CSV.Length - 2)
        End If
        If sFormatsCSV.Length > 2 Then
            sFormatsCSV = sFormatsCSV.Substring(0, sFormatsCSV.Length - 2)
        End If
        If sPIDItemsCSV.Length > 2 Then
            sPIDItemsCSV = sPIDItemsCSV.Substring(0, sPIDItemsCSV.Length - 2)
        End If
        'Get the file attachment if there is one:
        Dim nFileID As Nullable(Of Integer)
        'If filEvidence.PostedFile IsNot Nothing Then

        '    'Dim sExtension As String = System.IO.Path.GetExtension(Me.filEvidence.PostedFile.FileName).ToLower()
        '    Dim sFilename As String = System.IO.Path.GetFileName(Me.filEvidence.PostedFile.FileName)
        '    Dim nMaxKB As Integer = 256
        '    If Me.filEvidence.PostedFile.InputStream.Length > nMaxKB * 1024 Then
        '        lblModalHeading.Text = "Evidence file too big"
        '        Me.lblModalText.Text = sFilename + " is too big. Maximum file size is " + nMaxKB.ToString() + "K."
        '        ShowMessage()
        '        Exit Sub
        '    End If
        '    Dim size As Integer = Me.filEvidence.PostedFile.ContentLength
        '    Dim sContentType As String = filEvidence.PostedFile.ContentType
        '    Dim fileData As Byte() = New Byte(size - 1) {}
        '    Me.filEvidence.PostedFile.InputStream.Read(fileData, 0, size)
        '    nFileID = taq.InsertFile(sFilename, sContentType, Me.filEvidence.PostedFile.InputStream.Length / 1024, fileData, Session("UserOrganisationID"), Session("UserEmail"))
        'End If
        If nFileID < 1 Then
            nFileID = Nothing
        End If
        'Get userid:
        Dim currentUser As MembershipUser = Membership.GetUser()
        Dim currentUserId As Guid = DirectCast(currentUser.ProviderUserKey, Guid)
        Dim dtSigned As Nullable(Of DateTime)
        If tbDateSigned.Text.Length = 0 Then
            dtSigned = Nothing
        Else
            dtSigned = DateTime.ParseExact(tbDateSigned.Text, "d/M/yyyy", Globalization.CultureInfo.InvariantCulture, Globalization.DateTimeStyles.None)
        End If
        Dim dtOverride As Nullable(Of DateTime)
        If tbFixedReviewDate.Text.Length = 0 Then
            dtOverride = Nothing
        Else
            dtOverride = DateTime.ParseExact(tbFixedReviewDate.Text, "d/M/yyyy", Globalization.CultureInfo.InvariantCulture, Globalization.DateTimeStyles.None)
        End If
        Dim nInserted As Integer = taq.DataFlowSummary_Insert(tbDataflowName.Text, ddAsset.SelectedValue, tbPurpose.Text, tbLegal.Text, tbBenefits.Text, tbDataFields.Text, tbOtherAccessors.Text, dtSigned, ddReviewCycle.SelectedValue, nFileID, sAccessorsCSV, sInformationSharedCSV, sSubjectsCSV, sSchedule2CSV, sSchedule3CSV, Session("UserEmail"), currentUserId, Session("UserOrganisationID"), hfOrgGroupID.Value, sFormatsCSV, tbSubjectsOther.Text, dtOverride, ddPrivacyStatus.SelectedValue, sPIDItemsCSV)
        If nInserted > 0 Then
            Session("nSummaryID") = nInserted
            Session("FlowDetailID") = Nothing
            taq.FileGroups_UpdateID(nInserted, hfSummaryFileGroup.Value)
            lblModalHeading.Text = "Data Sharing Summary Added"
            Me.lblModalText.Text = "Your summary has been added successfully. What would you like to do?"
            hfSummaryID.Value = nInserted
            'lbtAddDetail.PostBackUrl = "~/application/summaries_list.aspx"
            ShowMessage(True)
        ElseIf nInserted = -10 Then
            lblModalHeading.Text = "A Data Sharing Summary Already Exists"
            Me.lblModalText.Text = "A data sharing summary with that name already exists. Please enter a unique name / identifier for the summary."
            ShowMessage(False)
        Else
            lblModalHeading.Text = "Could Not Save Data Sharing Summary"
            Me.lblModalText.Text = "This may be because your login has expired. Try logging out and logging back in again before attempting to re-add the summary. If the problem persists, please contact DPIA support."
            ShowMessage(False)
        End If
    End Sub
    Private Sub ddAsset_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddAsset.SelectedIndexChanged
        For Each li As ListItem In listFormats.Items
            li.Selected = False
        Next

        For Each li As ListItem In listSubjects.Items
            li.Selected = False
        Next

        For Each li As ListItem In listInformationShared.Items
            li.Selected = False
        Next
        For Each li As ListItem In listPersonalItemsEdit.Items
            li.Selected = False
        Next
        For Each li As ListItem In listPersonalSensitiveItems.Items
            li.Selected = False
        Next
        pnlSchedTwo.CssClass = "alert alert-warning clearfix collapse"
        pnlSchedThree.CssClass = "alert alert-danger clearfix collapse"
        Dim nAssetID As Integer = ddAsset.SelectedValue
        If nAssetID > 0 Then
            Dim taFormats As New ispdatasetTableAdapters.isp_DataAssetFormatTableAdapter
            Dim tFormats As New ispdataset.isp_DataAssetFormatDataTable
            tFormats = taFormats.GetDataByAssetID(nAssetID)
            Dim nFormatID As Integer
            For Each row As DataRow In tFormats.Rows
                nFormatID = row.Item("DataFormatID")
                For Each li As ListItem In listFormats.Items
                    If li.Value = nFormatID Then
                        li.Selected = True
                    End If
                Next
            Next

            Dim taSubjects As New ispdatasetTableAdapters.isp_DataAssetSubjectTableAdapter
            Dim tSubjects As New ispdataset.isp_DataAssetSubjectDataTable
            tSubjects = taSubjects.GetDataByAssetID(nAssetID)
            Dim nSubjectID As Integer
            For Each row As DataRow In tSubjects.Rows
                nSubjectID = row.Item("DataSubjectID")
                For Each li As ListItem In listSubjects.Items
                    If li.Value = nSubjectID Then
                        li.Selected = True
                    End If
                Next
            Next

            Dim taDataTypes As New ispdatasetTableAdapters.isp_DataAssetTypeTableAdapter
            Dim tDataTypes As New ispdataset.isp_DataAssetTypeDataTable
            tDataTypes = taDataTypes.GetDataByAssetID(nAssetID)
            Dim nDataTypeID As Integer
            For Each row As DataRow In tDataTypes.Rows
                nDataTypeID = row.Item("DataTypeID")
                For Each li As ListItem In listInformationShared.Items
                    If li.Value = nDataTypeID Then
                        li.Selected = True
                        If li.Value = 1 Then
                            pnlSchedTwo.CssClass = "alert alert-warning clearfix collapse-in"
                        ElseIf li.Value = 2 Then
                            pnlSchedTwo.CssClass = "alert alert-warning clearfix collapse-in"
                            pnlSchedThree.CssClass = "alert alert-danger clearfix collapse-in"
                        End If

                    End If
                Next
            Next
            Dim taPIDItems As New ispdatasetTableAdapters.isp_DataAssetPIDItemsTableAdapter
            Dim tPIDItems As New ispdataset.isp_DataAssetPIDItemsDataTable
            tPIDItems = taPIDItems.GetDataByAssetID(nAssetID)
            Dim nPIDItemID As Integer
            For Each row As DataRow In tPIDItems.Rows
                nPIDItemID = row.Item("PIDItemID")
                For Each li As ListItem In listPersonalItemsEdit.Items
                    If li.Value = nPIDItemID Then
                        li.Selected = True
                    End If
                Next
                For Each li As ListItem In listPersonalSensitiveItems.Items
                    If li.Value = nPIDItemID Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
        'ShowHideScheduleTwoThree()
    End Sub



    Private Sub lbtUpdateSummary_Click(sender As Object, e As EventArgs) Handles lbtUpdateSummary.Click
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        'Set up the CSVs:
        Dim sAccessorsCSV As String = ""
        Dim sInformationSharedCSV As String = ""
        Dim sSubjectsCSV As String = ""
        Dim sSchedule2CSV As String = ""
        Dim sSchedule3CSV As String = ""
        Dim sFormatsCSV As String = ""
        Dim sPIDItemsCSV As String = ""
        'Go through list boxes and populate CSV strings:
        For Each li As ListItem In listInformationShared.Items
            If li.Selected Then
                sInformationSharedCSV = sInformationSharedCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listSubjects.Items
            If li.Selected Then
                sSubjectsCSV = sSubjectsCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listAccessors.Items
            If li.Selected Then
                sAccessorsCSV = sAccessorsCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listSchedule2.Items
            If li.Selected Then
                sSchedule2CSV = sSchedule2CSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listSchedule3.Items
            If li.Selected Then
                sSchedule3CSV = sSchedule3CSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listFormats.Items
            If li.Selected Then
                sFormatsCSV = sFormatsCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listPersonalItemsEdit.Items
            If li.Selected Then
                sPIDItemsCSV = sPIDItemsCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listPersonalSensitiveItems.Items
            If li.Selected Then
                sPIDItemsCSV = sPIDItemsCSV + li.Value.ToString() + ", "
            End If
        Next
        'Trim the trailing , from the CSV string:
        If sAccessorsCSV.Length > 2 Then
            sAccessorsCSV = sAccessorsCSV.Substring(0, sAccessorsCSV.Length - 2)
        End If
        If sSubjectsCSV.Length > 2 Then
            sSubjectsCSV = sSubjectsCSV.Substring(0, sSubjectsCSV.Length - 2)
        End If
        If sInformationSharedCSV.Length > 2 Then
            sInformationSharedCSV = sInformationSharedCSV.Substring(0, sInformationSharedCSV.Length - 2)
        End If
        If sSchedule2CSV.Length > 2 Then
            sSchedule2CSV = sSchedule2CSV.Substring(0, sSchedule2CSV.Length - 2)
        End If
        If sSchedule3CSV.Length > 2 Then
            sSchedule3CSV = sSchedule3CSV.Substring(0, sSchedule3CSV.Length - 2)
        End If
        If sFormatsCSV.Length > 2 Then
            sFormatsCSV = sFormatsCSV.Substring(0, sFormatsCSV.Length - 2)
        End If
        If sPIDItemsCSV.Length > 2 Then
            sPIDItemsCSV = sPIDItemsCSV.Substring(0, sPIDItemsCSV.Length - 2)
        End If
        'Get the file attachment if there is one:

        Dim dtSigned As Nullable(Of DateTime)
        If tbDateSigned.Text.Length = 0 Then
            dtSigned = Nothing
        Else
            dtSigned = DateTime.ParseExact(tbDateSigned.Text, "d/M/yyyy", Globalization.CultureInfo.InvariantCulture, Globalization.DateTimeStyles.None)
        End If
        Dim dtOverride As Nullable(Of DateTime)
        If tbFixedReviewDate.Text.Length = 0 Then
            dtOverride = Nothing
        Else
            dtOverride = DateTime.ParseExact(tbFixedReviewDate.Text, "d/M/yyyy", Globalization.CultureInfo.InvariantCulture, Globalization.DateTimeStyles.None)
        End If
        'Get the userid:
        Dim currentUser As MembershipUser = Membership.GetUser()
        Dim currentUserId As Guid = DirectCast(currentUser.ProviderUserKey, Guid)

        Dim nSummaryID As Integer = hfSummaryID.Value
        Session("nSummaryID") = hfSummaryID.Value
        'Dim nUserOrganisationID As Integer = Session("UserOrganisationID")
        Dim nUpdated As Integer = taq.DataFlowSummary_Update(nSummaryID, tbDataflowName.Text, ddAsset.SelectedValue, tbPurpose.Text, tbLegal.Text, tbBenefits.Text, tbDataFields.Text, tbOtherAccessors.Text, dtSigned, ddReviewCycle.SelectedValue, sAccessorsCSV, sInformationSharedCSV, sSubjectsCSV, sSchedule2CSV, sSchedule3CSV, hfOwnedByOrganisationID.Value, sFormatsCSV, tbSubjectsOther.Text, currentUserId, dtOverride, ddPrivacyStatus.SelectedValue, sPIDItemsCSV)
        If nUpdated > 0 Then
            RemovePDFsForSummaryFlows()
            Response.Redirect("~/application/dataflow_summary.aspx?summaryid=" & hfSummaryID.Value & "&updated=1")
        Else
            Response.Redirect("~/application/dataflow_summary.aspx?summaryid=" & hfSummaryID.Value & "&updated=0")
        End If
    End Sub
    Protected Sub RemovePDFsForSummaryFlows()
        Dim taDFD As New DataFlowDetailTableAdapters.DFDIDForSummaryTableAdapter
        Dim tDFD As New DataFlowDetail.DFDIDForSummaryDataTable
        tDFD = taDFD.GetData(hfSummaryID.Value)
        For Each r As DataRow In tDFD
            Dim pdfName As String = Server.MapPath("~/application/pdfout/") + "DPIA_ISA_" & r.Item("DataFlowDetailID") & ".pdf"
            If File.Exists(pdfName) Then
                File.Delete(pdfName)
            End If
        Next
    End Sub
    Private Sub lbtUpload_Click(sender As Object, e As EventArgs) Handles lbtUpload.Click
        Dim nSummaryID = 0
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        If Not hfSummaryID.Value Is Nothing Then
            nSummaryID = hfSummaryID.Value
        End If
        If hfSummaryFileGroup.Value = 0 Then
            hfSummaryFileGroup.Value = taq.isp_FileGroup_Insert("summary", nSummaryID)
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
                    lblModalHeading.Text = "Evidence file error"
                    Me.lblModalText.Text = Me.lblModalText.Text + "<p>" + sFilename + " is too big. Maximum file size is " + (nMaxKB / 1024).ToString() + "MB." + "</p>"
                    bShowWarning = True
                Else
                    Dim size As Integer = pFile.ContentLength
                    Dim sContentType As String = pFile.ContentType
                    Dim fileData As Byte() = New Byte(size - 1) {}
                    pFile.InputStream.Read(fileData, 0, size)
                    nFileID = taq.InsertFile(sFilename, sContentType, pFile.InputStream.Length / 1024, fileData, Session("UserOrganisationID"), Session("UserEmail"))
                    If nFileID > 0 Then
                        taq.FileGroupFile_Insert(hfSummaryFileGroup.Value, nFileID)
                    Else
                        lblModalHeading.Text = "Evidence file error"
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

    Private Sub rptFiles_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptFiles.ItemCommand
        If e.CommandName = "Delete" Then
            Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
            taq.File_Delete(CInt(e.CommandArgument))
            rptFiles.DataBind()
        End If
    End Sub

    Private Sub rptFiles_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptFiles.ItemDataBound
        If pnlFileUpload.Visible = False Then
            Dim lbt As LinkButton = e.Item.FindControl("lbtDelete")
            If Not lbt Is Nothing Then
                lbt.Visible = False
            End If
        End If
    End Sub

    Private Sub lbtAddSelected_Click(sender As Object, e As EventArgs) Handles lbtAddSelected.Click
        Dim taAssOrgs As New DataFlowDetailTableAdapters.isp_AssociatedOrganisationsTableAdapter
        Dim tAssOrgs As New DataFlowDetail.isp_AssociatedOrganisationsDataTable
        Dim taDFOrgs As New ispdatasetTableAdapters.isp_DF_OrganisationsTableAdapter
        For Each li As ListItem In listQuickAccess.Items
            If li.Selected Then
                tAssOrgs = taAssOrgs.GetByID(li.Value)
                If tAssOrgs.Count > 0 Then
                    taDFOrgs.InsertQuery(hfOrgGroupID.Value, tAssOrgs.First.OrganisationID, tAssOrgs.First.ICORegistrationNumber, tAssOrgs.First.OrganisationName, cbProvidingQuickAdd.Checked, cbReceivingQuickAdd.Checked)
                End If
            End If
        Next
        gvOrganisations.DataBind()
        listQuickAccess.DataBind()
    End Sub

    Private Sub listSubjects_DataBound(sender As Object, e As EventArgs) Handles listSubjects.DataBound
        Dim nSummaryID = 0
        If Not hfSummaryID.Value Is Nothing Then
            nSummaryID = hfSummaryID.Value
        End If
        If nSummaryID > 0 Then
            Dim taSubjects As New ispdatasetTableAdapters.isp_DF_DFSubjectsTableAdapter
            Dim tSubjects As New ispdataset.isp_DF_DFSubjectsDataTable
            tSubjects = taSubjects.GetByDataFlowID(nSummaryID)

            For Each r As DataRow In tSubjects.Rows
                For Each li As ListItem In listSubjects.Items
                    If li.Value = r.Item("DFSubjectID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listSchedule2_DataBound(sender As Object, e As EventArgs) Handles listSchedule2.DataBound
        Dim nSummaryID = 0
        If Not hfSummaryID.Value Is Nothing Then
            nSummaryID = hfSummaryID.Value
        End If
        If nSummaryID > 0 Then
            Dim taSched2 As New ispdatasetTableAdapters.isp_DF_ScheduleTwosTableAdapter
            Dim tSched2 As New ispdataset.isp_DF_ScheduleTwosDataTable
            tSched2 = taSched2.GetByDataFlowID(nSummaryID)
            For Each r As DataRow In tSched2.Rows
                For Each li As ListItem In listSchedule2.Items
                    If li.Value = r.Item("SchTwoPurposeID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listSchedule3_DataBound(sender As Object, e As EventArgs) Handles listSchedule3.DataBound
        Dim nSummaryID = 0
        If Not hfSummaryID.Value Is Nothing Then
            nSummaryID = hfSummaryID.Value
        End If
        If nSummaryID > 0 Then
            Dim taSched3 As New ispdatasetTableAdapters.isp_DF_ScheduleThreesTableAdapter
            Dim tSched3 As New ispdataset.isp_DF_ScheduleThreesDataTable
            tSched3 = taSched3.GetByDataFlowID(nSummaryID)
            For Each r As DataRow In tSched3.Rows
                For Each li As ListItem In listSchedule3.Items
                    If li.Value = r.Item("ScheduleThreeID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listInformationShared_DataBound(sender As Object, e As EventArgs) Handles listInformationShared.DataBound
        Dim nSummaryID = 0
        If Not hfSummaryID.Value Is Nothing Then
            nSummaryID = hfSummaryID.Value
        End If
        If nSummaryID > 0 Then
            Dim taInfoShared As New ispdatasetTableAdapters.isp_DF_InformationSharedTableAdapter
            Dim tInfoShared As New ispdataset.isp_DF_InformationSharedDataTable
            tInfoShared = taInfoShared.GetByDataFlowID(nSummaryID)
            For Each r As DataRow In tInfoShared.Rows
                For Each li As ListItem In listInformationShared.Items
                    If li.Value = r.Item("InformationSharedID") Then
                        li.Selected = True
                        If li.Value = 1 Then
                            pnlSchedTwo.CssClass = "alert alert-warning clearfix collapse-in"
                        ElseIf li.Value = 2 Then
                            pnlSchedTwo.CssClass = "alert alert-warning clearfix collapse-in"
                            pnlSchedThree.CssClass = "alert alert-danger clearfix collapse-in"
                        End If
                    End If
                Next
            Next
            'ShowHideScheduleTwoThree()
        End If
    End Sub

    Private Sub listAccessors_DataBound(sender As Object, e As EventArgs) Handles listAccessors.DataBound
        Dim nSummaryID = 0
        If Not hfSummaryID.Value Is Nothing Then
            nSummaryID = hfSummaryID.Value
        End If
        If nSummaryID > 0 Then
            Dim taAccessors As New ispdatasetTableAdapters.isp_DF_DFAccessorsTableAdapter
            Dim tAccessors As New ispdataset.isp_DF_DFAccessorsDataTable
            tAccessors = taAccessors.GetByDataFlowID(nSummaryID)
            For Each r As DataRow In tAccessors.Rows
                For Each li As ListItem In listAccessors.Items
                    If li.Value = r.Item("DFAccessorID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listFormats_DataBound(sender As Object, e As EventArgs) Handles listFormats.DataBound
        Dim nSummaryID = 0
        If Not hfSummaryID.Value Is Nothing Then
            nSummaryID = hfSummaryID.Value
        End If
        If nSummaryID > 0 Then
            Dim taFormats As New ispdatasetTableAdapters.isp_DF_FormatsTableAdapter
            Dim tFormats As New ispdataset.isp_DF_FormatsDataTable
            tFormats = taFormats.GetByDataFlowID(nSummaryID)
            For Each r As DataRow In tFormats.Rows
                For Each li As ListItem In listFormats.Items
                    If li.Value = r.Item("FormatID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listPersonalItemsEdit_DataBound(sender As Object, e As EventArgs) Handles listPersonalItemsEdit.DataBound
        Dim nSummaryID = 0
        If Not hfSummaryID.Value Is Nothing Then
            nSummaryID = hfSummaryID.Value
        End If
        If nSummaryID > 0 Then
            Dim taPID As New ispdatasetTableAdapters.isp_DF_PIDItemsTableAdapter
            Dim tPID As New ispdataset.isp_DF_PIDItemsDataTable
            tPID = taPID.GetBySummaryID(nSummaryID)
            For Each r As DataRow In tPID.Rows
                For Each li As ListItem In listPersonalItemsEdit.Items
                    If li.Value = r.Item("PIDItemsID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub

    Private Sub listPersonalSensitiveItems_DataBound(sender As Object, e As EventArgs) Handles listPersonalSensitiveItems.DataBound
        Dim nSummaryID = 0
        If Not hfSummaryID.Value Is Nothing Then
            nSummaryID = hfSummaryID.Value
        End If
        If nSummaryID > 0 Then
            Dim taPID As New ispdatasetTableAdapters.isp_DF_PIDItemsTableAdapter
            Dim tPID As New ispdataset.isp_DF_PIDItemsDataTable
            tPID = taPID.GetBySummaryID(nSummaryID)
            For Each r As DataRow In tPID.Rows
                For Each li As ListItem In listPersonalSensitiveItems.Items
                    If li.Value = r.Item("PIDItemsID") Then
                        li.Selected = True
                    End If
                Next
            Next
        End If
    End Sub
End Class