Public Class admin_resources
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'If Not Session("IsCentralSA") Then
        '    pnlAGAdd.Attributes.Add("style", "display:none;")
        '    pnlAGEdit.Attributes.Add("style", "display:none;")
        'End If

    End Sub

    Private Sub lbtUploadResource_Click(sender As Object, e As EventArgs) Handles lbtUploadResource.Click
        UploadFileAndPopBox(fupResource, ResourcePathTextBox, ddType)
    End Sub
    Protected Sub UploadFileAndPopBox(ByVal fup As FileUpload, ByVal tb As TextBox, ByVal dd As DropDownList)
        If fup.HasFile Then
            Dim size As Integer = fup.PostedFile.ContentLength
            Dim sContentType As String = fup.PostedFile.ContentType
            Dim fileData As Byte() = New Byte(size - 1) {}
            Dim sFilename As String = System.IO.Path.GetFileName(fup.PostedFile.FileName)
            fup.PostedFile.InputStream.Read(fileData, 0, size)
            Dim nFileID As Integer
            Dim fpath As String
            Dim taQ As New ispdatasetTableAdapters.QueriesTableAdapter
            nFileID = taQ.InsertFile(sFilename, sContentType, fup.PostedFile.InputStream.Length / 1024, fileData, Session("UserOrganisationID"), Session("UserEmail"))
            fpath = "GetFile.aspx?FileID=" & nFileID.ToString()
            Dim extension As String

            extension = System.IO.Path.GetExtension(fup.PostedFile.FileName)
            tb.Text = fpath
            Select Case extension
                Case ".xlsx", ".xls"
                    dd.SelectedValue = "icon-file-excel"
                Case ".docx", ".doc", ".dotx", ".dot"
                    dd.SelectedValue = "icon-file-word"
                Case ".pdf"
                    dd.SelectedValue = "icon-file-pdf"
                Case ".zip"
                    dd.SelectedValue = "icon-file-zip"
                Case ".bmp", ".jpg", ".jpeg", ".png", ".tif", ".gif"
                    dd.SelectedValue = "icon-file-picture"
                Case ".pptx", "ppsx", "ppt", "pps"
                    dd.SelectedValue = "file-powerpoint-o"
                Case Else
                    dd.SelectedValue = "icon-file2"
            End Select

        Else
            Exit Sub
        End If
    End Sub

    Private Sub lbtUploadConfirm_Click(sender As Object, e As EventArgs) Handles lbtUploadConfirm.Click
		Dim taRes As New adminTableAdapters.isp_ResourcesTableAdapter
        taRes.InsertQuery(tbResourceName.Text, ResourcePathTextBox.Text, ddType.SelectedValue, tbResourceDesc.Text, ddAdminGroup.SelectedValue, cbPreLogin.Checked, cbRequiresFullLicence.Checked, tbCategory.Text)
        gvResources.DataBind()
		tbResourceName.Text = ""
		ResourcePathTextBox.Text = ""
		ddType.SelectedIndex = 0
        tbResourceDesc.Text = ""
        cbPreLogin.Checked = True
	End Sub

	Private Sub gvResources_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvResources.RowCommand
		If e.CommandName = "DeleteResource" Then
			Dim taRes As New adminTableAdapters.isp_ResourcesTableAdapter
			taRes.DeleteQuery(e.CommandArgument)
			gvResources.DataBind()
		ElseIf e.CommandName = "EditResource" Then
			hfResourceIDEdit.Value = e.CommandArgument
			Dim taRes As New adminTableAdapters.isp_ResourcesTableAdapter
			Dim tRes As New admin.isp_ResourcesDataTable
			tRes = taRes.GetData(e.CommandArgument)
            If tRes.Count > 0 Then
                tbResourceNameEdit.Text = tRes.First.ResourceName
                tbResourcePathEdit.Text = tRes.First.URL
                tbResourceDescriptionEdit.Text = tRes.First.ResourceDescription
                tbCategoryEdit.Text = tRes.First.Category
                ddTypeEdit.SelectedValue = tRes.First.Type
                cbPreLoginEdit.Checked = tRes.First.PreLogin
                cbRequiresFullLicenceEdit.Checked = tRes.First.RequiresFullLicence
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowEditModal", "<script>$('#modalEditResource').modal('show');</script>")
            End If

        End If
	End Sub

	Private Sub lbtEditOK_Click(sender As Object, e As EventArgs) Handles lbtEditOK.Click
		Dim taRes As New adminTableAdapters.isp_ResourcesTableAdapter
        taRes.isp_Resources_Update(tbResourceNameEdit.Text, tbResourcePathEdit.Text, ddTypeEdit.SelectedValue, tbResourceDescriptionEdit.Text, cbPreLoginEdit.Checked, ddAdminGroupEdit.SelectedValue, cbRequiresFullLicenceEdit.Checked, tbCategoryEdit.Text, hfResourceIDEdit.Value)
        gvResources.DataBind()
	End Sub

    Private Sub ddAdminGroup_DataBound(sender As Object, e As EventArgs) Handles ddAdminGroup.DataBound, ddAdminGroupEdit.DataBound
        Dim dd As DropDownList = TryCast(sender, DropDownList)
        If Not dd Is Nothing Then
            If Not Session("IsCentralSA") Then
                dd.Items.RemoveAt(0)
                If Session("OrgAdminGroupID") > 0 Then

                    dd.SelectedValue = Session("OrgAdminGroupID")
                End If
            End If
            If dd.Items.Count = 1 Then
                If dd.ID = "ddAdminGroup" Then
                    pnlAGAdd.Attributes.Add("style", "display:none;")
                Else
                    pnlAGEdit.Attributes.Add("style", "display:none;")
                End If
            End If
        End If
    End Sub

    Private Sub lbtUploadResourceEdit_Click(sender As Object, e As EventArgs) Handles lbtUploadResourceEdit.Click
        UploadFileAndPopBox(fupResourceEdit, tbResourcePathEdit, ddTypeEdit)
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowEditModal", "<script>$('#modalEditResource').modal('show');</script>")
    End Sub


End Class