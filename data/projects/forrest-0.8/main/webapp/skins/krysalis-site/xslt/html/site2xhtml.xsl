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
site2xhtml.xsl is the final stage in HTML page production.  It merges HTML from
document2html.xsl, tab2menu.xsl and book2menu.xsl, and adds the site header,
footer, searchbar, css etc.  As input, it takes XML of the form:

<site>
  <? class="menu">
    ...
  </?>
  <? class="tab">
    ...
  </?>
  <? class="content">
    ...
  </?>
</site>

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../../common/xslt/html/site-to-xhtml.xsl"/>
  <xsl:template match="site">
    <html>
      <head>
        <xsl:call-template name="html-meta"/>
        <title><xsl:value-of select="div[@class='content']/table/tr/td/h1"/></title><link rel="stylesheet" href="{$root}skin/page.css" type="text/css"/><link rel="stylesheet" href="{$root}skin/forrest.css" type="text/css"/>
        <xsl:if test="//skinconfig/favicon-url"><link rel="shortcut icon">
          <xsl:attribute name="href">
            <xsl:value-of select="concat($root,//skinconfig/favicon-url)"/>
          </xsl:attribute></link>
        </xsl:if>
<script type="text/javascript" language="javascript" src="{$root}skin/fontsize.js"></script>
<script type="text/javascript" language="javascript" src="{$root}skin/menu.js"></script>
      </head>
      <body onload="init()" >
<script type="text/javascript">ndeSetTextSize();</script>
<!--
          +=========================+
          |       topstrip          |
          +=========================+
          |                         |
          |       centerstrip       |
          |                         |
          |                         |
          +=========================+
          |       bottomstrip       |
          +=========================+
        -->
        <xsl:call-template name="topstrip" />
        <xsl:call-template name="centerstrip"/>
        <xsl:call-template name="bottomstrip"/>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="topstrip">
<!--   
        +======================================================+
        |+============+    +==============+    | search box |  |
        || group logo |    | project logo |    +============+  |
        |+============+    +==============+                    |
        +======================================================+
        ||tab|tab|tab|                                         |
        +======================================================+
        ||subtab|subtab|subtab|                  publish date  |
        +======================================================+        
    -->
    <table class="header" cellspacing="0" cellpadding="0" border="0" width="100%">
      <tr>
<!-- ( ================= Group Logo ================== ) -->
        <td >
          <div class="headerlogo">
            <xsl:call-template name="renderlogo">
              <xsl:with-param name="name" select="//skinconfig/group-name"/>
              <xsl:with-param name="url" select="//skinconfig/group-url"/>
              <xsl:with-param name="logo" select="//skinconfig/group-logo"/>
              <xsl:with-param name="root" select="$root"/>
            </xsl:call-template>
          </div>
        </td>
<!-- ( ================= Project Logo ================== ) -->
        <xsl:choose>
          <xsl:when test="$config/search and not($config/search/@box-location = 'alt')">
            <td align="center" >
              <div class="headerlogo">
                <xsl:call-template name="renderlogo">
                  <xsl:with-param name="name" select="//skinconfig/project-name"/>
                  <xsl:with-param name="url" select="//skinconfig/project-url"/>
                  <xsl:with-param name="logo" select="//skinconfig/project-logo"/>
                  <xsl:with-param name="root" select="$root"/>
                </xsl:call-template>
              </div>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td align="right" colspan="3" valign="bottom">
              <div class="headerlogo right">
                <xsl:call-template name="renderlogo">
                  <xsl:with-param name="name" select="//skinconfig/project-name"/>
                  <xsl:with-param name="url" select="//skinconfig/project-url"/>
                  <xsl:with-param name="logo" select="//skinconfig/project-logo"/>
                  <xsl:with-param name="root" select="$root"/>
                </xsl:call-template>
              </div>
            </td>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$config/search and not($config/search/@box-location = 'alt')">
<!-- ( =================  Search ================== ) -->
            <td class="search" align="right" rowspan="2" valign="top">
              <xsl:choose>
                <xsl:when test="$config/search/@provider = 'lucene'">
