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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" 
               version="1.0" 
               omit-xml-declaration="no" 
               indent="yes"
               doctype-public="-//APACHE//DTD Documentation V1.2//EN"
               doctype-system="http://forrest.apache.org/dtd/document-v12.dtd" />
  <xsl:template match="/">
    <document>
      <header>
        <title>Site Linkmap Table of Contents</title>
      </header>
      <body>
        <p>
          This is a map of the complete site and its structure.
        </p>
<!-- FIXME: FOR-731 workaround for a side-effect of the workaround for FOR-675
         <xsl:apply-templates select="*[not(self::site)]" />        
-->
        <xsl:apply-templates select="*" />
      </body>
    </document>
  </xsl:template>
  <xsl:template match="*">
    <xsl:if test="@label">
      <ul>
        <li><a>
          <xsl:if test="@href!=''">
            <xsl:attribute name="href">
              <xsl:value-of select="@href"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="@label"/>
<!-- force site element name to be on same line as label --></a>&#160;&#160;___________________&#160;&#160;<em>
          <xsl:value-of select="name(.)" /></em>
          <xsl:if test="@description">
<!-- allow description to flow to next line in a small window -->
<xsl:text>&#160;: </xsl:text>
            <xsl:value-of select="normalize-space(@description)"/>
          </xsl:if></li>
        <xsl:if test="*">
          <ul>
            <xsl:apply-templates/>
          </ul>
        </xsl:if>
      </ul>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
