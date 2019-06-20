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
  <xsl:output method="xml" indent="yes" />
  <xsl:param name="plugin-name" />
  <xsl:param name="plugin-version" />
  <xsl:param name="plugin-dir"/>
  <xsl:param name="plugin-src-dir"/>
  <xsl:param name="forrest-version" />
  <xsl:template match="plugins">
    <xsl:choose>
      <xsl:when test="plugin[@name=$plugin-name]">
        <project default="fetchplugin">
          <target name="fetchplugin">
            <xsl:attribute name="depends">
              <xsl:if test="$plugin-version">
<xsl:text>fetch-local-versioned-plugin, fetch-remote-versioned-plugin-version-forrest,</xsl:text>
              </xsl:if>
<xsl:text>fetch-local-unversioned-plugin, fetch-remote-unversioned-plugin-version-forrest,</xsl:text>
<xsl:text>fetch-remote-unversioned-plugin-unversion-forrest, final-check</xsl:text>
            </xsl:attribute>
          </target>
          <target name="fetch-local-versioned-plugin">
<!-- Search for the local versionned plugin ...-->
            <antcallback target="get-local" return="plugin-found">
              <param name="local-plugin-version">
                <xsl:attribute name="value">-<xsl:value-of select="$plugin-version" />
                </xsl:attribute>
              </param>
              <param name="local-plugin-name">
                <xsl:attribute name="value">
                  <xsl:value-of select="$plugin-name" />
                </xsl:attribute>
              </param>
            </antcallback>
          </target>
          <target name="fetch-remote-versioned-plugin-version-forrest" unless="plugin-found">
<!-- Search for the remote versionned plugin in the versionned Forrest...-->
            <antcallback target="download" return="plugin-found,desired.plugin.zip.present">
              <param name="download-plugin-version">
                <xsl:attribute name="value">-<xsl:value-of select="$plugin-version" />
                </xsl:attribute>
              </param>
              <param name="download-plugin-name">
                <xsl:attribute name="value">
                  <xsl:value-of select="$plugin-name" />
                </xsl:attribute>
              </param>
              <param name="download-forrest-version">
                <xsl:attribute name="value">
                  <xsl:value-of select="$forrest-version" />/</xsl:attribute>
              </param>
            </antcallback>
          </target>
          <target name="fetch-local-unversioned-plugin" unless="plugin-found">
<!-- Search for the local unversionned plugin ...-->
            <antcallback target="get-local" return="plugin-found">
              <param name="local-plugin-version" value=""/>
              <param name="local-plugin-name">
                <xsl:attribute name="value">
                  <xsl:value-of select="$plugin-name" />
                </xsl:attribute>
              </param>
            </antcallback>
          </target>
          <target name="fetch-remote-unversioned-plugin-version-forrest" unless="plugin-found">
<!-- Search for the remote unversionned plugin in the versionned Forrest...-->
            <antcallback target="download" return="plugin-found,desired.plugin.zip.present">
              <param name="download-plugin-version" value=""/>
              <param name="download-plugin-name">
                <xsl:attribute name="value">
                  <xsl:value-of select="$plugin-name" />
                </xsl:attribute>
              </param>
              <param name="download-forrest-version">
                <xsl:attribute name="value">
                  <xsl:value-of select="$forrest-version" />/</xsl:attribute>
              </param>
            </antcallback>
          </target>
          <target name="fetch-remote-unversioned-plugin-unversion-forrest" unless="plugin-found">
<!-- Search for the remote unversionned plugin in the unversionned Forrest...-->
            <antcallback target="download" return="plugin-found,desired.plugin.zip.present">
              <param name="download-plugin-version" value=""/>
              <param name="download-plugin-name">
                <xsl:attribute name="value">
                  <xsl:value-of select="$plugin-name" />
                </xsl:attribute>
              </param>
              <param name="download-forrest-version" value=""/>
            </antcallback>
          </target>
          <target name="get-local">
            <echo>Trying to locally get ${local-plugin-name}${local-plugin-version}</echo>
            <trycatch property="plugin-found">
              <try>
                <for param="plugin-src-dir">
                  <xsl:attribute name="list">
                    <xsl:value-of select="$plugin-src-dir" />
                  </xsl:attribute>
                  <sequential>
                    <echo>Looking in local @{plugin-src-dir}</echo>
                    <if>
                      <available property="plugin.src.present" type="dir">
                        <xsl:attribute name="file">@{plugin-src-dir}/${local-plugin-name}${local-plugin-version}</xsl:attribute>
                      </available>
                      <then>
                        <echo message="Found !"/>
                        <ant target="local-deploy">
                          <xsl:attribute name="antfile">@{plugin-src-dir}/${local-plugin-name}${local-plugin-version}/build.xml</xsl:attribute>
                          <xsl:attribute name="dir">@{plugin-src-dir}/${local-plugin-name}${local-plugin-version}</xsl:attribute>
                          <property name="no.echo.init" value="true"/>
                        </ant>
                        <fail/>
                      </then>
                    </if>
                  </sequential>
                </for>
              </try>
              <catch>
                <echo>Plugin ${local-plugin-name}${local-plugin-version} deployed ! Ready to configure</echo>
              </catch>
            </trycatch>
          </target>
          <target name="download" depends="keep-original-zip,get-from-remote-site,is-downloaded,remove-original-zip"/>
          <target name="keep-original-zip" depends="available-original-zip" if="original.zip.exists">
            <copy preservelastmodified="true">
              <xsl:attribute name="file">
                <xsl:value-of select="$plugin-dir"/>${download-plugin-name}.zip</xsl:attribute>
              <xsl:attribute name="tofile">
                <xsl:value-of select="$plugin-dir"/>${download-plugin-name}.zip.orig</xsl:attribute>
            </copy>
          </target>
          <target name="available-original-zip">
            <available property="original.zip.exists">
              <xsl:attribute name="file">
                <xsl:value-of select="$plugin-dir"/>${download-plugin-name}.zip</xsl:attribute>
            </available>
          </target>
          <target name="get-from-remote-site">
            <echo>Tying to download ${download-plugin-name}${download-plugin-version} from the distribution site ...</echo>
