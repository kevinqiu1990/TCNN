<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>

 <xsl:output method='text'/>

 <xsl:template match='/dtd'>
  <xsl:if test='@sysid'>
   <xsl:comment>Generated from <xsl:value-of select='@sysid'/></xsl:comment>
  <xsl:text>
</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
 </xsl:template>

 <xsl:template match='elementDecl'>
  <xsl:text>&lt;!ELEMENT </xsl:text>
  <xsl:value-of select='@ename'/>
  <xsl:text> </xsl:text>
  <xsl:value-of select='@model'/>
  <xsl:text>&gt;
</xsl:text>
 </xsl:template>

 <xsl:template match='attlist'>
  <xsl:text>&lt;!ATTLIST </xsl:text>
  <xsl:value-of select='@ename'/>
  <xsl:text> </xsl:text>
  <xsl:for-each select='.//attributeDecl'>
   <xsl:if test='position()&gt;1'>
    <xsl:text>
</xsl:text>
    <xsl:call-template name='indent'>
     <xsl:with-param name='length'><xsl:value-of select='11+string-length(@ename)'/></xsl:with-param>
    </xsl:call-template>
   </xsl:if>
   <xsl:apply-templates select='.'/>
  </xsl:for-each>
  <xsl:text>&gt;
</xsl:text>
 </xsl:template>

 <xsl:template match='attributeDecl'>
  <xsl:value-of select='@aname'/>
  <xsl:text> </xsl:text>
  <xsl:value-of select='@atype'/>
  <xsl:if test='@atype="NOTATION"'>
   <xsl:text> (</xsl:text>
   <xsl:for-each select='enumeration'>
    <xsl:if test='position()&gt;1'>|</xsl:if>
    <xsl:value-of select='@value'/>
   </xsl:for-each>
   <xsl:text>)</xsl:text>
  </xsl:if>
  <xsl:choose>
   <xsl:when test='@required'> #REQUIRED</xsl:when>
   <xsl:when test='@fixed'> #FIXED</xsl:when>
   <xsl:when test='not(@default)'> #IMPLIED</xsl:when>
  </xsl:choose>
  <xsl:if test='@default'>
   <xsl:text> "</xsl:text>
   <xsl:call-template name='escape'>
    <xsl:with-param name='s'><xsl:value-of select='@default'/></xsl:with-param>
   </xsl:call-template>
   <xsl:text>"</xsl:text>
  </xsl:if>
 </xsl:template>

 <xsl:template match='internalEntityDecl[not(contains(@name,"%"))]'>
  <xsl:text>&lt;!ENTITY </xsl:text>
  <xsl:value-of select='@name'/>
  <xsl:text> "</xsl:text>
  <xsl:call-template name='escape'>
   <xsl:with-param name='s'>
    <xsl:call-template name='escape'>
     <xsl:with-param name='s'><xsl:value-of select='@value'/></xsl:with-param>
    </xsl:call-template>
   </xsl:with-param>
   <xsl:with-param name='c'>%</xsl:with-param>
   <xsl:with-param name='C'>&amp;#37;</xsl:with-param>
  </xsl:call-template>
  <xsl:text>"&gt;
</xsl:text>
 </xsl:template>

 <xsl:template match='externalEntityDecl[not(contains(@name,"%"))]'>
  <xsl:text>&lt;!ENTITY </xsl:text>
  <xsl:value-of select='@name'/>
  <xsl:choose>
   <xsl:when test='@pubid'>
    <xsl:text> PUBLIC "</xsl:text>
    <xsl:value-of select='@pubid'/>
    <xsl:text>"</xsl:text>
   </xsl:when>
   <xsl:otherwise> SYSTEM</xsl:otherwise>
  </xsl:choose>
  <xsl:text> "</xsl:text>
  <xsl:value-of select='@sysid'/>
  <xsl:text>"&gt;
</xsl:text>
 </xsl:template>

 <xsl:template match='unparsedEntityDecl'>
  <xsl:text>&lt;!ENTITY </xsl:text>
  <xsl:value-of select='@name'/>
  <xsl:choose>
   <xsl:when test='@pubid'>
    <xsl:text> PUBLIC "</xsl:text>
    <xsl:value-of select='@pubid'/>
    <xsl:text>"</xsl:text>
   </xsl:when>
   <xsl:otherwise> SYSTEM</xsl:otherwise>
  </xsl:choose>
  <xsl:if test='@sysid'>
   <xsl:text> "</xsl:text>
   <xsl:value-of select='@sysid'/>
   <xsl:text>"</xsl:text>
  </xsl:if>
  <xsl:text> NDATA </xsl:text>
  <xsl:value-of select='@notation'/>
  <xsl:text>&gt;
</xsl:text>
 </xsl:template>

 <xsl:template match='notationDecl'>
  <xsl:text>&lt;!NOTATION </xsl:text>
  <xsl:value-of select='@name'/>
  <xsl:choose>
   <xsl:when test='@pubid'>
    <xsl:text> PUBLIC "</xsl:text>
    <xsl:value-of select='@pubid'/>
    <xsl:text>"</xsl:text>
   </xsl:when>
   <xsl:otherwise> SYSTEM</xsl:otherwise>
  </xsl:choose>
  <xsl:if test='@sysid'>
   <xsl:text> "</xsl:text>
   <xsl:value-of select='@sysid'/>
   <xsl:text>"</xsl:text>
  </xsl:if>
  <xsl:text>&gt;
</xsl:text>
 </xsl:template>

 <xsl:template match='conditional'>
  <xsl:text>&lt;![</xsl:text>
  <xsl:value-of select='@type'/>
  <xsl:text>[</xsl:text>
  <xsl:if test='@type="INCLUDE"'>
   <xsl:text>
</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:text>]]&gt;
</xsl:text>
 </xsl:template>

 <xsl:template match='ignoredCharacters'>
  <xsl:value-of select='text()'/>
 </xsl:template>

 <xsl:template match='comment'>
  <xsl:text>&lt;!--</xsl:text>
  <xsl:value-of select='text()'/>
  <xsl:text>--&gt;
</xsl:text>
 </xsl:template>

 <xsl:template match='processingInstruction'>
  <xsl:text>&lt;?</xsl:text>
  <xsl:value-of select='@target'/>
  <xsl:if test='@data'>
   <xsl:text> </xsl:text>
   <xsl:value-of select='@data'/>
  </xsl:if>
  <xsl:text>?&gt;
</xsl:text>
 </xsl:template>

 <xsl:template name='indent'>
  <xsl:param name='length'>0</xsl:param>
  <xsl:if test='$length&gt;0'>
   <xsl:text> </xsl:text>
   <xsl:call-template name='indent'>
    <xsl:with-param name='length'><xsl:value-of select='number($length)-1'/></xsl:with-param>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

 <xsl:template name='escape'>
  <xsl:param name='s'/>
  <xsl:param name='c'>"</xsl:param>
  <xsl:param name='C'>&amp;#34;</xsl:param>
  <xsl:if test='string-length($s)&gt;0'>
   <xsl:choose>
    <xsl:when test='contains($s,$c)'>
     <xsl:value-of select='substring-before($s,$c)'/>
     <xsl:value-of select='$C'/>
     <xsl:call-template name='escape'>
      <xsl:with-param name='s'>
       <xsl:value-of select='substring(substring-after($s,$c),2)'/>
      </xsl:with-param>
     </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select='$s'/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:if>
 </xsl:template>

</xsl:stylesheet>
