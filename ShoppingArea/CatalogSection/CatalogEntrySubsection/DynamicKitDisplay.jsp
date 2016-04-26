<!DOCTYPE html>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN DynamicKitDisplay.jsp -->

<%-- 
  *****
  * This JSP page displays the dynamic kit details.  It shows the following information:
  *  - Full-sized image, name, and long description of the dynamic kit
  *  - Discount description for the dynamic kit, if available
  *  - Pre-Configured price of the dynamic kit
  *  - Descriptive attributes, displayed as name:value
  *  - 'Quantity' box to enter the quantity (default is 1)
  *  - 'Add to shopping cart' button, 'Add to wish list' button for B2C stores
  *****
--%>
<%@include file="../../../Common/EnvironmentSetup.jspf" %>
<%@include file="../../../Common/nocache.jspf" %>

<c:if test="${not empty WCParam.productId}">
	<c:set var="productId" value="${WCParam.productId}" />
</c:if>

<c:if test="${empty productId and not empty param.productId}">
	<c:set var="productId" value="${param.productId}" />
</c:if>

<wcf:url var="DynamicKitDisplayURL" patternName="ProductURL" value="Product1">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${storeId}" />
	<wcf:param name="catalogId" value="${catalogId}" />
	<wcf:param name="productId" value="${productId}" />
	<wcf:param name="urlLangId" value="${urlLangId}" />
</wcf:url>

<c:if test="${!empty productId}">
	<%-- Since this is a product page, get all the details about this product and save it in internal cache, so that other components can use it... --%>

	<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${productId}" scope="request">	
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="currency" value="${env_currencyCode}"/>
		<wcf:param name="responseFormat" value="json"/>		
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<c:forEach var="contractId" items="${env_activeContractIds}">
			<wcf:param name="contractId" value="${contractId}"/>
		</c:forEach>
	</wcf:rest>
	<c:set var="key1" value="${productId}+getCatalogEntryViewAllByID"/>
	<wcf:set target = "${cachedCatalogEntryDetailsMap}" key="${key1}" value="${catalogNavigationView.catalogEntryView[0]}"/>

	<wcf:rest var="getPageResponse" url="store/{storeId}/page">
		<wcf:var name="storeId" value="${storeId}" encode="true"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="q" value="byCatalogEntryIds"/>
		<wcf:param name="catalogEntryId" value="${productId}"/>
	</wcf:rest>
	<c:set var="page" value="${getPageResponse.resultList[0]}"/>
</c:if>

<c:set var="pageTitle" value="${page.title}" />
<c:set var="metaDescription" value="${page.metaDescription}" />
<c:set var="metaKeyword" value="${page.metaKeyword}" />
<c:set var="fullImageAltDescription" value="${page.fullImageAltDescription}" scope="request" />
<c:set var="categoryId" value="${catalogNavigationView.catalogEntryView[0].parentCatalogGroupID}"/>
<c:set var="pageView" value="DynamicDisplayView" scope="request"/>
<c:set var="partNumber" value="${catalogNavigationView.catalogEntryView[0].partNumber}" scope="request"/>
<c:if test="${ empty partNumber}">
	<c:set var="partNumber" value="${page.partNumber}" scope="request"/>
</c:if>
<c:set var="pageGroup" value="DynamicKit" scope="request"/>
<c:set var="type" value="${fn:toLowerCase(catalogNavigationView.catalogEntryView[0].catalogEntryTypeCode)}" />
<c:set var="type" value="${fn:replace(type,'bean','')}" />
<c:set var="catalogEntryID" value="${catalogNavigationView.catalogEntryView[0].uniqueID}" />
<c:set var="pageCategory" value="Browse" scope="request"/>

<wcf:rest var="getPageDesignResponse" url="store/{storeId}/page_design">
	<wcf:var name="storeId" value="${storeId}" encode="true"/>
	<wcf:param name="catalogId" value="${catalogId}"/>
	<wcf:param name="langId" value="${langId}"/>
	<wcf:param name="q" value="byObjectIdentifier"/>
	<wcf:param name="objectIdentifier" value="${productId}"/>
	<wcf:param name="deviceClass" value="${deviceClass}"/>
	<wcf:param name="pageGroup" value="${pageGroup}"/>
