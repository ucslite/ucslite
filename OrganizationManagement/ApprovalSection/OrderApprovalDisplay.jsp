
<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf" %>

<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<fmt:message bundle="${storeText}" key="MYACCOUNT_ORDER_APPROVAL" var="contentPageName" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>
<c:set var="pageCategory" value="MyAccount" scope="request"/>

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
	xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><fmt:message key="MYACCOUNT_ORDER_APPROVAL" bundle="${storeText}"/></title>
		
		<!--Main Stylesheet for browser -->
		<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${vfileStylesheet}"/>" type="text/css"/>

		<!-- Include script files -->
		<%@ include file="../../Common/CommonJSToInclude.jspf"%>
		<script type="text/javascript" src="${staticAssetContextRoot}/Widgets_701/com.ibm.commerce.store.widgets.OrderApprovalList/javascript/OrderApprovalList.js"></script>
	</head>
	
	<body>
		<!-- Page Start -->
		<div id="page" class="nonRWDPageB">
			<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>	
			
			<!-- Header Widget -->
			<div id="headerWrapper">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>

			<!-- Main Content Start -->
			<div id="contentWrapper">
				<div id="content" role="main">
					<div class="rowContainer" id="container_reqList_detail">
						<div class="row margin-true">
							<!-- breadcrumb -->
							<%out.flush();%>
								<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">  
									<c:param name="pageGroup" value="Content" />
									<c:param name="doNotCacheForMyAccount" value="true"/>
								</c:import>
							<%out.flush();%>
							<div class="col12"></div>
						</div>
										
						<div class="row margin-true">
							<!-- Left Nav -->
							<div class="col4 acol12 ccol3">
								<%out.flush();%>
								<%-- 
									Since this is OrderApprovalDisplay page, OrderApprovalList widget included below will fetch the count. 
									Ignore fetching pending approval count in MyAccountNavigation.jsp 
								--%>
								<c:set var="fetchPendingOrderApprovalCount" value="false" scope="request"/>
								<c:set var="updateCountInJS" value="true" scope="request"/>
								<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.MyAccountNavigation/MyAccountNavigation.jsp"/>
								<%out.flush();%>	
							</div>
							
							<!-- Content area -->
							<div class="col8 acol12 ccol9 right">	
								<div id="mainContent_OrderApprovalList" role="main" aria-label="<fmt:message key="MYACCOUNT_APPROVAL_REQUESTS" bundle="${storeText}"/>" aria-expanded="true">	
									<div id="OrderAporovalPageHeading">						
										<h1><fmt:message key="MYACCOUNT_ORDER_APPROVAL" bundle="${storeText}"/></h1>
									</div>	
									<%out.flush();%>
									<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrderApprovalList/OrderApprovalList.jsp">			
										<c:param name="storeId" value="${storeId}" />
										<c:param name="catalogId" value="${catalogId}" />
										<c:param name="langId" value="${langId}" />
										<c:param name="approvalStatus" value="0"/> <%-- By default display Pending approvals --%>
									</c:import>			
									<%out.flush();%>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>				
			<!-- Main Content End -->

			<!-- Footer Widget -->
			<div id="footerWrapper">
				<%out.flush();%>
				<c:import url="${env_jspStoreDir}Widgets/Footer/Footer.jsp"/>
				<%out.flush();%>
			</div>
		
		</div>
		<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
		<%@ include file="../../Common/JSPFExtToInclude.jspf"%>
	</body>
</html>
