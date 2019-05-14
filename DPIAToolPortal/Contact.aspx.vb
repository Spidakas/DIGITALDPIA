Public Class Contact
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
		If Not Page.IsPostBack Then
			If CInt(Session("OrgAdminGroupID")) > 0 Then
				Dim taAG As New adminTableAdapters.isp_AdminGroupsTableAdapter
				Dim tag As New admin.isp_AdminGroupsDataTable
				tag = taAG.GetByAdminGroupID(Session("OrgAdminGroupID"))
				hlEmail.NavigateUrl = "mailto:" & tag.First.EmailAddress
				lblEmail.Text = tag.First.EmailAddress
				litAddress.Text = tag.First.Address.ToString().Replace(Environment.NewLine, "<br />")
				lblTelephone.Text = tag.First.Telephone
			End If
		End If
    End Sub

    '  Private Sub lbtSendEmail_Click(sender As Object, e As EventArgs) Handles lbtSendEmail.Click
    'Dim sEmail As String = lblEmail.Text
    '      Dim sSubject As String = tbSubject.Text
    '      Dim sBody As String = tbMessage.Text & " <br/>From: " & tbReplyAddress.Text
    '      Utility.SendEmail(sEmail, sSubject, sBody, True)
    '      mvContact.SetActiveView(vThanks)
    '  End Sub
End Class