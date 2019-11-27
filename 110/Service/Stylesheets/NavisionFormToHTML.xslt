<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" standalone="yes" omit-xml-declaration ="yes"/>
	<xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
      </head>
			<xsl:call-template name="output-fonts"/>
			<xsl:call-template name="output-styles"/>
			<xsl:call-template name="output-divs"/>
			<xsl:call-template name="output-document-properties"/>
			<xsl:call-template name="output-body"/>
		</html>
	</xsl:template>
	<xsl:template name="output-fonts">

	</xsl:template>
	<xsl:template name="output-styles">
    <style type="text/css">
			Body 
      {
			font-size: 8pt;
			font-family: Arial;
			color:		"#000000";
			background:	"#ffffff";
			margin:	20px;
			}

			.Header
			{
			font-size: 14pt;
			font-family: Arial;
			color:		"#333399";
			}

			.MainHeader
			{
			font-size: 14pt;
			font-family: Arial;
			color:		"#000000";
			padding: 10px;
			background-color: #add8e6;
			width: 100%;
			text-align: center;
			border-right: #000000 1px solid;
			border-top: #000000 1px solid;
			border-left: #000000 1px solid;
			border-bottom: #000000 double;
			}

			table.TableStyle 
      {
			font-size: 8pt;
			font-family: Arial;
			border-width: 1px;
			border-style: outset;
			border-color: gray;
			border-collapse: collapse;
			background-color: white;
			}
      
			table.TableStyle th 
      {
			border-width: 1px;
			padding: 2px;
			border-style: inset;
			border-color: gray;
			background-color: white;
			}
      
			table.TableStyle td 
      {
			border-width: 1px;
			padding: 2px;
			border-style: inset;
			border-color: gray;
			background-color: white;
			}

			table.TableStyleTabPage 
      {
			width:50%;
			font-size: 8pt;
			font-family: Arial;
			border-width: 1px;
			border-style: outset;
			border-color: gray;
			border-collapse: collapse;
			background-color: white;
			}
      
			table.TableStyleTabPage th 
      {
			border-width: 1px;
			padding: 2px;
			border-style: inset;
			border-color: gray;
			background-color: white;
			}
      
			table.TableStyleTabPage td 
      {
			width:50%;
			border-width: 1px;
			padding: 2px;
			border-style: inset;
			border-color: gray;
			background-color: white;
			}
		</style>
	</xsl:template>
	<xsl:template name="output-divs">

	</xsl:template>
	<xsl:template name="output-document-properties">

	</xsl:template>

	<xsl:template name="output-body">
		<body>			
				<xsl:call-template name="output-section-properties"/>			
		</body>
	</xsl:template>

	<xsl:template name="output-section-properties">
		<p>
      <span class="MainHeader">
        <xsl:choose>
          <xsl:when test="//Object/@url!=''">
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="//Object/@url"/>
              </xsl:attribute>
              <xsl:value-of select="//Object/@caption"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="//Object/@caption"/>
          </xsl:otherwise>
        </xsl:choose>
      </span>
    </p>
		<p>
			<xsl:value-of select="//Object/Header/CompanyName"/>
		</p>
		<xsl:apply-templates select="Object/Control"/>
	</xsl:template>

	<xsl:template match="Control[@type='TabControl']">
		<xsl:apply-templates select="./Control"/>
	</xsl:template>
  <xsl:template match="Control[@type='FactBox']">
  </xsl:template>
  <xsl:template match="Control[@type='TabPage']">

			<br/>
			<span class="Header">
				<xsl:value-of select="@caption"/>
			</span>
			<br/>
			<table class="TableStyleTabPage">
				<xsl:apply-templates select="Row" mode="TabPage"/>
			</table>
	</xsl:template>
	<xsl:template match="Control[@type='TableBox']">
    <xsl:if test="@caption">
      <br/>
      <span class="Header">
        <xsl:value-of select="@caption"/>
      </span>
      <br/>
    </xsl:if>
    <table width="780">
			<tr>
				<td>
					<table class="TableStyle">
						<xsl:apply-templates select="Row" mode="TableBox"/>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="Control[@type='Frame']">
		<br/>
		<span class="Header">
			<xsl:value-of select="@caption"/>
		</span>
		<br/>
		<table class="TableStyleTabPage">
			<xsl:apply-templates select="Row" mode="Frame"/>
		</table>
	</xsl:template>
	<xsl:template match="Row" mode="TabPage">
		<tr>
			<xsl:apply-templates select="./Control"/>
		</tr>
	</xsl:template>
	<xsl:template match="Row" mode="TableBox">
		<tr>
			<xsl:apply-templates select="./Control"/>
		</tr>
	</xsl:template>
	<xsl:template match="Row" mode="Frame">
		<tr>
			<xsl:apply-templates select="./Control"/>
		</tr>
	</xsl:template>
	<xsl:template match="Control[@type='Label']">
		<td><b><xsl:value-of select="@value"/></b></td>
	</xsl:template>
	<xsl:template match="Control[@type='TextBox']">
		<td><xsl:value-of select="@value"/></td>
	</xsl:template>
	<xsl:template match="Control[@type='CheckBox']">
		<td><xsl:value-of select="@value"/></td>
	</xsl:template>
</xsl:stylesheet>