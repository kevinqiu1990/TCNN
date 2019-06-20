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
<!--+
    | Upgrade skin from previous versions.
    |
    +-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="copyover.xsl"/>
  <xsl:template match="toc/@level">
    <xsl:attribute name="max-depth">
      <xsl:value-of select="."/>
    </xsl:attribute>
    <xsl:apply-templates />
  </xsl:template>
<!--Search Element-->
<!--First ignore these elements to avoid been copied.-->
  <xsl:template match="disable-lucene|searchsite-name|searchsite-domain|comment()"/>
  <xsl:template match="disable-search">
    <xsl:if test=".='false'">
      <xsl:element name="search">
        <xsl:apply-templates select="../disable-lucene" mode="search-enable"/>
        <xsl:apply-templates select="../searchsite-name" mode="search-enable"/>
        <xsl:apply-templates select="../searchsite-domain" mode="search-enable"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <xsl:template match="disable-lucene" mode="search-enable">
    <xsl:if test=".='false'">
      <xsl:attribute name="provider">lucene</xsl:attribute>
    </xsl:if>
  </xsl:template >
  <xsl:template match="searchsite-name" mode="search-enable">
    <xsl:attribute name="name">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="searchsite-domain" mode="search-enable">
    <xsl:attribute name="domain">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template >
</xsl:stylesheet>
