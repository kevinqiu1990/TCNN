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
  <xsl:template match="plugins">
    <project default="echoplugins">
      <target name="echoplugins">
        <echo>Available plugins:
Forrest provides basic functionality for creating documentation in various
formats from a range of source formats. However, additional functionlaity
can be provided through plugins.

Plugins may be maintained by other people and be available from
outside the Forrest distribution. The list below details all known plugins.
</echo>
        <echo>
=============
Input Plugins
=============
</echo>
        <xsl:apply-templates select="plugin[@type='input']" />
        <echo>
==============
Output Plugins
==============
</echo>
        <xsl:apply-templates select="plugin[@type='output']" />
        <echo>
================
Internal Plugins
================
</echo>
        <xsl:apply-templates select="plugin[@type='internal']" />
      </target>
    </project>
  </xsl:template>
  <xsl:template match="plugin">
    <echo>
    * <xsl:value-of select="@name"/>
      - <xsl:value-of select="normalize-space(description)"/>
    
      - Author: <xsl:value-of select="@author"/>
      - Website: <xsl:value-of select="@website"/>
      - Version:  <xsl:value-of select="@version"/>
      - Required Forrest Version: <xsl:value-of select="forrestVersion"/>
    </echo>
  </xsl:template>
</xsl:stylesheet>
