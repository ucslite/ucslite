
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="myAccountLandingPage" value="true" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>
<c:set var="pageCategory" value="MyAccount" scope="request"/>

<wcf:url var="OrderStatusTableDetailsDisplayURL" value="OrderStatusTableDetailsDisplay" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
	<c:if test="${WCParam.isQuote eq true}">
		<wcf:param name="isQuote" value="true" />
	</c:if>
</wcf:url>

<wcf:url var="RecurringOrderTableDetailsDisplayURL" value="RecurringOrderTableDetailsDisplay" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>

<wcf:url var="SubscriptionTableDetailsDisplayURL" value="SubscriptionTableDetailsDisplay" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>
<fmt:message bundle="${storeText}" key="MA_MYACCOUNT" var="contentPageName" scope="request"/>

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
<!-- BEGIN MyAccountDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml"
xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<!-- Mimic Internet Explorer 7 -->
	<link href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${vfileStylesheetprint}"/>" type="text/css" media="print"/>
	<%@ include file="../../Common/CommonJSToInclude.jspf"%>
	<%@ include file="../../include/ErrorMessageSetupBrazilExt.jspf" %>
	<%@ include file="MyAccountDisplayExt.jspf" %>
	<%@ include file="GiftRegistryMyAccountDisplayExt.jspf" %>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingList.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingListServicesDeclaration.js"/>"></script>
		
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AddressHelper.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CheckoutArea/CheckoutPayments.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/LogonForm.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CatalogArea/CategoryDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountControllersDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CheckoutArea/Punchout.js"/>"></script>
	<title><fmt:message bundle="${storeText}" key="MA_MYACCOUNT"/></title>
	<c:if test="${isBrazilStore}"> 
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyBrazilAccountDisplay.js"/>"></script>
	</c:if>
	
	<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>
		


<script type="text/javascript">
	dojo.addOnLoad(function() {
		categoryDisplayJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>','${userType}');
		MyAccountServicesDeclarationJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');

		<fmt:message bundle="${storeText}" key="MO_ORDER_CANCELED_MSG" var="MO_ORDER_CANCELED_MSG"/>
		<fmt:message bundle="${storeText}" key="SCHEDULE_ORDER_CANCEL_MSG" var="SCHEDULE_ORDER_CANCEL_MSG"/>
		<fmt:message bundle="${storeText}" key="SCHEDULE_ORDER_PENDING_CANCEL_MSG" var="SCHEDULE_ORDER_PENDING_CANCEL_MSG"/>
		<fmt:message bundle="${storeText}" key="SUBSCRIPTION_CANCEL_MSG" var="SUBSCRIPTION_CANCEL_MSG"/>
		<fmt:message bundle="${storeText}" key="SUBSCRIPTION_PENDING_CANCEL_MSG" var="SUBSCRIPTION_PENDING_CANCEL_MSG"/>
		<fmt:message bundle="${storeText}" key="CANNOT_RENEW_NOW_MSG" var="CANNOT_RENEW_NOW_MSG"/>
		MessageHelper.setMessage("MO_ORDER_CANCELED_MSG", <wcf:json object="${MO_ORDER_CANCELED_MSG}"/>);	
		MessageHelper.setMessage("SCHEDULE_ORDER_CANCEL_MSG", <wcf:json object="${SCHEDULE_ORDER_CANCEL_MSG}"/>);
		MessageHelper.setMessage("SCHEDULE_ORDER_PENDING_CANCEL_MSG", <wcf:json object="${SCHEDULE_ORDER_PENDING_CANCEL_MSG}"/>);
		MessageHelper.setMessage("SUBSCRIPTION_CANCEL_MSG", <wcf:json object="${SUBSCRIPTION_CANCEL_MSG}"/>);
		MessageHelper.setMessage("SUBSCRIPTION_PENDING_CANCEL_MSG", <wcf:json object="${SUBSCRIPTION_PENDING_CANCEL_MSG}"/>);
		MessageHelper.setMessage("CANNOT_RENEW_NOW_MSG", <wcf:json object="${CANNOT_RENEW_NOW_MSG}"/>);
		MyAccountControllersDeclarationJS.setControllerURL("ScheduledOrdersStatusDisplayController", "<c:out value='${OrderStatusTableDetailsDisplayURL}'/>");
		MyAccountControllersDeclarationJS.setControllerURL("ProcessedOrdersStatusDisplayController", "<c:out value='${OrderStatusTableDetailsDisplayURL}'/>");
		MyAccountControllersDeclarationJS.setControllerURL("WaitingForApprovalOrdersStatusDisplayController", "<c:out value='${OrderStatusTableDetailsDisplayURL}'/>");
		if(document.getElementById("RecentRecurringOrderDisplay")){
			parseWidget("RecentRecurringOrderDisplay");
		}
		if(document.getElementById("RecentSubscriptionDisplay")){
			parseWidget("RecentSubscriptionDisplay");
		}
		MyAccountControllersDeclarationJS.setControllerURL("RecurringOrderDisplayController", "<c:out value='${RecurringOrderTableDetailsDisplayURL}'/>");
		MyAccountControllersDeclarationJS.setControllerURL("SubscriptionDisplayController", "<c:out value='${SubscriptionTableDetailsDisplayURL}'/>");
		<%--Start order cancel --%>
		parseWidget("Ext_MyAccountOrderStatusDisplay_Widget");
		<%-- end order cancel --%>
		
		if (dojo.cookie("WC_SHOW_USER_ACTIVATION_" + WCParamJS.storeId) == "true") {setCookie("WC_SHOW_USER_ACTIVATION_" + WCParamJS.storeId, null, {path: '/', expires: -1, domain: cookieDomain});}
	});
