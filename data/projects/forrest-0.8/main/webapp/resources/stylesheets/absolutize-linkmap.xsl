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
Stylesheet to recursively append all @href's in a tree,
e.g. given as input:

<site href="">
  <community href="community/">
    <faq href="faq.html">
      <how_can_I_help href="#help"/>
    </faq>
  </community>
</site>

Output would be:

<site href="">
  <community href="community/">
    <faq href="community/faq.html">
      <how_can_I_help href="community/faq.html#help"/>
    </faq>
  </community>
</site>

This is applied to site.xml to generate the 'abs-linkmap' URIs in the sitemap.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- Recursive template to collate @href's -->
  <xsl:template name="absolutize">
    <xsl:param name="node"/>
<!-- Only append ancestor hrefs if we're not a uri-scheme: URL -->
    <xsl:if test="not(contains($node/@href, ':')) or contains(substring-before($node/@href, ':'), '/')">
      <xsl:if test="$node/..">
        <xsl:call-template name="absolutize">
          <xsl:with-param name="node" select="$node/.."/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
    <xsl:value-of select="$node/@href"/>
  </xsl:template>
  <xsl:template match="@href">
    <xsl:attribute name="href">
      <xsl:choose>
        <xsl:when test="starts-with(., '/')">
<!-- already is an absolute path, strip the leading slash -->
          <xsl:value-of select="substring-after(., '/')"/>
        </xsl:when>
        <xsl:otherwise>
<!-- the path needs to be absolutized -->
          <xsl:call-template name="absolutize">
            <xsl:with-param name="node" select=".."/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
