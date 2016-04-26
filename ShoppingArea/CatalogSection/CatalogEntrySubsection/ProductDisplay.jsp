<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!doctype HTML>


<!-- BEGIN ProductDisplay.jsp -->

<%-- 
  *****
  * This JSP diplay the product details given a productId or partNumber. This page imports the following components
  * Header Component - Display header links, department widget, mini shop-cart widget and Search widget
  * Product Image Component - Display the product image
  * Product Description Component - Displays product short description, attributes, inventory component, price component etc.,
  * Merchandising Association Component
  * E-spots for Recently Viewed and Recommendations
  * Product TAB component
  * Footer Component - Display footer links
  *****
--%>

<%@include file="../../../Common/EnvironmentSetup.jspf" %>
<%@include file="../../../Common/nocache.jspf" %>

<c:if test="${!empty param.top_category}">
	<c:set var="top_category" value="${param.top_category}"/>
</c:if>
<c:if test="${!empty WCParam.top_category}">
	<c:set var="top_category" value="${WCParam.top_category}"/>
</c:if>
<c:if test="${!empty param.parent_category_rn}">
	<c:set var="parent_category_rn" value="${param.parent_category_rn}"/>
</c:if>
<c:if test="${!empty WCParam.parent_category_rn}">
	<c:set var="parent_category_rn" value="${WCParam.parent_category_rn}"/>
</c:if>

<c:set var="pageCategory" value="Browse" scope="request"/>

<c:if test="${!empty productId}">
	<%-- Since this is a product page, get all the details about this product and save it in internal cache, so that other components can use it... --%>

	<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${productId}" >	
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="currency" value="${env_currencyCode}"/>
		<wcf:param name="responseFormat" value="json"/>		
		<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
		<c:forEach var="contractId" items="${env_activeContractIds}">
			<wcf:param name="contractId" value="${contractId}"/>
		</c:forEach>
	</wcf:rest>
	<%-- Cache it in our internal hash map --%>
	<c:set var="key1" value="${productId}+getCatalogEntryViewAllByID"/>
	<wcf:set target = "${cachedCatalogEntryDetailsMap}" key="${key1}" value="${catalogNavigationView.catalogEntryView[0]}"/>

	<wcf:rest var="getPageResponse" url="store/{storeId}/page">
		<wcf:var name="storeId" value="${storeId}" encode="true"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="q" value="byCatalogEntryIds"/>
		<wcf:param name="catalogEntryId" value="${productId}"/>
	</wcf:rest>
	<c:set var="page" value="${getPageResponse.resultList[0]}"/>
	
	<c:if test="${!empty catalogNavigationView && !empty catalogNavigationView.catalogEntryView[0]}">
		<c:set var="catalogEntryDetails" value="${catalogNavigationView.catalogEntryView[0]}"/>
	</c:if>
	
	<c:set var="parentCatEntryId" value="${catalogNavigationView.catalogEntryView[0].parentCatalogEntryID}" scope="request"/>
	<%-- If parentCateEntryId is not empty, then this is an item and not a product --%>
	<c:if test="${not empty parentCatEntryId}">
		<%-- Since this is an item, get all the details about the parent product and save it in internal cache, so that other components can use it... --%>

		<wcf:rest var="parentCatalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${parentCatEntryId}" >	
				<wcf:param name="langId" value="${WCParam.langId}"/>
				<wcf:param name="currency" value="${env_currencyCode}"/>
				<wcf:param name="responseFormat" value="json"/>		
				<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
				<c:forEach var="contractId" items="${env_activeContractIds}">
					<wcf:param name="contractId" value="${contractId}"/>
				</c:forEach>
		</wcf:rest>
		
		<%-- Check if the parent is a product and not package or bundle --%>
		<c:if test="${parentCatalogNavigationView.catalogEntryView[0].catalogEntryTypeCode eq 'ProductBean'}">
			<%-- Keep all the defining attributes and its value in WCParam so that it will be selected by default --%>
			<c:forEach var="attribute" items="${catalogNavigationView.catalogEntryView[0].attributes}">
				<c:if test="${attribute.usage eq 'Defining'}">
					<c:set target="${WCParam}" property="${attribute.name}" value="${attribute.values[0].value}"/>
				</c:if>
			</c:forEach>
			
			<%-- So that the parent page can be displayed instead of item page and pre select the values correspoding to the item --%>
			<c:set var="catalogNavigationView" value="${parentCatalogNavigationView}" />
			<c:set var="itemId" value="${productId}" scope="request"/>
			<c:set var="productId" value="${parentCatEntryId}" scope="request"/>
			<c:set var="catalogEntryDetails" value="${catalogNavigationView.catalogEntryView[0]}"/>
			
			<%-- Cache parent catalog entry in our internal hash map --%>
			<c:set var="key1" value="${productId}+getCatalogEntryViewAllByID"/>
			<wcf:set target = "${cachedCatalogEntryDetailsMap}" key="${key1}" value="${catalogNavigationView.catalogEntryView[0]}"/>
		</c:if>
	</c:if>
	
