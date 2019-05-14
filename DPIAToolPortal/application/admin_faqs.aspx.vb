Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports System.Text.RegularExpressions
Imports DevExpress.Web.ASPxHtmlEditor

Public Class admin_faqs
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Private Sub lbtAddNewFAQ_Click(sender As Object, e As EventArgs) Handles lbtAddNewFAQ.Click
        mvFAQs.SetActiveView(vAddEditFAQ)
        fvFAQs.ChangeMode(FormViewMode.Insert)
    End Sub

    Private Sub fvFAQs_ItemCommand(sender As Object, e As FormViewCommandEventArgs) Handles fvFAQs.ItemCommand
        If e.CommandName = "Cancel" Then
            mvFAQs.SetActiveView(vFAQList)
        End If
    End Sub

    Private Sub fvFAQs_ItemInserted(sender As Object, e As FormViewInsertedEventArgs) Handles fvFAQs.ItemInserted
        mvFAQs.SetActiveView(vFAQList)
        gvFAQs.DataBind()
    End Sub

    Private Sub gvFAQs_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvFAQs.RowCommand
        If e.CommandName = "EditFAQ" Then
            mvFAQs.SetActiveView(vAddEditFAQ)
            fvFAQs.ChangeMode(FormViewMode.Edit)
            fvFAQs.PageIndex = CInt(e.CommandArgument)
        End If
    End Sub

    Private Sub fvFAQs_ItemUpdated(sender As Object, e As FormViewUpdatedEventArgs) Handles fvFAQs.ItemUpdated
        fvFAQs.ChangeMode(FormViewMode.Insert)
        mvFAQs.SetActiveView(vFAQList)
        gvFAQs.DataBind()
    End Sub
    Protected Sub htmlFAQCorrecting(sender As Object, e As HtmlCorrectingEventArgs)
        Dim regex As New Regex("<img[^/]+src=[""'](?<data>data:image/[^'""]*)[""'][^/]*/>")
        e.Html = regex.Replace(e.Html, New MatchEvaluator(Function(m)
                                                              Dim base64Value As String = m.Groups("data").Value
                                                              Dim tagStr As String = m.Value
                                                              Return tagStr.Replace(base64Value, CreateImageFromBase64(base64Value))

                                                          End Function))
    End Sub
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
    Protected Sub ddAdminGroup_DataBound(sender As Object, e As EventArgs)
        Dim dd As DropDownList = TryCast(sender, DropDownList)
        If Not dd Is Nothing Then
            If Not Session("IsCentralSA") Then
                dd.Items.RemoveAt(0)
                If Session("OrgAdminGroupID") > 0 Then

                    dd.SelectedValue = Session("OrgAdminGroupID")
                End If
            End If
            If dd.Items.Count = 1 Then
                dd.Enabled = False
            End If
        End If
    End Sub
End Class