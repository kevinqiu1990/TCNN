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
<!-- Generates a Forrest document from a Lucene search result. -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:search="http://apache.org/cocoon/search/1.0" 
  xmlns:xlink="http://www.w3.org/1999/xlink"
  version="1.0">
<!-- The HTTP request parameter to pass in the query string -->
  <xsl:param name="query-string-param" select="'queryString'"/>
<!-- The HTTP request parameter to pass in the page length (number
  of hits displayed per search result page) -->
  <xsl:param name="page-length-param" select="'pageLength'"/>
<!-- The HTTP request parameter to pass in the start index (the
  index of the first item in a hit list that is actually being
  displayed) -->
  <xsl:param name="start-index-param" select="'startIndex'"/>
<!-- The URL of the search page. -->
  <xsl:param name="search-url" select="'lucene-search.html'"/>
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="search:results">
    <document>
      <header>
<!-- FIXME: i18n stuff here -->
        <title>Search Results</title>
      </header>
      <body>
        <xsl:if test="not(search:hits)">
          <note>
<xsl:text>Your search for </xsl:text>
            <code>
            <xsl:value-of select="@query-string"/>
            </code>
<xsl:text> returned no results. Check that you spelled your
            search terms correctly, or choose more generic terms to
            broaden your search.</xsl:text>
          </note>
        </xsl:if>
        <xsl:apply-templates/>
      </body>
    </document>
  </xsl:template>
  <xsl:template match="search:hits">
    <xsl:apply-templates/>
  </xsl:template>
<!-- Displays the search hit as a paragraph. -->
  <xsl:template match="search:hit">
    <p>
<!-- FIXME: Score should be displayed in some graphical manner
      (stars, color codes, whatever) -->
      <strong>
<xsl:text>Score </xsl:text>
      <xsl:value-of select="@score"/>
<xsl:text>: </xsl:text>
      </strong>
      <xsl:apply-templates select="." mode="create-link"/>
      <xsl:apply-templates select="search:field[@name= 'author']"/>
      <xsl:apply-templates select="search:field[@name= 'abstract']"/>
    </p>
  </xsl:template>
<!-- Renders the url attribute of a search hit as a Forrest
  link. -->
  <xsl:template match="search:hit" mode="create-link">
    <xsl:variable name="mangledlink">
      <xsl:value-of select="concat(substring-before(@uri, '.'), '.html')"/>
<!--
      <xsl:choose>
        <xsl:when test="substring(@uri,string-length(@uri)-3) = '.xml'">
          <xsl:text>site:</xsl:text>
          <xsl:value-of select="substring(@uri, 1, string-length(@uri)-4)"/>
        </xsl:when>
        <xsl:when test="substring(@uri,string-length(@uri)-5) = '.ehtml'">
          <xsl:text>site:</xsl:text>
          <xsl:value-of select="substring(@uri, 1, string-length(@uri)-6)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@uri"/>
        </xsl:otherwise>
      </xsl:choose>
      -->
    </xsl:variable>
    <xsl:variable name="linktext">
      <xsl:choose>
<!-- If a field for the document title exists, use its
        contents as the link text. -->
        <xsl:when test="search:field[@name = 'title']">
          <xsl:value-of select="search:field[@name = 'title']"/>
        </xsl:when>
<!-- Otherwise, use the mangled link as determined above -->
        <xsl:otherwise>
          <xsl:value-of select="$mangledlink"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
<!-- Create the link --><link>
    <xsl:attribute name="href">
      <xsl:value-of select="$mangledlink"/>
    </xsl:attribute>
    <xsl:value-of select="$linktext"/></link>
  </xsl:template>
<!-- If a document's author is known, displays the author's name in
  parentheses -->
  <xsl:template match="search:field[@name = 'author' and text() != '']">
<xsl:text> (</xsl:text>
    <xsl:apply-templates/>
<xsl:text>) </xsl:text>
  </xsl:template>
<!-- If a abstract exists for a document, displays it with emphasis -->
  <xsl:template match="search:field[@name = 'abstract' and text() != '']"><em>
    <xsl:apply-templates/></em>
  </xsl:template>
<!-- Creates a document footer, to be used for navigation -->
  <xsl:template match="search:navigation">
    <xsl:variable name="startindex" select="../@start-index"/>
    <xsl:variable name="hitcount" select="count(../search:hits/search:hit)"/>
    <xsl:variable name="endindex" select="$startindex + $hitcount - 1"/>
    <xsl:variable name="totalhitcount" select="@total-count"/>
    <footer>
      <xsl:if test="$totalhitcount != 0">
        <xsl:choose>
          <xsl:when test="../@page-length = 1">
<xsl:text>Displaying hit </xsl:text>
<!-- A zero-based index might be confusing to users, so we
            simply add 1 to the real index values -->
            <xsl:value-of select="$startindex + 1"/>
          </xsl:when>
          <xsl:otherwise>
<xsl:text>Displaying hits </xsl:text>
<!-- A zero-based index might be confusing to users, so we
            simply add 1 to the real index values -->
            <xsl:value-of select="$startindex + 1"/>
<xsl:text> to </xsl:text>
            <xsl:value-of select="$endindex + 1"/>
          </xsl:otherwise>
        </xsl:choose>
<xsl:text> of </xsl:text>
        <xsl:value-of select="$totalhitcount"/>
<xsl:text> total hits for query </xsl:text><code>
        <xsl:value-of select="../@query-string"/></code>
<xsl:text>.</xsl:text>
<!-- Display "previous page" link, if appropriate -->
        <xsl:if test="@has-previous = 'true'">
<xsl:text>&#160;</xsl:text>
          <xsl:call-template name="nav-link">
            <xsl:with-param name="linktext">Previous page</xsl:with-param>
            <xsl:with-param name="start-index" select="@previous-index"/>
          </xsl:call-template>
        </xsl:if>
<!-- Display "next page" link, if appropriate -->
        <xsl:if test="@has-next = 'true'">
<xsl:text>&#160;</xsl:text>
          <xsl:call-template name="nav-link">
            <xsl:with-param name="linktext">Next page</xsl:with-param>
            <xsl:with-param name="startindex" select="@next-index"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:if>
    </footer>
  </xsl:template>
<!-- Convenience template, constructs a link to jump to a specific
  item in the hit list. -->
  <xsl:template name="nav-link">
    <xsl:param name="context" select="."/>
    <xsl:param name="linktext"/>
    <xsl:param name="startindex"/><link>
    <xsl:attribute name="href">
      <xsl:value-of select="$search-url"/>
<xsl:text>?</xsl:text>
      <xsl:value-of select="$query-string-param"/>
<xsl:text>=</xsl:text>
      <xsl:value-of select="$context/../@query-string"/>
<xsl:text>&amp;</xsl:text>
      <xsl:value-of select="$start-index-param"/>
<xsl:text>=</xsl:text>
      <xsl:value-of select="$startindex"/>
<xsl:text>&amp;</xsl:text>
      <xsl:value-of select="$page-length-param"/>
<xsl:text>=</xsl:text>
      <xsl:value-of select="$context/../@page-length"/>
    </xsl:attribute>
    <xsl:value-of select="$linktext"/></link>
  </xsl:template>
</xsl:stylesheet>
