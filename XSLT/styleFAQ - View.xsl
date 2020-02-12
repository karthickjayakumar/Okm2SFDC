<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:java="http://xml.apache.org/xslt/java" xmlns:str="http://exslt.org/strings">
<xsl:output method="text" omit-xml-declaration="yes" indent="yes"/>
<xsl:param name="HTMLPATH"/>
<xsl:param name="HTMLFOLDERNAME"/>
<xsl:param name="singlequote">"</xsl:param>
<xsl:variable name="sQuotes">"</xsl:variable>
<xsl:variable name="VQuotes">""</xsl:variable>
<xsl:variable name="existFlag">false</xsl:variable>
<xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
         select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>
<xsl:template match="/">DOCUMENTID,VIEWS,ATTACHMENTS
<xsl:for-each select="//CONTENTS/FAQ_WRAPPER[@MASTERLOCALEVERSION = 'Y']/CONTENT">
	<!--<xsl:for-each select="//CONTENTS/CONTENT">-->
		<xsl:value-of select="concat(DOCUMENTID,',')"/>
		<xsl:element name="view">
			<xsl:variable name="view_Value">
				<xsl:for-each select="VIEWS/VIEW">
				<xsl:if test="REFERENCE_KEY!=''">
					<xsl:value-of select="concat(';',REFERENCE_KEY)"/>
				</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:value-of select="substring($view_Value,2)"/>
		</xsl:element>
		<xsl:value-of select="','"/>
		<xsl:element name="file">
			<xsl:variable name="file_Value">
				<xsl:for-each select="FAQS/ATTACHMENTS">
					<xsl:if test="FILE!=''">
						<xsl:value-of select="concat(';',FILE)"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:value-of select="substring($file_Value,2)"/>
		</xsl:element>
		<xsl:value-of select="concat(',','&#xA;')"/>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>