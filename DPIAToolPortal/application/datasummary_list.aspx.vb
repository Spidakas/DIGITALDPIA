Imports System.IO

Public Class data_in_list
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("UserRoleAdmin") = False And Session("UserRoleAO") = False And Session("UserRoleIAO") = False And Session("UserRoleIGO") = False Then
            lbtAdd.Visible = False
        Else
            gvFlowSummaries.EmptyDataText = "No data sharing summaries have yet been added that involve this organisation. Click Add below to add one."
        End If
    End Sub
    Protected Function PadID(value As Integer) As String

        Dim fmt As String = "DS000000"
        Dim str As String = value.ToString(fmt)
        Return str
    End Function
    Private Sub gvFlowSummaries_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvFlowSummaries.RowCommand
        If e.CommandName = "EditShare" Then
            Dim nShareID As Integer = e.CommandArgument
            Session("nSummaryID") = nShareID
            Response.Redirect("~/application/dataflow_summary.aspx")
        ElseIf e.CommandName = "ViewShare" Then
            Dim nShareID As Integer = e.CommandArgument
            Session("nSummaryID") = nShareID
            Response.Redirect("~/application/dataflow_list.aspx")
        ElseIf e.CommandName = "ArchiveSummary" Then
            hfArchiveSummaryID.Value = e.CommandArgument
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalArchive", "$('#modalArchive').modal('show');", True)
            'Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalArchive", "<script>$('#modalArchive').modal('show');</script>")
            'We need to archive the summary, this process should also involve 
        End If
    End Sub

    Private Sub lbtAdd_Click(sender As Object, e As EventArgs) Handles lbtAdd.Click
        Response.Redirect("~/application/dataflow_summary.aspx?action=add")
    End Sub

    Private Sub gvFlowSummaries_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvFlowSummaries.RowDataBound
        If e.Row.Cells.Count > 1 Then
            'If overdue then apply danger css class
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim r As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                If r("OverDue") = 2 Then
                    e.Row.CssClass = "danger alert-danger"
                    e.Row.ToolTip = "Review date passed"
                End If
                If r("OverDue") = 1 Then
                    e.Row.CssClass = "warning alert-warning"
                    e.Row.ToolTip = "Within 1 month of review date"
                End If
                If r("DFArchivedDate").ToString.Length > 0 Then
                    e.Row.CssClass = "text-muted"
                End If
            End If
            'Hide controls according to role:

            'If Session("UserRoleAdmin") = False And Session("UserRoleSIRO") = False And Session("UserRoleIAO") = False And Session("UserRoleIGO") = False Then
            '    e.Row.Cells(8).CssClass = "hiddencol"
            'End If
        End If

    End Sub

    Private Sub ddSharingOrgs_DataBound(sender As Object, e As EventArgs) Handles ddSharingOrgs.DataBound
        If Not Page.Request.Item("orgid") Is Nothing Then
            If Not ddSharingOrgs.Items.FindByValue(Page.Request.Item("orgid")) Is Nothing Then
                ddSharingOrgs.SelectedValue = Page.Request.Item("orgid")
                FilterPanel.CssClass = "collapse filter-panel in"
                pnlShareOrg.CssClass = "form-group has-success"
                ddSharingOrgs.CssClass = "form-control bg-warning"
            End If
        End If
    End Sub

    Private Sub lbtArchiveConfirm_Click(sender As Object, e As EventArgs) Handles lbtArchiveConfirm.Click, lbtRecycleAll.Click, lbtRecycleSummary.Click
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        Dim currentUser As MembershipUser = Membership.GetUser()
        Dim currentUserId As Guid = DirectCast(currentUser.ProviderUserKey, Guid)
        Dim lbt As LinkButton = TryCast(sender, LinkButton)
        Dim nFlowCount As Integer
        If nFlowCount > 0 Then
            RemovePDFsForSummaryFlows()
        End If
        Select Case lbt.CommandArgument
            Case "0"
                'We are only archiving so pass in false, false for recycle params
                nFlowCount = taq.DataFlowSummaries_Archive_Recycle(hfArchiveSummaryID.Value, currentUserId, False, False)
                'Return a message appropriate to the number of associated flows returned by the query:
                If nFlowCount > 0 Then
                    lblModalHeading.Text = "Data Sharing Summary and Flows Archived"
                    lblModalText.Text = "<p>The data sharing summary and " & nFlowCount.ToString() & " associated flows have been archived.</p>"
                    lblModalText.Text = lblModalText.Text & "<p>To see archived summaries and flows, use the <b>Filter / Search</b> panel and uncheck <b>Hide archived flows</b>.</p>"
                Else
                    lblModalHeading.Text = "Data Sharing Summary Archived"
                    lblModalText.Text = "<p>The data sharing summary has been archived.</p>"
                    lblModalText.Text = lblModalText.Text & "<p>To see archived summaries, use the <b>Filter / Search</b> panel and uncheck <b>Hide archived flows</b>.</p>"
                End If

            Case "1"
                'We are recycling all so pass in true, true
                nFlowCount = taq.DataFlowSummaries_Archive_Recycle(hfArchiveSummaryID.Value, currentUserId, True, True)
                'Return a message appropriate to the number of associated flows returned by the query:
                If nFlowCount > 0 Then
                    lblModalHeading.Text = "Data Sharing Summary and Flows Archived and Recycled"
                    lblModalText.Text = "<p>The data sharing summary and " & nFlowCount.ToString() & " associated flows have been archived.</p>"
                    lblModalText.Text = "<p>Copies of the data sharing summary and " & nFlowCount.ToString() & " associated flows have been created with today's date appended to their name ready for review and sign off.</p>"
                    lblModalText.Text = lblModalText.Text & "<p>To see archived summaries and flows, use the <b>Filter / Search</b> panel and uncheck <b>Hide archived flows</b>.</p>"
                Else
                    lblModalHeading.Text = "Data Sharing Summary Archived and Recycled"
                    lblModalText.Text = "<p>The data sharing summary has been archived.</p>"
                    lblModalText.Text = "<p>A copy of the data sharing summary has been created with today's date appended to its name ready for review and sign off.</p>"
                    lblModalText.Text = lblModalText.Text & "<p>To see archived summaries, use the <b>Filter / Search</b> panel and uncheck <b>Hide archived flows</b>.</p>"
                End If

            Case "2"
                'We are recycling the summary only so pass in True, False
                nFlowCount = taq.DataFlowSummaries_Archive_Recycle(hfArchiveSummaryID.Value, currentUserId, True, False)
                If nFlowCount > 0 Then
                    lblModalHeading.Text = "Data Sharing Summary and Flows Archived and Summary Recycled"
                    lblModalText.Text = "<p>The data sharing summary and " & nFlowCount.ToString() & " associated flows have been archived.</p>"
                    lblModalText.Text = "<p>A copy of the data sharing summary has been created with today's date appended to its name ready for review and sign off.</p>"
                    lblModalText.Text = lblModalText.Text & "<p>To see archived summaries and flows, use the <b>Filter / Search</b> panel and uncheck <b>Hide archived flows</b>.</p>"
                Else
                    lblModalHeading.Text = "Data Sharing Summary Archived and Recycled"
                    lblModalText.Text = "<p>The data sharing summary has been archived.</p>"
                    lblModalText.Text = "<p>A copy of the data sharing summary has been created with today's date appended to its name ready for review and sign off.</p>"
                    lblModalText.Text = lblModalText.Text & "<p>To see archived summaries, use the <b>Filter / Search</b> panel and uncheck <b>Hide archived flows</b>.</p>"
                End If

        End Select

        gvFlowSummaries.DataBind()
        ShowMessage()

    End Sub
    Protected Sub RemovePDFsForSummaryFlows()
        Dim taDFD As New DataFlowDetailTableAdapters.DFDIDForSummaryTableAdapter
        Dim tDFD As New DataFlowDetail.DFDIDForSummaryDataTable
        tDFD = taDFD.GetData(hfArchiveSummaryID.Value)
        For Each r As DataRow In tDFD
            Dim pdfName As String = Server.MapPath("~/application/pdfout/") + "DPIA_ISA_" & r.Item("DataFlowDetailID") & ".pdf"
            If File.Exists(pdfName) Then
                File.Delete(pdfName)
            End If
        Next
    End Sub
    Protected Sub ShowMessage()
        'Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalMessage", "<script>$('#modalMessage').modal('show');</script>")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalMessage", "$('#modalMessage').modal('show');", True)
    End Sub
End Class