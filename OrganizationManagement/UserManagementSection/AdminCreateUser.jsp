
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ include file="../../include/ErrorMessageSetup.jspf" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="addtionalBCT" scope="request"><fmt:message bundle="${storeText}" key="ORGANIZATIONMANAGE_ORGS_AND_USERS"/></c:set>
<wcf:url var="additionalBCT_URL" value="OrganizationsAndUsersView" scope="request">
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
</wcf:url>
<fmt:message bundle="${storeText}" key="ORGANIZATIONMANAGE_ADDUSER" var="contentPageName" scope="request"/>
<c:set var="pageCategory" value="MyAccount" scope="request"/>
<c:choose>
<c:when test="${not empty param.orgEntityId}" >
	<c:set var="parentMemberId" value="${param.orgEntityId}"/>
</c:when>
<c:when test="${not empty WCParam.orgEntityId}" >
	<c:set var="parentMemberId" value="${WCParam.orgEntityId}"/>
</c:when>
</c:choose>
<c:choose>
<c:when test="${not empty param.orgEntityName}" >
	<c:set var="parentMemberName" value="${param.orgEntityName}"/>
</c:when>
<c:when test="${not empty WCParam.orgEntityName}" >
	<c:set var="parentMemberName" value="${WCParam.orgEntityName}"/>
</c:when>
</c:choose>

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

