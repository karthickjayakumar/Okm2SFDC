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
<!-- <xsl:template name="escape_comma">
    <xsl:param name="field" />
	<xsl:choose>
		 <xsl:when test="contains( $field, ',' )">
			<xsl:text>"</xsl:text>
			<xsl:value-of select="$field" />
			<xsl:text>"</xsl:text>
         </xsl:when>
		 <xsl:otherwise>
			<xsl:value-of select="$field" />
		 </xsl:otherwise>
	</xsl:choose>
</xsl:template> 
<xsl:template name="escape_comma">
    <xsl:param name="field" />
			<xsl:text>"</xsl:text>
			<xsl:value-of select="$field" />
			<xsl:text>"</xsl:text>
</xsl:template>-->
<xsl:template match="/">Title,RECORDTYPEID,channels,Answer,Keywords,Embedded video,Language,Review date,Category,Sub-Category,Customer Support Journey,Customer Classification,Case ID,Legacy Doc ID,Related articles,Url,First publication date,Last publication date,Created date,Created by,Last modified date,Last modified by,Owner,Internal comments
<xsl:for-each select="//CONTENTS/FAQ_WRAPPER[@MASTERLOCALEVERSION = 'Y']/CONTENT">
	<xsl:element name="TITLE">
			<xsl:variable name="myTitle">
			  <xsl:call-template name="string-replace-all">
				<xsl:with-param name="text" select="FAQS/QUESTION" />
				<xsl:with-param name="replace" select="$sQuotes" />
				<xsl:with-param name="by" select="$VQuotes" />
			  </xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="concat($singlequote,$myTitle,$singlequote,',')" />
	</xsl:element>
	<xsl:value-of select="concat('0121H000001NGGc',',')"/>
     <xsl:choose>
		<xsl:when test="SECURITY/USERGROUP/REFERENCE_KEY = 'EXTERNAL'">
			<xsl:value-of select="concat('application+sites',',')"/> 
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat('application',',')"/> 
		</xsl:otherwise>
	</xsl:choose>
	<xsl:value-of select="concat($HTMLFOLDERNAME,java:convertXMLToOCSVandHTML.convertXMLToHTMLFile(DOCUMENTID,FAQS/ANSWER,$HTMLPATH),',')"/>
	<xsl:element name="COMMA">
        <xsl:variable name="myComma">
          <xsl:call-template name="string-replace-all">
            <xsl:with-param name="text" select="FAQS/KEYWORDS" />
            <xsl:with-param name="replace" select="$sQuotes" />
            <xsl:with-param name="by" select="$VQuotes" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat($singlequote,$myComma,$singlequote)" />
	</xsl:element>
	<xsl:value-of select="concat(',,',LOCALECODE,',,','PROD - Product specific',',,')"/>
	<xsl:element name="SP1">
	<xsl:variable name="SP1_Value">
		<xsl:for-each select="CATEGORIES/CATEGORY">
			<xsl:choose>
				<xsl:when test="contains(REFERENCE_KEY, 'SP1_')">
					<xsl:if test="REFERENCE_KEY = 'SP1_TROUBLESHOOTING'">
						<xsl:value-of select="concat('_','TRB')"/>  
					</xsl:if>
					<xsl:if test="REFERENCE_KEY = 'SP1_PRODUCT_SELECTION_AND_SERVICES'">
						<xsl:value-of select="concat('_','SEL')"/>
					</xsl:if>
					<xsl:if test="REFERENCE_KEY = 'SP1_INSTALLATION_SETUP'">
						<xsl:value-of select="concat('_','INS')"/>
					</xsl:if>
					<xsl:if test="REFERENCE_KEY = 'SP1_ADDITIONAL_DOCUMENTATION_REQUEST'">
						<xsl:value-of select="concat('_','DOC')"/>
					</xsl:if>
					<xsl:if test="REFERENCE_KEY = 'SP1_DOCUMENTATION_MISSING_OR_INCORRECT'">
						<xsl:value-of select="concat('_','DOC')"/>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		</xsl:variable>
	<xsl:choose>
     <xsl:when test="$SP1_Value !=''">
           <xsl:value-of select="substring($SP1_Value,2)"/>
     </xsl:when>
     <xsl:otherwise>
          <xsl:value-of select="'Not Found'"/>
     </xsl:otherwise>
    </xsl:choose>
	</xsl:element>
	<xsl:value-of select="','"/>
	<xsl:element name="CC1">
		<xsl:variable name="CC1_Value">
		<xsl:for-each select="CATEGORIES/CATEGORY">
			<xsl:choose>
				<xsl:when test=" contains(REFERENCE_KEY, 'CC1_')">
					<xsl:if test="REFERENCE_KEY = 'CC1_SYSTEM_INTEGRATOR'">
						<xsl:value-of select="concat(';','SI')"/>
					</xsl:if>
					<xsl:if test="REFERENCE_KEY = 'CC1_ORIGINAL_EQUIPMENT_MANUFACTURER'">
						<xsl:value-of select="concat(';','OM')"/>
					</xsl:if>
					<xsl:if test="REFERENCE_KEY = 'CC1_ELECTRICIANS'">
						<xsl:value-of select="concat(';','SC')"/>
					</xsl:if>
					<xsl:if test="REFERENCE_KEY = 'CC1_END_USER_CUSTOMER'">
						<xsl:value-of select="concat(';','EU')"/>
					</xsl:if>
					<xsl:if test="REFERENCE_KEY = 'CC1_PANEL_BUILDER'">
						<xsl:value-of select="concat(';','PB')"/>
					</xsl:if>
					<xsl:if test="REFERENCE_KEY = 'CC1_WHOLESALE_DISTRIBUTOR'">
						<xsl:value-of select="concat(';','WD')"/>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		</xsl:variable>
		<xsl:choose>
     <xsl:when test="$CC1_Value !=''">
           <xsl:value-of select="substring($CC1_Value,2)"/>
     </xsl:when>
     <xsl:otherwise>
          <xsl:value-of select="'Not Found'"/>
     </xsl:otherwise>
    </xsl:choose>
	</xsl:element>
	<xsl:value-of select="concat(',,',DOCUMENTID,',,,,',PUBLISHEDDATE,',',CREATEDATE,',,',LASTMODIFIEDDATE,',',LASTMODIFIER,',',OWNER)"/>
	<xsl:value-of select="concat(',,','&#xA;')"/>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>