Public Class News
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Not Page.Request.Item("ItemID") Is Nothing Then
                mvNews.SetActiveView(vNewsDetail)
            Else
                mvNews.SetActiveView(vNewsList)
            End If
        End If
    End Sub

End Class