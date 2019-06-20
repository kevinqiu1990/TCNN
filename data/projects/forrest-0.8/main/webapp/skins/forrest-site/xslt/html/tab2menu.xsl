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
This stylesheet generates 'tabs' at the top left of the screen.
See the imported tab2menu.xsl for details.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../../common/xslt/html/tab-to-menu.xsl"/>
  <xsl:template match="tabs">
    <div class="tab">
      <table cellspacing="0" cellpadding="0" border="0" summary="tab bar">
        <tr>
          <xsl:call-template name="base-tabs"/>
        </tr>
      </table>
    </div>
    <xsl:if test="tab[@dir=$longest-dir]/tab">
      <div class="level2tab">
        <xsl:call-template name="level2tabs"/>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template name="pre-separator">
    <xsl:call-template name="separator"/>
  </xsl:template>
  <xsl:template name="post-separator"></xsl:template>
  <xsl:template name="separator">
    <td width="6">
      <img src="{$root}skin/images/spacer.gif" width="6" height="8" alt=""/>
    </td>
  </xsl:template>
  <xsl:template name="level2-pre-separator"></xsl:template>
  <xsl:template name="level2-post-separator"></xsl:template>
  <xsl:template name="level2-separator">&#160;|&#160;</xsl:template>
  <xsl:template name="selected">
    <td valign="bottom">
      <table cellspacing="0" cellpadding="0" border="0"  style="height: 1.8em" summary="selected tab">
        <tr>
          <td bgcolor="#4C6C8F" width="5" valign="top">
            <img src="{$skin-img-dir}/tabSel-left.gif" alt="" width="5" height="5" />
          </td>
          <td bgcolor="#4C6C8F" valign="middle">
            <font face="Arial, Helvetica, Sans-serif" size="2" color="#ffffff">
              <b>
                <xsl:call-template name="base-selected"/>
              </b>
            </font>
          </td>
          <td bgcolor="#4C6C8F" width="5" valign="top">
            <img src="{$skin-img-dir}/tabSel-right.gif" alt="" width="5" height="5" />
          </td>
        </tr>
      </table>
    </td>
  </xsl:template>
  <xsl:template name="not-selected">
    <td valign="bottom">
      <table cellspacing="0" cellpadding="0" border="0" style="height: 1.6em" summary="non selected tab">
        <tr>
          <td bgcolor="#B2C4E0" width="5" valign="top">
            <img src="{$skin-img-dir}/tab-left.gif" alt="" width="5" height="5" />
          </td>
          <td bgcolor="#B2C4E0" valign="middle">
            <xsl:call-template name="base-not-selected"/>
          </td>
          <td bgcolor="#B2C4E0" width="5" valign="top">
            <img src="{$skin-img-dir}/tab-right.gif" alt="" width="5" height="5" />
          </td>
        </tr>
        <tr>
          <td height="1" colspan="3"></td>
        </tr>
      </table>
    </td>
  </xsl:template>
  <xsl:template name="level2-not-selected">
    <xsl:call-template name="base-not-selected"/>
  </xsl:template>
  <xsl:template name="level2-selected">
    <xsl:call-template name="base-selected"/>
  </xsl:template>
</xsl:stylesheet>