</c:if>

<c:set var="displaySKUContextData" value="false" scope="request" />
<c:set var="singleSKUProductWithoutDefiningAttribute" value="false" scope="request"/>
<c:set var="pageTitle" value="${page.title}" />
<c:set var="metaDescription" value="${page.metaDescription}" />
<c:set var="metaKeyword" value="${page.metaKeyword}" />
<c:set var="fullImageAltDescription" value="${page.fullImageAltDescription}" scope="request" />
<c:set var="categoryId" value="${catalogNavigationView.catalogEntryView[0].parentCatalogGroupID}"/>
<c:set var="partNumber" value="${catalogNavigationView.catalogEntryView[0].partNumber}" scope="request"/>
<c:if test="${ empty partNumber}">
	<c:set var="partNumber" value="${page.partNumber}" scope="request"/>
</c:if>
<c:set var="search" value='"'/>
<c:set var="replaceStr" value="'"/>
<c:set var="search01" value="'"/>
<c:set var="replaceStr01" value="\\'"/>

<c:set var="type" value="${fn:toLowerCase(catalogEntryDetails.catalogEntryTypeCode)}" />
<c:set var="type" value="${fn:replace(type,'bean','')}" />
<c:choose>
	<c:when test="${type == 'item'}">
		<c:set var="pageGroup" value="Item" scope="request"/>
	</c:when>
	<c:otherwise>
		<c:set var="pageGroup" value="Product" scope="request"/>
	</c:otherwise>
</c:choose>

<c:choose>
	<%-- Use the context parameters if they are available; usually in a subcategory --%>
	<c:when test="${!empty parent_category_rn && !empty top_category && parent_category_rn ne top_category}">
		<%-- both parent and top category are present.. display full product URL --%>
		<c:set var="parent_category_rn" value="${parent_category_rn}" />
		<c:set var="top_category" value="${top_category}" />
		<c:set var="categoryId" value="${categoryId}" />
		<c:set var="patternName" value="ProductURLWithParentAndTopCategory"/>
	</c:when>
	<c:when test="${!empty parent_category_rn}">
		<%-- parent category is not empty..use product URL with parent category --%>
		<c:set var="parent_category_rn" value="${parent_category_rn}" />
		<c:set var="top_category" value="${top_category}" />
		<c:set var="categoryId" value="${categoryId}" />
		<c:set var="patternName" value="ProductURLWithParentCategory"/>
	</c:when>
	<%-- In a top category; use top category parameters --%>
	<c:when test="${!empty categoryId}">
		<c:set var="parent_category_rn" value="${parent_category_rn}" />
		<c:set var="top_category" value="${top_category}" />
		<c:set var="categoryId" value="${categoryId}" />
		<c:set var="patternName" value="ProductURLWithCategory"/>
	</c:when>
	<%-- Store front main page; usually eSpots, parents unknown --%>
	<c:otherwise>
		<c:set var="parent_category_rn" value="${parent_category_rn}" />
		<c:set var="top_category" value="${top_category}" />
		<%-- Just display productURL without any category info --%>
		<c:set var="patternName" value="ProductURL"/>
	</c:otherwise>
</c:choose>

<c:if test="${empty parentCatEntryId}">
	<c:set var="parentCatEntryId" value="${productId}"/>
</c:if>

<wcf:url var="ProductDisplayURL" patternName="${patternName}" value="Product1" scope="request">
	<wcf:param name="catalogId" value="${catalogId}"/>
	<wcf:param name="storeId" value="${storeId}"/>
	<wcf:param name="productId" value="${parentCatEntryId}"/>
	<wcf:param name="langId" value="${langId}"/>
	<wcf:param name="urlLangId" value="${urlLangId}" />
	<wcf:param name="categoryId" value="${categoryId}" />
	<wcf:param name="parent_category_rn" value="${parent_category_rn}" />
	<wcf:param name="top_category" value="${top_category}" />
