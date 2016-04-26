<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN CategoryNavigationResults.jsp -->

<%@include file="../../../Common/EnvironmentSetup.jspf" %>
<%@include file="../../../Common/nocache.jspf" %>

<c:choose>
	<c:when test="${!empty WCParam.searchTerm || !empty WCParam.manufacturer}">
		<%@include file = "../../../../Widgets_701/Common/SearchSetup.jspf" %>
	</c:when>
	<c:otherwise>
		<%@include file = "../../../../Widgets_701/Common/CategoryNavigationSetup.jspf" %>
	</c:otherwise>
</c:choose>

<c:set var="endIndex" value = "${pageSize + beginIndex}"/>
<c:if test="${endIndex > totalCount}">
	<c:set var="endIndex" value = "${totalCount}"/>
</c:if>


<%-- totalCount is set in SearchSetup.jspf file.. --%>
<fmt:parseNumber var="total" value="${totalCount}" parseLocale="en_US"/> <%-- Get a float value from totalCount which is a string --%>
<c:set  var="totalPages"  value = "${total / pageSize * 1.0}"/>
<%-- Get a float value from totalPages which is a string --%>
<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="false" parseLocale="en_US"/> 

<%-- do a ceil if totalPages contains fraction digits --%>
<c:set var="totalPages" value = "${totalPages + (1 - (totalPages % 1)) % 1}"/>

<c:set var="currentPage" value = "${( beginIndex + 1) / pageSize}" />
<%-- Get a float value from currentPage which is a string --%>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="false" parseLocale="en_US"/>

<%-- do a ceil if currentPage contains fraction digits --%>
<c:set var="currentPage" value = "${currentPage + (1 - (currentPage % 1)) % 1}"/>

<%-- Get a float value from currentPage which is a string --%>
<fmt:parseNumber var="currentPage" value="${currentPage}" integerOnly="false" parseLocale="en_US"/>

<%-- Get number of items to be displayed in this page --%>
<fmt:parseNumber var="numOfItemsInPage" value="${endIndex - beginIndex}" integerOnly="false" parseLocale="en_US"/>

<%-- If we are using grid mode, then we need to know the total number of rows to display --%>
<c:set var="totalRows"  value="${numOfItemsInPage / env_resultsPerRow}"/>

<%-- Get a float value from totalRows which is a string --%>
<fmt:parseNumber var="totalRows" value="${totalRows}" integerOnly="false" parseLocale="en_US"/> 

<%-- do a ceil if totalRows contains fraction digits --%>
<c:set var="totalRows" value = "${totalRows + (1 - (totalRows % 1)) % 1}"/>

<%-- This will be passed as params to compare page to create the best SEO product url possible --%>
<c:set var="categoryIds" value="{top_category: '${WCParam.top_category}', parent_category_rn: '${WCParam.parent_category_rn}', categoryId: '${WCParam.categoryId}'}"/>

<script>
	var QI_catentryIds = new Array();
	dojo.addOnLoad(function(){
		if(!!'<wcf:out value = "${WCParam.searchTerm}" escapeFormat = "js"/>'){
			shoppingActionsJS.setSearchTerm('<wcf:out value = "${WCParam.searchTerm}" escapeFormat="js"/>');
		}	
		shoppingActionsJS.setCompareReturnName('<c:out value='${compareReturnName}'/>');
	});
</script>

<c:choose>
	<c:when test="${!param.bufferResults}">
		<input type="hidden" id="totalResultCountHidden" value="${totalCount}"/>
		<c:set var="productListDivId" value="productOrgList"/>
		<input type="hidden" id="startingPageHidden" value="${currentPage}"/>
		<input type="hidden" id="pageViewHidden" value="${WCParam.pageView}"/>
	</c:when>
	<c:otherwise>
		<input type="hidden" id="totalResultCountHidden" value="${totalCount}"/>
		<input type="hidden" id="currentPageHidden" value="${currentPage}"/>
		<c:set var="productListDivId" value="productBufferList"/>
	</c:otherwise>
</c:choose>

