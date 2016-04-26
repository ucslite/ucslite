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

<!-- BEGIN RecurringOrderTableDetailsDisplay.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>

<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>
<c:if test="${param.isMyAccountMainPage}">
	<c:set var="pageSize" value="3"/>
</c:if>

<c:set var="contextId" value="RecurringOrderDisplay_Context"/>

<jsp:useBean id="now" class="java.util.Date" scope="page"/>

<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>	
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>

<wcf:rest var="recurringOrders" url="/store/{storeId}/subscription">
		<wcf:var name="storeId" value="${storeId}" />
		<wcf:param name="q" value="byBuyerIdAndSubscriptionType"/>
		<wcf:param name="profileName" value="IBM_Store_Summary"/>
		<wcf:param name="buyerId" value="${CommandContext.userId}"/>
		<wcf:param name="subscriptionTypeCode" value="RecurringOrder"/>
</wcf:rest>

<fmt:parseNumber var="numEntries" value="${recurringOrders.recordSetTotal}" integerOnly="true" />
<c:set  var="totalPages"  value = "${numEntries / pageSize * 1.0}"/>
<%-- Get a float value from totalPages which is a string --%>
<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="false" parseLocale="en_US"/>

<%-- do a ceil if totalPages contains fraction digits --%>
<c:set var="totalPages" value = "${totalPages + (1 - (totalPages % 1)) % 1}"/>
<c:choose>
	<c:when test="${beginIndex + pageSize >= numEntries}">
		<c:set var="endIndex" value="${numEntries}" />
	</c:when>
	<c:otherwise>
		<c:set var="endIndex" value="${beginIndex + pageSize}" />
	</c:otherwise>
</c:choose>

<c:if test="${numEntries > pageSize}">
	<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
	<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>
</c:if>

<c:if test="${(param.isMyAccountMainPage == null) || (empty param.isMyAccountMainPage) || (param.isMyAccountMainPage == false)}">
	<%-- Display pagination links only if user is in Recurring Order page. Do not display pagination links in MyAccount page --%>
	<c:if test="${numEntries > pageSize}">
		<div id="RecurringOrderPagination_1">
			<span id="RecurringOrderDetailPagination_span_1a" class="text">
				<fmt:message bundle="${storeText}" key="MO_Page_Results" > 
					<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
				</fmt:message>
				<span id="RecurringOrderDetailPagination_span_2a" class="paging">
					<c:if test="${beginIndex != 0}">	
						<a id="RecurringOrderDetailPagination_previous_link_1" href="javaScript:setCurrentId('RecurringOrderDetailPagination_previous_link_1'); if(submitRequest()){cursor_wait();
						wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE" />" />
					<c:if test="${beginIndex != 0}">
						</a>
					</c:if>
					<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
						<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
					</fmt:message>
					<c:if test="${numEntries > endIndex }">
						<a id="RecurringOrderDetailPagination_next_link_1" href="javaScript:setCurrentId('RecurringOrderDetailPagination_next_link_1'); if(submitRequest()){cursor_wait();
						wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
					<c:if test="${numEntries > endIndex }">
						</a>
					</c:if>
				</span>
			</span>
		</div>
	</c:if>
</c:if>

<table border="0" cellpadding="0" cellspacing="0" class="order_status_table scheduled_orders" summary="<fmt:message bundle="${storeText}" key="MO_SCHEDULED_ORDERS_TABLE_DESCRIPTION" />">

<fmt:parseNumber var="numEntries" value="${recurringOrders.recordSetTotal}" integerOnly="true" />
<c:choose>
<c:when test="${numEntries <= 0}">
	<tr><td><fmt:message bundle="${storeText}" key="MO_NOORDERSFOUND" /></td></tr>
</c:when>
<c:otherwise>

