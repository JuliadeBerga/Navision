<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:sl="http://schemas.microsoft.com/schemaLibrary/2003/core" xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:ns2="http://www.navisionformlist.com">
  <xsl:output method="xml" encoding="UTF-8" standalone="yes" />
  <xsl:template match="/">
    <xsl:processing-instruction name="mso-application">
      <xsl:text>progid="Word.Document"</xsl:text>
    </xsl:processing-instruction>
    <w:wordDocument xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:sl="http://schemas.microsoft.com/schemaLibrary/2003/core" xmlns:aml="http://schemas.microsoft.com/aml/2001/core" xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:ns2="http://www.navisionformlist.com" w:macrosPresent="no" w:embeddedObjPresent="no" w:ocxPresent="no" xml:space="preserve">
			<xsl:call-template name="output-fonts"/>
			<xsl:call-template name="output-styles"/>
			<xsl:call-template name="output-divs"/>
			<xsl:call-template name="output-document-properties"/>
			<xsl:call-template name="output-body"/>
		</w:wordDocument>
  </xsl:template>
  <xsl:template name="output-fonts">
    <w:fonts>
      <w:defaultFonts w:ascii="Arial Unicode MS" w:fareast="Arial Unicode MS" w:h-ansi="Arial Unicode MS" w:cs="Arial Unicode MS"/>
      <w:font w:name="Arial Unicode MS">
        <w:panose-1 w:val="020B0604030504040204"/>
        <w:charset w:val="00"/>
        <w:family w:val="Swiss"/>
        <w:pitch w:val="variable"/>
        <w:sig w:usb-0="20000287" w:usb-1="00000000" w:usb-2="00000000" w:usb-3="00000000" w:csb-0="0000019F" w:csb-1="00000000"/>
      </w:font>
    </w:fonts>
  </xsl:template>
  <xsl:template name="output-styles">
    <w:styles>
      <w:versionOfBuiltInStylenames w:val="4"/>
      <w:latentStyles w:defLockedState="off" w:latentStyleCount="156"/>
      <w:style w:type="paragraph" w:default="on" w:styleId="Normal">
        <w:name w:val="Normal"/>
        <w:rsid w:val="00FD3EF5"/>
        <w:rPr>
          <wx:font wx:val="Arial Unicode MS"/>
          <w:sz w:val="24"/>
          <w:sz-cs w:val="24"/>
          <w:lang w:val="DA" w:fareast="EN-US" w:bidi="AR-SA"/>
        </w:rPr>
      </w:style>
      <w:style w:type="paragraph" w:styleId="Heading6">
        <w:name w:val="heading 6"/>
        <wx:uiName wx:val="Heading 6"/>
        <w:basedOn w:val="Normal"/>
        <w:rsid w:val="00F6329A"/>
        <w:pPr>
          <w:pStyle w:val="Heading6"/>
          <w:outlineLvl w:val="5"/>
        </w:pPr>
        <w:rPr>
          <wx:font wx:val="Arial Unicode MS"/>
          <w:b/>
          <w:b-cs/>
          <w:color w:val="EBF0F9"/>
          <w:sz w:val="15"/>
          <w:sz-cs w:val="15"/>
          <w:lang w:fareast="DA"/>
        </w:rPr>
      </w:style>
      <w:style w:type="character" w:default="on" w:styleId="DefaultParagraphFont">
        <w:name w:val="Default Paragraph Font"/>
        <w:semiHidden/>
      </w:style>
      <w:style w:type="table" w:default="on" w:styleId="TableNormal">
        <w:name w:val="Normal Table"/>
        <wx:uiName wx:val="Table Normal"/>
        <w:semiHidden/>
        <w:rPr>
          <wx:font wx:val="Arial Unicode MS"/>
        </w:rPr>
        <w:tblPr>
          <w:tblInd w:w="0" w:type="dxa"/>
          <w:tblCellMar>
            <w:top w:w="0" w:type="dxa"/>
            <w:left w:w="108" w:type="dxa"/>
            <w:bottom w:w="0" w:type="dxa"/>
            <w:right w:w="108" w:type="dxa"/>
          </w:tblCellMar>
        </w:tblPr>
      </w:style>
      <w:style w:type="list" w:default="on" w:styleId="NoList">
        <w:name w:val="No List"/>
        <w:semiHidden/>
      </w:style>
      <w:style w:type="table" w:styleId="TableGrid">
        <w:name w:val="Table Grid"/>
        <w:basedOn w:val="TableNormal"/>
        <w:rsid w:val="00FD3EF5"/>
        <w:rPr>
          <wx:font wx:val="Arial Unicode MS"/>
        </w:rPr>
        <w:tblPr>
          <w:tblInd w:w="0" w:type="dxa"/>
          <w:tblBorders>
            <w:top w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:left w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:bottom w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:right w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:insideH w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
            <w:insideV w:val="single" w:sz="4" wx:bdrwidth="10" w:space="0" w:color="auto"/>
          </w:tblBorders>
          <w:tblCellMar>
            <w:top w:w="0" w:type="dxa"/>
            <w:left w:w="108" w:type="dxa"/>
            <w:bottom w:w="0" w:type="dxa"/>
            <w:right w:w="108" w:type="dxa"/>
          </w:tblCellMar>
        </w:tblPr>
      </w:style>
      <w:style w:type="paragraph" w:styleId="Caption">
        <w:name w:val="caption"/>
        <wx:uiName wx:val="Caption"/>
        <w:basedOn w:val="Normal"/>
        <w:next w:val="Normal"/>
        <w:semiHidden/>
        <w:rsid w:val="00FD3EF5"/>
        <w:pPr>
          <w:pStyle w:val="Caption"/>
        </w:pPr>
        <w:rPr>
          <wx:font wx:val="Arial Unicode MS"/>
          <w:b/>
          <w:b-cs/>
          <w:sz w:val="20"/>
          <w:sz-cs w:val="20"/>
        </w:rPr>
      </w:style>
    </w:styles>
  </xsl:template>
  <xsl:template name="output-divs">
    <w:divs>
      <w:div w:id="44523789">
        <w:bodyDiv w:val="on"/>
        <w:marLeft w:val="0"/>
        <w:marRight w:val="315"/>
        <w:marTop w:val="0"/>
        <w:marBottom w:val="0"/>
        <w:divBdr>
          <w:top w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:left w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:bottom w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:right w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
        </w:divBdr>
        <w:divsChild>
          <w:div w:id="486824516">
            <w:marLeft w:val="0"/>
            <w:marRight w:val="0"/>
            <w:marTop w:val="0"/>
            <w:marBottom w:val="0"/>
            <w:divBdr>
              <w:top w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
              <w:left w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
              <w:bottom w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
              <w:right w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
            </w:divBdr>
          </w:div>
        </w:divsChild>
      </w:div>
      <w:div w:id="1899784509">
        <w:bodyDiv w:val="on"/>
        <w:marLeft w:val="0"/>
        <w:marRight w:val="315"/>
        <w:marTop w:val="0"/>
        <w:marBottom w:val="0"/>
        <w:divBdr>
          <w:top w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:left w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:bottom w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:right w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
        </w:divBdr>
        <w:divsChild>
          <w:div w:id="969895803">
            <w:marLeft w:val="0"/>
            <w:marRight w:val="0"/>
            <w:marTop w:val="0"/>
            <w:marBottom w:val="0"/>
            <w:divBdr>
              <w:top w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
              <w:left w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
              <w:bottom w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
              <w:right w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
            </w:divBdr>
          </w:div>
        </w:divsChild>
      </w:div>
      <w:div w:id="1952397351">
        <w:bodyDiv w:val="on"/>
        <w:marLeft w:val="0"/>
        <w:marRight w:val="315"/>
        <w:marTop w:val="0"/>
        <w:marBottom w:val="0"/>
        <w:divBdr>
          <w:top w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:left w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:bottom w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:right w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
        </w:divBdr>
        <w:divsChild>
          <w:div w:id="1409225886">
            <w:marLeft w:val="0"/>
            <w:marRight w:val="0"/>
            <w:marTop w:val="0"/>
            <w:marBottom w:val="0"/>
            <w:divBdr>
              <w:top w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
              <w:left w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
              <w:bottom w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
              <w:right w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
            </w:divBdr>
          </w:div>
        </w:divsChild>
      </w:div>
      <w:div w:id="2142962172">
        <w:bodyDiv w:val="on"/>
        <w:marLeft w:val="0"/>
        <w:marRight w:val="315"/>
        <w:marTop w:val="0"/>
        <w:marBottom w:val="0"/>
        <w:divBdr>
          <w:top w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:left w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:bottom w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:right w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
        </w:divBdr>
        <w:divsChild>
          <w:div w:id="1458405004">
            <w:marLeft w:val="0"/>
            <w:marRight w:val="0"/>
            <w:marTop w:val="0"/>
            <w:marBottom w:val="0"/>
            <w:divBdr>
              <w:top w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
              <w:left w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
              <w:bottom w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
              <w:right w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
            </w:divBdr>
          </w:div>
        </w:divsChild>
      </w:div>
    </w:divs>
  </xsl:template>
  <xsl:template name="output-document-properties">
    <w:docPr>
      <w:view w:val="normal"/>
      <w:proofState w:spelling="clean" w:grammar="clean"/>
      <w:attachedTemplate w:val=""/>
      <w:defaultTabStop w:val="1304"/>
      <w:hyphenationZone w:val="425"/>
      <w:characterSpacingControl w:val="DontCompress"/>
      <w:optimizeForBrowser/>
      <w:validateAgainstSchema/>
      <w:saveInvalidXML w:val="off"/>
      <w:ignoreMixedContent w:val="off"/>
      <w:alwaysShowPlaceholderText/>
      <w:compat>
        <w:breakWrappedTables/>
        <w:snapToGridInCell/>
        <w:wrapTextWithPunct/>
        <w:useAsianBreakRules/>
        <w:useWord2002TableStyleRules/>
      </w:compat>
    </w:docPr>
  </xsl:template>
  <xsl:template name="output-body">
    <w:body>
      <xsl:call-template name="output-section-properties"/>
    </w:body>
  </xsl:template>
  <xsl:template name="output-section-properties">
    <wx:sect>
      <w:tbl>
        <w:tblPr>
          <w:tblW w:w="8130" w:type="dxa"/>
          <w:tblInd w:w="-75" w:type="dxa"/>
          <w:tblCellMar>
            <w:top w:w="75" w:type="dxa"/>
            <w:left w:w="75" w:type="dxa"/>
            <w:bottom w:w="75" w:type="dxa"/>
            <w:right w:w="75" w:type="dxa"/>
          </w:tblCellMar>
        </w:tblPr>
        <w:tblGrid>
          <w:gridCol w:w="8130"/>
        </w:tblGrid>
        <w:tr>
          <w:trPr>
            <w:tblHeader/>
          </w:trPr>
          <w:tc>
            <w:tcPr>
              <w:tcW w:w="0" w:type="auto"/>
              <w:tcBorders>
                <w:top w:val="nil"/>
                <w:left w:val="nil"/>
                <w:bottom w:val="single" w:sz="36" wx:bdrwidth="90" w:space="0" w:color="auto"/>
                <w:right w:val="nil"/>
              </w:tcBorders>
              <w:shd w:val="clear" w:color="auto" w:fill="1E3C7B"/>
              <w:vAlign w:val="bottom"/>
            </w:tcPr>
            <w:p>
              <w:pPr>
                <w:pStyle w:val="Heading6"/>
                <w:rPr>
                  <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
                  <wx:font wx:val="Arial Unicode MS"/>
                  <w:b w:val="off"/>
                  <w:b-cs w:val="off"/>
                </w:rPr>
              </w:pPr>
              <w:hlink>
                <xsl:attribute name="w:dest">
                  <xsl:value-of select="//Object/@url"/>
                </xsl:attribute>
                <xsl:attribute name="w:screenTip" xml:space="preserve"> </xsl:attribute>
                <w:r>
                  <w:rPr>
                    <w:rStyle w:val="Hyperlink"/>
                    <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
                    <wx:font wx:val="Arial Unicode MS"/>
                    <w:b w:val="off"/>
                    <w:b-cs w:val="off"/>
                    <w:sz w:val="30"/>
                    <w:sz-cs w:val="30"/>
                  </w:rPr>
                  <w:t>
                    <xsl:value-of select="//Object/@caption"/>
                  </w:t>
                </w:r>
              </w:hlink>
            </w:p>
          </w:tc>
        </w:tr>
      </w:tbl>
      <xsl:apply-templates select="Object/Control"/>
      <w:p>
        <w:pPr>
          <w:rPr>
            <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
            <wx:font wx:val="Arial Unicode MS"/>
          </w:rPr>
        </w:pPr>
      </w:p>
      <w:sectPr>
        <w:hdr w:type="even">
          <w:p>
            <w:pPr>
              <w:pStyle w:val="Header"/>
            </w:pPr>
            <w:r>
              <w:rPr>
                <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
                <wx:font wx:val="Arial Unicode MS"/>
                <w:color w:val="1E3C7B"/>
                <w:b/>
                <w:sz w:val="30"/>
                <w:sz-cs w:val="30"/>
              </w:rPr>
              <w:t>
                <xsl:value-of select="//Object/Header/CompanyName"/>
              </w:t>
            </w:r>
          </w:p>
        </w:hdr>
        <w:hdr w:type="odd">
          <w:p>
            <w:pPr>
              <w:pStyle w:val="Header"/>
            </w:pPr>
            <w:r>
              <w:rPr>
                <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
                <wx:font wx:val="Arial Unicode MS"/>
                <w:color w:val="1E3C7B"/>
                <w:b/>
                <w:sz w:val="30"/>
                <w:sz-cs w:val="30"/>
              </w:rPr>
              <w:t>
                <xsl:value-of select="//Object/Header/CompanyName"/>
              </w:t>
            </w:r>
          </w:p>
        </w:hdr>
        <w:ftr w:type="even">
          <w:p>
            <w:pPr>
              <w:pStyle w:val="Footer"/>
            </w:pPr>
          </w:p>
        </w:ftr>
        <w:ftr w:type="odd">
          <w:p>
            <w:pPr>
              <w:pStyle w:val="Footer"/>
            </w:pPr>
          </w:p>
        </w:ftr>
        <w:hdr w:type="first">
          <w:p>
            <w:pPr>
              <w:pStyle w:val="Header"/>
            </w:pPr>
            <w:r>
              <w:rPr>
                <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
                <wx:font wx:val="Arial Unicode MS"/>
                <w:color w:val="1E3C7B"/>
                <w:b/>
                <w:sz w:val="30"/>
                <w:sz-cs w:val="30"/>
              </w:rPr>
              <w:t>
                <xsl:value-of select="//Object/Header/CompanyName"/>
              </w:t>
            </w:r>
          </w:p>
        </w:hdr>
        <w:ftr w:type="first">
          <w:p>
            <w:pPr>
              <w:pStyle w:val="Footer"/>
            </w:pPr>
          </w:p>
        </w:ftr>
        <w:pgSz w:w="11906" w:h="16838"/>
        <w:pgMar w:top="1701" w:right="1134" w:bottom="1701" w:left="1134" w:header="708" w:footer="708" w:gutter="0"/>
        <w:cols w:space="708"/>
        <w:docGrid w:line-pitch="360"/>
      </w:sectPr>
    </wx:sect>
  </xsl:template>
  <xsl:template match="Control[@type='TabControl']">
    <xsl:apply-templates select="./Control"/>
  </xsl:template>
  <xsl:template match="Control[@type='TabPage']">
    <w:p>
      <w:pPr>
        <w:rPr>
          <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
          <wx:font wx:val="Arial Unicode MS"/>
        </w:rPr>
      </w:pPr>
    </w:p>
    <w:p>
      <w:pPr>
        <w:pStyle w:val="Caption"/>
        <w:keepNext/>
        <w:tabs>
          <w:tab w:val="left" w:pos="180"/>
        </w:tabs>
        <w:rPr>
          <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
          <wx:font wx:val="Arial Unicode MS"/>
          <w:color w:val="1E3C7B"/>
          <w:sz w:val="24"/>
          <w:sz-cs w:val="24"/>
        </w:rPr>
      </w:pPr>
      <w:r>
        <w:rPr>
          <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS" w:fareast="Arial Unicode MS" w:cs="Arial Unicode MS"/>
          <wx:font wx:val="Arial Unicode MS"/>
          <w:color w:val="1E3C7B"/>
          <w:sz w:val="24"/>
          <w:sz-cs w:val="24"/>
        </w:rPr>
        <w:t>
          <xsl:value-of select="@caption"/>
        </w:t>
      </w:r>
    </w:p>
    <w:tbl>
      <w:tblPr>
        <w:tblStyle w:val="TableGrid"/>
        <w:tblW w:w="0" w:type="auto"/>
        <w:tblBorders>
          <w:top w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:left w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:bottom w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:right w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:insideH w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:insideV w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
        </w:tblBorders>
        <w:tblLook w:val="01E0"/>
      </w:tblPr>
      <xsl:apply-templates select="Row" mode="TabPage"/>
    </w:tbl>
  </xsl:template>
  <xsl:template match="Control[@type='FactBox']">
  </xsl:template>
  <xsl:template match="Control[@type='TableBox']">
    <w:p>
      <w:pPr>
        <w:rPr>
          <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
          <wx:font wx:val="Arial Unicode MS"/>
          <w:lang w:val="EN-GB"/>
        </w:rPr>
      </w:pPr>
    </w:p>
    <w:p>
      <w:pPr>
        <w:pStyle w:val="Caption"/>
        <w:keepNext/>
        <w:tabs>
          <w:tab w:val="left" w:pos="180"/>
        </w:tabs>
        <w:rPr>
          <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
          <wx:font wx:val="Arial Unicode MS"/>
          <w:color w:val="1E3C7B"/>
          <w:sz w:val="24"/>
          <w:sz-cs w:val="24"/>
        </w:rPr>
      </w:pPr>
      <xsl:if test="@caption">
        <w:r>
          <w:rPr>
            <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
            <wx:font wx:val="Arial Unicode MS"/>
            <w:color w:val="1E3C7B"/>
            <w:sz w:val="24"/>
            <w:sz-cs w:val="24"/>
          </w:rPr>
          <w:t>
            <xsl:value-of select="@caption"/>
          </w:t>
        </w:r>
      </xsl:if>
    </w:p>
    <w:tbl>
      <w:tblPr>
        <w:tblStyle w:val="TableGrid"/>
        <w:tblW w:w="0" w:type="auto"/>
        <w:tblBorders>
          <w:top w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:left w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:bottom w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:right w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:insideH w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:insideV w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
        </w:tblBorders>
        <w:tblLook w:val="01E0"/>
      </w:tblPr>
      <w:tblGrid>
        <xsl:for-each select="Row[1]/Control">
          <w:gridCol>
            <xsl:if test="@width">
              <xsl:attribute name="w:w">
                <xsl:value-of select="@width"/>
              </xsl:attribute>
            </xsl:if>
          </w:gridCol>
        </xsl:for-each>
      </w:tblGrid>
      <xsl:apply-templates select="Row" mode="TableBox"/>
    </w:tbl>
  </xsl:template>
  <xsl:template match="Control[@type='Frame']">
    <w:p>
      <w:pPr>
        <w:rPr>
          <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
          <wx:font wx:val="Arial Unicode MS"/>
          <w:lang w:val="EN-GB"/>
        </w:rPr>
      </w:pPr>
    </w:p>
    <w:p>
      <w:pPr>
        <w:pStyle w:val="Caption"/>
        <w:keepNext/>
        <w:tabs>
          <w:tab w:val="left" w:pos="180"/>
        </w:tabs>
        <w:rPr>
          <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
          <wx:font wx:val="Arial Unicode MS"/>
          <w:color w:val="1E3C7B"/>
          <w:sz w:val="24"/>
          <w:sz-cs w:val="24"/>
        </w:rPr>
      </w:pPr>
      <w:r>
        <w:rPr>
          <w:rFonts w:ascii="Arial Unicode MS" w:h-ansi="Arial Unicode MS"/>
          <wx:font wx:val="Arial Unicode MS"/>
          <w:color w:val="1E3C7B"/>
          <w:sz w:val="30"/>
          <w:sz-cs w:val="30"/>
        </w:rPr>
        <w:t>
          <xsl:value-of select="@caption"/>
        </w:t>
      </w:r>
    </w:p>
    <w:tbl>
      <w:tblPr>
        <w:tblStyle w:val="TableGrid"/>
        <w:tblW w:w="0" w:type="auto"/>
        <w:tblBorders>
          <w:top w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:left w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:bottom w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:right w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:insideH w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
          <w:insideV w:val="none" w:sz="0" wx:bdrwidth="0" w:space="0" w:color="auto"/>
        </w:tblBorders>
        <w:tblLook w:val="01E0"/>
      </w:tblPr>
      <xsl:apply-templates select="Row" mode="Frame"/>
    </w:tbl>
  </xsl:template>
  <xsl:template match="Row" mode="TabPage">
    <w:tr>
      <xsl:apply-templates select="./Control"/>
    </w:tr>
    <xsl:if test="position()!=last()">
      <w:tr>
        <xsl:for-each select="./Control">
          <w:tc>
            <w:tcPr>
              <w:tcW w:w="2692" w:type="dxa"/>
              <xsl:if test="@type='Label'">
                <w:shd w:val="clear" w:color="auto" w:fill="F2F2F2"/>
              </xsl:if>
              <w:vAlign w:val="bottom"/>
            </w:tcPr>
            <w:p>
              <w:pPr>
                <w:rPr>
                  <w:b/>
                  <w:sz w:val="4"/>
                  <w:sz-cs w:val="4"/>
                </w:rPr>
              </w:pPr>
            </w:p>
          </w:tc>
        </xsl:for-each>
      </w:tr>
    </xsl:if >
  </xsl:template>
  <xsl:template match="Row" mode="TableBox">
    <w:tr>
      <xsl:apply-templates select="./Control"/>
    </w:tr>
  </xsl:template>
  <xsl:template match="Row" mode="Frame">
    <w:tr>
      <xsl:apply-templates select="./Control"/>
    </w:tr>
  </xsl:template>
  <xsl:template match="Control[@type='Label']">
    <w:tc>
      <w:tcPr>
        <w:tcW w:type="dxa">
          <xsl:if test="@width">
            <xsl:attribute name="w:w">
              <xsl:value-of select="@width * 0.7"/>
            </xsl:attribute>
          </xsl:if>
        </w:tcW>
        <w:shd w:val="clear" w:color="auto" w:fill="F2F2F2"/>
        <w:vAlign w:val="bottom"/>
      </w:tcPr>
      <w:p>
        <w:r>
          <w:rPr>
            <w:b/>
            <w:sz w:val="18"/>
            <w:sz-cs w:val="18"/>
          </w:rPr>
          <w:t>
            <xsl:value-of select="@value"/>
          </w:t>
        </w:r>
      </w:p>
    </w:tc>
  </xsl:template>
  <xsl:template match="Control[@type='TextBox']">
    <w:tc>
      <w:tcPr>
        <w:tcW w:type="dxa">
          <xsl:if test="@width">
            <xsl:attribute name="w:w">
              <xsl:value-of select="@width * 0.7"/>
            </xsl:attribute>
          </xsl:if>
        </w:tcW>
        <w:vAlign w:val="bottom"/>
      </w:tcPr>
      <w:p>
        <w:r>
          <w:rPr>
            <w:sz w:val="18"/>
            <w:sz-cs w:val="18"/>
          </w:rPr>
          <w:t>
            <xsl:value-of select="@value"/>
          </w:t>
        </w:r>
      </w:p>
    </w:tc>
  </xsl:template>
  <xsl:template match="Control[@type='TextBox' and @datatype='Decimal']">
    <w:tc>
      <w:tcPr>
        <w:tcW w:type="dxa">
          <xsl:if test="@width">
            <xsl:attribute name="w:w">
              <xsl:value-of select="@width * 0.7"/>
            </xsl:attribute>
          </xsl:if>
        </w:tcW>
        <w:vAlign w:val="bottom"/>
      </w:tcPr>
      <w:p>
        <w:pPr>
          <w:jc w:val="right"/>
        </w:pPr>
        <w:r w:rsidRPr="00CB0CED">
          <w:rPr>
            <w:sz w:val="18"/>
            <w:sz-cs w:val="18"/>
          </w:rPr>
          <w:t>
            <xsl:value-of select="@value"/>
          </w:t>
        </w:r>
      </w:p>
    </w:tc>
  </xsl:template>
  <xsl:template match="Control[@type='CheckBox']">
    <w:tc>
      <w:tcPr>
        <w:tcW w:type="dxa">
          <xsl:if test="@width">
            <xsl:attribute name="w:w">
              <xsl:value-of select="@width * 0.7"/>
            </xsl:attribute>
          </xsl:if>
        </w:tcW>
        <w:vAlign w:val="bottom"/>
      </w:tcPr>
      <w:p>
        <w:r>
          <w:rPr>
            <w:sz w:val="18"/>
            <w:sz-cs w:val="18"/>
          </w:rPr>
          <w:t>
            <xsl:value-of select="@value"/>
          </w:t>
        </w:r>
      </w:p>
    </w:tc>
  </xsl:template>
</xsl:stylesheet>