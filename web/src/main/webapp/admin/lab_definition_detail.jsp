<%
String admin_section = "Manage Lab Definitions";
String admin_subsection = "Lab Definitions";
String sub_section = "";
String userlogin = "u";
String role = "r";
String serverName = request.getServerName();
String admin_protocol = "http";
int roleid = -1;


String authcode = flinn.util.CookieHandler.getCookie("authcode", request);
if (authcode == null || authcode.equals("")){ 
	response.sendRedirect(admin_protocol+"://"+serverName+"/sample");  
	return;	
}
else {
	flinn.dao.DaoAppManager dm = new flinn.dao.DaoAppManager();
	flinn.beans.response.ResponseSessionContainerBean userSession = dm.getSession(authcode, request);
	
	if (userSession != null){
		userlogin = userSession.getUser().getLogin();
		
		flinn.beans.AppUserRoleBean[] ar = userSession.getUser().getRoles();
		flinn.beans.AppUserRoleBean userRole = (flinn.beans.AppUserRoleBean)ar[0];
		role = userRole.getApprole();
		roleid = userRole.getApproleid();
		
		if (roleid != 1){ //Not a super admin
			if (roleid == 2) { //Force Facility Admins to index page
				response.sendRedirect("index.jsp");
				return;	
			}
			else { //Kick all non admins out
				response.sendRedirect(admin_protocol+"://"+serverName+"/sample");
				return;
			}
		}
	}
	else{
		response.sendRedirect(admin_protocol+"://"+serverName+"/sample");
		return;	
	}
}

Boolean invalid = false;    // Whether or not to show invalid users
//if (is_admin() && $HTTP_GET_VARS['invalid'] == 'y') $invalid = true;
%>
<jsp:include page="include/header.jsp">
	<jsp:param name="admin_section" value="<%=admin_section%>" />
	<jsp:param name="admin_subsection" value="<%=admin_subsection%>" />
	<jsp:param name="sub_section" value="<%=sub_section%>" />
</jsp:include>
	<td bgcolor="#E6E5E3" width="200" colspan="2" valign="top">
<jsp:include page="include/nav.jsp">
	<jsp:param name="admin_section" value="<%=admin_section%>" />
	<jsp:param name="admin_subsection" value="<%=admin_subsection%>" />
	<jsp:param name="sub_section" value="<%=sub_section%>" />
	<jsp:param name="role" value="<%=role%>" />	
</jsp:include>
	</td>
	<td valign="top">
<div class="pageHolder">
<jsp:include page="include/lab_definition_detail.jsp" />
</div>
	</td>
<jsp:include page="include/footer.jsp">
	<jsp:param name="userlogin" value="<%=userlogin%>" />
	<jsp:param name="role" value="<%=role%>" />
</jsp:include>
