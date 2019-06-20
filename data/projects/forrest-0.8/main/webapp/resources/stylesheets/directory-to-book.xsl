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
<!-- Converts the output of the DirectoryGenerator to Forrest's book.xml
format.  Typically this would be used to define a book.xml pipeline for a
specific page.  Eg, in menu.xmap, define the DirectoryGenerator:

<map:generators default="file">
  <map:generator name="directory" src="org.apache.cocoon.generation.DirectoryGenerator" />
</map:generators>

And then define the book.xml matcher for a directory that you want to
automatically generate a menu for (here wiki/):

<map:match pattern="wiki/**book-*">
  <map:generate type="directory" src="content/xdocs/wiki/{1}">
    <map:parameter name="dateFormat" value="yyyy-MM-dd hh:mm" />
    <map:parameter name="depth" value="5" />
    <map:parameter name="exclude" value="[.][^x[^m][^l]|~$|^my-images$" />
  </map:generate>
  <map:transform src="resources/stylesheets/directory-to-book.xsl" />
  <map:serialize type="xml"/>
</map:match>

Alternatively, the XPathDirectoryGenerator can be used to include some page
metadata (label, meta attributes) in the XML, and the directory listing can
then be sorted by an XPath expression specified in the sitemap:

<map:match pattern="(.*)(dir1|dir2|dir3)/book-(.*)" type="regexp">
   <map:generate label="debug" src="content/xdocs/{1}{2}" 
type="xpathdirectory">
      <map:parameter name="depth" value="2"/>
      <map:parameter name="xpath" value="/document/header/meta | 
/document/header/title"/>
   </map:generate>
   <map:transform src="resources/stylesheets/directory-to-book.xsl">
      <map:parameter name="sort-order" value="descending"/>
      <map:parameter name="sort-select" value="dir:xpath/meta[@name='date']"/>
   </map:transform>
   <map:serialize type="xml"/>
</map:match>
-->
<xsl:stylesheet exclude-result-prefixes="dir" version="1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dyn="http://exslt.org/dynamic">
  <xsl:import href="../../skins/common/xslt/html/pathutils.xsl"/>
  <xsl:output doctype-public="-//APACHE//DTD Cocoon Documentation Book V1.0//EN" doctype-system="book-cocoon-v10.dtd"/>
  <xsl:param name="served-extension" select="'html'"/>
  <xsl:param name="sort-order" select="'ascending'"/>
  <xsl:param name="sort-case-order" select="'upper-first'"/>
  <xsl:param name="sort-select" select="'.'"/>
  <xsl:template match="/">
    <book copyright="" software="" title="">
<!--
      <menu label="Aggregates">
        <menu-item label="Combined content" href="combined.html"/>
      </menu>
      -->
      <xsl:apply-templates/>
    </book>
  </xsl:template>
  <xsl:template match="dir:directory">
    <menu label="{translate(@name,'-_',' ')}">
      <xsl:apply-templates select="dir:file">
        <xsl:sort case-order="{$sort-case-order}" order="{$sort-order}" select="dyn:evaluate($sort-select)"/>
      </xsl:apply-templates>
    </menu>
    <xsl:apply-templates select="dir:directory [descendant::dir:file]"/>
  </xsl:template>
  <xsl:template match="dir:file">
<!-- name without extension -->
    <xsl:variable name="corename">
      <xsl:call-template name="path-noext">
        <xsl:with-param name="path" select="@name"/>
      </xsl:call-template>
    </xsl:variable>
<!-- indirection to allow get-label overriding -->
    <xsl:variable name="label">
      <xsl:call-template name="get-label">
        <xsl:with-param name="corename" select="$corename"/>
      </xsl:call-template>
    </xsl:variable>
<!-- empty label means side menu item inexistence -->
    <xsl:if test="$label != ''">
      <menu-item label="{$label}">
        <xsl:attribute name="href">
          <xsl:variable name="path"/>
          <xsl:for-each select="ancestor::dir:directory [not (position()=last())]">
            <xsl:variable name="path" select="concat($path, @name, '/')"/>
            <xsl:value-of select="$path"/>
          </xsl:for-each>
<!-- indirection to allow get-href overriding -->
          <xsl:call-template name="get-href">
            <xsl:with-param name="corename" select="$corename"/>
          </xsl:call-template>
        </xsl:attribute>
      </menu-item>
    </xsl:if>
  </xsl:template>
<!-- override this to your needs. For example, see xpathdirectory-to-book.xsl -->
  <xsl:template name="get-label">
    <xsl:param name="corename"/>
    <xsl:value-of select="translate($corename,'-_',' ')"/>
  </xsl:template>
  <xsl:template name="get-href">
    <xsl:param name="corename"/>
    <xsl:value-of select="concat($corename, '.', $served-extension)"/>
  </xsl:template>
</xsl:stylesheet>
