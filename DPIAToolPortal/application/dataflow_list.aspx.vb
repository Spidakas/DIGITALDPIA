Imports System.IO

Public Class dataflow_list
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("UserRoleAdmin") = False And Session("UserRoleIAO") = False And Session("UserRoleIGO") = False Then
            lbtAdd.Visible = False

            'gvFlows.EmptyDataText = "There are no data flows associated with the selected summary. Click Add below to add one."
        End If
        If Session("orgLicenceType") = "Free, limited licence" Then
            lbtExportDFList.Visible = False
        Else
            lbtExportDFList.Visible = True
        End If
    End Sub

    Protected Function PadID(value As Integer) As String

        Dim fmt As String = "DF000000"
        Dim str As String = value.ToString(fmt)
        Return str
    End Function
    Private Sub ddSummarySelect_DataBound(sender As Object, e As EventArgs) Handles ddSummarySelect.DataBound
        If Not Page.Request.Item("summaryid") Is Nothing Then
            Dim nSummaryID As Integer = CInt(Page.Request.Item("summaryid"))
            ddSummarySelect.SelectedValue = nSummaryID
            cbInvolvingMyOrg.Checked = False
            FilterPanel.CssClass = "collapse filter-panel in"
            pnlSummary.CssClass = "form-group has-success"
            ddSummarySelect.CssClass = "form-control bg-warning"
        ElseIf Not Session("nSummaryID") Is Nothing Then
            Dim nSummaryID As Integer = CInt(Session("nSummaryID"))
            ddSummarySelect.SelectedValue = nSummaryID
            cbInvolvingMyOrg.Checked = False
            FilterPanel.CssClass = "collapse filter-panel in"
            pnlSummary.CssClass = "form-group has-success"
            ddSummarySelect.CssClass = "form-control bg-warning"
        ElseIf ddSummarySelect.Items.Count = 1 Then
            lbtAdd.Enabled = False
            lbtAdd.Attributes("disabled") = "disabled"
        End If
        If ddSummarySelect.SelectedValue < 1 Then
            lbtAdd.Visible = False
        Else
            If Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO") Then
                lbtAdd.Visible = True
            End If
        End If
    End Sub

    Private Sub lbtAdd_Click(sender As Object, e As EventArgs) Handles lbtAdd.Click
        Response.Redirect("~/application/dataflow_detail.aspx?Action=Add")
    End Sub

    Private Sub gvFlows_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvFlows.RowCommand
        If e.CommandName = "Edit" Then
            Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
            Dim nFlowID As Integer = CInt(e.CommandArgument)
            Dim nSummaryID As Integer = taq.GetSummaryIDForFlow(nFlowID)
            Session("nSummaryID") = nSummaryID
            Session("FlowDetailID") = nFlowID
            If nSummaryID > 0 Then
                Response.Redirect("~/application/dataflow_detail.aspx?Action=Edit")
            End If
        ElseIf e.CommandName = "Export" Then
            Dim nFlowID As Integer = CInt(e.CommandArgument)
            Dim sPath As String = Request.Url.AbsoluteUri
            Dim nPos As Integer = sPath.LastIndexOf("application/")
            sPath = sPath.Substring(0, nPos)
            Dim sURL As String = sPath & "DSAExport.aspx?DFDID=" & nFlowID.ToString
            'Response.Redirect(SUrl)
            ' Dim pdfName As String = "DPIA_Information_Sharing_Agreement_" & nFlowID.ToString & ".pdf"

            Dim pdfName As String = Server.MapPath("~/application/pdfout/") + "DPIA_ISA_" & nFlowID.ToString & ".pdf"
            Utility.GeneratePDFFromURL(sURL, pdfName, "Information Sharing Agreement")
        ElseIf e.CommandName = "Copy" Then
            Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
            Dim nFlowID As Integer = CInt(e.CommandArgument)
            Dim nSummaryID As Integer = taq.GetSummaryIDForFlow(nFlowID)
            Session("nSummaryID") = nSummaryID
            Session("FlowDetailID") = nFlowID
            If nSummaryID > 0 Then
                Response.Redirect("~/application/dataflow_detail.aspx?Action=Copy")
            End If
        ElseIf e.CommandName = "Archive" Then
            Dim currentUser As MembershipUser = Membership.GetUser()
            Dim currentUserId As Guid = DirectCast(currentUser.ProviderUserKey, Guid)
            Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
            taq.ArchiveDataFlow(currentUserId, e.CommandArgument)
            RemovePDFIfExists(e.CommandArgument)
            gvFlows.DataBind()
        ElseIf e.CommandName = "DeleteFlow" Then
            Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
            taq.DataFlowDetail_DELETE(CInt(e.CommandArgument))
            gvFlows.DataBind()
        End If
    End Sub
    Protected Sub RemovePDFIfExists(ByVal nFlowID As Integer)
        Dim pdfName As String = Server.MapPath("~/application/pdfout/") + "DPIA_ISA_" & nFlowID.ToString & ".pdf"
        If File.Exists(pdfName) Then
            File.Delete(pdfName)
        End If
    End Sub
    Private Sub gvFlows_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvFlows.RowDataBound
        If e.Row.Cells.Count > 1 Then
            'Hide the Export column if the org has a "free" licence:
            'If Session("orgLicenceType") = "Free, limited licence" Then
            '    e.Row.Cells(9).CssClass = "hiddencol"
            'End If
            'Hide controls according to role:
            'If Session("UserRoleAdmin") = False And Session("UserRoleIAO") = False And Session("UserRoleIGO") = False Then
            '    e.Row.Cells(10).CssClass = "hiddencol"
            '    e.Row.Cells(11).CssClass = "hiddencol"
            'End If
            If ddStatus.SelectedValue = 1 Then
                'If the status is "in dev" don't show the first signed column:
                e.Row.Cells(7).CssClass = "hiddencol"
            End If
            If cbHideArchived.Checked Then
                'Don't show the archived date field:
                e.Row.Cells(8).CssClass = "hiddencol"
            End If
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

    Private Sub lbtUpdateFilter_Click(sender As Object, e As EventArgs) Handles lbtUpdateFilter.Click
        If ddSummarySelect.SelectedValue < 1 Then
            lbtAdd.Visible = False
        Else
            If Session("UserRoleAdmin") Or Session("UserRoleIAO") Or Session("UserRoleIGO") Then
                lbtAdd.Visible = True
            End If
        End If
    End Sub

    Private Sub ddStatus_DataBound(sender As Object, e As EventArgs) Handles ddStatus.DataBound
        If Not Page.Request.Item("filter") Is Nothing Then
            Dim nStatus As Integer = CInt(Page.Request.Item("filter"))
            ddStatus.SelectedValue = nStatus
            cbInvolvingMyOrg.Checked = True
            FilterPanel.CssClass = "collapse filter-panel in"
            pnlStatus.CssClass = "form-group has-success"
            ddStatus.CssClass = "form-control bg-warning"
        End If
    End Sub

    Private Sub lbtExportDFList_Click(sender As Object, e As EventArgs) Handles lbtExportDFList.Click
        Dim DFs_Export As New DataSet("DPIA DataFlow Export")
        Dim taDF As New DataFlowDetailTableAdapters.DataFlowDetail_GetFilteredTableAdapter
        Dim tDF As New DataFlowDetail.DataFlowDetail_GetFilteredDataTable
        tDF = taDF.GetData(True, Session("UserOrganisationID"), cbHideArchived.Checked, cbAddedByMyOrg.Checked, cbInvolvingMyOrg.Checked, tbSearch.Text.ToString, ddSharingOrgs.SelectedValue, ddStatus.SelectedValue, ddSummarySelect.SelectedValue)
        tDF.TableName = "DPIA DataFlows"
        DFs_Export.Tables.Add(tDF)
        Dim sDate As String = Date.Now.Day.ToString() & "-" & Date.Now.Month.ToString() & "-" & Date.Now.Year.ToString()
        OpenXMLExport.ExportToExcel(DFs_Export, "DPIA DataFlow Export (" + sDate + ").xlsx", Page.Response)
    End Sub

    Private Sub ddSummarySelect_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddSummarySelect.SelectedIndexChanged
        If Session("nSummaryID") <> ddSummarySelect.SelectedValue Then
            Session("nSummaryID") = ddSummarySelect.SelectedValue
        End If
    End Sub
End Class