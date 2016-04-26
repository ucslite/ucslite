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
<!-- BEGIN CheckoutLogon.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
 
<!-- Start - JSP File Name:  CheckoutLogon.jsp -->
<wcf:url var="OrderCalculateURL" value="OrderShippingBillingView" type="Ajax">
	<wcf:param name="langId" value="${langId}" />						
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="shipmentType" value="single" />
</wcf:url>

<c:set var="guestUserURL" value="${OrderCalculateURL}"/>
<c:if test="${userType eq 'G'}">
	<c:set var="validAddressId" value=""/>
	<%-- The below getdata statment for UsableShippingInfo can be removed if the order services can return order details and shipping details in same service call --%>
	<wcf:rest var="orderUsableShipping" url="store/{storeId}/cart/@self/usable_shipping_info" scope="request">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:param name="pageSize" value="1"/>
		<wcf:param name="pageNumber" value="1"/>
	</wcf:rest>
	<c:forEach var="usableAddress" items="${orderUsableShipping.usableShippingAddress}">
		<c:if test="${!empty usableAddress.nickName && usableAddress.nickName != profileBillingNickname}" >
			<c:set var="validAddressId" value="true"/>
		</c:if>
	</c:forEach>
	<c:if test="${empty validAddressId && order.x_isPersonalAddressesAllowedForShipping && (!env_contractSelection || (env_contractSelection && WCParam.guestChkout == '1'))}" >
		<wcf:url var="guestUserURL" value="UnregisteredCheckoutView" type="Ajax">
			<wcf:param name="langId" value="${langId}" />						
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		</wcf:url>
	</c:if>
</c:if>

<wcf:url var="PhysicalStoreSelectionURL" value="CheckoutStoreSelectionView">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="fromPage" value="ShoppingCart" />
</wcf:url>

<c:if test="${userType != 'G'}">
	<%-- See if this user has quick checkout profile created or not, if quick checkout enabled --%>
	<flow:ifEnabled feature="quickCheckout">
		<wcf:rest var="quickOrder" url="store/{storeId}/order/byStatus/{status}">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
			<wcf:var name="status" value="Q"/>
		</wcf:rest>
		<c:if test="${!empty quickOrder.Order}">
			<c:choose>
				<c:when test="${isBrazilStore}">
					<%-- See if this user has more info in the quick checkout profile than just the CPF number --%>
					<c:set var="person" value="${requestScope.person}"/>
					<c:if test="${empty person || person==null}">
						<wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
							<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
						</wcf:rest>
					</c:if>
					<c:if test="${!empty person.checkoutProfile[0].protocolData[1].value}">
						<c:set var="quickCheckoutProfile" value="true"/>
					</c:if>
				</c:when>
				<c:otherwise>
					<c:set var="quickCheckoutProfile" value="true"/>
				</c:otherwise>
			</c:choose>
		</c:if>
	</flow:ifEnabled>
</c:if>

