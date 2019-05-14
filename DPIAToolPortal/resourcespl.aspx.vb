Public Class resourcespl
    Inherits System.Web.UI.Page

    'Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    '    If Not Page.IsPostBack Then
    '        If Not Session("orgLicenceType") = "Free, limited licence" Then
    '            dsResources.SelectParameters.Item(2).DefaultValue = True
    '        End If
    '    End If
    'End Sub

    'Protected Sub ReportBroken_Click(sender As Object, e As CommandEventArgs)
    '    Dim taRes As New ispdatasetTableAdapters.isp_ResourcesTableAdapter
    '    taRes.ReportBroken(e.CommandArgument)
    '    Dim tRes As New ispdataset.isp_ResourcesDataTable
    '    tRes = taRes.GetByResourceID(e.CommandArgument)
    '    Dim sMessage As String = ""
    '    sMessage = sMessage & "<p>Dear DPIA Administrator</p>"
    '    sMessage = sMessage & "<p>The DPIA user <a href='mailto:" & Session("UserEmail") & "'>" & Session("UserOrgUserName") & "</a> from " & Session("UserOrganisationName") & " has reported that the link <a href='" & tRes.First.URL & "'>" & tRes.First.ResourceName & "</a> is broken.<p>"
    '    sMessage = sMessage & "<p>Please investigate this issue and resolve as appropriate.</p>"
    '    Utility.SendEmail("isg@mbhci.nhs.uk", "DPIA Resources Broken Link Report - " & tRes.First.ResourceName, sMessage, True)
    '    Page.ClientScript.RegisterStartupScript(Me.GetType(), "reportedBroken", "<script>$('#modalMessage').modal('show');</script>")
    'End Sub


End Class