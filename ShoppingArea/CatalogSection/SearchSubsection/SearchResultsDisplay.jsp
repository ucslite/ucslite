<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN SearchResultsDisplay.jsp -->

<%@include file="../../../Common/EnvironmentSetup.jspf" %>
<%@include file="../../../Common/nocache.jspf" %>

<%@ taglib uri="http://commerce.ibm.com/pagelayout" prefix="wcpgl" %>

<c:set var="pageGroup" value="Search" scope="request"/>
<c:set var="pageCategory" value="Browse" scope="request"/>

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
	xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><fmt:message bundle="${storeText}" key="TITLE_SEARCH_RESULTS"/></title>
		<meta name="description" content=""/>
		<meta name="keywords" content=""/>
		<meta name="pageIdentifier" content="<c:out value="${WCParam.searchTerm}"/>"/>
		<meta name="pageId" content=""/>
		<meta name="pageGroup" content="<c:out value="${requestScope.pageGroup}"/>"/>
		
		<!--Main Stylesheet for browser -->
		<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheet}" type="text/css" media="screen"/>
		<!-- Style sheet for print -->
		<link rel="stylesheet" href="${jspStoreImgDir}${env_vfileStylesheetprint}" type="text/css" media="print"/>

		<!-- Include script files -->
		<%@include file="../../../Common/CommonJSToInclude.jspf" %>
		
		<script type="text/javascript" src="${jsAssetsDir}javascript/CommonContextsDeclarations.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/CommonControllersDeclaration.js"></script>
		<script type="text/javascript" src="${jsAssetsDir}javascript/Widgets/collapsible.js"></script>
		
<%@ include file="/Widgets_701/Common/SearchSetup.jspf" %>

<c:set var="searchTabSubText1" value="${totalCount}" scope="request"/>
<c:set var="searchTabSubText2" value="${totalContentCount}" scope="request"/>

