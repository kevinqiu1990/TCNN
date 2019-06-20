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
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0"
  xmlns:str="http://www.ora.com/XSLTCookbook/namespaces/strings" 
  exclude-result-prefixes="cinclude">
  <xsl:include href="../external/str.find-last.xslt"/>
  <xsl:key name="node-id" match="*" use="@id"/>
<!-- If we encounter a section with an @id, make that @id globally unique by
  prefixing the id of the current document -->
  <xsl:template match="section/document//@id">
    <xsl:attribute name="id">
      <xsl:value-of select="concat(ancestor::section/@id, '#', .)"/>
    </xsl:attribute>
  </xsl:template>
<!-- Make #fragment-id references inside each page globally unique -->
  <xsl:template match="section/document//link/@href[starts-with(., '#')]">
    <xsl:attribute name="href">
      <xsl:value-of select="concat('#', ancestor::section/@id, .)"/>
    </xsl:attribute>
  </xsl:template>
<!-- Translate relative links to '#link' -->
  <xsl:template match="section/document//link/@href[not(starts-with(., 'http:') or starts-with(., 'https:'))]">
    <xsl:attribute name="href">
<xsl:text>#</xsl:text>
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="section/document//figure|img[starts-with(@src, 'my-images')]">
<!-- fix my-images/** links, which break as they are not relative to the site root -->
    <xsl:variable name="page-root">
      <xsl:call-template name="str:substring-before-last">
        <xsl:with-param name="input" select="ancestor::section/@id"/>
        <xsl:with-param name="substr" select="'/'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:copy>
      <xsl:attribute name="src">
        <xsl:value-of select="concat($page-root,'/',@src)"/>
      </xsl:attribute>
    </xsl:copy>
  </xsl:template>
  <xsl:include href="../copyover.xsl"/>
</xsl:stylesheet>
