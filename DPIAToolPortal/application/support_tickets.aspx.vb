Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports System.Text.RegularExpressions
Imports DevExpress.Web.ASPxHtmlEditor

Public Class support_tickets
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim sSupportAdmin As String = Session("orgSupportAdmin")
            If Not Page.Request.Item("ticketid") Is Nothing Then
                Dim nTicketID As Integer = CInt(Page.Request.Item("ticketid"))
                If nTicketID > 0 Then
                    OpenTicket(nTicketID)
                End If

            End If
            If Not Session("IsSuperAdmin") Is Nothing Then
                If Session("IsSuperAdmin") Then
                    pnlSAMine.Visible = True
                    If Session("IsCentralSA") Then
                        dsTickets.SelectParameters.Item(2).DefaultValue = 0

                    Else
                        Dim taSAG As New adminTableAdapters.isp_SuperAdminGroupsTableAdapter
                        Dim tSAG As New admin.isp_SuperAdminGroupsDataTable
                        tSAG = taSAG.GetBySuperAdminID(Session("SuperAdminID"))
                        dsTickets.SelectParameters.Item(2).DefaultValue = tSAG.First.AdminGroupID
                    End If
                ElseIf Session("orgSupportAdmin") = "None" Then
                    mvSupportTickets.SetActiveView(vNoTickets)
                Else
                    pnlSAMine.Visible = False
                    pnlPriority.Visible = False
                End If
            End If

            'parameter test:
            'Dim sEmail As String = Session("UserEmail")
            'Dim nUserAdminGroupID As Integer = Session("OrgAdminGroupID")
            'Dim bSuperAdmin As Boolean = Session("IsSuperAdmin")
            'Dim nUserOrgID As Integer = Session("UserOrganisationID")
            'Dim sSearch As String = tbSearch.Text
        End If

    End Sub

    Private Sub lbtRaiseTicket_Click(sender As Object, e As EventArgs) Handles lbtRaiseTicket.Click
        mvSupportTickets.SetActiveView(vAddTicket)
    End Sub

    Private Sub lbtSubmitNewSupportTicket_Click(sender As Object, e As EventArgs) Handles lbtSubmitNewSupportTicket.Click
        Dim taq As New TicketsTableAdapters.QueriesTableAdapter
        'Create the ticket
        Dim sEmail As String = Session("UserEmail").ToString()
        Dim sOrgName As String = Session("UserOrganisationName").ToString()
        Dim nOrgAdminGroupID As Integer = CInt(Session("OrgAdminGroupID"))
        Dim nOrgID As Integer = CInt(Session("UserOrganisationID"))
        Dim nTicketID As Integer = taq.SupportTicket_InsertAndReturnID(tbSubject.Text, sEmail, sOrgName, nOrgAdminGroupID, nOrgID)
        'Add the first comment:
        Dim nTicketCommentID As Integer = taq.SupportTicketComment_InsertAndReturnID(nTicketID, htmlNewTicket.Html, sEmail, 1)
        If nTicketCommentID > 0 Then
            'send e-mail:
            Dim sComment As String = RemoveHTMLTags(htmlNewTicket.Html)
            Dim sBody As String = ""
            Dim sSubject As String = ""
            Dim sUserName As String = Session("UserOrgUserName")
            Dim taAG As New adminTableAdapters.isp_AdminGroupsTableAdapter
            Dim tAG As New admin.isp_AdminGroupsDataTable
            Dim sTicketURL As String = HttpContext.Current.Request.UrlReferrer.GetLeftPart(UriPartial.Authority) & HttpContext.Current.Request.ApplicationPath & "application/support_tickets?ticketid=" & nTicketID.ToString()

            tAG = taAG.GetDataByTicketID(nTicketID)
            If tAG.Count > 0 Then
                Dim sAGEmail As String = Session("orgSupportAdmin")
                Dim sAGContactName As String = tAG.First.GroupContact
                If sAGEmail <> tAG.First.EmailAddress Then
                    sAGContactName = taq.GetUsernameFromEmail(sAGEmail)
                End If

                If sAGEmail <> "" And sEmail <> "" Then
                    sBody = "<p>Dear " & sAGContactName & "</p>"
                    If sTicketURL.Contains("sandpit") Then
                        sSubject = "New DPIA Sandpit Ticket " & nTicketID.ToString & " Submitted"
                        sBody = sBody & "<p>A new DPIA Sandpit support ticket " & nTicketID.ToString & " regarding <i>" & tbSubject.Text & "</i> has been submitted to by " & sUserName & ".</p>"
                    Else
                        sSubject = "New DPIA Ticket " & nTicketID.ToString & " Submitted"
                        sBody = sBody & "<p>A new DPIA support ticket " & nTicketID.ToString & " regarding <i>" & tbSubject.Text & "</i> has been submitted to by " & sUserName & ".</p>"
                    End If
                    sBody = sBody & "<p>To view and manage the support ticket <a href='" & sTicketURL & "'>click here</a>.</p>"
                    sBody = sBody & "<p>The ticket detail is:</p>"
                    sBody = sBody & "<hr/>"
                    sBody = sBody & "<div><i>" & sComment & "</i></div>"
                    sBody = sBody & "<hr/>"
                    sBody = sBody & "<p>PLEASE DO NOT REPLY TO THIS E-MAIL. IT WAS SENT FROM AN E-MAIL ADDRESS THAT IS NOT MONITORED.</p>"
                    Utility.SendEmail(sAGEmail, sSubject, sBody, True)
                End If
            End If
            gvTickets.DataBind()
            tbSubject.Text = ""
            htmlNewTicket.Html = ""
            mvSupportTickets.SetActiveView(vTicketList)
        End If
    End Sub

    Private Sub gvTickets_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvTickets.RowCommand
        Dim nTicketID As Integer
        If e.CommandName = "OpenTicket" Then
            nTicketID = CInt(e.CommandArgument)
            OpenTicket(nTicketID)
        ElseIf e.CommandName = "CloseTicket" Then
            nTicketID = CInt(e.CommandArgument)
            ArchiveTicket(nTicketID)
        End If
    End Sub
    Protected Sub OpenTicket(ByVal nTicketID As Integer)
        Dim taTicketDetail As New TicketsTableAdapters.isp_SupportTicketsTableAdapter
        Dim tTicket As New Tickets.isp_SupportTicketsDataTable
        Dim nOrgID As Integer = CInt(Session("UserOrganisationID"))
        tTicket = taTicketDetail.GetSupportTicketByID(nTicketID, Session("IsSuperAdmin"), nOrgID, Session("UserEmail").ToString())
        If tTicket.Count > 0 Then
            hfTicketID.Value = nTicketID
            hfReporterEmail.Value = tTicket.First.ReporterEmail
            lblTicketHeader.Text = "Ticket " & tTicket.First.TicketID
            lblTicketSubject.Text = tTicket.First.Subject
            lblTicketStatus.Text = GetTicketStatus(tTicket.First.TicketStatusID)
            lblAddedDate.Text = tTicket.First.Raised.ToString()
            lblLastUpdate.Text = tTicket.First.LastActivity.ToString()
            dsReassigns.SelectParameters(0).DefaultValue = tTicket.First.CurrentAdminGroupID
            rptAssignTo.DataBind()
            If tTicket.First.AssignedToEmail <> "" Then
                lblAssignTo.Text = "Assigned to " & tTicket.First.AssignedToEmail
            Else
                lblAssignTo.Text = "Assign to"
            End If
            lblResolveBy.Text = tTicket.First.TargetDate.ToString()
            lblAddedBy.Text = tTicket.First.ReporterEmail & ", " & tTicket.First.ReporterOrganisationName
            Select Case tTicket.First.ResponseDays
                Case 1
                    lblResolveByDD.Text = "Resolve target: Same day"
                Case 2
                    lblResolveByDD.Text = "Resolve target: Next day"
                Case 7
                    lblResolveByDD.Text = "Resolve target: One week"
                Case 100
                    lblResolveByDD.Text = "Resolve target: Change request"
            End Select
            dsTicketComments.SelectParameters(0).DefaultValue = nTicketID
            mvSupportTickets.SetActiveView(vManageTicket)
            If tTicket.First.CurrentAdminGroupID > 0 Then
                If Session("IsSuperAdmin") = True Then
                    If Not Session("IsCentralSA") Then
                        lbtEscalate.Visible = True
                    End If
                End If
            Else
                lbtEscalate.Visible = False
            End If
        End If
    End Sub
    Private Sub gvTickets_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvTickets.RowDataBound
        If e.Row.Cells.Count > 1 Then
            If Not Session("IsSuperAdmin") Then
                e.Row.Cells(2).CssClass = "hiddencol"
                e.Row.Cells(5).CssClass = "hiddencol"
                e.Row.Cells(7).CssClass = "hiddencol"
                e.Row.Cells(8).CssClass = "hiddencol"
            ElseIf Not Session("IsCentralSA") Then
                e.Row.Cells(4).CssClass = "hiddencol"
            End If
        End If
    End Sub
    Protected Function GetTicketColourStatus(ByVal nStatusID As Integer)
        Dim sReturn = "btn btn-default"
        Select Case nStatusID
            Case 1
                sReturn = "btn btn-danger"
            Case 2
                sReturn = "btn btn-warning"
            Case 3
                sReturn = "btn btn-success"
        End Select
        Return sReturn
    End Function
    Protected Function GetTicketStatus(ByVal nStatusID As Integer)
        Dim sReturn = "Closed"
        Select Case nStatusID
            Case 1
                sReturn = "New"
            Case 2
                sReturn = "Awaiting Response"
            Case 3
                sReturn = "Responded"
        End Select
        Return sReturn
    End Function
    Protected Function GetSLACSS(ByVal dTarget As DateTime)
        Dim sReturn = ""
        If dTarget < DateTime.Now() Then
            sReturn = "bg-danger"
        End If
        Return sReturn
    End Function
    Private Function CreateImageFromBase64(base64String As String) As String
        base64String = base64String.Split(New String() {"base64,"}, StringSplitOptions.RemoveEmptyEntries)(1)
        Dim imageBytes As Byte() = Convert.FromBase64String(base64String)
        Using ms As New MemoryStream(imageBytes, 0, imageBytes.Length)
            ms.Write(imageBytes, 0, imageBytes.Length)
            Using image__1 As Image = Image.FromStream(ms, True)
                Dim serverPath As String = String.Format("~/Resources/uploadedimages/{0}{1}", Guid.NewGuid(), Utility.GetFileExtension(image__1))
                image__1.Save(Server.MapPath(serverPath))
                Return ResolveClientUrl(serverPath)
            End Using
        End Using
    End Function
    

    Private Sub htmlNewTicket_HtmlCorrecting(sender As Object, e As HtmlCorrectingEventArgs) Handles htmlNewTicket.HtmlCorrecting, htmlAddComment.HtmlCorrecting
        Dim regex As New Regex("<img[^/]+src=[""'](?<data>data:image/[^'""]*)[""'][^/]*/>")
        e.Html = regex.Replace(e.Html, New MatchEvaluator(Function(m)
                                                              Dim base64Value As String = m.Groups("data").Value
                                                              Dim tagStr As String = m.Value
                                                              Return tagStr.Replace(base64Value, CreateImageFromBase64(base64Value))

                                                          End Function))
    End Sub

    Private Sub lbtCloseTicket_Click(sender As Object, e As EventArgs) Handles lbtCloseTicket.Click, lbtCancelNewTicket.Click
        tbSubject.Text = ""
        htmlNewTicket.Html = ""
        gvTickets.DataBind()
        mvSupportTickets.SetActiveView(vTicketList)

    End Sub

    Private Sub lbtSubmitNewComment_Click(sender As Object, e As EventArgs) Handles lbtSubmitNewComment.Click
        'check that a comment has actually been made:
        If htmlAddComment.Html <> "" Then
            'set up ticket comment table adapter access:
            Dim taq As New TicketsTableAdapters.QueriesTableAdapter
            Dim nTicketStatusID As Integer = 2
            If Session("IsSuperAdmin") Then
                nTicketStatusID = 3
            End If
            Dim nTicketID As Integer = CInt(hfTicketID.Value)
            Dim sEmail As String = Session("UserEmail").ToString()
            Dim nInsertedCommentID As Integer = taq.SupportTicketComment_InsertAndReturnID(nTicketID, htmlAddComment.Html, sEmail, nTicketStatusID)
            If nInsertedCommentID > 0 Then
                Dim sComment As String = RemoveHTMLTags(htmlAddComment.Html)
                htmlAddComment.Html = ""
                rptComments.DataBind()
                OpenTicket(nTicketID)
                'send e-mails:
                Dim sBody As String = ""
                Dim sSubject As String = ""
                Dim sUserName As String = Session("UserOrgUserName")
                Dim taAG As New adminTableAdapters.isp_AdminGroupsTableAdapter
                Dim tAG As New admin.isp_AdminGroupsDataTable
                Dim sTicketURL As String = HttpContext.Current.Request.UrlReferrer.GetLeftPart(UriPartial.Authority) & HttpContext.Current.Request.ApplicationPath & "application/support_tickets?ticketid=" & nTicketID.ToString()
                Dim sReporterEmail As String = hfReporterEmail.Value.ToString()
                tAG = taAG.GetDataByTicketID(nTicketID)
                If tAG.Count > 0 Then
                    Dim sAGEmail As String = Session("orgSupportAdmin")
                    If lblAssignTo.Text <> "Assign to" Then
                        sAGEmail = lblAssignTo.Text
                    End If
                    Dim sAGContactName As String = tAG.First.GroupContact
                    If sAGEmail <> tAG.First.EmailAddress Then
                        taq.GetUsernameFromEmail(sAGEmail)
                    End If
                    If sAGEmail <> "" And sReporterEmail <> "" Then
                            If Session("IsSuperAdmin") Then
                                'send an e-mail to the recipient:
                                sBody = "<p>Dear " & taq.GetUsernameFromEmail(sReporterEmail) & "</p>"
                                If sTicketURL.Contains("sandpit") Then
                                sSubject = "Your DPIA Sandpit Ticket " & nTicketID.ToString & " has Received a Response"
                                sBody = sBody & "<p>Your DPIA Sandpit support ticket regarding <i>" & lblTicketSubject.Text & "</i> has been responded to by " & sUserName & ".</p>"

                            Else
                                sSubject = "Your DPIA Ticket " & nTicketID.ToString & " has Received a Response"
                                sBody = sBody & "<p>Your DPIA support ticket regarding <i>" & lblTicketSubject.Text & "</i> has been responded to by " & sUserName & ".</p>"


                            End If


                                sBody = sBody & "<p>To view the response in full and manage your support ticket <a href='" & sTicketURL & "'>click here</a>.</p>"
                                sBody = sBody & "<p>Their response was:</p>"
                                sBody = sBody & "<hr/>"
                                sBody = sBody & "<div><i>" & sComment & "</i></div>"
                                sBody = sBody & "<hr/>"
                                sBody = sBody & "<p>If this response resolves your problem, please don't forget to close the ticket.</p>"
                                sBody = sBody & "<p>PLEASE DO NOT REPLY TO THIS E-MAIL. IT WAS SENT FROM AN E-MAIL ADDRESS THAT IS NOT MONITORED.</p>"
                                Utility.SendEmail(sReporterEmail, sSubject, sBody, True)
                            Else

                                sBody = "<p>Dear " & sAGContactName & "</p>"
                                If sTicketURL.Contains("sandpit") Then
                                sSubject = "DPIA Sandpit Ticket " & nTicketID.ToString & " has Received a Comment from " & sUserName
                                sBody = sBody & "<p>DPIA Sandpit support ticket " & nTicketID.ToString & " regarding <i>" & lblTicketSubject.Text & "</i> has been responded to by " & sUserName & ".</p>"
                            Else
                                sSubject = "DPIA Ticket " & nTicketID.ToString & " has Received a Comment from " & sUserName
                                sBody = sBody & "<p>DPIA support ticket " & nTicketID.ToString & " regarding <i>" & lblTicketSubject.Text & "</i> has been responded to by " & sUserName & ".</p>"

                            End If
                                sBody = sBody & "<p>To view the response in full and manage the support ticket <a href='" & sTicketURL & "'>click here</a>.</p>"
                                sBody = sBody & "<p>Their comment was:</p>"
                                sBody = sBody & "<hr/>"
                                sBody = sBody & "<div><i>" & sComment & "</i></div>"
                                sBody = sBody & "<hr/>"
                                sBody = sBody & "<p>PLEASE DO NOT REPLY TO THIS E-MAIL. IT WAS SENT FROM AN E-MAIL ADDRESS THAT IS NOT MONITORED.</p>"
                                Utility.SendEmail(sAGEmail, sSubject, sBody, True)
                            End If
                        End If
                    End If
                End If
        End If
    End Sub
    Public Function RemoveHTMLTags(ByVal HTMLCode As String) As String
        Return System.Text.RegularExpressions.Regex.Replace( _
          HTMLCode, "<[^>]*>", "")
    End Function
    Protected Sub ArchiveTicket(ByVal nTicketID As Integer)
        'send e-mails:
        Dim taq As New TicketsTableAdapters.QueriesTableAdapter
        Dim sComment As String = RemoveHTMLTags(htmlAddComment.Html)
        Dim sBody As String = ""
        Dim sSubject As String = ""
        Dim sUserName As String = Session("UserOrgUserName")
        Dim taAG As New adminTableAdapters.isp_AdminGroupsTableAdapter
        Dim tAG As New admin.isp_AdminGroupsDataTable
        Dim sTicketURL As String = HttpContext.Current.Request.UrlReferrer.GetLeftPart(UriPartial.Authority) & HttpContext.Current.Request.ApplicationPath & "application/support_tickets?ticketid=" & nTicketID.ToString()
        Dim sReporterEmail As String = hfReporterEmail.Value.ToString()
        tAG = taAG.GetDataByTicketID(nTicketID)
        If tAG.Count > 0 Then
            Dim sAGEmail As String = tAG.First.EmailAddress
            Dim sAGContactName As String = tAG.First.GroupContact
            If sAGEmail <> "" And sReporterEmail <> "" Then
                'send an e-mail to the recipient:

                sBody = "<p>Dear " & taq.GetUsernameFromEmail(sReporterEmail) & "</p>"
                If sTicketURL.Contains("sandpit") Then
                    sSubject = "Your DPIA Sandpit Ticket " & nTicketID.ToString & " has been Closed"
                    sBody = sBody & "<p>Your DPIA Sandpit support ticket regarding <i>" & lblTicketSubject.Text & "</i> has been closed by " & sUserName & ".</p>"
                Else
                    sSubject = "Your DPIA Ticket " & nTicketID.ToString & " has been Closed"
                    sBody = sBody & "<p>Your Data Protection Impact Assessment Tool support ticket regarding <i>" & lblTicketSubject.Text & "</i> has been closed by " & sUserName & ".</p>"
                End If

                sBody = sBody & "<p>To view the support ticket (and reopen if required) <a href='" & sTicketURL & "'>click here</a>.</p>"
                sBody = sBody & "<p>PLEASE DO NOT REPLY TO THIS E-MAIL. IT WAS SENT FROM AN E-MAIL ADDRESS THAT IS NOT MONITORED.</p>"
                Utility.SendEmail(sReporterEmail, sSubject, sBody, True)
            End If
        End If
        taq.CloseTicket(nTicketID)
        gvTickets.DataBind()
    End Sub

    Private Sub rptAssignTo_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptAssignTo.ItemCommand
        If e.CommandName = "AssignTo" Then
            Dim nTicketID As Integer = CInt(hfTicketID.Value)
            Dim sAssignToEmail As String = e.CommandArgument
            Dim taq As New TicketsTableAdapters.QueriesTableAdapter
            taq.AssignTicketToEmail(sAssignToEmail, nTicketID)
            're-assign e-mail:
            Dim sBody As String = ""
            Dim sSubject As String = ""
            Dim sUserName As String = Session("UserOrgUserName")
            Dim sTicketURL As String = HttpContext.Current.Request.UrlReferrer.GetLeftPart(UriPartial.Authority) & HttpContext.Current.Request.ApplicationPath & "application/support_tickets?ticketid=" & nTicketID.ToString()
            Dim sAGEmail As String = sAssignToEmail
            If sAGEmail <> "" Then
                'send an e-mail to the recipient:
                sBody = "<p>Dear " & taq.GetUsernameFromEmail(sAssignToEmail) & "</p>"
                If sTicketURL.Contains("sandpit") Then
                    sSubject = "DPIA Sandpit Ticket " & nTicketID.ToString & " has been Assigned to You (Ticket Based Support Pilot)"
                    sBody = sBody & "<p>DPIA Sandpit support ticket " & nTicketID.ToString & " regarding <i>" & lblTicketSubject.Text & "</i> has been assigned to you by " & sUserName & ".</p>"
                Else
                    sSubject = "DPIA Ticket " & nTicketID.ToString & " has been Assigned to You"
                    sBody = sBody & "<p>DPIA support ticket " & nTicketID.ToString & " regarding <i>" & lblTicketSubject.Text & "</i> has been assigned to you by " & sUserName & ".</p>"
                End If
                sBody = sBody & "<p>To view and manage the support ticket <a href='" & sTicketURL & "'>click here</a>.</p>"
                sBody = sBody & "<p>PLEASE DO NOT REPLY TO THIS E-MAIL. IT WAS SENT FROM AN E-MAIL ADDRESS THAT IS NOT MONITORED.</p>"
                Utility.SendEmail(sAssignToEmail, sSubject, sBody, True)
            End If
            'end re-assign email
            OpenTicket(nTicketID)
        End If
    End Sub

    Private Sub lbtRemoveAssign_Click(sender As Object, e As EventArgs) Handles lbtRemoveAssign.Click
        Dim nTicketID As Integer = CInt(hfTicketID.Value)
        Dim sAssignToEmail As String = ""
        Dim taq As New TicketsTableAdapters.QueriesTableAdapter
        taq.AssignTicketToEmail(sAssignToEmail, nTicketID)
        OpenTicket(nTicketID)
    End Sub

    Private Sub vManageTicket_Activate(sender As Object, e As EventArgs) Handles vManageTicket.Activate
        pnlAssignTo.Visible = Session("IsSuperAdmin")
    End Sub

    Private Sub lbtEscalate_Click(sender As Object, e As EventArgs) Handles lbtEscalate.Click
        Dim taq As New TicketsTableAdapters.QueriesTableAdapter
        Dim nTicketID As Integer = CInt(hfTicketID.Value)
        taq.EscalateTicket(nTicketID)
        'escalate e-mail:
        Dim taAG As New adminTableAdapters.isp_AdminGroupsTableAdapter
        Dim tAG As New admin.isp_AdminGroupsDataTable
        tAG = taAG.GetDataByTicketID(nTicketID)
        Dim sBody As String = ""
        Dim sSubject As String = ""
        Dim sUserName As String = Session("UserOrgUserName")
        Dim sTicketURL As String = HttpContext.Current.Request.UrlReferrer.GetLeftPart(UriPartial.Authority) & HttpContext.Current.Request.ApplicationPath & "application/support_tickets?ticketid=" & nTicketID.ToString()
        Dim sAGEmail As String = tAG.First.EmailAddress
        If sAGEmail <> "" Then
            'send an e-mail to the recipient:
            sBody = "<p>Dear " & tAG.First.GroupContact & "</p>"
            If sTicketURL.Contains("sandpit") Then
                sSubject = "DPIA Sandpit Ticket " & nTicketID.ToString & " has been Escalated to You (Ticket Based Support Pilot)"
                sBody = sBody & "<p>DPIA Sandpit support ticket " & nTicketID.ToString & " regarding <i>" & lblTicketSubject.Text & "</i> has been escalated to you by " & sUserName & ".</p>"
            Else
                sSubject = "DPIA Ticket " & nTicketID.ToString & " has been Escalated to You"
                sBody = sBody & "<p>DPIA support ticket " & nTicketID.ToString & " regarding <i>" & lblTicketSubject.Text & "</i> has been escalated to you by " & sUserName & ".</p>"
            End If
            sBody = sBody & "<p>To view and manage the support ticket <a href='" & sTicketURL & "'>click here</a>.</p>"
            sBody = sBody & "<p>PLEASE DO NOT REPLY TO THIS E-MAIL. IT WAS SENT FROM AN E-MAIL ADDRESS THAT IS NOT MONITORED.</p>"
            Utility.SendEmail(sAGEmail, sSubject, sBody, True)
        End If
        'end escalate email
        OpenTicket(nTicketID)
    End Sub
    Private Sub ddAdminGroupFilter_DataBound(sender As Object, e As EventArgs) Handles ddAdminGroupFilter.DataBound
        If Not Session("IsCentralSA") Then
            ddAdminGroupFilter.Items.RemoveAt(0)
        End If
        If ddAdminGroupFilter.Items.Count = 1 Then
            pnlAdminGroup.Visible = False
            ddAdminGroupFilter.SelectedIndex = 1
            gvTickets.DataBind()
        End If
    End Sub
    'Private Sub ddAdminGroupFilter_DataBound(sender As Object, e As EventArgs) Handles ddAdminGroupFilter.DataBound
    '    If Session("SuperAdminGroupID") = 0 Then
    '        ddAdminGroupFilter.SelectedValue = Session("OrgAdminGroupID")
    '    Else
    '        ddAdminGroupFilter.SelectedValue = Session("SuperAdminGroupID")
    '    End If
    'End Sub

    Private Sub ddAdminGroupFilter_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddAdminGroupFilter.SelectedIndexChanged
        dsTickets.SelectParameters.Item(2).DefaultValue = ddAdminGroupFilter.SelectedValue
    End Sub

    Private Sub lbtSameDay_Click(sender As Object, e As EventArgs) Handles lbtSameDay.Click
        Dim taq As New TicketsTableAdapters.QueriesTableAdapter
        Dim nTicketID As Integer = CInt(hfTicketID.Value)
        taq.SetResolveDaysForTicket(1, nTicketID)
        OpenTicket(nTicketID)
    End Sub
    Private Sub lbtNextDay_Click(sender As Object, e As EventArgs) Handles lbtNextDay.Click
        Dim taq As New TicketsTableAdapters.QueriesTableAdapter
        Dim nTicketID As Integer = CInt(hfTicketID.Value)
        taq.SetResolveDaysForTicket(2, nTicketID)
        OpenTicket(nTicketID)
    End Sub
    Private Sub lbtOneWeek_Click(sender As Object, e As EventArgs) Handles lbtOneWeek.Click
        Dim taq As New TicketsTableAdapters.QueriesTableAdapter
        Dim nTicketID As Integer = CInt(hfTicketID.Value)
        taq.SetResolveDaysForTicket(7, nTicketID)
        OpenTicket(nTicketID)
    End Sub
    Private Sub lbtChangeRequest_Click(sender As Object, e As EventArgs) Handles lbtChangeRequest.Click
        Dim taq As New TicketsTableAdapters.QueriesTableAdapter
        Dim nTicketID As Integer = CInt(hfTicketID.Value)
        taq.SetResolveDaysForTicket(100, nTicketID)
        OpenTicket(nTicketID)
    End Sub

    Private Sub lbtArchiveTicket_Click(sender As Object, e As EventArgs) Handles lbtArchiveTicket.Click
        Dim nTicketID As Integer = CInt(hfTicketID.Value)
        ArchiveTicket(nTicketID)
        OpenTicket(nTicketID)
    End Sub
End Class