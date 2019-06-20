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
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
  <xsl:import href="copyover.xsl"/>
<!-- Processing a raw howto without revisions -->
  <xsl:template match="/howto">
    <document>
      <xsl:copy-of select="header"/>
      <body>
        <xsl:apply-templates select="*[not(name()='header')]"/>
      </body>
    </document>
  </xsl:template>
<!-- Processing a howto combined with revisions -->
  <xsl:template match="/all">
    <document>
      <xsl:copy-of select="howto/header"/>
      <body>
        <xsl:apply-templates select="howto"/>
        <xsl:apply-templates select="revisions"/>
      </body>
    </document>
  </xsl:template>
  <xsl:template match="howto">
    <xsl:if test="normalize-space(header/abstract)!=''">
      <xsl:apply-templates select="header/abstract"/>
    </xsl:if>
    <xsl:apply-templates select="*[not(name()='header')]"/>
  </xsl:template>
  <xsl:template match="howto/header/abstract">
    <section id="Overview">
      <title>Overview</title>
      <p>
        <xsl:apply-templates/>
      </p>
    </section>
  </xsl:template>
  <xsl:template match="purpose | prerequisites | audience | steps | extension | tips | references | feedback">
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="normalize-space(@title)!=''">
          <xsl:value-of select="@title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="name()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <section id="{$title}">
      <title><xsl:value-of select="$title"/></title>
      <xsl:apply-templates/>
    </section>
  </xsl:template>
<!-- new faqs format - mostly borrowed from other sections -->
  <xsl:template match="faqs">
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="normalize-space(title)!=''">
          <xsl:apply-templates select="title"/>
        </xsl:when>
        <xsl:when test="normalize-space(@title)!=''">
          <xsl:value-of select="@title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="name()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <section id="{$title}">
      <title><xsl:value-of select="$title"/></title>
      <xsl:apply-templates select="faq"/>
      <xsl:apply-templates select="faqsection | part"/>
    </section>
  </xsl:template>
<!-- an actual faq is composed of a question and answer -->
  <xsl:template match="faq">
    <section>
      <xsl:apply-templates select="question"/>
      <xsl:apply-templates select="answer"/>
    </section>
  </xsl:template>
<!-- numbering a faqsection and adding to the title
    FIXME: maybe an ID should be written out -->
  <xsl:template match="faqsection | part">
    <section>
      <title><xsl:number count="faqsection | part" level="multiple" format="1.1.1 "/>
        <xsl:value-of select="normalize-space(title)"/></title>
      <xsl:apply-templates select="faq"/>
      <xsl:apply-templates select="faqsection | part"/>
    </section>
  </xsl:template>
<!-- numbering the question
    FIXME: maybe an ID of questnnn should be written out -->
  <xsl:template match="question">
    <title><xsl:number count="faqsection | part" level="multiple" format="1.1.1."/>
      <xsl:number count="faq" level="single" format="1 "/>
      <xsl:value-of select="normalize-space(.)"/></title>
    <xsl:apply-templates select="answer"/>
  </xsl:template>
<!-- borrowed from the current faqs stylesheet -->
  <xsl:template match="answer">
    <xsl:if test="count(p)>0">
      <xsl:apply-templates/>
    </xsl:if>
    <xsl:if test="count(p)=0">
      <p>
        <xsl:apply-templates/>
      </p>
    </xsl:if>
  </xsl:template>
  <xsl:template match="revisions">
    <section id="revisions">
      <title>Revisions</title>
      <p>
        Find a problem with this document? Consider contacting the mailing lists
        or submitting your own revision. For instructions, read the How To
        Submit a Revision.
      </p>
      <xsl:if test="revision">
        <ul>
          <xsl:apply-templates select="revision"/>
        </ul>
      </xsl:if>
    </section>
  </xsl:template>
  <xsl:template match="revision">
    <xsl:variable name="href">
      <xsl:value-of select="concat(substring-before(@name,'.xml'),'.html')" />
    </xsl:variable>
    <li>Revision, <link href="{ $href}">
      <xsl:value-of select="@date"/></link></li>
  </xsl:template>
</xsl:stylesheet>
