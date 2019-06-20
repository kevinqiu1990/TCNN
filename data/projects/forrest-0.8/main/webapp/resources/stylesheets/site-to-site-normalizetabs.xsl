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
Stylesheet to inherit @tab attributes if a node doesn't have one itself. Eg, given as input:

<site href="">
  <index href="index.html"/>
  <community href="community/" tab="community">
    <faq href="faq.html">
      <how_can_I_help href="#help"/>
    </faq>
    <howto tab="howto">
      <cvs href="cvs-howto.html"/>
    </howto>
  </community>
</site>

Output would be:

<site href="">
  <index href="index.html"/>
  <community tab="community" href="community/">
    <faq tab="community" href="faq.html">
      <how_can_I_help tab="community" href="#help"/>
    </faq>
    <howto tab="howto">
      <cvs tab="howto" href="cvs-howto.html"/>
    </howto>
  </community>
</site>

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:l="http://apache.org/forrest/linkmap/1.0">
<!-- Return a value for a node's @tab, either using an existing @tab or the first ancestor's -->
  <xsl:template name="gettab">
    <xsl:param name="node"/>
    <xsl:choose>
      <xsl:when test="$node/@tab">
        <xsl:value-of select="$node/@tab"/>
      </xsl:when>
      <xsl:when test="$node/..">
        <xsl:call-template name="gettab">
          <xsl:with-param name="node" select="$node/.."/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="//*">
    <xsl:variable name="newtab">
      <xsl:call-template name="gettab">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:copy>
<!-- <xsl:if test="not(normalize-space($newtab)='')"> -->
      <xsl:attribute name="tab">
        <xsl:value-of select="$newtab"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
