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
<%--
	*****
	*
	* This JSP page displays the Order Status page with the following elements:
	*  - List of orders waiting for approval.
	*  - List of orders already processed.
	*  - List of orders scheduled.
	* For each order, the following is displayed
	* 	- Order Number, Order Date, Status, Total
	* In each list, 'Details' is a link to the Order Details page for that order
	*
	*
	* How to use this snippet?
	*	<c:import url="../../../Snippets/Order/Cart/OrderStatusTableDisplay.jsp" >
	*		<c:param name="isMyAccountMainPage" value="true"/>
	*	</c:import>
	*
	*****
--%>
<!-- BEGIN OrderStatusTableDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

<c:if test="${param.isQuote eq true}">
	<c:set var="showScheduledOrders" value="false"/>
</c:if>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>
<c:choose>
	<c:when test="${(showProcessedOrders == true && showWaitingForApprovalOrders == false) ||
									(param.isMyAccountMainPage != null && param.isMyAccountMainPage == true)}">
		<script type="text/javascript">dojo.addOnLoad(function() { parseWidget("OrderStatusTableDisplay_div_1"); });</script>
		<div id="OrderStatusTableDisplay_div_1">
			<span id="ProcessedOrdersStatusDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Order_List"/></span>
			<c:choose>
				<c:when test="${!param.isMyAccountMainPage}">
					<div dojoType="wc.widget.RefreshArea" widgetId="ProcessedOrdersStatusDisplay" id="ProcessedOrdersStatusDisplay" controllerId="ProcessedOrdersStatusDisplayController" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Order_List_Updated"/>" ariaLiveId="${ariaMessageNode}" aria-labelledby="ProcessedOrdersStatusDisplay_ACCE_Label" aria-describedby="PreviouslyProcessedSummaryMyAccountMainPage">
				</c:when>
				<c:otherwise>
					<div id="ProcessedOrdersStatusDisplay">
				</c:otherwise>
			</c:choose>
			<%out.flush();%>
				<c:import url="${env_jspStoreDir}/Snippets/Order/Cart/OrderStatusTableDetailsDisplay.jsp"> 
					<c:param name="catalogId" value="${WCParam.catalogId}" />
					<c:param name="langId" value="${WCParam.langId}" />
					<c:param name="storeId" value="${WCParam.storeId}" />
					<c:param name="selectedTab" value="PreviouslyProcessed"/>
					<c:param name="isMyAccountMainPage" value="${param.isMyAccountMainPage}"/>
				</c:import>
			<%out.flush();%>
			</div>
		</div>
	</c:when>
	<c:otherwise>
		<script type="text/javascript">dojo.addOnLoad(function() { parseWidget("OrderStatusTableDisplay_div_2"); });</script>
		<div id="OrderStatusTableDisplay_div_2" class="order_status">
			<!--- Tabs --->
			<div class="tab_container_top" >
				<div id="PreviouslyProcessed_On">
					<div class="tab_clear"></div>
					<div class="tab_active_left"></div>
					<div class="tab_active_middle" id="tab_processed_orders1">
						<c:if test="${showProcessedOrders}">
							<fmt:message bundle="${storeText}" key="MO_PREVIOUSLY_PROCESSED" /> 
						</c:if>
					</div>
					<div class="tab_active_inactive"></div>
				</div>
						
				<div id="PreviouslyProcessed_Off" style="display:none">
					<div class="tab_clear"></div>
					<div class="tab_inactive_left"></div>
					<div class="tab_inactive_middle" id="tab_processed_orders">
						<a href="javascript:MyAccountDisplay.selectTab('PreviouslyProcessed');" class="tab_link">
							<c:if test="${showProcessedOrders}">
								<fmt:message bundle="${storeText}" key="MO_PREVIOUSLY_PROCESSED" /> 
							</c:if>
						</a>
					</div>
					<div class="tab_inactive_active"></div>
				</div>
			
				<div id="WaitingForApproval_Off">
					<div class="tab_inactive_middle" id="tab_waiting_approval1">
						<a href="javascript:MyAccountDisplay.selectTab('WaitingForApproval');" class="tab_link">
							<c:if test="${showWaitingForApprovalOrders}">
								<fmt:message bundle="${storeText}" key="MO_WAITING_FOR_APPROVAL" /> 
							</c:if>
						</a>
					</div>
					<div class="tab_inactive_right"></div>
				</div>
			
				<div id="WaitingForApproval_On" style="display:none">
					<div class="tab_active_middle" id="tab_waiting_approval">
						<a href="#" class="tab_link">
							<fmt:message bundle="${storeText}" key="MO_WAITING_FOR_APPROVAL" /> 
						</a>
					</div>
					<div class="tab_active_right"></div>
				</div>
			</div>
				
			<!--- End Tabs --->
			<div class="tab_container_base">
				<div class="tab_container_left"></div>
				<div class="tab_container_middle"></div>
				<div class="tab_container_right"></div>
			</div>

			<div id="mainTabContainer" class="mainTabContainer_body" dojoType="dijit.layout.TabContainer" doLayout="false">
				<div id="OrderStatusTableDisplay_div_4" class="body">
			<div class="myaccount_header" id="OrderStatusTableDisplay_div_4a">
				<div class="left_corner_straight" id="WC_OrderShipmentDetails_div_9"></div>
				<div class="headingtext" id="WC_OrderShipmentDetails_div_10">
					<span class="header"><fmt:message bundle="${storeText}" key="MA_ORDER_HISTORY" /></span>
				</div>
				<div class="right_corner_straight" id="WC_OrderShipmentDetails_div_11"></div>
			</div>
				<div id="OrderStatusTableDisplay_div_5" class="order_details_my_account">
					<c:if test="${showProcessedOrders}">
						<div id="PreviouslyProcessed" class="order_status_table" dojoType="dijit.layout.ContentPane" aria-describedby="PreviouslyProcessedSummary" style="display:block" selected="true">
							<div id="PreviouslyProcessedSummary" class="hidden_summary">
							<c:choose>
								<c:when test="${param.isQuote eq true}">
									<fmt:message bundle="${storeText}" key="MO_PROCESSED_QUOTES_TABLE_DESCRIPTION" />
								</c:when>
								<c:otherwise>
									<flow:ifEnabled feature="AllowReOrder">
										<fmt:message bundle="${storeText}" key="MO_PROCESSED_ORDERS_TABLE_DESCRIPTION" />
									</flow:ifEnabled>
									<flow:ifDisabled feature="AllowReOrder">
										<fmt:message bundle="${storeText}" key="MO_PROCESSED_ORDERS_TABLE_DESCRIPTION_WO_REORDER" />
									</flow:ifDisabled>
								</c:otherwise>
							</c:choose>
							</div>
							<span id="ProcessedOrdersStatusDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Order_List"/></span>
							<div dojoType="wc.widget.RefreshArea" widgetId="ProcessedOrdersStatusDisplay" id="ProcessedOrdersStatusDisplay" controllerId="ProcessedOrdersStatusDisplayController" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Order_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="ProcessedOrdersStatusDisplay_ACCE_Label">
								<%out.flush();%>
									<c:import url="${env_jspStoreDir}/Snippets/Order/Cart/OrderStatusTableDetailsDisplay.jsp"> 
										<c:param name="catalogId" value="${WCParam.catalogId}" />
										<c:param name="langId" value="${WCParam.langId}" />
										<c:param name="storeId" value="${WCParam.storeId}" />
										<c:param name="selectedTab" value="PreviouslyProcessed"/>
										<c:param name="beginIndex" value="${beginIndex}"/>
										<c:param name="isQuote" value="${param.isQuote}"/>
									</c:import>
								<%out.flush();%>
							</div>
						</div>
					</c:if>
					
					<c:if test="${showWaitingForApprovalOrders}">
						<div id="WaitingForApproval" class="order_status_table" dojoType="dijit.layout.ContentPane" aria-describedby="WaitingForApprovalSummary" 
								 style="display:none" selected="true" />
							<div id="WaitingForApprovalSummary" class="hidden_summary">
								<fmt:message bundle="${storeText}" key="MO_PENDING_APPROVAL_QUOTES_TABLE_DESCRIPTION" />
							</div>
							<span id="WaitingForApprovalStatusDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Order_List"/></span>
							<div dojoType="wc.widget.RefreshArea" widgetId="ProcessedOrdersStatusDisplay" id="WaitingForApprovalOrdersStatusDisplay" 
									 controllerId="WaitingForApprovalOrdersStatusDisplayController" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Order_List_Updated"/>" 
									 ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="WaitingForApprovalStatusDisplay_ACCE_Label">
								<%out.flush();%>
									<c:import url="${env_jspStoreDir}/Snippets/Order/Cart/OrderStatusTableDetailsDisplay.jsp"> 
										<c:param name="catalogId" value="${WCParam.catalogId}" />
										<c:param name="langId" value="${WCParam.langId}" />
										<c:param name="storeId" value="${WCParam.storeId}" />
										<c:param name="selectedTab" value="WaitingForApproval"/>
										<c:param name="beginIndex" value="${beginIndex}"/>
										<c:param name="isQuote" value="${param.isQuote}"/>
									</c:import>
								<%out.flush();%>
							</div>
						</div>
					</c:if>
				</div>
			</div>
			<div class="tabfooter"></div>
		</div>
	</c:otherwise>
</c:choose>

<!-- END OrderStatusTableDisplay.jsp -->
