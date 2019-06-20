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
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method = "xml"  
                version="1.0"
                omit-xml-declaration="no" 
                indent="yes"
                encoding="ISO-8859-1"
                doctype-system="book-cocoon-v10.dtd"
                doctype-public="-//APACHE//DTD Cocoon Documentation Book V1.0//EN" />
<!-- book to project -->
  <xsl:template match="project">
    <book software="{@name}"
            copyright="{@name}"
            title="{title}">
      <xsl:for-each select = "//menu">
        <menu label="{@name}">
          <xsl:for-each select = "item">
            <menu-item  label="{@name}" href="{@href}"/>
          </xsl:for-each>
        </menu>
      </xsl:for-each>
    </book>
  </xsl:template>
  <xsl:template match="menu"/>
  <xsl:template match="item"/>
</xsl:stylesheet>
