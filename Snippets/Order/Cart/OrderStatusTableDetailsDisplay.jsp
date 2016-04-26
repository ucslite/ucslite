<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
  *****
  * This JSP page displays order status details in the My Account section. It is imported in OrderStatusTableDisplay.jsp.
  *****
--%>

<!-- BEGIN OrderStatusTableDetailsDisplay.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>

<%-- Start AjaxOrderStatusView --%>
 <wcf:url value="AjaxOrderStatusView" var="AjaxOrderStatusURL" type="Ajax">
											<wcf:param name="storeId" value="${WCParam.storeId}"/>
											<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
											<wcf:param name="langId" value="${WCParam.langId}"/>
											<wcf:param name="myAccountPage" value="true"/>
										</wcf:url>
<%-- end AjaxOrderStatusView --%>

<c:set var="beginIndex" value="${WCParam.beginIndex}" />
<c:if test="${empty beginIndex}">
	<c:set var="beginIndex" value="0" />
</c:if>
<c:set var="pageSize" value="${WCParam.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="${maxOrderItemsPerPage}"/>
</c:if>

<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>

<flow:ifEnabled feature="SideBySideIntegration">
	<c:set var="lastExternalOrderIds" value="${WCParam.lastExternalOrderIds}" />
	 <c:if test="${empty lastExternalOrderIds}">
	  <c:set var="lastExternalOrderIds" value="" />
	</c:if>
	<!-- used to check the order total change in external system -->
	<fmt:parseNumber var="recordSetTotal" value="${WCParam.recordSetTotal}" integerOnly="true" />
	 <c:if test="${empty recordSetTotal}">
	  <c:set var="recordSetTotal" value="0" />
	</c:if>
</flow:ifEnabled>

<c:set var="isProcessedOrdersTab" value="${param.selectedTab == 'PreviouslyProcessed' || WCParam.selectedTab == 'PreviouslyProcessed'}"/>
<c:set var="isWaitingForApprovalOrdersTab" value="${param.selectedTab == 'WaitingForApproval' || WCParam.selectedTab == 'WaitingForApproval'}"/>
<c:set var="isScheduledOrdersTab" value="${param.selectedTab == 'Scheduled' || WCParam.selectedTab == 'Scheduled'}"/>
<c:set var="contextId" value=""/>

<jsp:useBean id="now" class="java.util.Date" scope="page"/>

<c:set var="formattedTimeZone" value="${fn:replace(cookie.WC_timeoffset.value, '%2B', '+')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.75', ':45')}"/>
<c:set var="formattedTimeZone" value="${fn:replace(formattedTimeZone, '.5', ':30')}"/>

<c:choose>
	<c:when test="${isProcessedOrdersTab}">
		<c:set var="max" value="3"/>
		<c:set var="start" value="0"/>

		<c:if test="${param.isMyAccountMainPage == null || param.isMyAccountMainPage == false}">
			<c:set var="max" value="${pageSize}"/>
			<c:set var="start" value="${beginIndex}"/>
			<c:set var="contextId" value="ProcessedOrdersStatusDisplay_Context"/>
		</c:if>

		<fmt:formatNumber var="currentPage" value="${(start/max)+1}"/>
		<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>

		<c:choose>
			<c:when test="${param.isQuote eq true}">
				<wcf:rest var="allOrdersInThisCategoryResult" url="store/{storeId}/order">
					<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
					<wcf:param name="q" value="findQuoteByStatus"/>
					<wcf:param name="status" value="N,M,A,B,C,R,S,D,F,G"/>
					<wcf:param name="pageSize" value="${max}"/>
					<wcf:param name="pageNumber" value="${currentPage}"/>
				</wcf:rest>
			</c:when>
			<c:otherwise>
				<flow:ifEnabled feature="SideBySideIntegration">
					<c:forTokens var="splitStr" items="${lastExternalOrderIds}" delims=";" varStatus="status">
					  <c:if test="${status.last}">
						<c:set var="extOrderId" value="${splitStr}" />
					  </c:if>
					</c:forTokens>
					<wcf:rest var="allOrdersInThisCategoryResult" url="store/{storeId}/order">
						<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
						<wcf:param name="q" value="findByStatusExt"/>
						<wcf:param name="status" value="N,M,A,B,C,R,S,D,F,H"/>
						<wcf:param name="extOrderId" value="${extOrderId}"/>
						<wcf:param name="recordSetTotal" value="${recordSetTotal}"/>
						<wcf:param name="pageSize" value="${max}"/>
						<wcf:param name="pageNumber" value="${currentPage}"/>
					</wcf:rest>
				</flow:ifEnabled>
				<flow:ifDisabled feature="SideBySideIntegration">
					<wcf:rest var="allOrdersInThisCategoryResult" url="store/{storeId}/order/byStatus/{status}">
						<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
						<wcf:var name="status" value="N,M,A,B,C,R,S,D,F,G,L,X"/>
						<wcf:param name="pageSize" value="${max}"/>
						<wcf:param name="pageNumber" value="${currentPage}"/>
					</wcf:rest>
				</flow:ifDisabled>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:when test="${isWaitingForApprovalOrdersTab}">
		<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
		<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>
		<c:choose>
			<c:when test="${param.isQuote eq true}">
				<wcf:rest var="allOrdersInThisCategoryResult" url="store/{storeId}/order">
					<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
					<wcf:param name="q" value="findQuoteByStatus"/>
					<wcf:param name="status" value="W"/>
					<wcf:param name="pageSize" value="${pageSize}"/>
					<wcf:param name="pageNumber" value="${currentPage}"/>
				</wcf:rest>
			</c:when>
			<c:otherwise>
				<wcf:rest var="allOrdersInThisCategoryResult" url="store/{storeId}/order/byStatus/{status}">
					<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
					<wcf:var name="status" value="W"/>
					<wcf:param name="pageSize" value="${pageSize}"/>
					<wcf:param name="pageNumber" value="${currentPage}"/>
				</wcf:rest>
			</c:otherwise>
		</c:choose>
		<c:set var="contextId" value="WaitingForApprovalOrdersStatusDisplay_Context"/>
	</c:when>
	<c:when test="${isScheduledOrdersTab}">
		<flow:ifEnabled feature="ScheduleOrder">
			<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
			<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>
			<wcf:rest var="allOrdersInThisCategoryResult" url="store/{storeId}/order">
				<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
				<wcf:param name="q" value="findScheduledOrder"/>
				<wcf:param name="startTime" value=""/>
				<wcf:param name="pageSize" value="${pageSize}"/>
				<wcf:param name="pageNumber" value="${currentPage}"/>
			</wcf:rest>
			<c:if test="${empty allOrdersInThisCategoryResult && beginIndex >= pageSize}">
				<c:set var="beginIndex" value="${beginIndex - pageSize}"/>
				<wcf:rest var="allOrdersInThisCategoryResult" url="store/{storeId}/order">
					<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
					<wcf:param name="q" value="findScheduledOrder"/>
					<wcf:param name="startTime" value=""/>
					<wcf:param name="pageSize" value="${pageSize}"/>
					<wcf:param name="pageNumber" value="${currentPage}"/>
				</wcf:rest>
			</c:if>
			<c:set var="contextId" value="ScheduledOrdersStatusDisplay_Context"/>
		</flow:ifEnabled>
	</c:when>