<tr id="RecurringOrderDetailsDisplayExt_ul_1" class="ul column_heading">
<th scope="col" id="RecurringOrderDetailsDisplayExt_li_header_1" class="li order_number_column">
<c:set var="messageKey" value="MA_ORDERNUM"/>	
<fmt:message bundle="${storeText}" key="${messageKey}" />
</th>
<th scope="col" id="RecurringOrderDetailsDisplayExt_li_header_2" class="li order_scheduled_column"><fmt:message bundle="${storeText}" key="SCHEDULE_ORDER_INTERVAL_TITLE" /></th>
<th scope="col" id="RecurringOrderDetailsDisplayExt_li_header_3" class="li next_order_column"><fmt:message bundle="${storeText}" key="MO_NEXT_ORDER" /></th>
<th scope="col" id="RecurringOrderDetailsDisplayExt_li_header_4" class="li order_status_column"><fmt:message bundle="${storeText}" key="MO_SUBSCRIPTION_STATUS" /></th>
<th scope="col" id="RecurringOrderDetailsDisplayExt_li_header_5" class="li total_price_column"><fmt:message bundle="${storeText}" key="TOTAL_PRICE" /></th>
<th scope="col" id="RecurringOrderDetailsDisplayExt_li_header_6" class="li options_column"><span class="spanacce"><fmt:message bundle="${storeText}" key="MO_ACCE_BUTTON_COLUMN" /></span></th>
</tr>
<c:forEach var="order" items="${recurringOrders.resultList}" varStatus="status">
<%-- status.count index is 1 based, while beginIndex and endIndex are 0 based --%>
<c:if test="${(status.count - 1) >= beginIndex && (status.count - 1 ) < endIndex}">

<c:choose>
	<c:when test="${order.purchaseDetails.parentOrderIdentifier.externalOrderID != null}">
		<c:set var="objectId" value="${order.purchaseDetails.parentOrderIdentifier.externalOrderID}"/>
		<c:set var="objectIdParam" value="externalOrderId"/>
	</c:when>
	<c:otherwise>
		<c:set var="objectId" value="${order.purchaseDetails.parentOrderIdentifier.parentOrderId}"/>
		<c:set var="objectIdParam" value="orderId"/>
	</c:otherwise>
</c:choose>
	
<c:choose>
	<c:when test ="${order.subscriptionInfo.paymentInfo.totalCost.value != null}">
		<%-- Need to reset currencyFormatterDB as initialized in JSTLEnvironmentSetup.jspf, as the currency code used there is from commandContext. For order history we want to display with currency used when the order was placed. --%>
		<c:set var="key1" value="store/${storeId}/currency_format+byCurrency+${order.subscriptionInfo.paymentInfo.totalCost.currency}+-1+${langId}"/>
		<c:set var="currencyFormatterDB" value="${cachedOnlineStoreMap[key1]}"/>
		<c:if test="${empty currencyFormatterDB}">
			<wcf:rest var="getCurrencyFormatResponse" url="store/{storeId}/currency_format" cached="true">
			<wcf:var name="storeId" value="${storeId}" />
				<wcf:param name="q" value="byCurrency" />
				<wcf:param name="currency" value="${order.subscriptionInfo.paymentInfo.totalCost.currency}" />
				<wcf:param name="numberUsage" value="-1" />
				<wcf:param name="langId" value="${langId}" />
			</wcf:rest>
			<c:set var="currencyFormatterDB" value="${getCurrencyFormatResponse.resultList[0]}" scope="request" />
			<wcf:set target = "${cachedOnlineStoreMap}" key="${key1}" value="${currencyFormatterDB}"/>
		</c:if>

		<c:set var="currencyDecimal" value="${currencyFormatterDB.decimalPlaces}"/>
		
		<c:if test="${order.subscriptionInfo.paymentInfo.totalCost.currency == 'KRW'}">
			<c:set property="currencySymbol" value="&#8361;" target="${currencyFormatterDB}"/>
		</c:if>

		<c:if test="${order.subscriptionInfo.paymentInfo.totalCost.currency == 'PLN'}">
			<c:set property="currencySymbol" value="z&#322;" target="${currencyFormatterDB}"/>
		</c:if>		
		
		<c:if test="${order.subscriptionInfo.paymentInfo.totalCost.currency == 'ILS' && locale == 'iw_IL'}">
			<c:set property="currencySymbol" value="&#1513;&#1524;&#1495;" target="${currencyFormatterDB}"/>
		</c:if>

		<%-- These variables are used to hold the currency symbol --%>
		<c:choose>
			<c:when test="${locale == 'ar_EG' && order.subscriptionInfo.paymentInfo.totalCost.currency == 'EGP'}">
				<c:set var="CurrencySymbolToFormat" value=""/>
				<c:set var="CurrencySymbol" value="${currencyFormatterDB.currencySymbol}"/>
			</c:when>
			<c:otherwise>
				<c:set var="CurrencySymbolToFormat" value="${currencyFormatterDB.currencySymbol}"/>
				<c:set var="CurrencySymbol" value=""/>
			</c:otherwise>
		</c:choose>
	</c:when>
