Public Class isg_privacy
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim taTOU As New adminTableAdapters.isp_TermsOfUseTableAdapter
        Dim tTOU As New admin.isp_TermsOfUseDataTable
        tTOU = taTOU.GetCurrent("Privacy")
        If tTOU.Count > 0 Then
            litPrivacyText.Text = tTOU.First.TermsHTML.Replace("pre-scrollable", "")
        End If
    End Sub

End Class