</script>
 <script type="text/javascript">
         function popupWindow(URL) {
            window.open(URL, "mywindow", "status=1,scrollbars=1,resizable=1");
         }
 </script>

</head>
<body>
 
<!-- Page Start -->
<div id="page" class="nonRWDPage">
	<!-- Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	
	<script type="text/javascript">
		if('<wcf:out value="${WCParam.page}" escapeFormat="js"/>'=='quickcheckout'){
			dojo.addOnLoad(function() { 
				MessageHelper.displayStatusMessage(storeNLS["QC_UPDATE_SUCCESS"]);
			});
		}
	</script>

	<c:set var="action" value="recurring_order"/>
	<%@ include file="../../Snippets/Subscription/CancelPopup.jspf" %>
	<c:set var="action" value="subscription"/>
	<%@ include file="../../Snippets/Subscription/CancelPopup.jspf" %>
	
	<!-- Main Content Start -->
	<div id="contentWrapper">
		<div id="content" role="main">		
			<div class="row margin-true">
				<div class="col12">				
					<%out.flush();%>
						<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">  														
							<c:param name="pageGroup" value="Content"/>
						</c:import>
					<%out.flush();%>					
				</div>
			</div>
			<div class="rowContainer" id="container_MyAccountDisplayB2B">
				<div class="row margin-true">					
					<div class="col4 acol12 ccol3">
						<%out.flush();%>
							<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.MyAccountNavigation/MyAccountNavigation.jsp"/>
						<%out.flush();%>		
					</div>
					<div class="col8 acol12 ccol9 right">	
						<!-- Main Content Start -->
								<div id="WC_MyAccountDisplay_div_3_9">
									<div id="WC_MyAccountDisplay_div_4">
										<div id= "box">
											<div class="my_account" id="WC_MyAccountDisplay_div_4_1">
												<div class="main_header" id="WC_MyAccountDisplay_div_5">
													<h2 class="myaccount_header bottom_line"><fmt:message bundle="${storeText}" key='MA_SUMMARY'/></h2>
												</div>
												<div class="contentline" id="WC_MyAccountDisplay_div_9"></div>
												<div class="body" id="WC_MyAccountDisplay_div_13">
													<%out.flush();%>
													<c:import url="/${sdb.jspStoreDir}/UserArea/AccountSection/MyAccountCenterLinkDisplay.jsp">  
														<c:param name="storeId" value="${WCParam.storeId}"/>
														<c:param name="catalogId" value="${WCParam.catalogId}"/>  
														<c:param name="langId" value="${langId}"/>
													</c:import>
													<%out.flush();%>  
												</div>
												<div class="footer" id="WC_MyAccountDisplay_div_14">
													<div class="left_corner" id="WC_MyAccountDisplay_div_15"></div>
													<div class="tile" id="WC_MyAccountDisplay_div_16"></div>
													<div class="right_corner" id="WC_MyAccountDisplay_div_17"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
					</div>
				</div>
			</div>			
		</div>
	</div>	
	<!-- Main Content End -->					

	<!-- Footer Start Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div> 
     <!-- Footer Start End -->
</div>

<flow:ifEnabled feature="Analytics"><cm:pageview pageType="wcs-registration"/></flow:ifEnabled>
<%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END MyAccountDisplay.jsp -->