<!-- Lucene search -->
                  <form method="get" action="{$root}{$lucene-search}">
                    <table class="dialog" cellspacing="0" cellpadding="0" border="0">
                      <tr>
                        <td colspan="3" class="border" height="10"></td>
                      </tr>
                      <tr>
                        <td colspan="3" height="8"></td>
                      </tr>
                      <tr>
                        <td></td>
                        <td nowrap="nowrap">
                          <input type="text" id="query" name="queryString" size="15"/>
			&#160;
			<input type="submit" value="Search" name="Search"/>
                          <br />
			the <xsl:value-of select="$config/search/@name"/> site
		      </td>
                        <td></td>
                      </tr>
                      <tr>
                        <td colspan="3" height="7"></td>
                      </tr>
                      <tr>
                        <td class="search border bottom-left SBBL"></td>
                        <td class="search border bottomborder"></td>
                        <td class="search border bottom-right SBBR"></td>
                      </tr>
                    </table>
                  </form>
                </xsl:when>
                <xsl:otherwise>
<!-- Google search -->
                  <form method="get" action="http://www.google.com/search" target="_blank">
                    <table class="dialog" cellspacing="0" cellpadding="0" border="0">
                      <tr>
                        <td colspan="3" class="border" height="10"></td>
                      </tr>
                      <tr>
                        <td colspan="3" height="8"></td>
                      </tr>
                      <tr>
                        <td></td>
                        <td nowrap="nowrap">
                          <input type="hidden" name="as_sitesearch" value="{$config/search/@domain}"/>
                          <input type="text" id="query" name="as_q" size="15"/>
			&#160;
			<input type="submit" value="Search" name="Search"/>
                          <br />
			the <xsl:value-of select="$config/search/@name"/> site
			<!-- setting search options off for the moment -->
<!--
			<input type="radio" name="web" value="web"/>web site&#160;&#160;<input type="radio" name="mail" value="mail"/>mail lists
			-->
                        </td>
                        <td></td>
                      </tr>
                      <tr>
                        <td colspan="3" height="7"></td>
                      </tr>
                      <tr>
                        <td class="search border bottom-left SBBL"></td>
                        <td class="search border bottomborder"></td>
                        <td class="search border bottom-right SBBR"></td>
                      </tr>
                    </table>
                  </form>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td align="right" width="10" height="10">
              <span class="textheader">
                <xsl:value-of select="//skinconfig/project-name"/>
              </span>
            </td>
          </xsl:when>
        </xsl:choose>
      </tr>
<!-- ( ================= Tabs ================== ) -->
      <tr>
        <td colspan="4" class="tabstrip">
          <xsl:apply-templates select="table[@class='tab']"/>
        </td>
      </tr>
      <tr>
        <td colspan="2" class="level2tabstrip">
          <xsl:apply-templates select="table[@class='level2tab']"/>
        </td>
        <td colspan="2" class="datenote level2tabstrip">
          <div class="published">