<%-- If we have only one search result, then redirect shopper to the page directly instead of showing the results --%>
<c:choose>
	<c:when test="${totalContentCount == 0 && totalCount == 1 && !searchMissed && empty WCParam.categoryId && empty WCParam.manufacturer}">
		<c:forEach var="breadcrumb" items="${globalbreadcrumbs.breadCrumbTrailEntryView}">
			<c:if test="${breadcrumb.type_ == 'FACET_ENTRY_CATEGORY'}">
				<c:if test="${empty searchTopCategoryId}">
					<c:set var="searchTopCategoryId" value="${breadcrumb.value}" scope="request"/>
				</c:if>
				<c:set var="searchParentCategoryId" value="${breadcrumb.value}" scope="request"/>
			</c:if>
		</c:forEach>

		<%-- Global Results will contain only one element --%>
		<c:forEach var="catEntry" items="${globalresults}" varStatus="status">
			<c:set var="catEntryIdentifier" value="${catEntry.uniqueID}"/>
			<c:set var="catEntryDetails" value="${catEntry}"/>
		</c:forEach>

		<c:choose>
			<%-- Use the context parameters if they are available; usually in a subcategory --%>
			<c:when test="${!empty searchParentCategoryId && !empty searchTopCategoryId}">
				<%-- both parent and top category are present.. display full product URL --%>
				<c:set var="parent_category_rn" value="${searchTopCategoryId}" />
				<c:set var="top_category" value="${searchTopCategoryId}" />
				<c:set var="categoryId" value="${searchParentCategoryId}" />
				<c:set var="patternName" value="ProductURLWithParentAndTopCategory"/>
			</c:when>
			<c:when test="${!empty searchParentCategoryId}">
				<%-- parent category is not empty..use product URL with parent category --%>
				<c:set var="parent_category_rn" value="${searchParentCategoryId}" />
				<c:set var="top_category" value="${searchTopCategoryId}" />
				<c:set var="categoryId" value="${WCParam.categoryId}" />
				<c:set var="patternName" value="ProductURLWithParentCategory"/>
			</c:when>
			<%-- In a top category; use top category parameters --%>
			<c:when test="${WCParam.top == 'Y'}">
				<c:set var="parent_category_rn" value="${searchParentCategoryId}" />
				<c:set var="top_category" value="${searchTopCategoryId}" />
				<c:set var="categoryId" value="${WCParam.categoryId}" />
				<c:set var="patternName" value="ProductURLWithCategory"/>
			</c:when>
			<%-- Store front main page; usually eSpots, parents unknown --%>
			<c:otherwise>
				<c:set var="parent_category_rn" value="${searchParentCategoryId}" />
				<c:set var="top_category" value="${searchTopCategoryId}" />
				<%-- Just display productURL without any category info --%>
				<c:set var="patternName" value="ProductURL"/>
			</c:otherwise>
		</c:choose>
		
		<c:set var="productIdForURL" value="${catEntryIdentifier}"/>
		<c:if test="${env_displaySKUContextData && catEntryDetails.hasSingleSKU}">
		  <c:set var="productIdForURL" value="${catEntryDetails.singleSKUCatalogEntryID}"/>
		</c:if>
		<wcf:url var="catEntryDisplayUrl" patternName="${patternName}" value="Product2">
			<wcf:param name="catalogId" value="${catalogId}"/>
			<wcf:param name="storeId" value="${storeId}"/>
			<wcf:param name="productId" value="${productIdForURL}"/>
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="errorViewName" value="ProductDisplayErrorView"/>
			<wcf:param name="categoryId" value="${WCParam.categoryId}" />
			<wcf:param name="parent_category_rn" value="${searchParentCategoryId}" />
			<wcf:param name="top_category" value="${searchTopCategoryId}" />
			<wcf:param name="urlLangId" value="${urlLangId}" />
		</wcf:url>
		<%-- 
			Set redirect == true.. Since we have only one result, we will display the product page directly instead of search results page.. 
			do not do <c:redirect here.. SearchTermHistroy cookie will be updated at client browser and then redirect happens
		--%>
		<c:set var="redirect" value="true"/>
		<c:if test="${empty updatedSearchTermHistory}">
			<%-- Nothing to update in cookie.. redirect from here itself --%>
			<c:set var="redirected" value="true"/>
			</head>
			<body>
			<c:redirect url="${catEntryDisplayUrl}"/>
			</body>
			</html>
		</c:if>
	</c:when>
	<c:otherwise>
		<%-- If we are here, then we have either 0 results or more than 1 result --%>
		<c:set var="pageView" value="${WCParam.pageView}" scope="request"/>
		<c:if test="${empty pageView}" >
			<c:set var="pageView" value="${env_defaultPageView}" scope="request"/>
		</c:if>


		<%-- Get SEO data and canonical URL --%>
		<wcf:url var="CategoryDisplayURL" patternName="CanonicalCategoryURL" value="Category3">
			<wcf:param name="langId" value="${langId}" />
			<wcf:param name="storeId" value="${storeId}" />
			<wcf:param name="catalogId" value="${catalogId}" />
			<wcf:param name="categoryId" value="${WCParam.categoryId}" />	
			<wcf:param name="urlLangId" value="${urlLangId}" />							
		</wcf:url>

		<wcf:url var="CategoryNavigationResultsViewURL" value="CategoryNavigationResultsView" type="Ajax">
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="storeId" value="${storeId}"/>
			<wcf:param name="catalogId" value="${catalogId}"/>
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="sType" value="SimpleSearch"/>						
			<wcf:param name="categoryId" value="${WCParam.categoryId}"/>		
			<wcf:param name="searchType" value="${WCParam.searchType}"/>	
			<wcf:param name="metaData" value="${metaData}"/>	
			<wcf:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}"/>	
			<wcf:param name="filterFacet" value="${WCParam.filterFacet}"/>
			<wcf:param name="manufacturer" value="${WCParam.manufacturer}"/>
			<wcf:param name="searchTermScope" value="${WCParam.searchTermScope}"/>
			<wcf:param name="filterTerm" value="${WCParam.filterTerm}" />
			<wcf:param name="filterType" value="${WCParam.filterType}" />
			<wcf:param name="advancedSearch" value="${WCParam.advancedSearch}"/>
			<wcf:param name="searchForContent" value="false"/>
		</wcf:url>

		<wcf:url var="CategoryNavigationResultsViewContentURL" value="CategoryNavigationResultsContentView" type="Ajax">
			<wcf:param name="langId" value="${langId}"/>
			<wcf:param name="storeId" value="${storeId}"/>
			<wcf:param name="catalogId" value="${catalogId}"/>
			<wcf:param name="pageSize" value="${pageSize}"/>
			<wcf:param name="sType" value="SimpleSearch"/>						
			<wcf:param name="categoryId" value="${WCParam.categoryId}"/>		
			<wcf:param name="searchType" value="${WCParam.searchType}"/>	
			<wcf:param name="metaData" value="${metaData}"/>	
			<wcf:param name="resultCatEntryType" value="${WCParam.resultCatEntryType}"/>	
			<wcf:param name="filterFacet" value="${WCParam.filterFacet}"/>
			<wcf:param name="manufacturer" value="${WCParam.manufacturer}"/>
			<wcf:param name="searchTermScope" value="${WCParam.searchTermScope}"/>
			<wcf:param name="filterTerm" value="${WCParam.filterTerm}" />
			<wcf:param name="filterType" value="${WCParam.filterType}" />
			<wcf:param name="advancedSearch" value="${WCParam.advancedSearch}"/>
		</wcf:url>
		
		<link rel="canonical" href="<c:out value="${CategoryDisplayURL}"/>" />
	</c:otherwise>
