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

<!-- BEGIN RegistrationUpdateCommonPage.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>             
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/LogonForm.js"/>"></script>
<c:if test="${isBrazilStore}">
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyBrazilAccountDisplay.js"/>"></script>
</c:if>
	
<c:set var="myAccountPage" value="true" scope="request"/>

<c:set var="person" value="${requestScope.person}"/>
<c:if test="${empty person || person==null}">
	<wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	</wcf:rest>
</c:if>

<c:set var="personSession" value="${requestScope.personSession}"/>
<c:if test="${empty personSession || personSession==null}">
	<wcf:rest var="personSession" url="store/{storeId}/person/{personId}" scope="request">
		<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		<wcf:var name="personId" value="${userId}" encode="true"/>
	</wcf:rest>
</c:if>	
	
<c:set var="firstName" value="${person.firstName}"/>
<c:set var="lastName" value="${person.lastName}"/>
<c:set var="middleName" value="${person.middleName}"/>
<c:set var="street" value="${person.addressLine[0]}"/>
<c:set var="street2" value="${person.addressLine[1]}"/>
<c:set var="city" value="${person.city}"/>
<c:set var="state" value="${person.state}"/>
<c:set var="country1" value="${person.country}"/>
<c:set var="zipCode" value="${person.zipCode}"/>
<c:set var="phone1" value="${person.phone1}"/>
<c:set var="email1" value="${person.email1}"/>
<c:set var="emailOption" value="${person.receiveEmailPreference[0].value}"/>
<c:set var="preferredLanguage" value="${person.preferredLanguage}"/>
<c:set var="preferredCurrency" value="${person.preferredCurrency}"/>

<c:set var="foundAge" value="false"/>
<c:forEach var="attributes" items="${person.attributes}">
	<c:set var="attrKey" value="${attributes.pProfileAttrKey}"/>
	<c:if test="${attrKey=='age' && !foundAge}">
		<c:set var="foundAge" value="true"/>
		<c:set var="attrValue" value="${attributes.pProfileAttrValue}"/>
	</c:if>
</c:forEach>
<c:set var="age" value="${attrValue}"/>

<c:set var="gender" value="${person.gender}"/>
<c:set var="dateOfBirth" value="${person.dateOfBirth}"/>
<c:set var="mobilePhoneNumber1" value="${person.mobilePhone1}"/>
<c:set var="mobilePhoneNumber1Country" value="${person.mobilePhone1Country}"/>
<c:set var="mobilePhoneNumber1CountryCode" value=""/>
<c:set var="receiveSMSNotification" value="${person.receiveSMSNotification}"/>
<c:set var="receiveSMSPreference" value="${person.receiveSMSPreference[0].value}"/>

<c:choose>
	<c:when test="${empty storeError.key}">
		<c:set var="logonPassword" value="${person.logonPassword}"/>
		<c:set var="logonPasswordVerify" value="${person.logonPassword}"/>
	</c:when>
	<c:otherwise>
		<c:set var="logonPassword" value="${WCParam.logonPassword}"/>
		<c:set var="logonPasswordVerify" value="${WCParam.logonPasswordVerify}"/>
		<c:set var="paramSource" value="${WCParam}"/>
	</c:otherwise>
</c:choose>

<wcf:rest var="bnEmailUserReceive" url="store/{storeId}/person/@self/optOut">
	<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
	<wcf:param name="profileName" value="IBM_optOut_all" />
</wcf:rest>
<c:set var="bnEmailUserReceive" value="${bnEmailUserReceive}" scope="request"/>

<wcf:url var="LogonForm" value="AjaxLogonForm">
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="myAcctMain" value="1" />
</wcf:url>


