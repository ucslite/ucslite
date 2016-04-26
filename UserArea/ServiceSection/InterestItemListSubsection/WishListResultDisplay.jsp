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
<!-- BEGIN WishListResultDisplay.jsp -->
<%@ include file="../../../Common/EnvironmentSetup.jspf" %>
<%@ include file="../../../Common/JSTLEnvironmentSetupExtForRemoteWidgets.jspf"%>
<%@ include file="../../../Common/nocache.jspf" %>

<c:set var="myAccountPage" value="true" scope="request"/>
<c:set var="bHasWishList" value="true" />
<c:set var="wishListPage" value="true" />
<c:set var="emailError" value="false" />
	
<c:set var="numberProductsPerRow" value="2"/>
	
<c:set var="pageSize" value="${param.pageSize}" />
<c:if test="${empty pageSize}">
	<c:set var="pageSize" value="12" />
</c:if>
<c:set var="wishListViaEmail" value="false" />
<c:if test="${(WCParam.wishListEMail != null && !empty WCParam.wishListEMail  && WCParam.wishListEMail == 'true')}">
	<c:set var="wishListViaEmail" value="true" />
</c:if>

<c:if test="${(param.wishListEMail != null && !empty param.wishListEMail && param.wishListEMail == 'true')}">
	<c:set var="wishListViaEmail" value="true" />
</c:if>

<c:choose>
	<%-- users have explicitly chosen a pageView --%>
	<c:when test="${!empty WCParam.pageView}">
		<c:set var="pageView" value="${WCParam.pageView}"/>
	</c:when>
	<c:otherwise>
		<c:set var="pageView" value="image" />
	</c:otherwise>
