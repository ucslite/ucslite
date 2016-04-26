
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../include/ErrorMessageSetup.jspf"%>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>
<c:set var="pageCategory" value="MyAccount" scope="request"/>

<wcf:url var="AjaxCheckoutDisplayViewURL" value="AjaxCheckoutDisplayView">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>
<wcf:url var="PrepareOrderURL" value="RESTOrderPrepare">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="URL" value="${AjaxCheckoutDisplayViewURL}" />
</wcf:url>

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

<c:choose>
	<c:when test="${WCParam.isQuote eq true}">		
		<fmt:message bundle="${storeText}" key="MO_MYQUOTES" var="contentPageName" scope="request"/>
	</c:when>
	<c:when test="${WCParam.isRecurringOrder eq true}">		
		<fmt:message bundle="${storeText}" key="MA_SCHEDULEDORDERS" var="contentPageName" scope="request"/>
	</c:when>
	<c:when test="${WCParam.isSubscription eq true}">		
		<fmt:message bundle="${storeText}" key="MA_SUBSCRIPTIONS" var="contentPageName" scope="request"/>
	</c:when>
	<c:otherwise>
		<fmt:message bundle="${storeText}" key="MA_ORDER_HISTORY" var="contentPageName" scope="request"/>
	</c:otherwise>
