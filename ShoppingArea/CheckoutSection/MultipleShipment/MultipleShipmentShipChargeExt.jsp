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
<%-- 
  *****
  * This JSP file shows shipping charge snippet used by B2B checkout
  *****
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>

	<script type="text/javascript">
		dojo.addOnLoad(function() { 
			CheckoutHelperJS.setShipChargeEnabled(true);
		});
	</script>

	<c:set var="orderUniqueId" value="${WCParam.orderId}" />
	<c:if test="${orderUniqueId == '' || orderUniqueId == undefined || orderUniqueId == null}">
		<c:set var="orderUniqueId" value="${param.orderId}" />
	</c:if>
	
	<%-- use the UsableShipChargesAndAccountByShipModeDataBean instead of getting from order service as it will give how many ship modes shopper has selected --%>

	 <wcf:rest var="shipCharges" url="store/{storeId}/cart/{orderId}/usable_ship_charges_by_ship_mode">
		<wcf:var name="storeId" value="${storeId}" />
		<wcf:var name="orderId" value="${orderUniqueId}" />
	</wcf:rest>
	<c:set var="shipCharges" value="${shipCharges.resultList[0]}" />
	<c:if test="${not empty shipCharges.shipChargesByShipMode}">
		<%-- for multiple shipment --%>
		<flow:ifDisabled feature="AjaxCheckout"> 
			<form method="post" action="ShipInfoUpdate" id="shipChargeUpdateForm" name="shipChargeUpdateForm">
				<input type="hidden" name="storeId" value="${WCParam.storeId}" id="shipChargeUpdateForm_input_1"/>
				<input type="hidden" name="langId" value="${WCParam.langId}" id="shipChargeUpdateForm_input_2"/>
				<input type="hidden" name="catalogId" value="${WCParam.catalogId}" id="shipChargeUpdateForm_input_3"/>
				<input type="hidden" name="orderId" value="${orderUniqueId}" id="shipChargeUpdateForm_input_4"/>
				<input type="hidden" name="URL" value="" id="shipChargeUpdateForm_input_5"/>
		</flow:ifDisabled>
		
		<%-- display ship charge selection in table format --%>
		<table id="B2BShippingChargeExt_shipcharge_table" cellpadding="0" cellspacing="0" border="0" width="100%" summary="<fmt:message bundle="${storeText}" key="Multi_Ship_ShipCharge_Table" />">
			<tr class="nested">
				<th class="align_left" id="B2BShippingChargeExt_header1"><fmt:message bundle="${storeText}" key="ShipCharge_Table_Shipmode" /></th>
				<th class="align_left" id="B2BShippingChargeExt_header2"><fmt:message bundle="${storeText}" key="ShippingChargeType" /></th>
				<th class="align_left" id="B2BShippingChargeExt_header3"><fmt:message bundle="${storeText}" key="ShippingChargeAcctNum" /></th>
			</tr>
			
			<c:forEach items="${shipCharges.shipChargesByShipMode}" var="shipCharges_data"  varStatus="counter">
				<input type="hidden" name="shipModeId_<c:out value="${counter.count}"/>" id="shipModeId_<c:out value="${counter.count}"/>" value="<c:out value="${shipCharges_data.shipModeId}" />" />
				<tr id="shipChargeTable_row_<c:out value="${counter.count}"/>">
					<td id="shipChargeTable_row_<c:out value="${counter.count}"/>_shipmode" class="th_align_left_normal" width="225">
						<c:out value="${shipCharges_data.shipModeDesc}" />
					</td>
					<td id="shipChargeTable_row_<c:out value="${counter.count}"/>_chargeType" class="th_align_left_no_bottom" width="200">
						<select class="drop_down_shipping" name="shipChargTypeId_<c:out value="${counter.count}"/>" id="shipChargTypeId_<c:out value="${counter.count}"/>" 
									onchange="javascript:setCurrentId('shipChargTypeId_<c:out value="${counter.count}"/>'); 
										CheckoutHelperJS.hideShipChargeAccountField('shipChargTypeId_<c:out value="${counter.count}"/>','ShipChargeAcctDiv_<c:out value="${counter.count}"/>');
										CheckoutHelperJS.updateShippingChargeForShipModeAjax('<c:out value="${orderUniqueId}"/>', '<c:out value="${shipCharges_data.shipModeId}" />', this.value);">
							<c:forEach items="${shipCharges_data.shippingChargeTypes}" var="shipChargeType_data" >
								<c:choose>
									<c:when test="${shipChargeType_data.selected}">
										<c:set var="chargeByCarrier" value="${shipChargeType_data.internalPolicyId}"/>
										<option value="<c:out value="${shipChargeType_data.policyId}"/>" selected="selected">
									</c:when> 
									<c:otherwise>
										<option value="<c:out value="${shipChargeType_data.policyId}"/>">
									</c:otherwise>
								</c:choose>
									<fmt:message key="${shipChargeType_data.policyName}" bundle="${storeText}" />
								</option>
							</c:forEach>
						</select>
						<label class="nodisplay" for="shipChargTypeId_<c:out value="${counter.count}"/>">
							<fmt:message key="ShipCharge_Table_label_chargeType" bundle="${storeText}"> 
								<fmt:param><c:out value="${shipCharges_data.shipModeDesc}" escapeXml="false"/></fmt:param>
							</fmt:message> 
						</label>
					</td>
					<td id="shipChargeTable_row_<c:out value="${counter.count}"/>_account" class="th_align_left_no_bottom">
						<c:choose>
							<c:when test="${chargeByCarrier eq -7002}">
								<div id="ShipChargeAcctDiv_<c:out value='${counter.count}'/>" style="display: block;">
							</c:when>
							<c:otherwise>
								<div id="ShipChargeAcctDiv_<c:out value='${counter.count}'/>" style="display: none;">
							</c:otherwise>
						</c:choose> 
						<input class="input" type="text" name="shipCarrAccntNum_<c:out value="${counter.count}"/>" 
								size="20" maxlength="100" value="<c:out value="${shipCharges_data.carrierAccountNumber}" />" 
									id="shipCarrAccntNum_<c:out value="${counter.count}"/>"
									onblur="javascript:setCurrentId('shipChargTypeId_<c:out value="${counter.count}"/>'); 
									CheckoutHelperJS.updateShippingChargeForShipModeAjax('<c:out value="${orderUniqueId}"/>', '<c:out value="${shipCharges_data.shipModeId}" />', document.getElementById('shipChargTypeId_<c:out value="${counter.count}"/>').value, this.value);"/> 
						<label class="nodisplay" for="shipCarrAccntNum_<c:out value="${counter.count}"/>">
							<fmt:message key="ShipCharge_Table_label_acct" bundle="${storeText}"> 
								<fmt:param><c:out value="${shipCharges_data.shipModeDesc}" escapeXml="false"/></fmt:param>
							</fmt:message> 
						</label>
					</td>
				</tr>
			</c:forEach>
		</table>
		<flow:ifDisabled feature="AjaxCheckout"> 
			</form>
			<div id="button_class">
				<span class="primary_button button_fit">
					<span class="button_container">
						<span class="button_bg">
							<span class="button_top">
								<span class="button_bottom">
									<a href="#" onclick="javascript:CheckoutHelperJS.updateShippingChargeForShipMode(document.shipChargeUpdateForm);"><fmt:message key="ShippingCharge_Update" bundle="${storeText}"/></a>
								</span>
							</span>
						</span>
					</span>
				</span>
			</div>
		</flow:ifDisabled>
		<div class="shipChargePadding"></div>
	</c:if>
