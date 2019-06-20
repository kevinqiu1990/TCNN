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
#branding {
background-color: <xsl:value-of select="@value"/>;
}  
</xsl:template>
  <xsl:template match="color[@name='tab-selected']"> 
#nav-main .current { background-color: <xsl:value-of select="@value"/>;} 
#nav-main .current a:link {  color: <xsl:value-of select="@link"/>;  }
#nav-main .current a:visited { color: <xsl:value-of select="@vlink"/>; }
#nav-main .current a:hover { color: <xsl:value-of select="@hlink"/>; }
</xsl:template>
  <xsl:template match="color[@name='tab-unselected']"> 
#nav-main li      { background-color: <xsl:value-of select="@value"/> ;} 
#nav-main li a:link {  color: <xsl:value-of select="@link"/>;  }
#nav-main li a:visited { color: <xsl:value-of select="@vlink"/>; }
#nav-main li a:hover { color: <xsl:value-of select="@hlink"/>; }
</xsl:template>
  <xsl:template match="color[@name='subtab-selected']">
#branding-tagline   { background-color: <xsl:value-of select="@value"/> ;} 
#branding-tagline a:link {  color: <xsl:value-of select="@link"/>;  }
#branding-tagline a:visited { color: <xsl:value-of select="@vlink"/>; }
#branding-tagline a:hover { color: <xsl:value-of select="@hlink"/>; }
</xsl:template>
<!--xsl:template match="color[@name='subtab-unselected']">
.level2tabstrip { background-color: <xsl:value-of select="@value"/>;}
.datenote { background-color: <xsl:value-of select="@value"/>;} 
.level2tabstrip.unselected a:link {  color: <xsl:value-of select="@link"/>;  }
.level2tabstrip.unselected a:visited { color: <xsl:value-of select="@vlink"/>; }
.level2tabstrip.unselected a:hover { color: <xsl:value-of select="@hlink"/>; }
</xsl:template-->
<!--
<xsl:template match="color[@name='heading']">
.heading { background-color: <xsl:value-of select="@value"/>;} 
</xsl:template> 
-->
<!--xsl:template match="color[@name='subheading']">
.boxed { background-color: <xsl:value-of select="@value"/>;} 
.underlined_5 	{border-bottom: solid 5px <xsl:value-of select="@value"/>;}
.underlined_10 	{border-bottom: solid 10px <xsl:value-of select="@value"/>;}
table caption { 
	background-color: <xsl:value-of select="@value"/>; 
	color: <xsl:value-of select="@font"/>;
}
</xsl:template> 
<xsl:template match="color[@name='feedback']">    
#feedback {
	color: <xsl:value-of select="@font"/>;
	background: <xsl:value-of select="@value"/>;
	text-align: <xsl:value-of select="@align"/>;
}
#feedback #feedbackto {
	color: <xsl:value-of select="@font"/>;
}   
</xsl:template>
<xsl:template match="color[@name='published']">
#published { 
    color: <xsl:value-of select="@font"/>;
    background: <xsl:value-of select="@value"/>; 
}
</xsl:template> 

<xsl:template match="color[@name='navstrip']">
#main .breadtrail {
	background: <xsl:value-of select="@value"/>; 
	color: <xsl:value-of select="@font"/>;
}
#main .breadtrail a:link {  color: <xsl:value-of select="@link"/>;  }
#main .breadtrail a:visited { color: <xsl:value-of select="@vlink"/>; }
#main .breadtrail a:hover { color: <xsl:value-of select="@hlink"/>; }
#top .breadtrail {
	background: <xsl:value-of select="@value"/>; 
	color: <xsl:value-of select="@font"/>;
}
#top .breadtrail a:link {  color: <xsl:value-of select="@link"/>;  }
#top .breadtrail a:visited { color: <xsl:value-of select="@vlink"/>; }
#top .breadtrail a:hover { color: <xsl:value-of select="@hlink"/>; }

</xsl:template> 

<xsl:template match="color[@name='toolbox']">
#menu .menupagetitle  { background-color: <xsl:value-of select="@value"/>}
</xsl:template> 

<xsl:template match="color[@name='border']">
#menu           { border-color: <xsl:value-of select="@value"/>;}
#menu .menupagetitle  { border-color: <xsl:value-of select="@value"/>;}
#menu .menupageitemgroup  { border-color: <xsl:value-of select="@value"/>;}
</xsl:template-->
  <xsl:template match="color[@name='menu']">
#nav-section {
background-color: <xsl:value-of select="@value"/>;
color: <xsl:value-of select="@font"/>;
} 
#nav-section a:link {  color: <xsl:value-of select="@link"/>;} 
#nav-section a:visited {  color: <xsl:value-of select="@vlink"/>;} 
#nav-section a:hover {
background-color: <xsl:value-of select="@value"/>;
color: <xsl:value-of select="@hlink"/>;
} 
#nav-section .menupagetitle  { color: <xsl:value-of select="@hlink"/>;}     
</xsl:template>
<!--xsl:template match="color[@name='dialog']"> 
#menu .menupageitemgroup     { 
	background-color: <xsl:value-of select="@value"/>;
}
#menu .menupageitem {
	color: <xsl:value-of select="@font"/>;
} 
</xsl:template-->
  <xsl:template match="color[@name='menuheading']">
.nav-section-title {
    color: <xsl:value-of select="@font"/>;
    background-color: <xsl:value-of select="@value"/>;
}   
</xsl:template>
  <xsl:template match="color[@name='menuarea']">
#nav-section .currentmenuitemgroup {
    color: <xsl:value-of select="@font"/>;
    background-color: <xsl:value-of select="@value"/>;
}   
</xsl:template>
  <xsl:template match="color[@name='searchbox']"> 
.search-input { 
    background-color: <xsl:value-of select="@value"/> ;
    color: <xsl:value-of select="@font"/>; 
} 
</xsl:template>
  <xsl:template match="color[@name='body']">
body         { background-color: <xsl:value-of select="@value"/>;
               color: <xsl:value-of select="@font"/>;} 
a:link { color:<xsl:value-of select="@link"/>} 
a:visited { color:<xsl:value-of select="@vlink"/>} 
a:hover { color:<xsl:value-of select="@hlink"/>} 
/*
.menupage a:link { background-color: <xsl:value-of select="@value"/>;
                                color:<xsl:value-of select="@link"/>} 
.menupage a:visited { background-color: <xsl:value-of select="@value"/>;
                                color:<xsl:value-of select="@vlink"/>} 
.menupage a:hover { background-color: <xsl:value-of select="@value"/>;
                                color:<xsl:value-of select="@hlink"/>} 
*/
</xsl:template>
  <xsl:template match="color[@name='footer']"> 
#footer       { background-color: <xsl:value-of select="@value"/>;} 
</xsl:template>
<!-- ==================== other colors ============================ -->
<!--xsl:template match="color[@name='highlight']"> 
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
.ForrestTable      { background-color: <xsl:value-of select="@value"/>;} 
</xsl:template> 

<xsl:template match="color[@name='table-cell']"> 
.ForrestTable td   { background-color: <xsl:value-of select="@value"/>;} 
</xsl:template-->
</xsl:stylesheet>
