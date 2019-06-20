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

..which site2xhtml.xsl then combines with HTML from the index (book2menu.xsl)
and tabs (tab2menu.xsl) to generate the final HTML.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../../common/xslt/html/document-to-html.xsl"/>
  <xsl:template match="document">
    <div class="content">
      <xsl:if test="normalize-space(header/title)!=''">
        <table class="title">
          <tr>
            <td valign="middle">
              <h1>
                <xsl:value-of select="header/title"/>
              </h1>
            </td>
            <div id="skinconf-printlink"/>
            <div id="skinconf-xmllink"/>
            <div id="skinconf-podlink"/>
            <div id="skinconf-txtlink"/>
            <div id="skinconf-pdflink"/>
          </tr>
        </table>
      </xsl:if>
      <xsl:if test="normalize-space(header/subtitle)!=''">
        <h3>
          <xsl:value-of select="header/subtitle"/>
        </h3>
      </xsl:if>
      <xsl:if test="header/abstract">
        <div class="abstract">
          <xsl:value-of select="header/abstract"/>
        </div>
      </xsl:if>
      <xsl:apply-templates select="body"/>
      <xsl:if test="header/authors">
        <p align="right">
          <font size="-2">
            <xsl:for-each select="header/authors/person">
              <xsl:choose>
                <xsl:when test="position()=1">by&#160;</xsl:when>
                <xsl:otherwise>,&#160;</xsl:otherwise>
              </xsl:choose>
              <xsl:value-of select="@name"/>
            </xsl:for-each>
          </font>
        </p>
      </xsl:if>
    </div>
  </xsl:template>
  <xsl:template match="body">
    <div id="skinconf-toc-page"/>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="@id">
    <xsl:apply-imports/>
  </xsl:template>
  <xsl:template match="section"><a name="{generate-id()}"/>
    <xsl:apply-templates select="@id"/>
    <xsl:variable name = "level" select = "count(ancestor::section)+1" />
    <xsl:choose>
      <xsl:when test="$level=1">
        <div class="skinconf-heading-{$level}">
          <h1>
            <xsl:value-of select="title"/>
          </h1>
        </div>
        <div class="section">
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:when test="$level=2">
        <div class="skinconf-heading-{$level}">
          <h1>
            <xsl:value-of select="title"/>
          </h1>
        </div>
        <xsl:apply-templates select="*[not(self::title)]"/>
      </xsl:when>
<!-- If a faq, answer sections will be level 3 (1=Q/A, 2=part) -->
      <xsl:when test="$level=3 and $notoc='true'">
        <h4 class="faq">
          <xsl:value-of select="title"/>
        </h4>
        <div align="right"><a href="#{@id}-menu">^</a>
        </div>
        <div style="margin-left: 15px">
          <xsl:apply-templates select="*[not(self::title)]"/>
        </div>
      </xsl:when>
      <xsl:when test="$level=3">
        <h4>
          <xsl:value-of select="title"/>
        </h4>
        <xsl:apply-templates select="*[not(self::title)]"/>
      </xsl:when>
      <xsl:otherwise>
        <h5>
          <xsl:value-of select="title"/>
        </h5>
        <xsl:apply-templates select="*[not(self::title)]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="fixme | note | warning">
    <xsl:apply-imports/>
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
    <xsl:apply-imports/>
  </xsl:template>
  <xsl:template match="title">
<!-- do not show title elements, they are already in other places-->
  </xsl:template>
</xsl:stylesheet>
