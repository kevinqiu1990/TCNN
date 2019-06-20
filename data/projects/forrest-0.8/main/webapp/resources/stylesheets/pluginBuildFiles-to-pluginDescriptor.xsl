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
<xsl:stylesheet xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:param name="type" select="FIXME"/>
  <xsl:template match="/">
    <plugins>
      <xsl:attribute name="type">
        <xsl:value-of select="$type"/>
      </xsl:attribute>
      <xsl:apply-templates select="/dir:directory/dir:directory/dir:file[@name='build.xml']/dir:xpath"/>
    </plugins>
  </xsl:template>
  <xsl:template match="project">
    <xsl:if test="property[@name='publish']/@value='true'">
      <plugin>
        <xsl:attribute name="name">
          <xsl:value-of select="property[@name='plugin-name']/@value"/>
        </xsl:attribute>
        <xsl:attribute name="type">
          <xsl:value-of select="property[@name='type']/@value"/>
        </xsl:attribute>
        <xsl:attribute name="author">
          <xsl:value-of select="property[@name='author']/@value"/>
        </xsl:attribute>
        <xsl:attribute name="website">
          <xsl:value-of select="property[@name='websiteURL']/@value"/>
        </xsl:attribute>
        <xsl:attribute name="url">
          <xsl:value-of select="property[@name='downloadURL']/@value"/>
        </xsl:attribute>
        <xsl:attribute name="version">
          <xsl:value-of select="property[@name='plugin-version']/@value"/>
        </xsl:attribute>
        <forrestVersion>
          <xsl:value-of select="property[@name='forrest.version']/@value"/>
        </forrestVersion>
        <description>
          <xsl:value-of select="property[@name='description']/@value"/>
        </description>
      </plugin>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
