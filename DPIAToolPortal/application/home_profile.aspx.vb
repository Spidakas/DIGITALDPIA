Public Class home_profile
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        setupVisibility()
    End Sub
    Protected Sub setupVisibility()
        Dim taq As New NotificationsTableAdapters.QueriesTableAdapter
        Dim nUnsubsribed As Integer = taq.CheckUnsubscribeStatus(Session("UserEmail"))
        If nUnsubsribed > 0 Then
            pnlNotifications.Enabled = False
            lbtSaveNotificationSettings.CssClass = lbtSaveNotificationSettings.CssClass & " disabled"
            cbActivate.Checked = False
        Else
            pnlNotifications.Enabled = True
            lbtSaveNotificationSettings.CssClass = lbtSaveNotificationSettings.CssClass.Replace(" disabled", "")
            cbActivate.Checked = True
        End If
    End Sub

    Private Sub gvRoles_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvRoles.RowCommand
        Dim lnkBtn As LinkButton = DirectCast(e.CommandSource, LinkButton)
        ' the button
        Dim myRow As GridViewRow = DirectCast(lnkBtn.Parent.Parent, GridViewRow)
        ' the row
        Dim myGrid As GridView = DirectCast(sender, GridView)
        ' the gridview
        Dim UserRoleID As Integer = CInt(myGrid.DataKeys(myRow.RowIndex).Value)
        Session("UserRoleID") = UserRoleID
        ' value of the datakey 
        Select Case e.CommandName
            Case "Delegate"
                lblModalHeading.Text = "Delegate DPIA Role - " & e.CommandArgument.ToString()
                lblModalText.Text = "I hereby give my permission for the following user to act on my behalf as " & e.CommandArgument.ToString() & " for " & Session("UserOrganisationName") & ". Furthermore, I take full responsibility for the actions they take on my behalf."
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalInsert", "$('#modalDelegate').modal('show');", True)
            Case "Clear"
                lblModalClearHeader.Text = "Cancel " & e.CommandArgument.ToString() & " Role Delegation?"
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalCleart", "$('#modalClear').modal('show');", True)
            Case "Resign"
                modalResignTitle.Text = "Resign as " & e.CommandArgument.ToString() & "?"
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalResign", "$('#modalResign').modal('show');", True)
        End Select
    End Sub

    Private Sub btnConfirmDelegate_Click(sender As Object, e As EventArgs) Handles btnConfirmDelegate.Click
        Dim taQ As New ispdatasetTableAdapters.QueriesTableAdapter
        taQ.DelegateRoleTo(ddDelegateToAdmin.SelectedValue.ToString(), Session("UserRoleID"))
        gvRoles.DataBind()
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "HideModalInsert", "$('#modalDelegate').modal('hide');", True)
    End Sub

    Private Sub lbtCancelYes_Click(sender As Object, e As EventArgs) Handles lbtCancelYes.Click
        'Clear the role:
        Dim taQ As New ispdatasetTableAdapters.QueriesTableAdapter
        taQ.ClearRoleDelegation(Session("UserRoleID"))
        gvRoles.DataBind()
        'Close modal dialogue:
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "HideModalClear", "$('#modalClear').modal('hide');", True)
    End Sub

    Private Sub gvRoles_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvRoles.RowDataBound
        If e.Row.Cells.Count > 1 Then
            If Session("UserRoleAO") = False Then
                e.Row.Cells(2).CssClass = "hiddencol"
            End If
        End If
    End Sub


    Private Sub lbtResignConfirm_Click(sender As Object, e As EventArgs) Handles lbtResignConfirm.Click
        'Resign the role
        Dim taQ As New ispdatasetTableAdapters.QueriesTableAdapter
        taQ.ResignPost(tbReason.Text, Session("UserRoleID"))
        gvRoles.DataBind()
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "HideModalResign", "$('#modalResign').modal('hide');", True)
    End Sub

    Private Sub lbtSaveNotificationSettings_Click(sender As Object, e As EventArgs) Handles lbtSaveNotificationSettings.Click
        If Not Session("UserEmail") Is Nothing Then
            Dim taNotifUsers As New NotificationsTableAdapters.isp_NotificationUsersTableAdapter
            For Each i As RepeaterItem In rptNotifications.Items
                Dim cbYN As HtmlInputCheckBox = i.FindControl("cbYesNo")
                Dim hf As HiddenField = i.FindControl("hfNotificationID")
                If cbYN.Checked Then
                    taNotifUsers.InsertUserNotificationIfNotExists(Session("UserEmail"), hf.Value)
                Else
                    taNotifUsers.DeleteByIDandEmail(hf.Value, Session("UserEmail"))
                End If
            Next

        End If
        rptNotifications.DataBind()
    End Sub

    Private Sub rptNotifications_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptNotifications.ItemDataBound
        Dim r As RepeaterItem = e.Item
        Dim bEnabled As Boolean = pnlNotifications.Enabled
        Dim cb As HtmlInputCheckBox = r.FindControl("cbYesNo")
        If Not cb Is Nothing Then
            If Not bEnabled Then
                cb.Attributes.Add("disabled", "true")
            End If
        End If
    End Sub

    Private Sub lbtConfirmUnsubscribe_Click(sender As Object, e As EventArgs) Handles lbtConfirmUnsubscribe.Click
        Dim sEmail As String = Session("UserEmail")
        Dim taUnsub As New ispdatasetTableAdapters.isp_UnsubscribeListTableAdapter
        If taUnsub.CheckIfEmailInList(sEmail) = 0 Then
            taUnsub.Insert(sEmail)
        End If

        setupVisibility()
        rptNotifications.DataBind()
        '  Dim url As String = HttpContext.Current.Request.Url.AbsoluteUri
        '  Response.Redirect(url)
    End Sub

    Private Sub lbtConfirmSubscribe_Click(sender As Object, e As EventArgs) Handles lbtConfirmSubscribe.Click
        Dim sEmail As String = Session("UserEmail")
        Dim taUnsub As New ispdatasetTableAdapters.isp_UnsubscribeListTableAdapter
        taUnsub.UnUnsubscribeByEmail(sEmail)

        setupVisibility()
        rptNotifications.DataBind()
        ' Dim url As String = HttpContext.Current.Request.Url.AbsoluteUri
        ' Response.Redirect(url)
    End Sub
End Class