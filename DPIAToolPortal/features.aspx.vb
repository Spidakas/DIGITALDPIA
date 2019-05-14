Public Class features
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub
    Protected Function getContentCSSOdd(ByVal sImageURL) As String
        Dim sCss As String = "content col-xs-12 col-md-4"
        If sImageURL.ToString.Length = 0 Then
            sCss = "content col-lg-12"
        End If
        Return sCss
    End Function
    Protected Function getContentCSSEven(ByVal sImageURL) As String
        Dim sCss As String = "content col-md-push-8 col-sm-push-0 col-xs-push-0 col-xs-12 col-md-4"
        If sImageURL.ToString.Length = 0 Then
            sCss = "content col-lg-12"
        End If
        Return sCss
    End Function
End Class