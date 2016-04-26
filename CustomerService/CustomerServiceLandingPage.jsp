<%@ include file="../Common/EnvironmentSetup.jspf"%>
<%@ include file="../Common/nocache.jspf"%>

<fmt:message bundle="${storeText}" key="CUSTOMER_SERVICE" var="contentPageName" scope="request"/>

<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!-- BEGIN CustomerServiceLandingPage.jsp -->
<flow:ifEnabled feature="on-behalf-of-csr">
<html xmlns="http://www.w3.org/1999/xhtml"
xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<!-- Mimic Internet Explorer 7 -->
		<link href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${vfileStylesheetprint}"/>" type="text/css" media="print"/>
		<title><fmt:message bundle="${storeText}" key="CUSTOMER_SERVICE"/></title>
		<%@ include file="../Common/CommonJSToInclude.jspf"%>
		<script type="text/javascript" src="${jsAssetsDir}javascript/UserArea/AddressHelper.js"></script>
		<script type="text/javascript" src="${staticAssetContextRoot}${env_siteWidgetsDir}Common/javascript/WidgetCommon.js"></script>
		<script type="text/javascript" src="${staticAssetContextRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.RegisteredCustomers/javascript/RegisteredCustomers.js"></script>
		<script type="text/javascript" src="${staticAssetContextRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.FindOrders/javascript/FindByCSRUtilities.js"></script>
		<script type="text/javascript" src="${staticAssetContextRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.FindOrders/javascript/FindOrders.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/ServicesDeclaration.js"/></script>
	</head>

	<body>
		<!-- Page Start -->
		<div id="page">
			<%@ include file="../Common/CommonJSPFToInclude.jspf"%>
			<div id="wrapper" class="ucp_active">
				<div class="highlight">
					<!-- Header Widget -->
					<div id="headerWrapper">
						<%out.flush();%> <c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" /> <%out.flush();%>
					</div>
				</div>
			</div>
			<!-- Main Content Start -->
			<div id="contentWrapper">
				<div id="content" role="main">
					<div class="rowContainer" id="container_orgUserList_detail">
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
									<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.CustomerServiceNavigation/CustomerServiceNavigation.jsp"/> 
								<%out.flush();%>	
							</div>
							
							<!-- Content area -->
							<div class="col8 acol12 ccol9 right" id="registeredCustomersSearchAndResultsDiv">
								<div id="RegisteredCustomersPageHeading" tabindex="0">	
									<h1 style="padding: 0px 0px;"><fmt:message key="FIND_CUSTOMERS_CSR" bundle="${storeText}"/></h1>
									<span id="errorMessage_section" style="display:none"></span>
								</div>
								<div id="RegisteredCustomersSearch_table" class="listTable findOrderlistTable" role="grid" aria-labelledby="registeredCustomerSearchResults_table_summary" tabindex="0">
									<%-- This is the hidden table summary used for Accessibility TODO --%>
									<div id="registeredCustomerSearchResults_table_summary" class="nodisplay" aria-hidden="true">
										<fmt:message key="REGISTERED_CUSTOMER_SEARCH_RESULTS_TABLE_SUMMARY" bundle="${storeText}"/>
									</div>
									<div class="row">
										<div class="col12">
											<%out.flush();%> 
											<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.RegisteredCustomers/RegisteredCustomersSearch.jsp"/>
											<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.RegisteredCustomers/RegisteredCustomersList.jsp"/>
											<%out.flush();%> 
										</div>
									</div>
								</div>
							</div>
							
									
							<!-- Content area -->
							<div class="col8 acol12 ccol9 right" id="ordersSearchAndResultsDiv">
							
								<div id="findOrdersPageHeading" tabindex="0">	
									<h1 style="padding: 0px 0px;"><fmt:message key="FIND_ORDERS_CSR" bundle="${storeText}"/></h1>
									<span id="errorMessage_sectionFindOrders" class="successSpan" style="display:block"><fmt:message key="ORDERS_SEARCH_OPTIONS_SHIPPING" bundle="${storeText}"/> </span>
								</div>
							
								<div id="FindOrdersSearch_table" class="listTable findOrderlistTable" role="grid" aria-labelledby="findOrdersSearchResults_table_summary" tabindex="0">
									<%-- This is the hidden table summary used for Accessibility TODO --%>
									<div id="findOrdersSearchResults_table_summary" class="nodisplay" aria-hidden="true">
										<fmt:message key="FINDORDERS_SEARCH_RESULTS_TABLE_SUMMARY" bundle="${storeText}"/>
									</div>
								
									<div class="row">
										<div class="col12">
											<%out.flush();%>
											<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.FindOrders/FindOrdersSearch.jsp"/>
											<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.csr.FindOrders/FindOrdersResultList.jsp"/>
											<%out.flush();%> 
										</div>
									</div>
								</div>
							</div>
						</div>
							
							
					
					
												
					
					</div>
				
					<!-- Footer Widget -->
					<div class="highlight">
						<div id="footerWrapper">
							<%out.flush();%> <c:import url="${env_jspStoreDir}Widgets/Footer/Footer.jsp"/> <%out.flush();%>
						</div>
					</div>
				</div>
			</div>				
			<!-- Main Content End -->

			<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
			<%@ include file="../Common/JSPFExtToInclude.jspf"%>
		</div>
	</body>
</html>
</flow:ifEnabled>
<!-- END CustomerServiceLandingPage.jsp -->
