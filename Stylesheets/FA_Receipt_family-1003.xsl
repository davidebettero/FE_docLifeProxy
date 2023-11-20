<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:a="http://www.fatturapa.gov.it/sdi/messaggi/v1.0" xmlns:ns3="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fattura/messaggi/v1.0" xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
	<xsl:output version="4.0" method="html" indent="no" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>
	<xsl:param name="SV_OutputFormat" select="'HTML'"/>
	<xsl:variable name="XML" select="/"/>

	<xsl:template match="/">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=edge" />
				<style type="text/css">
					#notifica-container { width: 100%; position: relative; font-family: sans-serif; }
					
					#notifica { margin-left: auto; margin-right: auto; max-width: 1280px; min-width: 930px; padding: 0; }
					#notifica h1 { padding: 20px 0 0 0; margin: 0; font-size: 30px; }
					#notifica h2 { padding: 20px 0 0 0; margin: 0; font-size: 20px; border-bottom: 2px solid #333333; }
					#notifica h3 { padding: 20px 0 0 0; margin: 0; font-size: 17px; }
					#notifica h4 { padding: 20px 0 0 0; margin: 0; font-size: 15px; }
					#notifica h5 { padding: 15px 0 0 0; margin: 0; font-size: 14px; font-style: italic; }
					#notifica ul { list-style-type: none; margin: 0 !important; padding: 1em 0 1em 2em !important; }
					#notifica ul li {}
					#notifica ul li span { font-weight: bold; }
					#notifica div { padding: 0; margin: 0; }
					
					#notifica div.page {
						background: #fff url("http://www.fatturapa.gov.it/img/sdi.png") right bottom no-repeat !important;
						position: relative;
						
						margin: 20px 0 50px 0;
						padding: 60px;
						
						background: -moz-linear-gradient(0% 0 360deg, #FFFFFF, #F2F2F2 20%, #FFFFFF) repeat scroll 0 0 transparent;
						border: 1px solid #CCCCCC;
						-webkitbox-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
						-mozbox-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
						box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
					}
					
					#notifica div.header { padding: 50px 0 0 0; margin: 0; font-size: 11px; text-align: center; color: #777777; }
					#notifica div.footer { padding: 50px 0 0 0; margin: 0; font-size: 11px; text-align: center; color: #777777; }
					#notifica-container .versione { font-size: 11px; float:right; color: #777777; }
					
					#notifica table { font-size: .9em; margin-top: 1em; border-collapse: collapse; border: 1px solid black; }
					#notifica table caption { color: black; padding: .5em 0; font-weight: bold; }
					#notifica table th { border: 1px solid black; background-color: #f0f0f0; padding: .2em .5em; }
					#notifica table td { border: 1px solid black; padding: .2em .5em; }
					#notifica table td:first-child { text-align: center; font-weight: bold; }
				</style>
			</head>
			
			<body>
				<xsl:for-each select="a:RicevutaConsegna">
					
					<div id="notifica-container">
					<div id="notifica">
						<div class="page">
						
							<div class="versione">
								<xsl:if test="ds:Signature">
									File con firma elettronica - 
								</xsl:if>
								Versione <xsl:value-of select="@versione"/>
								<br/>
								<xsl:variable name="dupliceRuolo">
									<xsl:value-of select="@IntermediarioConDupliceRuolo"/>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$dupliceRuolo='Si'"> Flusso semplificato</xsl:when>
								</xsl:choose>
							</div>
							<h1>Ricevuta Consegna</h1>
						
							<ul>
								<li>
									Identificativo SdI:
									<span><xsl:value-of select="IdentificativoSdI" /></span>
								</li>
								
								<li>
									Nome File:
									<span><xsl:value-of select="NomeFile" /></span>
								</li>
								
								<li>
									Data Ora Ricezione:
									<span><xsl:value-of select="DataOraRicezione" /></span>
								</li>
								
								<li>
									Data Ora Consegna:
									<span><xsl:value-of select="DataOraConsegna" /></span>
								</li>
								
								<li>
									Destinatario:
									<span><xsl:value-of select="Destinatario" /></span>
								</li>
								
								<xsl:if test="RiferimentoArchivio">
								<li>
									<h3>Riferimento Archivio:</h3>
									<ul>
										<li>
											Identificativo SdI:
											<span><xsl:value-of select="RiferimentoArchivio/IdentificativoSdI" /></span>
										</li>
										<li>
											Nome File:
											<span><xsl:value-of select="RiferimentoArchivio/NomeFile" /></span>
										</li>
									</ul>
								</li>
								</xsl:if>
								
								<li>
									Message Id:
									<span><xsl:value-of select="MessageId" /></span>
								</li>
								<xsl:if test="PecMessageId">
									<li>
										Pec Message-ID:
										<span><xsl:value-of select="PecMessageId" /></span>
									</li>
								</xsl:if>
								
								<xsl:if test="Note">
								    Note:
									<br />
 		  	                        <xsl:value-of select="substring-before(Note,'|')"/>   
									<ul>
									   <xsl:call-template name="tokenizeNote">
											<xsl:with-param name="list" select="substring-after(Note,'|')"/>
											<xsl:with-param name="delimiter" select="'|'"/>
									   </xsl:call-template>
									</ul>
								</xsl:if>
							</ul>
						</div>
					</div>
				</div>
					
				</xsl:for-each>
				
				<xsl:for-each select="ns3:RicevutaConsegna">
					
					<div id="notifica-container">
					<div id="notifica">
						<div class="page">
						
							<div class="versione">
								<xsl:if test="ds:Signature">
									File con firma elettronica - 
								</xsl:if>
								Versione <xsl:value-of select="@versione"/>
								<br/>
								<xsl:variable name="dupliceRuolo">
									<xsl:value-of select="@IntermediarioConDupliceRuolo"/>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$dupliceRuolo='Si'"> Flusso semplificato</xsl:when>
								</xsl:choose>
							</div>
							<h1>Ricevuta Consegna</h1>
						
							<ul>
								<li>
									Identificativo SdI:
									<span><xsl:value-of select="IdentificativoSdI" /></span>
								</li>
								
								<li>
									Nome File:
									<span><xsl:value-of select="NomeFile" /></span>
								</li>
								
								<xsl:if test="Hash">
									<li>
										Hash:
										<span><xsl:value-of select="Hash" /></span>
									</li>
								</xsl:if>

								<li>
									Data Ora Ricezione:
									<span><xsl:value-of select="DataOraRicezione" /></span>
								</li>
								
								<li>
									Data Ora Consegna:
									<span><xsl:value-of select="DataOraConsegna" /></span>
								</li>
								
								<li>
									Destinatario:
									<span><xsl:value-of select="Destinatario" /></span>
								</li>
								
								<xsl:if test="RiferimentoArchivio">
								<li>
									<h3>Riferimento Archivio:</h3>
									<ul>
										<li>
											Identificativo SdI:
											<span><xsl:value-of select="RiferimentoArchivio/IdentificativoSdI" /></span>
										</li>
										<li>
											Nome File:
											<span><xsl:value-of select="RiferimentoArchivio/NomeFile" /></span>
										</li>
									</ul>
								</li>
								</xsl:if>
								
								<li>
									Message Id:
									<span><xsl:value-of select="MessageId" /></span>
								</li>
								<xsl:if test="PecMessageId">
									<li>
										Pec Message-ID:
										<span><xsl:value-of select="PecMessageId" /></span>
									</li>
								</xsl:if>

								<xsl:if test="Note">
								    Note:
 		  	                        <xsl:value-of select="Note"/>   
								</xsl:if>
							</ul>
						</div>
					</div>
				</div>
					
				</xsl:for-each>
				<xsl:for-each select="a:NotificaScarto">
				
				<div id="notifica-container">
					<div id="notifica">
						<div class="page">
						
							<div class="versione">
								<xsl:if test="ds:Signature">
									File con firma digitale - 
								</xsl:if>
								Versione <xsl:value-of select="@versione"/>
							</div>
							<h1>Notifica Scarto</h1>
						
							<ul>
								<li>
									Identificativo SdI:
									<span><xsl:value-of select="IdentificativoSdI" /></span>
								</li>
								
								<li>
									Nome File:
									<span><xsl:value-of select="NomeFile" /></span>
								</li>
								
								<li>
									Data Ora Ricezione:
									<span><xsl:value-of select="DataOraRicezione" /></span>
								</li>
								
								
								<xsl:if test="RiferimentoArchivio">
								<li>
									<h3>Riferimento Archivio</h3>
									<ul>
										<li>
											Identificativo SdI:
											<span><xsl:value-of select="RiferimentoArchivio/IdentificativoSdI" /></span>
										</li>
										<li>
											Nome File:
											<span><xsl:value-of select="RiferimentoArchivio/NomeFile" /></span>
										</li>
									</ul>
								</li>
								</xsl:if>
								
								
								<xsl:if test="MessageId">
								<li>
									Message Id:
									<span><xsl:value-of select="MessageId" /></span>
								</li>
								</xsl:if>
								
								<xsl:if test="PecMessageId">
								<li>
									Pec Message Id:
									<span><xsl:value-of select="PecMessageId" /></span>
								</li>
								</xsl:if>
								
								<xsl:if test="Note">
								    Note:
									<br />
 		  	                        <xsl:value-of select="substring-before(Note,'|')"/>   
									<ul>	
									   <xsl:call-template name="tokenizeNote">
											<xsl:with-param name="list" select="substring-after(Note,'|')"/>
											<xsl:with-param name="delimiter" select="'|'"/>
									   </xsl:call-template>
									</ul>
								</xsl:if>
								
								<li>
									<table summaty="La tabella riporta gli errori riscontrati dal SdI nel file inviato">
									<caption>Lista errori</caption>
									<tr>
										<th>Codice</th>
										<th>Descrizione</th>
									</tr>
									<xsl:for-each select="ListaErrori/Errore">
										<tr>
											<td><xsl:value-of select="Codice"/></td>
											<td><xsl:value-of select="Descrizione"/></td>
										</tr>
									</xsl:for-each>
									</table>
								</li>
							</ul>
						</div>
					</div>
				</div>
				
				</xsl:for-each>
				<xsl:for-each select="ns3:RicevutaScarto">
				<div id="notifica-container">
					<div id="notifica">
						<div class="page">
						
							<div class="versione">
								<xsl:if test="ds:Signature">
									File con firma digitale - 
								</xsl:if>
								Versione <xsl:value-of select="@versione"/>
							</div>
							<h1>Ricevuta di Scarto</h1>
						
							<ul>
								<li>
									Identificativo SdI:
									<span><xsl:value-of select="IdentificativoSdI" /></span>
								</li>
								
								<li>
									Nome File:
									<span><xsl:value-of select="NomeFile" /></span>
								</li>

								<xsl:if test="Hash">
									<li>
										Hash:
										<span><xsl:value-of select="Hash" /></span>
									</li>
								</xsl:if>
								
								<li>
									Data Ora Ricezione:
									<span><xsl:value-of select="DataOraRicezione" /></span>
								</li>
								
								
								<xsl:if test="RiferimentoArchivio">
								<li>
									<h3>Riferimento Archivio</h3>
									<ul>
										<li>
											Identificativo SdI:
											<span><xsl:value-of select="RiferimentoArchivio/IdentificativoSdI" /></span>
										</li>
										<li>
											Nome File:
											<span><xsl:value-of select="RiferimentoArchivio/NomeFile" /></span>
										</li>
									</ul>
								</li>
								</xsl:if>
								
								
								<xsl:if test="MessageId">
								<li>
									Message Id:
									<span><xsl:value-of select="MessageId" /></span>
								</li>
								</xsl:if>
								
								<xsl:if test="PecMessageId">
								<li>
									Pec Message Id:
									<span><xsl:value-of select="PecMessageId" /></span>
								</li>
								</xsl:if>

								<xsl:if test="Note">
								    Note:
									<br />
 		  	                        <xsl:value-of select="substring-before(Note,'|')"/>   
									<ul>	
									   <xsl:call-template name="tokenizeNote">
											<xsl:with-param name="list" select="substring-after(Note,'|')"/>
											<xsl:with-param name="delimiter" select="'|'"/>
									   </xsl:call-template>
									</ul>
								</xsl:if>
								
								<li>
									<table summaty="La tabella riporta gli errori riscontrati dal SdI nel file inviato">
									<caption>Lista errori</caption>
									<tr>
										<th>Codice</th>
										<th>Descrizione</th>
									</tr>
									<xsl:for-each select="ListaErrori/Errore">
										<tr>
											<td><xsl:value-of select="Codice"/></td>
											<td><xsl:value-of select="Descrizione"/></td>
										</tr>
									</xsl:for-each>
									</table>
								</li>
							</ul>
						</div>
					</div>
				</div>
				
				</xsl:for-each>
				<xsl:for-each select="a:NotificaEsito">
					<div id="notifica-container">
						<div id="notifica">
							<div class="page">
								<div class="versione">
									<xsl:if test="ds:Signature">
										File con firma digitale - 
									</xsl:if>
									Versione <xsl:value-of select="@versione"/>
									<br/>
									<xsl:variable name="dupliceRuolo">
										<xsl:value-of select="@IntermediarioConDupliceRuolo"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="$dupliceRuolo='Si'"> Intermediario con Duplice Ruolo</xsl:when>
									</xsl:choose>
								</div>
								<h1>Notifica Esito</h1>
								
								<ul>
									<li>
										Identificativo SdI:
										<span><xsl:value-of select="IdentificativoSdI" /></span>
									</li>
									
									<li>
										Nome File:
										<span><xsl:value-of select="NomeFile" /></span>
									</li>
									
									<xsl:if test="MessageId">
									<li>
										Message Id:
										<span><xsl:value-of select="MessageId" /></span>
									</li>
									</xsl:if>
									
									<xsl:if test="PecMessageId">
									<li>
										PEC Message Id:
										<span><xsl:value-of select="PecMessageId" /></span>
									</li>
									</xsl:if>
									
									<xsl:if test="Note">
									<li>
										Note:
										<span><xsl:value-of select="Note" /></span>
									</li>
									</xsl:if>
									
									<h2>Esito Committente</h2>
									
									<xsl:if test="EsitoCommittente/RiferimentoFattura">
									<li>
										<li>
											Identificativo SdI:
											<span><xsl:value-of select="EsitoCommittente/IdentificativoSdI" /></span>
										</li>
										
										<li>
											<h3>Riferimento Fattura</h3>
											<ul>
												<li>
													Numero Fattura:
													<span><xsl:value-of select="EsitoCommittente/RiferimentoFattura/NumeroFattura" /></span>
												</li>
												<li>
													Anno Fattura:
													<span><xsl:value-of select="EsitoCommittente/RiferimentoFattura/AnnoFattura" /></span>
												</li>
												<xsl:if test="EsitoCommittente/RiferimentoFattura/PosizioneFattura">
												<li>
													Posizione Fattura:
													<span><xsl:value-of select="EsitoCommittente/RiferimentoFattura/PosizioneFattura" /></span>
												</li>
												</xsl:if>
											</ul>
										</li>
									</li>
									</xsl:if>
									
									<li>
										Esito:
										<span><xsl:value-of select="EsitoCommittente/Esito" /></span>
										<xsl:variable name="EC">
											<xsl:value-of select="EsitoCommittente/Esito" />
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="$EC='EC01'"> (Accettazione)</xsl:when>
											<xsl:when test="$EC='EC02'"> (Rifiuto)</xsl:when>
										</xsl:choose>
									</li>
									
									<xsl:if test="EsitoCommittente/Descrizione">
									<li>
										Descrizione:
										<span><xsl:value-of select="EsitoCommittente/Descrizione" /></span>
									</li>
									</xsl:if>
									
									<xsl:if test="EsitoCommittente/MessageIdCommittente">
									<li>
										Message Id Committente:
										<span><xsl:value-of select="EsitoCommittente/MessageIdCommittente" /></span>
									</li>
									</xsl:if>
								</ul>
							</div>
						</div>
					</div>
				</xsl:for-each>
				<xsl:for-each select="a:MetadatiInvioFile">
				
				<div id="notifica-container">
					<div id="notifica">
						<div class="page">
						
							<div class="versione">
								Versione <xsl:value-of select="@versione"/>
							</div>
							<h1>Notifica Metadati</h1>
						
							<ul>
								<li>
									Identificativo SdI:
									<span><xsl:value-of select="IdentificativoSdI" /></span>
								</li>

								<li>
									Nome File:
									<span><xsl:value-of select="NomeFile" /></span>
								</li>

								<li>
									Codice Destinatario:
									<span><xsl:value-of select="CodiceDestinatario" /></span>
								</li>

								<li>
									Formato:
									<span><xsl:value-of select="Formato" /></span>
								</li>

								<li>
									Tentativi Invio:
									<span><xsl:value-of select="TentativiInvio" /></span>
								</li>

								<li>
									Message Id:
									<span><xsl:value-of select="MessageId" /></span>
								</li>

								<xsl:if test="Note">
									<li>
										Note:
										<span><xsl:value-of select="Note" /></span>
									</li>
								</xsl:if>
							</ul>
							
						</div>
					</div>
				</div>
				
				</xsl:for-each>
				
				<xsl:for-each select="ns3:FileMetadati">
				
				<div id="notifica-container">
					<div id="notifica">
						<div class="page">
						
							<div class="versione">
								Versione <xsl:value-of select="@versione"/>
							</div>
							<h1>Notifica Metadati</h1>
						
							<ul>
								<li>
									Identificativo SdI:
									<span><xsl:value-of select="IdentificativoSdI" /></span>
								</li>

								<li>
									Nome File:
									<span><xsl:value-of select="NomeFile" /></span>
								</li>
								
								<xsl:if test="Hash">
									<li>
										Hash:
										<span><xsl:value-of select="Hash" /></span>
									</li>
								</xsl:if>
								
								<li>
									Codice Destinatario:
									<span><xsl:value-of select="CodiceDestinatario" /></span>
								</li>

								<li>
									Formato:
									<span><xsl:value-of select="Formato" /></span>
								</li>

								<li>
									Tentativi Invio:
									<span><xsl:value-of select="TentativiInvio" /></span>
								</li>

								<li>
									Message Id:
									<span><xsl:value-of select="MessageId" /></span>
								</li>
								
								<xsl:if test="Note">
									<li>
										Note:
										<span><xsl:value-of select="Note" /></span>
									</li>
								</xsl:if>
							</ul>
							
						</div>
					</div>
				</div>
				
				</xsl:for-each>
				<xsl:for-each select="a:NotificaMancataConsegna">
				
				<div id="notifica-container">
					<div id="notifica">
						<div class="page">
						
							<div class="versione">
								<xsl:if test="ds:Signature">
									File con firma digitale - 
								</xsl:if>
								Versione <xsl:value-of select="@versione"/>
							</div>
							<h1>Notifica Mancata Consegna</h1>
						
							<ul>
								<li>
									Identificativo SdI:
									<span><xsl:value-of select="IdentificativoSdI" /></span>
								</li>
								
								<li>
									Nome File:
									<span><xsl:value-of select="NomeFile" /></span>
								</li>
								
								<xsl:if test="RiferimentoArchivio">
								<li>
									<h3>Riferimento Archivio</h3>
									<ul>
										<li>
											Identificativo SdI:
											<span><xsl:value-of select="RiferimentoArchivio/IdentificativoSdI" /></span>
										</li>
										<li>
											Nome File:
											<span><xsl:value-of select="RiferimentoArchivio/NomeFile" /></span>
										</li>
									</ul>
								</li>
								</xsl:if>

								<xsl:if test="Descrizione">
								<li>
									Descrizione:
									<span><xsl:value-of select="Descrizione" /></span>
								</li>
								</xsl:if>
								
								<li>
									Message Id:
									<span><xsl:value-of select="MessageId" /></span>
								</li>
								
								<xsl:if test="PecMessageId">
								<li>
									Pec Message Id:
									<span><xsl:value-of select="PecMessageId" /></span>
								</li>
								</xsl:if>
								
								<xsl:if test="Note">
								    Note:
									<br />
 		  	                        <xsl:value-of select="substring-before(Note,'|')"/>   
									<ul>	
									   <xsl:call-template name="tokenizeNote">
											<xsl:with-param name="list" select="substring-after(Note,'|')"/>
											<xsl:with-param name="delimiter" select="'|'"/>
									   </xsl:call-template>
									</ul>
								</xsl:if>
							</ul>
						</div>
					</div>
				</div>
				
				</xsl:for-each>
				<xsl:for-each select="ns3:RicevutaImpossibilitaRecapito">
				
				<div id="notifica-container">
					<div id="notifica">
						<div class="page">
						
							<div class="versione">
								<xsl:if test="ds:Signature">
									File con firma digitale - 
								</xsl:if>
								Versione <xsl:value-of select="@versione"/>
							</div>
							<h1>Ricevuta di impossibilità di recapito</h1>
						
							<ul>
								<li>
									Identificativo SdI:
									<span><xsl:value-of select="IdentificativoSdI" /></span>
								</li>
								
								<li>
									Nome File:
									<span><xsl:value-of select="NomeFile" /></span>
								</li>
								
								<xsl:if test="Hash">
									<li>
										Hash:
										<span><xsl:value-of select="Hash" /></span>
									</li>
								</xsl:if>
								
								<li>
									Data Ora Ricezione:
									<span><xsl:value-of select="DataOraRicezione" /></span>
								</li>

								<li>
									Data Messa a Disposizione:
									<span><xsl:value-of select="DataMessaADisposizione" /></span>
								</li>								
								
								<xsl:if test="RiferimentoArchivio">
								<li>
									<h3>Riferimento Archivio</h3>
									<ul>
										<li>
											Identificativo SdI:
											<span><xsl:value-of select="RiferimentoArchivio/IdentificativoSdI" /></span>
										</li>
										<li>
											Nome File:
											<span><xsl:value-of select="RiferimentoArchivio/NomeFile" /></span>
										</li>
									</ul>
								</li>
								</xsl:if>

								<xsl:if test="Descrizione">
								<li>
									Descrizione:
									<span><xsl:value-of select="Descrizione" /></span>
								</li>
								</xsl:if>
								
								<li>
									Message Id:
									<span><xsl:value-of select="MessageId" /></span>
								</li>
								
								<xsl:if test="PecMessageId">
								<li>
									Pec Message Id:
									<span><xsl:value-of select="PecMessageId" /></span>
								</li>
								</xsl:if>

								<xsl:if test="Note">
								<li>
									Note:
									<span><xsl:value-of select="Note" /></span>
								</li>
								</xsl:if>
							</ul>
						</div>
					</div>
				</div>
				
				</xsl:for-each>
				<xsl:for-each select="a:NotificaEsitoCommittente">
					<div id="notifica-container">
						<div id="notifica">
							<div class="page">
								<div class="versione">
									<xsl:if test="ds:Signature">
										File con firma digitale - 
									</xsl:if>
									Versione <xsl:value-of select="@versione"/>
								</div>
								<h1>Notifica Esito Committente</h1>
								
								<ul>
									<li>
										Identificativo SdI:
										<span><xsl:value-of select="IdentificativoSdI" /></span>
									</li>
									
									<xsl:if test="RiferimentoFattura">
									<li>
										<h3>Riferimento Fattura</h3>
										<ul>
											<li>
												Numero Fattura:
												<span><xsl:value-of select="RiferimentoFattura/NumeroFattura" /></span>
											</li>
											<li>
												Anno Fattura:
												<span><xsl:value-of select="RiferimentoFattura/AnnoFattura" /></span>
											</li>
											<xsl:if test="RiferimentoFattura/PosizioneFattura">
											<li>
												Posizione Fattura:
												<span><xsl:value-of select="RiferimentoFattura/PosizioneFattura" /></span>
											</li>
											</xsl:if>
										</ul>
									</li>
									</xsl:if>
									
									<li>
										Esito:
										<span><xsl:value-of select="Esito" /></span>
										<xsl:variable name="EC">
											<xsl:value-of select="Esito" />
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="$EC='EC01'"> (Accettazione)</xsl:when>
											<xsl:when test="$EC='EC02'"> (Rifiuto)</xsl:when>
										</xsl:choose>
									</li>
									
									<xsl:if test="Descrizione">
									<li>
										Descrizione:
										<span><xsl:value-of select="Descrizione" /></span>
									</li>
									</xsl:if>
									
									<xsl:if test="MessageIdCommittente">
									<li>
										Message Id Committente:
										<span><xsl:value-of select="MessageIdCommittente" /></span>
									</li>
									</xsl:if>
								</ul>
							</div>
						</div>
					</div>
				</xsl:for-each>
				<xsl:for-each select="a:NotificaDecorrenzaTermini">
					<div id="notifica-container">
						<div id="notifica">
							<div class="page">
								<div class="versione">
									<xsl:if test="ds:Signature">
										File con firma digitale - 
									</xsl:if>
									Versione <xsl:value-of select="@versione"/>
									<br/>
									<xsl:variable name="dupliceRuolo">
										<xsl:value-of select="@IntermediarioConDupliceRuolo"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="$dupliceRuolo='Si'"> Intermediario con Duplice Ruolo</xsl:when>
									</xsl:choose>
								</div>
								<h1>Notifica Decorrenza Termini</h1>
								
								<ul>
									<li>
										Identificativo SdI:
										<span><xsl:value-of select="IdentificativoSdI" /></span>
									</li>
									
									<xsl:if test="RiferimentoFattura">
									<li>
										<h3>Riferimento Fattura</h3>
										<ul>
											<li>
												Numero Fattura:
												<span><xsl:value-of select="RiferimentoFattura/NumeroFattura" /></span>
											</li>
											<li>
												Anno Fattura:
												<span><xsl:value-of select="RiferimentoFattura/AnnoFattura" /></span>
											</li>
											<xsl:if test="RiferimentoFattura/PosizioneFattura">
											<li>
												Posizione Fattura:
												<span><xsl:value-of select="RiferimentoFattura/PosizioneFattura" /></span>
											</li>
											</xsl:if>
										</ul>
									</li>
									</xsl:if>
									
									<li>
										Nome File:
										<span><xsl:value-of select="NomeFile" /></span>
									</li>
									
									<li>
										Descrizione:
										<span><xsl:value-of select="Descrizione" /></span>
									</li>
									
									<li>
										Message Id:
										<span><xsl:value-of select="MessageId" /></span>
									</li>
									
									<xsl:if test="PecMessageId">
										<li>
											Pec Message Id:
											<span><xsl:value-of select="PecMessageId" /></span>
										</li>
									</xsl:if>
									
									<xsl:if test="Note">
										<li>
											Note:
											<span><xsl:value-of select="Note" /></span>
										</li>
									</xsl:if>
								</ul>
							</div>
						</div>
					</div>
				</xsl:for-each>
				<xsl:for-each select="a:AttestazioneTrasmissioneFattura">
					<div id="notifica-container">
						<div id="notifica">
							<div class="page">
								<div class="versione">
									<xsl:if test="ds:Signature">
										File con firma digitale - 
									</xsl:if>
									Versione <xsl:value-of select="@versione"/>
								</div>
								<h1>Attestazione di avvenuta trasmissione della fattura con impossibilità di recapito</h1>
								
								<ul>
									<li>
										Identificativo SdI:
										<span><xsl:value-of select="IdentificativoSdI" /></span>
									</li>
									
									<li>
										Nome File:
										<span><xsl:value-of select="NomeFile" /></span>
									</li>
									
									<li>
										Data Ora Ricezione:
										<span><xsl:value-of select="DataOraRicezione" /></span>
									</li>
									
									<xsl:if test="RiferimentoArchivio">
									<li>
										<h3>Riferimento Archivio:</h3>
										<ul>
											<li>
												Identificativo SdI:
												<span><xsl:value-of select="RiferimentoArchivio/IdentificativoSdI" /></span>
											</li>
											<li>
												Nome File:
												<span><xsl:value-of select="RiferimentoArchivio/NomeFile" /></span>
											</li>
										</ul>
									</li>
									</xsl:if>
									
									<li>
										Destinatario:
										<span><xsl:value-of select="Destinatario" /></span>
									</li>
									
									<li>
										Message Id:
										<span><xsl:value-of select="MessageId" /></span>
									</li>
									<xsl:if test="PecMessageId">
										<li>
											Pec Message-ID:
											<span><xsl:value-of select="PecMessageId" /></span>
										</li>
									</xsl:if>
									
									<xsl:if test="Note">
										<li>
											Note:
											<span><xsl:value-of select="Note" /></span>
										</li>
									</xsl:if>
									
									<li>
										Hash del File Originale:
										<span><xsl:value-of select="HashFileOriginale" /></span>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</xsl:for-each>
				<xsl:for-each select="a:ScartoEsitoCommittente">
					<div id="notifica-container">
						<div id="notifica">
							<div class="page">
								<div class="versione">
									<xsl:if test="ds:Signature">
										File con firma digitale - 
									</xsl:if>
									Versione <xsl:value-of select="@versione"/>
								</div>
								
								<h1>Scarto Esito committente</h1>
								
								<ul>
									<li>
										Identificativo SdI:
										<span><xsl:value-of select="IdentificativoSdI" /></span>
									</li>
									
									<xsl:if test="RiferimentoFattura">
									<li>
										<h3>Riferimento Fattura</h3>
										<ul>
											<li>
												Numero Fattura:
												<span><xsl:value-of select="RiferimentoFattura/NumeroFattura" /></span>
											</li>
											<li>
												Anno Fattura:
												<span><xsl:value-of select="RiferimentoFattura/AnnoFattura" /></span>
											</li>
											<xsl:if test="RiferimentoFattura/PosizioneFattura">
											<li>
												Posizione Fattura:
												<span><xsl:value-of select="RiferimentoFattura/PosizioneFattura" /></span>
											</li>
											</xsl:if>
										</ul>
									</li>
									</xsl:if>
									
									<li>
										Scarto:
										<span><xsl:value-of select="Scarto" /></span>
										<xsl:variable name="SC">
											<xsl:value-of select="Scarto" />
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="$SC='EN00'"> (NOTIFICA NON CONFORME AL FORMATO)</xsl:when>
											<xsl:when test="$SC='EN01'"> (NOTIFICA NON AMMISSIBILE)</xsl:when>
										</xsl:choose>
									</li>
									
									<li>
										Message Id:
										<span><xsl:value-of select="MessageId" /></span>
									</li>
									
									<xsl:if test="MessageIdCommittente">
										<li>
											Message-ID committente:
											<span><xsl:value-of select="MessageIdCommittente" /></span>
										</li>
									</xsl:if>
									
									<xsl:if test="PecMessageId">
										<li>
											Pec Message-ID:
											<span><xsl:value-of select="PecMessageId" /></span>
										</li>
									</xsl:if>
									
									<xsl:if test="Note">
										<li>
											Note:
											<span><xsl:value-of select="Note" /></span>
										</li>
									</xsl:if>
								</ul>
							</div>
						</div>
					</div>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
	
    <!--############################################################-->
    <!--## Template to tokenize Note                              ##-->
    <!--############################################################-->
    <xsl:template name="tokenizeNote">
		<!--passed template parameter -->
        <xsl:param name="list"/>
        <xsl:param name="delimiter"/>
        <xsl:choose>
            <xsl:when test="contains($list, $delimiter)">                
                <li>
                    <!-- get everything in front of the first delimiter -->
                    <span> <xsl:value-of select="substring-before($list,$delimiter)"/> </span>	
                </li>
                <xsl:call-template name="tokenizeNote">
                    <!-- store anything left in another variable -->
                    <xsl:with-param name="list" select="substring-after($list,$delimiter)"/>
                    <xsl:with-param name="delimiter" select="$delimiter"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$list = ''">
                        <xsl:text/>
                    </xsl:when>
                    <xsl:otherwise>
                      	  <li>
							<span>	<xsl:value-of select="$list"/>  </span>	 
						  </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>	
</xsl:stylesheet>