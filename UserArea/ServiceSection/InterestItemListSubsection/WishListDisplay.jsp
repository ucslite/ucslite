
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>

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
<!-- BEGIN WishListDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml"
xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message bundle="${storeText}" key="WISHLIST_TITLE"/></title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingList.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingListServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Widgets/ShoppingList/ShoppingListControllers.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Configurator/ConfiguratorServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CatalogArea/CategoryDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CatalogArea/CompareProduct.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AccountWishListDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesDeclaration.js"/>"></script>


	<script type="text/javascript">
		dojo.addOnLoad(function() { 
			categoryDisplayJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>','<c:out value='${userType}'/>');
			ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');
			
			<fmt:message bundle="${storeText}" key="WISHLIST_MISSINGNAME" var="WISHLIST_MISSINGNAME"/>
			<fmt:message bundle="${storeText}" key="WISHLIST_MISSINGEMAIL" var="WISHLIST_MISSINGEMAIL"/>
			<fmt:message bundle="${storeText}" key="WISHLIST_INVALIDEMAILFORMAT" var="WISHLIST_INVALIDEMAILFORMAT"/>
			<fmt:message bundle="${storeText}" key="REQUIRED_FIELD_ENTER" var="REQUIRED_FIELD_ENTER"/>
			<fmt:message bundle="${storeText}" key="WISHLIST_EMPTY" var="WISHLIST_EMPTY"/>
			<fmt:message bundle="${storeText}" key="SHOPCART_ADDED" var="SHOPCART_ADDED"/>
			<fmt:message bundle="${storeText}" key="SHOPCART_REMOVEITEM" var="SHOPCART_REMOVEITEM" />
			<fmt:message bundle="${storeText}" key="ERROR_MESSAGE_TYPE" var="ERROR_MESSAGE_TYPE"/>
			<fmt:message bundle="${storeText}" key="WISHLIST_ADDED" var="WISHLIST_ADDED"/>
			<fmt:message bundle="${storeText}" key="QUANTITY_INPUT_ERROR" var="QUANTITY_INPUT_ERROR"/>
			<%-- Missing message --%>
			<fmt:message bundle="${storeText}" key="ERROR_CONTRACT_EXPIRED_GOTO_ORDER" var="ERROR_CONTRACT_EXPIRED_GOTO_ORDER"/>
			<fmt:message bundle="${storeText}" key="GENERICERR_MAINTEXT" var="ERROR_RETRIEVE_PRICE">                                     
				<fmt:param><fmt:message bundle="${storeText}" key="GENERICERR_CONTACT_US" /></fmt:param>
			</fmt:message>
			<fmt:message bundle="${storeText}" key="ERR_RESOLVING_SKU" var="ERR_RESOLVING_SKU"/>
			MessageHelper.setMessage("ERROR_RETRIEVE_PRICE", <wcf:json object="${ERROR_RETRIEVE_PRICE}"/>);
			MessageHelper.setMessage("WISHLIST_MISSINGNAME", <wcf:json object="${WISHLIST_MISSINGNAME}"/>);
			MessageHelper.setMessage("WISHLIST_MISSINGEMAIL", <wcf:json object="${WISHLIST_MISSINGEMAIL}"/>);
			MessageHelper.setMessage("WISHLIST_INVALIDEMAILFORMAT", <wcf:json object="${WISHLIST_INVALIDEMAILFORMAT}"/>);
			MessageHelper.setMessage("REQUIRED_FIELD_ENTER", <wcf:json object="${REQUIRED_FIELD_ENTER}"/>);
			MessageHelper.setMessage("WISHLIST_EMPTY", <wcf:json object="${WISHLIST_EMPTY}"/>);
			MessageHelper.setMessage("SHOPCART_ADDED", <wcf:json object="${SHOPCART_ADDED}"/>);
			MessageHelper.setMessage("SHOPCART_REMOVEITEM", <wcf:json object="${SHOPCART_REMOVEITEM}"/>);
			MessageHelper.setMessage("ERROR_MESSAGE_TYPE", <wcf:json object="${ERROR_MESSAGE_TYPE}"/>);
			MessageHelper.setMessage("WISHLIST_ADDED", <wcf:json object="${WISHLIST_ADDED}"/>);
			MessageHelper.setMessage("QUANTITY_INPUT_ERROR", <wcf:json object="${QUANTITY_INPUT_ERROR}"/>);
			MessageHelper.setMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER", <wcf:json object="${ERROR_CONTRACT_EXPIRED_GOTO_ORDER}"/>);
			MessageHelper.setMessage("ERR_RESOLVING_SKU", <wcf:json object="${ERR_RESOLVING_SKU}"/>);
		});
		dojo.addOnLoad(AccountWishListDisplay.processBookmarkURL); 
		dojo.addOnLoad(function() { AccountWishListDisplay.initHistory("WishlistDisplay_Widget", '${WishListResultDisplayViewURL}') });
	</script>
	
	<wcf:url var="WishListResultDisplayViewURL" value="WishListResultDisplayView">
		<wcf:param name="langId" value="${langId}" />						
		<wcf:param name="storeId" value="${WCParam.storeId}" />
		<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	</wcf:url>
	
	<fmt:message bundle="${storeText}" key="WISHLISTS_TITLE" var="contentPageName" scope="request"/>