</c:choose>

	<c:set var="startIndex" value="${WCParam.startIndex}" />
	<c:if test="${empty startIndex}">
		<c:set var="startIndex" value="0" />
	</c:if>
	<%@ include file="../../../Snippets/MultipleWishList/GetDefaultWishList.jspf" %>	
	
	<c:choose>
		<c:when test="${!empty WCParam.wishListEMail && WCParam.wishListEMail != null && WCParam.wishListEMail == 'true'}">
			<%-- from shared wish list page - user can be a guest user or a registered user who is not the owner of the wish list --%>
			<c:set var="sharedWishList" value="true" scope="request"/>
			<c:set var="numberProductsPerRow" value="4"/>
			<c:choose>
				
				<c:when test="${empty WCParam.externalId}">
					<c:set var="emailError" value="true" />
				</c:when>
				
				<c:otherwise>
					<c:set var="selectedWishListExternalId" value="${WCParam.externalId}"/>
					<%@ include file="../../../Snippets/MultipleWishList/GetWishListItemsByExternalId.jspf" %>
					<fmt:parseNumber var="numEntries" value="${wishListResult.recordSetTotal}" integerOnly="true" />

					<c:if test="${(numEntries == 0 && startIndex != 0) || (numEntries < startIndex )}">
						<%-- when nothing is returned - it can be that last item from the page is removed, go back one page --%>
						<c:set var="startIndex" value="${startIndex - pageSize}" />
						<c:if test="${startIndex < 0}">
							<c:set var="startIndex" value="0" />
						</c:if>
						<%@ include file="../../../Snippets/MultipleWishList/GetWishListItemsByExternalId.jspf" %>
					</c:if>
					
					<c:if test="${selectedWishList == null}">
						<c:set var="emailError" value="true" />
					</c:if>
					
					<c:if test="${empty selectedWishList.item}">
						<c:set var="bHasWishList" value="false"/>
					</c:if>
				</c:otherwise>
			</c:choose>
			
		</c:when>
		
		<c:when test="${empty defaultWishList}">
			<%-- from my account wish list page - if user has no wish list defined, set bHasWishList to false --%>
			<c:set var="bHasWishList" value="false"/>
		</c:when>
		
		<c:when test="${WCParam.giftListId == -1}">
			<%-- from my account wish list page - user selected the dummy Wish List entry, set bHasWishList to false --%>
			<c:set var="bHasWishList" value="false"/>
		</c:when>
		
		<c:otherwise>
			<%-- from my account wish list page - user has wish list defined, get the detail of user's default wish list --%>
			<c:set var="selectedWishListExternalId" value="${defaultWishList.externalIdentifier}"/>
			<c:set var="selectedWishListId" value="${defaultWishList.uniqueID}"/>
			<%@ include file="../../../Snippets/MultipleWishList/GetWishListItemsByExternalId.jspf" %>
			<fmt:parseNumber var="numEntries" value="${wishListResult.recordSetTotal}" integerOnly="true" />
			<c:if test="${(numEntries == 0 && startIndex != 0) || (numEntries < startIndex )  }">
				<%-- when nothing is returned - it can be that last item from the page is removed, go back one page --%>
				<c:set var="startIndex" value="${startIndex - pageSize}" />
				<c:if test="${startIndex < 0}">
					<c:set var="startIndex" value="0" />
				</c:if>
				<%@ include file="../../../Snippets/MultipleWishList/GetWishListItemsByExternalId.jspf" %>
			</c:if>
			
			<c:if test="${empty selectedWishList.item}">
				<c:set var="bHasWishList" value="false"/>
			</c:if>
		</c:otherwise>
	</c:choose>
	<fmt:parseNumber var="numEntries" value="${wishListResult.recordSetTotal}" integerOnly="true" />
	<c:set var="numEntries" value="${numEntries}"/>
	
	<fmt:formatNumber var="totalPages" value="${(numEntries/pageSize)+1}"/>
	<c:if test="${numEntries%pageSize == 0}">
		<fmt:formatNumber var="totalPages" value="${numEntries/pageSize}"/>
		<c:if test="${totalPages == 0 && numEntries!=0}">
			<fmt:formatNumber var="totalPages" value="1"/>
		</c:if>
	</c:if>
	<fmt:parseNumber var="totalPages" value="${totalPages}" integerOnly="true"/>
	
	<c:set var="currentPage" value="${param.currentPage}" />
	<c:if test="${empty currentPage}">
		<c:set var="currentPage" value="0" />
	</c:if>
	
	<c:if test="${currentPage < 0}">
		<c:set var="currentPage" value="0"/>
	</c:if>
	<c:if test="${currentPage >= (totalPages)}">
		<c:set var="currentPage" value="${totalPages-1}"/>
	</c:if>
		
	<c:set var="endIndex" value="${(currentPage + 1) * pageSize}"/>
	<c:if test="${endIndex > numEntries}">
		<c:set var="endIndex" value="${numEntries}"/>
	</c:if>
	
<c:if test="${currentPage != 0}">
	<wcf:url var="WishListResultDisplayViewPrevURL" value="WishListResultDisplayView" type="Ajax">
	  <wcf:param name="langId" value="${langId}" />						
	  <wcf:param name="storeId" value="${WCParam.storeId}" />
	  <wcf:param name="catalogId" value="${WCParam.catalogId}" />
	  <wcf:param name="currentPage" value="${currentPage - 1}" />
	  <wcf:param name="startIndex" value="${startIndex - pageSize}" />
	  <wcf:param name="pageView" value="${pageView}" />
	  <c:if test="${wishListViaEmail == 'true'}">
	  	<wcf:param name="wishListEMail" value="true" />
	  	<wcf:param name="externalId" value="${WCParam.externalId}" />
	  </c:if>
	</wcf:url>
</c:if>

<c:if test="${currentPage < totalPages-1}">
	<wcf:url var="WishListResultDisplayViewNextURL" value="WishListResultDisplayView" type="Ajax">
		<wcf:param name="langId" value="${langId}" />						
		<wcf:param name="storeId" value="${WCParam.storeId}" />
		<wcf:param name="catalogId" value="${WCParam.catalogId}" />
		<wcf:param name="currentPage" value="${currentPage + 1}" />
		<wcf:param name="startIndex" value="${startIndex + pageSize}" />
		<wcf:param name="pageView" value="${pageView}" />
		<c:if test="${wishListViaEmail == 'true'}">
			<wcf:param name="wishListEMail" value="true" />
			<wcf:param name="externalId" value="${WCParam.externalId}" />
		</c:if>
	</wcf:url>
