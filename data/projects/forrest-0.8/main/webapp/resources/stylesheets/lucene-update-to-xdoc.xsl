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
<!-- Creates a Forrest document containing status information from a
     Lucene index creation or update. -->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:lucene="http://apache.org/cocoon/lucene/1.0"
  version="1.0">
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="lucene:index">
    <document>
      <header>
        <title>Lucene Index Creation Report</title>
      </header>
      <body>
        <p>
<xsl:text>Lucene has created an index in a directory named </xsl:text>
          <code>
          <xsl:value-of select="@directory"/>
          </code>
<xsl:text> below your servlet container's context
          root. </xsl:text>
<xsl:text>It used the analyzer class </xsl:text>
          <code>
          <xsl:value-of select="@analyzer"/>
          </code>
<xsl:text> for this purpose.</xsl:text>
        </p>
        <p>
          <xsl:value-of select="count(lucene:document)"/>
<xsl:text> documents were indexed. </xsl:text>
<xsl:text>The index was created with a merge factor
          of </xsl:text>
          <xsl:value-of select="@merge-factor"/>
<xsl:text>, just in case you're interested.</xsl:text>
        </p>
        <section>
          <title>Index creation time breakdown</title>
          <xsl:apply-templates/>
        </section>
      </body>
    </document>
  </xsl:template>
  <xsl:template match="lucene:document">
    <p>
<xsl:text>The document </xsl:text>
      <strong>
      <xsl:value-of select="@url"/>
      </strong>
<xsl:text> was indexed in </xsl:text>
      <strong>
      <xsl:value-of select="@elapsed-time"/>
<xsl:text>ms</xsl:text>
      </strong>
<xsl:text>.</xsl:text>
    </p>
  </xsl:template>
</xsl:stylesheet>
