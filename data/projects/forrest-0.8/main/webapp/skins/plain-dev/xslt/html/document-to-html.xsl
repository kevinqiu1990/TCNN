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
This stylesheet contains the majority of templates for converting documentv11
to HTML.  It renders XML as HTML in this form:

  <div class="content">
   ...
  </div>

..which site-to-xhtml.xsl then combines with HTML from the index (book-to-menu.xsl)
and tabs (tab-to-menu.xsl) to generate the final HTML.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../../common/xslt/html/document-to-html.xsl"/>
  <xsl:template match="document">
    <html>
      <head>
        <xsl:if test="normalize-space(header/title)!=''">
          <title><xsl:value-of select="header/title"/></title>
        </xsl:if><link rel     = "schema.DC"
               href    = "http://purl.org/DC/elements/1.0/"/>
        <xsl:if test="normalize-space(header/subtitle)!=''">
          <meta name    = "DC.Subject"      content = "{header/subtitle}"/>
        </xsl:if>
        <xsl:if test="header/authors">
          <xsl:for-each select="header/authors/person">
            <meta name    = "DC.Creator"      content = "{@name}"/>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="header/abstract">
          <meta name    = "DC.Description"  content = "{header/abstract}"/>
        </xsl:if>
      </head>
      <body>
<!-- include ssi top -->
        <xsl:apply-templates select="body"/>
<!-- include ssi bottom -->
      </body>
    </html>
  </xsl:template>
  <xsl:template match="body">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="section">
    <xsl:variable name = "level" select = "count(ancestor::section)+1" />
    <xsl:choose>
      <xsl:when test="$level=1">
        <h1>
          <xsl:value-of select="title"/>
        </h1>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$level=2">
        <h2>
          <xsl:value-of select="title"/>
        </h2>
        <xsl:apply-templates select="*[not(self::title)]"/>
      </xsl:when>
<!-- If a faq, answer sections will be level 3 (1=Q/A, 2=part) -->
      <xsl:when test="$level=3 and $notoc='true'">
        <h3 class="faq">
          <xsl:value-of select="title"/>
        </h3>
        <xsl:apply-templates select="*[not(self::title)]"/>
      </xsl:when>
      <xsl:when test="$level=3">
        <h3>
          <xsl:value-of select="title"/>
        </h3>
        <xsl:apply-templates select="*[not(self::title)]"/>
      </xsl:when>
      <xsl:otherwise>
        <h4>
          <xsl:value-of select="title"/>
        </h4>
        <xsl:apply-templates select="*[not(self::title)]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="fixme">
    <div class="fixme">
      <xsl:value-of select="@author"/>:
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="note">
    <div class="note">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="warning">
    <div class="warning">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="link">
    <xsl:apply-imports/>
  </xsl:template>
  <xsl:template match="jump">
    <xsl:apply-imports/>
  </xsl:template>
  <xsl:template match="fork">
    <xsl:apply-imports/>
  </xsl:template>
  <xsl:template match="p[@xml:space='preserve']">
    <xsl:apply-imports/>
  </xsl:template>
  <xsl:template match="source">
    <xsl:apply-imports/>
  </xsl:template>
  <xsl:template match="anchor">
    <xsl:apply-imports/>
  </xsl:template>
  <xsl:template match="icon">
    <xsl:apply-imports/>
  </xsl:template>
  <xsl:template match="code">
    <xsl:apply-imports/>
  </xsl:template>
  <xsl:template match="figure">
    <xsl:apply-imports/>
  </xsl:template>
  <xsl:template match="table">
    <table>
      <xsl:apply-templates/>
    </table>
  </xsl:template>
  <xsl:template match="caption">
    <xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match="title">
<!-- do not show title elements, they are already in other places-->
  </xsl:template>
</xsl:stylesheet>
