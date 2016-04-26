<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%--
  *****
  *
  * This JSP page displays the Subscription page 
  * In each list, 'Details' is a link to the Subscription Details page for that subscription
  *
  *
  * How to use this snippet?
  *	<c:import url="../../../Snippets/Subscription/SubscriptionTableDisplay.jsp" >
  *		<c:param name="isMyAccountMainPage" value="true"/>
  *	</c:import>
  *
  *****
--%>
<!-- BEGIN SubscriptionTableDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>


<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<div id="WC_SubscriptionTableDisplay_div_1">
	<span id="SubscriptionDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Subscription_Order_List"/></span>
	<c:choose>
		<c:when test="${!param.isMyAccountMainPage}">
			<div dojoType="wc.widget.RefreshArea" widgetId="SubscriptionDisplay" id="SubscriptionDisplay" controllerId="SubscriptionDisplayController" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Subscription_Order_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="SubscriptionDisplay_ACCE_Label">
		</c:when>
		<c:otherwise>
			<div dojoType="wc.widget.RefreshArea" widgetId="RecentSubscriptionDisplay" id="RecentSubscriptionDisplay" controllerId="RecentSubscriptionDisplayController">
		</c:otherwise>
	</c:choose>
	<%out.flush();%>
		<c:import url="${env_jspStoreDir}/Snippets/Subscription/SubscriptionTableDetailsDisplay.jsp"> 
			<c:param name="catalogId" value="${WCParam.catalogId}" />
			<c:param name="langId" value="${WCParam.langId}" />
			<c:param name="storeId" value="${WCParam.storeId}" />
			<c:param name="isMyAccountMainPage" value="${param.isMyAccountMainPage}"/>
		</c:import>
	<%out.flush();%>
	</div>
</div>

<!-- END SubscriptionTableDisplay.jsp -->