<c:if test="${env_shopOnBehalfSessionEstablished eq 'true'}">
	<div class="listTable listTable_CSR_resetPassword" id="csr_reset_password">
		<form name="ResetPasswordAction_AuthTokenInfo"  id="ResetPasswordAction_AuthTokenInfo">
			<input type="hidden" name="authToken" id="ResetPasswordAction_authToken" value="<c:out value='${authToken}'/>"/>
		</form>	 
		<div class="row">
			<div class="col12">
				<div aria-label='<fmt:message bundle="${storeText}" key="RESET_PASSWORD" />' class="toolbar">
					<div class="newList">
						<a id="csr_resetPassword_button" aria-haspopup="true" class="button_secondary toolbarButton" aria-label='<fmt:message bundle="${storeText}" key = "RESET_PASSWORD_ARIA_MEESAGE" />' href="#" onclick="javascript:registeredCustomersJS.handleCSRPasswordReset(event);return false;">
							<div class="left_border"></div>
							<div class="button_text"><span><fmt:message bundle="${storeText}" key="RESET_PASSWORD" /></span></div>								
							<div class="right_border"></div>
						</a>						
						<div aria-label='<fmt:message bundle="${storeText}" key="RESET_PASSWORD" />' class="toolbarDropdown" id="csr_resetPassword_dropdown_panel">
							<div class="createTableList">
								<%--
									Use this when CSR password is mandatory for resetting customer password.
								<label for="administratorPassword"><fmt:message bundle="${storeText}" key="RESET_PASSWORD_MESSAGE" /></label>
								<input type="password" maxlength="254" class="input_field" name="administratorPassword" id="administratorPassword" onkeypress="javascript:registeredCustomersJS.hideErrorDiv();">
								--%>
								<span id="csr_resetPassword_confirmation"><fmt:message bundle="${storeText}" key="RESET_PASSWORD_CONFIRMATION_MESSAGE" /></span>

								<div class="hidden csr_errorMsg" id="csr_resetPassword_error">
									<span id="csr_resetPassword_error_msg"  tabindex="0"><fmt:message bundle="${storeText}" key="RESET_PASSWORD_MESSAGE" /></span>
								</div>

								<a role="button" class="button_primary clicked" id="csr_password_ok" href="#"		onclick="javascript:registeredCustomersJS.resetPasswordByAdminOnBehalf('${person.logonId}');">
									<div class="left_border"></div>
									<div class="button_text"><span><fmt:message bundle="${storeText}" key="RESET_PASSWORD_OK" /></span></div>								
									<div class="right_border"></div>
								</a>
								
								<a role="button" class="button_secondary clicked" id="csr_password_cancel" href="#"		onclick="javascript:registeredCustomersJS.handleCSRPasswordReset(event);return false;" >
									<div class="left_border"></div>
									<div class="button_text"><span><fmt:message bundle="${storeText}" key="RESET_PASSWORD_CANCEL" /></span></div>							
									<div class="right_border"></div>
								</a>
								<div class="clearFloat"></div>
							</div>
						</div>
					</div>
					<div class="clearFloat"></div>
				</div>
			</div>
		</div>
	</div>
</c:if>

