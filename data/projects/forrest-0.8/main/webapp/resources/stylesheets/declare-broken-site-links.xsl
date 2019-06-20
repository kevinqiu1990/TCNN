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
<!-- This is a workaround for FOR-284 "link rewriting broken when
  linking to xml source views which contain site: links"

  Prepend "error:" to any legitimate broken "site:" or "ext:" links.
  The remaining ones are the bogus ones caused by FOR-284 which are
  then excluded by cli.xconf
-->
  <xsl:template match="@*">
    <xsl:attribute name="{name(.)}">
      <xsl:choose>
        <xsl:when test="contains(., 'site:') or contains(., 'ext:')">
          <xsl:value-of select="concat('error:', .)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="/ | * | comment() | processing-instruction() | text()">
    <xsl:copy>
      <xsl:apply-templates select="@* | * | comment() | processing-instruction() | text()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
