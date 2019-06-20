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
  <xsl:template match="skinconfig">
    <xsl:if test="not(colors)">
      <colors>
<!-- Krysalis -->
        <color name="header"    value="#FFFFFF"/>
        <color name="tab-selected" value="#a5b6c6" link="#000000" vlink="#000000" hlink="#000000"/>
        <color name="tab-unselected" value="#F7F7F7"  link="#000000" vlink="#000000" hlink="#000000"/>
        <color name="subtab-selected" value="#a5b6c6"  link="#000000" vlink="#000000" hlink="#000000"/>
        <color name="subtab-unselected" value="#a5b6c6"  link="#000000" vlink="#000000" hlink="#000000"/>
        <color name="heading" value="#a5b6c6"/>
        <color name="subheading" value="#CFDCED"/>
        <color name="published" value="#000000"/>
        <color name="navstrip" value="#CFDCED" font="#000000" link="#000000" vlink="#000000" hlink="#000000"/>
        <color name="toolbox" value="#a5b6c6"/>
        <color name="border" value="#a5b6c6"/>
        <color name="menu" value="#F7F7F7" link="#000000" vlink="#000000" hlink="#000000"/>
        <color name="dialog" value="#F7F7F7"/>
        <color name="body"    value="#ffffff" link="#0F3660" vlink="#009999" hlink="#000066"/>
        <color name="table" value="#a5b6c6"/>
        <color name="table-cell" value="#ffffff"/>
        <color name="highlight" value="#ffff00"/>
        <color name="fixme" value="#cc6600"/>
        <color name="note" value="#006699"/>
        <color name="warning" value="#990000"/>
        <color name="code" value="#a5b6c6"/>
        <color name="footer" value="#a5b6c6"/>
      </colors>
    </xsl:if>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="node()[not(name(.)='colors')]"/>
      <xsl:apply-templates select="colors"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="colors">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="node()[name(.)='color']"/>
      <xsl:if test="not(color[@name='header'])">
        <color name="header" value="#FFFFFF"/>
      </xsl:if>
      <xsl:if test="not(color[@name='tab-selected'])">
        <color name="tab-selected" value="#a5b6c6" link="#000000" vlink="#000000" hlink="#000000"/>
      </xsl:if>
      <xsl:if test="not(color[@name='tab-unselected'])">
        <color name="tab-unselected" value="#F7F7F7"  link="#000000" vlink="#000000" hlink="#000000"/>
      </xsl:if>
      <xsl:if test="not(color[@name='subtab-selected'])">
        <color name="subtab-selected" value="#a5b6c6"  link="#000000" vlink="#000000" hlink="#000000"/>
      </xsl:if>
      <xsl:if test="not(color[@name='subtab-unselected'])">
        <color name="subtab-unselected" value="#a5b6c6"  link="#000000" vlink="#000000" hlink="#000000"/>
      </xsl:if>
      <xsl:if test="not(color[@name='heading'])">
        <color name="heading" value="#a5b6c6"/>
      </xsl:if>
      <xsl:if test="not(color[@name='subheading'])">
        <color name="subheading" value="#CFDCED"/>
      </xsl:if>
      <xsl:if test="not(color[@name='published'])">
        <color name="published" value="#ffffff"/>
      </xsl:if>
      <xsl:if test="not(color[@name='navstrip'])">
        <color name="navstrip" value="#CFDCED" font="#000000" link="#000000" vlink="#000000" hlink="#000000"/>
      </xsl:if>
      <xsl:if test="not(color[@name='toolbox'])">
        <color name="toolbox" value="#a5b6c6"/>
      </xsl:if>
      <xsl:if test="not(color[@name='border'])">
        <color name="border" value="#a5b6c6"/>
      </xsl:if>
      <xsl:if test="not(color[@name='menu'])">
        <color name="menu" value="#F7F7F7" link="#000000" vlink="#000000" hlink="#000000"/>
      </xsl:if>
      <xsl:if test="not(color[@name='dialog'])">
        <color name="dialog" value="#F7F7F7"/>
      </xsl:if>
      <xsl:if test="not(color[@name='body'])">
        <color name="body" value="#ffffff" link="#0F3660" vlink="#009999" hlink="#000066"/>
      </xsl:if>
      <xsl:if test="not(color[@name='table'])">
        <color name="table" value="#a5b6c6"/>
      </xsl:if>
      <xsl:if test="not(color[@name='table-cell'])">
        <color name="table-cell" value="#ffffff"/>
      </xsl:if>
      <xsl:if test="not(color[@name='highlight'])">
        <color name="highlight" value="#ffff00"/>
      </xsl:if>
      <xsl:if test="not(color[@name='fixme'])">
        <color name="fixme" value="#c60"/>
      </xsl:if>
      <xsl:if test="not(color[@name='note'])">
        <color name="note" value="#069"/>
      </xsl:if>
      <xsl:if test="not(color[@name='warning'])">
        <color name="warning" value="#900"/>
      </xsl:if>
      <xsl:if test="not(color[@name='code'])">
        <color name="code" value="#a5b6c6"/>
      </xsl:if>
      <xsl:if test="not(color[@name='footer'])">
        <color name="footer" value="#a5b6c6"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
