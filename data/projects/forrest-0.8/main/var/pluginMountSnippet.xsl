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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:map="http://apache.org/cocoon/sitemap/1.0">
  <xsl:output method="xml" indent="yes" />
  <xsl:param name="plugin-name" />
  <xsl:param name="plugin-type" />
  <xsl:template match="map:sitemap">
    <map:sitemap>
      <xsl:apply-templates/>
    </map:sitemap>
  </xsl:template>
  <xsl:template match="map:pipelines">
    <map:pipelines>
      <xsl:apply-templates/>
    </map:pipelines>
  </xsl:template>
  <xsl:template match="map:pipeline">
    <map:pipeline>
      <xsl:apply-templates/>
      <xsl:element name="map:select">
        <xsl:attribute name="type">exists</xsl:attribute>
        <xsl:element name="map:when">
          <xsl:attribute name="test">{forrest:forrest.plugins}/<xsl:value-of select="$plugin-name"/>/<xsl:value-of select="$plugin-type"/>.xmap</xsl:attribute>
          <xsl:element name="map:mount">
            <xsl:attribute name="uri-prefix"/>
            <xsl:attribute name="src">{forrest:forrest.plugins}/<xsl:value-of select="$plugin-name"/>/<xsl:value-of select="$plugin-type"/>.xmap</xsl:attribute>
            <xsl:attribute name="check-reload">yes</xsl:attribute>
            <xsl:attribute name="pass-through">true</xsl:attribute>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </map:pipeline>
  </xsl:template>
  <xsl:template match="@*|*|text()|processing-instruction()|comment()">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
