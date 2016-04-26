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

<!-- BEGIN AccountAddressForm.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%-- ErrorMessageSetup.jspf is used to retrieve an appropriate error message when there is an error --%>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>
<%@ include file="/Widgets_701/Common/Address/AddressHelperCountrySelection.jspf" %>


<script type="text/javaScript"></script>
<c:set var="key1" value="store/${WCParam.storeId}/country/country_state_list+${langId}+${contact.country}"/>
<c:set var="countryBean" value="${cachedOnlineStoreMap[key1]}"/>
<c:if test="${empty countryBean}">
	<wcf:rest var="countryBean" url="store/{storeId}/country/country_state_list" cached="true">
		<wcf:var name="storeId" value="${WCParam.storeId}" />
		<wcf:param name="langId" value="${langId}" />
		<wcf:param name="countryCode" value="${contact.country}"/>
	</wcf:rest>
	<wcf:set target = "${cachedOnlineStoreMap}" key="${key1}" value="${countryBean}"/>
</c:if>

<c:set var="type" value="${WCParam.type}"/>

<c:set var="addressId" value="${WCParam.addressId}"/>

<c:choose>
<c:when test="${addressId eq 'empty'}" >
	<jsp:include page="../AddressbookSubsection/AccountForm.jsp" flush="true">
			<jsp:param name="addressId" value="empty" />
	</jsp:include>
</c:when>
<c:otherwise>

	<c:set var="person" value="${requestScope.person}"/>
	<c:if test="${empty person || person==null}">
		<wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		</wcf:rest>
	</c:if>	
	<c:set var="personAddresses" value="${person}"/>
	
	<c:set var="shownAddress" value="false"/>
	<c:set var="contact" value="${person}"/>
	<c:if test="${contact.addressId eq addressId}" >	
		<c:set var="final_accountaddr" value="${contact}"/>
		<jsp:include page="../AddressbookSubsection/AccountForm.jsp" flush="true">
			<jsp:param name="addressId" value="${final_accountaddr.addressId}" />
			<jsp:param name="nickName" value="${final_accountaddr.nickName}" />
			<jsp:param name="firstName" value="${final_accountaddr.firstName}"/>
			<jsp:param name="lastName" value="${final_accountaddr.lastName}"/>
			<jsp:param name="address1" value="${final_accountaddr.addressLine[0]}"/>
			<jsp:param name="address2" value="${final_accountaddr.addressLine[1]}"/>
			<jsp:param name="city" value="${final_accountaddr.city}"/>
			<jsp:param name="state" value="${final_accountaddr.state}"/>
			<jsp:param name="countryReg" value="${final_accountaddr.country}"/>
			<jsp:param name="zipCode" value="${final_accountaddr.zipCode}"/>
			<jsp:param name="phone" value="${final_accountaddr.phone1}"/>
			<jsp:param name="email1" value="${final_accountaddr.email1}"/>
			<jsp:param name="addressType" value="${final_accountaddr.addressType}"/>
		</jsp:include>
		<c:set var="shownAddress" value="true"/>
	</c:if>
	<c:if test="${!shownAddress}" >
		<c:forEach items="${personAddresses.contact}" var="contact">
			<c:if test="${contact.addressId eq addressId}" >
				<c:set var="final_accountaddr" value="${contact}"/>
				<jsp:include page="../AddressbookSubsection/AccountForm.jsp" flush="true">
					<jsp:param name="addressId" value="${final_accountaddr.addressId}" />
					<jsp:param name="nickName" value="${final_accountaddr.nickName}" />
					<jsp:param name="firstName" value="${final_accountaddr.firstName}"/>
					<jsp:param name="lastName" value="${final_accountaddr.lastName}"/>
					<jsp:param name="address1" value="${final_accountaddr.addressLine[0]}"/>
					<jsp:param name="address2" value="${final_accountaddr.addressLine[1]}"/>
					<jsp:param name="city" value="${final_accountaddr.city}"/>
					<jsp:param name="state" value="${final_accountaddr.state}"/>
					<jsp:param name="countryReg" value="${final_accountaddr.country}"/>
					<jsp:param name="zipCode" value="${final_accountaddr.zipCode}"/>
					<jsp:param name="phone" value="${final_accountaddr.phone1}"/>
					<jsp:param name="email1" value="${final_accountaddr.email1}"/>
					<jsp:param name="addressType" value="${final_accountaddr.addressType}"/>
				</jsp:include>
				<c:set var="shownAddress" value="true"/>
			</c:if>
		</c:forEach>
	</c:if>
</c:otherwise>
</c:choose>
<!-- END AccountAddressForm.jsp -->
