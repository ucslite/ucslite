
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ include file="../../../include/ErrorMessageSetup.jspf" %>

<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!-- BEGIN UserRegistrationAddForm.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message bundle="${storeText}" key="REGISTER_TITLE"/></title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>
	
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	<%@ include file="../../../include/ErrorMessageSetupBrazilExt.jspf" %>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/LogonForm.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AddressHelper.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
	<c:if test="${isBrazilStore}"> 
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyBrazilAccountDisplay.js"/>"></script>
	</c:if>

	<c:if test="${empty B2BLogonFormJSIncluded}">
		<script type="text/javascript" src="<c:out value="${staticAssetContextRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.RegistrationForm/javascript/B2BLogonForm.js"/>"></script>
		<c:set var="B2BLogonFormJSIncluded" value="true" scope="request"/>
	</c:if>
	
	<script type="text/javascript">
		dojo.addOnLoad(function() {
			ServicesDeclarationJS.setCommonParameters('<c:out value='${WCParam.langId}'/>','<c:out value='${WCParam.storeId}'/>','<c:out value='${WCParam.catalogId}'/>');

			MessageHelper.setMessage("PWDREENTER_DO_NOT_MATCH", storeNLS['PWDREENTER_DO_NOT_MATCH']);
			MessageHelper.setMessage("WISHLIST_INVALIDEMAILFORMAT", storeNLS['WISHLIST_INVALIDEMAILFORMAT']);
			MessageHelper.setMessage("REQUIRED_FIELD_ENTER", storeNLS['REQUIRED_FIELD_ENTER']);
			MessageHelper.setMessage("ERROR_INVALIDPHONE", storeNLS['ERROR_INVALIDPHONE']);
			MessageHelper.setMessage("ERROR_LastNameEmpty", storeNLS['ERROR_LastNameEmpty']);
			MessageHelper.setMessage("ERROR_AddressEmpty", storeNLS['ERROR_AddressEmpty']);
			MessageHelper.setMessage("ERROR_CityEmpty", storeNLS['ERROR_CityEmpty']);
			MessageHelper.setMessage("ERROR_StateEmpty", storeNLS['ERROR_StateEmpty']);
			MessageHelper.setMessage("ERROR_CountryEmpty", storeNLS['ERROR_CountryEmpty']);
			MessageHelper.setMessage("ERROR_ZipCodeEmpty", storeNLS['ERROR_ZipCodeEmpty']);
			MessageHelper.setMessage("ERROR_EmailEmpty", storeNLS['ERROR_EmailEmpty']);
			MessageHelper.setMessage("ERROR_LogonIdEmpty", storeNLS['ERROR_LogonIdEmpty']);
			MessageHelper.setMessage("ERROR_PasswordEmpty", storeNLS['ERROR_PasswordEmpty']);
			MessageHelper.setMessage("ERROR_VerifyPasswordEmpty", storeNLS['ERROR_VerifyPasswordEmpty']);
			MessageHelper.setMessage("ERROR_MESSAGE_TYPE", storeNLS['ERROR_MESSAGE_TYPE']);
			MessageHelper.setMessage("ERROR_INVALIDEMAILFORMAT", storeNLS['ERROR_INVALIDEMAILFORMAT']);
			MessageHelper.setMessage("ERROR_FirstNameEmpty", storeNLS['ERROR_FirstNameEmpty']);
			MessageHelper.setMessage("ERROR_FirstNameTooLong", storeNLS['ERROR_FirstNameTooLong']);
			MessageHelper.setMessage("ERROR_LastNameTooLong", storeNLS['ERROR_LastNameTooLong']);
			MessageHelper.setMessage("ERROR_AddressTooLong", storeNLS['ERROR_AddressTooLong']);
			MessageHelper.setMessage("ERROR_CityTooLong", storeNLS['ERROR_CityTooLong']);
			MessageHelper.setMessage("ERROR_StateTooLong", storeNLS['ERROR_StateTooLong']);
			MessageHelper.setMessage("ERROR_CountryTooLong", storeNLS['ERROR_CountryTooLong']);
			MessageHelper.setMessage("ERROR_ZipCodeTooLong", storeNLS['ERROR_ZipCodeTooLong']);
			MessageHelper.setMessage("ERROR_EmailTooLong", storeNLS['ERROR_EmailTooLong']);
			MessageHelper.setMessage("ERROR_PhoneTooLong", storeNLS['ERROR_PhoneTooLong']);	         
			MessageHelper.setMessage("ERROR_SpecifyYear", storeNLS['ERROR_SpecifyYear']);
			MessageHelper.setMessage("ERROR_SpecifyMonth", storeNLS['ERROR_SpecifyMonth']);
			MessageHelper.setMessage("ERROR_SpecifyDate", storeNLS['ERROR_SpecifyDate']);
			MessageHelper.setMessage("ERROR_InvalidDate1", storeNLS['ERROR_InvalidDate1']);
			MessageHelper.setMessage("ERROR_InvalidDate2", storeNLS['ERROR_InvalidDate2']);
			MessageHelper.setMessage("ERROR_MOBILE_PHONE_EMPTY", storeNLS['ERROR_MOBILE_PHONE_EMPTY']);
			MessageHelper.setMessage("AGE_WARNING_ALERT", storeNLS['AGE_WARNING_ALERT']);
			MessageHelper.setMessage("ERROR_OrgNameEmpty", storeNLS['ERROR_OrgNameEmpty']);
			MessageHelper.setMessage("ERROR_DefaultOrgRegistration", storeNLS['ERROR_DefaultOrgRegistration']);
		});
		
	</script>
	<script type="text/javascript">
		function popupWindow(URL) {
			window.open(URL, "mywindow", "status=1,scrollbars=1,resizable=1");
		}
	</script>  

	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
      
</head>


<wcf:url var="MyAccountURL" value="AjaxLogonForm" type="Ajax">
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
</wcf:url>

<c:set var="actionURL" value="UserRegistrationAdd" scope="request" />
<c:set var="pageCategory" value="MyAccount" scope="request"/>

<body>

<!-- Page Start -->
<div id="page">

	<%--
	  ***
	  * If an error occurs, the page will refresh and the entry fields will be pre-filled with the previously entered value.
	  * The entry fields below use e.g. paramSource.logonId to get the previously entered value.
	  * In this case, the paramSource is set to WCParam.  
	  ***
	--%>
	<c:set var="paramSource" value="${WCParam}"/>  

	<c:set var="person" value="${requestScope.person}"/>
	<c:if test="${empty person || person==null}">
		<wcf:rest var="person" url="store/{storeId}/person/@self" scope="request">
			<wcf:var name="storeId" value="${WCParam.storeId}" encode="true"/>
		</wcf:rest>
	</c:if>	
	<!-- Main Content Start -->

	<!-- Import Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->
	
	<!-- Content Start -->
	<div class="content_wrapper_position" role="main">
		<div class="content_wrapper">
			<div class="content_left_shadow">
				<div class="content_right_shadow">
					<div class="main_content">
						<div class="container_full_width">	
							<%out.flush();%>
							<c:import url = "${env_siteWidgetsDir}com.ibm.commerce.store.widgets.RegistrationForm/RegistrationForm.jsp" />
							<%out.flush();%>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Content End -->
	
	<!-- Main Content End -->
	<!-- Footer Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div>
	<!-- Footer End --> 
</div>

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
<%@ include file="../../../Common/JSPFExtToInclude.jspf"%> </body>
</html>
   
<!-- END UserRegistrationAddForm.jsp -->
