<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="org_mou.aspx.vb" Inherits="InformationSharingPortal.org_mou" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Data Protection Impact Assessment Tool MoU</title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:ObjectDataSource ID="dsTierZero" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetActiveForOrganisation" TypeName="InformationSharingPortal.ispdatasetTableAdapters.isp_TierZeroSignaturesTableAdapter">
                                    <SelectParameters>
                                        <asp:QueryStringParameter Name="OrganisationID" QueryStringField="OrganisationID" Type="Int32" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
   
        <ul class="list-group">
                                    <li id="Li1" class="list-group-item" style="background-color: #e4e4e4" runat="server">
                                        <table><tr>
                                        <td style="width:80px"><img src="Images/ISG_logo_med.png"  alt="" /></td><td class="col-sm-11"><h3> Data Protection Impact Assessment Tool Usage Agreement (MoU) - <asp:Label ID="lblOrgName" runat="server" Text="Organisation name"></asp:Label></h3></td>
                                        </tr></table>
                                    </li>
            <li class="list-group-item">
                 <asp:Literal ID="litMOUText" runat="server"></asp:Literal>
            </li>
                                    <asp:FormView ID="fvUsageAgreement" runat="server" DataKeyNames="TierZeroID" DataSourceID="dsTierZero" RenderOuterTable="False">
                                        <ItemTemplate>
                                            <li class="list-group-item">Signed:<asp:Label ID="SignedDateLabel" runat="server" Text='<%# Eval("SignedDate")%>' Font-Bold="True" />
                                            </li>
                                            <li class="list-group-item">By:
                            <asp:Label ID="SignedByLabel" runat="server" Text='<%# Eval("SignedBy")%>' Font-Bold="True" />
                                            </li>
                                            <li class="list-group-item">Role:
                            <asp:Label ID="RoleIDLabel" runat="server" Text='<%# Eval("Role")%>' Font-Bold="True" />
                                            </li>
                                            <div id="divOnBehalf" runat="server" visible='<%# Eval("OnBehalfOf").ToString.Length > 0%>'>
                                                <li class="list-group-item">On Behalf Of:
                            <asp:Label ID="OnBehalfOfLabel" runat="server" Text='<%# Eval("OnBehalfOf")%>' Font-Bold="True" />
                                                </li>
                                                <li class="list-group-item">Role:
                            <asp:Label ID="OnBehalfOfRoleIDLabel" runat="server" Text='<%# Eval("BehalfOfRole")%>' Font-Bold="True" />
                                                </li>
                                            </div>
                                           

                                            
                                             
                                        </ItemTemplate>
                                        
                                    </asp:FormView>
                                   
                                </ul>
    </div>
    </form>
</body>
</html>
