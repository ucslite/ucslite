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

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/coremetrics"  prefix="cm" %>
<%@ taglib uri="flow.tld" prefix="flow" %>
<%@include file="../../Common/EnvironmentSetup.jspf" %>

<%@ page trimDirectiveWhitespaces="true" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Vector"%>
<%@page import="org.apache.solr.client.solrj.SolrQuery"%>
<%@page import="org.apache.solr.client.solrj.impl.HttpSolrServer"%>
<%@page import="org.apache.solr.client.solrj.SolrServer"%>
<%@page import="org.apache.solr.client.solrj.request.QueryRequest"%>
<%@page import="org.apache.solr.client.solrj.response.TermsResponse.Term"%>
<%@page import="org.apache.solr.common.params.TermsParams"%>
<%@page import="org.apache.solr.client.solrj.SolrRequest"%>
<%@page import="com.ibm.commerce.foundation.internal.server.services.search.config.solr.SolrSearchConfigurationRegistry"%>


<% 
		final String PARAM_TERM = "searchTerm";
		final String PARAM_COUNT = "count";
		final String TERM_QUERY_TYPE = "/terms";
		final String TERMS_FIELD = "spellCheck";
		final String INDEX_NAME = "CatalogEntry";
		final String STORE_ID = "storeId";
		final String LANGUAGE_ID = "langId";
		int limit = 12; // default limit

		String term = request.getParameter(PARAM_TERM);
		Integer storeId = Integer.parseInt(request.getParameter(STORE_ID));
		Integer langId = Integer.parseInt(request.getParameter(LANGUAGE_ID));
		if (term != null) {
			int termLength = term.length();
			if (term.length() > 0) {
				String countParameter = request.getParameter(PARAM_COUNT);
				if (countParameter != null && countParameter.length() > 0) {
					limit = Integer.parseInt(countParameter);
				}
				SolrSearchConfigurationRegistry registry = SolrSearchConfigurationRegistry.getInstance();
				String coreName = registry.getCoreName(storeId, INDEX_NAME, langId);
				if (coreName == null || coreName.length() == 0) {
					return;
				}
				SolrServer server = registry.getServer(coreName);
				if (server != null) {
					String lowerCaseTerm = term.toLowerCase();
					SolrQuery query = new SolrQuery();
					query.setQueryType(TERM_QUERY_TYPE);
					query.setTerms(true);
					query.setTermsLimit(limit);
					query.setTermsSortString(TermsParams.TERMS_SORT_COUNT);
					query.setTermsPrefix(lowerCaseTerm);
					query.addTermsField(TERMS_FIELD);
					QueryRequest termReq = new QueryRequest(query);
					termReq.setMethod(SolrRequest.METHOD.POST);
					List<Term> terms = termReq.process(server)
							.getTermsResponse().getTerms(TERMS_FIELD);
					
					int total = terms.size();
					if(total > 0) {
						out.print("{\"terms\":[");
						// display keyword matches from the server
						StringBuilder termsBuilder = new StringBuilder();
						Term aResponseTerm = null;
						for (int i = 0; i < total; i++) {
							aResponseTerm = terms.get(i);
							termsBuilder.append("{\"");
							termsBuilder.append(aResponseTerm.getTerm().toLowerCase());
							termsBuilder.append("\":");
							termsBuilder.append("\"");
							termsBuilder.append(aResponseTerm.getFrequency());
							termsBuilder.append("\"}");
							termsBuilder.append(",");
						}
						// remove the last comma
						out.print(termsBuilder.subSequence(0, termsBuilder.length() - 1));
						out.print("]}");
					}
				}
			}
		}
%>