<c:if test="${userType == 'G'}">	
	<wcf:url var="orderMove" value="RESTMoveOrderItem" type="Ajax">		
		<wcf:param name="toOrderId" value="."/>
		<flow:ifEnabled feature="MultipleActiveOrders">
			<wcf:param name="deleteIfEmpty" value="."/>
			<wcf:param name="fromOrderId" value="."/>
		</flow:ifEnabled>
		<flow:ifDisabled feature="MultipleActiveOrders">
			<wcf:param name="deleteIfEmpty" value="*"/>
			<%-- MultipleActiveOrders is disabled. Order merging behavior should be the same as B2C --%>
			<wcf:param name="fromOrderId" value="*"/>
		</flow:ifDisabled>	
		<wcf:param name="continue" value="1"/>
		<wcf:param name="createIfEmpty" value="1"/>
		<wcf:param name="calculationUsageId" value="-1"/>
		<wcf:param name="updatePrices" value="0"/>
	</wcf:url>
		
	<wcf:url var="ForgetPasswordURL" value="ResetPasswordGuestErrorView">
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="storeId" value="${WCParam.storeId}" />
		<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		<wcf:param name="state" value="forgetpassword" />
	</wcf:url>	

	<form method="post" name="AjaxLogon" id="AjaxLogon" action="Logon">
		<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}"/>" id="WC_RememberMeLogonForm_FormInput_storeId_In_AjaxLogon_1"/>
		<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}"/>" id="WC_RememberMeLogonForm_FormInput_catalogId_In_AjaxLogon_1"/>
		<input type="hidden" name="URL" value="" id="WC_AccountDisplay_FormInput_URL_In_Logon_1" />
		<c:choose>
			<c:when test="${!empty WCParam.ErrorCode && WCParam.ErrorCode == '2430'}">						
				<script type="text/javascript">
				document.location.href = "ResetPasswordForm?storeId="
						+ <c:out value="${WCParam.storeId}"/> + "&catalogId=" + <c:out value="${WCParam.catalogId}"/>
						+ "&langId=" + <c:out value="${langId}"/> + "&errorCode=" + <c:out value="${WCParam.ErrorCode}"/>;
				</script>
			</c:when>
			<c:otherwise>
				<input type="hidden" name="reLogonURL" value="AjaxOrderItemDisplayView" id="WC_RememberMeLogonForm_FormInput_reLogonURL_In_AjaxLogon_1"/>
			</c:otherwise>
		</c:choose>
		<input type="hidden" name="errorViewName" value="AjaxOrderItemDisplayView" id="WC_RememberMeLogonForm_FormInput_errorViewName_In_AjaxLogon_1"/>	

		<div class="top_border" id="WC_CheckoutLogonf_div_0">
			<div id="customers_new_or_returning">
				<div class="new" id="WC_CheckoutLogonf_div_1">
					<h2><fmt:message bundle="${storeText}" key="SHOPCART_NEW_CUSTOMER"/></h2>
					<p><fmt:message bundle="${storeText}" key="SHOPCART_CHECKOUT_WITHOUT_SIGNING"/></p>
					<br />
					<p><fmt:message bundle="${storeText}" key="SHOPCART_TEXT1"/></p>
					<br />
					<p><fmt:message bundle="${storeText}" key="SHOPCART_TEXT2"/></p>
					<div class="new_returning_button" id="WC_CheckoutLogonf_div_2">
						<div class="button_align" id="WC_CheckoutLogonf_div_3">
							<a href="#" role="button" class="button_primary" id="guestShopperContinue" onclick="javascript:if(CheckoutHelperJS.canCheckoutContinue('<c:out value="${userType}"/>') && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){TealeafWCJS.processDOMEvent(event);ShipmodeSelectionExtJS.guestShopperContinue('<c:out value='${guestUserURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}return false;">
								<div class="left_border"></div>
								<div class="button_text"><fmt:message bundle="${storeText}" key="SHOPCART_CONTINUE" /></div>
								<div class="right_border"></div>
							</a>
						</div>
					</div>
				</div>
				
				<c:if test="${env_shopOnBehalfSessionEstablished eq 'false'}">
					<%-- If onBehalf session is established, then it is CSR shopping as guest. So cannot log-in as user. --%>
					<div class="returning" id="WC_CheckoutLogonf_div_4">
						<h2><fmt:message bundle="${storeText}" key="SHOPCART_TEXT3"/></h2>
						<p><fmt:message bundle="${storeText}" key="SHOPCART_TEXT4"/></p>
						<br />
						<p><label for="WC_CheckoutLogon_FormInput_logonId"><fmt:message bundle="${storeText}" key="SHOPCART_USERNAME"/></label></p>
						<p>
							<input id="WC_CheckoutLogon_FormInput_logonId" name="logonId" type="text" size="25" onchange="javaScript:TealeafWCJS.processDOMEvent(event);" onkeypress="if(event.keyCode==13){javascript:if(CheckoutHelperJS.canCheckoutContinue() && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){ShipmodeSelectionExtJS.guestShopperLogon('javascript:LogonForm.SubmitAjaxLogin(document.AjaxLogon)', '<c:out value='${orderMove}'/>', '<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}}" />
						</p>
						<br />
						<p><label for="WC_CheckoutLogon_FormInput_logonPassword"><fmt:message bundle="${storeText}" key="SHOPCART_PASSWORD"/></label></p>
						<p>
							<input id="WC_CheckoutLogon_FormInput_logonPassword" name="logonPassword" type="password" autocomplete="off" size="25" onchange="javaScript:TealeafWCJS.processDOMEvent(event);" onkeypress="if(event.keyCode==13){javascript:if(CheckoutHelperJS.canCheckoutContinue() && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){ShipmodeSelectionExtJS.guestShopperLogon('javascript:LogonForm.SubmitAjaxLogin(document.AjaxLogon)', '<c:out value='${orderMove}'/>', '<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}}" />
						</p>
						<p><a href="<c:out value="${ForgetPasswordURL}"/>" class="myaccount_link hover_underline" id="WC_CheckoutLogonf_links_1"><fmt:message bundle="${storeText}" key="SHOPCART_FORGOT"/></a></p>
						<div class="new_returning_button" id="WC_CheckoutLogonf_div_5">
							<div class="button_align" id="WC_CheckoutLogonf_div_6">
								<a href="#" role="button" class="button_primary" id="guestShopperLogon" onclick="javascript:TealeafWCJS.processDOMEvent(event);if(CheckoutHelperJS.canCheckoutContinue() && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){ShipmodeSelectionExtJS.guestShopperLogon('javascript:LogonForm.SubmitAjaxLogin(document.AjaxLogon)', '<c:out value='${orderMove}'/>', '<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}return false;">
									<div class="left_border"></div>
									<div class="button_text"><fmt:message bundle="${storeText}" key="SHOPCART_SIGNIN" /></div>
									<div class="right_border"></div>
								</a>
							</div>
						</div>
					</div>
				</c:if>
			</div>
		</div>
	 	<br clear="all" />
	 	<br />
	</form>
