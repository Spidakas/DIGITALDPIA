Imports System.Globalization

Public Class org_assurance
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		If Not Page.IsPostBack Then
            If Session("orgLicenceType") = "Free, limited licence" Then
                pnlFileUpload.Visible = False
            End If
            Session("AgreementFileGroupID") = 0
            Dim taTOU As New adminTableAdapters.isp_TermsOfUseTableAdapter
            Dim tTOU As New admin.isp_TermsOfUseDataTable
            tTOU = taTOU.GetCurrent("MOU")
            If tTOU.Count > 0 Then
                litMOUTextSO.Text = tTOU.First.TermsHTML
                litMOUView.Text = tTOU.First.TermsHTML
            End If
        End If
        ScriptManager.RegisterStartupScript(Me, Me.GetType, "DatePicker", " $('#tbICOReviewDate').datepicker({ dateFormat: 'dd/mm/yy' });", True)
        If Session("UserRoleAO") Or Session("UserRoleDELEG") Then
            lbtSignAgreement.Visible = True
            pnlWhoCanSign.Visible = False
        Else
            lbtSignAgreement.Visible = False
			pnlWhoCanSign.Visible = True
        End If

        If Session("UserRoleAO") Or Session("UserRoleAdmin") Or Session("UserRoleIGO") Then
            lbtAddAssurance.Visible = True
        Else
            lbtAddAssurance.Visible = False
        End If
    End Sub

    Private Sub lbtAddAssurance_Click(sender As Object, e As EventArgs) Handles lbtAddAssurance.Click

        Me.mvAssurance.SetActiveView(vSubmitAssurance)
    End Sub

    Private Sub rblICOReg_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rblICOReg.SelectedIndexChanged
        If rblICOReg.SelectedValue = 0 Then
            divICONotRegReason.Visible = True
            divICODetails.Visible = False
        Else
            divICONotRegReason.Visible = False
            divICODetails.Visible = True
        End If
    End Sub

    Private Sub lbtCancelInsert_Click(sender As Object, e As EventArgs) Handles lbtCancelInsert.Click
        ClearSubmissionForm()
        Me.mvAssurance.SetActiveView(Me.vCurrentAssurance)
    End Sub
    Protected Function DoWarning(ByVal checked As Boolean)
        If checked Then
            Return ""
        Else
            Return "list-group-item-danger"
        End If
    End Function
    Private Sub ddCompliance_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddCompliance.SelectedIndexChanged
        If ddCompliance.SelectedValue > -1 Then
            If ddCompliance.SelectedItem.Text = "None" Then
                divNonComplianceReason.Visible = True
                lblNonComplianceReason.Text = "Provide details of other compliancy or reason why you are not compliant:"
                divComplianceScoreVersion.Visible = False
            ElseIf ddCompliance.SelectedItem.Text.Contains("Assurance") Then
                divNonComplianceReason.Visible = True
                lblNonComplianceReason.Text = "Provide details of assurance / compliance:"
                divComplianceScoreVersion.Visible = False
            Else
                divNonComplianceReason.Visible = False
                divComplianceScoreVersion.Visible = True
            End If
        Else
            divComplianceScoreVersion.Visible = False
            divNonComplianceReason.Visible = False
        End If
    End Sub

    Private Sub rblScreened_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rblScreened.SelectedIndexChanged
        If rblScreened.SelectedValue = 0 Then
            divStaffScreeningDetails.Visible = False
            divNoScreeningReason.Visible = True
        Else
            divStaffScreeningDetails.Visible = True
            divNoScreeningReason.Visible = False
        End If
    End Sub

    Private Sub rblIGTrained_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rblIGTrained.SelectedIndexChanged
        If rblIGTrained.SelectedValue = 0 Then
            divStaffTrained.Visible = False
            divStaffNotTrained.Visible = True
        Else
            divStaffTrained.Visible = True
            divStaffNotTrained.Visible = False
        End If
    End Sub
    Protected Sub ClearSubmissionForm()
        rblICOReg.SelectedIndex = -1
        tbICONotRegReason.Text = ""
        tbICORegNumber.Text = ""
        tbICOReviewDate.Text = ""
        ddCompliance.SelectedValue = -1
        tbToolkitVersion.Text = ""
        tbNonComplianceReason.Text = ""
        rblScreened.SelectedIndex = -1
        tbStaffScreeningDetails.Text = ""
        tbNoScreeningReason.Text = ""
        rblIGTrained.SelectedIndex = -1
        tbIGTrainingType.Text = ""
        tbNoIGTrainingReason.Text = ""
        divICODetails.Visible = False
        divICONotRegReason.Visible = False
        divComplianceScoreVersion.Visible = False
        divNonComplianceReason.Visible = False
        divStaffScreeningDetails.Visible = False
        divNoScreeningReason.Visible = False
        divStaffTrained.Visible = False
        divStaffNotTrained.Visible = False
    End Sub

    Private Sub lbtSubmitAssurance_Click(sender As Object, e As EventArgs) Handles lbtSubmitAssurance.Click
        If Page.IsValid Then
            Dim nScore As Integer
            Dim taAssure As New ispdatasetTableAdapters.isp_AssuranceSubmissionsTableAdapter
            Try
                Dim expDate As Nullable(Of DateTime)
                If tbICOReviewDate.Text.Length > 1 And rblICOReg.SelectedValue = 1 Then
                    expDate = DateTime.ParseExact(tbICOReviewDate.Text, "d/M/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None)
                End If
                Dim nOrgID As Integer = Session("UserOrganisationID")
                Dim sOrgUserName As String = Session("UserOrgUserName")
                nScore = taAssure.AssuranceSubmissions_Insert(CInt(Session("UserOrganisationID")), Session("UserOrgUserName"), rblICOReg.SelectedValue, tbICORegNumber.Text, expDate, tbICONotRegReason.Text, ddCompliance.SelectedValue, tbToolkitVersion.Text, tbScore.Text, tbNonComplianceReason.Text, rblScreened.SelectedValue, tbStaffScreeningDetails.Text, tbNoScreeningReason.Text, rblIGTrained.SelectedValue, tbIGTrainingType.Text, tbNoIGTrainingReason.Text, ddCyberEssentials.SelectedValue)
            Catch ex As System.InvalidOperationException
                lblModalHeading.Text = "Database Error"
                lblModalText.Text = "Error details: " & ex.Message
                ShowMessage("msgAssuranceError")
            Finally
                Dim sOutcome As String
                Select Case nScore
                    Case 0
                        sOutcome = "significant"
                    Case 1
                        sOutcome = "limited"
                    Case Else
                        sOutcome = "none"
                End Select
                lblModalHeading.Text = "Assurance Details Submitted Successfully"
                lblModalText.Text = "From the responses you have submitted, we have calculated your organisation assurance rating as " & sOutcome & "."
                ShowMessage("msgAssuranceSubmitted")
				If Session("UserSponsorOrganisationID") > 0 Then
					Dim taSeniorUsers As New NotificationsTableAdapters.isp_OrganisationUsersTableAdapter
					Dim tSeniorUsers As New Notifications.isp_OrganisationUsersDataTable
                    tSeniorUsers = taSeniorUsers.GetUsersInRoleForOrganisation(Session("UserSponsorOrganisationID"), 5)
                    Dim sSubject As String = "DPIA Supported Organisation has Submitted New Assurance Details - " & Session("UserOrganisationName")
                    Dim sPageName As String = HttpContext.Current.Request.UrlReferrer.GetLeftPart(UriPartial.Authority) & HttpContext.Current.Request.ApplicationPath & "Account/login.aspx"
					For Each r As DataRow In tSeniorUsers.Rows
						Dim sEmail As String = r.Item("OrganisationUserEmail")
						Dim taNots As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
						Dim nRequestEmails As Integer = taNots.GetByNotificationEmail(3, sEmail)
						If nRequestEmails > 0 Then
							Dim sMailMessage As String = ""
							sMailMessage = sMailMessage & "<p>Dear " & r.Item("OrganisationUserName") & ",</p>"
                            sMailMessage = sMailMessage & "<p><a href='mailto:" & Session("UserEmail") & "'>" & Session("UserOrgUserName") & " (" & Session("UserEmail") & ")</a> has provided a new Data Protection Impact Assessment Tool Assurance submission for their organisation - " & Session("UserOrganisationName") & ".</p>"
                            sMailMessage = sMailMessage & "<p>From the responses they have submitted, we have calculated their organisation assurance rating as " & sOutcome & ".</p>"
                            sMailMessage = sMailMessage & "<p>To login to the gateway and acknowledge this assurance submission, <a href='" & sPageName & "'>click here</a>.</p>"
							Utility.SendEmail(sEmail, sSubject, sMailMessage, True)
						End If
					Next
				End If
				fvCurrentAssurance.DataBind()
				Me.mvAssurance.SetActiveView(Me.vCurrentAssurance)
            End Try
        End If
    End Sub

    Private Sub lbtSignAgreement_Click(sender As Object, e As EventArgs) Handles lbtSignAgreement.Click
        Me.mvAssurance.SetActiveView(Me.vSignAgreement)
    End Sub

    Private Sub vSignAgreement_Activate(sender As Object, e As EventArgs) Handles vSignAgreement.Activate
        lblAgreeUserName.Text = Session("UserOrgUserName")
        lblAgreeOrganisation.Text = Session("UserOrganisationName")
        lblAgreeOrganisation2.Text = Session("UserOrganisationName")
        If Session("UserRoleAO") Then
            lblAgreeRole.Text = "Senior Officer"
        ElseIf Session("UserRoleIGO") Then
            lblAgreeRole.Text = "Information Governance / Project Officer"
            lblOnBehalfOf.Text = "acting on behalf of my Senior Officer,"
        Else
            lblAgreeRole.Text = "Administrator"
            lblOnBehalfOf.Text = "acting on behalf of my Senior Officer,"
        End If
    End Sub

    Private Sub lbtCancelSign_Click(sender As Object, e As EventArgs) Handles lbtCancelSign.Click
        Me.mvAssurance.SetActiveView(Me.vCurrentAssurance)
    End Sub

    Private Sub lbtFinalSignAgreement_Click(sender As Object, e As EventArgs) Handles lbtFinalSignAgreement.Click
        Dim nTopRoleID As Integer = 0
        If Session("UserRoleAO") Then
            nTopRoleID = 1
        ElseIf Session("UserRoleIGO") Then
            nTopRoleID = 8
        Else
            nTopRoleID = 5
        End If
        Dim nFileID As Nullable(Of Integer)
        Dim taQ As New ispdatasetTableAdapters.QueriesTableAdapter
       

        Dim nReturn As Integer = taQ.TierZeroSignature_Insert(CInt(Session("UserOrganisationID")), Session("UserOrgUserName"), Session("UserEmail"), nTopRoleID, nFileID)
        If nReturn > 0 Then
            taQ.FileGroups_UpdateID(nReturn, Session("AgreementFileGroupID"))
            lblModalHeading.Text = "Thank you"
            lblModalText.Text = "DPIA Organisation MOU signed."
            ShowMessage("msgSigned")
            fvUsageAgreement.DataBind()
            Me.mvAssurance.SetActiveView(Me.vCurrentAssurance)
        End If
    End Sub



    Private Sub vSubmitAssurance_Activate(sender As Object, e As EventArgs) Handles vSubmitAssurance.Activate
        Dim tao As New ispdatasetTableAdapters.isp_OrganisationsTableAdapter
        Dim torg As New ispdataset.isp_OrganisationsDataTable
        torg = tao.GetData(CInt(Session("UserOrganisationID")))
        Dim sICORegNum As String = torg.First.ICORegistrationNumber
        If sICORegNum.Length > 1 Then
            rblICOReg.SelectedValue = 1
            tbICORegNumber.Text = sICORegNum
            divICONotRegReason.Visible = False
            divICODetails.Visible = True
            Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
            Dim dEnd As Nullable(Of Date)
            dEnd = taq.GetICORegEndDate(sICORegNum)
            If Not dEnd Is Nothing Then
                Dim dEndDate As Date = dEnd
                tbICOReviewDate.Text = dEndDate.ToString("dd/MM/yyyy")
            End If
        End If
        If torg.First.HasPN = True Then
            tbPN.Text = "Yes"
        End If
    End Sub

    Private Sub lbtUpload_Click(sender As Object, e As EventArgs) Handles lbtUpload.Click
        Dim nAgreementID = 0
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        If Not Session("nAgreementID") Is Nothing Then
            nAgreementID = Session("nAgreementID")
        End If
        If Session("AgreementFileGroupID") = 0 Then
            Session("AgreementFileGroupID") = taq.isp_FileGroup_Insert("agreement", nAgreementID)
        End If
        If filEvidence.PostedFiles.Count > 0 Then
            Dim bShowWarning As Boolean = 0
            Me.lblModalText.Text = ""
            Dim nFileID As Nullable(Of Integer)
            Dim sFilename As String = ""
            For Each pFile As HttpPostedFile In filEvidence.PostedFiles
                'Dim sExtension As String = System.IO.Path.GetExtension(Me.filEvidence.PostedFile.FileName).ToLower()
                sFilename = System.IO.Path.GetFileName(pFile.FileName)
                Dim nMaxKB As Integer = 256
                If pFile.InputStream.Length > nMaxKB * 1024 Then
                    lblModalHeading.Text = "Evidence file too big"
                    Me.lblModalText.Text = Me.lblModalText.Text + "<p>" + sFilename + " is too big. Maximum file size is " + nMaxKB.ToString() + "K." + "</p>"
                    bShowWarning = True
                Else
                    Dim size As Integer = pFile.ContentLength
                    Dim sContentType As String = pFile.ContentType
                    Dim fileData As Byte() = New Byte(size - 1) {}
                    pFile.InputStream.Read(fileData, 0, size)
                    nFileID = taq.InsertFile(sFilename, sContentType, pFile.InputStream.Length / 1024, fileData, CInt(Session("UserOrganisationID")), Session("UserEmail"))
                    If nFileID > 0 Then
                        taq.FileGroupFile_Insert(Session("AgreementFileGroupID"), nFileID)
                    Else
                        lblModalHeading.Text = "Evidence file error"
                        Me.lblModalText.Text = Me.lblModalText.Text + "<p>" + sFilename + " failed to upload due to an unknown error. </p>"
                        bShowWarning = True
                    End If
                End If
            Next

            rptFiles.DataBind()
            If bShowWarning Then
                ShowMessage("msgFileTooBig")
            End If
        End If
    End Sub
    Protected Sub ShowMessage(ByVal txt As String)
        Page.ClientScript.RegisterStartupScript(Me.GetType(), txt, "<script>$('#modalMessage').modal('show');</script>")
    End Sub
    Private Sub rptFiles_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptFiles.ItemCommand
        If e.CommandName = "Delete" Then
            Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
            taq.File_Delete(CInt(e.CommandArgument))
            rptFiles.DataBind()
        End If
    End Sub

	Private Sub fvUsageAgreement_DataBound(sender As Object, e As EventArgs) Handles fvUsageAgreement.DataBound
		If Not fvUsageAgreement.SelectedValue Is Nothing Then
			pnlWhoCanSign.Visible = False
		End If
	End Sub

    Private Sub lbtViewAgreement_Click(sender As Object, e As EventArgs) Handles lbtViewAgreement.Click
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "mou-modal", "<script>$('#modalMOU').modal('show');</script>")
    End Sub

    Private Sub fvUsageAgreement_ItemCommand(sender As Object, e As FormViewCommandEventArgs) Handles fvUsageAgreement.ItemCommand
        Dim sURL As String
        Dim sPath As String = Request.Url.AbsoluteUri
        Dim nPos As Integer = sPath.LastIndexOf("application/")
        If e.CommandName = "Download" Then
            sURL = sPath.Substring(0, nPos) & "org_mou.aspx" & _
             "?OrganisationID=" & Session("UserOrganisationID")
            'Response.Redirect(SUrl)
            Dim pdfName As String = Server.MapPath("~/application/pdfout/") + "DPIA_Usage_Agreement_" & Session("UserOrganisationName").ToString.Replace(" ", "_") & ".pdf"
            Utility.GeneratePDFFromURL(sURL, pdfName, "DPIA Usage Agreement / MoU")
        End If
    End Sub
End Class