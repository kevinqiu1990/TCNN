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
Generates a skeleton doc-v20 file for the whole site with CInclude elements where content should be pulled in.
Input is expected to be in standard book.xml format. @hrefs should be normalized, although unnormalized hrefs can be
handled by uncommenting the relevant section.

See http://127.0.0.1:8888/book-wholesite.html to see what the book xml looks like
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cinclude="http://apache.org/cocoon/include/1.0">
  <xsl:param name="title" select="''"/>
  <xsl:param name="ignore" select="'jira-manual'"/>
  <xsl:template match="book">
    <document>
      <header>
        <title><xsl:value-of select="$title"/></title>
      </header>
      <body>
        <xsl:apply-templates select="menu|menu-item"/>
      </body>
    </document>
  </xsl:template>
  <xsl:template match="menu[contains(@href, ':')]"/>
<!-- Ignore all non-local links -->
  <xsl:template match="menu[contains(@href, '/')]"/>
<!-- Ignore directories -->
  <xsl:template match="menu[not(contains(@href, '.'))]">
    <section>
      <title><xsl:value-of select="@label"/></title>
      <xsl:apply-templates/>
    </section>
  </xsl:template>
  <xsl:template match="menu-item[@type='hidden']"/>
<!-- Ignore hidden items -->
  <xsl:template match="menu-item[contains(@href, '#')]"/>
<!-- Ignore #frag-id items -->
  <xsl:template match="menu-item[contains(@href, ':')]"/>
<!-- Ignore all non-local links -->
  <xsl:template match="menu-item[starts-with(@href, $ignore)]"/>
<!-- Ignore the aggregated pages -->
<!-- Recursive template to collate @href's -->
  <xsl:template name="absolute-href">
    <xsl:param name="node"/>
<!-- Only append ancestor hrefs if we're not a http(s): URL -->
    <xsl:if test="not(starts-with($node/@href, 'http:') or starts-with($node/@href, 'https:'))">
      <xsl:if test="$node/../@href">
        <xsl:call-template name="absolute-href">
          <xsl:with-param name="node" select="$node/.."/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
    <xsl:value-of select="$node/@href"/>
  </xsl:template>
<!-- normally directories are menus and files are menu-items,
      but if 'menu' contained a '.' (then it didn't match the main 'menu' template above),
      and it's probably a file (because the children menu-items are #fragments)
      so we match now like a menu-item
  -->
  <xsl:template match="menu-item|menu">
    <section class="page">
      <xsl:attribute name="id">
<xsl:text></xsl:text>
        <xsl:value-of select="@href"/>
      </xsl:attribute>
      <cinclude:include>
        <xsl:attribute name="src">
<xsl:text>cocoon://</xsl:text>
<!--  This isn't necessary if reading source from cocoon://book-*.xml
          <xsl:call-template name="absolute-href">
            <xsl:with-param name="node" select=".."/>
          </xsl:call-template>
          -->
          <xsl:value-of select="concat(substring-before(@href, '.'), '.xml')"/>
        </xsl:attribute>
      </cinclude:include>
    </section>
  </xsl:template>
</xsl:stylesheet>