<html xmlns:wairole="http://www.w3.org/2005/01/wai-rdf/GUIRoleTaxonomy#"
	xmlns:waistate="http://www.w3.org/2005/07/aaa" lang="${shortLocale}" xml:lang="${shortLocale}">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>${contentPageName}</title>
		
		<!--Main Stylesheet for browser -->
		<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${vfileStylesheet}"/>" type="text/css"/>

		<!-- Include script files -->
		<%@ include file="../../Common/CommonJSToInclude.jspf"%>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
		
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/ServicesDeclaration.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/LogonForm.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AddressHelper.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${staticAssetContextRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.RegistrationForm/javascript/B2BLogonForm.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${staticAssetContextRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationList/javascript/OrganizationList.js"/>"></script>
		<script type="text/javascript" src="<c:out value="${staticAssetContextRoot}${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationSummary/javascript/OrganizationSummary.js"/>"></script>

		<c:if test="${isBrazilStore}"> 
			<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyBrazilAccountDisplay.js"/>"></script>
		</c:if>
		<script type="text/javascript"> 
		require(["wc/widget/Tooltip"]); 
		dojo.addOnLoad(function() { 
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
		});
	</script>
		
		<%@ include file="../../include/ErrorMessageSetupBrazilExt.jspf" %>
	</head>
	
	<body>
		<!-- Page Start -->
		<div id="page" class="nonRWDPageB">
			<%@ include file="../../Common/CommonJSPFToInclude.jspf"%>	
			
			<!-- Header Widget -->
			<div id="headerWrapper">
				<%out.flush();%>
				<c:import url = "${env_jspStoreDir}Widgets/Header/Header.jsp" />
				<%out.flush();%>
			</div>
			<div id="AddBuyerErrorMessage">
				<c:if test="${!empty errorMessage}">
					<script type="text/javascript">
						dojo.addOnLoad(function() { 
							MessageHelper.displayErrorMessage('${errorMessage}');
						});
					</script>
				</c:if>
			</div>
			<!-- Main Content Start -->
			<div id="contentWrapper">
				<div id="content" role="main">
					<div class="rowContainer" id="container_reqList_detail">
						<div class="row margin-true">
							<!-- breadcrumb -->
							<%out.flush();%>
								<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.BreadcrumbTrail/BreadcrumbTrail.jsp">  
									<c:param name="pageGroup" value="Content" />
									<c:param name="doNotCacheForMyAccount" value="true"/>
								</c:import>
							<%out.flush();%>
							<div class="col12"></div>
						</div>
										
						<div class="row margin-true">
							<!-- Left Nav -->
							<div class="col4 acol12 ccol3">
								<%out.flush();%>
								<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.MyAccountNavigation/MyAccountNavigation.jsp"/>
								<%out.flush();%>	
							</div>
							
							<!-- Content area -->
							<div class="col8 acol12 ccol9 right">
								<div id="BuyerAdministratorBuyerCommonPageHeading">						
									<h1>${contentPageName}</h1>
									<span class="required-field" id="WC_denotesRequiredField"> * <fmt:message bundle="${storeText}" key="REQUIRED_FIELDS"/></span>
								</div>
								<div id="WC_createUser_orgDetailsEdit" class="pageSection" role="region" aria-labelledby="WC_CREATEUSER_ORGANIZATION_DETAILS_LABEL">
									<div class="pageSectionTitle">
										<span><h2 id="WC_CREATEUSER_ORGANIZATION_DETAILS_LABEL"><fmt:message key="ORGANIZATION_DETAILS" bundle="${storeText}"/></h2>
											<span id="WC_CREATEUSER_ORGANIZATION_DETAILS_ToolTip" tabindex="0" class="more_info_icon verticalAlign_middle">
												<img class="info_on" src="<c:out value='${jspStoreImgDir}${vfileColor}icon_info_ON.png'/>" alt=""/>
												<img class="info_off" src="<c:out value='${jspStoreImgDir}${vfileColor}icon_info.png'/>" alt=""/>
											</span>
										</span>
									</div>
									<%out.flush();%>
										<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationList/OrganizationList.jsp">
												<c:param name="fromPage" value="createUser" />
												<c:param name="orgEntityName" value="${parentMemberName }"/>
												<c:param name="orgEntityId" value="${parentMemgerId }"/>
										</c:import>
									<%out.flush();%>
								</div>
								<%out.flush();%>
								<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationUserInfo/OrganizationUserInfo.jsp">
									<c:param name="fromPage" value="createUser" />
									<c:param name="orgEntityName" value="${parentMemberName }"/>
									<c:param name="orgEntityId" value="${parentMemgerId }"/>
								</c:import>
								<%out.flush();%>
								
								
								<c:if test = "${(env_shopOnBehalfSessionEstablished eq 'false' && env_shopOnBehalfEnabled_CSR eq 'false')}">
									<%-- This is a normal buyerAdmin session or buyerAdmin on-behalf-session for another buyerAdmin. Not a CSR session --%>	
									<%out.flush();%>
									<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.UserRoleManagement/UserRoleManagement.jsp">
										<c:param name="fromPage" value="createUser" />
									</c:import>
									<%out.flush();%>
								</c:if>


								<div class="button_footer_line no_float" id="WC_UserRegistrationAddForm_Buttons_1">

									<wcf:url var="OrganizationsAndUsersViewURL" value="OrganizationsAndUsersView">
										<wcf:param name="storeId"   value="${WCParam.storeId}"  />
										<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
										<wcf:param name="langId" value="${langId}"/>
									</wcf:url>
									<c:set var="prepareFormSubmitJS" value="JavaScript:OrganizationUserInfoJS.chainedServicePrepareSubmit(document.Register,'${OrganizationsAndUsersViewURL}');return false;"/>

									<a href="#" role="button" class="button_primary" id="WC_UserRegistrationAddForm_links_1" tabindex="0" onclick="${prepareFormSubmitJS}">
										<div class="left_border"></div>
										<div class="button_text"><fmt:message bundle="${storeText}" key="SUBMIT"/></div>												
										<div class="right_border"></div>
									</a>
									
									<a role="button" class="button_secondary button_left_padding" id="WC_UserRegistrationAddForm_links_2" tabindex="0" href="javascript:setPageLocation('${OrganizationsAndUsersViewURL}')">
										<div class="left_border"></div>
										<div class="button_text"><fmt:message bundle="${storeText}" key="CANCEL"/></div>												
										<div class="right_border"></div>
									</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>				
			<!-- Main Content End -->

			<!-- Footer Widget -->
			<div id="footerWrapper">
				<%out.flush();%>
				<c:import url="${env_jspStoreDir}Widgets/Footer/Footer.jsp"/>
				<%out.flush();%>
			</div>
		
		</div>
		<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
		<%@ include file="../../Common/JSPFExtToInclude.jspf"%>
	</body>
</html>
