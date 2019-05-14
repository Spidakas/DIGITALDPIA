Imports DevExpress.Web
Imports DevExpress.Web.Bootstrap

Public Class flows_list
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Not Page.Request.Item("filter") Is Nothing Then
                Session("DFFilterID") = Page.Request.Item("filter")
            End If

        End If
        If Session("orgLicenceType") = "Free, limited licence" Then
            pnlFreeLicenceMessage.Visible = True
            bsgvFlows.Toolbars(0).Items.FindByName("Export").Visible = False
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
    'Private Sub lbtClearFilters_Click(sender As Object, e As EventArgs) Handles lbtClearFilters.Click
    '    bsgvFlows.FilterExpression = ""
    '    bsgvFlows.SearchPanelFilter = ""
    '    bsgvFlows.DataBind()
    'End Sub
    'Private Sub lbtExportDAList_Click(sender As Object, e As EventArgs) Handles lbtExportList.Click
    '    Dim bsgv As BootstrapGridView = bsgvFlows
    '    Dim bArchVis As Boolean = bsgv.Columns("View / Edit").Visible
    '    bsgv.Columns("View / Edit").Visible = False
    '    bsgvExporter.WriteXlsxToResponse()
    '    bsgv.Columns("View / Edit").Visible = bArchVis
    'End Sub
    Protected Sub GridViewCustomToolbar_ToolbarItemClick(ByVal source As Object, ByVal e As BootstrapGridViewToolbarItemClickEventArgs)
        Select Case e.Item.Name
            Case "Export"
                Dim bsgv As BootstrapGridView = bsgvFlows
                Dim bArchVis As Boolean = bsgv.Columns("View / Edit").Visible
                bsgv.Columns("View / Edit").Visible = False
                bsgv.Columns("Tools").Visible = False
                bsgvExporter.WriteXlsxToResponse()
                bsgv.Columns("View / Edit").Visible = bArchVis
                bsgv.Columns("Tools").Visible = True
            Case Else
        End Select
    End Sub
    Protected Sub Edit_Click(sender As Object, e As CommandEventArgs)
        Dim nFlowID As Integer = CInt(e.CommandArgument)
        Session("FlowEditMode") = False
        Session("FlowDetailID") = nFlowID
        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        Dim nSummaryID As Integer = taq.GetSummaryIDForFlow(nFlowID)
        Session("nSummaryID") = nSummaryID
        If CInt(Session("nSummaryID")) > 0 Then
            Response.Redirect("~/application/dataflow_detail.aspx?Action=Edit")
        End If
    End Sub
    Protected Sub View_Click(sender As Object, e As CommandEventArgs)
        Dim nFlowID As Integer = CInt(e.CommandArgument)
        Session("FlowDetailID") = nFlowID
        Session("FlowEditMode") = False
        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        Dim nSummaryID As Integer = taq.GetSummaryIDForFlow(nFlowID)
        Session("nSummaryID") = nSummaryID
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
        Dim nSummaryID As Integer = taq.GetSummaryIDForFlow(nFlowID)
        Session("nSummaryID") = nSummaryID
        Session("FlowDetailID") = nFlowID
        If CInt(Session("nSummaryID")) > 0 Then
            Response.Redirect("~/application/dataflow_detail.aspx?Action=Copy")
        End If
    End Sub
    Protected Sub DeleteFlow_Click(sender As Object, e As CommandEventArgs)
        Dim taq As New DataFlowDetailTableAdapters.QueriesTableAdapter
        taq.DataFlowDetail_DELETE(CInt(e.CommandArgument))
        bsgvFlows.DataBind()
    End Sub
    Protected Sub Archive_Click(sender As Object, e As CommandEventArgs)
        Dim currentUser As MembershipUser = Membership.GetUser()
        Dim currentUserId As Guid = DirectCast(currentUser.ProviderUserKey, Guid)
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        taq.ArchiveDataFlow(currentUserId, e.CommandArgument)
        bsgvFlows.DataBind()
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
    Private Sub ddSharingOrgs_DataBound(sender As Object, e As EventArgs) Handles ddSharingOrgs.DataBound
        If Not Page.Request.Item("orgid") Is Nothing Then
            bsgvFlows.FilterExpression = ""
            If Not ddSharingOrgs.Items.FindByValue(Page.Request.Item("orgid")) Is Nothing Then
                ddSharingOrgs.SelectedValue = Page.Request.Item("orgid")

                pnlShareOrg.CssClass = "form-group has-success"
                ddSharingOrgs.CssClass = "form-control bg-warning"
                bsgvFlows.DataBind()
            End If
        End If
    End Sub

    Private Sub bsgvFlows_DataBound(sender As Object, e As EventArgs) Handles bsgvFlows.DataBound
        If Not Session("DFFilterID") Is Nothing Then
            Dim nFilterID As Integer = CInt(Session("DFFilterID"))
            Session("DFFilterID") = Nothing
            Dim sFilter As String = ""
            Select Case nFilterID
                Case 1
                    sFilter = "[InDraft] = True And [Signatures] = 0"
                Case 2
                    sFilter = "[InDraft] = False And [SignatureRequests] > 0"
                Case 3
                    sFilter = "[InDraft] = False And [SignatureRequests] = 0 And [Signatures] > 0"
                Case 4
                    sFilter = "[NonGDPRCompliant] = True"
            End Select
            bsgvFlows.FilterExpression = sFilter
        ElseIf Not Session("SelectedSummaryID") Is Nothing Then
            bsgvFlows.FilterExpression = "[SummaryID] = " & Session("SelectedSummaryID")
            Session("nSummaryID") = Session("SelectedSummaryID")
            bsbtnAdd.ClientVisible = True
            Session("SelectedSummaryID") = Nothing
        Else
            bsbtnAdd.ClientVisible = False

        End If
        If cbIncludeArchived.Checked Then
            bsgvFlows.Columns("Archived").Visible = True
        End If
    End Sub


    Private Sub bsbtnAdd_Click(sender As Object, e As EventArgs) Handles bsbtnAdd.Click
        Response.Redirect("~/application/dataflow_detail.aspx?Action=Add")
    End Sub
End Class