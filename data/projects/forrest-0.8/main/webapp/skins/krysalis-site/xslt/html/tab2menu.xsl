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
This stylesheet generates 'tabs' at the top left of the Forrest skin.  Tabs are
visual indicators that a certain subsection of the URI space is being browsed.
For example, if we had tabs with paths:

Tab1:  ''
Tab2:  'community'
Tab3:  'community/howto'
Tab4:  'community/howto/xmlform/index.html'

Then if the current path was 'community/howto/foo', Tab3 would be highlighted.
The rule is: the tab with the longest path that forms a prefix of the current
path is enabled.

The output of this stylesheet is HTML of the form:
    <table class="tab">
      ...
    </table>
    <table class="level2tab">
      ...
    </table>

which is then merged by site2xhtml.xsl

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../../common/xslt/html/tab-to-menu.xsl"/>
  <xsl:template match="tabs">
    <table class="tab" cellspacing="0" cellpadding="0" border="0">
      <tr>
        <xsl:call-template name="base-tabs"/>
      </tr>
    </table>
    <xsl:if test="tab[@dir=$longest-dir]/tab">
      <table class="level2tab" cellspacing="0" cellpadding="0" border="0">
        <tr>
          <td>
            <xsl:call-template name="level2tabs"/>
          </td>
        </tr>
      </table>
    </xsl:if>
  </xsl:template>
  <xsl:template name="pre-separator">
    <td class="tab pre-separator"></td>
  </xsl:template>
  <xsl:template name="post-separator"></xsl:template>
  <xsl:template name="separator">
    <td class="tab separator"></td>
  </xsl:template>
  <xsl:template name="level2-pre-separator">
    <td class="tab pre-separator"></td>
  </xsl:template>
  <xsl:template name="level2-post-separator"></xsl:template>
  <xsl:template name="level2-separator">
    <td class="level2tab separator">|</td>
  </xsl:template>
  <xsl:template name="selected">
    <td class="tab selected top-left TSTL"></td>
    <td class="tab selected">
      <xsl:call-template name="base-selected"/>
    </td>
    <td class="tab selected top-right TSTR"></td>
  </xsl:template>
  <xsl:template name="not-selected">
    <td>
      <table cellspacing="0" cellpadding="0" border="0">
        <tr>
          <td class="tab unselected top-left TUTL"></td>
          <td class="tab unselected corner">
            <xsl:call-template name="base-not-selected"/>
          </td>
          <td class="tab unselected top-right TUTR"></td>
        </tr>
        <tr>
          <td colspan="3" class="spacer"/>
        </tr>
      </table>
    </td>
  </xsl:template>
  <xsl:template name="level2-selected">
    <td class="level2tab selected">
      <xsl:call-template name="base-selected"/>
    </td>
  </xsl:template>
  <xsl:template name="level2-not-selected">
    <td class="level2tab unselected">
      <xsl:call-template name="base-not-selected"/>
    </td>
  </xsl:template>
</xsl:stylesheet>
