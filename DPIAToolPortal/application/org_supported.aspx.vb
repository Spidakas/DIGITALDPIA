Imports DevExpress.Web.Bootstrap

Public Class org_supported
    Inherits System.Web.UI.Page
    Public Function GetProgClass(ByVal pcComp As Integer) As String
        Dim sClass As String = Utility.GetProgClass(pcComp)
        Return sClass
    End Function
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("UserRoleAdmin") And CInt(Session("UserSponsorOrganisationID")) < 1 Then
            lbtAddSponsored.Visible = True
        Else
            lbtAddSponsored.Visible = False
        End If
    End Sub




    Protected Function DoWarning(ByVal checked As Boolean)
        If checked Then
            Return ""
        Else
            Return "list-group-item-danger"
        End If
    End Function



    Private Sub lbtAddSponsored_Click(sender As Object, e As EventArgs) Handles lbtAddSponsored.Click
        Response.Redirect("~/application/organisation_registration.aspx")
    End Sub




    Protected Sub lbtViewOrg_ClickCommand(sender As Object, e As CommandEventArgs)
        Session("UserOrganisationID") = CInt(e.CommandArgument)
        Response.Redirect("~/application/home_intray.aspx?orgid=" & e.CommandArgument.ToString())
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

    Protected Sub RegisterPostbackForLinkButton(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim lbt As LinkButton = TryCast(sender, LinkButton)

        If Not IsNothing(lbt) Then
            ScriptManager.GetCurrent(Me).RegisterPostBackControl(lbt)
        End If

    End Sub
    'Private Sub lbtClearFilters_Click(sender As Object, e As EventArgs) Handles lbtClearFilters.Click
    '    bsgvSponsored.FilterExpression = ""
    '    bsgvSponsored.SearchPanelFilter = ""
    '    bsgvSponsored.DataBind()
    'End Sub
    'Private Sub lbtExportDAList_Click(sender As Object, e As EventArgs) Handles lbtExportDAList.Click
    '    Dim bsgv As BootstrapGridView = bsgvSponsored
    '    Try
    '        bsgvExporter.WriteXlsxToResponse("ISGSponsoredOrgExport")
    '    Catch ex As Exception
    '        Dim sEx As String = ex.Message
    '    End Try

    'End Sub
    Protected Sub GridViewCustomToolbar_ToolbarItemClick(ByVal source As Object, ByVal e As BootstrapGridViewToolbarItemClickEventArgs)
        Select Case e.Item.Name
            Case "Export"
                Dim bsgv As BootstrapGridView = bsgvSponsored
                Try
                    bsgvExporter.WriteXlsxToResponse()
                Catch ex As Exception
                    Dim sEx As String = ex.Message
                End Try
            Case Else
        End Select
    End Sub

    Private Sub lbtExportDAList_Click(sender As Object, e As EventArgs) Handles lbtExportDAList.Click
        Dim bsgv As BootstrapGridView = bsgvSponsored
        Try
            bsgvExporter.WriteXlsxToResponse()
        Catch ex As Exception
            Dim sEx As String = ex.Message
        End Try
    End Sub
End Class