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
Stylesheet to normalize the paths of href attributes, e.g.
href="somedir/../someotherdir/index.html" ==> href="someotherdir/index.html"
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
  <xsl:include href="../../skins/common/xslt/html/pathutils.xsl" />
  <xsl:include href="copyover.xsl" />
  <xsl:template match="@href">
    <xsl:if test="normalize-space(.)!=''">
      <xsl:attribute name="href">
        <xsl:call-template name="normalize">
          <xsl:with-param name="path" select="."/>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
