Public Class home_intray
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Session("UserOrgUserName") Is Nothing Then
            If Not Page.Request.Item("returnURL") Is Nothing Then
                If Not Page.Request.Item("returnURL") = "" Then
                    Response.Redirect(Page.Request.Item("returnURL"))
                End If
            End If
            TOUAcknowledge.Visible = Not Session("TOUAgreed")
                If TOUAcknowledge.Visible Then
                    Dim taTOU As New adminTableAdapters.isp_TermsOfUseTableAdapter
                    Dim tTOU As New admin.isp_TermsOfUseDataTable
                    tTOU = taTOU.GetCurrent("TOU")
                    If tTOU.Count > 0 Then
                        litTOUSummary.Text = tTOU.First.TermsSummary
                    Else
                        litTOUSummary.Text = "No summary provided."
                    End If
                End If
            If Not Page.IsPostBack Then
                pnlSignatureRequests.Visible = False
                divNewSubmissions.Visible = False
                pnlDPOReviewRequests.Visible = False
                If Session("UserRoleAO") Or Session("UserRoleDELEG") Then
                    pnlSignatureRequests.Visible = True
                End If

                If Session("UserRoleIAO") Then
                    pnlSignatureRequests.Visible = True
                End If
                If Session("UserRoleDPO") Then
                    pnlDPOReviewRequests.Visible = True
                End If
                If Session("UserRoleAdmin") Then
                    If Session("UserSponsorOrganisationID") = 0 Then

                        divNewSubmissions.Visible = True
                    End If
                Else

                End If
                Dim sServerName As String = Request.ServerVariables("SERVER_NAME").ToLower()
                If Not sServerName = "www.info-sharing-system.org.uk" And Not sServerName = "www.dpiatool.org.uk" Then
                    lblUserName.Text = "to the Data Protection Impact Assessment Tool Sandpit, " & Session("UserOrgUserName")
                Else
                    lblUserName.Text = "to the Data Protection Impact Assessment Tool, " & Session("UserOrgUserName")
                End If


                Dim taNots As New NotificationsTableAdapters.isp_NotificationsTableAdapter
                Dim tNots As New Notifications.isp_NotificationsDataTable
                tNots = taNots.GetByEmail(Session("UserEmail"))
                If tNots.Count > 0 Then
                    For Each r As DataRow In tNots.Rows
                        Select Case r.Item("NotificationID")

                            Case 2
                                cbDataFlowSignOffRequests.Checked = r.Item("HasNotification")
                            Case 3
                                cbNewAssuranceNotifications.Checked = r.Item("HasNotification")
                            Case 4
                                cbSubSANotifications.Checked = r.Item("HasNotification")
                            Case 6
                                cbDPOReviewRequests.Checked = r.Item("HasNotification")
                        End Select
                    Next
                End If
                Dim taq As New InTrayTableAdapters.QueriesTableAdapter

                Dim nICOExp As Integer = taq.GetAssuranceExpiry(Session("UserOrganisationID"))
                Select Case nICOExp
                    Case 4
                        lblICOExpiryHeader.Text = "Organisation Assurance Not Yet Submitted"
                        lblICOExpiryBody.Text = "In order to satisfy your sharing partners that you have the basic governance arrangements in place in your organisation to make you safe to share with, please submit your organisation assurance information."
                        pnlIcoExpiry.CssClass = "panel panel-danger"
                    Case 2
                        lblICOExpiryHeader.Text = "Organisation Assurance Expired"
                        lblICOExpiryBody.Text = "The ICO review date specified in your last organisation assurance submission has now passed. You should provide a new assurance submission as soon as possible."
                        pnlIcoExpiry.CssClass = "panel panel-danger"
                    Case 1
                        lblICOExpiryHeader.Text = "Organisation Assurance Expires Soon"
                        lblICOExpiryBody.Text = "The ICO review date specified in your last organisation assurance submission is less than one month away. You should provide a new assurance submission as soon as possible."
                        pnlIcoExpiry.CssClass = "panel panel-warning"
                    Case 0
                        Dim nAssuranceScore As Integer = taq.getAssuranceForOrg(Session("UserOrganisationID"))
                        Select Case nAssuranceScore
                            Case 0
                                lblICOExpiryHeader.Text = "Organisation Assurance Level: Significant Assurance"
                                pnlIcoExpiry.CssClass = "panel panel-success"
                            Case 1
                                lblICOExpiryHeader.Text = "Organisation Assurance Level: Limited Assurance"
                                pnlIcoExpiry.CssClass = "panel panel-warning"
                            Case Is > 1
                                lblICOExpiryHeader.Text = "Organisation Assurance Level: No Assurance"
                                pnlIcoExpiry.CssClass = "panel panel-danger"
                        End Select
                        pnlExpiryBody.Visible = False
                End Select
                Dim nOrgReadiness As Integer = taq.GetOrgRegProgress(Session("UserOrganisationID"))
                lblOrgPercent.Text = nOrgReadiness.ToString & "%"
                orgprog.Attributes.Add("aria-valuenow", nOrgReadiness.ToString)
                orgprog.Attributes.Add("style", "width:" & nOrgReadiness.ToString & "%;")
                Select Case nOrgReadiness
                    Case Is <= 60
                        orgprog.Attributes.Add("class", "progress-bar progress-bar-danger progress-bar-striped")
                        PopulateActionList()
                    Case Is < 100
                        orgprog.Attributes.Add("class", "progress-bar progress-bar-warning progress-bar-striped")
                        PopulateActionList()
                    Case Else
                        pnlActionList.Visible = False
                        orgprog.Attributes.Add("class", "progress-bar progress-bar-success progress-bar-striped")

                End Select
            End If
        End If
    End Sub
    Protected Sub PopulateActionList()
        Dim taOrgActions As New InTrayTableAdapters.OrgActionsTableAdapter
        Dim tOrgActions As New InTray.OrgActionsDataTable
        tOrgActions = taOrgActions.GetData(Session("UserOrganisationID"))
        If Not tOrgActions Is Nothing Then
            If tOrgActions.Count > 0 Then

                If tOrgActions.First.Administrators = 0 Then
                    secondIcon.Attributes.Add("class", "glyphicon glyphicon-remove text-danger")
                    lbtRegAdmin.Visible = True
                End If
                If tOrgActions.First.ContactEmail = 0 Then
                    eighthIcon.Attributes.Add("class", "glyphicon glyphicon-remove text-danger")
                    lbtAddContact.Visible = True
                End If
                If tOrgActions.First.SeniorUsers = 0 Then
                    thirdIcon.Attributes.Add("class", "glyphicon glyphicon-remove text-danger")
                    lbtRegSenior.Visible = True
                    lbtRegSeniorVideo.Visible = True
                ElseIf tOrgActions.First.SeniorUsers = 1 Then
                    thirdIcon.Attributes.Add("class", "glyphicon glyphicon-ok text-warning")
                    lbtRegSenior.ToolTip = "Go to Organisation Users to send registration reminders to Senior Officers"
                    lbtRegSeniorVideo.Visible = True
                End If
                If tOrgActions.First.DPOExempt Then
                    liDPO.Attributes.Add("style", "display:none;")
                Else
                    If tOrgActions.First.DPOs = 0 Then
                        ninthIcon.Attributes.Add("class", "glyphicon glyphicon-remove text-danger")
                        lbtRegDPO.Visible = True
                    ElseIf tOrgActions.First.DPOs = 1 Then
                        ninthIcon.Attributes.Add("class", "glyphicon glyphicon-ok text-warning")
                        lbtRegDPO.Visible = True
                        lbtRegDPO.ToolTip = "Go to Organisation Users to send registration reminder to DPO"
                    End If
                End If
                If tOrgActions.First.Assurance = 0 Then
                    fourthIcon.Attributes.Add("class", "glyphicon glyphicon-remove text-danger")
                    lbtAssurance.Visible = True
                    lbtAssuranceVideo.Visible = True
                ElseIf tOrgActions.First.Assurance = 1 Then
                    fourthIcon.Attributes.Add("class", "glyphicon glyphicon-ok text-warning")
                    lbtAssurance.ToolTip = "Go to Organisation Assurance to update assurance"
                    lbtAssurance.Visible = True
                    lbtAssuranceVideo.Visible = True
                End If
                If tOrgActions.First.MOU = 0 Then
                    fifthIcon.Attributes.Add("class", "glyphicon glyphicon-remove text-danger")
                    lbtMOU.Visible = True
                    lbtMOUVideo.Visible = True
                End If
            End If
        End If
    End Sub





    Private Sub cbDataFlowSignOffRequests_CheckedChanged(sender As Object, e As EventArgs) Handles cbDataFlowSignOffRequests.CheckedChanged
        If Not Session("UserEmail") Is Nothing Then
			Dim taNotifUsers As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
            If Not cbDataFlowSignOffRequests.Checked Then
                taNotifUsers.InsertUserNotificationIfNotExists(Session("UserEmail"), 2)
                cbDataFlowSignOffRequests.Checked = True
            Else
                taNotifUsers.DeleteByIDandEmail(2, Session("UserEmail"))
                cbDataFlowSignOffRequests.Checked = False
            End If
        End If
    End Sub

    Private Sub cbNewAssuranceNotifications_CheckedChanged(sender As Object, e As EventArgs) Handles cbNewAssuranceNotifications.CheckedChanged
        If Not Session("UserEmail") Is Nothing Then
            Dim taNotifUsers As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
            If Not cbNewAssuranceNotifications.Checked Then
                taNotifUsers.InsertUserNotificationIfNotExists(Session("UserEmail"), 3)
                cbNewAssuranceNotifications.Checked = True
            Else
                taNotifUsers.DeleteByIDandEmail(3, Session("UserEmail"))
                cbNewAssuranceNotifications.Checked = False
            End If
        End If
    End Sub

    Private Sub cbSubSANotifications_CheckedChanged(sender As Object, e As EventArgs) Handles cbSubSANotifications.CheckedChanged
        If Not Session("UserEmail") Is Nothing Then
            Dim taNotifUsers As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
            If Not cbSubSANotifications.Checked Then
                taNotifUsers.InsertUserNotificationIfNotExists(Session("UserEmail"), 4)
                cbSubSANotifications.Checked = True
            Else
                taNotifUsers.DeleteByIDandEmail(4, Session("UserEmail"))
                cbSubSANotifications.Checked = False
            End If
        End If
    End Sub

    Private Sub cbDPOReviewRequests_CheckedChanged(sender As Object, e As EventArgs) Handles cbDPOReviewRequests.CheckedChanged
        If Not Session("UserEmail") Is Nothing Then
            Dim taNotifUsers As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
            If Not cbSubSANotifications.Checked Then
                taNotifUsers.InsertUserNotificationIfNotExists(Session("UserEmail"), 6)
                cbSubSANotifications.Checked = True
            Else
                taNotifUsers.DeleteByIDandEmail(6, Session("UserEmail"))
                cbSubSANotifications.Checked = False
            End If
        End If
    End Sub

    Private Sub gvNewAssuranceSubs_DataBound(sender As Object, e As EventArgs) Handles gvNewAssuranceSubs.DataBound
        If gvNewAssuranceSubs.Rows.Count = 0 Then
            divNewSubmissions.Visible = False
        Else
            ForYourAttention()
		End If
	End Sub

	Private Sub gvNewAssuranceSubs_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvNewAssuranceSubs.RowCommand
        If e.CommandName = "Acknowledge" Then
            Dim taq As New adminTableAdapters.QueriesTableAdapter
            taq.AcknowledgeAssuranceSubmission(e.CommandArgument)
            gvNewAssuranceSubs.DataBind()
            ForYourAttention()
        End If
    End Sub

    Private Sub gvSignOffRequests_DataBound(sender As Object, e As EventArgs) Handles gvSignOffRequests.DataBound
        If gvSignOffRequests.Rows.Count = 0 Then
            pnlSignatureRequests.Visible = False
        Else
            ForYourAttention()
        End If
    End Sub
    Private Sub gvDPOReviewRequests_DataBound(sender As Object, e As EventArgs) Handles gvDPOReviewRequests.DataBound
        If gvDPOReviewRequests.Rows.Count = 0 Then
            pnlDPOReviewRequests.Visible = False
        Else
            ForYourAttention()
        End If
    End Sub
    Private Sub gvDPOReviewsCompleted_DataBound(sender As Object, e As EventArgs) Handles gvDPOReviewsCompleted.DataBound
        If gvDPOReviewsCompleted.Rows.Count = 0 Then
            pnlDPOReviewsCompleted.Visible = False
        Else
            ForYourAttention()
        End If
    End Sub
    Private Sub gvAckReviewSignOff_DataBound(sender As Object, e As EventArgs) Handles gvAckReviewSignOff.DataBound
        If gvAckReviewSignOff.Rows.Count = 0 Then
            pnlAckReviewSignOff.Visible = False
        Else
            ForYourAttention()
        End If
    End Sub
    Protected Sub ForYourAttention()
        Dim nNewVal As Integer = 0
        If divNewSubmissions.Visible Then nNewVal += gvNewAssuranceSubs.Rows.Count
        If pnlSignatureRequests.Visible Then nNewVal += gvSignOffRequests.Rows.Count
        If pnlDPOReviewRequests.Visible Then nNewVal += gvDPOReviewRequests.Rows.Count
        If pnlDPOReviewsCompleted.Visible Then nNewVal += gvDPOReviewsCompleted.Rows.Count
        If pnlAckReviewSignOff.Visible Then nNewVal += gvAckReviewSignOff.Rows.Count
        If pnlExpiryBody.Visible Then nNewVal = nNewVal + 1
        If TOUAcknowledge.Visible Then nNewVal = nNewVal + 1
        lblForAttention.Text = nNewVal.ToString()
    End Sub

    Private Sub lbtRegSeniorVideo_Click(sender As Object, e As EventArgs) Handles lbtRegSeniorVideo.Click
        Dim sServerName As String = Request.ServerVariables("SERVER_NAME").ToLower()
        videosrc.Attributes.Add("src", "https://" & sServerName & "/mp4/SeniorUserQuickClip.mp4")
        vidparm.Attributes.Add("value", "src=https://" & sServerName & "/mp4/SeniorUserQuickClip.mp4&autoPlay=true")
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "myModalShow", "<script>$('#myModal').modal('show');</script>")
    End Sub

    Private Sub lbtAssuranceVideo_Click(sender As Object, e As EventArgs) Handles lbtAssuranceVideo.Click
        Dim sServerName As String = Request.ServerVariables("SERVER_NAME").ToLower()
        videosrc.Attributes.Add("src", "https://" & sServerName & "/mp4/AssuranceQuickClips.mp4")
        vidparm.Attributes.Add("value", "src=https://" & sServerName & "/mp4/AssuranceQuickClips.mp4&autoPlay=true")
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "myModalShow", "<script>$('#myModal').modal('show');</script>")
    End Sub

    Private Sub lbtMOUVideo_Click(sender As Object, e As EventArgs) Handles lbtMOUVideo.Click
        Dim sServerName As String = Request.ServerVariables("SERVER_NAME").ToLower()
        videosrc.Attributes.Add("src", "https://" & sServerName & "/mp4/MoUQuickClip.mp4")
        vidparm.Attributes.Add("value", "src=https://" & sServerName & "/mp4/MoUQuickClip.mp4&autoPlay=true")
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "myModalShow", "<script>$('#myModal').modal('show');</script>")
    End Sub

    Private Sub lbtAgreeTOU_Click(sender As Object, e As EventArgs) Handles lbtAgreeTOU.Click
        Dim taq As New InTrayTableAdapters.QueriesTableAdapter
        taq.UpdateOrInsertTOUSignedDate(Session("UserEmail"))
        TOUAcknowledge.Visible = False
        Session("TOUAgreed") = True
    End Sub

    Private Sub gvSignOffRequests_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSignOffRequests.RowCommand, gvDPOReviewRequests.RowCommand, gvDPOReviewsCompleted.RowCommand
        If e.CommandName = "ReviewFlow" Then
            Dim nFlowID As Integer = CInt(e.CommandArgument)
            Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
            Dim nSummaryID As Integer = taq.GetSummaryIDForFlow(nFlowID)
            Session("nSummaryID") = nSummaryID
            Session("FlowDetailID") = nFlowID
            If nSummaryID > 0 Then
                Response.Redirect("~/application/dataflow_detail.aspx?Action=Edit")
            End If
        ElseIf e.CommandName = "Acknowledge" Then
            Dim taq As New InTrayTableAdapters.QueriesTableAdapter
            taq.AcknowledgeDPOReview(e.CommandArgument)
            gvDPOReviewsCompleted.DataBind()
        End If
    End Sub
    Private Sub gvAckReviewSignOff_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvAckReviewSignOff.RowCommand

        If e.CommandName = "ReviewFlow" Then
            Dim nFlowID As Integer = CInt(e.CommandArgument)
            Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
            Dim nSummaryID As Integer = taq.GetSummaryIDForFlow(nFlowID)
            Session("nSummaryID") = nSummaryID
            Session("FlowDetailID") = nFlowID
            If nSummaryID > 0 Then
                Response.Redirect("~/application/dataflow_detail.aspx?Action=Edit")
            End If
        ElseIf e.CommandName = "Acknowledge" Then
            Dim taq As New InTrayTableAdapters.QueriesTableAdapter
            taq.AcknowledgeDPOAck(e.CommandArgument)
            gvAckReviewSignOff.DataBind()
        End If
    End Sub

    Private Sub dsNotices_Selected(sender As Object, e As ObjectDataSourceStatusEventArgs) Handles dsNotices.Selected
        Dim nRows As Integer = DirectCast(e.ReturnValue, InformationSharingPortal.admin.SANotificationsDataTable).Count
        If nRows = 0 Then
            pnlNotices.Visible = False
        Else
            pnlNotices.Visible = True
            lblNotificationCount.Text = nRows.ToString
        End If

    End Sub

    Private Sub rptNotifications_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptNotifications.ItemCommand

        If e.CommandName = "AcknowledgeNotice" Then
            Dim taq As New adminTableAdapters.QueriesTableAdapter
            taq.AcknowledgeSANotification(e.CommandArgument, Session("UserEmail"))
            rptNotifications.DataBind()
        End If
    End Sub


End Class