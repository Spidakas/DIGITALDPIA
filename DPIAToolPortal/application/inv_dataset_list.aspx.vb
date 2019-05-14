Imports DevExpress.Web.Bootstrap
Public Class inv_dataset_list
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("UserRoleAdmin") = False And Session("UserRoleIAO") = False And Session("UserRoleIGO") = False Then
            lbtAdd.Visible = False
        End If

    End Sub
    Protected Function PadID(value As Integer) As String

        Dim fmt As String = "DA000000"
        Dim str As String = value.ToString(fmt)
        Return str
    End Function
    Protected Sub lbtAdd_Click(sender As Object, e As EventArgs) Handles lbtAdd.Click
        Session("DAContactGroupID") = 0
        Session("AssetFileGroupID") = 0
        mvInventory.SetActiveView(vAddAsset)
    End Sub

    Private Sub lbtCancelInsert_Click(sender As Object, e As EventArgs) Handles lbtCancelInsert.Click
        ClearAddAssetForm()
        mvInventory.SetActiveView(vInventoryList)
    End Sub
    Private Sub lbtCancelUpdate_Click(sender As Object, e As EventArgs) Handles lbtCancelUpdate.Click
        ClearEditAssetForm()
        mvInventory.SetActiveView(vInventoryList)
    End Sub
    Protected Sub ClearAddAssetForm()
        tbAssetName.Text = ""
        tbDescription.Text = ""

        tbUniqueRef.Text = ""
        listSubjects.ClearSelection()
        listTypes.ClearSelection()
        listFormats.ClearSelection()
    End Sub
    Protected Sub ClearEditAssetForm()
        lblAssetID.Text = ""
        tbAssetNameEdit.Text = ""
        tbDescriptionEdit.Text = ""
        'tbIAOEdit.Text = ""
        tbUniqueEdit.Text = ""
        listSubjects.ClearSelection()
        listTypes.ClearSelection()
        listFormats.ClearSelection()
    End Sub

    Private Sub lbtInsertAsset_Click(sender As Object, e As EventArgs) Handles lbtInsertAsset.Click
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        Dim nAssetID As Integer
        Try
            'add the data asset and get it's id:
            nAssetID = taq.DataAssetInventory_Insert(Session("UserOrganisationID"), tbAssetName.Text.ToString(), tbDescription.Text.ToString(), HiddenField1.Value, tbUniqueRef.Text.ToString(), ddPrivacyStatus.SelectedValue)
            If nAssetID = -10 Then
                lblModalHeading.Text = "Asset Name Already Exists"
                lblModalText.Text = "An asset with that name already exists in your inventory."
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalWhoops", "<script>$('#modalMessage').modal('show');</script>")
                'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalWhoops", "$('#modalMessage').modal('show');", True)
                Exit Sub
            ElseIf nAssetID = -11 Then
                lblModalHeading.Text = "Unique Identifier Already Exists"
                lblModalText.Text = "An asset with that unique identifier already exists in your inventory."
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalWhoops", "<script>$('#modalMessage').modal('show');</script>")
                'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalWhoops", "$('#modalMessage').modal('show');", True)
                Exit Sub
            End If
            'update the contact group with the asset id:
            If Session("DAContactGroupID") > 0 Then
                taq.isp_DataAssetContactGroups_UpdateAssetID(nAssetID, Session("DAContactGroupID"))
            End If
            'update the filegroup with the asset id:
            If Not Session("AssetFileGroupID") = 0 Then
                Dim taq2 As New ispdatasetTableAdapters.QueriesTableAdapter
                taq2.FileGroups_UpdateID(nAssetID, Session("AssetFileGroupID"))
            End If
            'now add sources:
            Dim taDASrc As New ispdatasetTableAdapters.isp_DataAssetFormatTableAdapter
            For Each li As ListItem In listFormats.Items
                If li.Selected Then
                    taDASrc.Insert(nAssetID, li.Value)
                End If
            Next
            'now add subjects:
            Dim taDASub As New ispdatasetTableAdapters.isp_DataAssetSubjectTableAdapter
            For Each li As ListItem In listSubjects.Items
                If li.Selected Then
                    taDASub.Insert(nAssetID, li.Value)
                End If
            Next
            'now add types:
            Dim taDAT As New ispdatasetTableAdapters.isp_DataAssetTypeTableAdapter
            For Each li As ListItem In listTypes.Items
                If li.Selected Then
                    taDAT.Insert(nAssetID, li.Value)
                End If
            Next
            'now add pid items:
            Dim taPID As New ispdatasetTableAdapters.isp_DataAssetPIDItemsTableAdapter
            For Each li As ListItem In listPersonalItems.Items
                If li.Selected Then
                    taPID.Insert(nAssetID, li.Value)
                End If
            Next
            For Each li As ListItem In listPersonalSensitiveItems.Items
                If li.Selected Then
                    taPID.Insert(nAssetID, li.Value)
                End If
            Next
            lblModalHeading.Text = "Asset Added"
            lblModalText.Text = "<p>You have successfully added the asset <b>" & tbAssetName.Text & "</b> to your organisation inventory.</p><p>You will be able to choose this asset when setting up data flows and other organisations will be able to submit requests for data flows from it.</p>"
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalRequest", "<script>$('#modalMessage').modal('show');</script>")
            'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalRequest", "$('#modalMessage').modal('show');", True)
        Catch ex As Exception
            lblModalHeading.Text = "Whoops! Something went wrong..."
            lblModalText.Text = "Computer says: " & ex.Message
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalWhoops", "<script>$('#modalMessage').modal('show');</script>")
            'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalWhoops", "$('#modalMessage').modal('show');", True)
        End Try
        ClearAddAssetForm()
        'gvDataInventory.DataBind()
        bsgvDataInventory.DataBind()
        mvInventory.SetActiveView(vInventoryList)
    End Sub



    'Private Sub gvDataInventory_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDataInventory.RowCommand
    '    If e.CommandName = "Select" Then
    '        Dim nDataAssetID As Integer = e.CommandArgument

    '    End If
    'End Sub




    Private Sub lbtUpdateAsset_Click(sender As Object, e As EventArgs) Handles lbtUpdateAsset.Click
        Dim sTypesCSV As String = ""
        Dim sSubjectsCSV As String = ""
        Dim sFormatsCSV As String = ""
        Dim sPIDItemsCSV As String = ""
        'Go through list boxes and populate CSV strings:
        For Each li As ListItem In listTypesEdit.Items
            If li.Selected Then
                sTypesCSV = sTypesCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listSubjectsEdit.Items
            If li.Selected Then
                sSubjectsCSV = sSubjectsCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listFormatsEdit.Items
            If li.Selected Then
                sFormatsCSV = sFormatsCSV + li.Value.ToString() + ", "
            End If
        Next
        'Go through PID list boxes and populate CSV strings:
        For Each li As ListItem In listPersonalItemsEdit.Items
            If li.Selected Then
                sPIDItemsCSV = sPIDItemsCSV + li.Value.ToString() + ", "
            End If
        Next
        For Each li As ListItem In listPersonalSensitiveItemsEdit.Items
            If li.Selected Then
                sPIDItemsCSV = sPIDItemsCSV + li.Value.ToString() + ", "
            End If
        Next
        'Trim the trailing , from the CSV string:
        If sTypesCSV.Length > 2 Then
            sTypesCSV = sTypesCSV.Substring(0, sTypesCSV.Length - 2)
        End If
        If sSubjectsCSV.Length > 2 Then
            sSubjectsCSV = sSubjectsCSV.Substring(0, sSubjectsCSV.Length - 2)
        End If
        If sFormatsCSV.Length > 2 Then
            sFormatsCSV = sFormatsCSV.Substring(0, sFormatsCSV.Length - 2)
        End If
        If sPIDItemsCSV.Length > 2 Then
            sPIDItemsCSV = sPIDItemsCSV.Substring(0, sPIDItemsCSV.Length - 2)
        End If
        'Run the update query (should really handle errors here):
        Dim taQ As New ispdatasetTableAdapters.QueriesTableAdapter
        taQ.DataAsset_Update(Session("EditAssetID"), tbAssetNameEdit.Text, tbDescriptionEdit.Text, "", tbUniqueEdit.Text, sTypesCSV, sSubjectsCSV, sFormatsCSV, ddPrivacyStatusEdit.SelectedValue, sPIDItemsCSV)
        bsgvDataInventory.DataBind()
        Me.mvInventory.SetActiveView(vInventoryList)
    End Sub

    Private Sub lbtConfirm_Click(sender As Object, e As EventArgs) Handles lbtConfirm.Click
        Dim nAssetID As Integer = hfAssetID.Value
        Dim taQ As New ispdatasetTableAdapters.QueriesTableAdapter
        taQ.DataAsset_Archive(Session("UserEmail"), tbReason.Text, nAssetID)
        bsgvDataInventory.DataBind()
    End Sub

    Private Sub lbtContactAdd_Click(sender As Object, e As EventArgs) Handles lbtContactAdd.Click, lbtAddContactEdit.Click
        tbContactName.Text = ""
        tbContactEmail.Text = ""
        tbRole.Text = ""
        tbPhoneNumber.Text = ""
        cbIsIAO.Checked = False
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalAddContact", "<script>$('#modalAddcontact').modal('show');</script>")
        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalAddContact", "$('#modalAddcontact').modal('show');", True)
    End Sub

    Private Sub lbtAddConfirm_Click(sender As Object, e As EventArgs) Handles lbtAddConfirm.Click
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        Dim nAssetID As Integer = 0

        nAssetID = Session("EditAssetID")

        If Session("DAContactGroupID") <= 0 Then
            Session("DAContactGroupID") = taq.isp_DataAssetContactGroups_Insert()
            If nAssetID > 0 Then
                taq.isp_DataAssetContactGroups_UpdateAssetID(nAssetID, Session("DAContactGroupID"))
            End If
        End If
        Dim nAdded As Integer = taq.DataAssetContact_Add(Session("DAContactGroupID"), tbContactName.Text, tbContactEmail.Text, tbRole.Text, cbIsIAO.Checked, tbPhoneNumber.Text)
        If nAdded = -10 Then
            Dim sDomains As String = taq.GetDomainsCSVShort
            lblModalHeading.Text = "Cannot add Contact - Invalid E-mail Domain"
            Dim sMess = "<p>The contact could not be added because their e-mail address was not from the approved list of ""safe"" domains.</p>"
            sMess = sMess + "<p>Valid e-mail addresses should end with one of the following: <b>" & sDomains & "</b>.</p>"
            lblModalText.Text = sMess
            Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalDomainError", "<script>$('#modalMessage').modal('show');</script>")
            'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "ShowModalDomainError", "$('#modalMessage').modal('show');", True)
            Exit Sub
        End If
        gvContactsEdit.DataBind()
        gvAssetContacts.DataBind()
    End Sub



    Protected Sub lbtEdit_ClickCommand(sender As Object, e As CommandEventArgs)
        Dim nAssetID As Integer = e.CommandArgument
        Session("EditAssetID") = nAssetID
        Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
        Session("DAContactGroupID") = taq.GetDAContactGroupID(nAssetID)
        Dim taAsset As New ispdatasetTableAdapters.isp_DataAssetInventoryTableAdapter
        Dim tAsset As New ispdataset.isp_DataAssetInventoryDataTable
        listFormatsEdit.DataBind()
        listSubjectsEdit.DataBind()
        listTypesEdit.DataBind()
        listPersonalItemsEdit.DataBind()
        listPersonalSensitiveItemsEdit.DataBind()
        gvContactsEdit.DataBind()
        rptFiles.DataBind()
        tAsset = taAsset.GetAssetByID(nAssetID)
        lblAssetID.Text = PadID(nAssetID)
        tbAssetNameEdit.Text = tAsset.First.DataAssetName
        tbDescriptionEdit.Text = tAsset.First.DataAssetDescription
        ddPrivacyStatusEdit.SelectedValue = tAsset.First.PrivacyStatusID
        dvPersonalEdit.CssClass = "form-group collapse"
        dvPersonalSensitiveEdit.CssClass = "form-group collapse"
        'tbIAOEdit.Text = tAsset.First.InformationAssetOwnerEmail
        tbUniqueEdit.Text = tAsset.First.UniqueReference
        Dim taFormats As New ispdatasetTableAdapters.isp_DataAssetFormatTableAdapter
        Dim tFormats As New ispdataset.isp_DataAssetFormatDataTable
        tFormats = taFormats.GetDataByAssetID(nAssetID)
        For Each r As DataRow In tFormats.Rows
            For Each li As ListItem In listFormatsEdit.Items
                If li.Value = r.Item("DataFormatID") Then
                    li.Selected = True
                End If
            Next
        Next
        Dim taSubjects As New ispdatasetTableAdapters.isp_DataAssetSubjectTableAdapter
        Dim tSubjects As New ispdataset.isp_DataAssetSubjectDataTable
        tSubjects = taSubjects.GetDataByAssetID(nAssetID)
        For Each r As DataRow In tSubjects.Rows
            For Each li As ListItem In listSubjectsEdit.Items
                If li.Value = r.Item("DataSubjectID") Then
                    li.Selected = True
                End If
            Next
        Next
        Dim taTypes As New ispdatasetTableAdapters.isp_DataAssetTypeTableAdapter
        Dim tTypes As New ispdataset.isp_DataAssetTypeDataTable
        tTypes = taTypes.GetDataByAssetID(nAssetID)
        For Each r As DataRow In tTypes.Rows
            If r.Item("DataTypeID") = 1 Then
                dvPersonalEdit.CssClass = "form-group collapse-in"
            End If
            If r.Item("DataTypeID") = 2 Then
                dvPersonalSensitiveEdit.CssClass = "form-group collapse-in"
            End If
            For Each li As ListItem In listTypesEdit.Items
                If li.Value = r.Item("DataTypeID") Then
                    li.Selected = True
                End If
            Next
        Next
        'now load PID items:
        Dim taPID As New ispdatasetTableAdapters.isp_DataAssetPIDItemsTableAdapter
        Dim tPIDs As New ispdataset.isp_DataAssetPIDItemsDataTable
        tPIDs = taPID.GetDataByAssetID(nAssetID)
        For Each r As DataRow In tPIDs.Rows
            For Each li As ListItem In listPersonalItemsEdit.Items
                If li.Value = r.Item("PIDItemID") Then
                    li.Selected = True
                End If
            Next
            For Each li As ListItem In listPersonalSensitiveItemsEdit.Items
                If li.Value = r.Item("PIDItemID") Then
                    li.Selected = True
                End If
            Next
        Next
        Me.mvInventory.SetActiveView(vEdit)
    End Sub
    Protected Sub lbtArchive_ClickCommand(sender As Object, e As CommandEventArgs)
        hfAssetID.Value = e.CommandArgument
        lblConfirmHeading.Text = "Archive Asset " & PadID(e.CommandArgument)
        Page.ClientScript.RegisterStartupScript(Me.GetType(), "ShowModalWhoops", "<script>$('#modalConfirm').modal('show');</script>")
    End Sub
    Protected Sub lbtUnarchive_ClickCommand(sender As Object, e As CommandEventArgs)
        Dim taQ As New ispdatasetTableAdapters.QueriesTableAdapter
        taQ.DataAsset_Unarchive(e.CommandArgument)
        'gvDataInventory.DataBind()
        bsgvDataInventory.DataBind()
    End Sub
    Protected Sub GridViewCustomToolbar_ToolbarItemClick(ByVal source As Object, ByVal e As BootstrapGridViewToolbarItemClickEventArgs)
        Select Case e.Item.Name
            Case "Export"
                Dim bsgv As BootstrapGridView = bsgvDataInventory
                Dim bEdVis As Boolean = bsgv.Columns("Edit").Visible
                Dim bArchVis As Boolean = bsgv.Columns("Archive").Visible
                bsgv.Columns("Edit").Visible = False
                bsgv.Columns("Archive").Visible = False
                bsgvDataInventoryExporter.WriteXlsxToResponse()
                bsgv.Columns("Edit").Visible = bEdVis
                bsgv.Columns("Archive").Visible = bArchVis
            Case Else
        End Select
    End Sub
    Protected Sub dsAssetFiles_Selected(sender As Object, e As ObjectDataSourceStatusEventArgs)
        If e.Exception Is Nothing Then
            Dim nRows As Integer = e.ReturnValue.Rows.Count
            If nRows > 0 Then
                trNoFiles.Visible = False
            Else
                trNoFiles.Visible = True
            End If
        End If
    End Sub
    Private Sub vAddAsset_Activate(sender As Object, e As EventArgs) Handles vAddAsset.Activate
        hfIncludeInactive.Value = 0
    End Sub

    Private Sub vEdit_Activate(sender As Object, e As EventArgs) Handles vEdit.Activate
        hfIncludeInactive.Value = 1
    End Sub

    Protected Sub lbtUpload_Click(sender As Object, e As EventArgs) Handles lbtUpload.Click
        Dim nUserID As Guid = Membership.GetUser().ProviderUserKey
        Dim taQ As New ispdatasetTableAdapters.QueriesTableAdapter
        Dim nFileGroupID As Integer = taQ.isp_FileGroup_Insert("assetfiles", Session("EditAssetID"))
        Dim fil As FileUpload = filAssetDocs
        If Not fil Is Nothing Then
            If fil.PostedFiles.Count > 0 Then
                Dim bShowWarning As Boolean = 0
                Me.lblModalText.Text = ""
                Dim nFileID As Nullable(Of Integer)
                Dim sFilename As String = ""
                For Each pFile As HttpPostedFile In fil.PostedFiles
                    'Dim sExtension As String = System.IO.Path.GetExtension(Me.filEvidence.PostedFile.FileName).ToLower()
                    sFilename = System.IO.Path.GetFileName(pFile.FileName)
                    Dim nMaxKB As Integer = 5000
                    If pFile.InputStream.Length > nMaxKB * 1024 Then
                        lblModalHeading.Text = "Asset document file too big"
                        Me.lblModalText.Text = Me.lblModalText.Text + "<p>" + sFilename + " is too big. Maximum file size is " + nMaxKB.ToString() + "K." + "</p>"
                        bShowWarning = True
                    Else
                        Dim size As Integer = pFile.ContentLength
                        Dim sContentType As String = pFile.ContentType
                        Dim fileData As Byte() = New Byte(size - 1) {}
                        pFile.InputStream.Read(fileData, 0, size)
                        nFileID = taQ.InsertFile(sFilename, sContentType, pFile.InputStream.Length / 1024, fileData, Session("UserOrganisationID"), Session("UserEmail"))
                        If nFileID > 0 Then
                            taQ.FileGroupFile_Insert(nFileGroupID, nFileID)
                        Else
                            lblModalHeading.Text = "Asset document file error"
                            Me.lblModalText.Text = Me.lblModalText.Text + "<p>" + sFilename + " failed to upload due to an unknown error. </p>"
                            bShowWarning = True
                        End If
                    End If
                Next
                If bShowWarning Then
                    Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgFileTooBig", "<script>$('#modalMessage').modal('show');</script>")
                End If
                Dim rpt As Repeater = rptFiles
                If Not rpt Is Nothing Then
                    rpt.DataBind()
                End If
            End If
        End If

    End Sub
    Protected Sub rptFiles_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptFiles.ItemCommand, rptAssetFilesAdd.ItemCommand
        If e.CommandName = "Delete" Then
            Dim taq As New ispdatasetTableAdapters.QueriesTableAdapter
            taq.File_Delete(CInt(e.CommandArgument))
            Dim rpt As Repeater = rptFiles
            If Not rpt Is Nothing Then
                rpt.DataBind()
            End If
        End If
    End Sub

    Private Sub lbtUploadAssetFilesAdd_Click(sender As Object, e As EventArgs) Handles lbtUploadAssetFilesAdd.Click
        Dim nUserID As Guid = Membership.GetUser().ProviderUserKey
        Dim taQ As New ispdatasetTableAdapters.QueriesTableAdapter
        Dim nFileGroupID As Integer = Session("AssetFileGroupID")
        If nFileGroupID = 0 Then
            nFileGroupID = taQ.isp_FileGroup_Insert("assetfiles", 0)
            Session("AssetFileGroupID") = nFileGroupID
        End If
        Dim fil As FileUpload = filAssetFileAdd
        If Not fil Is Nothing Then
            If fil.PostedFiles.Count > 0 Then
                Dim bShowWarning As Boolean = 0
                Me.lblModalText.Text = ""
                Dim nFileID As Nullable(Of Integer)
                Dim sFilename As String = ""
                For Each pFile As HttpPostedFile In fil.PostedFiles
                    'Dim sExtension As String = System.IO.Path.GetExtension(Me.filEvidence.PostedFile.FileName).ToLower()
                    sFilename = System.IO.Path.GetFileName(pFile.FileName)
                    Dim nMaxKB As Integer = 5000
                    If pFile.InputStream.Length > nMaxKB * 1024 Then
                        lblModalHeading.Text = "Asset document file too big"
                        Me.lblModalText.Text = Me.lblModalText.Text + "<p>" + sFilename + " is too big. Maximum file size is " + nMaxKB.ToString() + "K." + "</p>"
                        bShowWarning = True
                    Else
                        Dim size As Integer = pFile.ContentLength
                        Dim sContentType As String = pFile.ContentType
                        Dim fileData As Byte() = New Byte(size - 1) {}
                        pFile.InputStream.Read(fileData, 0, size)
                        nFileID = taQ.InsertFile(sFilename, sContentType, pFile.InputStream.Length / 1024, fileData, Session("UserOrganisationID"), Session("UserEmail"))
                        If nFileID > 0 Then
                            taQ.FileGroupFile_Insert(nFileGroupID, nFileID)
                        Else
                            lblModalHeading.Text = "Asset document file error"
                            Me.lblModalText.Text = Me.lblModalText.Text + "<p>" + sFilename + " failed to upload due to an unknown error. </p>"
                            bShowWarning = True
                        End If
                    End If
                Next
                If bShowWarning Then
                    Page.ClientScript.RegisterStartupScript(Me.GetType(), "msgFileTooBig", "<script>$('#modalMessage').modal('show');</script>")
                End If
                Dim rpt As Repeater = rptAssetFilesAdd
                If Not rpt Is Nothing Then
                    rpt.DataBind()
                End If
            End If
        End If
    End Sub

    Private Sub dsAssetFilesAdd_Selected(sender As Object, e As ObjectDataSourceStatusEventArgs) Handles dsAssetFilesAdd.Selected
        If e.Exception Is Nothing Then
            Dim nRows As Integer = e.ReturnValue.Rows.Count
            If nRows > 0 Then
                trNoFilesAdd.Visible = False
            Else
                trNoFilesAdd.Visible = True
            End If
        End If
    End Sub
End Class