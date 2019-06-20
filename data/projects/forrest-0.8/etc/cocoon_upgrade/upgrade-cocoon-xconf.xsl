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
    | Upgrade xconf from cocoon CVS
    |
    +-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


  <xsl:template match="/">
<xsl:comment>
  Licensed to the Apache Software Foundation (ASF) under one or more
  license agreements.  See the NOTICE file distributed with
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
</xsl:comment>
<xsl:comment>
=======================================================================
File created by etc/cocoon_upgrade/upgrade-cocoon-xconf.xsl
Please do not Edit!!!!!
========================================================================
</xsl:comment>

    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="components">

    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="include"/>
      <xsl:apply-templates select="sitemap"/>
      <xsl:apply-templates select="input-modules"/>
      <xsl:apply-templates select="source-factories"/>
      <xsl:apply-templates select="entity-resolver"/>
      <xsl:apply-templates select="xml-parser"/>
      <xsl:apply-templates select="xslt-processor"/>
      <xsl:apply-templates select="component"/>
      <xsl:apply-templates select="xpath-processor"/>
      <xsl:apply-templates select="xmlizer"/>
      <xsl:apply-templates select="transient-store"/>
      <xsl:apply-templates select="store"/>
      <xsl:apply-templates select="persistent-store"/>
      <xsl:apply-templates select="store-janitor"/>
      <xsl:apply-templates select="classloader"/>
      <xsl:apply-templates select="xml-serializer"/>
      <xsl:apply-templates select="xml-deserializer"/>
    </xsl:copy>
  </xsl:template>

  <!-- Whole elements trees that need to be copied as is -->
  <xsl:template match="sitemap|component-instance|xml-parser|xslt-processor|xpath-processor|classloader|xml-serializer|xml-deserializer|include">
    <xsl:copy>
    <xsl:copy-of select="@*"/>
    <!-- FIXME: remove comment() elements -->
    <xsl:copy-of select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Trees with parameter elements so we can avoid comments -->
  <xsl:template match="component|transient-store|store|persistent-store|store-janitor">
    <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:copy-of select="parameter"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="input-modules">
    <xsl:comment>======= Input Modules needed by forrest input module =========</xsl:comment>
    <xsl:element name="input-modules">
    <xsl:apply-templates select="component-instance[@name='request']"/>
    <xsl:apply-templates select="component-instance[@name='request-param']"/>
    <xsl:apply-templates select="component-instance[@name='request-attr']"/>
    <xsl:apply-templates select="component-instance[@name='session-attr']"/>
    <xsl:apply-templates select="component-instance[@name='realpath']"/>
    <xsl:call-template name="forrest-input"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="forrest-input">
    <xsl:comment>======= Forrest Chain =========</xsl:comment>
   
    <component-instance name="forrest">
      <xsl:copy-of select="component-instance[@name='chain']/@logger"/>
      <xsl:copy-of select="component-instance[@name='chain']/@class"/>
      <input-module name="request-param"/>
      <input-module name="request-attr"/>
      <input-module name="session-attr"/>
      <input-module name="defaults"/>
    </component-instance>

    <xsl:comment>======= Defaults Model is replaced by ant using tokens =========</xsl:comment>
    <component-instance name="defaults" class="org.apache.forrest.conf.ForrestConfModule">
      <values>
        <skin>@project.skin@</skin>
        <menu-scheme>@project.menu-scheme@</menu-scheme>
        <bugtracking-url>@project.bugtracking-url@</bugtracking-url>
        <i18n>@project.i18n@</i18n>
        <home>@forrest.home@/</home>
        <context>@context.home@</context>
        <skins-dir>@context.home@/skins/</skins-dir>
        <stylesheets>@context.home@/resources/stylesheets</stylesheets>
      </values>
    </component-instance>

    <xsl:comment>======= "Project" Defaults Model is replaced by ant using tokens =========</xsl:comment>
    <component-instance name="project" class="org.apache.forrest.conf.ForrestConfModule">
      <values>
        <skin>@project.skin@</skin>
        <status>@project.home@/@project.status@</status>
        <skinconf>@project.webapp@/skinconf.xml</skinconf>
        <doc>@project.home@/@project.content-dir@/</doc>
        <content>@project.home@/@project.raw-content-dir@/</content>
        <content.xdocs>@project.home@/@project.xdocs-dir@/</content.xdocs>
        <translations>@project.home@/@project.translations-dir@</translations>
        <resources.stylesheets>@project.home@/@project.stylesheets-dir@/</resources.stylesheets>
        <resources.images>@project.home@/@project.images-dir@/</resources.images>
        <skins-dir>@project.home@/@project.skins-dir@/</skins-dir>
      </values>
    </component-instance>

    <xsl:comment>======= Skinconf Defaults Model is replaced by values on the skinconf.xml file =========</xsl:comment>
    <component-instance name="conf">
      <xsl:copy-of select="component-instance[@name='simplemap']/@logger"/>
      <xsl:copy-of select="component-instance[@name='simplemap']/@class"/>
      <input-module name="skinconf">
        <file src="skinconf.xml" reloadable="true" />
      </input-module>
      <prefix>/skinconfig/</prefix>
    </component-instance>

    <xsl:comment>======= For the site: scheme =========</xsl:comment>
    <component-instance name="linkmap" >
      <xsl:copy-of select="component-instance[@name='myxml']/@logger"/>
      <xsl:copy-of select="component-instance[@name='myxml']/@class"/>
    </component-instance>
    
    <component-instance name="skinconf">
      <xsl:copy-of select="component-instance[@name='myxml']/@logger"/>
      <xsl:copy-of select="component-instance[@name='myxml']/@class"/>
    </component-instance>

    <xsl:comment>======= Links to URIs within the site =========</xsl:comment>
    <component-instance name="site">
      <xsl:copy-of select="component-instance[@name='simplemap']/@logger"/>
      <xsl:copy-of select="component-instance[@name='simplemap']/@class"/>
    </component-instance>

    <xsl:comment>======= Links to external URIs, as distinct from 'site' URIs =========</xsl:comment>
    <component-instance name="ext">
      <xsl:copy-of select="component-instance[@name='simplemap']/@logger"/>
      <xsl:copy-of select="component-instance[@name='simplemap']/@class"/>
    </component-instance>
  </xsl:template>

  <xsl:template match="source-factories">
    <xsl:comment>======= This is needed by the Open Office Support =========</xsl:comment>
    <xsl:element name="source-factories">
      <!-- Needed for the OO source -->
      <component-instance class="org.apache.cocoon.components.source.impl.ZipSourceFactory" name="zip"/>
      <xsl:copy-of select="component-instance"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="entity-resolver">
    <xsl:comment>======= Entity Resolution built-in =========</xsl:comment>
    <xsl:element name="entity-resolver">
      <xsl:copy-of select="@logger"/>
      <parameter name="catalog" value="@forrest.home@/context/resources/schema/catalog.xcat"/>
      <parameter name="local-catalog" value="@local-catalog@"/>
      <parameter name="verbosity" value="@catalog-verbosity@"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xmlizer">
    <xsl:element name="xmlizer">
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="parser"/>
      <parser mime-type="text/html" role="org.apache.excalibur.xml.sax.SAXParser/HTML"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