</c:choose>

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
<!-- BEGIN OrderStatusDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message bundle="${storeText}" key="MO_MYORDERS"/></title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>

	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
			
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AddressHelper.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountControllersDeclaration.js"/>"></script>
	
	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
	
	<script type="text/javascript">
		dojo.addOnLoad(function() {
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
			if(document.getElementById("RecurringOrderDisplay")){
				parseWidget("RecurringOrderDisplay");
			}
			if(document.getElementById("SubscriptionDisplay")){
				parseWidget("SubscriptionDisplay");
			}
			MyAccountControllersDeclarationJS.setControllerURL("RecurringOrderDisplayController", "<c:out value='${RecurringOrderTableDetailsDisplayURL}'/>");
			MyAccountControllersDeclarationJS.setControllerURL("SubscriptionDisplayController", "<c:out value='${SubscriptionTableDetailsDisplayURL}'/>");
		});
	</script>
	<flow:ifEnabled feature="RecurringOrders">
		<c:if test="${WCParam.isRecurringOrder eq true}">
			<script type="text/javascript">
				dojo.addOnLoad(function() {
					if(document.getElementById("RecurringOrderBreadcrumb")){
						document.getElementById("MyAccountBreadcrumbLink").style.display = "none";
						document.getElementById("RecurringOrderBreadcrumb1").style.display = "inline";
					}
				});
			</script>
		</c:if>
	</flow:ifEnabled>
	<flow:ifEnabled feature="Subscription">
		<c:if test="${WCParam.isSubscription eq true}">
			<script type="text/javascript">
				dojo.addOnLoad(function() {
					if(document.getElementById("SubscriptionBreadcrumb")){
						document.getElementById("MyAccountBreadcrumbLink").style.display = "none";
						document.getElementById("SubscriptionBreadcrumb1").style.display = "inline";
					}
				});
			</script>
		</c:if>
	</flow:ifEnabled>
	<c:if test="${WCParam.isSubscription ne true && WCParam.isRecurringOrder ne true}">
		<script type="text/javascript">
			dojo.addOnLoad(function() {
				if(document.getElementById("OrderHistoryBreadcrumb")){
					document.getElementById("MyAccountBreadcrumbLink").style.display = "none";
					document.getElementById("OrderHistoryBreadcrumb1").style.display = "inline";
				}
			});
		</script>
	</c:if>
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
	
	<c:if test="${WCParam.isRecurringOrder eq true}">
		<c:set var="action" value="recurring_order"/>
	</c:if>
	<c:if test="${WCParam.isSubscription eq true}">
		<c:set var="action" value="subscription"/>
	</c:if>

    <!-- Main Content Start -->
		
	<c:if test="${!empty errorMessage}">
		<fmt:message bundle="${storeText}" var ="msgType" key="ERROR_MESSAGE_TYPE"/>
		<c:set var = "errorMessage" value ="${msgType}${errorMessage}"/>
		<script type="text/javascript">
			dojo.addOnLoad(function() { 
				dojo.byId('MessageArea').style.display = "block";
				dojo.byId('ErrorMessageText').innerHTML =<wcf:json object="${errorMessage}"/>;
				dojo.byId('MessageArea').focus();
				setTimeout("dojo.byId('ErrorMessageText').focus()",2000);
			});
		</script>
	</c:if>
	
	<!-- Main Content Start -->
	<div id="contentWrapper">
		<div id="content" role="main">
			<%@ include file="../../../Snippets/Subscription/CancelPopup.jspf" %>
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
						<div id="box" class="myAccountMarginRight">
									<div class="my_account" id="WC_OrderStatusDisplay_div_1">		

										<c:if test="${WCParam.showOrderHeader eq true}">
											<div class="myaccount_header bottom_line" id="WC_OrderStatusCommonPage_div_2">
												<div class="left_corner" id="WC_OrderStatusCommonPage_div_3"></div>
												<div class="headingtext" id="WC_OrderStatusCommonPage_div_4">
													<span class="main_header_text">
														<c:choose>
															<c:when test="${WCParam.isQuote eq true}">
																<fmt:message bundle="${storeText}" key='MO_MYQUOTES'/>
															</c:when>
															<c:when test="${WCParam.isRecurringOrder eq true}">
																<fmt:message bundle="${storeText}" key='MA_SCHEDULEDORDERS'/>
															</c:when>
															<c:when test="${WCParam.isSubscription eq true}">
																<fmt:message bundle="${storeText}" key='MA_SUBSCRIPTIONS'/>
															</c:when>
															<c:otherwise>
																<fmt:message bundle="${storeText}" key='MA_ORDER_HISTORY'/>
															</c:otherwise>
														</c:choose>
													</span>
												</div>
												<div class="right_corner" id="WC_OrderStatusCommonPage_div_5"></div>
											</div>
										</c:if>

										<c:if test="${WCParam.showOrderHeader eq true}">
											<div class="body" id="WC_OrderStatusCommonPage_div_6">						
										</c:if>
										<% out.flush(); %>
										<c:choose>
											<c:when test="${WCParam.isQuote eq true}">
												<c:import url="/${sdb.jspStoreDir}/Snippets/Order/Cart/OrderStatusTableDisplay.jsp" >
													<c:param name="isQuote" value="true"/>
												</c:import>
											</c:when>
											<c:when test="${WCParam.isRecurringOrder eq true}">
												<c:import url="/${sdb.jspStoreDir}/Snippets/Subscription/RecurringOrder/RecurringOrderTableDisplay.jsp"></c:import>
											</c:when>
											<c:when test="${WCParam.isSubscription eq true}">
												<c:import url="/${sdb.jspStoreDir}/Snippets/Subscription/SubscriptionTableDisplay.jsp"></c:import>
											</c:when>
											<c:otherwise>
											<%--Start order cancel Refesh Area --%>
												<div dojoType="wc.widget.RefreshArea"
		     										 widgetId="Ext_OrderStatusCommonPage_Widget"
		     										 id="Ext_OrderStatusCommonPage_Widget"
		    										 controllerId="OrderStatusDisplay_Controller" role="wairole:region"
		    										 waistate:live="polite" waistate:atomic="false"
	            									 waistate:relevant="all">
												<c:import url="/${sdb.jspStoreDir}/Snippets/Order/Cart/OrderStatusTableDisplay.jsp"></c:import>
												</div>
											<%-- end order cancel Refesh Area --%>
											</c:otherwise>
										</c:choose>
										<% out.flush();%>				
										<br/>								
										<br clear="all" />
										<c:if test="${WCParam.showOrderHeader eq true}">
											</div>
										</c:if>
									</div>
									<div class="footer" id="WC_OrderStatusCommonPage_div_7">
										<div class="left_corner" id="WC_OrderStatusCommonPage_div_8"></div>
										<div class="tile" id="WC_OrderStatusCommonPage_div_9"></div>
										<div class="right_corner" id="WC_OrderStatusCommonPage_div_10"></div>
									</div>				
								</div>
							</div>																			
					</div>
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
<!-- END OrderStatusDisplay.jsp -->
