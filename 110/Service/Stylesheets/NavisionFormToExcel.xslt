<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">
	<xsl:output method="xml" encoding="UTF-8" standalone="yes" />
	<xsl:template match="/">
		<xsl:processing-instruction name="mso-application">
			<xsl:text>progid="Excel.Sheet"</xsl:text>
		</xsl:processing-instruction>
		<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">
			<xsl:call-template name="output-ExcelWorkbook"/>
			<xsl:call-template name="output-Styles"/>
			<xsl:call-template name="output-Worksheet"/>
		</Workbook>
	</xsl:template>
    <xsl:variable name="DecimalSeparator" select="Object/DecimalSeparator"/>
	<xsl:variable name="ThousandSeparator" select="Object/ThousandSeparator"/>
	<xsl:variable name="DateSeparator1" select="Object/DateSeparator1"/>
	<xsl:variable name="DateSeparator2" select="Object/DateSeparator2"/>
	<xsl:template name="output-ExcelWorkbook">
		<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
			<WindowHeight>9300</WindowHeight>
			<WindowWidth>15135</WindowWidth>
			<WindowTopX>120</WindowTopX>
			<WindowTopY>120</WindowTopY>
			<AcceptLabelsInFormulas/>
			<ProtectStructure>False</ProtectStructure>
			<ProtectWindows>False</ProtectWindows>
		</ExcelWorkbook>
	</xsl:template>
	<xsl:template name="output-Styles">
		<Styles xmlns="urn:schemas-microsoft-com:office:spreadsheet">
			<Style ss:ID="Default" ss:Name="Normal">
				<Alignment ss:Vertical="Bottom"/>
				<Borders/>
				<Font/>
				<Interior/>
				<NumberFormat/>
				<Protection/>
			</Style>
			<Style ss:ID="normalSheet" ss:Name="Normal_Sheet1">
				<Interior/>
				<NumberFormat ss:Format="#,##0_);[Red]\(#,##0\)"/>
			</Style>
			<Style ss:ID="formCaption">
				<Font x:Family="Swiss" ss:Size="12" ss:Bold="1"/>	
			</Style>
			<Style ss:ID="tabCaption">
				<Font x:Family="Swiss" ss:Size="11" ss:Color="#333399" ss:Bold="1"/>
			</Style>
			<Style ss:ID="Label">
				<Alignment ss:Horizontal="Left" ss:Vertical="Bottom" ss:WrapText="1"/>
				<Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="8" ss:Bold="1"/>
				<Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
			</Style>
			<Style ss:ID="TextBox">
				<Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
			<Style ss:ID="TextBoxNumber">
				<Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
				<NumberFormat ss:Format="Standard"/>
			</Style>
      <Style ss:ID="TextBoxInteger">
        <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>
        <Font ss:FontName="Verdana" x:Family="Swiss"/>
      </Style>
      <Style ss:ID="TextBoxDate">
        <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
        <Font ss:FontName="Verdana" x:Family="Swiss"/>
        <NumberFormat ss:Format="Short Date"/>
      </Style>
      <Style ss:ID="TextBoxTime">
        <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
        <Font ss:FontName="Verdana" x:Family="Swiss"/>
        <NumberFormat ss:Format="[$-F400]h:mm:ss\ AM/PM"/>
      </Style>
		<Style ss:ID="TextBoxDateTime">
			<Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
			<Font ss:FontName="Verdana" x:Family="Swiss"/>
			<NumberFormat ss:Format="General Date"/>
		</Style>

			<Style ss:ID="CheckBox">
				<Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
				<Font ss:FontName="Verdana" x:Family="Swiss"/>
			</Style>
			<Style ss:ID="rowheading">
				<Font x:Family="Swiss" ss:Bold="1"/>
				<Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
			</Style>
		</Styles>
	</xsl:template>
	<xsl:template name="output-Worksheet">
	<xsl:choose>
		<xsl:when test="Object/descendant-or-self::Control[@type='TableBox']">
			<xsl:apply-templates select="Object/Control" />
		</xsl:when>
		<xsl:when test="Object/descendant-or-self::Control[@type='TabPage']">
			<xsl:apply-templates select="Object/Control" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="Empty" />
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	<xsl:template match="Control[@type='TabControl']">
		<xsl:apply-templates select="./Control"/>
	</xsl:template>
	<xsl:template match="Control[@type='FactBox']">
	</xsl:template>
	<xsl:template match="Control[@type='TabPage']">
		<Worksheet xmlns="urn:schemas-microsoft-com:office:spreadsheet">
      <xsl:attribute name="ss:Name">
        <xsl:call-template name="GetWorksheetName"/>
      </xsl:attribute>
      <Table>
				<xsl:attribute name="ss:ExpandedColumnCount">100</xsl:attribute>
				<xsl:attribute name="ss:ExpandedRowCount">10000</xsl:attribute>
				<Column ss:AutoFitWidth="0" ss:Width="123.75" ss:Span="1"/>
				<Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="111.75"/>
				<Column ss:AutoFitWidth="0" ss:Width="98.25"/>
				<Row>
					<Cell ss:StyleID="formCaption">
						<!--<xsl:attribute name="ss:HRef">
							<xsl:value-of select="//Object/@url"/>
						</xsl:attribute>-->
						<Data ss:Type="String">
							<xsl:value-of select="//Object/@caption"/>
						</Data>
					</Cell>
				</Row>
				<Row>
					<Cell ss:StyleID="tabCaption">
						<Data ss:Type="String">
							<xsl:value-of select="@caption"/>
						</Data>
					</Cell>
				</Row>
				<xsl:apply-templates select="Row" mode="TabPage"/>
			</Table>
			<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
				<Selected/>
				<Panes>
					<Pane>
						<Number>3</Number>
						<ActiveRow>6</ActiveRow>
						<ActiveCol>1</ActiveCol>
					</Pane>
				</Panes>
				<ProtectObjects>False</ProtectObjects>
				<ProtectScenarios>False</ProtectScenarios>
			</WorksheetOptions>
		</Worksheet>
	</xsl:template>
	<xsl:template match="Control[@type='TableBox']">
		<Worksheet xmlns="urn:schemas-microsoft-com:office:spreadsheet">
			<xsl:attribute name="ss:Name">
        <xsl:call-template name="GetWorksheetName"/>
      </xsl:attribute>
			<Table>
				<xsl:attribute name="ss:ExpandedColumnCount"><xsl:value-of select="count(Row[1]/Control)"/></xsl:attribute>
				<xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count(Row) + 2"/></xsl:attribute>

				<xsl:for-each select="Row[1]/Control">
					<Column ss:AutoFitWidth="0">
            <xsl:if test="@width">
						  <xsl:attribute name="ss:Width">
							  <xsl:value-of select="@width * 0.02857"/>
						  </xsl:attribute>
            </xsl:if>
					</Column>
				</xsl:for-each>
				<Row>
					<Cell ss:StyleID="formCaption">
						<Data ss:Type="String">
							<xsl:value-of select="//Object/@caption"/>
						</Data>
					</Cell>
				</Row>
				<xsl:apply-templates select="Row" mode="TableBox"/>
			</Table>
			<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
				<Selected/>
				<Panes>
					<Pane>
						<Number>3</Number>
						<ActiveRow>6</ActiveRow>
						<ActiveCol>1</ActiveCol>
					</Pane>
				</Panes>
				<ProtectObjects>False</ProtectObjects>
				<ProtectScenarios>False</ProtectScenarios>
			</WorksheetOptions>
		</Worksheet>
	</xsl:template>
	<xsl:template match="Control[@type='Frame']">
		<Worksheet xmlns="urn:schemas-microsoft-com:office:spreadsheet">
			<xsl:attribute name="ss:Name">
        <xsl:call-template name="GetWorksheetName"/>
      </xsl:attribute>
      <Table>
        <xsl:attribute name="ss:ExpandedColumnCount">100</xsl:attribute>
        <xsl:attribute name="ss:ExpandedRowCount">10000</xsl:attribute>

        <xsl:for-each select="Row[1]/Control">
          <Column ss:AutoFitWidth="0">
            <xsl:if test="@width">
              <xsl:attribute name="ss:Width">
  							<xsl:value-of select="@width * 0.02857"/>
	  					</xsl:attribute>
            </xsl:if>
          </Column>
				</xsl:for-each>
				<Row>
					<Cell ss:StyleID="formCaption">
						<Data ss:Type="String">
							<xsl:value-of select="//Object/@caption"/>
						</Data>
					</Cell>
				</Row>
				<xsl:apply-templates select="Row" mode="Frame"/>
			</Table>
			<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
				<Selected/>
				<Panes>
					<Pane>
						<Number>3</Number>
						<ActiveRow>6</ActiveRow>
						<ActiveCol>1</ActiveCol>
					</Pane>
				</Panes>
				<ProtectObjects>False</ProtectObjects>
				<ProtectScenarios>False</ProtectScenarios>
			</WorksheetOptions>
		</Worksheet>
	</xsl:template>
	<xsl:template match="Row" mode="TabPage">
		<Row xmlns="urn:schemas-microsoft-com:office:spreadsheet">
			<xsl:apply-templates select="Control"/>
		</Row>
		<xsl:if test="position()!=last()">
			<Row xmlns="urn:schemas-microsoft-com:office:spreadsheet">
				<xsl:for-each select="./Control">
					<Cell>
						<xsl:attribute name="ss:StyleID">
							<xsl:value-of select="@type"/>
						</xsl:attribute>
					</Cell>
				</xsl:for-each>
			</Row>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Row" mode="TableBox">
		<Row xmlns="urn:schemas-microsoft-com:office:spreadsheet">
			<xsl:apply-templates select="Control"/>
		</Row>
	</xsl:template>
	<xsl:template match="Row" mode="Frame">
		<Row xmlns="urn:schemas-microsoft-com:office:spreadsheet">
			<xsl:apply-templates select="Control"/>
		</Row>
	</xsl:template>
	<xsl:template match="Control[@type='Label']">
		<Cell xmlns="urn:schemas-microsoft-com:office:spreadsheet">
			<xsl:attribute name="ss:StyleID">Label</xsl:attribute>
			<Data>
				<xsl:attribute name="ss:Type">String</xsl:attribute>
				<xsl:value-of select="@value"/>
			</Data>
		</Cell>
	</xsl:template>
  <xsl:template match="Control[@type='TextBox']">
    <Cell xmlns="urn:schemas-microsoft-com:office:spreadsheet" ss:StyleID="TextBox">
      <Data ss:Type="String">
        <xsl:value-of select="@value"/>
      </Data>
    </Cell>
  </xsl:template>
  <xsl:template match="Control[@type='TextBox' and @datatype='Date']">
    <Cell xmlns="urn:schemas-microsoft-com:office:spreadsheet" ss:StyleID="TextBoxDate">
      <xsl:if test="string-length(@value) > 0">
      <Data ss:Type="DateTime">
        <xsl:value-of select="@data"/>
      </Data>
      </xsl:if>
    </Cell>
  </xsl:template>
  <xsl:template match="Control[@type='TextBox' and @datatype='DateTime']">
		<Cell xmlns="urn:schemas-microsoft-com:office:spreadsheet" ss:StyleID="TextBoxDateTime">
			<xsl:if test="string-length(@value) > 0">
				<Data ss:Type="DateTime">
					<xsl:value-of select="@data"/>
				</Data>
			</xsl:if>
		</Cell>
	</xsl:template>
	<xsl:template match="Control[@type='TextBox' and @datatype='Time']">
    <Cell xmlns="urn:schemas-microsoft-com:office:spreadsheet" ss:StyleID="TextBoxTime">
      <xsl:if test="string-length(@value) > 0">
      <Data ss:Type="DateTime">1899-12-31T<xsl:value-of select="@data"/></Data>
      </xsl:if>
    </Cell>
  </xsl:template>
  <xsl:template match="Control[@type='TextBox' and @datatype='Decimal']">
    <Cell xmlns="urn:schemas-microsoft-com:office:spreadsheet" ss:StyleID="TextBoxNumber">
      <xsl:if test="string-length(@value) > 0">
        <Data ss:Type="Number"><xsl:value-of select="@data"/></Data>
      </xsl:if>
    </Cell>
  </xsl:template>
  <xsl:template match="Control[@type='TextBox' and @datatype='Integer']">
    <Cell xmlns="urn:schemas-microsoft-com:office:spreadsheet" ss:StyleID="TextBoxInteger">
      <Data ss:Type="Number">
        <xsl:value-of select="@value"/>
      </Data>
    </Cell>
  </xsl:template>
  <xsl:template match="Control[@type='TextBox' and @datatype='String']">
    <Cell xmlns="urn:schemas-microsoft-com:office:spreadsheet" ss:StyleID="TextBox">
      <Data ss:Type="String">
        <xsl:value-of select="@value"/>
      </Data>
    </Cell>
  </xsl:template>
  <xsl:template match="Control[@type='TextBox' and @datatype='Boolean']">
    <Cell xmlns="urn:schemas-microsoft-com:office:spreadsheet" ss:StyleID="TextBox">
      <Data ss:Type="String">
        <xsl:value-of select="@value"/>
      </Data>
    </Cell>
  </xsl:template>
  <xsl:template match="Control[@type='CheckBox']">
    <Cell xmlns="urn:schemas-microsoft-com:office:spreadsheet">
      <xsl:attribute name="ss:StyleID">CheckBox</xsl:attribute>
      <Data>
        <xsl:attribute name="ss:Type">String</xsl:attribute>
        <xsl:value-of select="@value"/>
      </Data>
    </Cell>
  </xsl:template>
  <xsl:template name="Empty">
    <Worksheet xmlns="urn:schemas-microsoft-com:office:spreadsheet">
      <xsl:attribute name="ss:Name">
        <xsl:call-template name="GetWorksheetName" />
      </xsl:attribute>
      <Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="1">
        <Column ss:AutoFitWidth="0" />
        <Row>
          <Cell xmlns="urn:schemas-microsoft-com:office:spreadsheet" ss:StyleID="TextBox">
            <Data ss:Type="String">No data found.</Data>
          </Cell>
        </Row>
      </Table>
    </Worksheet>
  </xsl:template> 
  <xsl:template name="GetWorksheetName">
    <xsl:value-of select="@caption"/>
    <xsl:if test="not(@caption) or @caption = ''">
      <xsl:variable name="TableBoxCaption">
        <xsl:value-of select="translate(//Object/@caption, ':\/?*[]', '------')"/>
      </xsl:variable>
      <xsl:value-of select="substring($TableBoxCaption,1,27)"/>
      <xsl:value-of select="position()"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
  