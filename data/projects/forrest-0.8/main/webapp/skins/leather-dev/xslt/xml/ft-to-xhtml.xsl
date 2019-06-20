<?xml version="1.0"?>
<!--
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
-->
<!--
site-to-xml.xsl is the final stage in XML page production.  It merges HTML from
document-to-html.xsl, tab-to-menu.xsl and book-to-menu.xsl, and adds the site header,
footer, searchbar, css etc.  As input, it takes XML of the form:

<elements>
  <branding/>
  <search/>
  <menu/>
  <content/>
  <siteinfo/>
</elements>

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="fct-bits/fct-bits.xsl"/>
  <xsl:param name="contextPath"/>
<!--+
  |Overall site template
  +-->
  <xsl:template match="/">
    <ft>
      <xsl:apply-templates />
    </ft>
  </xsl:template>
  <xsl:template match="hook">
    <div id="{@name}">
      <xsl:apply-templates />
    </div>
  </xsl:template>
  <xsl:template match="contract">
    <div id="{@name}">
      <xsl:apply-templates />
    </div>
  </xsl:template>
</xsl:stylesheet>
