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
Stylesheet for generating book.xml from a suitably hierarchical site.xml file.
The project info is currently hardcoded, but since it isn't used anyway that
isn't a major problem.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="http://apache.org/forrest/linkmap/1.0" exclude-result-prefixes="f">
  <xsl:param name="path"/>
  <xsl:output doctype-system="book-cocoon-v10.dtd" doctype-public="-//APACHE//DTD Cocoon Documentation Book V1.0//EN"/>
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
<!-- FIXME: This is a workaround to Issue FOR-675 and commons-jxpath-1.2 -->
<!--
  <xsl:template match="f:site">
-->
  <xsl:template match="site">
<!-- end FIXME: FOR-675 -->
    <book software="Forrest"
      title="Apache Forrest"
      copyright="Copyright 2002-2005 The Apache Software Foundation or its licensors, as applicable.">
      <xsl:apply-templates/>
    </book>
  </xsl:template>
  <xsl:template match="*/*">
    <xsl:choose>
<!-- No label, abandon the whole subtree -->
      <xsl:when test="not(@label)"></xsl:when>
<!-- Below here, everything has a label, and is therefore considered "for display" -->
<!-- No children -> must be a menu item -->
<!-- Has children, but they are not for display -> menu item -->
      <xsl:when test="count(*) = 0 or count(*) > 0 and (not(*/@label))">
        <menu-item>
          <xsl:copy-of select="@*"/>
        </menu-item>
      </xsl:when>
<!-- Anything else is considered a menu -->
      <xsl:otherwise>
        <menu>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </menu>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
