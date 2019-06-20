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
  <xsl:output method="xml" indent="yes" />
  <xsl:param name="skin-name" />
  <xsl:param name="forrest-version" />
  <xsl:template match="skins">
    <project default="fetchskin">
      <target name="fetchskin" depends="fetch-versioned-skin, fetch-unversioned-skin, final-check"/>
      <target name="fetch-versioned-skin">
        <echo>Trying to get "<xsl:value-of select="$skin-name" />" skin version 
                  <xsl:value-of select="$forrest-version" />...</echo>
        <get verbose="true" usetimestamp="true" ignoreerrors="true">
          <xsl:attribute name="src">
            <xsl:value-of select="skin[@name=$skin-name]/@url" />
            <xsl:value-of select="$skin-name" />-<xsl:value-of select="$forrest-version" />.zip</xsl:attribute>
          <xsl:attribute name="dest">${forrest.home}/context/skins/<xsl:value-of select="$skin-name" />.zip</xsl:attribute>
        </get>
        <available property="versioned-skin.present">
          <xsl:attribute name="file">${forrest.home}/context/skins/<xsl:value-of select="$skin-name" />.zip</xsl:attribute>
        </available>
      </target>
      <target name="fetch-unversioned-skin" unless="versioned-skin.present">
        <echo>Versioned skin unavailable, trying to get versionless skin...</echo>
        <get verbose="true" usetimestamp="true" ignoreerrors="true">
          <xsl:attribute name="src">
            <xsl:value-of select="skin[@name=$skin-name]/@url" />
            <xsl:value-of select="$skin-name" />.zip</xsl:attribute>
          <xsl:attribute name="dest">${forrest.home}/context/skins/<xsl:value-of select="$skin-name" />.zip</xsl:attribute>
        </get>
      </target>
      <target name="final-check">
        <available property="skin.present">
          <xsl:attribute name="file">${forrest.home}/context/skins/<xsl:value-of select="$skin-name" />.zip</xsl:attribute>
        </available>
        <fail unless="skin.present">
              Unable to download the 
              "<xsl:value-of select="$skin-name" />" skin from 
              <xsl:value-of select="skin[@name=$skin-name]/@url" />
              In case the reason is the network connection, you can try 
              installing the package manually by placing the file in the 
              skins directory.</fail>
        <echo>Skin "<xsl:value-of select="$skin-name" />" correctly installed.</echo>
      </target>
    </project>
  </xsl:template>
  <xsl:template match="skin"></xsl:template>
</xsl:stylesheet>
