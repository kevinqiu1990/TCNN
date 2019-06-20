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
This stylesheet selects a set of nodes with @tab equal to that of a node whose @href matches an input parameter.  Could
probably be done with 2 lines of XQuery.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:l="http://apache.org/forrest/linkmap/1.0">
  <xsl:import href="pathutils.xsl"/>
  <xsl:param name="path" select="'index'"/>
  <xsl:variable name="tab">
    <xsl:variable name="path-noext">
      <xsl:call-template name="path-noext">
        <xsl:with-param name="path" select="$path"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="string(//*[starts-with(@href, $path-noext)]/@tab)"/>
  </xsl:variable>
  <xsl:template match="/*">
<!--
    <xsl:message>## path is <xsl:value-of select="$path"/></xsl:message>
    <xsl:message>## tab is <xsl:value-of select="$tab"/></xsl:message>
    -->
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
<!-- Ignore external references, as they are only useful for link mapping, not
  creating menus -->
  <xsl:template match="l:external-refs"/>
  <xsl:template match="*">
    <xsl:choose>
<!-- Take out the first test to not duplicate other tabs' content in first menu -->
      <xsl:when test="$tab='' or @tab=$tab">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
