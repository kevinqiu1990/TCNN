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
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<html:html locale="true">
    <head>
        <meta name="robots" content="index,nofollow">
        <title><tiles:insert attribute="title"/></title>
    </head>
    <body bgcolor="#FFFFFF"/>

    <tiles:insert attribute="header"/>
	<h2>
		<tiles:insert attribute="title"/>
	</h2>
    <tiles:insert attribute="welcome"/>
    <tiles:insert attribute="welcome-local"/>
    <tiles:insert attribute="login"/>
    <tiles:insert attribute="body-content"/>
    <tiles:insert attribute="footer"/>

    </body>
</html:html>