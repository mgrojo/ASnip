<?xml version="1.0" encoding="utf-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       xmlns:html="http://www.w3.org/1999/xhtml"
	       version="1.0">

  <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
  <!-- ASnip will have produced HTML output for source files in      -->
  <!-- this directory. This transformation will merge them into the  -->
  <!-- XHTML sample files. The template document should have two     -->
  <!-- identifiable "pre" elements, one for each source snippet.     -->


  <xsl:param name="style-sheet">ada-rm.css</xsl:param>

  <xsl:output method="xml"
	      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	      indent="yes"/>
	  
  <xsl:template match="/">
    <xsl:apply-templates select="html:html"/>
  </xsl:template>

  <xsl:template match="html:html">
    <xsl:element name="html" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>  

  <xsl:template match="html:head">
    <xsl:element name="head">
      <xsl:apply-templates/>
      <xsl:element name="link">
	<xsl:attribute name="type">text/css</xsl:attribute>
	<xsl:attribute name="rel">stylesheet</xsl:attribute>
	<xsl:attribute name="href">
	  <xsl:value-of select="$style-sheet"/>
      </xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- pre is also the root element of the included documents: -->

  <xsl:template match="html:pre[@id='single-language']">
    <xsl:comment>Single language sample</xsl:comment>
    <xsl:copy-of select="document('single.xml')"/>
  </xsl:template>

  <xsl:template match="html:pre[@id='multi-language']">
    <xsl:comment>Multi language sample</xsl:comment>
    <xsl:copy-of select="document('multi.xml')"/>
  </xsl:template>

  <!-- The link to the style sheet used for this sample -->
  <xsl:template match="html:a[@title='style-sheet']">
    <xsl:element name="a">
      <xsl:attribute name="href">
         <xsl:value-of select="$style-sheet"/>
      </xsl:attribute>
      <xsl:value-of  select="$style-sheet"/>
    </xsl:element>
  </xsl:template>

  <!-- The link to the style sheet used for the other sample -->
  <xsl:template match="html:a[@title='style-sheet-alt']">
    <xsl:element name="a">
      <xsl:attribute name="href">
         <xsl:choose>
            <xsl:when test="starts-with($style-sheet, 'ada-rm')">
               <xsl:text>sample-antiq.html</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>sample-rm.html</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:attribute>
      <xsl:value-of  select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="html:*">
    <xsl:element name="{name(.)}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

</xsl:transform>
