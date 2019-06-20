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
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean-el" prefix="bean-el" %>
<html:html locale="true">
    <head>
        <meta name="robots" content="index,nofollow">
    </head>
    <body bgcolor="#FFFFFF"/>
    <table border="0" width="100%" cellpadding="0" cellspacing="0">
    <tr><td>
        <html:link target="_top" page="/"><bean:message key="log.back"/></html:link>
    </td><td align="center">
        <bean-el:message key="log.refresh" arg0="${refreshrate}"/>
    </td><td align="right">
        <html:link target="body" page="/viewlog_body.do" paramId="project" paramName="project"><bean:message key="log.force.refresh"/></html:link>
    </td></tr>
    </table>
    </body>
</html:html>