<c:if test="${totalCount > 0}">
<div class="widget_product_listing_position container_margin_5px">
	<div class="widget_product_listing">
		<div class="top">
			<div class="left_border"></div>
			<div class="middle_tile"></div>
			<div class="right_border"></div>
		</div>
		<div class="middle">
			<div class="left_border">
				<div class="right_border">
					<div class="content">
						<!-- <div class="header_bar">
							<script>
								dojo.addOnLoad(function(){
									dojo.subscribe("toggleViewEvent",SearchBasedNavigationDisplayJS,"toggleView");
									dojo.subscribe("showResultsForPageNumber",SearchBasedNavigationDisplayJS,"showResultsPage");
								});
							</script> -->
							
							<c:if test="${!param.bufferResults}">
									<%--<div dojoType="wc.widget.RefreshArea" widgetId="searchBasedNavPaginationControl_widget" id="searchBasedNavPaginationControl_widget" controllerId="searchBasedNavPaginationControl_controller" ariaLiveId="${ariaMessageNode}" role="region">
								 out.flush(); %>
										<c:import url="${env_jspStoreDir}Snippets/Catalog/CategoryDisplay/CatNavResultsPaginationControlWidget.jsp">
											<c:param name="beginIndex" value="${beginIndex}" />
											<c:param name="totalCount" value="${totalCount}" />
											<c:param name="endIndex" value="${endIndex}" />
											<c:param name="totalPages" value="${totalPages}" />
											<c:param name="currentPage" value="${currentPage}" />
											<c:param name="pageSize" value="${pageSize}" />
										</c:import>
									<% out.flush(); >
								--%>
								<!-- </div> -->
							</c:if>

							<div class="sorting_controls">
								<span><label for="orderBy"><fmt:message key="SN_SORT_BY"/></label>:</span>
								<select title="<fmt:message key='SN_SORT_BY_USAGE'/>" id="orderBy" name="orderBy" onChange="javaScript:setCurrentId('orderBy');SearchBasedNavigationDisplayJS.sortResults(this.value)">
									<option value = ""><fmt:message key="SN_NO_SORT"/></option>
									<option value = "1"><fmt:message key="SN_SORT_BY_BRANDS"/></option>
									<option value = "2"><fmt:message key="SN_SORT_BY_NAME"/></option>
									<c:if test="${globalpricemode == 1}">
										<option value = "3"><fmt:message key="SN_SORT_LOW_TO_HIGH"/></option>
										<option value = "4"><fmt:message key="SN_SORT_HIGH_TO_LOW"/></option>
									</c:if>
								</select>
							</div>
							
							<div id="compare_button" class="compare_controls disabled">
								<div id="compare_button_disabled" class="button_primary">
									<div class="left_border"></div>
									<div class="button_text"><fmt:message key="COMPARE_SELECTED"/></div>
									<div class="right_border"></div>
								</div>
								<a id="compare_button_enabled" href="Javascript:setCurrentId('compare_button_enabled');shoppingActionsJS.compareProducts(${categoryIds});" class="button_primary" wairole="button" role="button" style="display:none;">
									<div class="left_border"></div>
									<div class="button_text"><fmt:message key="COMPARE_SELECTED"/></div>
									<div class="right_border"></div>
								</a>
							</div>

						</div>

						<div class="product_listing_container">
							<c:if test="${totalCount > 0}">
								<c:choose>
									<%-- Display the results in either grid mode or in list mode.. grid mode being default --%>
									<c:when test="${WCParam.pageView == 'list'}">
										<div class="list_mode">
										<fieldset>
											<legend><span class="spanacce"><fmt:message key='ES_PRODUCT_LISTING'/></span></legend>
											<div class="row row_border first_row">
												<%-- For list view use getCatalogEntryViewDetailsByID to get all attributes combinations (required for 'ribbonad' and 'swatch' features) --%>
												<%-- For list view in search results use getCatalogEntryViewAllByID to get everything with attachments --%>
												<c:choose>
													<c:when test="${empty searchTerm}">
														<c:set var="expressionBuilder" value="getCatalogEntryViewDetailsByID"/>
														<c:set var="searchProfile" value="IBM_findCatalogEntryDetails_PriceMode"/>
													</c:when>
													<c:otherwise>
														<c:set var="expressionBuilder" value="getCatalogEntryViewAllByID"/>
														<c:set var="searchProfile" value="IBM_findCatalogEntryAll_PriceMode"/>
													</c:otherwise>
												</c:choose>
												<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
													expressionBuilder="${expressionBuilder}" varShowVerb="showCatalogNavigationView" recordSetStartNumber="0">
													<c:forEach var = "catEntry" items = "${globalresults}" varStatus = "status">
														<wcf:param name="UniqueID" value="${catEntry.uniqueID}"/>
													</c:forEach>
													<wcf:contextData name="storeId" data="${storeId}" />
													<wcf:contextData name="catalogId" data="${catalogId}" />
													<wcf:param name="searchProfile" value="${searchProfile}"/>
												</wcf:getData>
												
												<div id="<c:out value="${productListDivId}"/>">
													<c:forEach var = "catEntry" items = "${globalresults}" varStatus = "status">
														<c:set var="catEntryIdentifier" value="${catEntry.uniqueID}" scope="request"/>
														<c:set var="catalogEntryDetails" value="${catEntry}" scope="request"/>
															
														<c:forEach var="sku" items="${catalogNavigationView.catalogEntryView}" varStatus="status1">
															<c:if test="${sku.uniqueID eq catEntryIdentifier}">
																<c:set var="catalogEntryDetails" value="${sku}" scope="request"/>
															</c:if>
														</c:forEach>	
																										
														<% out.flush(); %>
														<c:choose>
															<c:when test="${empty searchTerm}">
																<c:import url="${env_siteWidgetsDir}Common/CatalogEntry/CatalogEntryDisplay.jsp">
																	<c:param name="pageView" value="list"/>
																	<c:param name="catEntryIdentifier" value="${catEntryIdentifier}"/> <%-- Pass catEntryIdentifier parameter so that CatalogEntryDisplay can be cached, based on catEntryIdentifier --%>
																</c:import>
															</c:when>
															<c:otherwise>
																<c:import url="${env_siteWidgetsDir}Common/CatalogEntry/CatalogEntryDisplay.jsp">
																	<c:param name="pageView" value="list"/>
																	<c:param name="displayAttachments" value="true"/>
																	<c:param name="excludeUsageStr" value="ANGLEIMAGES_THUMBNAIL,ANGLEIMAGES_FULLIMAGE,ANGLEIMAGES_HDIMAGE,IMAGE_SIZE_55,IMAGE_SIZE_40,IMAGE_SIZE_330,IMAGE_SIZE_1000"/>
																	<c:param name="catEntryIdentifier" value="${catEntryIdentifier}"/> <%-- Pass catEntryIdentifier parameter so that CatalogEntryDisplay can be cached, based on catEntryIdentifier --%>
																</c:import>
															</c:otherwise>
														</c:choose>
														<% out.flush(); %>
													</c:forEach>
												</div>
											</div>											
										</fieldset>
										</div>
									</c:when>
									<c:otherwise>
										<fieldset>
										<legend><span class="spanacce"><fmt:message key='ES_PRODUCT_LISTING'/></span></legend>
										<div class="grid_mode" id="<c:out value="${productListDivId}"/>">
											<%-- For grid view use getCatalogEntryViewPriceWithAttributesByID to get just product attributes (required for 'ribbonad' feature)
											<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogNavigationViewType" var="catalogNavigationView" 
												expressionBuilder="getCatalogEntryViewPriceWithAttributesByID" varShowVerb="showCatalogNavigationView" recordSetStartNumber="0">
												<c:forEach var = "catEntry" items = "${globalresults}" varStatus = "status">
													<wcf:param name="UniqueID" value="${catEntry.uniqueID}"/>
												</c:forEach>
												<wcf:contextData name="storeId" data="${storeId}" />
												<wcf:contextData name="catalogId" data="${catalogId}" />
												<wcf:param name="searchProfile" value="IBM_findCatalogEntryPriceWithAttributes_PriceMode"/>
											</wcf:getData>--%>

											<c:forEach var="rowNumber" begin="0" end = "${totalRows - 1}" varStatus="statusRow">
												<%-- Loop through number of rows --%>
												<c:set var="divStyle" value="row"/> <%-- class for last row..without border --%>
												<c:if test="${not statusRow.last}">
													<c:choose>
														<c:when test="${statusRow.first}">
															<c:set var="divStyle" value="${divStyle} row_border first_row"/> <%-- class for first row --%>
														</c:when>
														<c:otherwise>
															<c:set var="divStyle" value="${divStyle} row_border"/> <%-- class for middle rows --%>
														</c:otherwise>
													</c:choose>
												</c:if>
												<div class="${divStyle}">
													<c:forEach var="catEntry" items="${globalresults}" begin="${rowNumber * env_resultsPerRow}" end = "${(rowNumber * env_resultsPerRow) + (env_resultsPerRow - 1)}" varStatus="statusColumn">
														<c:set var="catEntryIdentifier" value="${catEntry.uniqueID}" scope="request"/>

														<script type="text/javascript">QI_catentryIds.push('${catEntryIdentifier}');</script>

														<c:set var="catalogEntryDetails" value="${catEntry}" scope="request"/>
															
														<c:forEach var="sku" items="${catalogNavigationView.catalogEntryView}" varStatus="status1">
															<c:if test="${sku.uniqueID eq catEntryIdentifier}">
																<c:set var="catalogEntryDetails" value="${sku}" scope="request"/>
															</c:if>
														</c:forEach>		
																											
														<div class="product">
															<% out.flush(); %>
															<c:import url="${env_siteWidgetsDir}Common/CatalogEntry/CatalogEntryDisplay.jsp">
																<c:param name="pageView" value="grid"/>
																<c:param name="catEntryIdentifier" value="${catEntryIdentifier}"/> <%-- Pass catEntryIdentifier parameter so that CatalogEntryDisplay can be cached, based on catEntryIdentifier --%>
															</c:import>
															<% out.flush(); %>
														</div>
														<%-- Removed the divider, since border is provided using css --%>
													</c:forEach>
												</div>
											</c:forEach>
										</div>
										</fieldset>
									</c:otherwise>
								</c:choose>
							</c:if> <%-- End of check for total pages > 1 --%>
						</div>

						<%-- display pagination control at bottom depending upon the viewType and count --%>
						<%-- Temporarily disabled.
						<c:if test="${(WCParam.pageView == 'list' && pageSize > env_list_pagination_count) || (WCParam.pageView != 'list' && pageSize > env_grid_pagination_count)}">
							<div class="header_bar simple_bar">
								<div class="paging_controls">
									<c:set var="linkPrefix" value="categoryResults_bottom"/>
									<%@include file="../Common/PaginationControls.jspf" %>
								</div>
							</div>
						</c:if>
						--%>
					</div>
				</div>				
			</div>
		</div>
		<div class="bottom">
			<div class="left_border"></div>
			<div class="middle_tile"></div>
			<div class="right_border"></div>
		</div>
	</div>
	<flow:ifEnabled feature="Analytics">
		<c:set var="singleQuote" value="'"/>
		<c:set var="escapedSingleQuote" value="\\\\'"/>
		<c:set var="doubleQuote" value="\""/>
		<c:set var="escapedDoubleQuote" value="\\\\\""/>

		<c:remove var="analyticsEscapedFacetAttributes"/>
		<c:set var="analyticsEscapedFacetAttributes" value="${fn:replace(analyticsFacetAttributes, singleQuote, escapedSingleQuote)}"/>
		<c:set var="analyticsEscapedFacetAttributes" value="${fn:replace(analyticsEscapedFacetAttributes, doubleQuote, escapedDoubleQuote)}"/>

		<c:remove var="analyticsEscapedSearchTerm"/>
		<c:set var="analyticsEscapedSearchTerm" value="${fn:replace(searchTerm, singleQuote, escapedSingleQuote)}"/>
		<c:set var="analyticsEscapedSearchTerm" value="${fn:replace(analyticsEscapedSearchTerm, doubleQuote, escapedDoubleQuote)}"/>
		<div id="catalog_search_result_information" style="visibility:hidden">
			{	searchResult: {
				pageSize: <c:out value="${pageSize}"/>, 
				searchTerms: '<c:out value="${analyticsEscapedSearchTerm}"/>', 
			 	totalPageNumber: <c:out value="${totalPages}"/>, 
			  	totalResultCount: <c:out value="${totalCount}"/>, 
			  	currentPageNumber:<c:out value="${currentPage}"/>,
				attributes: "<c:out value="${analyticsEscapedFacetAttributes}"/>"
				}
			}
	</div>
	</flow:ifEnabled>
</div>
</c:if>

<div id="facetCounts">
	<script>
		function updateFacetCounts() {
			<c:forEach var="facetField" items="${globalfacets}">
				<c:forEach var="item" items="${facetField.entry}" varStatus="aStatus">
					SearchBasedNavigationDisplayJS.updateFacetCount("${item.extendedData['uniqueId']}", <c:out value="${item.count}" />);
				</c:forEach>
			</c:forEach>
			var searchTotalCount = $('searchTotalCount');
			var productTotalCount = $('productTotalCount');
			if(searchTotalCount != null) {
				searchTotalCount.innerHTML = '<fmt:message key = "{0}_matches"><fmt:param value="${originalTotalSearchCount}"/></fmt:message>';
			}
			if(productTotalCount != null) {
				productTotalCount.innerHTML = '<c:out value="${totalCount}"/>';
			}
		}
	</script>
</div>
<!-- END CategoryNavigationResults.jsp -->
