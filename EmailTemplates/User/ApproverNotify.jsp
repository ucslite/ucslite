<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!doctype HTML>

<%-- 
  *****
  * After a new user or buyer organization registers, and an order requiring approval is placed by a buyer this email will be sent to the approver. 
  * This email JSP page informs the approver about user or buyer organization registration and order approvals.
  *****
--%>

<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf"%>
<%@ page import="com.ibm.commerce.ubf.registry.BusinessFlowManager" %>
<%@ page import="com.ibm.commerce.ubf.registry.BusinessFlow" %>
<%@ page import="com.ibm.commerce.ubf.registry.BusinessFlowType" %>
<%@ page import="com.ibm.commerce.ubf.util.BusinessFlowConstants" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>

<%
	String orgName = ""; 
	String logonId = ""; 
	String firstName = ""; 
	String orderId = "";
	
	JSPHelper jsphelper=new JSPHelper(request);
	
	Long lngFlowId = new Long(jsphelper.getParameter(BusinessFlowConstants.EC_FLOWID));
	BusinessFlow flow= BusinessFlowManager.getInstance().getFlow(lngFlowId);
	try {
		BusinessFlowType bft = flow.getBusinessFlowType();
		if (bft != null) {
			String strFlowId = bft.getIdentifier();
			request.setAttribute("approvalIdentifier", strFlowId);
			if (strFlowId.equals("OrderProcess")){
				orderId = jsphelper.getParameter("orderId");
				request.setAttribute("orderId", orderId);
			} else if (strFlowId.equals("ResellerOrgEntityRegistrationAdd")){
				orgName = jsphelper.getParameter("org_orgEntityName");
				logonId = jsphelper.getParameter("usr_logonId");
				firstName = jsphelper.getParameter("firstName");		
				request.setAttribute("orgName", orgName);
				request.setAttribute("logonId", logonId);
				request.setAttribute("firstName", firstName);
			} else if (strFlowId.equals("UserRegistrationAdd")){
				orgName = jsphelper.getParameter("ancestorOrgs");
				logonId = jsphelper.getParameter("logonId");
				firstName = jsphelper.getParameter("firstName");
				request.setAttribute("orgName", orgName);
				request.setAttribute("logonId", logonId);
				request.setAttribute("firstName", firstName);
			} else {
				// do nothing
			}
		}
	} catch (javax.ejb.ObjectNotFoundException nfe ) {
		//out.println(" Exception: " + nfe);	// Did not find description in desired language.
	}
	
%>

<c:set value="${pageContext.request.scheme}://${pageContext.request.serverName}${portUsed}" var="hostPath" />
<c:set value="${jspStoreImgDir}" var="fullJspStoreImgDir" />
<c:if test="${!(fn:contains(fullJspStoreImgDir, '://'))}">
	<c:set value="${hostPath}${jspStoreImgDir}" var="fullJspStoreImgDir" />
</c:if>

