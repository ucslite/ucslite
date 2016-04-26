<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
  *****
  * This JSP file displays the shopping cart page. It shows shopping cart details plus lets the shopper
  * initiate the checkout process either as a guest user, a registered user, or as a registered user
  * that has a quick checkout profile saved with the store.
  *****
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../Common/nocache.jspf"%>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>

<c:set var="pageCategory" value="Checkout" scope="request"/>
<flow:ifEnabled feature="RequisitionList">
	<flow:ifEnabled feature="AjaxMyAccountPage">
		<wcf:url var="RequisitionListViewURL" value="AjaxLogonForm">
			<wcf:param name="page" value="createrequisitionlist"/>
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		</wcf:url>
	</flow:ifEnabled>

	<flow:ifDisabled feature="AjaxMyAccountPage">
		<wcf:url var="RequisitionListViewURL" value="RequisitionListDetailView">
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="storeId" value="${WCParam.storeId}"/>
			<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
			<wcf:param name="editable" value="true"/>
			<wcf:param name="newList" value="true"/>
		</wcf:url>
	</flow:ifDisabled>
</flow:ifEnabled>

<c:set var="isBOPISEnabled" value="false"/>
<%-- Check if store locator feature is enabled. --%>
<flow:ifEnabled feature="BOPIS">
	<c:set var="isBOPISEnabled" value="true"/>
</flow:ifEnabled>

