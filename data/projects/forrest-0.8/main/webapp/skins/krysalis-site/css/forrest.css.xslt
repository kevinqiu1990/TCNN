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
  <xsl:import href="../../common/css/forrest.css.xslt"/>
<!-- This is not used by Forrest but makes it possible to debug the 
       stylesheet in standalone editors -->
  <xsl:output method = "text"  omit-xml-declaration="yes"  />
<!-- ==================== main block colors ============================ -->
  <xsl:template match="color[@name='header']">
.header         { background-color: <xsl:value-of select="@value"/>;}  
</xsl:template>
  <xsl:template match="color[@name='tab-selected']"> 
.tab.selected      { background-color: <xsl:value-of select="@value"/>;} 
.tab.selected a:link {  color: <xsl:value-of select="@link"/>;  }
.tab.selected a:visited { color: <xsl:value-of select="@vlink"/>; }
.tab.selected a:hover { color: <xsl:value-of select="@hlink"/>; }
.border         { background-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
  <xsl:template match="color[@name='tab-unselected']"> 
.tab.unselected      { background-color: <xsl:value-of select="@value"/>;} 
.tab.unselected a:link {  color: <xsl:value-of select="@link"/>;  }
.tab.unselected a:visited { color: <xsl:value-of select="@vlink"/>; }
.tab.unselected a:hover { color: <xsl:value-of select="@hlink"/>; }
</xsl:template>
  <xsl:template match="color[@name='subtab-selected']">
.level2tabstrip a:link {  color: <xsl:value-of select="@link"/>;  }
.level2tabstrip a:visited { color: <xsl:value-of select="@vlink"/>; }
.level2tabstrip a:hover { color: <xsl:value-of select="@hlink"/>; }
</xsl:template>
  <xsl:template match="color[@name='subtab-unselected']">
.level2tabstrip { background-color: <xsl:value-of select="@value"/>;}
.datenote { background-color: <xsl:value-of select="@value"/>;} 
.level2tabstrip.unselected a:link {  color: <xsl:value-of select="@link"/>;  }
.level2tabstrip.unselected a:visited { color: <xsl:value-of select="@vlink"/>; }
.level2tabstrip.unselected a:hover { color: <xsl:value-of select="@hlink"/>; }
</xsl:template>
  <xsl:template match="color[@name='heading']">
.heading { background-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
  <xsl:template match="color[@name='subheading']">
.subheading { background-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
  <xsl:template match="color[@name='published']">
.published { color: <xsl:value-of select="@value"/>;}
</xsl:template>
  <xsl:template match="color[@name='navstrip']">
.subborder      { color: <xsl:value-of select="@font"/>;
                  background-color: <xsl:value-of select="@value"/>;}
.subborder a:link {  color: <xsl:value-of select="@link"/>;  }
.subborder a:visited { color: <xsl:value-of select="@vlink"/>; }
.subborder a:hover { color: <xsl:value-of select="@hlink"/>; }
.menu .menupagetitle  { background-color: <xsl:value-of select="@value"/>;}
</xsl:template>
  <xsl:template match="color[@name='toolbox']">
.menu .menupagetitle  { background-color: <xsl:value-of select="@value"/>}
</xsl:template>
  <xsl:template match="color[@name='border']">
.subborder.trail {border-bottom: 1px solid <xsl:value-of select="@value"/>;
                  border-top: 1px solid <xsl:value-of select="@value"/>; } 
.footer          {border-top: 1px solid <xsl:value-of select="@value"/>; }
.menu           { border-color: <xsl:value-of select="@value"/>;}
.menu .menupagetitle  { border-color: <xsl:value-of select="@value"/>;}
.menu .menupageitemgroup  { border-color: <xsl:value-of select="@value"/>;}
</xsl:template>
  <xsl:template match="color[@name='menu']">
.menu      { background-color: <xsl:value-of select="@value"/>;} 
.menu  {  color: <xsl:value-of select="@font"/>;} 
.menu a:link {  color: <xsl:value-of select="@link"/>;} 
.menu a:visited {  color: <xsl:value-of select="@vlink"/>;} 
.menu a:hover {  background-color: <xsl:value-of select="@value"/>;
                 color: <xsl:value-of select="@hlink"/>;} 
.menu .menupagetitle  { color: <xsl:value-of select="@hlink"/>;}     
</xsl:template>
  <xsl:template match="color[@name='dialog']"> 
.dialog      { background-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
  <xsl:template match="color[@name='body']">
body         { background-color: <xsl:value-of select="@value"/>;
               color: <xsl:value-of select="@font"/>;} 
a:link { color:<xsl:value-of select="@link"/>} 
a:visited { color:<xsl:value-of select="@vlink"/>} 
a:hover { color:<xsl:value-of select="@hlink"/>} 
.menupage a:link { background-color: <xsl:value-of select="@value"/>;
                                color:<xsl:value-of select="@link"/>} 
.menupage a:visited { background-color: <xsl:value-of select="@value"/>;
                                color:<xsl:value-of select="@vlink"/>} 
.menupage a:hover { background-color: <xsl:value-of select="@value"/>;
                                color:<xsl:value-of select="@hlink"/>} 
</xsl:template>
  <xsl:template match="color[@name='footer']"> 
.footer      { background-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
<!-- ==================== other colors ============================ -->
  <xsl:template match="color[@name='highlight']"> 
.highlight        { background-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
  <xsl:template match="color[@name='fixme']"> 
.fixme        { border-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
  <xsl:template match="color[@name='note']"> 
.note         { border-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
  <xsl:template match="color[@name='warning']"> 
.warning         { border-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
  <xsl:template match="color[@name='code']"> 
.code         { border-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
  <xsl:template match="color[@name='table']"> 
.content .ForrestTable      { background-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
  <xsl:template match="color[@name='table-cell']"> 
.content .ForrestTable td   { background-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
</xsl:stylesheet>
