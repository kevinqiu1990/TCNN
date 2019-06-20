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
  <xsl:template match="faqs">
    <document>
      <header>
        <title><xsl:value-of select="@title"/></title>
      </header>
      <body>
        <section>
          <title>Questions</title>
          <xsl:apply-templates select="faq|part"/>
        </section>
      </body>
    </document>
  </xsl:template>
  <xsl:template match="part" mode="index">
    <li><strong>
<!-- Rely on <ol> numbering here -->
<!--<xsl:number level="multiple" count="faq|part" format="1.1. "/> -->
      <xsl:apply-templates select="title"/></strong>
      <ul>
        <xsl:apply-templates select="faq|part" mode="index"/>
      </ul>
      <br /></li>
  </xsl:template>
  <xsl:template match="faq" mode="index">
    <li><xsl:attribute name="id">
        <xsl:call-template name="generate-id"/>
<xsl:text>-menu</xsl:text>
      </xsl:attribute><link>
      <xsl:attribute name="href">
<xsl:text>#</xsl:text>
        <xsl:call-template name="generate-id"/>
      </xsl:attribute>
<!--
		  IMHO adding this makes the tightly-packed menu less legible for
		  little benefit (JT)
	    <xsl:number level="multiple" count="faq|part" format="1.1. "/>
		-->
      <xsl:apply-templates select="question" mode="index"/></link></li>
  </xsl:template>
  <xsl:template match="part">
    <xsl:variable name="id">
      <xsl:call-template name="generate-id"/>
    </xsl:variable>
    <section id="{$id}">
      <title><xsl:number level="multiple" count="faq|part" format="1.1. "/>
        <xsl:value-of select="title"/></title>
      <xsl:apply-templates select="faq|part"/>
    </section>
  </xsl:template>
  <xsl:template match="faq">
    <xsl:variable name="id">
      <xsl:call-template name="generate-id"/>
    </xsl:variable>
    <section id="{$id}">
      <title><xsl:number level="multiple" count="faq|part" format="1.1. "/>
        <xsl:apply-templates select="question"/></title>
      <xsl:apply-templates select="answer"/>
    </section>
  </xsl:template>
  <xsl:template name="generate-id">
    <xsl:choose>
      <xsl:when test="@id">
        <xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(concat(local-name(.), '-'), generate-id(.))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="question" mode="index">
    <xsl:apply-templates select="node()[not(local-name()='elaboration')]"/>
  </xsl:template>
  <xsl:template match="question">
    <xsl:apply-templates/>
  </xsl:template>
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
  <xsl:template match="title">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