</c:choose>

	<tr id="RecurringOrderDisplay_ul_2_${status.count}" class="ul row">
			
			<fmt:message bundle="${storeText}" key="X_DETAILS"  var="RecurringOrderDetailBreadcrumbLinkLabel"> 
				<fmt:param><c:out value="${objectId}"/></fmt:param>
			</fmt:message>

				<wcf:url value="OrderDetail" var="OrderDetailUrl1">
					<wcf:param name="${objectIdParam}" value="${objectId}"/>
					<wcf:param name="subscriptionId" value="${order.subscriptionIdentifier.subscriptionId}"/>
					<wcf:param name="storeId" value="${WCParam.storeId}"/>
					<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
					<wcf:param name="langId" value="${WCParam.langId}"/>
					<wcf:param name="currentSelection" value="RecurringOrderDetailSlct"/>
				</wcf:url>

			<td id="RecurringOrderDetailsDisplayExt_order_number_<c:out value='${status.count}'/>" class="li order_number_column">
				<span>
					<c:choose>
							<c:when test="${!empty objectId}">
								<c:out value="${objectId}"/>
							</c:when>
							<c:otherwise>
								<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />	
							</c:otherwise>
					</c:choose>					
				</span>
				<br/>
				
				<a href="<c:out value='${OrderDetailUrl1}'/>" class="myaccount_link hover_underline" id="OrderDetailLink_NonAjax_<c:out value='${status.count}'/>"><fmt:message bundle="${storeText}" key="DETAILS" /></a>
			</td>

			<td id="RecurringOrderDetailsDisplayExt_order_scheduled_<c:out value='${status.count}'/>" class="li order_scheduled_column">
				<span>
					<c:choose>
						<c:when test="${!empty order.subscriptionInfo.fulfillmentSchedule.frequencyInfo.frequency.value}">
							<c:if test="${!empty order.subscriptionInfo.fulfillmentSchedule.endInfo.duration.value}">
								<fmt:parseNumber var="timePeriod" value="${order.subscriptionInfo.fulfillmentSchedule.endInfo.duration.value}" integerOnly="true"/>
							</c:if>
							<fmt:parseNumber var="orderInterval" value="${order.subscriptionInfo.fulfillmentSchedule.frequencyInfo.frequency.value}" integerOnly="true"/>
							<c:set var="intervalUOM" value="${fn:trim(order.subscriptionInfo.fulfillmentSchedule.frequencyInfo.frequency.uom)}"/>
							<c:choose>
								<c:when test="${!empty order.subscriptionInfo.fulfillmentSchedule.endInfo.duration.value && timePeriod == 1}">
									<c:out value='${RecurringOrderFrequencyText1}'/>	
								</c:when>
								<c:when test="${orderInterval == RecurringOrderFrequency2 && intervalUOM == RecurringOrderFrequencyUOM2}">
									<c:out value='${RecurringOrderFrequencyText2}'/>	
								</c:when>
								<c:when test="${orderInterval == RecurringOrderFrequency3 && intervalUOM == RecurringOrderFrequencyUOM3}">
									<c:out value='${RecurringOrderFrequencyText3}'/>	
								</c:when>
								<c:when test="${orderInterval == RecurringOrderFrequency4 && intervalUOM == RecurringOrderFrequencyUOM4}">
									<c:out value='${RecurringOrderFrequencyText4}'/>	
								</c:when>
								<c:when test="${orderInterval == RecurringOrderFrequency5 && intervalUOM == RecurringOrderFrequencyUOM5}">
									<c:out value='${RecurringOrderFrequencyText5}'/>	
								</c:when>
								<c:when test="${orderInterval == RecurringOrderFrequency6 && intervalUOM == RecurringOrderFrequencyUOM6}">
									<c:out value='${RecurringOrderFrequencyText6}'/>	
								</c:when>
							</c:choose>		
						</c:when>
						<c:otherwise>
							<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />	
						</c:otherwise>
					</c:choose>					
				</span>
			</td>

			<td id="RecurringOrderDetailsDisplayExt_next_order_date_<c:out value='${status.count}'/>" class="li next_order_column">
				<c:choose>
					<c:when test="${order.state eq 'Active' || order.state eq 'PendingCancel' || order.state eq 'InActive'}">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="nextTime" value="${order.subscriptionInfo.fulfillmentSchedule.frequencyInfo.nextOccurence}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
						</c:catch>

						<c:if test="${empty nextTime}">
							<c:catch>
								<fmt:parseDate parseLocale="${dateLocale}" var="nextTime" value="${order.subscriptionInfo.fulfillmentSchedule.frequencyInfo.nextOccurence}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
							</c:catch>
						</c:if>
						<c:set var="indexTime" value="${nextTime}" />
						<fmt:formatDate var="formattedNextOrderDate" value="${nextTime}" dateStyle="long" timeZone="${formattedTimeZone}"/>
						<span><c:out value="${formattedNextOrderDate}"/></span>
					</c:when>
					<c:otherwise>
						<span><c:out value="-"/></span>
					</c:otherwise>
				</c:choose>
			</td>
			
			<fmt:parseNumber var="timeDifference" value="${(indexTime.time - now.time)/1000}" parseLocale="${dateLocale}" integerOnly="true"/>
			<fmt:parseNumber var="cancelRecurringOrderNoticePeriod1" value="${cancelRecurringOrderNoticePeriod}" integerOnly="true"/>
			<c:choose>
				<c:when test="${timeDifference > 0 && timeDifference >= cancelRecurringOrderNoticePeriod1}">
					<fmt:message bundle="${storeText}" key="SCHEDULE_ORDER_CANCEL_PER"  var="cancelMessage"/>
				</c:when>
				<c:otherwise>
					<fmt:message bundle="${storeText}" key="CANCEL_NOTICE_PERIOD_MSG"  var="cancelMessage"> 
						<fmt:param><c:out value="${formattedNextOrderDate}" escapeXml="false"/></fmt:param>
					</fmt:message>
				</c:otherwise>
			</c:choose>
			<td id="RecurringOrderDetailsDisplayExt_order_status_<c:out value='${status.count}'/>" class="li order_status_column">
				<span>
					<c:choose>
						<c:when test="${!empty order.state}">
							<c:choose>
								<c:when test="${order.state eq 'InActive'}" >
									<fmt:message bundle="${storeText}" key="INACTIVE_STATE" />
								</c:when>
								<c:when test="${order.state eq 'Active'}" >
									<fmt:message bundle="${storeText}" key="ACTIVE_STATE" />
								</c:when>
								<c:when test="${order.state eq 'Expired'}" >
									<fmt:message bundle="${storeText}" key="EXPIRED_STATE" />
								</c:when>
								<c:when test="${order.state eq 'Cancelled'}" >
									<fmt:message bundle="${storeText}" key="CANCELLED_STATE" />
								</c:when>
								<c:when test="${order.state eq 'Completed'}" >
									<fmt:message bundle="${storeText}" key="COMPLETED_STATE" />
								</c:when>
								<c:when test="${order.state eq 'Suspended'}" >
									<fmt:message bundle="${storeText}" key="SUSPENDED_STATE" />
								</c:when>
								<c:when test="${order.state eq 'PendingCancel'}" >
									<fmt:message bundle="${storeText}" key="PENDING_CANCEL_STATE" />
								</c:when>
							</c:choose>
						</c:when>
						<c:otherwise>
							<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
						</c:otherwise>
					</c:choose>
				</span>
			</td>

			<td id="RecurringOrderDetailsDisplayExt_total_price_<c:out value='${status.count}'/>" class="li total_price_column">					
				<span class="price">
					<c:choose>
						<c:when test="${order.subscriptionInfo.paymentInfo.totalCost.value != null}">
							<c:choose>
								<c:when test="${!empty order.subscriptionInfo.paymentInfo.totalCost.value}">
									<fmt:formatNumber value="${order.subscriptionInfo.paymentInfo.totalCost.value}" type="currency" maxFractionDigits="${currencyDecimal}" currencySymbol="${CurrencySymbolToFormat}"/>
									<c:out value="${CurrencySymbol}"/>
								</c:when>
								<c:otherwise>
									<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />					
						</c:otherwise>
					</c:choose>
				</span>
			</td>

			<c:if test="${order.state eq 'Active'}" >
			<td id="RecurringOrderDetailsDisplayExt_option_<c:out value='${status.count}'/>" class="li options_column">
				<div class="option_button"> 
					<div id="showOptions_<c:out value='${status.count}'/>" class="option_button">
						<a role="button" aria-labelledby="recurring_order_actions_button_text" href="javascript:void(0);" class="button_primary" onkeypress="javaScript:MyAccountDisplay.showActionsPopup(event,'showOptions_<c:out value='${status.count}'/>','actions_popup_<c:out value='${status.count}'/>', 'actions_popup_widget_recurring_order');" onclick="javaScript:MyAccountDisplay.showActionsPopup(null,'showOptions_<c:out value='${status.count}'/>','actions_popup_<c:out value='${status.count}'/>', 'actions_popup_widget_recurring_order');" width="100%" id="RecurringOrderDetailsDisplayExt_option_button_3b_<c:out value='${status.count}'/>" tabindex="0">
							<div class="left_border"></div>
							<div class="button_text" id="recurring_order_actions_button_text"><fmt:message bundle="${storeText}" key="MO_ACTIONS" /><img class="actions_down_arrow" src="<c:out value="${jspStoreImgDir}${vfileColor}transparent.gif"/>" alt="<fmt:message bundle="${storeText}" key='DOWN_ARROW_IMAGE'/>"/></div>
							<div class="right_border"></div>
						</a>
					</div>
				</div>
			</td>
			</c:if>

			<c:if test="${order.state ne 'Active'}" >
				<td id="RecurringOrderDetailsDisplayExt_option_<c:out value='${status.count}'/>" class="li options_column">
					
						<flow:ifEnabled feature="AllowReOrder">
							<c:if test="${param.isQuote != true}">
								<wcf:url value="AjaxRESTOrderCopy" var="OrderCopyUrl" type="Ajax">
									<wcf:param name="fromOrderId_1" value="${objectId}"/>
									<wcf:param name="toOrderId" value=".**."/>
									<wcf:param name="copyOrderItemId_1" value="*"/>
									<wcf:param name="URL" value="AjaxOrderItemDisplayView"/>
									<wcf:param name="storeId" value="${WCParam.storeId}"/>
									<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
									<wcf:param name="langId" value="${WCParam.langId}"/>
								</wcf:url>
								<div id="RecurringOrderDetailsDisplayExt_option_1_<c:out value='${status.count}'/>" class="option_button">
									<div class="option_button">
										<a href="#" class="button_primary" width="100%" id="RecurringOrderDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>" tabindex="0" onclick="javaScript:setCurrentId('RecurringOrderDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>'); MyAccountDisplay.prepareOrderCopy('<c:out value='${OrderCopyUrl}'/>');">
											<div class="left_border"></div>
											<div class="button_text"><fmt:message bundle="${storeText}" key="MO_REORDER" /></div>
											<div class="right_border"></div>
										</a>
									</div>
								</div>
							</c:if>
						</flow:ifEnabled>
					
				</td>
			</c:if>

		
				

		<div id="actions_popup_<c:out value='${status.count}'/>" style="display:none" >
			<div id="actions_popup_div1_<c:out value='${status.count}'/>" class="actions_popup hover_underline">
				<div id="actions_popup_reorder_<c:out value='${status.count}'/>" class="reorder">
						<flow:ifEnabled feature="AllowReOrder">
							<c:if test="${param.isQuote != true}">
								<wcf:url value="AjaxRESTOrderCopy" var="OrderCopyUrl" type="Ajax">
									<wcf:param name="fromOrderId_1" value="${objectId}"/>
									<wcf:param name="toOrderId" value=".**."/>
									<wcf:param name="copyOrderItemId_1" value="*"/>
									<wcf:param name="URL" value="AjaxOrderItemDisplayView"/>
									<wcf:param name="storeId" value="${WCParam.storeId}"/>
									<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
									<wcf:param name="langId" value="${WCParam.langId}"/>
								</wcf:url>
								<a href="javaScript:setCurrentId('RecurringOrderDetailsDisplayExt_option_button_3b_<c:out value='${status.count}'/>'); MyAccountDisplay.prepareOrderCopy('<c:out value='${OrderCopyUrl}'/>');" width="100%" id="RecurringOrderDetailsDisplayExt_option_button_link_3_<c:out value='${status.count}'/>" class="link"><fmt:message bundle="${storeText}" key="MO_REORDER" /></a>
							</c:if>
						</flow:ifEnabled>
					
				</div>
				<input type="hidden" id="recurringOrderCancelMessage_<c:out value='${status.count}'/>" name="recurringOrderCancelMessage_<c:out value='${status.count}'/>" value="${cancelMessage}">
				<div id="actions_popup_cancel_<c:out value='${status.count}'/>" class="cancel">
					<a href="javaScript:setCurrentId('RecurringOrder_CancelButton_Ajax_<c:out value='${status.count}'/>'); dijit.byId('actions_popup_widget_recurring_order').hide(); MyAccountDisplay.showPopup('recurring_order',${order.subscriptionIdentifier.subscriptionId},'recurringOrderCancelMessage_<c:out value='${status.count}'/>');" width="100%" id="RecurringOrder_CancelButton_Ajax_<c:out value='${status.count}'/>" class="link"><fmt:message bundle="${storeText}" key="SCHEDULE_ORDER_CANCEL" /></a>
				</div>
			</div>
		</div>
	</tr>
	</c:if>