</c:if>

<wcf:url var="WishListResultDisplayViewFullURL" value="WishListResultDisplayView" type="Ajax">
	<wcf:param name="langId" value="${langId}" />						
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="currentPage" value="${currentPage}" />
	<wcf:param name="startIndex" value="${startIndex}" />
	<wcf:param name="pageView" value="detailed" />
	<c:if test="${wishListViaEmail == 'true'}">
		<wcf:param name="wishListEMail" value="true" />
		<wcf:param name="externalId" value="${WCParam.externalId}" />
	</c:if>
</wcf:url>

<wcf:url var="WishListResultDisplayViewURL" value="WishListResultDisplayView" type="Ajax">
	<wcf:param name="langId" value="${langId}" />						
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="currentPage" value="${currentPage}" />
	<wcf:param name="startIndex" value="${startIndex}" />
	<wcf:param name="pageView" value="image" />
	<c:if test="${wishListViaEmail == 'true'}">
		<wcf:param name="wishListEMail" value="true" />
		<wcf:param name="externalId" value="${WCParam.externalId}" />
	</c:if>
</wcf:url>

<wcf:url var="WishListResultDisplay" value="WishListResultDisplayView" type="Ajax">
	<wcf:param name="langId" value="${langId}" />						
	<wcf:param name="storeId" value="${WCParam.storeId}" />
	<wcf:param name="catalogId" value="${WCParam.catalogId}" />
	<wcf:param name="currentPage" value="${currentPage}" />
	<wcf:param name="startIndex" value="${startIndex}" />
	<wcf:param name="pageView" value="${pageView}" />
	<c:if test="${wishListViaEmail == 'true'}">
		<wcf:param name="wishListEMail" value="true" />
		<wcf:param name="externalId" value="${WCParam.externalId}" />
	</c:if>
</wcf:url>

<div class="left body588" id="WC_WishListResultDisplay_div_3l">
	<c:if test="${isBiDiLocale == 'true' and !sharedWishList}">
		<flow:ifEnabled feature="RemoteWidget">
			<c:if test="${!empty defaultWishList}">		
				<div class="right" id="getWidgetButton">
					<c:url var="feedURL" value="${restURLScheme}://${restServerName}:${restURLPort}${restURI}/stores/${WCParam.storeId}/GiftLists/${selectedWishListId}?guestAccessKey=${defaultWishList.guestAccessKey}">
						<c:param name="responseFormat" value="atom" />
						<c:param name="langId" value="${langId}" />
						<c:param name="currency" value="${CommandContext.currency}" />
					</c:url>
					<c:import url="/${sdb.jspStoreDir}/Common/RemoteWidgetButtons.jsp">
			  			<c:param name="showFeed" value="false" />
			  			<c:param name="feedURL" value="${feedURL}" />
			  		</c:import>
				</div>	
			</c:if>
		</flow:ifEnabled>
	</c:if>
	<c:choose>
		<c:when test="${wishListViaEmail == 'true'}">
			<h2 class="myaccount_header no_side_lines"><c:out value="${selectedWishList.descriptionName}"/></h2>				
		</c:when>
		<c:when test="${empty defaultWishList || WCParam.giftListId == -1}">
			<h2 class="myaccount_header no_side_lines"><fmt:message bundle="${storeText}" key="MA_PERSONAL_WL" /></h2>
		</c:when>
		<c:otherwise>
			<h2 class="myaccount_header no_side_lines"><c:out value="${defaultWishList.descriptionName}"/></h2>
		</c:otherwise>
	</c:choose>
	
	<c:if test="${isChinaStore }">	
		<span class="main_header_text wishlist_sharing"><a href="javascript:;" onclick="dojo.byId('wishlist').style.display='block';return false;"><fmt:message bundle="${storeText}" key="WISHLIST_SHARE_WISHLIST" /></a></span>			
	</c:if>
		
	<c:if test="${isBiDiLocale == 'false' and !sharedWishList}">
		<flow:ifEnabled feature="RemoteWidget">
			<c:if test="${!empty defaultWishList}">		
				<div class="right" id="getWidgetButton">
					<c:url var="feedURL" value="${restURLScheme}://${restServerName}:${restURLPort}${restURI}/stores/${WCParam.storeId}/GiftLists/${selectedWishListId}?guestAccessKey=${defaultWishList.guestAccessKey}">
						<c:param name="responseFormat" value="atom" />
						<c:param name="langId" value="${langId}" />
						<c:param name="currency" value="${CommandContext.currency}" />
					</c:url>
					<c:import url="/${sdb.jspStoreDir}/Common/RemoteWidgetButtons.jsp">
			  			<c:param name="showFeed" value="false" />
			  			<c:param name="feedURL" value="${feedURL}" />
			  		</c:import>
				</div>	
			</c:if>
		</flow:ifEnabled>
	</c:if>