</head>
                 
<body>

	<%@ include file="../../../Common/MultipleWishListSetup.jspf" %>
	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>

<!-- Page Start -->
<div id="page" class="nonRWDPage">

	<c:set var="myAccountPage" value="true" scope="request"/>
	<c:set var="wishListPage" value="true" />
	<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>
	<c:set var="pageCategory" value="MyAccount" scope="request"/>

	<!-- Import Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->

    <!-- Main Content Start -->
	
	<c:set var="myAccountPage" value="true" scope="request"/>
	<c:set var="bHasWishList" value="true"/>
	<c:set var="wishListPage" value="true"/>
	<c:set var="url" value="WishListDisplayView"/>
	<c:set var="errorViewName" value="WishListDisplayView"/>
	
	
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
						<div id="box" class="myAccountMarginRight">
							<%@ include file="../../../Snippets/MultipleWishList/GetDefaultWishList.jspf" %>
							<div dojoType="wc.widget.RefreshArea" id="WishlistSelect_Widget" controllerId="WishlistSelect_Controller">
								<% out.flush(); %>
								<c:import url="/${sdb.jspStoreDir}/UserArea/ServiceSection/InterestItemListSubsection/MultipleWishListController.jsp">
									<c:param name="storeId" value="${WCParam.storeId}" />
									<c:param name="catalogId" value="${catalogId}" />
									<c:param name="langId" value="${langId}" />
								</c:import>
								<% out.flush(); %>
							</div>
							
							<div class="my_account_wishlist" id="WC_WishListDisplay_div_18">
								<span id="WishlistDisplay_Widget_ACCE_Label" class="spanacce"><fmt:message bundle="${storeText}" key="ACCE_Region_Wish_List"/></span>
								<div dojoType="wc.widget.RefreshArea" id="WishlistDisplay_Widget" controllerId="WishlistDisplay_Controller" ariaMessage="<fmt:message bundle="${storeText}" key="ACCE_Status_Wish_List_Updated"/>" ariaLiveId="${ariaMessageNode}" role="region" aria-labelledby="WishlistDisplay_Widget_ACCE_Label">
									
									<% out.flush(); %>
									<c:import url="/${sdb.jspStoreDir}/UserArea/ServiceSection/InterestItemListSubsection/WishListResultDisplay.jsp">
										<c:param name="storeId" value="${WCParam.storeId}" />
										<c:param name="catalogId" value="${catalogId}" />
										<c:param name="langId" value="${langId}" />
										<%-- get default list ID from get data once service is available, now just pass in 1st wish list ID found --%>
										<c:param name="listId" value="${defaultWishList.giftListIdentifier.uniqueID}"/>
									</c:import>
									<% out.flush(); %>
					
								</div>	
								<script type="text/javascript">
									dojo.addOnLoad(function() {
										parseWidget("WishlistSelect_Widget");
										parseWidget("WishlistDisplay_Widget"); 
										parseWidget("MultipleWishListPopup_create_popup");
										parseWidget("MultipleWishListPopup_edit_popup");
										parseWidget("MultipleWishListPopup_delete_popup");
									 });
								</script>					
								<p class="space"></p>
				
								<fmt:message bundle="${storeText}" var="titleString" key="WISHLIST_ESPOT_TITLE" scope="request"/>	
									<% out.flush(); %>
									<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.CatalogEntryRecommendation/CatalogEntryRecommendation.jsp">
										<c:param name="emsName" value="WishListCenter_CatEntries" />
										<c:param name="errorViewName" value="AjaxOrderItemDisplayView" />
										<c:param name="widgetOrientation" value="horizontal"/>
										<c:param name="espotTitle" value="${titleString}"/>
									</c:import>
									<% out.flush(); %>
							
								</div>
								<!-- Content End -->
								<!-- Right Nav Start -->
								<div id="right_nav">
									<div id="wishlist">
										<fmt:message bundle="${storeText}" var="wishListSubject" key="EMAIL_WISHLIST_EMAIL_SUBJECT"/>
										<form name="SendMsgForm" method="post" action="RESTWishListAnnounce" id="SendMsgForm">
											<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}" />" id="WC_WishListDisplay_FormInput_storeId_In_SendMsgForm_1"/>
											<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}" />" id="WC_WishListDisplay_FormInput_catalogId_In_SendMsgForm_1"/>
											<input type="hidden" name="langId" value="<c:out value="${langId}" />" id="WC_WishListDisplay_FormInput_langId_In_SendMsgForm_1"/>
											<input type="hidden" name="URL" value="${url}" id="WC_WishListDisplay_FormInput_URL_In_SendMsgForm_1"/>
											<input type="hidden" name="errorViewName" value="${errorViewName}" id="WC_WishListDisplay_FormInput_errorViewName_In_SendMsgForm_1"/>
											<input type="hidden" name="sender" value="<c:out value="${strSender}" />" id="WC_WishListDisplay_FormInput_sender_In_SendMsgForm_1"/>
											<input type="hidden" name="wishListHasItem" value="${bHasWishList}" id="WC_WishListDisplay_FormInput_wishListItem_In_SendMsgForm_1"/>
											<input type="hidden" name="giftListId" value="" id="WC_WishListDisplay_FormInput_listId_In_SendMsgForm_1"/>
											<input type="hidden" name="template" value="SOA_WISHLIST_EMAIL_TEMPLATE" id="WC_WishListDisplay_FormInput_Template_In_SendMsgForm_1"/>
											<input type="hidden" name="addressingMethod" value="DirectlyAddressed" id="WC_WishListDisplay_FormInput_AddMethod_In_SendMsgForm_1"/>
											<input type="hidden" name="subject" value="<c:out value='${wishListSubject}'/>" id="WC_WishListDisplay_FormInput_Subject_In_SendMsgForm_1"/>
											<input type="hidden" name="recipientEmail" value="" id="WC_WishListDisplay_FormInput_recipientEmail_In_SendMsgForm_1"/>
											<input type="hidden" name="senderName" value="" id="WC_WishListDisplay_FormInput_senderName_In_SendMsgForm_1"/>
											<input type="hidden" name="senderEmail" value="SOAWishListEmail@SOAWishListEmail.com" id="WC_WishListDisplay_FormInput_senderEmail_In_SendMsgForm_1"/>
											<input type="hidden" name="message" value="SOAWishListEmail" id="WC_WishListDisplay_FormInput_message_In_SendMsgForm_1"/>
			
											<div class="header" id="WC_WishListDisplay_div_4">
												<h2 class="sidebar_header"><fmt:message bundle="${storeText}" key="EMAIL_WISHLIST"/></h2>
											</div>
											<div class="contents" id="WC_WishListDisplay_div_5">
												<p class="header_text"><fmt:message bundle="${storeText}" key="SENDEMAIL_ACCE"/></p>
												<p class="header_text"><fmt:message bundle="${storeText}" key="SENDEMAIL1"/></p>
												<span class="required-field">* </span>
												<fmt:message bundle="${storeText}" key="REQUIRED_FIELDS"/><br/><br/>
												<div id="WC_WishListDisplay_div_6"><span class="required-field_wishlist">*</span><label for="SendWishListForm_Recipient_Email"><fmt:message bundle="${storeText}" key="WISHLIST_TO" /><fmt:message bundle="${storeText}" key="WISHLIST_EMAIL_ADDRESS"/></label></div>
												<div id="WC_WishListDisplay_div_7" class="wishlist_side_space"><input aria-required="true" type="text" size="21" maxlength="50" name="recipient" value="<c:out value="${WCParam.recipient}"/>" id="SendWishListForm_Recipient_Email"/></div>
												<div id="WC_WishListDisplay_div_8"><label for="SendWishListForm_Sender_Name"><span class="required-field_wishlist">*</span><fmt:message bundle="${storeText}" key="WISHLIST_FROM" /><fmt:message bundle="${storeText}" key="WISHLIST_NAME"/></label></div>
												<div id="WC_WishListDisplay_div_9" class="wishlist_side_space"><input aria-required="true" type="text" size="21" maxlength="110" name="sender_name" value="<c:out value="${strSenderName}"/>" id="SendWishListForm_Sender_Name"/></div>
												<div id="WC_WishListDisplay_div_10" class="wishlist_side_space"><label for="SendWishListForm_Sender_Email"><fmt:message bundle="${storeText}" key="WISHLIST_EMAIL" /></label></div>
												<div id="WC_WishListDisplay_div_11" class="wishlist_side_space"><input type="text" size="21" maxlength="50" name="sender_email" value="<c:out value="${strSenderEmail}"/>" id="SendWishListForm_Sender_Email"/></div>
												<div id="WC_WishListDisplay_div_12" class="wishlist_side_space"><label for="wishlist_message"><fmt:message bundle="${storeText}" key="WISHLIST_MESSAGE" /></label></div>
												<div id="WC_WishListDisplay_div_13" class="wishlist_side_space"><textarea rows="6" cols="22" name="wishlist_message" id="wishlist_message"><c:out value="${WCParam.wishlist_message}"/></textarea></div>
											   <br />
											   <div id="WC_WishListDisplay_div_14" class="wishlist_side_space">
													<a href="#" role="button" class="button_secondary" id="WC_WishListDisplay_links_1" onclick="JavaScript:MultipleWishLists.getWishListIdForEmail('SendMsgForm'); MultipleWishLists.checkSOAEmailForm('SendMsgForm','refreshArea');return false;">
														<div class="left_border"></div>
														<div class="button_text"><fmt:message bundle="${storeText}" key="SENDWISHLIST"/></div>								
														<div class="right_border"></div>
													</a>
											   </div>
											   <div class="clear_float"></div>
											</div>
										</form>
									
									</div>
									<div id="WishListEmailSucMsg_Div" class="text" style="display:none;" tabindex="-1">
										<c:if test="${empty storeError.key}">
											<fmt:message bundle="${storeText}" key="WISHLIST_SENDTO"><fmt:param><span id="recipientEmail_wishListDisplay"></span></fmt:param></fmt:message>
											<script type="text/javascript">
												dojo.addOnLoad(function() {
													AccountWishListDisplay.clearWishListEmailForm('SendMsgForm');
													setTimeout("dojo.byId('WishListEmailSucMsg_Div').focus()",2000);
												});
											</script>
										</c:if>
									</div>
								</div>
								<!-- Right Nav End -->
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
</div>
<flow:ifEnabled feature="Analytics">
	<cm:pageview/>
</flow:ifEnabled>
<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
<!-- END WishListDisplay.jsp -->