</c:choose>


	<c:if test="${!redirected}">
		<%-- No redirection happend at server side.. But we may still redirect from client side, if redirect = true --%>
		<c:if test="${empty redirect}">
			<%-- We are not redirecting at client side using script method.. So get page design to display the page.. --%>
			<wcf:rest var="getPageDesignResponse" url="store/{storeId}/page_design">
				<wcf:var name="storeId" value="${storeId}" encode="true"/>
				<wcf:param name="catalogId" value="${catalogId}"/>
				<wcf:param name="langId" value="${langId}"/>
				<wcf:param name="q" value="byObjectIdentifier"/>
				<c:choose>
					<c:when test="${empty WCParam.searchTerm}">
						<wcf:param name="objectIdentifier" value="-1"/>
					</c:when>
					<c:otherwise>
						<c:set var="escapeSearchTerm" value="${fn:replace(WCParam.searchTerm,'$','\\\$')}"/>
						<wcf:param name="objectIdentifier" value="${fn:escapeXml(escapeSearchTerm)}"/>
					</c:otherwise>
				</c:choose>
				<wcf:param name="deviceClass" value="${deviceClass}"/>
				<wcf:param name="pageGroup" value="${pageGroup}"/>
			</wcf:rest>
			<c:set var="pageDesign" value="${getPageDesignResponse.resultList[0]}" scope="request"/>
			<c:set var="PAGE_DESIGN_DETAILS_JSON_VAR" value="pageDesign" scope="request"/>
		</c:if>
				<c:if test="${empty redirect}">
					<wcpgl:jsInclude/>
				</c:if>

				<script type="text/javascript">
				  dojo.addOnLoad(function() {					
						var searchTabProdCount = byId('searchTabProdCount');
						if(searchTabProdCount != null) {
							searchTabProdCount.innerHTML = <c:out value="${totalCount}"/>;
						}
						var searchTabContentCount = byId('searchTabContentCount');
						if(searchTabContentCount != null) {
							searchTabContentCount.innerHTML = <c:out value="${totalContentCount}"/>;
						}
						shoppingActionsJS.initCompare('<c:out value="${param.fromPage}"/>');
					});
				</script>

				<input id="searchBoxText" name="searchBoxText" type="hidden" aria-hidden="true" value="<c:out value='${WCParam.searchTerm}'/>"/>
				<c:choose>
					<c:when test="${empty redirect}">
						<script type="text/javascript">
							dojo.addOnLoad(function() { 
								shoppingActionsServicesDeclarationJS.setCommonParameters('<c:out value="${langId}" />','<c:out value="${storeId}" />','<c:out value="${catalogId}" />');
								<c:if test="${!empty updatedSearchTermHistory}">
									SearchJS.updateSearchTermHistoryCookie("<c:out value='${updatedSearchTermHistory}'/>");										
								</c:if>
								dojo.byId("SimpleSearchForm_SearchTerm").className = "search_input";
								dojo.byId("SimpleSearchForm_SearchTerm").value = document.getElementById("searchBoxText").value;
							});
						</script>
						<flow:ifEnabled feature="Analytics">
							<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Analytics.js"/>"></script>
							<script type="text/javascript">
							  dojo.addOnLoad(function() {
									analyticsJS.storeId="<c:out value="${storeId}"/>";
									analyticsJS.catalogId="<c:out value="${catalogId}"/>";
							//		analyticsJS.loadMiniShopCartHandler();
									analyticsJS.loadPagingHandler();
									analyticsJS.loadSearchResultHandler("catalogSearchResultDisplay_Controller","catalog_search_result_information", true, "Advanced_Search_Form_div");
								});

							</script>
						</flow:ifEnabled>
					</c:when>
					<c:otherwise>
						<%--- Redirect is needed.. Will be done at client side.... OnLoad,update the searchTermHistory and redirect --%>
						<script type="text/javascript">
							dojo.addOnLoad(function() { 
									SearchJS.updateSearchTermHistoryCookieAndRedirect("<c:out value='${updatedSearchTermHistory}'/>", "${catEntryDisplayUrl}");										
							});
							if (navigator.userAgent.toLowerCase().indexOf('firefox') > -1) {document.location.href = "${catEntryDisplayUrl}";}
						</script>
					</c:otherwise>
				</c:choose>
			</head>
				
			<c:if test="${empty redirect}">
				<body>
					<%-- This file includes the progressBar mark-up and success/error message display markup --%>
					<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
				
					<c:set var="layoutPageIdentifier" value="${WCParam.searchTerm}"/>
					<c:set var="layoutPageName" value="${WCParam.searchTerm}"/>
					<%@ include file="/Widgets_701/Common/ESpot/LayoutPreviewSetup.jspf"%>
						
					<div id="page">
						<div id="grayOut"></div>
						<div id="headerWrapper">
							<%out.flush();%>
							<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" />
							<%out.flush();%>
						</div>
						
						<div id="contentWrapper">
							<div id="content" role="main">
								<c:set var="rootWidget" value="${pageDesign.widget}"/>
								<wcpgl:widgetImport uniqueID="${rootWidget.widgetDefinitionId}" debug=false/>
							</div>
						</div>
						
						<div id="footerWrapper">
							<%out.flush();%>
							<c:import url="${env_jspStoreDir}Widgets/Footer/Footer.jsp"/>
							<%out.flush();%>
						</div>
					</div>		
				<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
			
				<!--Start: Contents after page load-->
				<c:if test="${env_fetchMarketingDetailsOnLoad}">
				<%out.flush();%>
					<c:import url = "${env_jspStoreDir}Widgets/PageLoadContent/PageLoadContent.jsp">
						<c:param name="doubleContentAreaESpot" value="true"/>
					</c:import>
				<%out.flush();%>
				</c:if>
				<!--End: Contents after page load-->
				<wcpgl:pageLayoutCache pageLayoutId="${pageDesign.layoutId}"/>				
				<!-- END SearchResultsDisplay.jsp -->
			</c:if>

			<flow:ifEnabled feature="Analytics">
				<script type="text/javascript">
					dojo.addOnLoad(function() {
						analyticsJS.registerSearchResultPageView("catalogSearchResultDisplay_Controller","catalog_search_result_information", true, "Advanced_Search_Form_div");
					});
				</script>
			</flow:ifEnabled>

		</html>

</c:if>