</wcf:url>

<c:set var="productWithoutDefiningAttribute" value="true"/>

<c:if test="${!empty catalogEntryDetails.attributes}">
	<c:forEach var="attribute" items="${catalogEntryDetails.attributes}">
		<c:if test="${attribute.usage eq 'Defining'}">
			<c:set var="productWithoutDefiningAttribute" value="false"/>
		</c:if>
	</c:forEach>
</c:if>

<c:set var="redirectSKUUrl" value="" scope="request"/>

<c:if test="${productWithoutDefiningAttribute && catalogEntryDetails.numberOfSKUs eq 1 && !empty catalogEntryDetails.singleSKUCatalogEntryID}">
	<c:set var="singleSKUProductWithoutDefiningAttribute" value="true" scope="request"/>
	<wcf:url var="SkuURL" patternName="ProductURL" value="Product2">
		<wcf:param name="catalogId" value="${catalogId}"/>
		<wcf:param name="storeId" value="${storeId}"/>
		<wcf:param name="productId" value="${catalogEntryDetails.singleSKUCatalogEntryID}"/>
		<wcf:param name="langId" value="${langId}"/>
		<wcf:param name="urlLangId" value="${urlLangId}" />
	</wcf:url>
	
	<c:if test="${ProductDisplayURL != SkuURL && displaySKUContextData == 'true' && empty itemId}">
		<c:set var="redirectSKUUrl" value="${SkuURL}" scope="request"/>
	</c:if>
</c:if>

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
		<meta name="viewport" content="<c:out value="${viewport}"/>"/>
		<meta name="description" content="<c:out value="${metaDescription}"/>"/>
		<meta name="keywords" content="<c:out value="${metaKeyword}"/>"/>
		<meta name="pageIdentifier" content="<c:out value="${partNumber}"/>"/>
		<meta name="pageId" content="<c:out value="${productId}"/>"/>
		<meta name="pageGroup" content="<c:out value="${pageGroup}"/>"/>
	    <link rel="canonical" href="<c:out value="${ProductDisplayURL}"/>" />
		
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
					<c:if test="${!empty redirectSKUUrl}">					
						document.location.href = "${redirectSKUUrl}";		
					</c:if>
				});
			<c:if test="${!empty requestScope.deleteCartCookie && requestScope.deleteCartCookie[0]}">					
					document.cookie = "WC_DeleteCartCookie_${requestScope.storeId}=true;path=/";				
				</c:if>
		</script>
		
		<flow:ifEnabled feature="FacebookIntegration">
			<%@include file="../../../Common/JSTLEnvironmentSetupExtForFacebook.jspf" %>
			
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
			
			<meta property="og:url" content="<c:out value="${ProductDisplayURL}"/>"/>
			<meta property="og:type" content="product"/>
			<meta property="og:description" content="<c:out value="${metaDescription}"/>" />
			<meta property="fb:app_id" name="fb_app_id" content="<c:out value="${facebookAppId}"/>"/>
		</flow:ifEnabled>
		
			<wcpgl:jsInclude/>
	</head>
		
	<body>
		<%-- This file includes the progressBar mark-up and success/error message display markup --%>
		<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
