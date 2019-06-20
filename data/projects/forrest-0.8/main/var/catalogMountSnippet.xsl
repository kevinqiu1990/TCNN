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
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xcat="urn:oasis:names:tc:entity:xmlns:xml:catalog"
  exclude-result-prefixes="xcat"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="plugin-catalog-path"/>
  <xsl:key name="existing-catalogs" match="xcat:nextCatalog" use="@catalog"/>
  <xsl:template match="xcat:catalog">
    <xsl:element name="catalog"
      namespace="urn:oasis:names:tc:entity:xmlns:xml:catalog">
      <xsl:apply-templates/>
      <xsl:if test="not(key('existing-catalogs', $plugin-catalog-path))">
        <xsl:element name="nextCatalog"
            namespace="urn:oasis:names:tc:entity:xmlns:xml:catalog">
          <xsl:attribute name="catalog">
            <xsl:value-of select="$plugin-catalog-path"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>
  <xsl:template match="@*|*|text()|processing-instruction()|comment()">
    <xsl:copy>
      <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
