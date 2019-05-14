Public Class org_mou
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Page.Request.Item("OrganisationID") Is Nothing Then
            Response.Redirect("Default.aspx")
        Else
            Dim taOrg As New ispdatasetTableAdapters.isp_OrganisationsTableAdapter
            Dim tOrg As New ispdataset.isp_OrganisationsDataTable
            tOrg = taOrg.GetData(CInt(Page.Request.Item("OrganisationID")))
            lblOrgName.Text = tOrg.First.OrganisationName
            Dim taTOU As New adminTableAdapters.isp_TermsOfUseTableAdapter
            Dim tTOU As New admin.isp_TermsOfUseDataTable
            tTOU = taTOU.GetCurrent("MOU")
            If tTOU.Count > 0 Then
                litMOUText.Text = tTOU.First.TermsHTML.Replace("pre-scrollable", "")
            End If
        End If

    End Sub

End Class