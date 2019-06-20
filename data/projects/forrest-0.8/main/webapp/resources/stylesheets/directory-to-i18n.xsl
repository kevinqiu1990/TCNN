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
  Create a div element with all the alternate language versions.
-->
<xsl:stylesheet exclude-result-prefixes="dir" version="1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1">
  <xsl:param name="ext" />
  <xsl:template match="/">
    <div class="lang" >
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  <xsl:template match="dir:file">
<!-- Assume that the file pattern is resource_locale.extension -->
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="concat(substring-before(@name,'_'),'.',$ext)"/>
      </xsl:attribute >
      <xsl:attribute name="hreflang">
        <xsl:value-of select="substring-after(substring-before(@name, '.'),'_')"/>
      </xsl:attribute >
      <xsl:attribute name="lang">
<!-- It just specify that the content on "a" element is in this language -->
        <xsl:value-of select="substring-after(substring-before(@name, '.'),'_')"/>
      </xsl:attribute >
      <xsl:attribute name="rel">
        <xsl:value-of select="'alternate'"/>
      </xsl:attribute>
      <xsl:attribute name="i18n:attr">title</xsl:attribute>
      <xsl:attribute name="title" >
        <xsl:value-of select="substring-after(substring-before(@name, '.'),'_')"/>
      </xsl:attribute>
      <i18n:text i18n:catalogue="langcode">
        <xsl:value-of select="substring-after(substring-before(@name, '.'),'_')"/>
      </i18n:text>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
