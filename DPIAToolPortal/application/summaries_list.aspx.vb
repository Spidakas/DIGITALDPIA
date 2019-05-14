Imports DevExpress.Web
Imports DevExpress.Web.Bootstrap

Public Class summaries_list
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Session("FlowDetailID") = Nothing
        End If
        If Session("orgLicenceType") = "Free, limited licence" Then
            pnlFreeLicenceMessage.Visible = True
            bsgvSummaries.Toolbars(0).Items.FindByName("Export").Visible = False
        End If
    End Sub
    Protected Function PadID(value As Integer) As String

        Dim fmt As String = "DS000000"
        Dim str As String = value.ToString(fmt)
        Return str
    End Function
    Protected Function PadDFID(value As Integer) As String

        Dim fmt As String = "DF000000"
        Dim str As String = value.ToString(fmt)
        Return str
    End Function
    Protected Sub EditShare(sender As Object, e As CommandEventArgs)
        Dim nShareID As Integer = e.CommandArgument
        Session("nSummaryID") = nShareID
        Response.Redirect("~/application/dataflow_summary.aspx")
    End Sub
    Protected Sub ArchiveSummary(sender As Object, e As CommandEventArgs)
        hfArchiveSummaryID.Value = e.CommandArgument
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalArchive", "<script>$('#modalArchive').modal('show');</script>")
        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalArchive", "$('#modalArchive').modal('show');", True)
    End Sub
    'Private Sub lbtClearFilters_Click(sender As Object, e As EventArgs) Handles lbtClearFilters.Click
    '    bsgvSummaries.FilterExpression = ""
    '    bsgvSummaries.SearchPanelFilter = ""
    '    bsgvSummaries.DataBind()
    'End Sub
    'Private Sub lbtExportDAList_Click(sender As Object, e As EventArgs) Handles lbtExportList.Click
    '    Dim bsgv As BootstrapGridView = bsgvSummaries
    '    Dim bArchVis As Boolean = bsgv.Columns("View / Edit").Visible
    '    bsgv.Columns("View / Edit").Visible = False
    '    bsgvExporter.WriteXlsxToResponse()
    '    bsgv.Columns("View / Edit").Visible = bArchVis
    'End Sub
    Protected Sub GridViewCustomToolbar_ToolbarItemClick(ByVal source As Object, ByVal e As BootstrapGridViewToolbarItemClickEventArgs)
        Select Case e.Item.Name
            Case "Export"
                Dim bsgv As BootstrapGridView = bsgvSummaries
                Dim bArchVis As Boolean = bsgv.Columns("View / Edit").Visible
                bsgv.Columns("View / Edit").Visible = False
                bsgvExporter.WriteXlsxToResponse()
                bsgv.Columns("View / Edit").Visible = bArchVis
            Case Else
        End Select
    End Sub
    Protected Sub bsgvFlowsForSummary_DataSelect(ByVal sender As Object, ByVal e As EventArgs)
        Session("nSummaryID") = (TryCast(sender, BootstrapGridView)).GetMasterRowKeyValue()
    End Sub
    Protected Sub Edit_Click(sender As Object, e As CommandEventArgs)
        Dim nFlowID As Integer = CInt(e.CommandArgument)
        Session("FlowEditMode") = False
        Session("FlowDetailID") = nFlowID
        If CInt(Session("nSummaryID")) > 0 Then
            Response.Redirect("~/application/dataflow_detail.aspx?Action=Edit")
        End If
    End Sub
    Protected Sub View_Click(sender As Object, e As CommandEventArgs)
        Dim nFlowID As Integer = CInt(e.CommandArgument)
        Session("FlowDetailID") = nFlowID
        Session("FlowEditMode") = False
        If CInt(Session("nSummaryID")) > 0 Then
            Response.Redirect("~/application/dataflow_detail.aspx?Action=Edit")
        End If
    End Sub
    Protected Sub Export_Click(sender As Object, e As CommandEventArgs)
        Dim nFlowID As Integer = CInt(e.CommandArgument)
        Dim sPath As String = Request.Url.AbsoluteUri
        Dim nPos As Integer = sPath.LastIndexOf("application/")
        sPath = sPath.Substring(0, nPos)
        Dim sURL As String = sPath & "DSAExport.aspx?DFDID=" & nFlowID.ToString
        'Response.Redirect(SUrl)
        ' Dim pdfName As String = "DPIA_Information_Sharing_Agreement_" & nFlowID.ToString & ".pdf"

        Dim pdfName As String = Server.MapPath("~/application/pdfout/") + "DPIA_ISA_" & nFlowID.ToString & ".pdf"
        Utility.GeneratePDFFromURL(sURL, pdfName, "Information Sharing Agreement")
    End Sub
    Protected Sub Copy_Click(sender As Object, e As CommandEventArgs)
        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        Dim nFlowID As Integer = CInt(e.CommandArgument)
        Session("FlowDetailID") = nFlowID
        If CInt(Session("nSummaryID")) > 0 Then
            Response.Redirect("~/application/dataflow_detail.aspx?Action=Copy")
        End If
    End Sub
    Protected Sub DeleteFlow_Click(sender As Object, e As CommandEventArgs)
        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        taq.DataFlowDetail_DELETE(CInt(e.CommandArgument))
        bsgvSummaries.DataBind()
    End Sub
    Protected Sub Archive_Click(sender As Object, e As CommandEventArgs)
        Dim currentUser As MembershipUser = Membership.GetUser()
        Dim currentUserId As Guid = DirectCast(currentUser.ProviderUserKey, Guid)
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        taq.ArchiveDataFlow(currentUserId, e.CommandArgument)
        bsgvSummaries.DataBind()
    End Sub
    Protected Sub lbtAddDF_Click(ByVal sender As Object, ByVal e As CommandEventArgs)
        Response.Redirect("~/application/dataflow_detail.aspx?Action=Add")
    End Sub
    Private Sub lbtAdd_Click(sender As Object, e As EventArgs) Handles lbtAdd.Click
        Response.Redirect("~/application/dataflow_summary.aspx?action=add")
    End Sub
    Private Sub bsgvSummaries_HtmlRowPrepared(sender As Object, e As ASPxGridViewTableRowEventArgs) Handles bsgvSummaries.HtmlRowPrepared
        If e.RowType <> DevExpress.Web.GridViewRowType.Data Then
            Return
        End If
        Dim nOverdue As Integer = CInt(e.GetValue("OverDue"))
        If e.GetValue("DFArchivedDate").ToString.Length > 0 Then
            e.Row.CssClass = "text-muted"
        ElseIf nOverdue = 2 Then
            e.Row.CssClass = "danger alert-danger"
            e.Row.ToolTip = "Review date passed"
        ElseIf nOverdue = 1 Then
            e.Row.CssClass = "warning alert-warning"
            e.Row.ToolTip = "Within 1 month of review date"
        End If

    End Sub
    Protected Sub bsgvFlowsForSummary_HtmlRowPrepared(sender As Object, e As ASPxGridViewTableRowEventArgs)
        If e.RowType <> DevExpress.Web.GridViewRowType.Data Then
            Return
        End If
        If Not e.GetValue("InvolvesMyOrg") Then
            e.Row.CssClass = "text-muted"
            e.Row.ToolTip = "Flow does not involve my organisation"
        ElseIf e.GetValue("Archived").ToString.Length > 0 Then
            e.Row.CssClass = "text-muted"
            e.Row.ToolTip = "Flow archived"
        End If
    End Sub
    Private Sub lbtArchiveConfirm_Click(sender As Object, e As EventArgs) Handles lbtArchiveConfirm.Click, lbtRecycleAll.Click, lbtRecycleSummary.Click
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        Dim currentUser As MembershipUser = Membership.GetUser()
        Dim currentUserId As Guid = DirectCast(currentUser.ProviderUserKey, Guid)
        Dim lbt As LinkButton = TryCast(sender, LinkButton)
        Dim nFlowCount As Integer
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

        bsgvSummaries.DataBind()
        ShowMessage()

    End Sub
    Protected Sub ShowMessage()
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalMessage", "<script>$('#modalMessage').modal('show');</script>")
        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalMessage", "$('#modalMessage').modal('show');", True)
    End Sub
End Class