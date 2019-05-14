Imports DevExpress.Web.Bootstrap

Public Class home_dash
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        hfOrgID.Value = Session("UserOrganisationID")
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        hfRegionID.Value = taq.GetRegionIDForOrg(Session("UserOrganisationID"))
        Session("nSummaryID") = Nothing
        'Dim sSeg As String = HttpContext.Current.Request.Url.Host
        'If sSeg = "www.info-sharing-sandpit.org.uk" Then
        '    pnlPlaceholder.Visible = True
        'Else
        'pnlPlaceholder.Visible = True
        'End If

    End Sub

    Protected Sub ViewOrgDetails_Click(sender As Object, e As CommandEventArgs)
        Dim orgd As OrgDetailsModal = OrgDetailsModal
        If Not e.CommandArgument Is Nothing Then
            Dim nOrgID As Integer = CInt(e.CommandArgument)
            Dim ds As ObjectDataSource = orgd.FindControl("dsOrganisationDetails")
            ds.SelectParameters(0).DefaultValue = nOrgID
            Dim fv As FormView = orgd.FindControl("fvOrgDetails")
            fv.DataBind()
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "orgDetailsModalOpen", "$('#modalOrgDetails').modal('show');", True)
        End If
    End Sub
    Protected Sub btnGetOrgInfo_Click(sender As Object, e As EventArgs) Handles btnGetOrgInfo.Click
        Dim orgd As OrgDetailsModal = OrgDetailsModal
        If Not hfMapOrgID.Value Is Nothing Then
            Dim nOrgID As Integer = CInt(hfMapOrgID.Value)
            Dim ds As ObjectDataSource = orgd.FindControl("dsOrganisationDetails")
            ds.SelectParameters(0).DefaultValue = nOrgID
            Dim fv As FormView = orgd.FindControl("fvOrgDetails")
            fv.DataBind()
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "orgDetailsModalOpen", "$('#modalOrgDetails').modal('show');", True)
        End If
    End Sub


    Private Sub lbtClearFilters_Click(sender As Object, e As EventArgs) Handles lbtClearFilters.Click
        bsgvOrgsSharing.FilterExpression = ""
        bsgvOrgsSharing.SearchPanelFilter = ""
        bsgvOrgsSharing.DataBind()
    End Sub
    Private Sub lbtExportDAList_Click(sender As Object, e As EventArgs) Handles lbtExportDAList.Click
        Dim bsgv As BootstrapGridView = bsgvOrgsSharing
        Try
            bsgv.Columns("ISGID").Visible = True
            bsgv.Columns("OrgType").Visible = True
            bsgv.Columns("ICORegistrationNumber").Visible = True
            bsgv.Columns("AssuranceType").Visible = True
            bsgv.Columns("ICORegReviewDate").Visible = True
            bsgv.Columns("IGComplianceVersion").Visible = True
            bsgv.Columns("IGComplianceScore").Visible = True
            bsgv.Columns("TierZeroSigned").Visible = True
            bsgvExporter.WriteXlsxToResponse("ISGSharingOrgsExport")
            bsgv.Columns("ISGID").Visible = False
            bsgv.Columns("OrgType").Visible = False
            bsgv.Columns("ICORegistrationNumber").Visible = False
            bsgv.Columns("AssuranceType").Visible = False
            bsgv.Columns("ICORegReviewDate").Visible = False
            bsgv.Columns("IGComplianceVersion").Visible = False
            bsgv.Columns("IGComplianceScore").Visible = False
            bsgv.Columns("TierZeroSigned").Visible = False
        Catch ex As Exception
            Dim sEx As String = ex.Message
        End Try

    End Sub
    'Protected Sub GridViewCustomToolbar_ToolbarItemClick(ByVal source As Object, ByVal e As BootstrapGridViewToolbarItemClickEventArgs)
    '    Select Case e.Item.Name
    '        Case "Export"
    '            Dim bsgv As BootstrapGridView = bsgvOrgsSharing
    '            'Try
    '            bsgv.Columns("ISGID").Visible = True
    '                bsgv.Columns("OrgType").Visible = True
    '                bsgv.Columns("ICORegistrationNumber").Visible = True
    '                bsgv.Columns("AssuranceType").Visible = True
    '                bsgv.Columns("ICORegReviewDate").Visible = True
    '                bsgv.Columns("IGComplianceVersion").Visible = True
    '                bsgv.Columns("IGComplianceScore").Visible = True
    '                bsgv.Columns("TierZeroSigned").Visible = True
    '                bsgvExporter.WriteXlsxToResponse("ISGSharingOrgsExport")
    '                bsgv.Columns("ISGID").Visible = False
    '                bsgv.Columns("OrgType").Visible = False
    '                bsgv.Columns("ICORegistrationNumber").Visible = False
    '                bsgv.Columns("AssuranceType").Visible = False
    '                bsgv.Columns("ICORegReviewDate").Visible = False
    '                bsgv.Columns("IGComplianceVersion").Visible = False
    '                bsgv.Columns("IGComplianceScore").Visible = False
    '                bsgv.Columns("TierZeroSigned").Visible = False
    '            'Catch ex As Exception
    '            '    Dim sEx As String = ex.Message
    '            'End Try
    '        Case Else
    '    End Select
    'End Sub
End Class