</div>

<div class="body588" id="WC_WishListResultDisplay_div_5">
	<c:choose> 
		<c:when test="${emailError}">
			<%-- 
			  ***
			  * Error condition - when externalID specified is incorrect, or guestAccessKey is incorrect 
			  ***
			--%>
			<div class="my_account_wishlist_container" id="WC_WishListResultDisplay_div_6">
				<fmt:message bundle="${storeText}" key="GENERICERR_MAINTEXT" >
					<fmt:param><fmt:message bundle="${storeText}" key="GENERICERR_CONTACT_US" /></fmt:param>
				</fmt:message>
				<br/><br/>
			</div>
		</c:when>
		
		<c:when test="${ !bHasWishList }">
			<%--
				***
				* Start: Empty Wish List 
				* If the wish list is empty, display the empty wish list message
				***
			--%>
			<div class="my_account_wishlist_container" id="WC_WishListResultDisplay_div_6"><br/><fmt:message bundle="${storeText}" key="EMPTYWISHLIST" /><br/><br/></div>
			 <%--
				***
				* End: Empty Wish List 
				***
			--%>	
		</c:when>
		
		<c:otherwise>
			<%-- 
			  ***
			  * Wish list is not empty - display content of wish list 
			  ***
			--%>
						
			<%-- calculate total number of pages --%>
			<div class="left_wishlist" id="WC_WishListResultDisplay_div_8">
				<span class="subheader_text">
					<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_DISPLAYING" > 
						<fmt:param><fmt:formatNumber value="${startIndex + 1}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
					</fmt:message>
					
					<c:if test="${totalPages > 1}">
						<span class="paging">
							<c:if test="${currentPage != 0}">
								<c:choose>
									<c:when test="${wishListViaEmail == 'true'}">
										<a href="javaScript:refreshContentURL('<c:out value='${WishListResultDisplayViewPrevURL}'/>');" id="WC_WishListResultDisplay_links_1">
									</c:when>
									<c:otherwise>
										<a href="javaScript:setCurrentId('WC_WishListResultDisplay_links_1');AccountWishListDisplay.loadContentURL('<c:out value='${WishListResultDisplayViewPrevURL}'/>');" id="WC_WishListResultDisplay_links_1">
									</c:otherwise>
								</c:choose>
							</c:if>
							<img src="<c:out value='${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}' />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE" />" />
							<c:if test="${currentPage != 0}">
								</a>
							</c:if>
							<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
								<fmt:param><fmt:formatNumber value="${currentPage + 1}"/></fmt:param>
								<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
							</fmt:message>
							<c:if test="${currentPage < totalPages-1}">
								<c:choose>
									<c:when test="${wishListViaEmail == 'true'}">
										<a href="javaScript:refreshContentURL('<c:out value='${WishListResultDisplayViewNextURL}'/>');" id="WC_WishListResultDisplay_links_2">
									</c:when>
									<c:otherwise>
										<a href="javaScript:setCurrentId('WC_WishListResultDisplay_links_2');AccountWishListDisplay.loadContentURL('<c:out value='${WishListResultDisplayViewNextURL}'/>');" id="WC_WishListResultDisplay_links_2">
									</c:otherwise>	
								</c:choose>
							</c:if>
							<img src="<c:out value='${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}' />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
							<c:if test="${currentPage < totalPages-1}">
								</a>
							</c:if>
						</span>
					</c:if>
				</span>
			</div>
			<div class="right" id="WC_WishListResultDisplay_div_9">              
				<span class="views_icon">  
					<c:if test="${pageView !='image'}">
						<c:set var="gridView" value="horizontal_grid"/>
						<c:choose>
							<c:when test="${wishListViaEmail == 'true'}">
								<a id="WC_WishListResultDisplay_links_3" title="<fmt:message bundle="${storeText}" key="CATEGORY_IMAGE_VIEW" />"
									href="javaScript:refreshContentURL('<c:out value='${WishListResultDisplayViewURL}'/>');">
									<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}" />grid_normal.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_IMAGE_VIEW" />" />
								</a>
							</c:when>
							<c:otherwise>
								<a id="WC_WishListResultDisplay_links_3" title="<fmt:message bundle="${storeText}" key="CATEGORY_IMAGE_VIEW" />"
									href="javaScript:setCurrentId('WC_WishListResultDisplay_links_3'); AccountWishListDisplay.loadContentURL('<c:out value='${WishListResultDisplayViewURL}'/>');">
									<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}" />grid_normal.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_IMAGE_VIEW" />" />
								</a>
							</c:otherwise>	
						</c:choose>
						 <img id="detailedTypeImageSelected" src="<c:out value="${jspStoreImgDir}${env_vfileColor}list_selected.png"/>" alt="<fmt:message bundle="${storeText}" key="FF_VIEWDETAILS" />"/>	
					</c:if>
					<c:if test="${pageView !='detailed'}">
						<c:set var="gridView" value="four-grid-wishlist"/> 
						<img id="imageTypeImageSelected" src="<c:out value="${jspStoreImgDir}${env_vfileColor}grid_selected.png"/>" alt="<fmt:message bundle="${storeText}" key="FF_VIEWICONS" />"/>
						<c:choose>
							<c:when test="${wishListViaEmail == 'true'}">
								<a  id="WC_WishListResultDisplay_links_4" title="<fmt:message bundle="${storeText}" key='CATEGORY_DETAILED_VIEW'/>"
									href="javaScript:refreshContentURL('<c:out value='${WishListResultDisplayViewFullURL}'/>');">
									<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}" />list_normal.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_DETAILED_VIEW" />" />
								</a>
							</c:when>
							<c:otherwise>
								<a  id="WC_WishListResultDisplay_links_4" title="<fmt:message bundle="${storeText}" key='CATEGORY_DETAILED_VIEW'/>"
									href="javaScript:setCurrentId('WC_WishListResultDisplay_links_4'); AccountWishListDisplay.loadContentURL('<c:out value='${WishListResultDisplayViewFullURL}'/>');">
									<img src="<c:out value="${jspStoreImgDir}${env_vfileColor}" />list_normal.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_DETAILED_VIEW" />" />
								</a>
							</c:otherwise>	
						</c:choose>
					</c:if>
				</span>
			</div>
			<br/>
			<br clear="all" />
			<div id="${gridView}" cellpadding="0" cellspacing="0" border="0" role="presentation">
			<c:set var="rowItemCount" value="0"/>
			<c:set var="rowBeginIndex" value="0"/>

			<%-- 
			  ***
			  * displays items in the wish list
			  ***
			--%>	
			  <c:set var="prefix" value="wishList"/> <%-- used by CatalogEntryDBThumbnailDisplay.jspf to form unique ID for divs/quickInfo buttons --%>
				
				<wcf:rest var="catalogNavigationView" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/byIds" >
					<c:forEach var = "wishListItem" items = "${selectedWishList.item}" varStatus = "status">
						<wcf:param name="id" value="${wishListItem.productId}"/>
						
					</c:forEach>
					<wcf:param name="langId" value="${langId}" />
					<wcf:param name="currency" value="${env_currencyCode}" />
					<wcf:param name="responseFormat" value="json" />
					<wcf:param name="catalogId" value="${sdb.masterCatalog.catalogId}" />
					<wcf:param name="profileName" value="IBM_findProductByIds_Summary" />
				</wcf:rest>
				
				<c:set var="productResults" value="${catalogNavigationView.catalogEntryView}"/>					
				<c:forEach var="wishlistItem" items="${selectedWishList.item}" varStatus="status">
					<%-- If wish list unique Id is empty, the wishlist also has partnumber.
						Call service to see if a sku exists for the partnumber.	
					--%>
					<c:set var="itemError" value="false"/>
					<c:choose>
						<c:when test="${empty wishlistItem.productId}">
							<wcf:rest var="catalogNavigationViewItem" url="${searchHostNamePath}${searchContextPath}/store/${WCParam.storeId}/productview/${wishlistItem.partNumber}" >
								<wcf:param name="langId" value="${langId}" />
								<wcf:param name="currency" value="${env_currencyCode}" />
								<wcf:param name="responseFormat" value="json" />
								<wcf:param name="catalogId" value="${sdb.masterCatalog.catalogId}" />
								<wcf:param name="profileName" value="IBM_findProductByPartNumber_Summary" />
							</wcf:rest>
							<c:if test="${!empty catalogNavigationViewItem.catalogEntryView}">
								<c:set var="itemCatentryId" value="${catalogNavigationViewItem.catalogEntryView[0].uniqueID}"/>
							</c:if>
							<c:if test="${empty catalogNavigationViewItem.catalogEntryView}">
								<c:set var="itemError" value="true"/>
							</c:if>
							<c:if test="${!itemError}">
							
									<c:forEach var="wishListItemDisplay" items="${productResults}">
										<c:if test="${wishListItemDisplay.uniqueID eq itemCatentryId}">
											<c:set var="catEntry" value="${wishListItemDisplay}" />
										</c:if>
									</c:forEach>
									
							</c:if>
							<c:remove var="itemCatentryId"/>
						</c:when>
						<c:otherwise>
							
							<c:forEach var="wishListItemDisplay" items="${productResults}">
								<c:if test="${wishListItemDisplay.uniqueID eq wishlistItem.productId}">
									<c:set var="catEntry" value="${wishListItemDisplay}" />
								</c:if>
							</c:forEach>
							
						</c:otherwise>
					</c:choose>			
					
					<c:choose>
						<c:when test="${!itemError}">		
							<%--
							  *** 
							  * item exists in catalog - calls thumbnail display to display item details 
							  ***
							--%>
							<c:if test="${!sharedWishList}">
								<c:set var="includeRemoveFromWishList" value="true"/>
							</c:if>
							<c:set var="wishListIdentifier" value="${selectedWishList.uniqueID}"/>
							<c:if test="${rowItemCount == 0}">
								<div class="item_container_divider">
									<div class="divider_line" colspan="4" id="WC_WishListResultDisplay_td_1_<c:out value='${status.count}'/>"></div>
								</div>
								<div class="item_container">	
							</c:if>
							<c:if test="${pageView == 'image'}">
								<div class="item" id="WC_WishListResultDisplay_td_2_<c:out value='${status.count}'/>">
									<div id="WC_WishListResultDisplay_div_11_<c:out value='${status.count}'/>" <c:if test="${rowItemCount!=0}"> class="container" </c:if>>
										<c:set var="rowItemCount" value="${rowItemCount+1}"/>
							</c:if>

							<c:set var="listItem" value="${wishlistItem}"/>
							<c:set var="catEntryIdentifier" value="${wishlistItem.productId}" scope="request"/> <%-- used by CatalogEntryDBThumbnailDisplay.jspf to form unique ID for divs/quickInfo buttons --%>
							
							<%@ include file="../../../Snippets/ReusableObjects/CatalogEntrySearchThumbnailDisplay.jspf" %>
							<c:if test="${pageView == 'image'}">
									</div>
								</div>
							</c:if>
							<c:if test="${rowItemCount%numberProductsPerRow == 0}">
								</div>
								
								<c:set var="rowItemCount" value="0"/>
								<c:set var="rowBeginIndex" value="${status.index+1}"/>
							</c:if>
						</c:when> 
					
						<c:otherwise>
							<%-- 
							  *** 
							  * item does not exist in catalog - display empty image and remove link to allow shopper to remove the item 
							  ***
							--%>
							<c:if test="${rowItemCount == 0}">
								<div class="item_container_divider">
									<div class="divider_line" colspan="4" id="WishListResultDisplay_noCatentry_td_1_<c:out value='${status.count}'/>"></div>
								</div>
								<div class="item_container">	
							</c:if>
							
							<c:choose>
								<c:when test="${pageView == 'image'}">	
									<div class="item" id="WishListResultDisplay_noCatentry_td_2_<c:out value='${status.count}'/>">
										<div id="WishListResultDisplay_noCatentry_div_1_<c:out value='${status.count}'/>" <c:if test="${rowItemCount!=0}"> class="container" </c:if>>
											<c:set var="rowItemCount" value="${rowItemCount+1}"/>
											<div id="WishListResultDisplay_noCatentry_div_2_<c:out value='${status.count}'/>">
												<img src="<c:out value='${jspStoreImgDir}' />images/NoImageIcon_sm.jpg" alt="<fmt:message bundle="${storeText}" key="No_Image" />" border="0" width="70" height="70"/>
											</div>
											<div class="description" id="WishListResultDisplay_noCatentry_div_3_<c:out value='${status.count}'/>">
												<c:out value="${wishlistItem.partNumber}"/>
												<p><fmt:message bundle="${storeText}" key="PRODUCT_ERROR" /></p>
											</div>
											<div class="price" id="WishListResultDisplay_noCatentry_div_4_<c:out value='${status.count}'/>">
											</div>
											<div class="button" id="WishListResultDisplay_noCatentry_div_5_<c:out value='${status.count}'/>">
												<div class="multiple_buttons" id="WishListResultDisplay_noCatentry_div_6_<c:out value='${status.count}'/>"> &nbsp;</div>
												<div class="multiple_buttons" id="WishListResultDisplay_noCatentry_div_7_<c:out value='${status.count}'/>">
													<c:if test="${!sharedWishList}">
														<div class="deleteLink"><a class="bopis_link" href="javaScript:MultipleWishLists.removeItem('<c:out value='${wishlistItem.giftListItemID}'/>')" id="WishListResultDisplay_noCatentry_div_8_<c:out value='${status.count}'/>"><fmt:message bundle="${storeText}" key="WISHLIST_REMOVE" /></a></div>
													</c:if>
												</div>
											</div>
										</div>
									</div>
								</c:when>
								<c:when test="${pageView == 'detailed'}">
									<div class="image" id="WishListResultDisplay_noCatentry_td_3_<c:out value='${status.count}'/>">
										<div id="WishListResultDisplay_noCatentry_div_9_<c:out value='${status.count}'/>" class="itemhoverdetailed">
											<img src="<c:out value='${jspStoreImgDir}' />images/NoImageIcon_sm.jpg" alt="<fmt:message bundle="${storeText}" key="No_Image" />" border="0" width="70" height="70"/>
										</div>
									</div>
									<div class="information" id="WishListResultDisplay_noCatentry_td_4_<c:out value='${status.count}'/>">
										<h3><c:out value="${wishlistItem.partNumber}"/></h3>
										<p><fmt:message bundle="${storeText}" key="PRODUCT_ERROR" /></p>
									</div>
									<div class="price" id="WishListResultDisplay_noCatentry_td_5_<c:out value='${status.count}'/>">
									</div>
									<div class="add_to_cart" id="WishListResultDisplay_noCatentry_td_6_<c:out value='${status.count}'/>">
										<c:if test="${!sharedWishList}">
											<div class="deleteLink"><a class="bopis_link" href="javaScript:MultipleWishLists.removeItem('<c:out value='${wishlistItem.giftListItemID}'/>')" id="WishListResultDisplay_noCatentry_div_10_<c:out value='${status.count}'/>"><fmt:message bundle="${storeText}" key="WISHLIST_REMOVE" /></a></div>
										</c:if>
									</div>
								</c:when>
							</c:choose>
							<c:if test="${rowItemCount%numberProductsPerRow == 0}">
								</div>
								
								<c:set var="rowItemCount" value="0"/>
								<c:set var="rowBeginIndex" value="${status.index+1}"/>
							</c:if>
						</c:otherwise>
					</c:choose>
					<c:remove var="catEntry"/>
					<c:remove var="itemError"/>
				</c:forEach>
				
			
				<c:if test="${rowItemCount != 0 && pageView !='detailed'}">
					</div>
				</c:if>
				<div class="item_container_divider">
					<div class="divider_line" colspan="4" id="WC_WishListResultDisplay_td_1a"></div>
				</div>
			</div>
					
			<div class="clear_both"></div>
		</c:otherwise>
	</c:choose>
