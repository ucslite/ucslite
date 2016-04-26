<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf"%>
<%@ include file="../../../include/ErrorMessageSetup.jspf"%>
<%@ include file="../../../Common/nocache.jspf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>    
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="hasBreadCrumbTrail" value="false" scope="request"/>

<!DOCTYPE HTML>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<!-- BEGIN OrderStatusDisplay.jsp -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="${shortLocale}" xml:lang="${shortLocale}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><fmt:message key="MO_MYORDERS"/></title>
	<link rel="stylesheet" href="<c:out value="${jspStoreImgDir}${env_vfileStylesheet}"/>" type="text/css"/>

	<script type="text/javascript" src="<c:out value="${dojoFile}"/>" djConfig="${dojoConfigParams}"></script>
	<%@ include file="../../../Common/CommonJSToInclude.jspf"%>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}/javascript/Widgets/Search.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}/javascript/Widgets/MiniShopCartDisplay/MiniShopCartDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}/javascript/Widgets/Department/Department.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/Common/ShoppingActions.js"/>"></script>
	
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonContextsDeclarations.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/CommonControllersDeclaration.js"/>"></script>
			
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/AddressHelper.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountDisplay.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountServicesDeclaration.js"/>"></script>
	<script type="text/javascript" src="<c:out value="${jsAssetsDir}javascript/UserArea/MyAccountControllersDeclaration.js"/>"></script>
	
	<%@ include file="../../../Common/CommonJSPFToInclude.jspf"%>
	
	<script type="text/javascript">
		dojo.addOnLoad(function() {
			MyAccountServicesDeclarationJS.setCommonParameters('<c:out value="${WCParam.langId}"/>','<c:out value="${WCParam.storeId}"/>','<c:out value="${WCParam.catalogId}"/>');
		});
	</script>
  </head>
<body>

<!-- Page Start -->
<div id="page">
	<!-- Import Header Widget -->
	<div class="header_wrapper_position" id="headerWidget">
		<%out.flush();%>
		<c:import url = "${env_jspStoreDir}/Widgets/Header/Header.jsp" />
		<%out.flush();%>
	</div>
	<!-- Header Nav End -->
	<div class="content_wrapper_position" role="main">
		<div class="content_wrapper">
			<div class="content_left_shadow">
				<div class="content_right_shadow">
					<div class="main_content">
						<%out.flush();%>
							<c:import url="/${sdb.jspStoreDir}/include/BreadCrumbTrailDisplay.jsp">
								<c:param name="topCategoryPage" value="${requestScope.topCategoryPage}" />
								<c:param name="categoryPage" value="${requestScope.categoryPage}" />
								<c:param name="productPage" value="${requestScope.productPage}" />
								<c:param name="shoppingCartPage" value="${requestScope.shoppingCartPage}" />
								<c:param name="compareProductPage" value="${requestScope.compareProductPage}" />
								<c:param name="finalBreadcrumb" value="${requestScope.finalBreadcrumb}" />
								<c:param name="extensionPageWithBCF" value="${requestScope.extensionPageWithBCF}" />
								<c:param name="hasBreadCrumbTrail" value="${requestScope.hasBreadCrumbTrail}" />
								<c:param name="requestURIPath" value="${requestScope.requestURIPath}" />
								<c:param name="SavedOrderListPage" value="${requestScope.SavedOrderListPage}" />
								<c:param name="pendingOrderDetailsPage" value="${requestScope.pendingOrderDetailsPage}" />
								<c:param name="sharedWishList" value="${requestScope.sharedWishList}" />
								<c:param name="searchPage" value="${requestScope.searchPage}"/>
							</c:import>
						<%out.flush();%>
						<div class="container_content_leftsidebar">													
						  	<div class="left_column">
						  		<%@ include file="../../../include/LeftSidebarDisplay.jspf"%>
						  	</div>
							<div class="right_column">
								<div id="box">
									<div class="my_account" id="WC_OrderStatusDisplay_div_1">		
										<div class="body" id="WC_OrderStatusCommonPage_div_6">						
											<wcbase:useBean id="customer" classname="com.ibm.commerce.user.beans.UserDataBean">
												<c:set target="${customer}" property="dataBeanKeyMemberId" value="${userId}" />
											</wcbase:useBean>	
											customer: ${customer.userField1 }
										</div>
									</div>
									<div class="footer" id="WC_OrderStatusCommonPage_div_7">
										<div class="left_corner" id="WC_OrderStatusCommonPage_div_8"></div>
										<div class="tile" id="WC_OrderStatusCommonPage_div_9"></div>
										<div class="right_corner" id="WC_OrderStatusCommonPage_div_10"></div>
									</div>				
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
	<!-- Footer Start -->
	<div class="footer_wrapper_position">
		<%out.flush();%>
			<c:import url = "${env_jspStoreDir}/Widgets/Footer/Footer.jsp" />
		<%out.flush();%>
	</div>
	<!-- Footer End --> 
</div>

<flow:ifEnabled feature="Analytics"><cm:pageview/></flow:ifEnabled>
</body>
</html>
<!-- END OrderStatusDisplay.jsp -->