</c:if>

<div id="WC_CheckoutLogonf_div_9">
	<%-- User is not a guest user AND (order is NOT locked OR locked by logged in CSR ), then display Checkout Button --%>
	<c:if test="${userType != 'G' && (currentOrderLocked != 'true' || currentOrderStatus_CSR == 'locked')}">
		<div class="left" id="shopcartCheckoutButton">
			<c:choose>
				<c:when test="${requestScope.allContractsValid}">
					<div class="button_align left" id="WC_CheckoutLogonf_div_10">
					<a href="#" role="button" class="button_primary" id="shopcartCheckout" tabindex="0" onclick="javascript:TealeafWCJS.processDOMEvent(event);if(CheckoutHelperJS.canCheckoutContinue('<c:out value="${userType}"/>') && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){ShipmodeSelectionExtJS.registeredUserContinue('<c:out value='${OrderCalculateURL}'/>', '<c:out value='${PhysicalStoreSelectionURL}'/>');}return false;">
				</c:when>
				<c:otherwise>
					<div class="disabled left" id="WC_CheckoutLogonf_div_10">
					<a role="button" class="button_primary" id="shopcartCheckout" tabindex="0" onclick="javascript:TealeafWCJS.processDOMEvent(event);setPageLocation('#')">
				</c:otherwise>
			</c:choose>
			<div class="left_border"></div>
			<div class="button_text"><fmt:message bundle="${storeText}" key="SHOPCART_CHECKOUT" /></div>
			<div class="right_border"></div>				
			</a>
			</div>	
			<c:if test="${quickCheckoutProfile}">
				<c:set var="quickOrderId" value="${quickOrder.Order[0].orderId}"/>
				<div class="left" id="quickCheckoutButton">
					<div class="button_align" id="WC_CheckoutLogonf_div_13">
						<a href="#" role="button" class="button_primary button_left_padding" id="WC_CheckoutLogonf_links_2" tabindex="0" onclick="javascript:if(CheckoutHelperJS.canCheckoutContinue('<c:out value="${userType}"/>') && CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,true)){setCurrentId('WC_CheckoutLogonf_links_2'); ShipmodeSelectionExtJS.updateCartWithQuickCheckoutProfile('<c:out value='${quickOrderId}'/>');}">
							<div class="left_border"></div>
							<div class="button_text"><fmt:message bundle="${storeText}" key="QUICKCHECKOUT" /></div>
							<div class="right_border"></div>
						</a>
					</div>
				</div>
			</c:if>
		</div>
	</c:if>

	<flow:ifDisabled feature="AjaxCheckout">
		<div class="left" id="updateShopCart"> 
			<div class="button_align" id="WC_CheckoutLogonf_div_14">
				<a href="#" role="button" class="button_primary" id="ShoppingCart_NonAjaxUpdate" tabindex="0" onclick="javascript:CheckoutHelperJS.updateShoppingCart(document.ShopCartForm,false);return false;">
					<div class="left_border"></div>
					<div class="button_text"><fmt:message bundle="${storeText}" key="SHOPCART_UPDATE" /></div>
					<div class="right_border"></div>
				</a>
			</div>
		</div>	
		<br/>
		<br/>
	</flow:ifDisabled>
</div>
<%@ include file="CheckoutLogonEIExt.jspf"%>
<!-- END CheckoutLogon.jsp -->