<!-- BEGIN ApproverNotify.jsp -->
<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#" xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	
	<head>
		<title>
			<fmt:message bundle="${storeText}" key="EMAIL_PAGE_TITLE_1">
				<fmt:param value="${storeName}"/>
			</fmt:message>
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>

	<body text="#333333" style="background-color:#fff">
		<p>&nbsp;</p>
		<table border="0" align="center" cellpadding="6" cellspacing="6">
			<tbody>
				<tr>
				  <td align="left" valign="top" style="font-family: arial, Verdana, sans-serif; font-size: 11px; color:#666">
					<p style="margin-bottom:0px;">	
						<fmt:message bundle="${storeText}" key="EMAIL_DISCLAIMER_1_MESSAGE">
							<fmt:param value="${storeName}"/>
						</fmt:message>
					</p>
					<p style="margin-top:0px;">
						<fmt:message bundle="${storeText}" key="EMAIL_DISCLAIMER_2_MESSAGE">
							<fmt:param value="${storeName}"/>
						</fmt:message>
					</p>
					</td>
				</tr>
			</tbody>
		</table>
		<table border="0" align="center" cellpadding="0" cellspacing="0" style="background-color:#fff; width:100%; max-width:690px; ">
			<tr>
				<td height="10" align="center" valign="top">
					<img src="${fullJspStoreImgDir}${env_vfileColor}email_template/top_border.jpg" height="10" border="0" alt="top border" style="display:block; width:100%">
				</td>
			</tr>
			<tr>
				<td align="center" valign="top" style="min-height:300px; border-color:#ccc; border-width:0px 1px 0px 1px; border-style:solid">
					 <table border="0" align="center" cellpadding="0" cellspacing="0" >
						<tr>
							<td height="96" align="left" valign="top">
						      <!-- Insert logo and optional social media links in this table row -->
						      <a href="#"><img src="${fullJspStoreImgDir}${env_vfileColor}email_template/Aurora_logo.jpg" width="219" height="96" alt="Aurora logo" border="0" style="display:block"/></a>
						    </td>
						</tr>
						<tr>
							<td align="center" valign="top" style="min-height:300px; padding: 0px 20px 0px 20px;">
									<table border="0" cellspacing="5" cellpadding="5" style="width: 100%;">
										<tbody>
											<c:choose>
												 <c:when test="${approvalIdentifier eq 'UserRegistrationAdd'}">
													<tr>
													<td align="left" valign="top" style="font-family: arial, Verdana, sans-serif; font-size:21px; color:#333333">
														<fmt:message bundle="${storeText}" key="EMAIL_DEAR_ADMINISTRATOR"/>
													</td>
													</tr>
												 </c:when>
												 <c:when test="${approvalIdentifier eq 'OrderProcess'}">
													<tr>
													<td align="left" valign="top" style="font-family: arial, Verdana, sans-serif; font-size:21px; color:#333333">
														<fmt:message bundle="${storeText}" key="EMAIL_DEAR_APPROVER"/>
													</td>
													</tr>
												 </c:when>
												 <c:otherwise>
													<!-- empty sub-heading -->
												 </c:otherwise>
											</c:choose>
										<tr>
										  <td align="left" valign="top" style="font-family: arial, Verdana, sans-serif; font-size:14px; color:#333333">
										  <!-- START Message body 
										   TO DO: Need to account for this type: || approvalIdentifier eq 'ResellerUserRegistrationAdd'
										  -->
											<c:choose>
												 <c:when test="${approvalIdentifier eq 'ResellerOrgEntityRegistrationAdd'}">
													<fmt:message bundle="${storeText}" key="EMAIL_APPROVAL_BUYERREG_MESSAGE">
														<fmt:param value="${orgName}"/>
													</fmt:message>
												 </c:when>
												 <c:when test="${approvalIdentifier eq 'UserRegistrationAdd'}">
													<fmt:message bundle="${storeText}" key="EMAIL_APPROVAL_USERREG_MESSAGE">
														<fmt:param value="${logonId}"/>
														<fmt:param value="${orgName}"/>
														<fmt:param value="${storeName}"/>
													</fmt:message>
												 </c:when>
												 <c:when test="${approvalIdentifier eq 'OrderProcess'}">
													<fmt:message bundle="${storeText}" key="EMAIL_APPROVAL_ALT_ORDER_MESSAGE">
														<fmt:param value="${orderId}"/>
														<fmt:param value="${storeName}"/>
													</fmt:message>
												 </c:when>
												 <c:otherwise>
													<fmt:message bundle="${storeText}" key="EMAIL_APPROVAL_GENERIC_MESSAGE"/>
												 </c:otherwise>
											</c:choose>
										   <!-- END Message body -->
										  </td>
										</tr>
									  </tbody>
									</table>
							</td>
						</tr>
						<tr>
							<td height="168" valign="top" align="center">
								<!-- Featured items table -->
								<table height="168" border="0" align="center" cellpadding="0" cellspacing="0">
									<tr>
										<td style="padding-left: 20px; padding-right: 20px; padding-bottom: 10px;">
										  <a href="#" style="display:inline-block;"><img src="${fullJspStoreImgDir}${env_vfileColor}email_template/feature_01.jpg" width="213" height="168" alt="Feature 1" border="0" style="display:block"></a>
										  <a href="#" style="display:inline-block;"><img src="${fullJspStoreImgDir}${env_vfileColor}email_template/feature_02.jpg" width="210" height="168" alt="Feature 2" border="0" style="display:block"></a>
										  <a href="#" style="display:inline-block;"><img src="${fullJspStoreImgDir}${env_vfileColor}email_template/feature_03.jpg" width="213" height="168" alt="Feature 3" border="0" style="display:block"></a>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td height="30" valign="top">
					<!-- Footer -->
					<img src="${fullJspStoreImgDir}${env_vfileColor}email_template/footer.jpg" height="30" alt="Footer" border="0" style="display:block; width:100%"/>
				</td>
			</tr>		
		</table>  
		<table border="0" align="center" cellpadding="6" cellspacing="6">
		  <tbody>
			<tr>
			  <td align="left" valign="top" style="font-family: arial, Verdana, sans-serif; font-size: 11px; color:#666">
				<!-- Legal info. -->
				<fmt:message bundle="${storeText}" key="EMAIL_LEGAL_INFO_MESSAGE">
					<fmt:param value="${storeName}"/>
				</fmt:message>
			  </td>
			</tr>
		  </tbody>
		</table>
		<!-- Please leave spacers at bottom -->
		<p>&nbsp;</p>
		<p>&nbsp;</p>
	</body>
</html>

