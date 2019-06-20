<?xml version="1.0" encoding="iso-8859-1"?>
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">
  <xsl:param name="pluginDocsVersion"/>
  <xsl:template match="pluginList">
    <document>
      <header>
        <title>Plugins Index</title>
      </header>
      <body>
        <section id="introduction">
          <title>Plugins Index</title>
          <p>
            Plugins are a way of extending Forrest to satisfy site-specific
            needs. If a site requires one or more plugins then the site designer
            will have named them in the <code>project.required.plugins</code>
            property in the projects <code>forrest.properties</code> file. When
            Forrest builds the site it will automatically discover the plugin
            and install it. For more information on how to use plugins see
<!-- See FOR-963 regarding the reasons for this full URL. -->
            <a>
            <xsl:attribute name="href">
<xsl:text>http://forrest.apache.org/pluginDocs/plugins_</xsl:text>
              <xsl:value-of select="$pluginDocsVersion"/>
<xsl:text>/usingPlugins.html</xsl:text>
            </xsl:attribute>
            Extending Forrest with Plugins </a>.
          </p>
          <p>
            This page lists all plugins that have been recognised by the Apache
            Forrest project. There are two sections to this page, the first is
            the released plugins, The second is the whiteboard plugins. Any
            plugins in the released section have been verified as working in the
            versions of Forrest specified. However, this verification does not
            imply that the plugins are mature, merely that they work as
            documented. See the plugin documentation for how mature they are and
            the features they support.
          </p>
          <p>
            The second section lists plugins in the whiteboard, that is plugins
            that may change considerably in how they work before their first
            official release. These plugins may not be fully functional, in most
            cases they are usable, but developers should use them with caution as they are not
            considered stable. You would need to keep up-to-date with the dev@
            mailing list.
          </p>
          <note>
            If you have created a plugin that is not listed here please let us
            know.
          </note>
          <note>
            The minimum version of Forrest is for latest version of the plugin,
            there may be an earlier versions of the plugin for earlier versions
            of Forrest. If you do not define a version number for the plugin it
            will always use the latest version compatible with your version of
            Forrest. However, be aware that if you are using a development
            version of forrest, you will also be using development versions of
            the plugins.
          </note>
          <section>
            <title>Released Plugins</title>
            <xsl:apply-templates select="plugins[@type='released']"/>
          </section>
          <section>
            <title>Whiteboard Plugins</title>
            <warning>
              See <a href="#introduction">introduction</a> for warnings about
              plugins in development.
            </warning>
            <div class="frame note">
              <div class="label">Note</div>
              <div class="content">Plugins in this section may not automatically
              deploy when you run Forrest as they are still in development.
              You may need to perform some manual installation steps to use 
              them. See the plugin documentation for more details.</div>
            </div>
            <xsl:apply-templates select="plugins[@type='whiteboard']"/>
          </section>
        </section>
      </body>
    </document>
  </xsl:template>
  <xsl:template match="plugins">
    <section>
      <title>Input Plugins</title>
      <p>
        Input plugins enable Forrest to work with source documents in different
        formats.
      </p>
      <xsl:choose>
        <xsl:when test="plugin[@type='input']">
          <xsl:apply-templates
            select="plugin[@type='input']">
            <xsl:sort select="@name" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <p>
            No plugins of this type available.
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </section>
    <section>
      <title>Output Plugins</title>
      <p>
        Output plugins enable Forrest to produce documents in different formats.
      </p>
      <xsl:choose>
        <xsl:when test="plugin[@type='output']">
          <xsl:apply-templates
            select="plugin[@type='output']">
            <xsl:sort select="@name" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <p>
            No plugins of this type available.
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </section>
    <section>
      <title>Internal Plugins</title>
      <p>
        Internal plugins change the core behaviour of Forrest.
      </p>
      <xsl:choose>
        <xsl:when test="plugin[@type='internal']">
          <xsl:apply-templates
            select="plugin[@type='internal']">
            <xsl:sort select="@name" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <p>
            No plugins of this type available.
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </section>
  </xsl:template>
  <xsl:template match="plugin">
    <section>
      <title><xsl:value-of select="@name" /></title>
      <table>
        <tr>
          <th width="25%">Description</th>
          <td>
            <xsl:choose>
              <xsl:when test="description/p">
                <xsl:apply-templates
                  select="description" />
              </xsl:when>
              <xsl:otherwise>
                <p>
                  <xsl:apply-templates
                    select="description" />
                </p>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <th width="25%">Author</th>
          <td>
            <xsl:value-of select="@author" />
          </td>
        </tr>
        <tr>
          <th width="25%">Website</th>
          <td><a>
            <xsl:attribute name="href">
              <xsl:value-of select="@website" />
            </xsl:attribute>
            <xsl:value-of select="@website" /></a>
          </td>
        </tr>
        <tr>
          <th width="25%">Download URL:</th>
          <td><a>
            <xsl:attribute name="href">
              <xsl:value-of select="@url" />
            </xsl:attribute>
            <xsl:value-of select="@url" /></a>
          </td>
        </tr>
        <tr>
          <th width="25%">Latest Plugin version</th>
          <td>
            <xsl:value-of select="@version" />
          </td>
        </tr>
        <tr>
          <th width="25%">
            Minimum Forrest version required *
          </th>
          <td>
            <xsl:value-of select="forrestVersion" />
          </td>
        </tr>
        <xsl:if test="../@type='whiteboard'">
          <tr>
            <th width="25%">
              Warning
            </th>
            <td>
              This plugin is in the whiteboard development area.
              See notes in the <a href="#introduction">introduction</a> above.
            </td>
          </tr>
        </xsl:if>
      </table>
    </section>
  </xsl:template>
</xsl:stylesheet>