</div>

<%-- display total number of pages if wish list is not empty and when externalID specified is correct, or guestAccessKey is correct--%>
<c:if test="${!emailError && bHasWishList}">
			<div class="top_pagination">
				<span class="subheader_text">
					<%-- for classic wish list, startIndex begins with 1, but for SOA wish list, startIndex begins with 0 --%>
					
					<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_DISPLAYING" > 
						<fmt:param><fmt:formatNumber value="${startIndex + 1}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${endIndex}"/></fmt:param>
						<fmt:param><fmt:formatNumber value="${numEntries}"/></fmt:param>
					</fmt:message>
					
					<c:if test="${totalPages > 1}">
						<span class="paging">
							<c:if test="${currentPage != 0}">
								<c:choose>
									<c:when test="${wishListViaEmail == 'true'}">
										<a href="javaScript:refreshContentURL('<c:out value='${WishListResultDisplayViewPrevURL}'/>');" id="WC_WishListResultDisplay_links_5">
									</c:when>
									<c:otherwise>
										<a href="javaScript:setCurrentId('WC_WishListResultDisplay_links_5'); AccountWishListDisplay.loadContentURL('<c:out value='${WishListResultDisplayViewPrevURL}'/>');" id="WC_WishListResultDisplay_links_5">
									</c:otherwise>
								</c:choose>
							</c:if>
							<img src="<c:out value='${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}' />paging_back.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_LEFT_IMAGE" />" />
							<c:if test="${currentPage != 0}">
								</a>
							</c:if>
							<fmt:message bundle="${storeText}" key="CATEGORY_RESULTS_PAGES_DISPLAYING" > 
								<fmt:param><fmt:formatNumber value="${currentPage + 1}"/></fmt:param>
								<fmt:param><fmt:formatNumber value="${totalPages}"/></fmt:param>
							</fmt:message>
							<c:if test="${currentPage < totalPages-1}">
								<c:choose>
									<c:when test="${wishListViaEmail == 'true'}">
										<a href="javaScript:refreshContentURL('<c:out value='${WishListResultDisplayViewNextURL}'/>');" id="WC_WishListResultDisplay_links_6">
									</c:when>
									<c:otherwise>
										<a href="javaScript:setCurrentId('WC_WishListResultDisplay_links_6');AccountWishListDisplay.loadContentURL('<c:out value='${WishListResultDisplayViewNextURL}'/>');" id="WC_WishListResultDisplay_links_6">
									</c:otherwise>
								</c:choose>
							</c:if>
							<img src="<c:out value='${jspStoreImgDir}${env_vfileColor}${vfileColorBIDI}' />paging_next.png" alt="<fmt:message bundle="${storeText}" key="CATEGORY_PAGING_RIGHT_IMAGE" />" />
							<c:if test="${currentPage < totalPages-1}">
								</a>
							</c:if>
						</span>
					</c:if>
				</span>
			</div>
</c:if>		
<input type="hidden" name="controllerURLWishlist" value ="${WishListResultDisplay}" id="controllerURLWishlist"/>
<div class="footer" id="WC_WishListResultDisplay_div_12">
	<div class="left_corner" id="WC_WishListResultDisplay_div_13"></div>
	<div class="left" id="WC_WishListResultDisplay_div_14"></div>
	<div class="right_corner" id="WC_WishListResultDisplay_div_15"></div>
</div>
<!-- END WishListResultDisplay.jsp -->
