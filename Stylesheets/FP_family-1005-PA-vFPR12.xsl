<?xml version="1.0"?>
<xsl:stylesheet 
	version="1.1" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:a="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2">
		
		<xsl:param name="PathAllegati" />
		<xsl:param name="installPath" />
		<xsl:param name="companyId" />
		
		
	<xsl:output method="html" />
	<xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>
	<xsl:template name="FormatDateCompact">
		<xsl:param name="DateTime" />

		<xsl:variable name="year" select="substring($DateTime,1,4)" />
		<xsl:variable name="month" select="substring($DateTime,6,2)" />
		<xsl:variable name="day" select="substring($DateTime,9,2)" />

		<xsl:value-of select="$day" />
		<xsl:value-of select="'/'" />
		<xsl:value-of select="$month" />
		<xsl:value-of select="'/'" />
		<xsl:value-of select="$year" />

		<xsl:variable name="time" select="substring($DateTime,12)" />
		<xsl:if test="$time != ''">
			<xsl:variable name="hh" select="substring($time,1,2)" />
			<xsl:variable name="mm" select="substring($time,4,2)" />
			<xsl:variable name="ss" select="substring($time,7,2)" />

			<xsl:value-of select="' '" />
			<xsl:value-of select="$hh" />
			<xsl:value-of select="':'" />
			<xsl:value-of select="$mm" />
			<xsl:value-of select="':'" />
			<xsl:value-of select="$ss" />
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="FormatDateCompactF1030">
		<xsl:param name="DateTime" />

		<xsl:variable name="year" select="substring($DateTime,1,4)" />
		<xsl:variable name="month" select="substring($DateTime,5,2)" />
		<xsl:variable name="day" select="substring($DateTime,7,2)" />

		<xsl:value-of select="$day" />
		<xsl:value-of select="'/'" />
		<xsl:value-of select="$month" />
		<xsl:value-of select="'/'" />
		<xsl:value-of select="$year" />

		<xsl:variable name="time" select="substring($DateTime,12)" />
		<xsl:if test="$time != ''">
			<xsl:variable name="hh" select="substring($time,1,2)" />
			<xsl:variable name="mm" select="substring($time,4,2)" />
			<xsl:variable name="ss" select="substring($time,7,2)" />

			<xsl:value-of select="' '" />
			<xsl:value-of select="$hh" />
			<xsl:value-of select="':'" />
			<xsl:value-of select="$mm" />
			<xsl:value-of select="':'" />
			<xsl:value-of select="$ss" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="FormatDate">
		<xsl:param name="DateTime" />

		<xsl:variable name="year" select="substring($DateTime,1,4)" />
		<xsl:variable name="month" select="substring($DateTime,6,2)" />
		<xsl:variable name="day" select="substring($DateTime,9,2)" />

		<xsl:value-of select="' ('" />
		<xsl:value-of select="$day" />
		<xsl:value-of select="' '" />
		<xsl:choose>
			<xsl:when test="$month = '1' or $month = '01'">
				Gennaio
			</xsl:when>
			<xsl:when test="$month = '2' or $month = '02'">
				Febbraio
			</xsl:when>
			<xsl:when test="$month = '3' or $month = '03'">
				Marzo
			</xsl:when>
			<xsl:when test="$month = '4' or $month = '04'">
				Aprile
			</xsl:when>
			<xsl:when test="$month = '5' or $month = '05'">
				Maggio
			</xsl:when>
			<xsl:when test="$month = '6' or $month = '06'">
				Giugno
			</xsl:when>
			<xsl:when test="$month = '7' or $month = '07'">
				Luglio
			</xsl:when>
			<xsl:when test="$month = '8' or $month = '08'">
				Agosto
			</xsl:when>
			<xsl:when test="$month = '9' or $month = '09'">
				Settembre
			</xsl:when>
			<xsl:when test="$month = '10'">
				Ottobre
			</xsl:when>
			<xsl:when test="$month = '11'">
				Novembre
			</xsl:when>
			<xsl:when test="$month = '12'">
				Dicembre
			</xsl:when>
			<xsl:otherwise>
				Mese non riconosciuto
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="' '" />
		<xsl:value-of select="$year" />

		<xsl:variable name="time" select="substring($DateTime,12)" />
		<xsl:if test="$time != ''">
			<xsl:variable name="hh" select="substring($time,1,2)" />
			<xsl:variable name="mm" select="substring($time,4,2)" />
			<xsl:variable name="ss" select="substring($time,7,2)" />

			<xsl:value-of select="' '" />
			<xsl:value-of select="$hh" />
			<xsl:value-of select="':'" />
			<xsl:value-of select="$mm" />
			<xsl:value-of select="':'" />
			<xsl:value-of select="$ss" />
		</xsl:if>
		<xsl:value-of select="')'" />
	</xsl:template>
	
	<xsl:template name="string-replace-all">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="by" />
		<xsl:choose>
			<xsl:when test="$text = '' or $replace = ''or not($replace)" >
				<!-- Prevent this routine from hanging -->
				<xsl:value-of select="$text" />
			</xsl:when>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:value-of select="$by" />
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="substring-after($text,$replace)" />
					<xsl:with-param name="replace" select="$replace" />
					<xsl:with-param name="by" select="$by" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="whitespaceCharacters" select="'&#09;&#10;&#13; '" />	
    <!-- Trim Right side of the String -->
    <xsl:template name="TrimRight">
        <xsl:param name="input" />
        <xsl:param name="trim" select="$whitespaceCharacters" />
         
        <xsl:variable name="length" select="string-length($input)" />
        <xsl:if test="string-length($input) &gt; 0">
            <xsl:choose>
                <xsl:when test="contains($trim, substring($input, $length, 1))">
                    <xsl:call-template name="TrimRight">
                        <xsl:with-param name="input" select="substring($input, 1, $length - 1)" />
                        <xsl:with-param name="trim" select="$trim" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$input" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
     
    <!-- Trim Left side of the String -->
    <xsl:template name="TrimLeft">
        <xsl:param name="input" />
        <xsl:param name="trim" select="$whitespaceCharacters" />
         
        <xsl:if test="string-length($input) &gt; 0">
            <xsl:choose>
                <xsl:when test="contains($trim, substring($input, 1, 1))">
                    <xsl:call-template name="TrimLeft">
                        <xsl:with-param name="input" select="substring($input, 2)" />
                        <xsl:with-param name="trim" select="$trim" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$input" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

	<!-- Trim both sides of the String -->
    <xsl:template name="Trim">
        <xsl:param name="input" />
        <xsl:param name="trim" select="$whitespaceCharacters" />
        <xsl:call-template name="TrimRight">
            <xsl:with-param name="input">
                <xsl:call-template name="TrimLeft">
                    <xsl:with-param name="input" select="$input" />
                    <xsl:with-param name="trim" select="$trim" />
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="trim" select="$trim" />
        </xsl:call-template>
    </xsl:template>
	
	<xsl:template match="/">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=edge" />
				<style type="text/css">
					@font-face {
					  font-family: 'Free 3 of 9';
					  src: url('/adiJed/workfolder/SystemFiles/DefaultCompany/Other/free3of9.woff');
					}
					body {
					  background: rgb(204,204,204); 
					}
					page {
					  background: white;
					  display: block;
					  margin: 0 auto;
					  margin-bottom: 0.5cm;
					  box-shadow: 0 0 0.5cm rgba(0,0,0,0.5);
					}
					page[size="A4"] {  
					  max-width: 33cm;
					  min-width: 18cm;
					  width: 90%;
					}
					div.page_footer {
						display: none;
					}
					td.page_footer {
						display: none;
					}
					span.bcode {
						font-size:40pt; 
						font-family: 'Free 3 of 9';
						display: inline-block;
						text-transform: uppercase;
					}
					td.titleSmall {
						font-size:12px;
					}
					td.smallNote {
						font-size:10px;
					}
					table.intest {
						font-size:12px;
					}
					@media screen {
						body {
							padding-bottom: 100px;
							background-color: #f5f5f5;
						}
						div.document_values {
							width: 33cm;
							min-height: 15cm;
							box-shadow: 0px 3px 6px #808080;
							border: 1px #D3D3D3 solid;
							max-width: 100%;
							margin-left: auto;
							margin-right: auto;
							background-color: #ffffff;
						}
						table.borderRadTable td {
						  font-size:15px; 
						}
						div.smallText {
						  font-size:10px; 
						  line-height: 1em;
						}
					}
					@media only screen and (max-width: 800px) {
						table.borderRadTable td {
						  font-size:12px; 
						}
						table.borderDDT td {
						  font-size:12px; 
						}
						div.smallText {
						  font-size:10px; 
						  line-height: 1em;
						}
						
					}
					
					@media print {
						span.bcode {
							font-size:35pt; 
							font-family: 'Free 3 of 9';
							display: inline-block;
							text-transform: uppercase;
						}
						td.titleSmall {
							font-size:10px;
						}
						td.smallNote {
							font-size:8px;
						}
						table.intest {
							font-size:10px;
						}
						body {
							background: white;
						}
						page {
							margin: auto;
							box-shadow: 0;
							width: 100%;
						}
						page[size="A4"] {  
							width: 100%;
						}
						div.databody{
							page-break-inside: avoid;
						}
						div.page_header {
							position: running(header);
							display: inline-block;
						}
						div.page_footer {
							width: 100%;
							position: running(footer);
							display: inline-block;
							font-size: 85%;
							padding: 50px 0 0 0; margin: 0; font-size: 11px; text-align: center; color: #777777;
						}
						td.page_footer {
							display: inline-block;
						}
						table.page_footer {
							table-layout: fixed;
						}						
						#pageFooter:after {
							counter-increment: page;
							content:"Pag. " counter(page) " di " counter(pages);
							left: 0; 
							top: 100%;
							white-space: nowrap; 
							z-index: 20px;
							-moz-border-radius: 5px; 
							-moz-box-shadow: 0px 0px 4px #222;  
							background-image: -moz-linear-gradient(top, #eeeeee, #cccccc);  
							background-image: -moz-linear-gradient(top, #eeeeee, #cccccc);  
						  }
						table.borderRadTable td {
						  font-size:10px; 
						}
						table.borderDDT td {
						  font-size:10px; 
						}
						div.smallText {
						  font-size:8px;
						  line-height: 1em;						  
						}
						table.pg {
							max-width: 2480px;
							min-width: 18cm;
						}
					}
					@page {
						margin-top: 10cm;
						margin-bottom: 2.5cm;
					}
					@page {
						@top-center { content: element(header); }
						@bottom-center { content: element(footer); }
					}
				
					#fattura-container { width: 100%; position: relative; }

					#fattura-elettronica { font-family: sans-serif; margin-left: auto; margin-right: auto; max-width: 1280px; min-width: 930px; padding: 0; }
					#fattura-elettronica .versione { font-size: 11px; float:right; color: #777777; }
					#fattura-elettronica h1 { padding: 20px 0 0 0; margin: 0; font-size: 30px; }
					#fattura-elettronica h2 { padding: 20px 0 0 0; margin: 0; font-size: 20px; }
					#fattura-elettronica h3 { padding: 20px 0 0 0; margin: 0; font-size: 25px; }
					#fattura-elettronica h4 { padding: 20px 0 0 0; margin: 0; font-size: 20px; }
					#fattura-elettronica h5 { padding: 15px 0 0 0; margin: 0;
					font-size: 8px; font-style: italic; }
					#fattura-elettronica ul { list-style-type: none; margin: 0 !important; padding: 15px 0 0 40px !important; }
					#fattura-elettronica ul li {}
					#fattura-elettronica ul li span { font-weight: bold; }
					#fattura-elettronica div { padding: 0; margin: 0; }

					#fattura-elettronica
					div.page {
					background-color: #fff !important;
					position: relative;

					margin: 20px 0
					50px 0;
					padding: 60px;

					background: -moz-linear-gradient(0% 0 360deg, #FFFFFF, #F2F2F2 20%, #FFFFFF) repeat scroll 0 0 transparent;
					border: 1px solid #CCCCCC;
					-webkitbox-shadow: 0 0 10px rgba(0, 0, 0,
					0.3);
					-mozbox-shadow: 0
					0 10px rgba(0, 0, 0, 0.3);
					box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);

					
					}
					#fattura-elettronica div.footer { padding: 50px 0 0 0; margin: 0; font-size: 11px; text-align: center; color: #777777; }
	
					.font-italic{
						font-style: italic;
					}
					.spacePre {
						white-space: pre;
					}
					.font-bold {
						font-weight: bold;
					}
					.font-italic{
						font-style: italic;
					}
					.font-underline {
						text-decoration: underline;
					}
					td.borderRad {
						border: 1px solid black;
						page-break-inside: avoid;
						page-break-before:auto;
					}
					table.borderRadTable {
						border: 1px solid black;
						page-break-inside: avoid;
						page-break-before:auto;
					}
					tr.trtitle{
						background-color: lightgrey;
					}
					table.borderRadTable td.noBorder {
						border-bottom: 0px; 
						border-right: 0px;
						font-style: italic;	
						font-size:10px;
						text-align: left;						
					}
					table.borderRadTable td {
					  border-bottom: 1px solid black; 
					  border-right: 1px solid black; 
					}
					table.borderRadTable tr:last-child td
					{ 
						border-bottom: 0; 
					} 
					table.borderRadTable tr td:last-child
					{ 
						border-right: 0;
					} 
					table.borderRadTable tr.otherTitle
					{ 
						display: none;
					} 
					table.borderRadTable tr.otherTitle:first-child
					{ 
						display: table-row;
					} 
					table.borderDDT tr.DDTROW {
						border: 1px solid black;
						page-break-inside: avoid;
						page-break-before:auto;
					}
					table.borderDDT tr.DDTROW td {
					  border-bottom: 1px solid black; 
					  border-right: 1px solid black; 
					}
					table.borderDDT tr.DDTROW td:first-child {
					  border-left: 1px solid black; 
					}
					table.borderDDT tr.twoTitle
					{ 
						display: none;
					} 
					table.borderDDT tr.twoTitle:first-child
					{ 
						display: table-row;
					} 
					table.borderDDT tr.twoTitle:nth-child(2)
					{ 
						border: 1px solid black;
						display: table-row;
					} 
					table.borderDDT tr.twoTitle:nth-child(2) td {
					  border-bottom: 1px solid black; 
					  border-right: 1px solid black; 
					  border-top: 1px solid black; 
					}
					table.borderDDT tr.twoTitle:nth-child(2) td:first-child {
					  border-left: 1px solid black; 
					}
					.text-center {
						text-align: center;
					}
					.text-right {
						text-align: right;
					}
					table.pg {
						max-width: 2480px;
					}
					table.pg td:not(table.borderRadTable td){
						width: auto;
						overflow: hidden;
						word-wrap: break-word;
					}
				</style>
			</head>
			<body>
				<div id="fattura-container">
					<page size="A4">
					<!--INIZIO DATI HEADER-->
					<xsl:if test="a:FatturaElettronica">
						<div class="document_values">
							<div class="page_header">
							<table class="pg" width="100%" align="center" cellpadding="5">
								<xsl:variable name="VERSIONE">
									<xsl:value-of select="a:FatturaElettronica/@versione"/>
								</xsl:variable>
								<xsl:if test="a:FatturaElettronica/FatturaElettronicaHeader">
									<xsl:param name="FIDD" />
									<xsl:param name="BARCODE" />
									<xsl:param name="F11" />
									<xsl:param name="F1038" />
									<xsl:param name="F1030" />
									<xsl:if test="a:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione">
										<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione">
										<xsl:variable name="IDTRASMITENTE">
											<xsl:value-of select="IdTrasmittente/IdCodice" />
										</xsl:variable>
										<xsl:variable name="PROGINVIO">
											<xsl:value-of select="ProgressivoInvio" />
										</xsl:variable>
										<tr>
											<td colspan="2" width="100%">
												<table width="100%" cellpadding="0" cellspacing="0">
													<tr>
														<td width="25%">
															<table cellpadding="0" cellspacing="0" width="100%">
																<tr><td>
																</td></tr>
																<tr><td class="smallNote">FATTURA ELETTRONICA - Versione <xsl:value-of select="$VERSIONE" /></td></tr>
															</table>
														</td>											
														<td width="80%"  align="center">
															<table width="100%" cellpadding="0" cellspacing="0">
																<tr><td><span id="bcode" > Id. SIME <xsl:value-of select="$F1038" /> </span></td><td><span id="bcode" > Data ricezione <xsl:call-template name="FormatDateCompactF1030">
										<xsl:with-param name="DateTime" select="$F1030" /></xsl:call-template></span></td>
									</tr>
																<!--tr><td class="smallNote" id="bcodetd" align="center"><xsl:value-of select="$BARCODE" /></td></tr-->
															</table>														
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<xsl:if test="PECDestinatario">
											<tr>
												<td colspan="2" width="100%" class="titleSmall">Destinatario PEC:<xsl:value-of select="PECDestinatario" /></td>
											</tr>
										</xsl:if>
										</xsl:for-each>
									</xsl:if>
									<!--FINE DATI DELLA TRASMISSIONE-->
								</xsl:if>
								<tr>
									<td colspan="2" width="100%">
										<table width="100%"><tr>
									<td width="47%">
										<table width="100%"><tr><td class="borderRad" width="100%">
										<table width="100%" cellpadding="0" cellspacing="0" class="intest">
											<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/DatiAnagrafici">
													<xsl:variable name="Titolo">
														<xsl:value-of select="Anagrafica/Titolo"/>
													</xsl:variable>
													<xsl:variable name="Nome">
														<xsl:value-of select="Anagrafica/Nome"/>
													</xsl:variable>
													<xsl:variable name="Cognome">
														<xsl:value-of select="Anagrafica/Cognome"/>
													</xsl:variable>
													<tr><td>Mittente: <xsl:value-of select="concat($Titolo, ' ', $Nome, ' ', $Cognome)" />
													<xsl:if test="Anagrafica/Denominazione">
													<xsl:value-of select="Anagrafica/Denominazione" />
													</xsl:if>
													</td></tr>
													<tr><td>Partita IVA: <span>
															<xsl:value-of select="IdFiscaleIVA/IdPaese" />
															<xsl:value-of select="IdFiscaleIVA/IdCodice" />
														</span></td></tr>
													<tr><td>Codice Fiscale: <xsl:value-of select="CodiceFiscale" /></td></tr>
													<xsl:if test="Anagrafica/CodEORI">
														<tr><td>Codice EORI: <xsl:value-of select="Anagrafica/CodEORI" /></td></tr>
													</xsl:if>
													<xsl:if test="AlboProfessionale">
														<tr><td>Albo professionale di appartenenza: <xsl:value-of select="AlboProfessionale" /></td></tr>
													</xsl:if>
													<xsl:if test="ProvinciaAlbo">
														<tr><td>Provincia di competenza dell'Albo: <xsl:value-of select="ProvinciaAlbo" /></td></tr>
													</xsl:if>
													<xsl:if test="NumeroIscrizioneAlbo">
														<tr><td>Numero iscrizione all'Albo: <xsl:value-of select="NumeroIscrizioneAlbo" /></td></tr>
													</xsl:if>
													<xsl:if test="DataIscrizioneAlbo">
														<tr><td>Data iscrizione all'Albo:
															<xsl:call-template name="FormatDateCompact">
																<xsl:with-param name="DateTime" select="DataIscrizioneAlbo" />
															</xsl:call-template>
														</td></tr>
													</xsl:if>
													<tr><td>Regime Fiscale: <span>
															<xsl:value-of select="RegimeFiscale" />
														</span>

														<xsl:variable name="RF">
															<xsl:value-of select="RegimeFiscale" />
														</xsl:variable>
														<xsl:choose>
															<xsl:when test="$RF='RF01'">
																(ordinario)
															</xsl:when>
															<xsl:when test="$RF='RF02'">
																(contribuenti minimi)
															</xsl:when>
															<xsl:when test="$RF='RF03'">
																(nuove iniziative produttive) - Non più valido in quanto abrogato dalla legge di stabilità 2015
															</xsl:when>
															<xsl:when test="$RF='RF04'">
																(agricoltura e attività connesse e pesca)
															</xsl:when>
															<xsl:when test="$RF='RF05'">
																(vendita sali e tabacchi)
															</xsl:when>
															<xsl:when test="$RF='RF06'">
																(commercio fiammiferi)
															</xsl:when>
															<xsl:when test="$RF='RF07'">
																(editoria)
															</xsl:when>
															<xsl:when test="$RF='RF08'">
																(gestione servizi telefonia pubblica)
															</xsl:when>
															<xsl:when test="$RF='RF09'">
																(rivendita documenti di trasporto pubblico e di sosta)
															</xsl:when>
															<xsl:when test="$RF='RF10'">
																(intrattenimenti, giochi e altre attività di cui alla tariffa allegata al DPR 640/72)
															</xsl:when>
															<xsl:when test="$RF='RF11'">
																(agenzie viaggi e turismo)
															</xsl:when>
															<xsl:when test="$RF='RF12'">
																(agriturismo)
															</xsl:when>
															<xsl:when test="$RF='RF13'">
																(vendite a domicilio)
															</xsl:when>
															<xsl:when test="$RF='RF14'">
																(rivendita beni usati, oggetti d’arte,
																d’antiquariato o da collezione)
															</xsl:when>
															<xsl:when test="$RF='RF15'">
																(agenzie di vendite all’asta di oggetti d’arte,
																antiquariato o da collezione)
															</xsl:when>
															<xsl:when test="$RF='RF16'">
																(IVA per cassa P.A.)
															</xsl:when>
															<xsl:when test="$RF='RF17'">
																(IVA per cassa - art. 32-bis, D.L. 83/2012)
															</xsl:when>
															<xsl:when test="$RF='RF19'">
																(Regime forfettario)
															</xsl:when>
															<xsl:when test="$RF='RF18'">
																(altro)
															</xsl:when>
															<xsl:when test="$RF=''">
															</xsl:when>
															<xsl:otherwise>
																<span>(!!! codice non previsto !!!)</span>
															</xsl:otherwise>
														</xsl:choose></td></tr>
												</xsl:for-each>
												<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/Sede">
													<tr><td>Sede: <xsl:value-of select="Indirizzo" /> N.<xsl:value-of select="NumeroCivico" /> - <xsl:value-of select="CAP" /> - <xsl:value-of select="Comune" /> (<xsl:value-of select="Provincia" />) <xsl:value-of select="Nazione" /></td></tr>
												</xsl:for-each>
												<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/StabileOrganizzazione">
													<tr><td>Stabile Organizzazione: <xsl:value-of select="Indirizzo" /> N.<xsl:value-of select="NumeroCivico" /> - <xsl:value-of select="CAP" /> - <xsl:value-of select="Comune" /> (<xsl:value-of select="Provincia" />) <xsl:value-of select="Nazione" /></td></tr>
												</xsl:for-each>
												<xsl:if test="a:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/IscrizioneREA">
														<tr><td>Iscrizione nel registro delle imprese</td></tr>
													<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/IscrizioneREA">
														<tr><td>Provincia Ufficio Registro imprese: <xsl:value-of select="Ufficio" /></td></tr>
														<tr><td>Numero di iscrizione: <xsl:value-of select="NumeroREA" /></td></tr>
														<tr><td>Capitale Sociale: <xsl:value-of select="format-number(CapitaleSociale, '###.##0,00#########', 'euro')" /></td></tr>
														<tr><td><span>
																<xsl:value-of select="SocioUnico" />
															</span>

															<xsl:variable name="NS">
																<xsl:value-of select="SocioUnico" />
															</xsl:variable>
															<xsl:choose>
																<xsl:when test="$NS='SU'">
																	(socio unico)
																</xsl:when>
																<xsl:when test="$NS='SM'">
																	(più soci)
																</xsl:when>
																<xsl:when test="$NS=''">
																</xsl:when>
																<xsl:otherwise>
																	<span>(!!! codice non previsto !!!)</span>
																</xsl:otherwise>
															</xsl:choose></td></tr>
														<tr><td>Stato di liquidazione: <span>
															<xsl:value-of select="StatoLiquidazione" />
														</span>

														<xsl:variable name="SL">
															<xsl:value-of select="StatoLiquidazione" />
														</xsl:variable>
														<xsl:choose>
															<xsl:when test="$SL='LS'">
																(in liquidazione)
															</xsl:when>
															<xsl:when test="$SL='LN'">
																(non in liquidazione)
															</xsl:when>
															<xsl:when test="$SL=''">
															</xsl:when>
															<xsl:otherwise>
																<span>(!!! codice non previsto !!!)</span>
															</xsl:otherwise>
														</xsl:choose></td></tr>
													</xsl:for-each>
												</xsl:if>												
												<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/Contatti">
													<xsl:if test="Telefono or Fax or Email">

														<xsl:if test="Telefono">
															<tr><td>Telefono (Cedente/Prestatore): <span>
																	<xsl:value-of select="Telefono" />
																</span></td></tr>
														</xsl:if>
														<xsl:if test="Fax">
															<tr><td>Fax (Cedente/Prestatore): <span>
																	<xsl:value-of select="Fax" />
																</span></td></tr>
														</xsl:if>
														<xsl:if test="Email">
															<tr><td >E-mail (Cedente/Prestatore): <span class="font-underline">
																	<xsl:value-of select="Email" />
																</span></td></tr>
														</xsl:if>
													</xsl:if>
												</xsl:for-each>
												<xsl:if test="a:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/RiferimentoAmministrazione">
													<tr><td>Riferimento amministrativo: <span>
															<xsl:value-of select="a:FatturaElettronica/FatturaElettronicaHeader/CedentePrestatore/RiferimentoAmministrazione" />
														</span></td></tr>
												</xsl:if>												
												<xsl:if test="a:FatturaElettronica/FatturaElettronicaHeader">
													<xsl:if test="a:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione">
														<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione">
															<xsl:if test="ContattiTrasmittente/Telefono">
																<tr><td>Telefono: <span>
																		<xsl:value-of select="ContattiTrasmittente/Telefono" />
																	</span></td></tr>
															</xsl:if>
															<xsl:if test="ContattiTrasmittente/Email">
															<tr><td >E-mail: <span class="font-underline">
																	<xsl:value-of select="ContattiTrasmittente/Email" />
																</span></td></tr>
															</xsl:if>
														</xsl:for-each>
													</xsl:if>
													<!--FINE DATI DELLA TRASMISSIONE-->
												</xsl:if>
												
												<!--INIZIO DATI RAPPRESENTANTE FISCALE-->
												<xsl:if test="a:FatturaElettronica/FatturaElettronicaHeader/RappresentanteFiscale">
													<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/RappresentanteFiscale/DatiAnagrafici">
														<xsl:variable name="Titolo">
															<xsl:value-of select="Anagrafica/Titolo"/>
														</xsl:variable>
														<xsl:variable name="Nome">
															<xsl:value-of select="Anagrafica/Nome"/>
														</xsl:variable>
														<xsl:variable name="Cognome">
															<xsl:value-of select="Anagrafica/Cognome"/>
														</xsl:variable>
														<tr><td>Rappresentante Fiscale: <xsl:value-of select="concat($Titolo, ' ', $Nome, ' ', $Cognome)" />
														<xsl:if test="Anagrafica/Denominazione">
															<xsl:value-of select="Anagrafica/Denominazione" />
														</xsl:if>
														</td></tr>
														<tr><td>Identificativo fiscale ai fini IVA: <span>
																	<xsl:value-of select="IdFiscaleIVA/IdPaese" />
																	<xsl:value-of select="IdFiscaleIVA/IdCodice" />
																</span></td></tr>
														<tr><td>Codice Fiscale: <span>
																<xsl:value-of select="CodiceFiscale" />
															</span></td></tr>
														<xsl:if test="Anagrafica/CodEORI">
															<tr><td>Codice EORI: <xsl:value-of select="Anagrafica/CodEORI" /></td></tr>
														</xsl:if>														
													</xsl:for-each>
												</xsl:if>
												<!--FINE DATI RAPPRESENTANTE FISCALE-->
										</table>
										</td></tr>
								<!--INIZIO DATI TERZO INTERMEDIARIO SOGGETTO EMITTENTE-->
								<xsl:if test="a:FatturaElettronica/FatturaElettronicaHeader/TerzoIntermediarioOSoggettoEmittente">
									<tr>
										<td width="47%" class="borderRad">
											<table width="100%" cellpadding="0" cellspacing="0" class="intest">
												<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/TerzoIntermediarioOSoggettoEmittente">
													<xsl:variable name="Titolo">
														<xsl:value-of select="DatiAnagrafici/Anagrafica/Titolo"/>
													</xsl:variable>
													<xsl:variable name="Nome">
														<xsl:value-of select="DatiAnagrafici/Anagrafica/Nome"/>
													</xsl:variable>
													<xsl:variable name="Cognome">
														<xsl:value-of select="DatiAnagrafici/Anagrafica/Cognome"/>
													</xsl:variable>
													<tr><td>Terzo Intermediario: <xsl:value-of select="concat($Titolo, ' ', $Nome, ' ', $Cognome)" />
													<xsl:if test="DatiAnagrafici/Anagrafica/Denominazione">
														<xsl:value-of select="DatiAnagrafici/Anagrafica/Denominazione" />
													</xsl:if>
													</td></tr>
													<tr><td>Identificativo fiscale ai fini IVA: <span>
																<xsl:value-of select="DatiAnagrafici/IdFiscaleIVA/IdPaese" />
																<xsl:value-of select="DatiAnagrafici/IdFiscaleIVA/IdCodice" />
															</span></td></tr>
													<tr><td>Codice Fiscale: <span>
															<xsl:value-of select="DatiAnagrafici/CodiceFiscale" />
														</span></td></tr>
													<xsl:if test="DatiAnagrafici/Anagrafica/CodEORI">
														<tr><td>Codice EORI: <xsl:value-of select="DatiAnagrafici/Anagrafica/CodEORI" /></td></tr>
													</xsl:if>														
												</xsl:for-each>
											</table>
										</td>
									</tr>
								</xsl:if>
								<!--FINE DATI TERZO INTERMEDIARIO SOGGETTO EMITTENTE-->
										</table>
									</td>
									<td width="6%"></td>
									<td width="47%" class="borderRad">
										<!--INIZIO DATI CESSIONARIO COMMITTENTE-->
										<xsl:if test="a:FatturaElettronica/FatturaElettronicaHeader/CessionarioCommittente">
											<table width="100%" cellpadding="0" cellspacing="0" class="intest">
												<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/CessionarioCommittente/DatiAnagrafici">
													<xsl:variable name="Titolo">
														<xsl:value-of select="Anagrafica/Titolo"/>
													</xsl:variable>
													<xsl:variable name="Nome">
														<xsl:value-of select="Anagrafica/Nome"/>
													</xsl:variable>
													<xsl:variable name="Cognome">
														<xsl:value-of select="Anagrafica/Cognome"/>
													</xsl:variable>
													<tr><td>Cessionario/committente: <xsl:value-of select="concat($Titolo, ' ', $Nome, ' ', $Cognome)" />
													<xsl:if test="Anagrafica/Denominazione">
													<xsl:value-of select="Anagrafica/Denominazione" />
													</xsl:if>
													</td></tr>
													<tr><td>Identificativo fiscale ai fini IVA: <span>
																<xsl:value-of select="IdFiscaleIVA/IdPaese" />
																<xsl:value-of select="IdFiscaleIVA/IdCodice" />
															</span></td></tr>
													<tr><td>Codice Fiscale: <span>
															<xsl:value-of select="CodiceFiscale" />
														</span></td></tr>
													<xsl:if test="Anagrafica/CodEORI">
														<tr><td>Codice EORI: <xsl:value-of select="Anagrafica/CodEORI" /></td></tr>
													</xsl:if>														
												</xsl:for-each>
												<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/CessionarioCommittente/Sede">
													<tr><td>Sede: <xsl:value-of select="Indirizzo" /> N <xsl:value-of select="NumeroCivico" /> - <xsl:value-of select="CAP" /> - <xsl:value-of select="Comune" /> (<xsl:value-of select="Provincia" />) <xsl:value-of select="Nazione" /></td></tr>
												</xsl:for-each>
												<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/CessionarioCommittente/StabileOrganizzazione">
													<tr><td>Stabile Organizzazione: <xsl:value-of select="Indirizzo" /> N <xsl:value-of select="NumeroCivico" /> - <xsl:value-of select="CAP" /> - <xsl:value-of select="Comune" /> (<xsl:value-of select="Provincia" />) <xsl:value-of select="Nazione" /></td></tr>
												</xsl:for-each>
												<xsl:if test="a:FatturaElettronica/FatturaElettronicaHeader">
													<xsl:if test="a:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione">
														<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/DatiTrasmissione">
															<tr><td>Codice Univoco: <span class="font-italic font-bold"><xsl:value-of select="CodiceDestinatario" /></span></td></tr>
														</xsl:for-each>
													</xsl:if>
													<!--FINE DATI DELLA TRASMISSIONE-->
												</xsl:if>
												<xsl:if test="a:FatturaElettronica/FatturaElettronicaHeader/CessionarioCommittente/RappresentanteFiscale">
													<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaHeader/CessionarioCommittente/RappresentanteFiscale">
														<xsl:variable name="Nome">
															<xsl:value-of select="Nome"/>
														</xsl:variable>
														<xsl:variable name="Cognome">
															<xsl:value-of select="Cognome"/>
														</xsl:variable>
														<tr><td>Rappresentante Fiscale: <xsl:value-of select="concat($Nome, ' ', $Cognome)" />
														<xsl:if test="Denominazione">
														<xsl:value-of select="Denominazione" />
														</xsl:if>
														</td></tr>
														<tr><td>Identificativo fiscale ai fini IVA: <span>
																	<xsl:value-of select="IdFiscaleIVA/IdPaese" />
																	<xsl:value-of select="IdFiscaleIVA/IdCodice" />
																</span></td></tr>

													</xsl:for-each>
												</xsl:if>
											</table>
										</xsl:if>
										<!--FINE DATI CESSIONARIO COMMITTENTE-->
									</td>
								</tr>
										</table>
									</td>
								</tr>
							</table>
							</div>
							<table class="pg" width="100%" align="center" cellpadding="0">
						<xsl:for-each select="a:FatturaElettronica/FatturaElettronicaBody">							
						<xsl:variable name="all-ddt" select="DatiGenerali/DatiDDT" />
						<xsl:variable name="all-dett" select="DatiBeniServizi/DettaglioLinee" />
							<xsl:variable name="VALUTA">
								<xsl:value-of select="DatiGenerali/DatiGeneraliDocumento/Divisa" />
							</xsl:variable>
							<xsl:variable name="TipoDocumento">
								<xsl:value-of select="DatiGenerali/DatiGeneraliDocumento/TipoDocumento" />
							</xsl:variable>
														
							<div class="page_footer">
								<tr>
									<td width="100%" colspan="2" class="page_footer">
									<table width="100%" class="page_footer">
										<tr>
											<td colspan="25%"> </td>
											<td colspan="50%">
												<xsl:choose>
													<xsl:when test="$TipoDocumento='TD01'">
														FATTURA
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD02'">
														ACCONTO/ANTICIPO SU FATTURA
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD03'">
														ACCONTO/ANTICIPO SU PARCELLA									
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD04'">
														NOTA DI CREDITO
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD05'">
														NOTA DI DEBITO
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD06'">
														PARCELLA
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD16'">
														Integrazione fattura 
														reverse charge interno
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD17'">
														Integrazione/autofattura per 
														acquisto servizi da estero
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD18'">
														Integrazione per acquisto 
														beni intracomunitari
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD19'">
														Integrazione/autofattura per 
														acquisto beni ex art.17 c.2 DPR 633/72
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD20'">
														Autofattura per regolarizzazione e 
														integrazione delle fatture - 
														art.6 c.8 d.lgs.471/97 o art.46 c.5 D.L.331/93
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD21'">
														Autofattura per splafonamento
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD22'">
														Estrazione beni da Deposito IVA
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD23'">
														Estrazione beni da Deposito IVA 
														con versamento IVA
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD24'">
														Fattura differita - art.21 c.4 lett. a
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD25'">
														Fattura differita - art.21 c.4 terzo periodo lett. b
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD26'">
														Cessione di beni ammortizzabili e per 
														passaggi interni - art.36 DPR 633/72
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD27'">
														Fattura per autoconsumo o per cessioni 
														gratuite senza rivalsa
													</xsl:when>
												</xsl:choose> NR. <xsl:value-of select="DatiGenerali/DatiGeneraliDocumento/Numero" /> DEL <xsl:call-template name="FormatDateCompact">
										<xsl:with-param name="DateTime" select="DatiGenerali/DatiGeneraliDocumento/Data" />
									</xsl:call-template><br/>
									Printed by Adiuto v 1.28 ( www.Adiuto.it)
											</td>
											<td colspan="25%" align="right"><div id="pageFooter"></div></td>
										</tr>
									</table>
									</td>
								</tr>
							</div>
								<tr>
									<td width="100%" colspan="2" class="borderRad">
										<table width="100%" cellspacing="5">
											<tr>
												<td colspan="2" class="font-bold"><xsl:choose>
													<xsl:when test="$TipoDocumento='TD01'">
														FATTURA
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD02'">
														ACCONTO/ANTICIPO SU FATTURA
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD03'">
														ACCONTO/ANTICIPO SU PARCELLA									
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD04'">
														NOTA DI CREDITO
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD05'">
														NOTA DI DEBITO
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD06'">
														PARCELLA
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD16'">
														integrazione fattura 
														reverse charge interno
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD17'">
														Integrazione/autofattura per 
														acquisto servizi da estero
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD18'">
														Integrazione per acquisto 
														beni intracomunitari
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD19'">
														Integrazione/autofattura per 
														acquisto beni ex art.17 c.2 DPR 633/72
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD20'">
														Autofattura per regolarizzazione e 
														integrazione delle fatture - 
														art.6 c.8 d.lgs.471/97 o art.46 c.5 D.L.331/93
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD21'">
														Autofattura per splafonamento
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD22'">
														Estrazione beni da Deposito IVA
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD23'">
														Estrazione beni da Deposito IVA 
														con versamento IVA
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD24'">
														Fattura differita - art.21 c.4 lett. a
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD25'">
														Fattura differita - art.21 c.4 terzo periodo lett. b
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD26'">
														Cessione di beni ammortizzabili e per 
														passaggi interni - art.36 DPR 633/72
													</xsl:when>
													<xsl:when test="$TipoDocumento='TD27'">
														Fattura per autoconsumo o per cessioni 
														gratuite senza rivalsa
													</xsl:when>												</xsl:choose> NR. <span class="spacePre"><xsl:value-of select="DatiGenerali/DatiGeneraliDocumento/Numero" /></span> DEL <xsl:call-template name="FormatDateCompact">
																	<xsl:with-param name="DateTime" select="DatiGenerali/DatiGeneraliDocumento/Data" />
																</xsl:call-template></td>
											</tr>
											<tr>
												<td colspan="2"></td>
											</tr>
											<tr>
												<td width="30%">Importo totale documento:</td>
												<td width="70%"><xsl:if test="DatiGenerali/DatiGeneraliDocumento/ImportoTotaleDocumento"><xsl:value-of select="format-number(DatiGenerali/DatiGeneraliDocumento/ImportoTotaleDocumento, '###.##0,00#########', 'euro')" /> (<xsl:value-of select="$VALUTA" />)</xsl:if></td>
											</tr>
											<xsl:if test="DatiGenerali/DatiGeneraliDocumento/Arrotondamento">
												<tr>
													<td width="30%">Arrotondamento su Importo totale documento:</td>
													<td width="70%"><xsl:value-of select="DatiGenerali/DatiGeneraliDocumento/Arrotondamento" /></td>
												</tr>
											</xsl:if>
											<xsl:for-each select="DatiGenerali/DatiGeneraliDocumento/Causale">
												<tr>
													<td width="30%">Causale:</td>
													<td width="70%"><xsl:value-of select="current()" /></td>
												</tr>
											</xsl:for-each>
											<xsl:if test="DatiGenerali/DatiGeneraliDocumento/Art73">
												<tr>
													<td width="30%">Art. 73 DPR 633/72:</td>
													<td width="70%"><xsl:value-of select="DatiGenerali/DatiGeneraliDocumento/Art73" /></td>
												</tr>
											</xsl:if>
											
											<xsl:for-each select="DatiPagamento">
												<xsl:for-each select="DettaglioPagamento">
													<tr>
														<td width="30%">
														Importo Pagamento<xsl:if test="DataScadenzaPagamento">
														 entro il <br/><xsl:call-template name="FormatDateCompact">
															<xsl:with-param name="DateTime" select="DataScadenzaPagamento" />
														</xsl:call-template>
														</xsl:if>:
														</td>
														<td width="70%"><xsl:if test="ImportoPagamento"><xsl:value-of select="format-number(ImportoPagamento, '###.##0,00#########', 'euro')" /> (<xsl:value-of select="$VALUTA" />)</xsl:if></td>
													</tr>
													<xsl:if test="GiorniTerminiPagamento">
														<tr>
															<td width="30%">
																Termini di pagamento (in giorni):
															</td>
															<td width="70%">
																<xsl:value-of select="GiorniTerminiPagamento" />
															</td>
														</tr>
													</xsl:if>
												</xsl:for-each>
											</xsl:for-each>
										</table>
									</td>
								</tr>
								<tr>
									<td width="100%" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Riassunto dettagli fattura</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
											<tr class="trtitle font-bold">
												<td class="text-center">Doc.</td>
												<td class="text-center">Cod. Articolo</td>
												<td class="text-center">Descrizione</td>
												<td class="text-center" width="40px">Quantità</td>
												<td class="text-center" width="40px">Unità misure</td>
												<td class="text-center" width="40px">Valore unitario <br/> (<xsl:value-of select="$VALUTA" />)</td>
												<td class="text-center" width="40px">Valore totale <br/> (<xsl:value-of select="$VALUTA" />)</td>
												<td class="text-center" width="40px">Aliquota IVA <br/> (Natura operazione)</td>
												<td class="text-center">Sconto</td>

												</tr>
											<xsl:for-each select="DatiBeniServizi/DettaglioLinee">
												<tr>
													<xsl:if test="not(contains(Descrizione, ' ')) and string-length(Descrizione) > 40"><td class="text-center" rowspan="2"><xsl:value-of select="NumeroLinea" /></td></xsl:if>
													<xsl:if test="not(not(contains(Descrizione, ' ')) and string-length(Descrizione) > 40)"><td class="text-center" ><xsl:value-of select="NumeroLinea" /></td></xsl:if>
													<td>
														<xsl:for-each select="CodiceArticolo">
															<xsl:if test="CodiceTipo">
															<xsl:value-of select="CodiceTipo" />&#160;
															</xsl:if>
															<xsl:if test="CodiceValore">
															<xsl:value-of select="CodiceValore" />
															</xsl:if>
															<br/>
														</xsl:for-each>
													</td>
													<td><xsl:if test="not(not(contains(Descrizione, ' ')) and string-length(Descrizione) > 40)"><xsl:value-of select="Descrizione" /></xsl:if>
														<xsl:variable name="NLINEA">
															<xsl:value-of select="NumeroLinea" />
														</xsl:variable>
														<xsl:for-each select="$all-ddt">
															<xsl:variable name="NumeroDDT_TEMP">
																<xsl:value-of select="NumeroDDT" />
															</xsl:variable>
															<xsl:variable name="DataDDT_TEMP">
																<xsl:value-of select="DataDDT" />
															</xsl:variable>
															<xsl:for-each select="RiferimentoNumeroLinea">
																<xsl:variable name="DDTLINEA">
																	<xsl:value-of select="." />
																</xsl:variable>
																<xsl:if test="$DDTLINEA = $NLINEA">
																	<br/>Numero DDT: <xsl:value-of select="$NumeroDDT_TEMP" />
																	Data DDT:<xsl:call-template name="FormatDateCompact">
																		<xsl:with-param name="DateTime" select="$DataDDT_TEMP" />
																	</xsl:call-template>
																</xsl:if>
															</xsl:for-each>
														</xsl:for-each>
													</td>
													<td class="text-center"><xsl:if test="Quantita"><xsl:value-of select="format-number(Quantita, '###.###,###', 'euro')" /></xsl:if></td>
													<td class="text-center"><xsl:value-of select="UnitaMisura" /></td>
													<td class="text-right"><xsl:value-of select="format-number(PrezzoUnitario, '###.##0,00#########', 'euro')" /></td>
													<td class="text-right"><xsl:value-of select="format-number(PrezzoTotale, '###.##0,00#########', 'euro')" /></td>
													<td class="text-center"><xsl:value-of select="AliquotaIVA" />%
														<div class="smallText">
															<xsl:if test="Natura">
																<br/>
																<xsl:variable name="NAT">
																	<xsl:value-of select="Natura" />
																</xsl:variable>
																<xsl:choose>
																	<xsl:when test="$NAT='N1'">
																		(esclusa ex art.15)
																	</xsl:when>
																	<xsl:when test="$NAT='N2'">
																		(non soggetta)
																	</xsl:when>
																	<xsl:when test="$NAT='N2.1'">
																		(non soggette ad IVA - artt. da 7 a 7-septies 
																		del DPR 633/72)
																	</xsl:when>
																	<xsl:when test="$NAT='N2.2'">
																		(non soggette - altri casi)
																	</xsl:when>
																	<xsl:when test="$NAT='N3'">
																		(non imponibili)
																	</xsl:when>
																	<xsl:when test="$NAT='N3.1'">
																		(non imponibili - esportazioni)
																	</xsl:when>
																	<xsl:when test="$NAT='N3.2'">
																		(non imponibili - cessioni intracomunitarie)
																	</xsl:when>
																	<xsl:when test="$NAT='N3.3'">
																		(non imponibili - cessioni verso S.Marino)
																	</xsl:when>
																	<xsl:when test="$NAT='N3.4'">
																		(non imponibili - operazioni assimilate alle 
																		cessioni all'esportazione)
																	</xsl:when>
																	<xsl:when test="$NAT='N3.5'">
																		(non imponibili - a seguito di dichiarazioni 
																		d'intento)
																	</xsl:when>
																	<xsl:when test="$NAT='N3.6'">
																		(non imponibili - altre operazioni che non 
																		concorrono alla formazione del plafond)
																	</xsl:when>
																	<xsl:when test="$NAT='N4'">
																		(esenti)
																	</xsl:when>
																	<xsl:when test="$NAT='N5'">
																		(regime del margine / IVA non esposta in fattura)
																	</xsl:when>
																	<xsl:when test="$NAT='N6'">
																		(inversione contabile per le operazioni in reverse 
																		charge ovvero nei casi di autofatturazione per 
																		acquisti extra UE di servizi ovvero per importazioni 
																		di beni nei soli casi previsti)
																	</xsl:when>
																	<xsl:when test="$NAT='N6.1'">
																		(inversione contabile - cessione di rottami e 
																		altri materiali di recupero)
																	</xsl:when>
																	<xsl:when test="$NAT='N6.2'">
																		(inversione contabile - cessione di oro e 
																		argento puro)
																	</xsl:when>
																	<xsl:when test="$NAT='N6.3'">
																		(inversione contabile - subappalto nel settore 
																		edile)
																	</xsl:when>
																	<xsl:when test="$NAT='N6.4'">
																		(inversione contabile - cessione di fabbricati)
																	</xsl:when>
																	<xsl:when test="$NAT='N6.5'">
																		(inversione contabile - cessione di telefoni 
																		cellulari)
																	</xsl:when>
																	<xsl:when test="$NAT='N6.6'">
																		(inversione contabile - cessione di prodotti 
																		elettronici)
																	</xsl:when>
																	<xsl:when test="$NAT='N6.7'">
																		(inversione contabile - prestazioni comparto 
																		edile e settori connessi)
																	</xsl:when>
																	<xsl:when test="$NAT='N6.8'">
																		(inversione contabile - operazioni settore 
																		energetico)
																	</xsl:when>
																	<xsl:when test="$NAT='N6.9'">
																		(inversione contabile - altri casi)
																	</xsl:when>
																	<xsl:when test="$NAT='N7'">
																		(IVA assolta in altro stato UE - vendite a distanza 
																		ex art.40 c.3 e 4 e art.41 c.1 lett. b DL 331/93; 
																		prestazione di servizi di telecomunicazioni, 
																		tele-radiodiffusione ed elettronici ex art.7-sexies 
																		lett. f, g, e art.74-sexies DPR 633/72)
																	</xsl:when>
																	<xsl:otherwise>
																		<span>(!!! codice non previsto !!!)</span>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:if>
														</div>
													</td>
													<td>
														<xsl:if test="ScontoMaggiorazione">
															<xsl:for-each select="ScontoMaggiorazione">
																<xsl:if test="Tipo">
																		Tipo:
																		<span>
																			<xsl:value-of select="Tipo" />
																		</span>
																		<xsl:variable name="TSCM">
																			<xsl:value-of select="Tipo" />
																		</xsl:variable>
																		<xsl:choose>
																			<xsl:when test="$TSCM='SC'">

																				(sconto)
																			</xsl:when>
																			<xsl:when test="$TSCM='MG'">

																				(maggiorazione)
																			</xsl:when>
																			<xsl:otherwise>

																				<span>(!!! codice non previsto !!!)</span>
																			</xsl:otherwise>
																		</xsl:choose>
																</xsl:if>
																<xsl:if test="Percentuale">
																		Percentuale (%):
																		<span>
																			<xsl:value-of select="Percentuale" />
																		</span>
																</xsl:if>
																<xsl:if test="Importo">
																		Importo:
																		<span>
																			<xsl:value-of select="Importo" />
																		</span>
																</xsl:if>
															</xsl:for-each>
														</xsl:if>
													</td>
												</tr>
												<xsl:if test="not(contains(Descrizione, ' ')) and string-length(Descrizione) > 40">
													<tr>
														<td colspan="9">
															<xsl:value-of select="Descrizione" />
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="AltriDatiGestionali">
													<tr>
														<td colspan="9" class="text-center" width="100%">
															<table border="0" width="95%">
																<xsl:for-each select="AltriDatiGestionali">
																	<tr>
																		<td class="noBorder" width="25%"><xsl:value-of select="TipoDato" /></td>
																		<td class="noBorder" width="25%"><xsl:value-of select="RiferimentoTesto" /></td>
																		<td class="noBorder" width="25%"><xsl:value-of select="RiferimentoNumero" /></td>
																		<td class="noBorder" width="25%">
																			<xsl:if test="RiferimentoData">
																				<xsl:call-template name="FormatDateCompact">
																					<xsl:with-param name="DateTime" select="RiferimentoData" />
																				</xsl:call-template>
																			</xsl:if>
																		</td>
																	</tr>
																</xsl:for-each>
															</table>
														</td>
													</tr>
												</xsl:if>
												<xsl:if test="DataInizioPeriodo or DataFinePeriodo">
													<tr>
														<td colspan="9" class="text-center" width="100%">
															<table border="0" width="95%">
																<tr>
																	<td class="noBorder" width="25%">Data inizio periodo di riferimento</td>
																	<td class="noBorder" width="25%">
																		<xsl:if test="DataInizioPeriodo">
																			<xsl:call-template name="FormatDateCompact">
																				<xsl:with-param name="DateTime" select="DataInizioPeriodo" />
																			</xsl:call-template>
																		</xsl:if>
																	</td>
																	<td class="noBorder" width="25%">Data fine periodo di riferimento</td>
																	<td class="noBorder" width="25%">
																		<xsl:if test="DataFinePeriodo">
																			<xsl:call-template name="FormatDateCompact">
																				<xsl:with-param name="DateTime" select="DataFinePeriodo" />
																			</xsl:call-template>
																		</xsl:if>
																	</td>
																</tr>
															</table>
														</td>
													</tr>
												</xsl:if>
												
											</xsl:for-each>
										</table>
									</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
												<xsl:for-each select="DatiBeniServizi/DettaglioLinee">
													<xsl:if test="TipoCessionePrestazione or Ritenuta or RiferimentoAmministrazione">
													<tr class="trtitle otherTitle font-bold">
														<td class="text-center">Doc.</td>
														<td class="text-center">Tipo cessione/prestazione</td>
														<td class="text-center">Soggetta a ritenuta</td>
														<td class="text-center">Riferimento amministrativo/contabile</td>
													</tr>
													<tr>
														<td class="text-center"><xsl:value-of select="NumeroLinea" /></td>
														<td class="text-center">
															<xsl:if test="TipoCessionePrestazione">
																<xsl:variable name="TCP">
																	<xsl:value-of select="TipoCessionePrestazione" />
																</xsl:variable>
																<xsl:choose>
																	<xsl:when test="$TCP='SC'">
																		(sconto)
																	</xsl:when>
																	<xsl:when test="$TCP='PR'">
																		(premio)
																	</xsl:when>
																	<xsl:when test="$TCP='AB'">
																		(abbuono)
																	</xsl:when>
																	<xsl:when test="$TCP='AC'">
																		(spesa accessoria)
																	</xsl:when>
																	<xsl:otherwise>
																		<span>(!!! codice non previsto !!!)</span>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:if>
														</td>
														<td class="text-center">
															<xsl:if test="Ritenuta">
																<xsl:value-of select="Ritenuta" />
															</xsl:if>
														</td>
														<td class="text-center">
															<xsl:if test="RiferimentoAmministrazione">
																<xsl:value-of select="RiferimentoAmministrazione" />
															</xsl:if>													
														</td>
													</tr>
												</xsl:if>
												</xsl:for-each>
										</table>
									</td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Dati generali</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
											<tr class="trtitle font-bold">
												<td class="text-center">Tipologia</td>
												<td class="text-center">Documento</td>
												<td class="text-center">Data</td>
												<td class="text-center">Numero</td>
												<td class="text-center">Codice commessa/convenzione</td>
												<td class="text-center">CUP</td>
												<td class="text-center">CIG</td>
												<td class="text-center">Numero di linea di fattura</td>
											</tr>
											<xsl:for-each select="DatiGenerali/DatiOrdineAcquisto">
												<tr>
													<td class="text-center">Ordine di acquisto</td>
													<td class="text-center"><xsl:value-of select="IdDocumento" /></td>
													<td class="text-center">
														<xsl:if test="Data">
															<xsl:call-template name="FormatDateCompact">
																<xsl:with-param name="DateTime" select="Data" />
															</xsl:call-template>
														</xsl:if>
													</td>
													<td class="text-center"><xsl:value-of select="NumItem" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCommessaConvenzione" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCUP" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCIG" /></td>
													<td class="text-center"><xsl:for-each select="RiferimentoNumeroLinea">
																		<span>
																			<xsl:if test="(position( )) > 1">
																				,
																			</xsl:if>
																			<xsl:value-of select="." />
																		</span>
																	</xsl:for-each></td>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="DatiGenerali/DatiContratto">
												<tr>
													<td class="text-center">Contratto</td>
													<td class="text-center"><xsl:value-of select="IdDocumento" /></td>
													<td class="text-center">
														<xsl:if test="Data">
															<xsl:call-template name="FormatDateCompact">
																<xsl:with-param name="DateTime" select="Data" />
															</xsl:call-template>
														</xsl:if>
													</td>
													<td class="text-center"><xsl:value-of select="NumItem" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCommessaConvenzione" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCUP" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCIG" /></td>
													<td class="text-center"><xsl:for-each select="RiferimentoNumeroLinea">
																		<span>
																			<xsl:if test="(position( )) > 1">
																				,
																			</xsl:if>
																			<xsl:value-of select="." />
																		</span>
																	</xsl:for-each></td>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="DatiGenerali/DatiConvenzione">
												<tr>
													<td class="text-center">Convenzione</td>
													<td class="text-center"><xsl:value-of select="IdDocumento" /></td>
													<td class="text-center">
														<xsl:if test="Data">
															<xsl:call-template name="FormatDateCompact">
																<xsl:with-param name="DateTime" select="Data" />
															</xsl:call-template>
														</xsl:if>
													</td>
													<td class="text-center"><xsl:value-of select="NumItem" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCommessaConvenzione" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCUP" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCIG" /></td>
													<td class="text-center"><xsl:for-each select="RiferimentoNumeroLinea">
																		<span>
																			<xsl:if test="(position( )) > 1">
																				,
																			</xsl:if>
																			<xsl:value-of select="." />
																		</span>
																	</xsl:for-each></td>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="DatiGenerali/DatiRicezione">
												<tr>
													<td class="text-center">Ricezione</td>
													<td class="text-center"><xsl:value-of select="IdDocumento" /></td>
													<td class="text-center">
														<xsl:if test="Data">
															<xsl:call-template name="FormatDateCompact">
																<xsl:with-param name="DateTime" select="Data" />
															</xsl:call-template>
														</xsl:if>
													</td>
													<td class="text-center"><xsl:value-of select="NumItem" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCommessaConvenzione" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCUP" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCIG" /></td>
													<td class="text-center"><xsl:for-each select="RiferimentoNumeroLinea">
																		<span>
																			<xsl:if test="(position( )) > 1">
																				,
																			</xsl:if>
																			<xsl:value-of select="." />
																		</span>
																	</xsl:for-each></td>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="DatiGenerali/DatiFattureCollegate">
												<tr>
													<td class="text-center">Fatture Collegate</td>
													<td class="text-center"><xsl:value-of select="IdDocumento" /></td>
													<td class="text-center">
														<xsl:if test="Data">
															<xsl:call-template name="FormatDateCompact">
																<xsl:with-param name="DateTime" select="Data" />
															</xsl:call-template>
														</xsl:if>
													</td>
													<td class="text-center"><xsl:value-of select="NumItem" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCommessaConvenzione" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCUP" /></td>
													<td class="text-center"><xsl:value-of select="CodiceCIG" /></td>
													<td class="text-center"><xsl:for-each select="RiferimentoNumeroLinea">
																		<span>
																			<xsl:if test="(position( )) > 1">
																				,
																			</xsl:if>
																			<xsl:value-of select="." />
																		</span>
																	</xsl:for-each></td>
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
								
							<!--INIZIO DATI RIFERIMENTO SAL-->
							<xsl:if test="DatiGenerali/DatiSAL">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Stato avanzamento lavori</td>
								</tr>
								<tr>
									<td width="50%" class="font-bold">Numero fase avanzamento:</td>
									<td width="50%">
										<xsl:for-each select="DatiGenerali/DatiSAL/RiferimentoFase">
											<span>
												<xsl:if test="(position( )) > 1">
													,
												</xsl:if>
												<xsl:value-of select="." />
											</span>
										</xsl:for-each>
									</td>
								</tr>
							</xsl:if>
							<!--FINE DATI RIFERIMENTO SAL-->
								
							<!--INIZIO DATI  DDT-->
							<xsl:if test="DatiGenerali/DatiDDT">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderDDT" width="100%" cellpadding="2" cellspacing="0">
											<xsl:for-each select="DatiGenerali/DatiDDT">
											<xsl:variable name="COMPARATORE">
												<xsl:for-each select="RiferimentoNumeroLinea">
													<xsl:variable name="DDTLINEA">
														<xsl:value-of select="." />
													</xsl:variable>
													<xsl:value-of select="'Y'" />
												</xsl:for-each>
											</xsl:variable>

											<xsl:variable name="ABBINATO">
												<xsl:for-each select="RiferimentoNumeroLinea">
													<xsl:variable name="DDTLINEA">
														<xsl:value-of select="." />
													</xsl:variable>
														<xsl:for-each select="$all-dett">
															<xsl:variable name="NumeroLinea_TEMP">
																<xsl:value-of select="NumeroLinea" />
															</xsl:variable>
															<xsl:if test="$DDTLINEA = $NumeroLinea_TEMP">
																<xsl:value-of select="'Y'" />
															</xsl:if>
														</xsl:for-each>
												</xsl:for-each>
											</xsl:variable>
											<xsl:if test="not($ABBINATO = $COMPARATORE) or string-length($ABBINATO) = 0">
												<tr class="twoTitle">
													<td width="100%" class="font-bold" colspan="3">Dati di trasporto (DDT)</td>
												</tr>
												<tr class="trtitle twoTitle font-bold">
													<td class="text-center">Numero DDT</td>
													<td class="text-center">Data DDT</td>
													<td class="text-center">Numero di linea di fattura</td>
												</tr>
												<tr class="DDTROW">
													<td class="text-center"><xsl:value-of select="NumeroDDT" /></td>
													<td class="text-center"><xsl:call-template name="FormatDateCompact">
																	<xsl:with-param name="DateTime" select="DataDDT" />
																</xsl:call-template></td>
													<td class="text-center"><xsl:for-each select="RiferimentoNumeroLinea">
																	<span>
																		<xsl:if test="(position( )) > 1">
																			,
																		</xsl:if>
																		<xsl:value-of select="." />
																	</span>
																</xsl:for-each></td>
												</tr>
											</xsl:if>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:if>
							<!--FINE DATI DDT-->

							<!--INIZIO DATI  TRASPORTO-->
							<xsl:if test="DatiGenerali/DatiTrasporto/DatiAnagraficiVettore">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Dati relativi al trasporto</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
											<tr class="trtitle font-bold">
												<td class="text-center">Identificativo fiscale ai fini IVA</td>
												<td class="text-center">Codice Fiscale</td>
												<td class="text-center">Denominazione</td>
												<td class="text-center">Codice EORI</td>
												<td class="text-center">Numero licenza di guida</td>
											</tr>
											<xsl:for-each select="DatiGenerali/DatiTrasporto/DatiAnagraficiVettore">
												<tr>
													<td class="text-center">
														<xsl:if test="IdFiscaleIVA/IdPaese">
															<xsl:value-of select="IdFiscaleIVA/IdPaese" />
															<xsl:value-of select="IdFiscaleIVA/IdCodice" />
														</xsl:if>
													</td>
													<td class="text-center"><xsl:value-of select="CodiceFiscale" /></td>
														<xsl:variable name="Titolo">
															<xsl:value-of select="Anagrafica/Titolo"/>
														</xsl:variable>
														<xsl:variable name="Nome">
															<xsl:value-of select="Anagrafica/Nome"/>
														</xsl:variable>
														<xsl:variable name="Cognome">
															<xsl:value-of select="Anagrafica/Cognome"/>
														</xsl:variable>
													<td><xsl:value-of select="concat($Titolo, ' ', $Nome, ' ', $Cognome)" />
														<xsl:if test="Anagrafica/Denominazione">
														<xsl:value-of select="Anagrafica/Denominazione" />
														</xsl:if>
													</td>
													<td class="text-center"><xsl:value-of select="Anagrafica/CodEORI" /></td>
													<td class="text-center"><xsl:value-of select="NumeroLicenzaGuida" /></td>
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:if>
							
							<xsl:if
								test="DatiGenerali/DatiTrasporto/MezzoTrasporto or DatiGenerali/DatiTrasporto/CausaleTrasporto or DatiGenerali/DatiTrasporto/NumeroColli or DatiGenerali/DatiTrasporto/Descrizione or DatiGenerali/DatiTrasporto/UnitaMisuraPeso or DatiGenerali/DatiTrasporto/PesoLordo or DatiGenerali/DatiTrasporto/PesoNetto or DatiGenerali/DatiTrasporto/DataOraRitiro or DatiGenerali/DatiTrasporto/DataInizioTrasporto or DatiGenerali/DatiTrasporto/TipoResa or DatiGenerali/DatiTrasporto/IndirizzoResa">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Altri dati</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
											<tr class="trtitle font-bold">
												<td class="text-center">Mezzo di trasporto</td>
												<td class="text-center">Causale Trasporto</td>
												<td class="text-center">Numero Colli</td>
												<td class="text-center">Descrizione Beni</td>
												<td class="text-center">U.d.M.</td>
												<td class="text-center">Peso lordo</td>
												<td class="text-center">Peso netto</td>
												<td class="text-center">Data Ora Ritiro</td>
												<td class="text-center">Data inizio trasporto</td>
												<td class="text-center">Tipo Resa</td>
												<td class="text-center">Indirizzo di resa</td>
											</tr>
											<xsl:for-each select="DatiGenerali/DatiTrasporto">
												<tr>
													<td class="text-center"><xsl:value-of select="MezzoTrasporto" /></td>
													<td class="text-center"><xsl:value-of select="CausaleTrasporto" /></td>
													<td class="text-center"><xsl:value-of select="NumeroColli" /></td>
													<td class="text-center"><xsl:value-of select="Descrizione" /></td>
													<td class="text-center"><xsl:value-of select="UnitaMisuraPeso" /></td>
													<td class="text-center"><xsl:value-of select="PesoLordo" /></td>
													<td class="text-center"><xsl:value-of select="PesoNetto" /></td>
													<td class="text-center">
														<xsl:if test="DataOraRitiro">
															<xsl:call-template name="FormatDateCompact">
																<xsl:with-param name="DateTime" select="DataOraRitiro" />
															</xsl:call-template>
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="DataInizioTrasporto">
															<xsl:call-template name="FormatDateCompact">
																<xsl:with-param name="DateTime" select="DataInizioTrasporto" />
															</xsl:call-template>
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="TipoResa">
															<xsl:value-of select="TipoResa" /> (codifica secondo standard ICC)
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="IndirizzoResa/Indirizzo">
															<xsl:value-of select="IndirizzoResa/Indirizzo" /> N.<xsl:value-of select="IndirizzoResa/NumeroCivico" /> - <xsl:value-of select="IndirizzoResa/CAP" /> - <xsl:value-of select="IndirizzoResa/Comune" /> (<xsl:value-of select="IndirizzoResa/Provincia" />) <xsl:value-of select="IndirizzoResa/Nazione" />
														</xsl:if>
													</td>
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:if>
							<!--FINE DATI TRASPORTO-->
							
							<!--INIZIO FATTURA PRINCIPALE-->
							<xsl:if test="DatiGenerali/FatturaPrincipale">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Dati relativi alla fattura principale</td>
								</tr>
								<tr>
									<td width="50%" class="font-bold">Numero fattura principale:</td>
									<td width="50%"><xsl:value-of select="DatiGenerali/FatturaPrincipale/NumeroFatturaPrincipale" /></td>
								</tr>
								<tr>
									<td width="50%" class="font-bold">Data fattura principale:</td>
									<td width="50%">
										<xsl:call-template name="FormatDateCompact">
											<xsl:with-param name="DateTime" select="DatiGenerali/FatturaPrincipale/DataFatturaPrincipale" />
										</xsl:call-template>
									</td>
								</tr>
							</xsl:if>
							<!--FINE FATTURA PRINCIPALE-->							
							
							
							<xsl:if test="DatiBeniServizi/DatiRiepilogo">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Dati di riepilogo per aliquota IVA e natura</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
											<tr class="trtitle font-bold">
												<td class="text-center">IVA</td>
												<td class="text-center">Natura</td>
												<td class="text-center">Spese accessorie</td>
												<td class="text-center">Arrotondamento</td>
												<td class="text-center">Impon./Importo (<xsl:value-of select="$VALUTA" />)</td>
												<td class="text-center">Imposta (<xsl:value-of select="$VALUTA" />)</td>
												<td class="text-center">Esigibilità</td>
												<td class="text-center">Riferimento Normativo</td>
											</tr>
											<xsl:for-each select="DatiBeniServizi/DatiRiepilogo">
												<tr>
													<td class="text-right"><xsl:value-of select="AliquotaIVA" />%</td>
													<td class="text-left">
														<xsl:if test="Natura">
															<span>
																<xsl:value-of select="Natura" />
															</span>
															<xsl:variable name="NAT1">
																<xsl:value-of select="Natura" />
															</xsl:variable>
															<xsl:choose>
																<xsl:when test="$NAT1='N1'">
																	(escluse ex art.15)
																</xsl:when>
																<xsl:when test="$NAT1='N2'">
																	(non soggette)
																</xsl:when>
																<xsl:when test="$NAT1='N2.1'">
																	(non soggette ad IVA - artt. da 7 a 7-septies 
																	del DPR 633/72)
																</xsl:when>
																<xsl:when test="$NAT1='N2.2'">
																	(non soggette - altri casi)
																</xsl:when>																
																<xsl:when test="$NAT1='N3'">
																	(non imponibili)
																</xsl:when>
																<xsl:when test="$NAT1='N3.1'">
																	(non imponibili - esportazioni)
																</xsl:when>
																<xsl:when test="$NAT1='N3.2'">
																	(non imponibili - cessioni intracomunitarie)
																</xsl:when>
																<xsl:when test="$NAT1='N3.3'">
																	(non imponibili - cessioni verso S.Marino)
																</xsl:when>
																<xsl:when test="$NAT1='N3.4'">
																	(non imponibili - operazioni assimilate alle 
																	cessioni all'esportazione)
																</xsl:when>
																<xsl:when test="$NAT1='N3.5'">
																	(non imponibili - a seguito di dichiarazioni 
																	d'intento)
																</xsl:when>
																<xsl:when test="$NAT1='N3.6'">
																	(non imponibili - altre operazioni che non 
																	concorrono alla formazione del plafond)
																</xsl:when>
																<xsl:when test="$NAT1='N4'">
																	(esenti)
																</xsl:when>
																<xsl:when test="$NAT1='N5'">
																	(regime del margine / IVA non esposta in fattura)
																</xsl:when>
																<xsl:when test="$NAT1='N6'">
																	(inversione contabile per le operazioni in reverse 
																	charge ovvero nei casi di autofatturazione per 
																	acquisti extra UE di servizi ovvero per importazioni 
																	di beni nei soli casi previsti)
																</xsl:when>
																<xsl:when test="$NAT1='N6.1'">
																	(inversione contabile - cessione di rottami e 
																	altri materiali di recupero)
																</xsl:when>
																<xsl:when test="$NAT1='N6.2'">
																	(inversione contabile - cessione di oro e 
																	argento puro)
																</xsl:when>
																<xsl:when test="$NAT1='N6.3'">
																	(inversione contabile - subappalto nel settore 
																	edile)
																</xsl:when>
																<xsl:when test="$NAT1='N6.4'">
																	(inversione contabile - cessione di fabbricati)
																</xsl:when>
																<xsl:when test="$NAT1='N6.5'">
																	(inversione contabile - cessione di telefoni 
																	cellulari)
																</xsl:when>
																<xsl:when test="$NAT1='N6.6'">
																	(inversione contabile - cessione di prodotti 
																	elettronici)
																</xsl:when>
																<xsl:when test="$NAT1='N6.7'">
																	(inversione contabile - prestazioni comparto 
																	edile e settori connessi)
																</xsl:when>
																<xsl:when test="$NAT1='N6.8'">
																	(inversione contabile - operazioni settore 
																	energetico)
																</xsl:when>
																<xsl:when test="$NAT1='N6.9'">
																	(inversione contabile - altri casi)
																</xsl:when>
																<xsl:when test="$NAT1='N7'">
																	(IVA assolta in altro stato UE - vendite a distanza 
																	ex art.40 c.3 e 4 e art.41 c.1 lett. b DL 331/93; 
																	prestazione di servizi di telecomunicazioni, 
																	tele-radiodiffusione ed elettronici ex art.7-sexies 
																	lett. f, g, e art.74-sexies DPR 633/72)
																</xsl:when>
																<xsl:otherwise>
																	<span>(!!! codice non previsto !!!)</span>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
													</td>
													<td class="text-right"><xsl:value-of select="SpeseAccessorie" /></td>
													<td class="text-right"><xsl:value-of select="Arrotondamento" /></td>
													<td class="text-right"><xsl:value-of select="format-number(ImponibileImporto, '###.##0,00#########', 'euro')" /></td>
													<td class="text-right"><xsl:value-of select="format-number(Imposta, '###.##0,00#########', 'euro')" /></td>
													<td>
														<xsl:if test="EsigibilitaIVA">
														<span>
															<xsl:value-of select="EsigibilitaIVA" />
														</span>
														<xsl:variable name="EI">
															<xsl:value-of select="EsigibilitaIVA" />
														</xsl:variable>
														<xsl:choose>
															<xsl:when test="$EI='I'">
																(esigibilità immediata)
															</xsl:when>
															<xsl:when test="$EI='D'">
																(esigibilità differita)
															</xsl:when>
															<xsl:when test="$EI='S'">
																(scissione dei pagamenti)
															</xsl:when>
															<xsl:otherwise>
																<span>(!!! codice non previsto !!!)</span>
															</xsl:otherwise>
														</xsl:choose>
														</xsl:if>
													</td>
													<td class="text-right"><xsl:value-of select="RiferimentoNormativo" /></td>
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:if>
							
							<!--INIZIO DATI VEICOLI-->
							<xsl:if test="DatiVeicoli">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Dati Veicoli</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
											<tr class="trtitle font-bold">
												<td class="text-center">Data prima immatricolazione / iscrizione PR</td>
												<td class="text-center">Totale percorso</td>
											</tr>
											<xsl:for-each select="DatiBeniServizi/DatiRiepilogo">
												<tr>
													<td class="text-right">
														<xsl:call-template name="FormatDateCompact">
															<xsl:with-param name="DateTime" select="Data" />
														</xsl:call-template>
													</td>
													<td class="text-right"><xsl:value-of select="TotalePercorso" /></td>
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:if>
							<!--FINE DATI VEICOLI-->							
							
							<xsl:if test="DatiPagamento">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Pagamento</td>
								</tr>
								<xsl:for-each select="DatiPagamento">
									<tr>
										<td width="100%" class="font-bold" colspan="2"><span>
												<xsl:value-of select="CondizioniPagamento" />
											</span>
											<xsl:variable name="CP">
												<xsl:value-of select="CondizioniPagamento" />
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="$CP='TP01'">
													(pagamento a rate)
												</xsl:when>
												<xsl:when test="$CP='TP02'">
													(pagamento completo)
												</xsl:when>
												<xsl:when test="$CP='TP03'">
													(anticipo)
												</xsl:when>
												<xsl:when test="$CP=''">
												</xsl:when>
												<xsl:otherwise>
													<span>(!!! codice non previsto !!!)</span>
												</xsl:otherwise>
											</xsl:choose></td>
									</tr>
									<tr>
									<td width="100%" colspan="2" border="0">
											<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
												<tr class="trtitle font-bold">
													<td class="text-center">Beneficiario</td>
													<td class="text-center">Modalità</td>
													<td class="text-center">Importo (<xsl:value-of select="$VALUTA" />)</td>
													<td class="text-center">entro il</td>
													<td class="text-center">IBAN</td>
													<td class="text-center">Istituto Finanziario</td>													
													<td class="text-center">Codice Pagamento</td>
												</tr>
												<xsl:for-each select="DettaglioPagamento">
													<tr>
														<td class="text-center"><xsl:value-of select="Beneficiario" /></td>
														<td><span>
																<xsl:value-of select="ModalitaPagamento" />
															</span>
															<xsl:variable name="MP">
																<xsl:value-of select="ModalitaPagamento" />
															</xsl:variable>
															<xsl:choose>
																<xsl:when test="$MP='MP01'">
																	(contanti)
																</xsl:when>
																<xsl:when test="$MP='MP02'">
																	(assegno)
																</xsl:when>
																<xsl:when test="$MP='MP03'">
																	(assegno circolare)
																</xsl:when>
																<xsl:when test="$MP='MP04'">
																	(contanti presso Tesoreria)
																</xsl:when>
																<xsl:when test="$MP='MP05'">
																	(bonifico)
																</xsl:when>
																<xsl:when test="$MP='MP06'">
																	(vaglia cambiario)
																</xsl:when>
																<xsl:when test="$MP='MP07'">
																	(bollettino bancario)
																</xsl:when>
																<xsl:when test="$MP='MP08'">
																	(carta di pagamento)
																</xsl:when>
																<xsl:when test="$MP='MP09'">
																	(RID)
																</xsl:when>
																<xsl:when test="$MP='MP10'">
																	(RID utenze)
																</xsl:when>
																<xsl:when test="$MP='MP11'">
																	(RID veloce)
																</xsl:when>
																<xsl:when test="$MP='MP12'">
																	(RIBA)
																</xsl:when>
																<xsl:when test="$MP='MP13'">
																	(MAV)
																</xsl:when>
																<xsl:when test="$MP='MP14'">
																	(quietanza erario)
																</xsl:when>
																<xsl:when test="$MP='MP15'">
																	(giroconto su conti di contabilità speciale)
																</xsl:when>
																<xsl:when test="$MP='MP16'">
																	(domiciliazione bancaria)
																</xsl:when>
																<xsl:when test="$MP='MP17'">
																	(domiciliazione postale)
																</xsl:when>
																<xsl:when test="$MP='MP18'">
																	(bollettino di c/c postale)
																</xsl:when>
																<xsl:when test="$MP='MP19'">
																	(SEPA Direct Debit)
																</xsl:when>
																<xsl:when test="$MP='MP20'">
																	(SEPA Direct Debit CORE)
																</xsl:when>
																<xsl:when test="$MP='MP21'">
																	(SEPA Direct Debit B2B)
																</xsl:when>
																<xsl:when test="$MP='MP22'">
																	(Trattenuta su somme già riscosse)
																</xsl:when>
																<xsl:when test="$MP='MP23'">
																	(PagoPA)
																</xsl:when>
																<xsl:when test="$MP=''">
																</xsl:when>
																<xsl:otherwise>
																	<span>(!!! codice non previsto !!!)</span>
																</xsl:otherwise>
															</xsl:choose></td>
														<td class="text-right"><xsl:value-of select="format-number(ImportoPagamento, '###.###,###', 'euro')" /></td>
														<td>
															<xsl:if test="DataScadenzaPagamento">
																<xsl:call-template name="FormatDateCompact">
																	<xsl:with-param name="DateTime" select="DataScadenzaPagamento" />
																</xsl:call-template>
															</xsl:if>													
														</td>
														<td class="text-center"><xsl:value-of select="IBAN" /></td>
														<td class="text-center"><xsl:value-of select="IstitutoFinanziario" /></td>
														<td class="text-center"><xsl:value-of select="CodicePagamento" /></td>
													</tr>
												</xsl:for-each>
											</table>
										</td>
									</tr>
								</xsl:for-each>
							</xsl:if>

							<!--INIZIO DATI DELLA RITENUTA-->
							<xsl:if test="DatiGenerali/DatiGeneraliDocumento/DatiRitenuta">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Dati Ritenuta</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
											<tr class="trtitle font-bold">
												<td class="text-center">Tipologia ritenuta</td>
												<td class="text-center">Importo ritenuta</td>
												<td class="text-center">Aliquota ritenuta</td>
												<td class="text-center">Causale di pagamento</td>
											</tr>
											<xsl:for-each select="DatiGenerali/DatiGeneraliDocumento/DatiRitenuta">
												<tr class="font-bold">
													<td class="text-center">
														<xsl:if test="TipoRitenuta">
															<span>
																<xsl:value-of select="TipoRitenuta" />
															</span>
															<xsl:variable name="TR">
																<xsl:value-of select="TipoRitenuta" />
															</xsl:variable>
															<xsl:choose>
																<xsl:when test="$TR='RT01'">
																	(ritenuta persone fisiche)
																</xsl:when>
																<xsl:when test="$TR='RT02'">
																	(ritenuta persone giuridiche)
																</xsl:when>
																<xsl:when test="$TR='RT03'">
																	(contributo INPS)
																</xsl:when>
																<xsl:when test="$TR='RT04'">
																	(contributo ENASARCO)
																</xsl:when>
																<xsl:when test="$TR='RT05'">
																	(contributo ENPAM)
																</xsl:when>
																<xsl:when test="$TR='RT06'">
																	(altro contributo previdenziale)
																</xsl:when>
																<xsl:when test="$TR=''">
																</xsl:when>
																<xsl:otherwise>
																	<span>(!!! codice non previsto !!!)</span>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="ImportoRitenuta">
															<span>
																<xsl:value-of select="ImportoRitenuta" />
															</span>
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="AliquotaRitenuta">
															<span>
																<xsl:value-of select="AliquotaRitenuta" />%
															</span>
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="CausalePagamento">
															<span>
																<xsl:value-of select="CausalePagamento" />
															</span>
															<xsl:variable name="CP">
																<xsl:value-of select="CausalePagamento" />
															</xsl:variable>
															<xsl:if test="$CP!=''">
																(decodifica come da modello 770S)
															</xsl:if>
														</xsl:if>
													</td>
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:if>
							<!--FINE DATI DELLA RITENUTA-->

							<!--INIZIO DATI DEL BOLLO-->
							<xsl:if test="DatiGenerali/DatiGeneraliDocumento/DatiBollo">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Dati Bollo</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
											<tr class="trtitle font-bold">
												<td class="text-center">Bollo virtuale</td>
												<td class="text-center">Importo bollo</td>
											</tr>
											<xsl:for-each select="DatiGenerali/DatiGeneraliDocumento/DatiBollo">
												<tr>
													<td class="text-center">
														<xsl:if test="BolloVirtuale">
															<span>
																<xsl:value-of select="BolloVirtuale" />
															</span>
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="ImportoBollo">
															<span>
																<xsl:value-of select="ImportoBollo" />
															</span>
														</xsl:if>
													</td>
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:if>
							<!--FINE DATI DEL BOLLO-->

							<!--INIZIO DATI DELLA CASSA PREVIDENZIALE-->
							<xsl:if test="DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Dati Cassa Previdenziale</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
											<tr class="trtitle font-bold">
												<td class="text-center">Tipologia cassa previdenziale</td>
												<td class="text-center">Aliquota contributo cassa</td>
												<td class="text-center">Importo contributo cassa</td>
												<td class="text-center">Imponibile previdenziale</td>
												<td class="text-center">Aliquota IVA applicata</td>
												<td class="text-center">Contributo cassa soggetto a ritenuta</td>
												<td class="text-center">Tipologia di non imponibilità del contributo</td>
												<td class="text-center">Riferimento amministrativo / contabile</td>
											</tr>
											<xsl:for-each select="DatiGenerali/DatiGeneraliDocumento/DatiCassaPrevidenziale">
												<tr>
													<td class="text-center">
														<xsl:if test="TipoCassa">
															<span>
																<xsl:value-of select="TipoCassa" />
															</span>
															<xsl:variable name="TC">
																<xsl:value-of select="TipoCassa" />
															</xsl:variable>
															<xsl:choose>
																<xsl:when test="$TC='TC01'">
																	(Cassa Nazionale Previdenza e Assistenza Avvocati
																	e Procuratori legali)
																</xsl:when>
																<xsl:when test="$TC='TC02'">
																	(Cassa Previdenza Dottori Commercialisti)
																</xsl:when>
																<xsl:when test="$TC='TC03'">
																	(Cassa Previdenza e Assistenza Geometri)
																</xsl:when>
																<xsl:when test="$TC='TC04'">
																	(Cassa Nazionale Previdenza e Assistenza
																	Ingegneri e Architetti liberi profess.)
																</xsl:when>
																<xsl:when test="$TC='TC05'">
																	(Cassa Nazionale del Notariato)
																</xsl:when>
																<xsl:when test="$TC='TC06'">
																	(Cassa Nazionale Previdenza e Assistenza
																	Ragionieri e Periti commerciali)
																</xsl:when>
																<xsl:when test="$TC='TC07'">
																	(Ente Nazionale Assistenza Agenti e Rappresentanti
																	di Commercio-ENASARCO)
																</xsl:when>
																<xsl:when test="$TC='TC08'">
																	(Ente Nazionale Previdenza e Assistenza Consulenti
																	del Lavoro-ENPACL)
																</xsl:when>
																<xsl:when test="$TC='TC09'">
																	(Ente Nazionale Previdenza e Assistenza
																	Medici-ENPAM)
																</xsl:when>
																<xsl:when test="$TC='TC10'">
																	(Ente Nazionale Previdenza e Assistenza
																	Farmacisti-ENPAF)
																</xsl:when>
																<xsl:when test="$TC='TC11'">
																	(Ente Nazionale Previdenza e Assistenza
																	Veterinari-ENPAV)
																</xsl:when>
																<xsl:when test="$TC='TC12'">
																	(Ente Nazionale Previdenza e Assistenza Impiegati
																	dell'Agricoltura-ENPAIA)
																</xsl:when>
																<xsl:when test="$TC='TC13'">
																	(Fondo Previdenza Impiegati Imprese di Spedizione
																	e Agenzie Marittime)
																</xsl:when>
																<xsl:when test="$TC='TC14'">
																	(Istituto Nazionale Previdenza Giornalisti
																	Italiani-INPGI)
																</xsl:when>
																<xsl:when test="$TC='TC15'">
																	(Opera Nazionale Assistenza Orfani Sanitari
																	Italiani-ONAOSI)
																</xsl:when>
																<xsl:when test="$TC='TC16'">
																	(Cassa Autonoma Assistenza Integrativa
																	Giornalisti Italiani-CASAGIT)
																</xsl:when>
																<xsl:when test="$TC='TC17'">
																	(Ente Previdenza Periti Industriali e Periti
																	Industriali Laureati-EPPI)
																</xsl:when>
																<xsl:when test="$TC='TC18'">
																	(Ente Previdenza e Assistenza
																	Pluricategoriale-EPAP)
																</xsl:when>
																<xsl:when test="$TC='TC19'">
																	(Ente Nazionale Previdenza e Assistenza
																	Biologi-ENPAB)
																</xsl:when>
																<xsl:when test="$TC='TC20'">
																	(Ente Nazionale Previdenza e Assistenza
																	Professione Infermieristica-ENPAPI)
																</xsl:when>
																<xsl:when test="$TC='TC21'">
																	(Ente Nazionale Previdenza e Assistenza
																	Psicologi-ENPAP)
																</xsl:when>
																<xsl:when test="$TC='TC22'">
																	(INPS)
																</xsl:when>
																<xsl:when test="$TC=''">
																</xsl:when>
																<xsl:otherwise>
																	<span>(!!! codice non previsto !!!)</span>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="AlCassa">
															<xsl:value-of select="AlCassa" />%
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="ImportoContributoCassa">
																<xsl:value-of select="ImportoContributoCassa" />
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="ImponibileCassa">
															<xsl:value-of select="ImponibileCassa" />
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="AliquotaIVA">
															<xsl:value-of select="AliquotaIVA" />
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="Ritenuta">
															<xsl:value-of select="Ritenuta" />
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="Natura">
															<span>
																<xsl:value-of select="Natura" />
															</span>
															<xsl:variable name="NT">
																<xsl:value-of select="Natura" />
															</xsl:variable>
															<xsl:choose>
																<xsl:when test="$NT='N1'">
																	(escluse ex art. 15)
																</xsl:when>
																<xsl:when test="$NT='N2'">
																	(non soggette)
																</xsl:when>
																<xsl:when test="$NT='N2.1'">
																	(non soggette ad IVA - artt. da 7 a 7-septies 
																	del DPR 633/72)
																</xsl:when>
																<xsl:when test="$NT='N2.2'">
																	(non soggette - altri casi)
																</xsl:when>
																<xsl:when test="$NT='N3'">
																	(non imponibili)
																</xsl:when>
																<xsl:when test="$NT='N3.1'">
																	(non imponibili - esportazioni)
																</xsl:when>
																<xsl:when test="$NT='N3.2'">
																	(non imponibili - cessioni intracomunitarie)
																</xsl:when>
																<xsl:when test="$NT='N3.3'">
																	(non imponibili - cessioni verso S.Marino)
																</xsl:when>
																<xsl:when test="$NT='N3.4'">
																	(non imponibili - operazioni assimilate alle 
																	cessioni all'esportazione)
																</xsl:when>
																<xsl:when test="$NT='N3.5'">
																	(non imponibili - a seguito di dichiarazioni 
																	d'intento)
																</xsl:when>
																<xsl:when test="$NT='N3.6'">
																	(non imponibili - altre operazioni che non 
																	concorrono alla formazione del plafond)
																</xsl:when>
																<xsl:when test="$NT='N4'">
																	(esenti)
																</xsl:when>
																<xsl:when test="$NT='N5'">
																	(regime del margine)
																</xsl:when>
																<xsl:when test="$NT='N6'">
																	(inversione contabile)
																</xsl:when>
																<xsl:when test="$NT='N7'">
																	(IVA assolta in altro stato UE)
																</xsl:when>
																<xsl:when test="$NT=''">
																</xsl:when>
																<xsl:otherwise>
																	<span>(!!! codice non previsto !!!)</span>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
													</td>
													<td class="text-center">
														<xsl:if test="RiferimentoAmministrazione">
															<xsl:value-of select="RiferimentoAmministrazione" />
														</xsl:if>
													</td>
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:if>
							<!--FINE DATI DELLA CASSA PREVIDENZIALE-->


							<!--INIZIO DATI SCONTO / MAGGIORAZIONE-->
							<xsl:if test="DatiGenerali/DatiGeneraliDocumento/ScontoMaggiorazione">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Sconto/maggiorazione</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
											<tr class="trtitle font-bold">
												<td class="text-center">Tipologia</td>
												<td class="text-center">Percentuale</td>
												<td class="text-center">Importo</td>
											</tr>
											<xsl:for-each select="DatiGenerali/DatiGeneraliDocumento/ScontoMaggiorazione">
												<tr>
													<td class="text-center">
														<span>
															<xsl:value-of select="Tipo" />
														</span>
														<xsl:variable name="TSM">
															<xsl:value-of select="Tipo" />
														</xsl:variable>
														<xsl:choose>
															<xsl:when test="$TSM='SC'">

																(sconto)
															</xsl:when>
															<xsl:when test="$TSM='MG'">

																(maggiorazione)
															</xsl:when>
															<xsl:otherwise>

																<span>(!!! codice non previsto !!!)</span>
															</xsl:otherwise>
														</xsl:choose>
													</td>
													<td class="text-center"><xsl:value-of select="Percentuale" /></td>
													<td class="text-center"><xsl:value-of select="Importo" /></td>
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:if>
							<!--FINE DATI SCONTO / MAGGIORAZIONE-->							
							
							<!--INIZIO ALLEGATI-->
							<xsl:if test="Allegati">
								<tr>
									<td width="100%" class="font-bold" colspan="2"></td>
								</tr>
								<tr>
									<td width="100%" class="font-bold" colspan="2">Allegati</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" border="0">
										<table class="borderRadTable" width="100%" cellpadding="2" cellspacing="0">
											<tr class="trtitle font-bold">
												<td class="text-center">Nome dell'allegato</td>
												<td class="text-center">Algoritmo di compressione</td>
												<td class="text-center">Formato</td>
												<td class="text-center">Descrizione</td>
											</tr>
											<xsl:for-each select="Allegati">
												<tr class="font-bold">
													<td class="text-center"><a target="_blank">
															<xsl:variable name="N-ATT-TMP">
																<xsl:call-template name="Trim">
																	<xsl:with-param name="input" select="NomeAttachment" />
																</xsl:call-template>
															</xsl:variable>
															<xsl:variable name="N-ATT1">
																<xsl:value-of select="translate(translate(translate(translate(translate(translate(translate(translate(translate(translate(translate(translate(translate(translate(translate(translate($N-ATT-TMP, '/', '_'), '*', '_'), '\', '_'), '|', '_'), ':', '_'), '&quot;', '_'), '&lt;', '_'), '&gt;', '_'), ';', '_'), ':', '_'), '@', '_'), '&amp;', '_'), '=', '_'), '+', '_'), '$', '_'), ',', '_')" />
															</xsl:variable>
															<xsl:variable name="N-ATT">
																<xsl:call-template name="string-replace-all">
																	<xsl:with-param name="text" select="$N-ATT1" />
																	<xsl:with-param name="replace" select="'#'" />
																	<xsl:with-param name="by" select="'%23'" />
																</xsl:call-template>
															</xsl:variable>
															 <xsl:if test="contains($N-ATT, '.')">
															 <xsl:attribute name="href"><xsl:value-of select="$PathAllegati" /><xsl:value-of select="$N-ATT" /></xsl:attribute>
															 </xsl:if>
															 <xsl:if test="not(contains($N-ATT, '.'))">
																 <xsl:if test="AlgoritmoCompressione">
																 <xsl:attribute name="href"><xsl:value-of select="$PathAllegati" /><xsl:value-of select="$N-ATT" />.<xsl:value-of select="AlgoritmoCompressione" /></xsl:attribute>
																 </xsl:if>
																 <xsl:if test="not(AlgoritmoCompressione)">
																	 <xsl:if test="FormatoAttachment">
																		<xsl:attribute name="href"><xsl:value-of select="$PathAllegati" /><xsl:value-of select="$N-ATT" />.<xsl:value-of select="FormatoAttachment" /></xsl:attribute>
																	 </xsl:if>
																	 <xsl:if test="not(FormatoAttachment)">
																		<xsl:attribute name="href"><xsl:value-of select="$PathAllegati" /><xsl:value-of select="$N-ATT" /></xsl:attribute>
																	 </xsl:if>
																 </xsl:if>
															 </xsl:if>
															<xsl:value-of select="NomeAttachment" />
														</a></td>
													<td class="text-center"><xsl:value-of select="AlgoritmoCompressione" /></td>
													<td class="text-center"><xsl:value-of select="FormatoAttachment" /></td>
													<td class="text-center"><xsl:value-of select="DescrizioneAttachment" /></td>
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:if>
							<!--FINE ALLEGATI-->
						</xsl:for-each>
						</table>
					</div>
				</xsl:if>
				</page>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>