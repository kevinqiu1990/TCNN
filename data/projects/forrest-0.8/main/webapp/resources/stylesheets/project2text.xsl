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
<!--+
    | Replace element for the value on the project descriptor 
    | xmlns:for has to be replaced for the final version
    +-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:for="http://apache.org/forrest" version="1.0">
  <xsl:import href="copyover.xsl"/>
  <xsl:template match="for:*">
    <xsl:param name="config" select="//skinconfig"/>
    <xsl:choose>
<!-- If we have nested for:* elements in the XML we're
           transforming, recursively call ourselves
           with a narrowed scope for the skinconfig. -->
      <xsl:when test="*">
        <xsl:variable name="ln" select="local-name()"/>
        <xsl:apply-templates>
          <xsl:with-param name="config" select="$config/*[local-name() = $ln]"/>
        </xsl:apply-templates>
      </xsl:when>
<!-- Ah ha!  No more for:* children in the XML document being
           transformed so we just select the value of this node from skinconfig
           (ie.  $config). Note that the node we select from skinconfig may
           have nested elements and we'll get the values of all of them.  -->
      <xsl:otherwise>
        <xsl:variable name="ln" select="local-name()"/>
        <xsl:value-of select="$config/*[local-name() = $ln]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
