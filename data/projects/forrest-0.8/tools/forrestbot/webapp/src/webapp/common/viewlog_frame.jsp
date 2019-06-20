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
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<html:html locale="true">
    <head>
        <meta name="robots" content="index,nofollow">
        <title><tiles:insert attribute="title"/> - <c:out value="${project}"/></title>
    </head>
    <frameset rows="40,*">
        <html:frame frameName="header" page="/viewlog_header.do" paramId="project" paramName="project"/>
        <html:frame frameName="body" page="/viewlog_body.do" paramId="project" paramName="project"/>
    </frameset>
    <noframes>
      <html:link page="/viewlog_header.do" paramId="project" paramName="project">header</html:link>
      <html:link page="/viewlog_body.do" paramId="project" paramName="project">body</html:link>
    </noframes>
  </html:html>