<div id="IntelligentOfferMainPartNumber" style="display:none;"><c:out value="${partNumber}" /></div>
<div id="IntelligentOfferCategoryId" style="display:none;"><c:out value="${categoryId}" /></div>
<div id="displaySKUContextData" style="display:none;"><c:out value="${displaySKUContextData}" /></div>
<c:set var="catalogEntryID" value="${catalogEntryDetails.uniqueID}" />
<c:set var="entitledItems" value="${catalogEntryDetails.sKUs}"/>
<c:set var="numberOfSKUs" value="${catalogEntryDetails.numberOfSKUs}"/>
<c:set var="attributes" value="${catalogEntryDetails.attributes}"/>
<div id="entitledItem_<c:out value='${catalogEntryID}'/>" style="display:none;">
		[
		<c:if test="${type == 'product'}">

				<%-- SwatchCode start --%>
				<c:if test="${!empty entitledItems}">
				<%-- Find out if we have angle image attachments in the product, if there is then we should retrieve that for all items. --%>
					<%-- Otherwise, we can use a lighter service. --%>
					<c:set var="hasAngleImages" value="false" />
					<c:set var="allAttachments" value="${catalogEntryDetails.attachments}" />
					<c:forEach var="anAttachment" items="${allAttachments}">
						<c:if test="${'ANGLEIMAGES_THUMBNAIL' eq anAttachment.usage}">
							<c:set var="hasAngleImages" value="true" />
						</c:if>
					</c:forEach>
				</c:if>
				<%-- SwatchCode end --%>

				<c:forEach var='entitledItem' items='${entitledItems}' varStatus='outerStatus'>
					<c:if test="${entitledItem.buyable eq 'true' || buyablePurchasable eq 'true'}">
						<c:set var="sku" value="${entitledItem}"/>
						<c:set var="skuID" value="${entitledItem.uniqueID}"/>
						
						<wcf:url var="catEntryDisplayUrl" patternName="${patternName}" value="Product2">
							<wcf:param name="catalogId" value="${catalogId}"/>
							<wcf:param name="storeId" value="${storeId}"/>
							<wcf:param name="productId" value="${skuID}"/>
							<wcf:param name="langId" value="${langId}"/>
							<wcf:param name="urlLangId" value="${urlLangId}" />
							<wcf:param name="categoryId" value="${categoryId}" />
							<wcf:param name="parent_category_rn" value="${parent_category_rn}" />
							<wcf:param name="top_category" value="${top_category}" />
						</wcf:url>
							
						{
						"catentry_id" : "<c:out value='${skuID}' />",
						"seo_url" : "<c:out value='${catEntryDisplayUrl}' />",
						"displaySKUContextData" : "<c:out value='${displaySKUContextData}' />",
						"buyable" : "<c:out value='${entitledItem.buyable}' />",
						"Attributes" :	{
							<c:set var="hasAttributes" value="false"/>											
							<c:forEach var="definingAttrValue2" items="${sku.attributes}" varStatus="innerStatus">
								<c:if test="${definingAttrValue2.usage == 'Defining'}">
									<c:if test='${hasAttributes eq "true"}'>,</c:if>
									"<c:out value="${fn:replace(fn:replace(definingAttrValue2.name, search01, replaceStr01), search, replaceStr)}_|_${fn:replace(fn:replace(definingAttrValue2.values[0].value, search01, replaceStr01), search, replaceStr)}" />":"<c:out value='${innerStatus.count}' />"
									<c:set var="hasAttributes" value="true"/>
								</c:if>
							</c:forEach>
							},
							
							<%-- SwatchCode start --%>
							<c:if test="${!empty entitledItem.thumbnail}">
								<c:choose>
									<c:when test="${(fn:startsWith(entitledItem.thumbnail, 'http://') || fn:startsWith(entitledItem.thumbnail, 'https://'))}">
										<wcst:resolveContentURL var="thumbnailImage" url="${entitledItem.thumbnail}"/>
									</c:when>
									<c:otherwise>
										<c:set var="thumbnailImage" value="${entitledItem.thumbnail}" />
									</c:otherwise>
								</c:choose>
								<c:set var="itemFullImagePath" value="${fn:replace(thumbnailImage, productThumbnailImage, productMasterImage)}" />
							</c:if>
							
							<c:if test="${empty itemFullImagePath}">
								<c:set var="itemFullImagePath" value="${hostPath}${jspStoreImgDir}images/NoImageIcon.jpg"/>
							</c:if>
								
									"ItemImage" : "<c:out value='${itemFullImagePath}' />",
									"ItemImage467" : "<c:out value='${itemFullImagePath}' />",
									"ItemThumbnailImage" : "<c:out value='${fn:replace(itemFullImagePath, productMasterImage, productThumbnailImage)}' />"
									<c:if test="${fn:length(entitledItem.attachments) > 0}">
										,"ItemAngleThumbnail" : {
										<c:set var="imageCount" value="0" />
										<c:forEach var="itemAttachment" items="${entitledItem.attachments}" varStatus="status1">
											<c:if test="${itemAttachment.usage == 'ANGLEIMAGES_THUMBNAIL'}">
												<c:if test='${imageCount gt 0}'>,</c:if>
												<c:set var="imageCount" value="${imageCount+1}" />
												<c:choose>
													<c:when test="${(fn:startsWith(itemAttachment.attachmentAssetPath, 'http://') || fn:startsWith(itemAttachment.attachmentAssetPath, 'https://'))}">
														<wcst:resolveContentURL var="resolvedPath" url="${itemAttachment.attachmentAssetPath}"/>
													</c:when>
													<c:otherwise>
														<c:set var="resolvedPath" value="${env_imageContextPath}/${itemAttachment.attachmentAssetPath}" />
													</c:otherwise>
												</c:choose>
												"image_${imageCount}" : "<c:out value='${resolvedPath}' />"
											</c:if>
										</c:forEach>
										},
										"ItemAngleThumbnailShortDesc" : {
										<c:set var="imageCount" value="0" />
										<c:forEach var="itemAttachment" items="${entitledItem.attachments}" varStatus="status1">
											<c:if test="${itemAttachment.usage == 'ANGLEIMAGES_THUMBNAIL'}">
												<c:if test='${imageCount gt 0}'>,</c:if>
												<c:set var="imageCount" value="${imageCount+1}" />
												"image_${imageCount}" : '<c:out value="${fn:replace(itemAttachment.name, search01, replaceStr01)}"/>'
											</c:if>
										</c:forEach>
										},										
										"ItemAngleFullImage" : {
										<c:set var="imageCount" value="0" />
										<c:forEach var="itemAttachment" items="${entitledItem.attachments}" varStatus="status2">
											<c:set var="imgSource" value="${itemAttachment.attachmentAssetPath}" />
											<c:if test="${itemAttachment.usage == 'ANGLEIMAGES_FULLIMAGE'}">
												<c:if test='${imageCount gt 0}'>,</c:if>
												<c:set var="imageCount" value="${imageCount+1}" />
												<c:choose>
													<c:when test="${(fn:startsWith(imgSource, 'http://') || fn:startsWith(imgSource, 'https://'))}">
														<wcst:resolveContentURL var="imgSource" url="${imgSource}"/>
													</c:when>
													<c:otherwise>
														<c:set var="imgSource" value="${env_imageContextPath}/${imgSource}" />
													</c:otherwise>
												</c:choose>
												"image_${imageCount}" : "<c:out value='${imgSource}' />"
											</c:if>
										</c:forEach>
										}
									</c:if>
							<%-- SwatchCode end --%>
						}<c:if test='${!outerStatus.last}'>,</c:if>
					</c:if>
				</c:forEach>
			
		</c:if>
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
			<%-- CODE FOR DISPLAYING PREVIOUS AND NEXT PRODUCTS IN PDP --%>
			<div>
				<c:set var="nextProdUrl" value=""/>
		        <c:set var="prevProdUrl" value=""/>
		        <wcbase:useBean id="catObject" classname="com.ibm.commerce.catalog.beans.CategoryDataBean" scope="page">
		         <c:set property="categoryId" value="${categoryId}" target="${catObject}" />
		         <c:if test="${(!empty catalogId)}">
		          <c:set property="catalogId" value="${catalogId}" target="${catObject}" />
		         </c:if>
		        </wcbase:useBean>
		        <c:forEach var="eachCatEntry" items="${catObject.products}" varStatus='counter'>
		         <c:if test="${eachCatEntry.productID eq productId}">
		          <c:set var="currentProductIndex" value="${counter.count}"/>
		          <c:choose>
		           <c:when test="${counter.first}">
		            <c:set var="isFirstProd" value="${true }"/>
		           </c:when>
		           <c:when test="${counter.last}">
		            <c:set var="isLastProd" value="${true }"/>
		           </c:when>
		          </c:choose>
		         </c:if>
		        </c:forEach>
       			 <%-- ARRAY INDEX IS ALWAYS ONE LESS THAN THE COUNTER INDEXT GETTING FROM FOR EACH ATTRIBUTE.HENCE REDUCING BY ONE TO GET ARRAY INDEX  --%>
        		<c:set var="catEntryIdentifier" value="${catalogEntryDetails.uniqueID}" /> 
				<c:choose>
				 <c:when test="${(fn:startsWith(catalogEntryDetails.thumbnail, 'http://') || fn:startsWith(catalogEntryDetails.thumbnail, 'https://'))}">
				  <wcst:resolveContentURL var="productThumbNail" url="${catalogEntryDetails.thumbnail}"/>
				 </c:when>
				 <c:otherwise>
				  <c:set var="productThumbNail" value="${catalogEntryDetails.thumbnail}" />
				 </c:otherwise>
				</c:choose>
			        <c:set var="currentProductArrayIndex" value="${currentProductIndex-1}"/>
			        <span style="font-family: Arial;color: brown;font-size: 12px;padding-left: 10px;vertical-align: middle;height: 60px;font-weight: bold;"> 
			         <c:if test="${not isFirstProd}">
			          <c:set var="prevProductId" value="${catObject.products[currentProductArrayIndex-1].productID}"/>
			          
		          <wcf:rest var="prevCatalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${prevProductId}" > 
						  <wcf:param name="langId" value="${langId}"/>
						  <wcf:param name="currency" value="${env_currencyCode}"/>
						  <wcf:param name="responseFormat" value="json"/>  
						  <wcf:param name="catalogId" value="${WCParam.catalogId}"/>
						  <c:forEach var="contractId" items="${env_activeContractIds}">
						   <wcf:param name="contractId" value="${contractId}"/>
						  </c:forEach>
		 			</wcf:rest>
		 			
          			<c:if test="${!empty prevCatalogNavigationView && !empty prevCatalogNavigationView.catalogEntryView[0]}">
					  <c:set var="prevCatalogEntryDetails" value="${prevCatalogNavigationView.catalogEntryView[0]}"/>
					 </c:if>
					 <c:set var="prevproductThumbNail" value="${prevCatalogEntryDetails.thumbnail}" />
					 <c:choose>
					 <c:when test="${!empty prevproductThumbNail}">
					  <c:set var="previmgSource" value="${prevproductThumbNail}" />
					 </c:when>
					 <c:otherwise>
					  <c:set var="previmgSource" value="${jspStoreImgDir}images/NoImageIcon_sm.jpg" />
					 </c:otherwise>
					</c:choose>
					
			        <wcf:url var="prevProdUrl" patternName="ProductURL" value="Product1">
			           <wcf:param name="langId" value="${langId}" />
			           <wcf:param name="storeId" value="${storeId}" />
			           <wcf:param name="catalogId" value="${catalogId}" />
			           <wcf:param name="productId" value="${prevProductId}" />
			           <wcf:param name="urlLangId" value="${urlLangId}" />
			        </wcf:url>
					
			        <a href="${prevProdUrl}" > < <img style="vertical-align: middle;" src="${previmgSource}" height="80" width="80"/> </a>
			          <c:remove var="prevCatalogNavigationView"/>
			         </c:if> 
			         
			          Displaying ${currentProductIndex} of ${fn:length(catObject.products)}
			         <c:if test="${not isLastProd }">
			          <c:set var="nextProductId" value="${catObject.products[currentProductArrayIndex+1].productID}"/>
          
					 <wcf:rest var="nextCatalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byId/${nextProductId}" > 
					  <wcf:param name="langId" value="${langId}"/>
					  <wcf:param name="currency" value="${env_currencyCode}"/>
					  <wcf:param name="responseFormat" value="json"/>  
					  <wcf:param name="catalogId" value="${WCParam.catalogId}"/>
					  <c:forEach var="contractId" items="${env_activeContractIds}">
					   <wcf:param name="contractId" value="${contractId}"/>
					  </c:forEach>
					 </wcf:rest>
					 
					 <c:if test="${!empty nextCatalogNavigationView && !empty nextCatalogNavigationView.catalogEntryView[0]}">
					  <c:set var="nextCatalogEntryDetails" value="${nextCatalogNavigationView.catalogEntryView[0]}"/>
					 </c:if>
					 
					 <c:set var="nextproductThumbNail" value="${nextCatalogEntryDetails.thumbnail}" />
					 <c:choose>
					 <c:when test="${!empty nextproductThumbNail}">
					  <c:set var="nextImgSource" value="${nextproductThumbNail}" />
					 </c:when>
					 <c:otherwise>
					  <c:set var="nextImgSource" value="${jspStoreImgDir}images/NoImageIcon_sm.jpg" />
					 </c:otherwise>
					</c:choose>
          				
          			<wcf:url var="nextProdUrl" patternName="ProductURL" value="Product1">
			           <wcf:param name="langId" value="${langId}" />
			           <wcf:param name="storeId" value="${storeId}" />
			           <wcf:param name="catalogId" value="${catalogId}" />
			           <wcf:param name="productId" value="${nextProductId}" />
			           <wcf:param name="urlLangId" value="${urlLangId}" />
			        </wcf:url>
			        <a href="${nextProdUrl}"><img  style="vertical-align: middle;" src="${nextImgSource}" height="80" width="80"/> > </a>
			        <c:remove var="nextCatalogNavigationView"/>
			         </c:if>
			        </span><br/>
			</div>
			<%-- END CODE FOR DISPLAYING PREVIOUS AND NEXT PRODUCTS IN PDP --%>
			
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
<!-- END ProductDisplay.jsp -->		
</html>