<script language="JavaScript" type="text/javascript"><![CDATA[<!--
              document.write("Published: " + document.lastModified);
              //  -->]]></script>
          </div>
        </td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template name="centerstrip" >
<!--
     +=========+======================+
     |         |                      |
     |         |                      |
     |         |                      |
     |         |                      |
     |  menu   |   mainarea           |
     |         |                      |
     |         |                      |
     |         |                      |
     |         |                      |
     +=========+======================+
    -->
    <table cellspacing="0" cellpadding="0" border="0" width="100%">
      <tr>
<!-- ( =================  Menu  ================== ) -->
        <td valign="top">
<!-- If we have any menu items, draw a menu -->
          <xsl:if test="div[@class='menu']/ul/li">
            <xsl:call-template name="menu"/>
          </xsl:if>
        </td>
<!-- ( =================  Main Area  ================== ) -->
        <td valign="top" width="100%">
          <xsl:call-template name="mainarea"/>
        </td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template name="menu">
    <table cellpadding="0" cellspacing="0" class="menuarea">
      <tr>
<!-- ( ================= start left top NavBar ================== ) -->
        <td valign = "top" width="6px">
          <table class="leftpagemargin" cellspacing="0" cellpadding="0" border="0">
            <tr>
              <td class="subborder trail">&#160;</td>
            </tr>
          </table>
        </td>
<!-- ( ================= end left top NavBar ================== ) -->
        <td class="dialog">
<!-- ( ================= start Menu items ================== ) -->
          <div class="menu">
            <xsl:for-each select = "div[@class='menu']/ul/li">
              <xsl:call-template name = "innermenuli" >
                <xsl:with-param name="id" select="concat('1.', position())"/>
              </xsl:call-template>
            </xsl:for-each>
          </div>
<!-- ( ================= end Menu items ================== ) -->
        </td>
      </tr>
      <tr>
        <td></td>
        <td>
          <table cellspacing="0" cellpadding="0" border="0" width="100%">
            <tr>
              <td class="border bottom-left"></td>
              <td class="border bottomborder"></td>
              <td class="border bottom-right" ></td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td height="10" colspan="2"></td>
      </tr>
      <xsl:if test="$config/search and ($config/search/@box-location = 'alt' or $config/search/@box-location = 'all')">
        <tr>
          <td></td>
          <td class="search">
            <xsl:choose>
              <xsl:when test="$config/search/@provider = 'lucene'">
                <form method="get" action="{$root}{$lucene-search}">
                  <table class="dialog" cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                      <td class="border top-left"></td>
                      <td class="border"></td>
                      <td class="border top-right"></td>
                    </tr>
                    <tr>
                      <td class="border" ></td>
                      <td colspan="2" class="border" height="10">
                        <b>Search</b>
                      </td>
                    </tr>
                    <tr>
                      <td colspan="3" height="8"></td>
                    </tr>
                    <tr>
                      <td></td>
                      <td>
                        <input type="hidden" name="sitesearch" value="{$config/search/@domain}"/>
                    the <xsl:value-of select="$config/search/@name"/> site
                    <br />
                        <input type="text" id="query" name="queryString" size="13"/>
                        <input type="submit" value="Go" name="Search"/>
                      </td>
                      <td></td>
                    </tr>
                    <tr>
                      <td colspan="3" height="7"></td>
                    </tr>
                    <tr>
                      <td class="border bottom-left"></td>
                      <td class="border bottomborder"></td>
                      <td class="border bottom-right"></td>
                    </tr>
                  </table>
                </form>
              </xsl:when>
              <xsl:otherwise>
                <form method="get" action="http://www.google.com/search" target="_blank">
                  <table class="dialog" cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                      <td class="border top-left"></td>
                      <td class="border"></td>
                      <td class="border top-right"></td>
                    </tr>
                    <tr>
                      <td class="border" ></td>
                      <td colspan="2" class="border" height="10">
                        <b>Search</b>
                      </td>
                    </tr>
                    <tr>
                      <td colspan="3" height="8"></td>
                    </tr>
                    <tr>
                      <td></td>
                      <td>
                        <input type="hidden" name="as_sitesearch" value="{$config/search/@domain}"/>
                    the <xsl:value-of select="$config/search/@name"/> site
                    <br />
                        <input type="text" id="query" name="as_q" size="13"/>
                        <input type="submit" value="Go" name="Search"/>
                      </td>
                      <td></td>
                    </tr>
                    <tr>
                      <td colspan="3" height="7"></td>
                    </tr>
                    <tr>
                      <td class="border bottom-left"></td>
                      <td class="border bottomborder"></td>
                      <td class="border bottom-right"></td>
                    </tr>
                  </table>
                </form>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="$filename = 'index.html' and //skinconfig/credits">
        <tr>
          <td></td>
          <td>
            <xsl:for-each select="//skinconfig/credits/credit[not(@role='pdf')]">
              <xsl:variable name="name" select="name"/>
              <xsl:variable name="url" select="url"/>
              <xsl:variable name="image" select="image"/>
              <xsl:variable name="width" select="width"/>
              <xsl:variable name="height" select="height"/>
              <span class="logos"><a href="{$url}">
                <img alt="{$name} logo" border="0">
                  <xsl:attribute name="src">
                    <xsl:if test="not(starts-with($image, 'http://'))">
                      <xsl:value-of select="$root"/>
                    </xsl:if>
                    <xsl:value-of select="$image"/>
                  </xsl:attribute>
                  <xsl:if test="$width">
                    <xsl:attribute name="width">
                      <xsl:value-of select="$width"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="$height">
                    <xsl:attribute name="height">
                      <xsl:value-of select="$height"/>
                    </xsl:attribute>
                  </xsl:if>
                </img></a>
              </span>
              <br/>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
    </table>
  </xsl:template>
  <xsl:template name="innermenuli">
    <xsl:param name="id"/>
    <xsl:variable name="tagid">
      <xsl:choose>
        <xsl:when test="descendant-or-self::node()/li/span/@class='sel'">
          <xsl:value-of select="concat('menu_selected_',$id)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('menu_',concat(font,$id))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="whichGroup">
      <xsl:choose>
        <xsl:when test="descendant-or-self::node()/li/span/@class='sel'">selectedmenuitemgroup</xsl:when>
        <xsl:otherwise>menuitemgroup</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="menutitle" id="{$tagid}Title" onclick="SwitchMenu('{$tagid}')">
      <xsl:value-of select="span"/>
    </div>
    <div class="{$whichGroup}" id="{$tagid}">
      <xsl:for-each select= "ul/li">
        <xsl:choose>
          <xsl:when test="a">
            <div class="menuitem"><a href="{a/@href}">
              <xsl:value-of select="a" /></a>
            </div>
          </xsl:when>
          <xsl:when test="span/@class='sel'">
            <div class="menupage">
              <div class="menupagetitle">
                <xsl:value-of select="span" />
              </div>
              <xsl:if test="$config/toc/@max-depth&gt;0 and contains($minitoc-location,'menu')">
                <div class="menupageitemgroup">
                  <xsl:for-each select = "//tocitems/tocitem">
                    <div class="menupageitem">
                      <xsl:choose>
                        <xsl:when test="string-length(@title)>15"><a href="{@href}" title="{@title}">
                          <xsl:value-of select="substring(@title,0,20)" />...</a>
                        </xsl:when>
                        <xsl:otherwise><a href="{@href}">
                          <xsl:value-of select="@title" /></a>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="tocitem">
<!-- nicolaken: this enables double-nested page links-->
                        <ul>
                          <xsl:for-each select = "tocitem">
                            <xsl:choose>
                              <xsl:when test="string-length(@title)>15">
                                <li><a href="{@href}" title="{@title}">
                                  <xsl:value-of select="substring(@title,0,20)" />...</a></li>
                              </xsl:when>
                              <xsl:otherwise>
                                <li><a href="{@href}">
                                  <xsl:value-of select="@title" /></a></li>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:for-each>
                        </ul>
<!-- nicolaken: ...till here -->
                      </xsl:if>
                    </div>
                  </xsl:for-each>
                </div>
              </xsl:if>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name = "innermenuli">
              <xsl:with-param name="id" select="concat($id, '.', position())"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </div>
  </xsl:template>
  <xsl:template name="mainarea">
    <table cellspacing="0" cellpadding="0" border="0" width="100%">
<!-- ( ================= middle NavBar ================== ) -->
      <tr>
<!-- ============ Breadcrumbs =========== -->
        <td class="subborder trail">
	         &#160;
			 <xsl:if test="not ($config/trail/@location)">
            <xsl:call-template name="breadcrumbs"/>&#160;
             </xsl:if>
        </td>
<!-- ============ Page font settings =========== -->
        <td class="subborder trail" align="right" nowrap="nowrap">
			 &#160;
	       <xsl:if test="$disable-font-script = 'false'">
	        Font size: 
	          &#160;<input type="button" onclick="ndeSetTextSize('reset'); return false;" title="Reset text" class="resetfont" value="Reset"/>      
	          &#160;<input type="button" onclick="ndeSetTextSize('decr'); return false;" title="Shrink text" class="smallerfont" value="-a"/>
	          &#160;<input type="button" onclick="ndeSetTextSize('incr'); return false;" title="Enlarge text" class="biggerfont" value="+a"/>
          </xsl:if>
        </td>
      </tr>
<!-- ( ================= Content================== ) -->
      <tr >
        <td align="left" colspan="2">
          <xsl:apply-templates select="div[@class='content']"/>
        </td>
      </tr>
    </table>
  </xsl:template>
  <xsl:template match="div[@class = 'skinconf-heading-1']">
    <xsl:choose>
      <xsl:when test="//skinconfig/headings/@type='underlined'">
        <table class="h3" cellpadding="0" cellspacing="0" border="0" width="100%">
          <tbody>
            <tr>
              <td width="9" height="10"></td>
              <td>
                <h3>
                  <xsl:value-of select="h1"/>
                </h3>
              </td>
              <td></td>
            </tr>
            <tr class="heading ">
              <td class="bottom-left"></td>
              <td class="bottomborder"></td>
              <td class="bottom-right"></td>
            </tr>
          </tbody>
        </table>
      </xsl:when>
      <xsl:when test="//skinconfig/headings/@type='boxed'">
        <table class="h3 heading" cellpadding="0" cellspacing="0" border="0" width="100%">
          <tbody>
            <tr>
              <td class="top-left"></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <td></td>
              <td>
                <h3>
                  <xsl:value-of select="h1"/>
                </h3>
              </td>
              <td></td>
            </tr>
            <tr>
              <td class=" bottom-left"></td>
              <td></td>
              <td></td>
            </tr>
          </tbody>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <h3 class="h3">
          <xsl:value-of select="h1"/>
        </h3>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="div[@class = 'skinconf-heading-2']">
    <xsl:choose>
      <xsl:when test="//skinconfig/headings/@type='underlined'">
        <table class="h4" cellpadding="0" cellspacing="0" border="0" width="100%">
          <tbody>
            <tr>
              <td width="9" height="10"></td>
              <td>
                <h4>
                  <xsl:value-of select="h1"/>
                </h4>
              </td>
              <td></td>
            </tr>
            <tr class="subheading">
              <td class="bottom-left"></td>
              <td></td>
              <td class="bottom-right"></td>
            </tr>
          </tbody>
        </table>
      </xsl:when>
      <xsl:when test="//skinconfig/headings/@type='boxed'">
        <table class="h4 subheading" cellpadding="0" cellspacing="0" border="0" width="100%">
          <tbody>
            <tr>
              <td class="top-left"></td>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <td></td>
              <td>
                <h4>
                  <xsl:value-of select="h1"/>
                </h4>
              </td>
              <td></td>
            </tr>
            <tr>
              <td class=" bottom-left"></td>
              <td></td>
              <td></td>
            </tr>
          </tbody>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <h4 class="h4">
          <xsl:value-of select="h1"/>
        </h4>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="bottomstrip">
<!-- ( ================= start Footer ================== ) -->
    <table>
      <tr>
        <td>
<!-- using breaks so it scales with font size -->
          <br/>
          <br/>
        </td>
      </tr>
    </table>
    <table class="footer">
      <tr>
        <xsl:if test="//skinconfig/host-logo and not(//skinconfig/host-logo = '')">
          <div class="host">
            <xsl:call-template name="renderlogo">
              <xsl:with-param name="name" select="//skinconfig/host-name"/>
              <xsl:with-param name="url" select="//skinconfig/host-url"/>
              <xsl:with-param name="logo" select="//skinconfig/host-logo"/>
              <xsl:with-param name="root" select="$root"/>
            </xsl:call-template>
          </div>
        </xsl:if>
        <td width="90%" align="center" colspan="2">
          <span class="footnote">
            <xsl:choose>
              <xsl:when test="$config/copyright-link"><a>
                <xsl:attribute name="href">
                  <xsl:value-of select="$config/copyright-link"/>
                </xsl:attribute>
                Copyright &#169; <xsl:value-of select="$config/year"/>&#160;
                <xsl:value-of select="$config/vendor"/></a>
              </xsl:when>
              <xsl:otherwise>
                Copyright &#169; <xsl:value-of select="$config/year"/>&#160;
                <xsl:value-of select="$config/vendor"/>
              </xsl:otherwise>
            </xsl:choose>
            All rights reserved.
            <br/>
<script language="JavaScript" type="text/javascript"><![CDATA[<!--
              document.write(" - "+"Last Published: " + document.lastModified);
              //  -->]]></script>
            <xsl:if test="$config/feedback">
              <xsl:call-template name="feedback"/>
            </xsl:if>
          </span>
        </td>
        <td class="logos" align="right" nowrap="nowrap">
          <xsl:call-template name="compliancy-logos"/>
          <xsl:call-template name="bottom-credit-icons"/>
        </td>
      </tr>
    </table>
<!-- ( ================= end Footer ================== ) -->
  </xsl:template>
  <xsl:template name="bottom-credit-icons">
<!-- old place where to put credits icons-->
<!--
      <xsl:if test="$filename = 'index.html' and //skinconfig/credits">
        <xsl:for-each select="//skinconfig/credits/credit[not(@role='pdf')]">
          <xsl:variable name="name" select="name"/>
          <xsl:variable name="url" select="url"/>
          <xsl:variable name="image" select="image"/>
          <xsl:variable name="width" select="width"/>
          <xsl:variable name="height" select="height"/>
          <a href="{$url}">
            <img alt="{$name} logo" border="0">
              <xsl:attribute name="src">
                <xsl:if test="not(starts-with($image, 'http://'))"><xsl:value-of select="$root"/></xsl:if>
                <xsl:value-of select="$image"/>
              </xsl:attribute>
              <xsl:if test="$width"><xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute></xsl:if>
              <xsl:if test="$height"><xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute></xsl:if>
            </img>
          </a>
        </xsl:for-each>
      </xsl:if>
      -->
  </xsl:template>
</xsl:stylesheet>