</wcf:rest>
<c:set var="pageDesign" value="${getPageDesignResponse.resultList[0]}" scope="request"/>
<c:set var="PAGE_DESIGN_DETAILS_JSON_VAR" value="pageDesign" scope="request"/>

<%-- Special case when part of both master and sales catalog, categoryId returned is an array --%>
<c:set var="numParentCategories" value="0" />
<c:forEach var="aParentCategory" items="${categoryId}">
	<c:set var="numParentCategories" value="${numParentCategories+1}" />
</c:forEach>
<c:if test="${numParentCategories>1}">
	<c:set var="categoryId" value="${fn:split(categoryId[0], '_')[1]}"/>
</c:if>

<wcf:rest var="subCategory" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/categoryview/byId/${categoryId}" >	
	<wcf:param name="langId" value="${WCParam.langId}"/>
	<wcf:param name="currency" value="${env_currencyCode}"/>
	<wcf:param name="responseFormat" value="json"/>		
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<c:forEach var="contractId" items="${env_activeContractIds}">
		<wcf:param name="contractId" value="${contractId}"/>
	</c:forEach>
</wcf:rest>
<c:set var="emsNameLocalPrefix" value="${fn:replace(subCategory.catalogGroupView[0].identifier,' ','')}" scope="request"/>
<%-- Uncomment to use CatalogEntry's partnumber as the emsNameLocalPrefix
<c:set var="emsNameLocalPrefix" value="${fn:replace(partNumber,' ','')}" scope="request"/>
--%>
<c:set var="emsNameLocalPrefix" value="${fn:replace(emsNameLocalPrefix,'\\\\','')}"/>

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
<flow:ifEnabled feature="FacebookIntegration">
	<%-- Facebook requires this to work in IE browsers --%>
	xmlns:fb="http://www.facebook.com/2008/fbml" 
	xmlns:og="http://opengraphprotocol.org/schema/"