<div id="box" class="myAccountMarginRight">
	<div class="my_account" id="WC_RegistrationUpdateCommonPage_div_1">
		<h2 class="myaccount_header"><fmt:message bundle="${storeText}" key="MA_PERSONAL_INFO" /></h2>
		<div class="content_header" id="WC_UserRegistrationUpdateForm_div_6">
			<div class="left_corner" id="WC_UserRegistrationUpdateForm_div_7"></div>
			<div  id="WC_UserRegistrationUpdateForm_div_8" class="headingtext">
				<span class="content_text">
					<fmt:message bundle="${storeText}" key="PI_WELCOMEBACK" >
						<fmt:param><c:out value="${firstName}"/></fmt:param>
						<fmt:param><c:out value="${middleName}"/></fmt:param>
						<fmt:param><c:out value="${lastName}"/></fmt:param>
						<fmt:param><c:out value="${personSession.lastSession}"/></fmt:param>
					</fmt:message>
				</span>
			</div>
			<div class="right_corner" id="WC_UserRegistrationUpdateForm_div_9"></div>
		</div>
		<div class="body" id="WC_UserRegistrationUpdateForm_div_10">
			<div class="form_2column" id="WC_UserRegistrationUpdateForm_div_11">
				<form name="Register" method="post" action="RESTUserRegistrationUpdate" id="Register">
					<input type="hidden" name="storeId" value="<c:out value="${WCParam.storeId}"/>" id="WC_UserRegistrationUpdateForm_FormInput_storeId_In_Register_1"/>
					<input type="hidden" name="catalogId" value="<c:out value="${WCParam.catalogId}"/>" id="WC_UserRegistrationUpdateForm_FormInput_catalogId_In_Register_1"/>
					<input type="hidden" name="URL" value="<c:out value='${LogonForm}'/>" id="WC_UserRegistrationUpdateForm_FormInput_URL_In_Register_1"/>
					<input type="hidden" name="errorViewName" value="UserRegistrationForm" id="WC_UserRegistrationUpdateForm_FormInput_errorViewName_In_Register_1"/>
					<input type="hidden" name="registerType" value="RegisteredPerson" id="WC_UserRegistrationUpdateForm_FormInput_registerType_In_Register_1"/>
					<input type="hidden" name="editRegistration" value="Y" id="WC_UserRegistrationUpdateForm_FormInput_editRegistration_In_Register_1"/>
					<input type="hidden" name="receiveEmail" value="" id="WC_UserRegistrationUpdateForm_FormInput_receiveEmail_In_Register_1"/>
					<input type="hidden" name="receiveSMSNotification" value="" id="WC_UserRegistrationUpdateForm_FormInput_receiveSMSNotification_In_Register_1"/>
					<input type="hidden" name="receiveSMS" value="" id="WC_UserRegistrationUpdateForm_FormInput_receiveSMS_In_Register_1"/>
					<input type="hidden" name="logonId" value="<c:out value="${person.logonId}"/>" id="WC_UserRegistrationUpdateForm_FormInput_logonId_In_Register_1_1"/>
					<input type="hidden" name="authToken" value="${authToken}" id="WC_UserRegistrationUpdateForm_FormInput_authToken_In_Register_1"/>
					<span class="required-field" id="WC_UserRegistrationUpdateForm_div_12"> *</span>
					<fmt:message bundle="${storeText}" key="REQUIRED_FIELDS" />
					<%-- The challenge answer and question are necessary for the forget password feature. Therefore, they are set to "-" here.       --%>
				    <input type="hidden" name="challengeQuestion" value="-" id="WC_UserRegistrationUpdateForm_FormInput_challengeQuestion_In_Register_1"/>
				    <input type="hidden" name="challengeAnswer" value="-" id="WC_UserRegistrationUpdateForm_FormInput_challengeAnswer_In_Register_1"/>
					<br />
					<%@ include file="RegistrationUpdateCommonBrazilSetup.jspf" %>
	
					<br clear="all" />
					
					<c:set var="paramPrefix" value=""/>
					<c:set var="formName" value="document.Register.name" />
					<c:set var="pageName" value="UserRegistrationUpdateForm" />
					
					<jsp:include page="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.AddressForm/AddressForm.jsp" flush="true">
						<jsp:param name="addressId" value="${addressId}" />
						<jsp:param name="nickName" value="${nickName}" />
						<jsp:param name="firstName" value="${firstName}"/>
						<jsp:param name="lastName" value="${lastName}"/>
						<jsp:param name="middleName" value="${middleName}"/>
						<jsp:param name="address1" value="${street}"/>
						<jsp:param name="address2" value="${street2}"/>
						<jsp:param name="city" value="${city}"/>
						<jsp:param name="state" value="${state}"/>
						<jsp:param name="countryReg" value="${country1}"/>
						<jsp:param name="zipCode" value="${zipCode}"/>
						<jsp:param name="phone" value="${phone1}"/>
						<jsp:param name="email1" value="${email1}"/>
						<jsp:param name="emailOption" value="${emailOption}"/>
						<jsp:param name="gender" value="${gender}"/>
						<jsp:param name="dateOfBirth" value="${dateOfBirth}"/>
						<jsp:param name="mobilePhone1" value="${mobilePhoneNumber1}"/>
						<jsp:param name="mobilePhone1Country" value="${mobilePhoneNumber1Country}"/>
						<jsp:param name="mobilePhone1CountryCode" value="${mobilePhoneNumber1CountryCode}"/>
						<jsp:param name="receiveSMSNotification" value="${receiveSMSNotification}"/>
						<jsp:param name="receiveSMSPreference" value="${receiveSMSPreference}"/>
						<jsp:param name="preferredLanguage" value="${preferredLanguage}"/>
						<jsp:param name="preferredCurrency" value="${preferredCurrency}"/>
						<jsp:param name="formName" value="${formName}"/>
						<jsp:param name="pageName" value="${pageName}"/>
						<jsp:param name="flexFlowsFieldOrder" value="EmailOption,preferredLanguage,preferredCurrency,Age,Gender,DateOfBirth,MobilePhone,RememberMe"/>
					</jsp:include>
				
					<br clear="all" />
					<br />
				</form>
			</div>
		</div>
	</div>
	<div id="WC_UserRegistrationUpdateForm_div_40">
		<div class="button_footer_line" id="WC_UserRegistrationUpdateForm_div_42">
			<a href="#" role="button" class="button_primary" id="WC_UserRegistrationUpdateForm_links_1" onclick="javascript:MyAccountDisplay.prepareSubmit(document.Register,'<c:out value='${logonPassword}'/>','<c:out value='${logonPasswordVerify}'/>');return false;">
				<div class="left_border"></div>
				<div class="button_text"><fmt:message bundle="${storeText}" key="UPDATE" /></div>												
				<div class="right_border"></div>
			</a>	
		</div>
	</div>
</div>
<!-- END RegistrationUpdateCommonPage.jsp -->