<!-- FIXME the following test does not work... -->
            <if>
              <not>
                <equals arg2="">
                  <xsl:attribute name="arg1">${download.forrest.version}</xsl:attribute>
                </equals>
              </not>
              <then>
                <echo>Using Forrest version : ${download-forrest-version}</echo>
              </then>
            </if>
<!-- Get from the remote URL -->
            <get verbose="true" usetimestamp="true" ignoreerrors="true">
              <xsl:attribute name="src">
                <xsl:value-of select="plugin[@name=$plugin-name]/@url" />/${download-forrest-version}${download-plugin-name}${download-plugin-version}.zip</xsl:attribute>
              <xsl:attribute name="dest">
                <xsl:value-of select="$plugin-dir"/>${download-plugin-name}.zip</xsl:attribute>
            </get>
<!-- Check if a zip has been downloaded from this URL -->
            <available property="desired.plugin.zip.present">
              <xsl:attribute name="file">
                <xsl:value-of select="$plugin-dir"/>${download-plugin-name}.zip</xsl:attribute>
            </available>
            <condition property="plugin-found">
<!-- or -->
              <and>
                <isset property="desired.plugin.zip.present"/>
                <not>
                  <isset property="original.zip.exists"/>
                </not>
              </and>
            </condition>
          </target>
          <target name="is-downloaded" if="original.zip.exists">
<!-- Check is the downloaded file is more recent than the original zip ... -->
            <uptodate property="no-difference-found">
              <xsl:attribute name="srcfile">
                <xsl:value-of select="$plugin-dir"/>${download-plugin-name}.zip</xsl:attribute>
              <xsl:attribute name="targetfile">
                <xsl:value-of select="$plugin-dir"/>${download-plugin-name}.zip.orig</xsl:attribute>
            </uptodate>
<!-- If there are differences, the plugin is found -->
            <if>
              <not>
                <isset property="no-difference-found"/>
              </not>
              <then>
                <property name="plugin-found" value="true"/>
              </then>
            </if>
          </target>
          <target name="remove-original-zip" if="original.zip.exists">
<!-- Now, we can delete the original -->
            <delete>
              <xsl:attribute name="file">
                <xsl:value-of select="$plugin-dir"/>${download-plugin-name}.zip.orig</xsl:attribute>
            </delete>
          </target>
          <target name="final-check" depends="has-been-downloaded,downloaded-message,uptodate-message,not-found-message"/>
          <target name="has-been-downloaded" if="desired.plugin.zip.present">
            <condition property="up-to-date">
              <not>
                <isset property="plugin-found"/>
              </not>
            </condition>
            <condition property="downloaded">
              <isset property="plugin-found"/>
            </condition>
          </target>
          <target name="downloaded-message" if="downloaded">
            <echo>Plugin <xsl:value-of select="$plugin-name" /> downloaded ! Ready to install</echo>
          </target>
          <target name="uptodate-message" if="up-to-date">
            <echo>Plugin <xsl:value-of select="$plugin-name" /> was up-to-date ! Ready to configure</echo>
            <property name="plugin-found" value="true"/>
          </target>
          <target name="not-found-message" unless="desired.plugin.zip.present">
            <fail>
  Unable to download the
  "<xsl:value-of select="$plugin-name" />" plugin
  <xsl:if test="$plugin-version">version <xsl:value-of select="$plugin-version"/>
              </xsl:if>
  or an equivalent unversioned plugin
  from <xsl:value-of select="plugin[@name=$plugin-name]/@url" />
  There are a number of possible causes for this:

  One possible problem is that you do not have write access to
  FORREST_HOME, in which case ask your system admin to install the
  required Forrest plugin as described below.

  A further possibility is that Forrest may be unable to connect to
  the plugin distribution server. Again the solution is to manually
  install the plugin.

  To manually install a plugin, download the plugin zip file from
  <xsl:value-of select="plugin[@name=$plugin-name]/@url"/> and
  extract it into
  <xsl:value-of select="$plugin-dir"/>
              <xsl:value-of select="$plugin-name" />
            </fail>
          </target>
        </project>
      </xsl:when>
      <xsl:otherwise>
        <project default="findPlugin">
          <target name="findPlugin"/>
        </project>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="plugin"></xsl:template>
</xsl:stylesheet>
