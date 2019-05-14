<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="isg_privacy.aspx.vb" Inherits="InformationSharingPortal.isg_privacy" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Data Protection Impact Assessment Tool Privacy and Cookies</title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <ul class="list-group">
                                    <li id="Li1" class="list-group-item" style="background-color: #e4e4e4" runat="server">
                                        <table><tr>
                                        <td style="width:80px"><img src="Images/ISG_logo_med.png"  alt="" /></td><td class="col-sm-11"><h3> Data Protection Impact Assessment Tool Privacy Statement</h3></td>
                                        </tr></table>
                                    </li>
            <li class="list-group-item">
                 <asp:Literal ID="litPrivacyText" runat="server"></asp:Literal>
            </li>
                                    
                                   
                                </ul>
    </div>
    </form>
</body>
</html>
