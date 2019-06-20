<?xml version="1.0" encoding="UTF-8"?>
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
<!-- <xsl:preserve-space elements="*" /> -->
<!-- document-v10.dtd to document-v11.dtd transformation -->
<!-- We should something similar, i.e. make sure the result of this transformation is validated against the v11 DTD
  -->
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="document">
<!-- there exists a document element -->
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
<!-- no document element, presumably no header also, so I will generate one -->
        <document>
          <header>
            <title><xsl:value-of select="s1[1]/@title"/></title>
            <authors>
              <person name="unknown" email="unknown"/>
            </authors>
          </header>
          <body>
            <xsl:choose>
              <xsl:when test="count(s1)='1'">
<!-- only one s1 in the entire document, must be a hack to create a title -->
                <xsl:choose>
                  <xsl:when test="count(s1/s2)='1'">
<!-- only one s2 inside that s1, unwrap the content of that s2 -->
                    <xsl:apply-templates select="s1/s2/*"/>
                  </xsl:when>
                  <xsl:otherwise>
<!-- in any case, we get rid of these s1/s2 elements -->
                    <xsl:apply-templates select="s1/*"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates/>
              </xsl:otherwise>
            </xsl:choose>
          </body>
        </document>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
<!-- no links allowed in em anymore -->
  <xsl:template match="em[link]">
    <xsl:apply-templates/>
  </xsl:template>
<!-- fixes sections -->
  <xsl:template match="s1 | s2 | s3 | s4">
    <section>
      <xsl:apply-templates select="@*[name()!='title']"/>
      <xsl:apply-templates select="@*[name()='title']"/>
<!-- apply title rule last. See http://sourceforge.net/forum/forum.php?thread_id=729070&forum_id=94027 -->
      <xsl:apply-templates select="node()"/>
    </section>
  </xsl:template>
  <xsl:template match="s1/@title | s2/@title | s3/@title | s4/@title">
    <title><xsl:value-of select="."/></title>
  </xsl:template>
<!-- dunnow what to do with connect - maybe just evaporize it? -->
  <xsl:template match="connect">
    <xsl:message terminate="no">The connect element isn't supported anymore in the document-v11.dtd, please fix your document.</xsl:message>
    [[connect: <xsl:apply-templates/> ]]
  </xsl:template>
  <xsl:template match="link/@idref">
    <xsl:message terminate="no">The link element has no idref attribute defined in the document-v11.dtd, please fix your document.</xsl:message>
    [[link/@idref: <xsl:apply-templates/> ]]
  </xsl:template>
  <xsl:template match="link/@type | link/@actuate | link/@show |
                       jump/@type | jump/@actuate | jump/@show |
                       fork/@type | fork/@actuate | fork/@show"/>
<!-- 'simple lists' become unordered lists -->
  <xsl:template match="sl">
    <ul>
      <xsl:apply-templates select="@*|node()"/>
    </ul>
  </xsl:template>
<!-- the obligatory copy-everything -->
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