</c:choose>
<c:set var="allOrdersInThisCategory" value="${allOrdersInThisCategoryResult.Order}"/>

<c:if test="${(param.isMyAccountMainPage == null) || (empty param.isMyAccountMainPage) || (param.isMyAccountMainPage == false)}">
	<c:if test="${beginIndex == 0}">
		<fmt:parseNumber var="recordSetTotal" value="${allOrdersInThisCategoryResult.recordSetTotal}" integerOnly="true" />
		<c:if test="${recordSetTotal > allOrdersInThisCategoryResult.recordSetCount}">
			<c:set var="pageSize" value="${allOrdersInThisCategoryResult.recordSetCount}" />
		</c:if>
	</c:if>
	<fmt:parseNumber var="recordSetTotal" value="${allOrdersInThisCategoryResult.recordSetTotal}" integerOnly="true" />
	<c:set var="numEntries" value="${recordSetTotal}"/>
	<c:if test="${numEntries > pageSize}">
		<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)}" maxFractionDigits="0"/>
		<fmt:formatNumber var="halfPageSize" value="${(pageSize/2)}" maxFractionDigits="0"/>
		<c:if test="${numEntries%pageSize < halfPageSize}">
			<fmt:formatNumber var="totalPages" value="${(numEntries+halfPageSize-1)/pageSize}" maxFractionDigits="0"/>
		</c:if>
		<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true"/>

		<c:choose>
			<c:when test="${beginIndex + pageSize >= numEntries}">
				<c:set var="endIndex" value="${numEntries}" />
			</c:when>
			<c:otherwise>
				<c:set var="endIndex" value="${beginIndex + pageSize}" />
			</c:otherwise>
		</c:choose>

		<fmt:formatNumber var="currentPage" value="${(beginIndex/pageSize)+1}"/>
		<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="true"/>

		<div id="OrderStatusDetailPagination">
			<span id="OrderStatusDetailPagination_span_1" class="text">
				<fmt:message bundle="${storeText}" key="MO_Page_Results" >
					<fmt:param><fmt:formatNumber value="${beginIndex + 1}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
					<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
				</fmt:message>
				<span id="OrderStatusDetailPagination_span_2" class="paging">
					<flow:ifEnabled feature="SideBySideIntegration">
						<c:set var="actualPageSize" value="${allOrdersInThisCategoryResult.recordSetCount}"/>
						<c:forEach var="orderIter" items="${allOrdersInThisCategory}" varStatus="status" begin="${actualPageSize-1}">
							<c:set var="lastOrder" value="${orderIter}"/>
						</c:forEach>
					</flow:ifEnabled>
					<c:if test="${beginIndex != 0}">
						<flow:ifEnabled feature="SideBySideIntegration">
							<a id="OrderStatusDetailPagination_link_1" href="javaScript:setCurrentId('OrderStatusDetailPagination_link_1'); if(submitRequest()){cursor_wait();
							MyAccountDisplay.updateRenderContextForPagination('${contextId}', '${beginIndex}', '${pageSize}', '${param.isQuote}', '${currentPage}', '', '${lastExternalOrderIds}', '', '${numEntries}');}">
						</flow:ifEnabled>
						<flow:ifDisabled feature="SideBySideIntegration">
							<a id="OrderStatusDetailPagination_link_1" href="javaScript:setCurrentId('OrderStatusDetailPagination_link_1'); if(submitRequest()){cursor_wait();
							wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex - pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','isQuote':'${param.isQuote}'});}">
						</flow:ifDisabled>
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
						<flow:ifEnabled feature="SideBySideIntegration">
							<a id="OrderStatusDetailPagination_link_2" href="javaScript:setCurrentId('OrderStatusDetailPagination_link_2'); if(submitRequest()){cursor_wait();
							MyAccountDisplay.updateRenderContextForPagination('${contextId}', '${beginIndex}', '${pageSize}', '${param.isQuote}', '${currentPage}', '${lastOrder.externalOrderID}', '${lastExternalOrderIds}', '1', '${numEntries}');}">
						</flow:ifEnabled>
						<flow:ifDisabled feature="SideBySideIntegration">
							<a id="OrderStatusDetailPagination_link_2" href="javaScript:setCurrentId('OrderStatusDetailPagination_link_2'); if(submitRequest()){cursor_wait();
							wc.render.updateContext('${contextId}',{'beginIndex':'<c:out value='${beginIndex + pageSize}'/>','pageSize':'<c:out value='${pageSize}'/>','isQuote':'${param.isQuote}'});}">
						</flow:ifDisabled>
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

