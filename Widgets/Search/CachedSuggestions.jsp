<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!-- BEGIN CachedSuggestions.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@include file="../../Common/EnvironmentSetup.jspf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page trimDirectiveWhitespaces="true" %>

<c:set var="search01" value="'"/>
<c:set var="search02" value='"'/>
<c:set var="replaceStr01" value="\\\\'"/>
<c:set var="replaceStr02" value='\\\\"'/>

<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/sitecontent/suggestions" >
	<c:choose>
		<c:when test="${!empty WCParam.langId}">
			<wcf:param name="langId" value="${WCParam.langId}"/>
		</c:when>
		<c:otherwise>
			<wcf:param name="langId" value="${langId}"/>
		</c:otherwise>
	</c:choose>
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<c:forEach var="contractId" items="${env_activeContractIds}">
		<wcf:param name="contractId" value="${contractId}"/>
	</c:forEach>
</wcf:rest>

<c:set var="suggestionList" value="${catalogNavigationView.suggestionView}"/>
&nbsp;
<div id="cachedSuggestions">
<script type="text/javascript">
	// The primary Array to hold all static search suggestions
	var staticContent = new Array();

	// The titles of each search grouping
	var staticContentHeaders = new Array();

	<c:forEach var="suggestions" items="${suggestionList}">
		// The static search grouping content
		var s = new Array();
		<c:choose>
			<c:when test="${suggestions.identifier == 'Brand'}">
				staticContentHeaders.push(storeNLS['BRAND']);
			</c:when>
			<c:when test="${suggestions.identifier == 'Category'}">
				staticContentHeaders.push(storeNLS['CATEGORY']);
			</c:when>
			<c:when test="${suggestions.identifier == 'Articles'}">
				staticContentHeaders.push(storeNLS['ARTICLES']);
			</c:when>
		</c:choose>	
		<c:forEach var="entry" items="${suggestions.entry}">
			<c:remove var="urlValue"/>
			<c:set var="displayName" value="${entry.name}"/>
			<c:choose>
				<c:when test="${suggestions.identifier == 'Brand'}">
					<wcf:url var="urlValue" value="SearchDisplay">
						<wcf:param name="langId" value="${param.langId}" />
						<wcf:param name="storeId" value="${param.storeId}" />
						<wcf:param name="catalogId" value="${param.catalogId}" />
						<wcf:param name="sType" value="SimpleSearch" />
						<wcf:param name="manufacturer" value="${entry.name}"/>
					</wcf:url>
				</c:when>
				<c:when test="${suggestions.identifier == 'Category'}">
					<c:set var="displayName" value="${entry.fullPath}"/>
					<c:choose>
						<c:when test="${fn:length(displayName) == fn:length(entry.name)}">
							<wcf:url var="urlValue" patternName="CanonicalCategoryURL" value="Category3">
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="storeId" value="${storeId}" />
								<wcf:param name="catalogId" value="${catalogId}" />
								<wcf:param name="categoryId" value="${entry.value}" />
								<wcf:param name="pageView" value="${defaultPageView}" />
								<wcf:param name="beginIndex" value="0" />
								<wcf:param name="urlLangId" value="${urlLangId}" />
							</wcf:url>
						</c:when>
						<c:otherwise>
							<wcf:url var="urlValue" patternName="SearchCategoryURL" value="SearchDisplay">
								<wcf:param name="langId" value="${param.langId}" />
								<wcf:param name="storeId" value="${param.storeId}" />
								<wcf:param name="catalogId" value="${param.catalogId}" />
								<wcf:param name="sType" value="SimpleSearch" />
								<wcf:param name="facet" value=""/>
								<wcf:param name="categoryId" value="${entry.value}" />
								<wcf:param name="urlLangId" value="${urlLangId}" />
							</wcf:url>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:when test="${suggestions.identifier == 'Articles'}">
					<c:set var="urlValue" value="${entry.path}"/>
					<c:if test="${fn:startsWith(urlValue, 'StaticContent/')}">
						<wcf:url var="urlValue" patternName="StaticContentURL" value="StaticContent">
							<wcf:param name="url" value="${fn:substringAfter(urlValue, 'StaticContent/')}" />
							<wcf:param name="langId" value="${param.langId}" />
							<wcf:param name="storeId" value="${param.storeId}" />
							<wcf:param name="catalogId" value="${param.catalogId}" />
							<wcf:param name="urlLangId" value="${urlLangId}" />
						</wcf:url>
					</c:if>
					<c:if test="${!(fn:startsWith(urlValue, '/') || fn:contains(urlValue, '://'))}">
						<wcf:url var="urlValue" value="/${urlValue}" />
					</c:if>
				</c:when>
				<c:otherwise>
					<c:set var="urlValue" value="#"/>
				</c:otherwise>
			</c:choose>
			s.push(["<c:out value="${fn:replace(fn:replace(entry.name, search01, replaceStr01), search02, replaceStr02)}" escapeXml='false'/>", "<c:out value="${fn:replace(fn:replace(urlValue, search01, replaceStr01), search02, replaceStr02)}"/>", "<c:out value="${fn:replace(fn:replace(displayName, search01, replaceStr01), search02, replaceStr02)}" escapeXml='false'/>"]);
		</c:forEach>
		staticContent.push(s);
	</c:forEach>
</script>
</div>

<!-- END CachedSuggestions.jsp -->