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

<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="org.apache.log4j.Logger" %>

<%
Logger log = Logger.getLogger(request.getRequestURI());
%>

<html:errors/>

<pre>
<%--
I don't know of a way to put a bean variable into a jsp:include page attribute
nor how to use tiles to include an absolute file
so we include it the old fashioned way
--%>
<%
String logfile = (String)request.getAttribute("logfile");
if (logfile != null)
{
	log.debug(logfile);
	BufferedReader in = new BufferedReader(new FileReader(logfile));
	String line;
	while ((line = in.readLine()) != null) {
		out.println(line);
	}
	in.close();
}
%>
</pre>
