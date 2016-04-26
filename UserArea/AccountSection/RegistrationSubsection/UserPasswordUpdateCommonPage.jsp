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

<!-- BEGIN UserPasswordUpdateCommonPage.jsp -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>             
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/LogonForm.js"/>"></script>

<c:set var="UserPasswordUpdateCommonPage" value="true" scope="request"/>

<wcf:url var="LogonForm" value="AjaxLogonForm">
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="myAcctMain" value="1" />
</wcf:url>

<div id="box" class="myAccountMarginRight">
	<div class="my_account" id="WC_UserPasswordUpdateForm_div_1">
		<h2 class="myaccount_header"><fmt:message bundle="${storeText}" key="MA_CHANGE_PASSWORD"/></h2>
		<div class="body" id="WC_UserPasswordUpdateForm_div_2">
			<div class="form_2column" id="WC_UserPasswordUpdateForm_div_3" style="min-height: 200px;">
				 <div class="align" id="WC_UserPasswordUpdateForm_div_4">
				 	<c:if test="${!empty errorMessage}">
						<span class="error_msg" id="error_msg"><c:out value="${errorMessage}"/></span>
						<c:set var="aria_invalid" value="aria-invalid=true"/>
						<script type="text/javascript">
							dojo.addOnLoad(function() {
								increaseHeight("WC_UserPasswordUpdateForm_div_5", 20);
							});
						</script>
					</c:if>
					<form name="Logon" method="post" action="PersonChangeServicePasswordReset" id="Logon">
						<input type="hidden" name="storeId" value='<c:out value="${storeId}" />' id="WC_UserPasswordUpdateForm_FormInput_storeId_In_Logon_1"/>
						<input type="hidden" name="catalogId" value='<c:out value="${catalogId}" />' id="WC_UserPasswordUpdateForm_FormInput_catalogId_In_Logon_1"/>
						<input type="hidden" name="langId" value='<c:out value="${langId}" />' id="WC_UserPasswordUpdateForm_FormInput_langId_In_Logon_1"/>
						<input type="hidden" name="reLogonURL" value="UserPasswordUpdate" id="WC_UserPasswordUpdateForm_FormInput_reLogonURL_In_Logon_1"/>
						<input type="hidden" name="errorViewName" value="UserPasswordUpdate" id="WC_UserPasswordUpdateForm_FormInput_Error_In_Logon_1"/>
						<%-- the parameter 'calculationUsageId' and 'updatePrices' are used by the OrderCalculate command --%>
						<input type="hidden" name="URL" value="<c:out value='${LogonForm}'/>" id="WC_PasswordResetForm_FormInput_URL_In_ResetPasswordForm_1"/>
						<input type="hidden" name="authToken" value="${authToken}"  id="WC_UserPasswordUpdateForm_FormInput_authToken_In_Logon_1"/>
						
						<div class="column" id="WC_UserPasswordUpdateForm_div_6" style="float: none;">
							<div id="WC_UserPasswordUpdateForm_div_7">
								<label for="WC_UserPasswordUpdateForm_FormInput_logonPasswordOld_In_Logon_1">
									<fmt:message bundle="${storeText}" key="CURRENT_PWORD"/>
								</label>
							</div>
							<input <c:out value="${aria_invalid}"/> class="inputField" aria-required="true" aria-describedby="error_msg" size="35" maxlength="50" name="logonPasswordOld" type="password" autocomplete="off" value="" id="WC_UserPasswordUpdateForm_FormInput_logonPasswordOld_In_Logon_1"/>
						</div>
						<br clear="all" />
						
						<div class="column" id="WC_UserPasswordUpdateForm_div_8" style="float: none;">
							<div id="WC_UserPasswordUpdateForm_div_9">
								<label for="WC_UserPasswordUpdateForm_FormInput_logonPassword_In_Logon_1">
									<fmt:message bundle="${storeText}" key="PASSWORD"/>
								</label>
							</div>
							<input <c:out value="${aria_invalid}"/> class="inputField" aria-required="true" aria-describedby="error_msg" size="35" maxlength="50" name="logonPassword" type="password" autocomplete="off" value="" id="WC_UserPasswordUpdateForm_FormInput_logonPassword_In_Logon_1"/>
						</div>
						
						<br clear="all" />
						
						<div class="column" id="WC_UserPasswordUpdateForm_div_10" style="float: none;">
							<div id="WC_UserPasswordUpdateForm_div_11">
								<label for="WC_UserPasswordUpdateForm_FormInput_logonPasswordVerify_In_Logon_1">
									<fmt:message bundle="${storeText}" key="VERIFY_PASS"/>
								</label>
							</div>
						    <input <c:out value="${aria_invalid}"/> class="inputField" aria-required="true" aria-describedby="error_msg" size="35" maxlength="50" name="logonPasswordVerify" type="password" autocomplete="off" value="" id="WC_UserPasswordUpdateForm_FormInput_logonPasswordVerify_In_Logon_1"/>
						</div>
					</form>
				</div>
			</div>
		</div>
		<div class="button_footer_line">
			<a href="#" role="button" class="button_primary" id="WC_UserPasswordUpdateForm_Link_1" onclick="javascript:submitSpecifiedForm(document.Logon);return false;">
				<div class="left_border"></div>
				<div class="button_text"><fmt:message bundle="${storeText}" key="SUBMIT"/></div>
				<div class="right_border"></div>
			</a>
		</div>
		</div>
	</div>
</div>
<!-- END UserPasswordUpdateCommonPage.jsp -->
