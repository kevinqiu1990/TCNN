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
  <xsl:template match="skins">
    <project default="echoskins">
      <target name="echoskins">
        <echo>Available skins:
Forrest provides the following default skins which should meet most needs:

Current:
* pelt
* tigris

Development:
* plain-dev

See http://forrest.apache.org/docs/skins.html

Additional skins which are maintained by other people are available from
outside the Forrest distribution. Currently these are only basic test skins
to demonstrate the concept of a remote skin respository.</echo>
        <xsl:apply-templates select="skin" />
      </target>
    </project>
  </xsl:template>
  <xsl:template match="skin">
    <echo>
* <xsl:value-of select="@name"/> - <xsl:value-of select="normalize-space(description)"/>
  - author: <xsl:value-of select="@author"/>
  - website: <xsl:value-of select="@website"/>
    </echo>
  </xsl:template>
</xsl:stylesheet>