<table border="0" cellpadding="0" cellspacing="0" class="order_status_table" summary="<c:choose><c:when test="${param.isQuote eq true}"><fmt:message bundle="${storeText}" key="MO_PROCESSED_QUOTES_TABLE_DESCRIPTION" /></c:when><c:otherwise><flow:ifEnabled feature="AllowReOrder"><fmt:message bundle="${storeText}" key="MO_PROCESSED_ORDERS_TABLE_DESCRIPTION" /></flow:ifEnabled><flow:ifDisabled feature="AllowReOrder"><fmt:message bundle="${storeText}" key="MO_PROCESSED_ORDERS_TABLE_DESCRIPTION_WO_REORDER" /></flow:ifDisabled></c:otherwise></c:choose>">
<fmt:parseNumber var="recordSetTotal" value="${allOrdersInThisCategoryResult.recordSetTotal}" integerOnly="true" />
<c:choose>
	<c:when test="${recordSetTotal <= 0}">
		<c:choose>
			<c:when test="${param.isQuote eq true}">
				<tr><td><fmt:message bundle="${storeText}" key="MO_NOQUOTESFOUND"/></td></tr>
			</c:when>
			<c:otherwise>
				<tr><td><fmt:message bundle="${storeText}" key="MO_NOORDERSFOUND"/></td></tr>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>

		<%--
			The variable columnStyle is used to set the CSS class for a table column depending on the type of the order.
			Its default value is 1, which corresponds to orders that have already been processed.
		--%>
		<c:set var="columnStyle" value="1"/>
		<c:if test="${isWaitingForApprovalOrdersTab}">
			<c:set var="columnStyle" value="2"/>
		</c:if>
		<c:if test="${isScheduledOrdersTab}">
			<c:set var="columnStyle" value="3"/>
		</c:if>

		<tr id="OrderStatusDetailsDisplayExt_ul_1" class="ul column_heading">
			<th scope="col" id="OrderStatusDetailsDisplayExt_li_header_1" class="li order_number_column_<c:out value="${columnStyle}"/>">
			<c:choose>
				<c:when test="${param.isQuote eq true}">
					<fmt:message bundle="${storeText}" key="MO_QUOTENUMBER" />
				</c:when>
				<c:otherwise>
						<c:set var="messageKey" value="MA_ORDERNUM"/>
						<c:if test="${isScheduledOrdersTab}">
							<c:set var="messageKey" value="MO_SCHEDULED_ORDER_NUMBER"/>
						</c:if>
						<fmt:message bundle="${storeText}" key="${messageKey}" />
				</c:otherwise>
			</c:choose>
			</th>
			<c:if test="${isProcessedOrdersTab}">
				<th scope="col" id="OrderStatusDetailsDisplayExt_li_header_2" class="li order_date_column_<c:out value="${columnStyle}"/>">
				<c:choose>
					<c:when test="${param.isQuote eq true}">
						<fmt:message bundle="${storeText}" key="MO_QUOTEDATE" />
					</c:when>
					<c:otherwise>
						<fmt:message bundle="${storeText}" key="MA_ORDER_DATE" />
					</c:otherwise>
				</c:choose>
				</th>
			</c:if>
			<c:if test="${isWaitingForApprovalOrdersTab}"><th scope="col" id="OrdersStatusDetailsDisplayExt_li_header_3" class="li last_updated_column_<c:out value="${columnStyle}"/>"><fmt:message bundle="${storeText}" key="MO_LAST_UPDATED" /></th></c:if>
			<c:if test="${showPONumber && !isScheduledOrdersTab}"><th scope="col" id="OrderStatusDetailsDisplayExt_li_header_4" class="li purchase_order_column_<c:out value="${columnStyle}"/>"><fmt:message bundle="${storeText}" key="MO_PURCHASEORDER" /></th></c:if>
			<c:if test="${isProcessedOrdersTab}"><th scope="col" id="OrderStatusDetailsDisplayExt_li_header_5" class="li status_column_<c:out value="${columnStyle}"/>"><fmt:message bundle="${storeText}" key="MO_SUBSCRIPTION_STATUS" /></th></c:if>
			<c:if test="${isScheduledOrdersTab}"><flow:ifEnabled feature="ScheduleOrder"><th scope="col" id="OrderStatusDetailsDisplayExt_li_header_6" class="li next_order_date_column_<c:out value="${columnStyle}"/>"><fmt:message bundle="${storeText}" key="MO_NEXT_ORDER" /></th></flow:ifEnabled></c:if>
			<th scope="col" id="OrderStatusDetailsDisplayExt_li_header_7" class="li total_price_column_<c:out value="${columnStyle}"/>"><fmt:message bundle="${storeText}" key="TOTAL_PRICE" /></th>
			<c:if test="${!isWaitingForApprovalOrdersTab}"><th scope="col" id="OrderStatusDetailsDisplayExt_li_header_8" class="li option_<c:out value="${columnStyle}"/>"><span class="spanacce"><fmt:message bundle="${storeText}" key="MO_ACCE_BUTTON_COLUMN" /></span></th></c:if>
		</tr>

		<c:forEach var="order" items="${allOrdersInThisCategory}" varStatus="status">
		<%-- Start OrderCancelUrl --%>		
		<wcf:url value="AjaxOrderCancel" var="OrderCancelUrl" type="Ajax">
											<wcf:param name="orderId" value="${order.orderId}"/>
											<wcf:param name="URL" value=""/>
											<wcf:param name="storeId" value="${WCParam.storeId}"/>
											<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
											<wcf:param name="langId" value="${WCParam.langId}"/>
										</wcf:url>
			<%-- End OrderCancelUrl --%>
			<c:choose>
				<c:when test="${param.isQuote eq true}">
					<c:set var="quote" value="${order}"/>
					<c:set var="order" value="${quote.orderTemplate}"/>
					<c:choose>
						<c:when test="${quote.quoteIdentifier.externalQuoteID != null}">
							<c:set var="objectId" value="${quote.quoteIdentifier.externalQuoteID}"/>
							<c:set var="objectIdParam" value="externalQuoteId"/>
						</c:when>
						<c:otherwise>
							<c:set var="objectId" value="${quote.quoteIdentifier.uniqueID}"/>
							<c:set var="objectIdParam" value="quoteId"/>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<c:choose>
						<c:when test="${!empty order.externalOrderID}">
							<c:set var="objectId" value="${order.externalOrderID}"/>
							<c:set var="objectIdParam" value="externalOrderId"/>
						</c:when>
						<c:otherwise>
							<c:set var="objectId" value="${order.orderId}"/>
							<c:set var="objectIdParam" value="orderId"/>
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>

			<%-- Need to reset currencyFormatterDB as initialized in JSTLEnvironmentSetup.jspf, as the currency code used there is from commandContext. For order history we want to display with currency used when the order was placed. --%>
			<c:choose>
				<c:when test ="${order.grandTotal != null}">
					<c:set var="key1" value="store/${storeId}/currency_format+byCurrency+${order.grandTotalCurrency}+-1+${langId}"/>
					<c:set var="currencyFormatterDB" value="${cachedOnlineStoreMap[key1]}"/>
					<c:if test="${empty currencyFormatterDB}">
						<wcf:rest var="getCurrencyFormatResponse" url="store/{storeId}/currency_format" cached="true">
							<wcf:var name="storeId" value="${storeId}" />
							<wcf:param name="q" value="byCurrency" />
							<wcf:param name="currency" value="${order.grandTotalCurrency}" />
							<wcf:param name="numberUsage" value="-1" />
							<wcf:param name="langId" value="${langId}" />
						</wcf:rest>
						<c:set var="currencyFormatterDB" value="${getCurrencyFormatResponse.resultList[0]}" scope="request" />
						<wcf:set target = "${cachedOnlineStoreMap}" key="${key1}" value="${currencyFormatterDB}"/>
					</c:if>

					<c:set var="currencyDecimal" value="${currencyFormatterDB.decimalPlaces}"/>

					<c:if test="${order.grandTotalCurrency == 'KRW'}">
						<c:set property="currencySymbol" value="&#8361;" target="${currencyFormatterDB}"/>
					</c:if>
					<c:if test="${order.grandTotalCurrency == 'PLN'}">
						<c:set property="currencySymbol" value="z&#322;" target="${currencyFormatterDB}"/>
					</c:if>
					<c:if test="${order.grandTotalCurrency == 'ILS' && locale == 'iw_IL'}">
						<c:set property="currencySymbol" value="&#1513;&#1524;&#1495;" target="${currencyFormatterDB}"/>
					</c:if>

					<%-- These variables are used to hold the currency symbol --%>
					<c:choose>
						<c:when test="${locale == 'ar_EG' && order.grandTotalCurrency == 'EGP'}">
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

			<fmt:message bundle="${storeText}" key="X_DETAILS"  var="OrderDetailBreadcrumbLinkLabel">
				<fmt:param>
					<flow:ifEnabled feature="SideBySideIntegration">
					   <c:out value="${order.orderId}"/>
					</flow:ifEnabled>
					<flow:ifDisabled feature="SideBySideIntegration">
						<c:out value="${objectId}"/>
					</flow:ifDisabled>
				</fmt:param>
			</fmt:message>

			<tr id="OrderStatusDetailsDisplayExt_ul_2_${status.count}" class="ul row">
					<wcf:url value="OrderDetail" var="OrderDetailUrl1">
						<wcf:param name="${objectIdParam}" value="${objectId}"/>
						<wcf:param name="orderStatusCode" value="${order.orderStatus}"/>
						<wcf:param name="storeId" value="${WCParam.storeId}"/>
						<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
						<wcf:param name="langId" value="${WCParam.langId}"/>
						<c:if test="${param.isQuote eq true}">
							<wcf:param name="isQuote" value="true"/>
						</c:if>
					</wcf:url>

				<td id="OrderStatusDetailsDisplayExt_order_number_<c:out value='${status.count}'/>" class="hover_underline li order_number_column_<c:out value="${columnStyle}"/>">
					<span>
					<c:choose>
							<c:when test="${!empty objectId}">
								<flow:ifEnabled feature="SideBySideIntegration">
									<c:out value="${order.orderId}"/>
								</flow:ifEnabled>
								<flow:ifDisabled feature="SideBySideIntegration">
									<c:out value="${objectId}"/>
								</flow:ifDisabled>
							</c:when>
							<c:otherwise>
								<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
							</c:otherwise>
					</c:choose>
					</span>
					<a href="<c:out value='${OrderDetailUrl1}'/>" class="myaccount_link" id="WC_OrderStatusDisplay_Link_2b_<c:out value='${status.count}'/>"><fmt:message bundle="${storeText}" key="DETAILS" /></a>
				</td>
				<c:if test="${isProcessedOrdersTab}">
					<td id="OrderStatusDetailsDisplayExt_order_date_<c:out value='${status.count}'/>" class="li order_date_column_<c:out value="${columnStyle}"/>">
						<c:remove var="orderDate"/>
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="orderDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
						</c:catch>
						<c:if test="${empty orderDate}">
							<c:catch>
								<fmt:parseDate parseLocale="${dateLocale}" var="orderDate" value="${order.placedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
							</c:catch>
						</c:if>
						<span>
						<c:choose>
							<c:when test="${!empty orderDate}">
								<fmt:formatDate value="${orderDate}" dateStyle="long" timeZone="${formattedTimeZone}"/>
							</c:when>
							<c:otherwise>
								<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
							</c:otherwise>
						</c:choose>

						</span>
					</td>
				</c:if>
				<c:if test="${isWaitingForApprovalOrdersTab}">
					<td id="OrderStatusDetailsDisplayExt_last_updated_<c:out value='${status.count}'/>" class="li last_updated_column_<c:out value="${columnStyle}"/>">
						<c:catch>
							<fmt:parseDate parseLocale="${dateLocale}" var="lastUpdateDate" value="${order.lastUpdateDate}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
						</c:catch>
						<c:if test="${empty lastUpdateDate}">
							<c:catch>
								<fmt:parseDate parseLocale="${dateLocale}" var="lastUpdateDate" value="${order.lastUpdateDate}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
							</c:catch>
						</c:if>
						<span><fmt:formatDate value="${lastUpdateDate}" dateStyle="long" timeZone="${formattedTimeZone}"/></span>
					</td>
				</c:if>
				<c:if test="${showPONumber && !isScheduledOrdersTab}">
					<td id="OrderStatusDetailsDisplayExt_purchase_order_<c:out value='${status.count}'/>" class="li purchase_order_column_<c:out value="${columnStyle}"/>">
						<c:set var="purchaseOrderNumber" value="${order.buyerPONumber}"/>
						<span id="WC_OrderStatusDisplay_TableCell_34a_<c:out value='${status.count}'/>">
							<c:choose>
								<c:when test="${empty purchaseOrderNumber}">
									<fmt:message bundle="${storeText}" key="MO_NONE" />
								</c:when>
								<c:otherwise>
									<c:remove var="purchaseOrderBean"/>
									<wcf:rest var="purchaseOrderBean" url="/store/{storeId}/cart/@self/buyer_purchase_order/{buyerPurchaseOrderId}">
										<wcf:var name="storeId" value="${storeId}" />
										<wcf:var name="buyerPurchaseOrderId" value="${purchaseOrderNumber}" />
									</wcf:rest>
									<c:choose>
										<c:when test="${empty purchaseOrderBean.resultList[0].purchaseOrderNumber}">
											<fmt:message bundle="${storeText}" key="MO_NONE" />
										</c:when>
										<c:otherwise>
											<c:out value='${purchaseOrderBean.resultList[0].purchaseOrderNumber}'/>
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						</span>
					</td>
				</c:if>
				<c:if test="${isProcessedOrdersTab}">
					<td id="OrderStatusDetailsDisplayExt_status_<c:out value='${status.count}'/>" class="li status_column_<c:out value="${columnStyle}"/>">
						<flow:ifEnabled feature="SideBySideIntegration">
							<c:choose>
								<c:when test="${!empty order.orderStatus}">
									<c:set var="ordStatus" value="${order.orderStatus }"/>
									<c:if test="${order.orderStatus eq 'H' }">
										<c:set var="ordStatus" value="M"/>
									</c:if>
									<span><fmt:message bundle="${storeText}" key="MO_OrderStatus_${ordStatus}"/></span>
								</c:when>
								<c:otherwise>
									<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
								</c:otherwise>
							</c:choose>
						</flow:ifEnabled>
						<flow:ifDisabled feature="SideBySideIntegration">
							<c:choose>
								<c:when test="${!empty order.orderStatus}">
										<span><fmt:message bundle="${storeText}" key="MO_OrderStatus_${order.orderStatus}" /></span>
								</c:when>
								<c:otherwise>
									<fmt:message bundle="${storeText}" key="MO_NOT_AVAILABLE" />
								</c:otherwise>
							</c:choose>
						</flow:ifDisabled>
					</td>
				</c:if>
				<c:if test="${isScheduledOrdersTab}">
					<flow:ifEnabled feature="ScheduleOrder">
						<td id="OrderStatusDetailsDisplayExt_next_order_date_<c:out value='${status.count}'/>" class="li next_order_date_column_<c:out value="${columnStyle}"/>">
							<fmt:parseNumber var="interval" value="${order.orderScheduleInfo.interval}" integerOnly="true"/>
							<c:catch>
								<fmt:parseDate parseLocale="${dateLocale}" var="startTime" value="${order.orderScheduleInfo.startTime}" pattern="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" timeZone="GMT"/>
							</c:catch>
							<c:if test="${empty startTime}">
								<c:catch>
									<fmt:parseDate parseLocale="${dateLocale}" var="startTime" value="${order.orderScheduleInfo.startTime}" pattern="yyyy-MM-dd'T'HH:mm:ss'Z'" timeZone="GMT"/>
								</c:catch>
							</c:if>
							<c:choose>
								<c:when test="${startTime >= now}">
									<fmt:formatDate var="formattedNextOrderDate" value="${startTime}" dateStyle="long" timeZone="${formattedTimeZone}"/>
									<span><c:out value="${formattedNextOrderDate}"/></span>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${interval == null || empty (fn:trim(interval)) || interval == 0}">
											<span><fmt:message bundle="${storeText}" key="MO_NOT_APPLICABLE" /></span>
										</c:when>
										<c:otherwise>
											<c:set var="nextOrderDate" value="${now}"/>

											<%-- The variable stores the difference in seconds between now and the scheduled order start time. The original unit is in milliseconds. --%>
											<fmt:parseNumber var="timeDifference" value="${(now.time - startTime.time)/1000}" integerOnly="true"/>

											<fmt:parseNumber var="secondsUntilNextOrder" value="${interval - (timeDifference % interval)}" integerOnly="true"/>
											<fmt:parseNumber var="daysUntilNextOrder" value="${secondsUntilNextOrder / 86400}" integerOnly="true" parseLocale="en_US"/>

											<%-- If daysUntilNextOrder == 0, then it means that the next order is tomorrow. --%>
											<c:if test="${daysUntilNextOrder == 0}">
												<c:set var="daysUntilNextOrder" value="${daysUntilNextOrder + 1}"/>
											</c:if>

											<fmt:parseNumber var="now_year" value="${now.year + 1900}" integerOnly="true"/>
											<fmt:parseNumber var="now_month" value="${now.month + 1}" integerOnly="true"/>
											<fmt:parseNumber var="now_date" value="${now.date}" integerOnly="true"/>

											<c:set var="incrementMonth" value="false"/>
											<c:set var="daysInThisMonth" value="31"/>
											<c:set var="newDate" value="${now_date + daysUntilNextOrder}"/>

											<c:if test="${now_month == 4 || now_month == 6 || now_month == 9 || now_month == 11}">
												<c:set var="daysInThisMonth" value="30"/>
											</c:if>
											<c:if test="${now_month == 2}">
												<c:set var="daysInThisMonth" value="28"/>
												<c:if test="${((now_year % 4) == 0 && (now_year % 100) != 0) || (now_year % 400) == 0}">
													<c:set var="daysInThisMonth" value="29"/>
												</c:if>
											</c:if>

											<c:if test="${newDate > daysInThisMonth}">
												<c:set var="newDate" value="${newDate - daysInThisMonth}"/>
												<c:set var="incrementMonth" value="true"/>
											</c:if>

											<c:set var="nextOrderDate_year" value="${now_year}"/>
											<c:set var="nextOrderDate_month" value="${now_month}"/>
											<c:set var="nextOrderDate_date" value="${newDate}"/>
											<c:if test="${incrementMonth}">
												<c:set var="nextOrderDate_month" value="${now_month + 1}"/>
												<c:if test="${nextOrderDate_month > 12}">
													<c:set var="nextOrderDate_month" value="${nextOrderDate_month - 12}"/>
													<c:set var="nextOrderDate_year" value="${now_year + 1}"/>
												</c:if>
											</c:if>
											<fmt:parseDate parseLocale="${dateLocale}" var="nextOrderDate" value="${nextOrderDate_year}-${nextOrderDate_month}-${nextOrderDate_date}" pattern="yyyy-MM-dd" timeZone="${formattedTimeZone}"/>
											<fmt:formatDate var="formattedNextOrderDate" value="${nextOrderDate}" dateStyle="long" timeZone="${formattedTimeZone}"/>
											<span><c:out value="${formattedNextOrderDate}"/></span>
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						</td>
					</flow:ifEnabled>
				</c:if>
				<td id="OrderStatusDetailsDisplayExt_grand_total_<c:out value='${status.count}'/>" class="li total_price_column_<c:out value="${columnStyle}"/>">

					<span class="price">
					<c:choose>
						<c:when test="${order.grandTotal != null}">
							<c:choose>
								<c:when test="${!empty order.grandTotal}">
									<fmt:formatNumber value="${order.grandTotal}" type="currency" maxFractionDigits="${currencyDecimal}" currencySymbol="${CurrencySymbolToFormat}"/>
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
				<td id="OrderStatusDetailsDisplayExt_option_<c:out value='${status.count}'/>" class="li option_<c:out value="${columnStyle}"/>">
					<c:choose>
						<c:when test="${isProcessedOrdersTab}">

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
											<wcf:param name="inventoryValidation" value="true"/>
										</wcf:url>
										<div id="OrderStatusDetailsDisplayExt_option_button_1_<c:out value='${status.count}'/>" class="option_button">
											<div class="option_button">
												<flow:ifEnabled feature="SideBySideIntegration">
													<c:if test="${ordStatus != 'X'}">
														<c:choose>
															<c:when test="${objectIdParam=='externalOrderId'}">
																<wcf:url value="AjaxSSFSOrderCopy" var="SSFSOrderCopyUrl" type="Ajax">
																	<wcf:param name="OrderHeaderKey" value="${objectId}"/>
																	<wcf:param name="OrderNo" value="${order.orderId}"/>
																	<wcf:param name="toOrderId" value=".**."/>
																	<wcf:param name="calculate" value="1"/>
																	<wcf:param name="URL" value="AjaxOrderItemDisplayView"/>
																	<wcf:param name="storeId" value="${WCParam.storeId}"/>
																	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
																	<wcf:param name="langId" value="${WCParam.langId}"/>
																	<wcf:param name="inventoryValidation" value="true"/>
																</wcf:url>
																<a href="#" role="button" class="button_primary" id="OrderStatusDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>" width="100%" onclick="javaScript:setCurrentId('OrderStatusDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>'); MyAccountDisplay.prepareSSFSOrderCopy('<c:out value='${SSFSOrderCopyUrl}'/>');">
																	<div class="left_border"></div>
																	<div class="button_text"><fmt:message bundle="${storeText}" key="MO_REORDER" /></div>
																	<div class="right_border"></div>
																</a>
															</c:when>
															<c:otherwise>
																<a href="#" role="button" class="button_primary" id="OrderStatusDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>" width="100%" onclick="javaScript:setCurrentId('OrderStatusDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>'); MyAccountDisplay.prepareOrderCopy('<c:out value='${OrderCopyUrl}'/>');">
																	<div class="left_border"></div>
																	<div class="button_text"><fmt:message bundle="${storeText}" key="MO_REORDER" /></div>
																	<div class="right_border"></div>
																</a>
															</c:otherwise>
														</c:choose>
													</c:if>
												</flow:ifEnabled>
												<flow:ifDisabled feature="SideBySideIntegration">
													<c:choose>
														<c:when test="${env_shopOnBehalfSessionEstablished eq 'true'}">
															<%-- CSR can re-order, cancel or modify order --%>
															<div class="option_button"> 
																<div id="showOptions_<c:out value='${order.orderId}'/>" class="option_button">
																	<a role="button" aria-labelledby="history_order_actions_button_text" href="javascript:void(0);" class="button_primary" onkeypress="javaScript:MyAccountDisplay.showActionsPopup(event,'showOptions_<c:out value='${order.orderId}'/>','actions_popup_<c:out value='${order.orderId}'/>', 'actions_popup_widget_recurring_order');" onclick="javaScript:MyAccountDisplay.showActionsPopup(null,'showOptions_<c:out value='${order.orderId}'/>','actions_popup_<c:out value='${order.orderId}'/>', 'actions_popup_widget_history_order');" width="100%" id="HistoryOrderDetailsDisplayExt_option_button_3b_<c:out value='${order.orderId}'/>" tabindex="0">
																		<div class="left_border"></div>
																		<div class="button_text" id="history_order_actions_button_text"><fmt:message bundle="${storeText}" key="MO_ACTIONS" /><img class="actions_down_arrow" src="<c:out value="${jspStoreImgDir}${vfileColor}transparent.gif"/>" alt="<fmt:message bundle="${storeText}" key='DOWN_ARROW_IMAGE'/>"/></div>
																		<div class="right_border"></div>
																	</a>
																</div>
															</div>
															<div id="actions_popup_<c:out value='${order.orderId}'/>" style="display:none" >
																<div id="actions_popup_div1_<c:out value='${order.orderId}'/>" class="actions_popup hover_underline">
																	<div id="actions_popup_reorder_<c:out value='${order.orderId}'/>" class="reorder">
																		<a href="javaScript:setCurrentId('HistoryOrderDetailsDisplayExt_option_button_3b_<c:out value='${order.orderId}'/>'); MyAccountDisplay.prepareOrderCopy('<c:out value='${OrderCopyUrl}'/>');" width="100%" id="HistoryOrderDetailsDisplayExt_option_button_link_3_<c:out value='${order.orderId}'/>" class="link"><fmt:message bundle="${storeText}" key="MO_REORDER" /></a>
																	</div>
																	<c:if test = "${fn:contains(validOrderStatusForCancel,order.orderStatus)}">
																		<div id="actions_popup_cancel_<c:out value='${order.orderId}'/>" class="cancel">
																			<a href="javaScript:setCurrentId('HistoryOrder_CancelButton_Ajax_<c:out value='${order.orderId}'/>'); dijit.byId('actions_popup_widget_history_order').hide(); onBehalfUtilitiesJS.cancelOrder('${order.orderId}');" width="100%" id="HistoryOrder_CancelButton_Ajax_<c:out value='${order.orderId}'/>" class="link"><fmt:message bundle="${storeText}" key="CANCEL_ORDER_CSR" /></a>
																		</div>
																	</c:if>
																</div>
															</div>
														</c:when>
														<c:otherwise>
															<%-- Just display REORDER button for Shopper --%>
															<a href="#" role="button" class="button_primary" id="OrderStatusDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>" width="100%" onclick="javaScript:setCurrentId('OrderStatusDetailsDisplayExt_option_button_link_1_<c:out value='${status.count}'/>'); MyAccountDisplay.prepareOrderCopy('<c:out value='${OrderCopyUrl}'/>');">
																<div class="left_border"></div>
																<div class="button_text"><fmt:message bundle="${storeText}" key="MO_REORDER" /></div>
																<div class="right_border"></div>
															</a>		
															
															<c:if test="${order.orderStatus eq 'M'}">
															<a href="javaScript:CommonControllersDeclarationJS.setControllerURL('OrderStatusDisplay_Controller','<c:out value='${AjaxOrderStatusURL}'/>'); prepareOrderCancel('<c:out value='${OrderCancelUrl}'/>');" role="button" class="button_primary" id="Lab2_cancel" width="100%" >
																<div class="left_border"></div>
																<div class="button_text">Cancel</div>												
																<div class="right_border"></div>
															</a>
															</c:if>
																									
														</c:otherwise>
													</c:choose>
												</flow:ifDisabled>
											</div>
										</div>
									</c:if>
								</flow:ifEnabled>

						</c:when>
						<c:when test="${isScheduledOrdersTab}">
							<flow:ifEnabled feature="ScheduleOrder">

									<div id="OrderStatusDetailsDisplayExt_option_button_3_<c:out value='${status.count}'/>" class="option_button">
										<a href="#" role="button" class="button_primary" id="OrderStatusDetailsDisplayExt_option_button_link_3_<c:out value='${status.count}'/>" width="100%" onclick="javaScript:setCurrentId('OrderStatusDetailsDisplayExt_option_button_link_3_<c:out value='${status.count}'/>'); MyAccountDisplay.cancelScheduledOrder('<c:out value='${objectId}'/>');">
											<div class="left_border"></div>
											<div class="button_text"><fmt:message bundle="${storeText}" key="MO_CancelButton" /></div>
											<div class="right_border"></div>
										</a>
									</div>

							</flow:ifEnabled>
						</c:when>
					</c:choose>
				</td>
			</tr>
		</c:forEach>
	</c:otherwise>
</c:choose>
</table>
<div id='actions_popup_widget_history_order' style='display:none'></div>
<div class="item_spacer_8px"></div>
<!-- END OrderStatusTableDetailsDisplay.jsp -->
