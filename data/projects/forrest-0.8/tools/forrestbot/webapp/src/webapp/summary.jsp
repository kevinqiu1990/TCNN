<%--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
--%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<%@ page import="org.apache.forrest.forrestbot.webapp.dto.*" %>


<bean:message key="summary.current.time"/> <fmt:formatDate value="${serverTime}" type="BOTH"/>
<table>
<tr>
	<th><bean:message key="summary.site"/></th>
	<th><bean:message key="summary.status"/></th>
	<th><bean:message key="summary.log"/></th>
	<th><bean:message key="summary.date"/></th>
	<c:if test="${auth}">
		<th><bean:message key="summary.execute"/></th>
	</c:if>
</tr>
<logic:iterate id="project" name="projects" type="ProjectDTO">
	<tr>
		<td>
			<a href="<c:out value="${project.url}"/>"><c:out value="${project.name}"/></a>
		</td>
        <c:choose>
        	<c:when test="${project.status == Constants.STATUS_FAILED}">
				<td bgcolor='red'>
					<bean:message key="summary.status.failed"/>
				</td>
			</c:when>
			<c:when test="${project.status == Constants.STATUS_SUCCESS}">
				<td>
					<bean:message key="summary.status.success"/>
				</td>
			</c:when>
			<c:when test="${project.status == Constants.STATUS_RUNNING}">
				<td bgcolor='green'>
					<bean:message key="summary.status.running"/>
				</td>
			</c:when>
			<c:otherwise>
				<td bgcolor='yellow'>
					<bean:message key="summary.status.unknown"/>
				</td>  
			</c:otherwise>
		</c:choose>
		<td>
			<c:if test="${project.logged}">
				<html:link page="/viewlog.do" paramId="project" paramName="project" paramProperty="name"><bean:message key="summary.log"/></html:link>
			</c:if>
		</td>
		<td>
			<c:if test="${project.lastBuilt != null}">
				<fmt:formatDate value="${project.lastBuilt}" type="BOTH"/>
			</c:if>
		</td>
		<c:if test="${auth}">
			<td>
				<html:form action="/execute">
					<input type="hidden" name="project" value="<c:out value="${project.name}"/>"/>
					<c:if test="${project.buildable}">
						<html:submit property="build">
			                <bean:message key="summary.execute.build"/>
			            </html:submit>
			        </c:if>
					<c:if test="${project.deployable}">
						<html:submit property="deploy">
			                <bean:message key="summary.execute.deploy"/>
			            </html:submit>
			        </c:if>
			    </html:form>
    	    </td>
	    </c:if>
	</tr>
</logic:iterate>
</table>