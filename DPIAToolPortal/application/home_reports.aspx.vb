Imports DevExpress.XtraReports.UI

Public Class home_reports
	Inherits System.Web.UI.Page

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("orgLicenceType") = "Free, limited licence" Then
            mvReports.SetActiveView(vNoAdminGroup)
            'lbtExportDataToExcel.Visible = False
            'lbtCloseReport.Visible = False
            Exit Sub
        End If
    End Sub



    Private Sub lbtDataAssetsReport_Click(sender As Object, e As EventArgs) Handles lbtDataAssetsReport.Click
        Dim taRep As New ReportDataTableAdapters.isp_DataAssetInventoryTableAdapter
        Dim tRep As New ReportData.isp_DataAssetInventoryDataTable
        tRep = taRep.GetData(Session("UserOrganisationID"), 1)
        Dim DFs_Export As New DataSet("DPIA Data Asset Report Export")
        tRep.TableName = "Data Assets"
        DFs_Export.Tables.Add(tRep)
        Dim sDate As String = Date.Now.Day.ToString() & "-" & Date.Now.Month.ToString() & "-" & Date.Now.Year.ToString()
        OpenXMLExport.ExportToExcel(DFs_Export, "DPIA Data Asset Report Export (" + sDate + ").xlsx", Page.Response)
    End Sub

    Private Sub lbtSharingPartnersList_Click(sender As Object, e As EventArgs) Handles lbtSharingPartnersList.Click
        Dim taRep As New ReportDataTableAdapters.SharingPartnersTableAdapter
        Dim tRep As New ReportData.SharingPartnersDataTable
        tRep = taRep.GetData(Session("UserOrganisationID"))
        Dim DFs_Export As New DataSet("DPIA Sharing Partners Report Export")
        tRep.TableName = "Sharing Partners"
        DFs_Export.Tables.Add(tRep)
        Dim sDate As String = Date.Now.Day.ToString() & "-" & Date.Now.Month.ToString() & "-" & Date.Now.Year.ToString()
        OpenXMLExport.ExportToExcel(DFs_Export, "DPIA Sharing Partners Report Export (" + sDate + ").xlsx", Page.Response)
    End Sub

    Private Sub lbtDataFlows_Click(sender As Object, e As EventArgs) Handles lbtDataFlows.Click
        Dim DFs_Export As New DataSet("DPIA DataFlow Export")
        Dim taDF As New DataFlowDetailTableAdapters.DataFlowDetail_GetFilteredTableAdapter
        Dim tDF As New DataFlowDetail.DataFlowDetail_GetFilteredDataTable
        tDF = taDF.GetData(True, Session("UserOrganisationID"), True, False, False, "", 0, 0, 0)
        tDF.TableName = "DPIA DataFlows"
        DFs_Export.Tables.Add(tDF)
        Dim sDate As String = Date.Now.Day.ToString() & "-" & Date.Now.Month.ToString() & "-" & Date.Now.Year.ToString()
        OpenXMLExport.ExportToExcel(DFs_Export, "DPIA DataFlow Export (" + sDate + ").xlsx", Page.Response)
    End Sub
End Class