</c:forEach>
</c:otherwise>
</c:choose>
</table>
<c:if test="${(param.isMyAccountMainPage == null) || (empty param.isMyAccountMainPage) || (param.isMyAccountMainPage == false)}">
	<%-- Display pagination links only if user is in Recurring Order page. Do not display pagination links in MyAccount page --%>
	<c:if test="${numEntries > pageSize}">
		<div id="RecurringOrderPagination_2">
			<span id="RecurringOrderDetailPagination_span_1b" class="text">
				<fmt:message bundle="${storeText}" key="MO_Page_Results" > 
					<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
				</fmt:message>
				<span id="RecurringOrderDetailPagination_span_2b" class="paging">
					<c:if test="${beginIndex != 0}">	
						<a id="RecurringOrderDetailPagination_previous_link_2" href="javaScript:setCurrentId('RecurringOrderDetailPagination_previous_link_2'); if(submitRequest()){cursor_wait();
						wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE" />" />
					<c:if test="${beginIndex != 0}">
						</a>
					</c:if>
					<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
						<fmt:param><fmt:formatNumber value="${currentPage}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
					</fmt:message>
					<c:if test="${numEntries > endIndex }">
						<a id="RecurringOrderDetailPagination_next_link_2" href="javaScript:setCurrentId('RecurringOrderDetailPagination_next_link_2'); if(submitRequest()){cursor_wait();
						wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>'});}">
					</c:if>
					<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}" />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
					<c:if test="${numEntries > endIndex }">
						</a>
					</c:if>
				</span>
			</span>
		</div>
	</c:if>
</c:if>

<div id='actions_popup_widget_recurring_order' style='display:none'></div>
<div class="item_spacer_8px"></div>

<!-- END RecurringOrderTableDetailsDisplay.jsp -->
