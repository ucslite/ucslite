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

<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>

<wcf:url var="RecurringOrderChildOrdersTableDetailsDisplayURL" value="RecurringOrderChildOrdersTableDetailsDisplay" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>
<wcf:url var="SubscriptionChildOrdersTableDetailsDisplayURL" value="SubscriptionChildOrdersTableDetailsDisplay" type="Ajax">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>
<fmt:message bundle="${storeText}" key="MO_ORDERDETAILS" var="contentPageName" scope="request"/>
<%-- When set to true:
	Order details page, cancel button will redirect to home page.
	Order details page, will not display SMS notification option.
--%>
<c:set var="guestOrderDetails" value="true" scope="request"/>

<!-- BEGIN GuestOrderDetailDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>
		<fmt:message bundle="${storeText}" key='CSR_GUEST_ORDER_DETAILS'/>
	</title>
	
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountControllersDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CheckoutArea/Punchout.js"/>"></script>
	
	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
	
	<script type="text/javascript">
		dojo.addOnLoad(function() {
			MyAccountControllersDeclarationJS.setControllerURL("RecurringOrderChildOrdersDisplayController", "<c:out value='${RecurringOrderChildOrdersTableDetailsDisplayURL}'/>");
			MyAccountControllersDeclarationJS.setControllerURL("SubscriptionChildOrdersDisplayController", "<c:out value='${SubscriptionChildOrdersTableDetailsDisplayURL}'/>");
			<fmt:message bundle="${storeText}" key="MO_ORDER_CANCELED_MSG" var="MO_ORDER_CANCELED_MSG"/>
			<fmt:message bundle="${storeText}" key="MO_OrderStatus_X" var="MO_OrderStatus_X"/>
			MessageHelper.setMessage("MO_ORDER_CANCELED_MSG", <wcf:json object="${MO_ORDER_CANCELED_MSG}"/>);
			MessageHelper.setMessage("MO_OrderStatus_X", <wcf:json object="${MO_OrderStatus_X}"/>);
		});
	</script>
</head>
<body>

	<!-- Page Start -->
	<div id="page" class="nonRWDPage">

		<!-- Import Header Widget -->
		<div class="header_wrapper_position" id="headerWidget">
			<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
			<%out.flush();%>
		</div>
		<!-- Header Nav End -->
		
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
						<div class="col9 acol12 ccol9" style="margin:0 auto;float:none;">	
							<flow:ifEnabled feature="SideBySideIntegration">
								<c:choose>
									<c:when test="${!empty WCParam.externalOrderId}">
										<% out.flush(); %>
											<c:import url="../../../Snippets/Order/SterlingIntegration/SBSOrderDetails.jsp" >
											</c:import>
										<% out.flush(); %>
									</c:when>
									<c:otherwise>
										<% out.flush(); %>
										<c:import url="../../../Snippets/Order/Ship/OrderShipmentDetails.jsp" >
											<c:param name = "showCurrentCharges" value = "true"/>
											<c:param name = "showFutureCharges"  value = "true"/>
										</c:import>
										<% out.flush();%>
									</c:otherwise>
								</c:choose>
							</flow:ifEnabled>
							<flow:ifDisabled feature="SideBySideIntegration">
								<% out.flush(); %>
								<c:import url="../../../Snippets/Order/Ship/OrderShipmentDetails.jsp" >
									<c:param name= "showCurrentCharges" value= "true"/>
									<c:param name= "showFutureCharges"  value= "true"/>
								</c:import>
								<% out.flush();%>
							</flow:ifDisabled>
						</div>
						<div class="clear_float"></div>
					</div>
				</div>			
			</div>
		</div>	
	<!-- Main Content End -->			 
		
		<!-- Footer Start -->
		<div class="footer_wrapper_position">
			<%out.flush();%>
				<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
			<%out.flush();%>
		</div>
		<!-- Footer End -->
	</div>
	
	<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END GuestOrderDetailDisplay.jsp -->
