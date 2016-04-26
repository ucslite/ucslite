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
<wcf:url var="organizationsAndUsersViewURL" value="OrganizationsAndUsersView" >
	<wcf:param name="storeId"   value="${WCParam.storeId}"  />
	<wcf:param name="catalogId" value="${WCParam.catalogId}"/>
	<wcf:param name="langId" value="${langId}" />
	<wcf:param name="orgEntityId" value="${param.parentOrgEntityId}" />
</wcf:url>
<div style="margin-bottom:0px;" id="PageHeader_CreateOrganization" tabindex="0">
	<h1 style="padding: 0px 0px;" class="RequisitionListHeader"><fmt:message key="ORG_CREATE_ORG_HEADING" bundle="${storeText}"/></h1>
	<p class="required"> * <fmt:message key="REQUIRED_FIELDS" bundle="${storeText}"/></p>
</div>

<div class="row">
	<div class="col12">
		<div class="pageSection">
			<div id="orgDetailsEdit">
				<div class="field">
					<span class="spanacce">
						<label for="orgName">
							<fmt:message bundle="${storeText}" key="ORG_CREATE_ORG_NAME"/>
						</label>
					</span>
					<p><fmt:message key="ORG_CREATE_ORG_NAME" bundle="${storeText}"/><span class="required">*</span></p>
					<input type="text" id="orgName" name="orgName"/>
				</div>
				<c:set var="orgListHeading">
					<fmt:message key="ORG_CREATE_ORG_PARENT_ORG_NAME" bundle="${storeText}"/>
				</c:set>
				<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationList/OrganizationList.jsp">
					<c:param name="showOrgSummary" value="false"/>
					<c:param name="forParentOrg" value="true"/>
					<c:param name="parentOrgEntityId" value="${param.parentOrgEntityId}"/>
					<c:param name="createOrgPage" value="true"/>
					<c:param name="orgListHeading" value="${orgListHeading}"/>
					<c:param name="orgListHeading_2" value=" "/>
				</c:import>
			</div>
		</div>
		<%out.flush();%>
			<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationSummary/OrganizationSummary.jsp">
				<c:param name="orgSummaryType" value="create"/>
			</c:import>
		<%out.flush();%>

		<c:if test = "${(env_shopOnBehalfSessionEstablished eq 'false' && env_shopOnBehalfEnabled_CSR eq 'false')}">
			<%-- This is a normal buyerAdmin session or buyerAdmin on-behalf-session for another buyerAdmin. Not a CSR session --%>
			<%out.flush();%>
				<c:import url="${env_siteWidgetsDir}com.ibm.commerce.store.widgets.OrganizationRoles/OrganizationRoles.jsp">
					<c:param name="roleDisplayType" value="create"/>
					<c:param name="orgEntityId" value="${param.parentOrgEntityId}"/>
				</c:import>
			<%out.flush();%>
		</c:if>

		<div class="row">
			<div class="col12">
				<div style="margin:10px 10px 40px 10px;">
					<div class="editActions">
						<a class="button_primary" role="button" id="orgEntityCreate" onclick="javascript:organizationSummaryJS.createOrgEntity(this.id);return false;" href="#">
							<div class="button_text"><span><fmt:message bundle="${storeText}" key="ORG_SUBMIT"/></span></div>
						</a>

						<a class="button_secondary" role="button" id="orgEntityCreateCancel" onclick="javascript:widgetCommonJS.redirect('${organizationsAndUsersViewURL}');" href="#">
							<div class="button_text"><span><fmt:message bundle="${storeText}" key="ORG_CANCEL"/></span></div>
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<input type="hidden" id="authToken" value="${authToken}"/>