<!-- BEGIN OrderItemDisplay.jsp -->
<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#" xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
		
		<%-- Tealeaf should be set up before coremetrics inside CommonJSToInclude.jspf --%>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeafWC.js"></script>
		<c:if test="${env_Tealeaf eq 'true' && env_inPreview != 'true'}">
			<script type="text/javascript" src="${jsAssetsDir}javascript/Tealeaf/tealeaf.js"></script>
		</c:if>
		
		<%@ include file="../../Common/CommonJSToInclude.jspf"%>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/QuickInfo/QuickInfo.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingList.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingListServicesDeclaration.js"/>"></script>

		<%-- CommonContexts must come before CommonControllers --%>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>

		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CatalogArea/CategoryDisplay.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CheckoutArea/CheckoutHelper.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/LogonForm.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesDeclaration.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CheckoutArea/ShipmodeSelectionExt.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/StoreLocatorArea/PhysicalStoreCookie.js"/>"></script>
		<script type="text/javascript" src="${staticAssetContextRoot}${env_siteWidgetsDir}Common/javascript/OnBehalfUtilities.js"></script>
		
		<title><fmt:message bundle="${storeText}" key="SHOPPINGCART_TITLE"/></title>

		<script type="text/javascript">
			dojo.addOnLoad(function() {
				<c:if test="${!empty requestScope.deleteCartCookie && requestScope.deleteCartCookie[0]}">					
					document.cookie = "WC_DeleteCartCookie_${requestScope.storeId}=true;path=/";				
				</c:if>						
			});
		</script>
		<script type="text/javascript">
			dojo.addOnLoad(function() {
				<fmt:message bundle="${storeText}" key="ERR_RESOLVING_SKU" var="ERR_RESOLVING_SKU" />
				<fmt:message bundle="${storeText}" key="REQUIRED_FIELD_ENTER" var="REQUIRED_FIELD_ENTER"/>
				<fmt:message bundle="${storeText}" key="REQUIRED_SPECIFIC_FIELD_ENTER" var="LOGON_REQUIRED_FIELD_ENTER">
					<fmt:param><fmt:message bundle="${storeText}" key="SHOPCART_USERNAME"/></fmt:param>
				</fmt:message>
				<fmt:message bundle="${storeText}" key="REQUIRED_SPECIFIC_FIELD_ENTER" var="PASSWORD_REQUIRED_FIELD_ENTER">
					<fmt:param><fmt:message bundle="${storeText}" key="SHOPCART_PASSWORD"/></fmt:param>
				</fmt:message>
				<fmt:message bundle="${storeText}" key="QUANTITY_INPUT_ERROR" var="QUANTITY_INPUT_ERROR" />
				<fmt:message bundle="${storeText}" key="WISHLIST_ADDED" var="WISHLIST_ADDED" />
				<fmt:message bundle="${storeText}" key="SHOPCART_ADDED" var="SHOPCART_ADDED" />
				<fmt:message bundle="${storeText}" key="ERROR_MESSAGE_TYPE" var="ERROR_MESSAGE_TYPE" />
				<fmt:message bundle="${storeText}" key="SHOPCART_REMOVEITEM" var="SHOPCART_REMOVEITEM"/>
				<fmt:message bundle="${storeText}" key="ERROR_UPDATE_FIRST_SHOPPING_CART" var="ERROR_UPDATE_FIRST_SHOPPING_CART"/>
				<fmt:message bundle="${storeText}" key="PROMOTION_CODE_EMPTY" var="PROMOTION_CODE_EMPTY"/>
				<%-- ERROR_CONTRACT_EXPIRED_GOTO_ORDER message key seems to be missing --%>
				<fmt:message bundle="${storeText}" key="ERROR_CONTRACT_EXPIRED_GOTO_ORDER" var="ERROR_CONTRACT_EXPIRED_GOTO_ORDER"/>
				<fmt:message bundle="${storeText}" key="BOPIS_QUICKCHECKOUT_ERROR" var="quickCheckoutMsg"/>
				<fmt:message bundle="${storeText}" key="ERR_NO_PHY_STORE" var="ERR_NO_PHY_STORE"/>
				<fmt:message bundle="${storeText}" key="GENERICERR_MAINTEXT" var="ERROR_RETRIEVE_PRICE">
				<fmt:param><fmt:message bundle="${storeText}" key="GENERICERR_CONTACT_US"/></fmt:param></fmt:message>
				<fmt:message bundle="${storeText}" key="INVENTORY_ERROR" var="ERROR_RETRIEVE_PRICE_QTY_UPDATE"/>
				<fmt:message bundle="${storeText}" key="SHOPCART_HAS_NON_RECURRING_PRODUCTS" var="RECURRINGORDER_ERROR"/>
				<fmt:message bundle="${storeText}" key="ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER" var="ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER"/>

				MessageHelper.setMessage("ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER", <wcf:json object="${ERROR_GUEST_USER_SUBMIT_RECURRING_ORDER}"/>);
				MessageHelper.setMessage("RECURRINGORDER_ERROR", <wcf:json object="${RECURRINGORDER_ERROR}"/>);
				MessageHelper.setMessage("ERROR_RETRIEVE_PRICE_QTY_UPDATE", <wcf:json object="${ERROR_RETRIEVE_PRICE_QTY_UPDATE}"/>);
				MessageHelper.setMessage("ERROR_RETRIEVE_PRICE", <wcf:json object="${ERROR_RETRIEVE_PRICE}"/>);
				MessageHelper.setMessage("ERR_RESOLVING_SKU", <wcf:json object="${ERR_RESOLVING_SKU}"/>);
				MessageHelper.setMessage("QUANTITY_INPUT_ERROR", <wcf:json object="${QUANTITY_INPUT_ERROR}"/>);
				MessageHelper.setMessage("REQUIRED_FIELD_ENTER", <wcf:json object="${REQUIRED_FIELD_ENTER}"/>);
				MessageHelper.setMessage("LOGON_REQUIRED_FIELD_ENTER", <wcf:json object="${LOGON_REQUIRED_FIELD_ENTER}"/>);
				MessageHelper.setMessage("PASSWORD_REQUIRED_FIELD_ENTER", <wcf:json object="${PASSWORD_REQUIRED_FIELD_ENTER}"/>);
				MessageHelper.setMessage("WISHLIST_ADDED", <wcf:json object="${WISHLIST_ADDED}"/>);
				MessageHelper.setMessage("SHOPCART_ADDED", <wcf:json object="${SHOPCART_ADDED}"/>);
				MessageHelper.setMessage("SHOPCART_REMOVEITEM", <wcf:json object="${SHOPCART_REMOVEITEM}"/>);
				MessageHelper.setMessage("ERROR_MESSAGE_TYPE", <wcf:json object="${ERROR_MESSAGE_TYPE}"/>);
				categoryDisplayJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>','<c:out value='${userType}'/>');
				CheckoutHelperJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
				ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
				MessageHelper.setMessage("ERROR_UPDATE_FIRST_SHOPPING_CART", <wcf:json object="${ERROR_UPDATE_FIRST_SHOPPING_CART}"/>);
				MessageHelper.setMessage("PROMOTION_CODE_EMPTY", <wcf:json object="${PROMOTION_CODE_EMPTY}"/>);
				MessageHelper.setMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER", <wcf:json object="${ERROR_CONTRACT_EXPIRED_GOTO_ORDER}"/>);
				MessageHelper.setMessage("message_NO_STORE", <wcf:json object="${ERR_NO_PHY_STORE}"/>);
				MessageHelper.setMessage("message_QUICK_CHKOUT_ERR", <wcf:json object="${quickCheckoutMsg}"/>);
				ShipmodeSelectionExtJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
				ShipmodeSelectionExtJS.setBOPISEnabled(<c:out value="${isBOPISEnabled}"/>);
			});
		</script>

		<c:set var="AjaxAddToCart" value="false"/>
		<flow:ifEnabled feature="AjaxAddToCart">
			<c:set var="AjaxAddToCart" value="true"/>
		</flow:ifEnabled>

		<c:set var="isAjaxCheckOut" value="true"/>
		<flow:ifDisabled feature="AjaxCheckout">
			<c:set var="isAjaxCheckOut" value="false"/>
		</flow:ifDisabled>

		<script type="text/javascript">
			dojo.addOnLoad(shopCartPageLoaded);

			function shopCartPageLoaded() {
				categoryDisplayJS.setAjaxShopCart(<c:out value='${AjaxAddToCart && isAjaxCheckOut}'/>);
				CheckoutHelperJS.setAjaxCheckOut(<c:out value="${isAjaxCheckOut}"/>);
				CheckoutHelperJS.shoppingCartPage="true";
			}
		</script>

		<script type="text/javascript">

			dojo.addOnLoad(initGetTimeZone);

			function initGetTimeZone() {
				// get the browser's current date and time
				var d = new Date();

				// find the timeoffset between browser time and GMT
				var timeOffset = -d.getTimezoneOffset()/60;

				// store the time offset in cookie
				var gmtTimeZone;
				if (timeOffset < 0)
					gmtTimeZone = "GMT" + timeOffset;
				else if (timeOffset == 0)
					gmtTimeZone = "GMT";
				else
					gmtTimeZone = "GMT+" + timeOffset;
				setCookie("WC_timeoffset", gmtTimeZone, {path: "/", domain: cookieDomain});
			}
		</script>

		<wcf:url var="ShopCartDisplayViewURL" value="ShopCartDisplayView" type="Ajax">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${WCParam.storeId}" />
			<wcf:param name="catalogId" value="${WCParam.catalogId}" />
			<wcf:param name="shipmentType" value="single" />
		</wcf:url>

		<%-- This following section is only loaded and executed if the current page flow is non-AJAX --%>
		<c:if test="${!isAjaxCheckOut}">
			<script type="text/javascript">
				///////////////////////////////////////////////////
				// summary              : Set a dirty flag
				// description       : Set a dirty flag in CheckoutPayments.js when the user modifies order item quantities in a non-AJAX shopping cart
				//
				// event              : DOM/Dojo/Dijit event, e.g. onclick, onchange, etc.
				// assumptions       : Used in non-AJAX checkout flow
				// dojo API              :
				// returns              : void
				///////////////////////////////////////////////////
				function setDirtyFlag(){
					CheckoutHelperJS.setFieldDirtyFlag(true);
					console.debug("Order item information on the Shopping Cart page was modified.");
				}

				/////////////////////////////////////////////////////////////////////////
				// On page load, add editable fields in the shipping information
				// section to Dojo event listener so that when they are changed by the
				// user, the user is required to to update the shopping cart before
				// proceeding to checkout.
				/////////////////////////////////////////////////////////////////////////
				dojo.addOnLoad(CheckoutHelperJS.initDojoEventListenerShoppingCartPage);
			</script>
		</c:if>
	</head>

	<body>
		<%@ include file="../../../Widgets_701/Common/QuickInfo/QuickInfoPopup.jspf" %>
		<c:set var="shoppingCartPage" value="true" scope="request"/>
		<c:set var="hasBreadCrumbTrail" value="true" scope="request"/>
		<c:set var="useHomeRightSidebar" value="false" scope="request"/>
		<%@ include file="../../Snippets/ReusableObjects/GiftItemInfoDetailsDisplayExt.jspf" %>
		<%@ include file="../../Snippets/ReusableObjects/GiftRegistryGiftItemInfoDetailsDisplayExt.jspf" %>

		<flow:ifEnabled feature="Analytics">
			<cm:pageview pageType="wcs-cart"/>
		</flow:ifEnabled>

		<div id="page" class="nonRWDPage">
			<div id="grayOut"></div>
			<%-- This file includes the progressBar mark-up and success/error message display markup --%>
			<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>
			<!-- Header Widget -->
			<div class="header_wrapper_position" id="headerWidget">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>

			<script type="text/javascript">
				dojo.addOnLoad(function() {
					CommonControllersDeclarationJS.setControllerURL('ShopCartDisplayController','<c:out value="${ShopCartDisplayViewURL}"/>');
				});
			</script>

			<div class="content_wrapper_position" role="main">
				<div class="content_wrapper">
					<div class="content_left_shadow">
						<div class="content_right_shadow">
							<div class="main_content">
								<%out.flush();%>
								<c:import url="/${sdb.jspStoreDir}/include/BreadCrumbTrailDisplay.jsp">
									<c:param name="topCategoryPage" value="${requestScope.topCategoryPage}" />
									<c:param name="categoryPage" value="${requestScope.categoryPage}" />
									<c:param name="productPage" value="${requestScope.productPage}" />
									<c:param name="shoppingCartPage" value="${requestScope.shoppingCartPage}" />
									<c:param name="compareProductPage" value="${requestScope.compareProductPage}" />
									<c:param name="finalBreadcrumb" value="${requestScope.finalBreadcrumb}" />
									<c:param name="extensionPageWithBCF" value="${requestScope.extensionPageWithBCF}" />
									<c:param name="hasBreadCrumbTrail" value="${requestScope.hasBreadCrumbTrail}" />
									<c:param name="requestURIPath" value="${requestScope.requestURIPath}" />
									<c:param name="SavedOrderListPage" value="${requestScope.SavedOrderListPage}" />
									<c:param name="pendingOrderDetailsPage" value="${requestScope.pendingOrderDetailsPage}" />
									<c:param name="sharedWishList" value="${requestScope.sharedWishList}" />
									<c:param name="searchPage" value="${requestScope.searchPage}"/>
								</c:import>
								<%out.flush();%>
								<div class="container_content_rightsidebar shop_cart">
									<div class="left_column">
										<flow:ifDisabled feature="AjaxCheckout">
											<form name="ReplaceItemForm" method="post" action="OrderChangeServiceItemDelete" id="ReplaceItemForm">
												<!-- Define all the hidden fields required for submitting this form in case of Non-Ajax Checkout -->
												<input type="hidden" name="storeId" value='<c:out value="${storeId}"/>' id="WC_OrderItemDisplay_inputs_2"/>
												<input type="hidden" name="langId" value='<c:out value="${langId}" />' id="WC_OrderItemDisplay_inputs_3"/>
												<input type="hidden" name="orderId" value='<c:out value="${order.orderId}"/>' id="WC_OrderItemDisplay_inputs_4"/>
												<input type="hidden" name="catalogId" value='<c:out value="${catalogId}"/>' id="WC_OrderItemDisplay_inputs_5"/>
												<input type="hidden" name="errorViewName" value="InvalidInputErrorView" id="WC_OrderItemDisplay_inputs_6"/>
												<input type="hidden" name="orderItemId" value="" id="WC_OrderItemDisplay_inputs_7"/>
												<input type="hidden" name="URL" value="AjaxOrderItemDisplayView" id="WC_OrderItemDisplay_inputs_1"/>
												<input type="hidden" name="calculationUsage" value="-1,-2,-3,-4,-5,-6,-7" id="WC_OrderItemDisplay_inputs_8"/>
											</form>
										</flow:ifDisabled>

										<span id="ShopCartDisplay_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Shopping_Cart_Content"/></span>
										<div dojoType="wc.widget.RefreshArea" widgetId="ShopCartDisplay" id="ShopCartDisplay" controllerId="ShopCartDisplayController" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Shopping_Cart_Content_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="ShopCartDisplay_ACCE_Label">
											<%out.flush();%>
											<c:import url="/${sdb.jspStoreDir}/ShoppingArea/ShopcartSection/ShopCartDisplay.jsp"/>
											<%out.flush();%>
										</div>
										<%-- Include after ShopCartDisplay.jsp. ShopCartDisplay.jsp fetches the order details which can be reused in the GiftsPopup dialog --%>
										<%@ include file="../../Snippets/Marketing/Promotions/PromotionChoiceOfFreeGiftsPopup.jspf" %>
										<script type="text/javascript">
											dojo.addOnLoad(function() {
												parseWidget("ShopCartDisplay");
											});
										</script>
										<br/>
										<flow:ifEnabled feature="Analytics">
											<%-- Begin - Added for Coremetrics Intelligent Offer to Display dynamic recommendations for the most recently viewed product --%>
											<%-- Coremetrics Aanlytics is a prerequisite to Coremetrics Intelligent Offer --%>

											<div class="item_spacer_5px"></div>

											<div class="widget_product_listing_position">
												<%out.flush();%>
												<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.IBMProductRecommendations/IBMProductRecommendations.jsp">
													<c:param name="emsName" value="ShoppingCart_ProductRec" />
													<c:param name="widgetOrientation" value="horizontal"/>
													<c:param name="catalogId" value="${WCParam.catalogId}" />
												</c:import>
												<%out.flush();%>
											</div>

										<%-- End - Added for Coremetrics Intelligent Offer --%>
									</flow:ifEnabled>
									</div>
									<div class="right_column">
										<!-- Vertical Recommendations Widget -->
										<div class="widget_recommended_position">
											<% out.flush(); %>
												<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.CatalogEntryRecommendation/CatalogEntryRecommendation.jsp">
													<c:param name="emsName" value="ShoppingCartRight_CatEntries"/>
													<c:param name="widgetOrientation" value="vertical"/>
													<c:param name="pageSize" value="2"/>
												</c:import>
											<% out.flush(); %>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

		<script type="text/javascript">
			dojo.addOnLoad(function() {
				<c:choose>
					<c:when test="${!empty errorMessage && currentOrderLocked eq 'true' && env_shopOnBehalfSessionEstablished ne true}">
						// Current order is locked and this is shopper session. Just display generic error message instead of actual error message.
						require([
								 "dojo/html",
								 "dojo/_base/lang",
								 "dojo/domReady!"], function(html,lang) {
							var msg = storeNLS['ORDER_LOCKED_ERROR_MSG'];
							if(typeof(msg) != 'undefined' && msg != ""){
								MessageHelper.displayErrorMessage(lang.replace(msg, ['${order.orderId}']));
							} else {
								MessageHelper.displayErrorMessage(<wcf:json object="${errorMessage}"/>);
							}
						 });
					</c:when>
					<c:when test="${!empty errorMessage}">
						MessageHelper.displayErrorMessage(<wcf:json object="${errorMessage}"/>);
					</c:when>
				</c:choose>
			});
		</script>


			<!-- Footer Widget -->
			<div class="footer_wrapper_position">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
				<%out.flush();%>
			</div>
		</div>

	<%@ include file="../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END OrderItemDisplay.jsp -->
