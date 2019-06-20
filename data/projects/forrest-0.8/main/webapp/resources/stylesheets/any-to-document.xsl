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
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method = "xml"  
                version="1.0"
                omit-xml-declaration="no" 
                indent="no"
                encoding="ISO-8859-1"
                doctype-system="document-v11.dtd"
                doctype-public="-//APACHE//DTD Documentation V1.1//EN" />
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="name(child::node())='document'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <document>
          <header>
            <title>Error in conversion</title>
          </header>
          <body>
            <warning>
              This file is not in anakia format, please convert manually.
            </warning>
          </body>
        </document>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="document">
    <document>
      <xsl:apply-templates/>
    </document>
  </xsl:template>
<!-- properties to header -->
  <xsl:template match="properties">
    <header>
      <xsl:apply-templates/>
      <authors>
        <xsl:for-each select = "author">
          <person email="{@email}" name="{.}"/>
        </xsl:for-each>
      </authors>
    </header>
  </xsl:template>
  <xsl:template match="P|p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <xsl:template match="figure">
    <figure alt="{title}" src= "{graphic/@fileref}" />
  </xsl:template>
  <xsl:template match="img">
    <xsl:choose>
      <xsl:when test="name(..)='section'">
        <figure alt="{@alt}" src= "{@src}"/>
      </xsl:when>
      <xsl:otherwise>
        <img alt="{@alt}" src= "{@src}"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="source|blockquote">
    <xsl:choose>
      <xsl:when test="name(..)='p'"><code>
        <xsl:value-of select="." /></code>
      </xsl:when>
      <xsl:otherwise>
        <source>
          <xsl:value-of select="." />
        </source>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
<!-- person to author -->
  <xsl:template match="author"/>
  <xsl:template match="section|s1|s2|s3|s4|s5|s6">
    <section>
      <title><xsl:value-of select="@name" /></title>
      <xsl:apply-templates/>
    </section>
  </xsl:template>
  <xsl:template match="subsection">
    <section>
      <title><xsl:value-of select="@name" /></title>
      <xsl:apply-templates/>
    </section>
  </xsl:template>
<!-- convert a to link -->
  <xsl:template match="a">
    <xsl:if test="@name">
<!-- Attach an id to the current node -->
      <xsl:attribute name="id">
        <xsl:value-of select="translate(@name, ' $', '__')"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:if>
    <xsl:if test="@href"><link href="{@href}">
      <xsl:apply-templates/></link>
    </xsl:if>
  </xsl:template>
  <xsl:template match="@valign | @align"/>
  <xsl:template match="center">
    <xsl:choose>
      <xsl:when test="name(..)='p'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="ol">
    <xsl:choose>
      <xsl:when test="name(..)='p'">
<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
        <ol>
          <xsl:apply-templates/>
        </ol>
<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <ol>
          <xsl:apply-templates/>
        </ol>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="ul">
    <xsl:choose>
      <xsl:when test="name(..)='p'">
<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
        <ul>
          <xsl:apply-templates/>
        </ul>
<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <ul>
          <xsl:apply-templates/>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="b"><strong>
    <xsl:value-of select = "."/></strong>
  </xsl:template>
  <xsl:template match="i"><em>
    <xsl:value-of select = "."/></em>
  </xsl:template>
  <xsl:template match="table">
    <table>
      <xsl:apply-templates select="node()"/>
    </table>
  </xsl:template>
  <xsl:template match="br">
    <xsl:choose>
      <xsl:when test="normalize-space(text())">
        <xsl:choose>
          <xsl:when test="name(..)='p'">
            <xsl:apply-templates/>
            <br/>
          </xsl:when>
          <xsl:otherwise>
            <p>
              <xsl:apply-templates/>
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
<!-- Strip -->
  <xsl:template match="font">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="h1|h2|h3|h4">
    <xsl:comment> -ATTENTION- THIS IS A SECTION, PLEASE ENCLOSE THE SECTION CONTENTS... -ATTENTION- </xsl:comment>
    <section>
      <title><xsl:apply-templates/></title>
      <xsl:comment>... HERE! :-)</xsl:comment>
    </section>
  </xsl:template>
  <xsl:template match="node()|@*" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