</flow:ifEnabled>
xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><c:out value="${pageTitle}"/></title>
		<meta name="description" content="<c:out value="${metaDescription}"/>"/>
		<meta name="keywords" content="<c:out value="${metaKeyword}"/>"/>
		<meta name="pageIdentifier" content="<c:out value="${partNumber}"/>"/>
		<meta name="pageId" content="<c:out value="${productId}"/>"/>
		<meta name="pageGroup" content="<c:out value="${pageGroup}"/>"/>
	    <link rel="canonical" href="<c:out value="${DynamicKitDisplayURL}"/>" />
	    
		<!--Main Stylesheet for browser -->
		<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheet}" type="text/css" media="screen"/>
		<!-- Style sheet for print -->
		<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheetprint}" type="text/css" media="print"/>
		
		<!-- Include script files -->
		<%@include file="../../../Common/CommonJSToInclude.jspf" %>
		<script type="text/javascript" src="${jsAssetsDir}javascript/CommonContextsDeclarations.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/CommonControllersDeclaration.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/collapsible.js"></script>
		<script type="text/javascript">
			dojo.addOnLoad(function() { 
					shoppingActionsServicesDeclarationJS.setCommonParameters('<c:out value="${langId}" />','<c:out value="${storeId}" />','<c:out value="${catalogId}" />');
				});
		</script>
		
		<flow:ifEnabled feature="FacebookIntegration">
			<%@include file="../../../Common/JSTLEnvironmentSetupExtForFacebook.jspf" %>
			
			<c:if test="${!empty catalogNavigationView && !empty catalogNavigationView.catalogEntryView[0]}">
				<c:set var="catalogEntryDetails" value="${catalogNavigationView.catalogEntryView[0]}"/>
			</c:if>
			
			<%--Facebook Open Graph tags that are required  --%>
			<meta property="og:title" content="<c:out value="${pageTitle}"/>" />
			
			<c:choose>
				<c:when test="${!empty catalogEntryDetails.thumbnail}">
					<c:choose>
						<c:when test="${(fn:startsWith(catalogEntryDetails.thumbnail, 'http://') || fn:startsWith(catalogEntryDetails.thumbnail, 'https://'))}">
							<wcst:resolveContentURL var="imagePath" url="${catalogEntryDetails.thumbnail}" includeHostName="true"/>
						</c:when>
						<c:otherwise>
							<c:set var="imagePath" value="${catalogEntryDetails.thumbnail}" />
						</c:otherwise>
					</c:choose>
				</c:when>				
				<c:when test="${!empty catalogEntryDetails.fullImage}">
					<c:choose>
						<c:when test="${(fn:startsWith(catalogEntryDetails.fullImage, 'http://') || fn:startsWith(catalogEntryDetails.fullImage, 'https://'))}">
							<wcst:resolveContentURL var="imagePath" url="${catalogEntryDetails.fullImage}" includeHostName="true"/>
						</c:when>
						<c:otherwise>
							<c:set var="imagePath" value="${catalogEntryDetails.fullImage}" />
						</c:otherwise>
					</c:choose>
				</c:when>				
				<c:otherwise>
					<c:set var="imagePath" value="${jspStoreImgDir}images/logo.png" />
				</c:otherwise>
			</c:choose> 
			<c:if test="${(!fn:startsWith(imagePath, 'http://') && !fn:startsWith(imagePath, 'https://'))}">
				<c:set var="imagePath" value="${schemeToUse}://${request.serverName}${portUsed}${imagePath}"/>
			</c:if>
			<meta property="og:image" content="<c:out value="${imagePath}" />"/>
			
			<meta property="og:url" content="<c:out value="${DynamicKitDisplayURL}"/>"/>
			<meta property="og:type" content="product"/>
			<meta property="og:description" content="<c:out value="${metaDescription}"/>" />
			<meta property="fb:app_id" name="fb_app_id" content="<c:out value="${facebookAppId}"/>"/>
		</flow:ifEnabled>
		<wcpgl:jsInclude/>
		
	</head>
		
	<body>

		<%-- This file includes the progressBar mark-up and success/error message display markup --%>
		<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
		<div id="IntelligentOfferCategoryId" style="display:none;"><c:out value="${categoryId}" /></div>
		<div id="IntelligentOfferMainPartNumber" style="display:none;"><c:out value="${partNumber}" /></div>
		<div id="entitledItem_<c:out value='${catalogEntryID}'/>" style="display:none;">
				[
				<c:if test="${type == 'package' || type == 'bundle' || type == 'item' || type == 'dynamickit'}">
					{
					"catentry_id" : "<c:out value='${catalogEntryID}'/>",
					"Attributes" :	{ }
					}
				</c:if>
				]
		</div>
		
		<!-- Begin Page -->		
		<c:set var="layoutPageIdentifier" value="${productId}"/>
		<c:set var="layoutPageName" value="${partNumber}"/>
		<%@ include file="/Widgets_701/Common/ESpot/LayoutPreviewSetup.jspf"%>	
				
		<div id="page">
			<div id="grayOut"></div>					
			<div id="headerWrapper">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>
			
			<c:set var="rootWidget" value="${pageDesign.widget}"/>
			<wcpgl:widgetImport uniqueID="${rootWidget.widgetDefinitionId}" debug=false/>
			
			<div id="footerWrapper">
				<%out.flush();%>
				<c:import url="${env_jspStoreDir}Widgets/Footer/Footer.jsp"/>
				<%out.flush();%>
			</div>
		</div>
		
	<flow:ifEnabled feature="Analytics">
	<%@include file="../../../AnalyticsFacetSearch.jspf" %>
		<cm:product catalogNavigationViewJSON="${catalogNavigationView}" extraparms="null, ${analyticsFacet}"/>
		<cm:pageview pageType="wcs-productdetail"/>
	</flow:ifEnabled>

	<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
	
<wcpgl:pageLayoutCache pageLayoutId="${pageDesign.layoutId}"/>
<!-- END DynamicKitDisplay.jsp -->

</html>
