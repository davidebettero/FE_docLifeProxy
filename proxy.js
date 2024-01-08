"use strict";

const express = require("express");
require("dotenv").config({ path: "envdg" });
const axios = require("axios");
const FormData = require("form-data");
const request = require("request");
const form = new FormData();
var https = require("https");
var http = require("http");
var httpProxy = require("http-proxy");
const { createProxyMiddleware } = require("http-proxy-middleware");
var fs = require("fs");
const util = require("util");
var contentDisposition = require("content-disposition");
const { XMLParser, XMLBuilder, XMLValidator } = require("fast-xml-parser");

const config = require("./config.json");
console.log(config);

/*var key = fs.readFileSync(process.env.DG_KEY_URL);
var cert = fs.readFileSync(process.env.DG_CERT_URL);
var options = {
  key: key,
  cert: cert
};
*/

var app = express();

const agent = new https.Agent({
  rejectUnauthorized: false,
});

process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

var bodyParser = require("body-parser");
const { Console } = require("console");
require("body-parser-xml")(bodyParser);
app.use(
  bodyParser.xml({
    limit: "25MB",
    normalizeTags: false,
  })
);

app.post("/postToHorsaFE", (req, res) => {
  //console.log(req);
  var rawdata = req.body;
  var folderID = req.query.folder;
  var overwrite = req.query.overwrite;
  var horsaFEUrl = req.header("targetURL");
  let dataArea = rawdata.SyncContentDocument.DataArea[0].ContentDocument;
  let documentID = dataArea[0].DocumentID[0].ID[0]._;
  let FileName = "";
  let documentResource = "";
  let FileURL = "";
  let returnDocument = "";
  try {
    documentResource = dataArea[0].DocumentResource[0] ?? "";
    FileName = documentResource.FileName[0] ?? "";
    FileURL = documentResource.URL[0] ?? "";
    console.log(dataArea[0].DocumentMetaData[0].Attribute);
  } catch (err) {
    //console.log(dataArea);
    console.log(err);
    FileName = "ERROR";
  }
  if (FileName == "ERROR") return;

  FileURL = FileURL.replace("&amp;", "&");
  const request = axios
    .get(FileURL, {
      responseType: "arraybuffer",
    })
    .then((responseIDM) => {
      //console.log(responseIDM.data)
      const form = new FormData();
      form.append("file", responseIDM.data, {
        filename: FileName,
      });
      console.log(FileName);
      console.log(horsaFEUrl);
      var callUrl =
        "https://" + horsaFEUrl + "/services/api/v1/cc/attivo/upload";
      var basicAuth = req.header("authorization");
      console.log(callUrl);
      axios
        .post(callUrl, form, {
          headers: {
            Authorization: basicAuth,
            "Content-Type": "multipart/form-data",
            Accept: "*/*",
          },
        })
        .then(function (resp) {
          console.log(resp);
          const responseData = {
            id: documentID,
            esito: "ok",
            nodeRef: resp.data.id,
            stato: resp.data.stato,
            numeroFattura: resp.data.numeroFattura,
            datafattura: resp.data.dataFattura,
            annofattura: resp.data.annoFattura,
            tipodocumento: resp.data.tipoDocumento,
            mittente: resp.data.mittente.denominazione,
            mittenteNome: resp.data.mittente.nome,
            mittenteCognome: resp.data.mittente.cognome,
            mittentePIVA: resp.data.mittente.piva,
            destinatarioDenominazione: resp.data.destinatario.denominazione,
            destinatarioNome: resp.data.destinatario.nome,
            destinatarioCognome: resp.data.destinatario.cognome,
            destinatarioPIVA: resp.data.destinatario.piva,
          };
          res.setHeader("Content-Type", "application/json");
          const jsonContent = JSON.stringify(responseData);
          return res.end(jsonContent);
        })
        .catch(function (error) {
          //req.body.SyncContentDocument.DataArea[0].DocumentMetaData[0].Attribute[0].push({name: "Krishnan", salary: 5678});
          console.log(error);
          const responseData = {
            id: documentID,
            esito: error.response.data.message,
            nodeRef: error.data,
          };
          res.setHeader("Content-Type", "application/json");
          const jsonContent = JSON.stringify(responseData);
          return res.end(jsonContent);
        });
    })
    .catch(function (error) {
      console.log(error);
    });
});

app.post("/postToDocLife", (req, res) => {
  var rawdata = req.body;
  var folderID = req.query.folder;
  var overwrite = req.query.overwrite;
  var horsaFEUrl = req.header("targetURL");
  let dataArea = rawdata.SyncContentDocument.DataArea[0].ContentDocument;
  let documentID = dataArea[0].DocumentID[0].ID[0]._;
  let FileName = "";
  let documentResource = "";
  let DocumentMetaData = "";
  let Documenttype = "";
  let FileURL = "";
  let returnDocument = "";
  try {
    documentResource = dataArea[0].DocumentResource[0] ?? "";
    DocumentMetaData = dataArea[0].DocumentMetaData[0] ?? "";
    Documenttype = DocumentMetaData.DocumentTypeID[0] ?? "";
    FileName = documentResource.FileName[0] ?? "";
    FileURL = documentResource.URL[0] ?? "";
  } catch (err) {
    console.log(Documenttype);
    console.log("error");
    FileName = "ERROR";
  }
  if (FileName == "ERROR") return;

  FileURL = FileURL.replace("&amp;", "&");
  const request = axios
    .get(FileURL, {
      responseType: "arraybuffer",
    })
    .then((responseIDM) => {
      console.log(responseIDM.data);
      const form = new FormData();
      console.log(FileName);
      form.append("file", responseIDM.data, {
        filename: FileName,
      });
      var callUrl =
        "https://" +
        horsaFEUrl +
        "/doclife/api/document/" +
        folderID +
        "/uploadornewversion";
      var basicAuth = req.header("authorization");
      console.log("DOCLIFE");
      axios
        .post(callUrl, form, {
          headers: {
            Authorization: basicAuth,
            "Content-Type": "multipart/form-data",
          },
        })
        .then(function (resp) {
          returnDocument = req.body;
          console.log(resp.data);
          let nodeRef = resp.data.noderef;
          //Set Document Type
          //const resSetDocumentType  = axios.put('https://'+horsaFEUrl+'/doclife/api/document/'+nodeRef+'/uploadornewversion';, { hello: 'world' });
          //Get Document Type Configuration
          var result = config.filter((obj) => obj.idmdocument == Documenttype);
          console.log(result[0].doclife);

          let docLifeAttributeNodeRef = result[0].doclife.doclifeNodeRef ?? "";
          let docLifeAttributeAspect = result[0].doclife.docLifeAspect ?? "";
          let attributes = result[0].doclife.attributes ?? "";

          const responseData = {
            id: documentID,
            esito: resp.data.esito,
            nodeRef: resp.data.noderef,
          };
          let addAttributeUrl =
            "https://" + horsaFEUrl + "/doclife/api/document/" + nodeRef;
          axios
            .put(
              addAttributeUrl,
              {
                objectType: "hdm:document",
                nodeRef: nodeRef,
                typology: [docLifeAttributeNodeRef],
              },
              {
                headers: {
                  Authorization: basicAuth,
                },
              }
            )
            .then(function (respAttribute) {
              console.log(respAttribute);
              res.setHeader("Content-Type", "application/json");
              const jsonContent = JSON.stringify(responseData);
              return res.end(jsonContent);
            })
            .catch(function (errorAttribute) {
              console.log("erroreAttributo");
              console.log(errorAttribute);
              return res.send("error");
            });
        })
        .catch(function (error) {
          console.log("qui");
          console.log(error);
          return res.send(error.response.data);
        });
    })
    .catch(function (error) {});
});

// Call api/v1/cc/passivo/listUnacknowledged and for each invoice call api/v1/cc/passivo/{id}/download.
// Return an xml containing the base64 of invoices and their attributes (if valued)
app.get("/retrievePassiveInvoices", async (req, res) => {
  var basicAuth = req.header("authorization");
  const config = {
    headers: {
      Authorization: basicAuth,
    },
    maxRedirects: 21,
  };

  var url =
    "https://console-fe.horsa.it/services/api/v1/cc/passivo/listUnacknowledged";
  let temp = [];
  var builder = require("xmlbuilder");
  var doc = builder.create("PassiveInvoices");
  const result = await axios.get(url, config).then((atp) => {
    try {
      //console.log(atp.data.result.length);

      for (let i = 0; i < atp.data.result.length; i++) {
        let invoiceID = atp.data.result[i].id;
        let sdiID = atp.data.result[i].sdiId;
        let fileName = atp.data.result[i].nome; // missing extension (.xml)
        let documentDate = atp.data.result[i].dataFattura;
        let documentNumber = atp.data.result[i].numeroFattura;
        let codiceFiscaleMittente =
          atp.data.result[i].mittente["codiceFiscale"];
        let nomeMittente = atp.data.result[i].mittente["nome"];
        let cognomeMittente = atp.data.result[i].mittente["cognome"];
        let dataRicezioneFattura = atp.data.result[i].dataCreazione;
        let annoFattura = atp.data.result[i].annoFattura;

        let actual = {
          id: invoiceID,
          sdiID: sdiID,
          fileName: fileName + ".xml",
          documentDate: documentDate,
          documentNumber: documentNumber,
          codiceFiscaleMittente: codiceFiscaleMittente,
          nomeMittente: nomeMittente,
          cognomeMittente: cognomeMittente,
          dataRicezioneFattura: dataRicezioneFattura,
          annoFattura: annoFattura,
        };
        temp.push(actual);
        //console.log(actual);
      }
    } catch (err) {
      //console.log(err);
      var errorMessage = atp.data.errorMessage;
      console.log("errorMessage: " + errorMessage);
      return res.send(doc.toString({ pretty: true }));
    }
  });
  //console.log(temp.length);
  for (let i = 0; i < temp.length; i++) {
    //console.log(temp[i].id);
    if (temp[i].id != null && temp[i].id != undefined && temp[i].id != "") {
      var url2 =
        "https://console-fe.horsa.it/services/api/v1/cc/passivo/" +
        temp[i].id +
        "/download/readable";

      const result2 = await axios.get(url2, config).then((atp2) => {
        try {
          if (
            atp2 != undefined &&
            atp2 != null &&
            atp2.data != undefined &&
            atp2.data != null &&
            atp2.data !== ""
          ) {
            //console.log(atp2.data.indexOf("<?xml version="));
            //console.log(atp2.data.indexOf("</ns3:FatturaElettronica>"));
            if (
              (atp2.data.indexOf("<?xml version=") !== 0 &&
                atp2.data.indexOf("<?xml version=") !== -1) ||
              (atp2.data.indexOf("</ns3:FatturaElettronica>") +
                "</ns3:FatturaElettronica>".length !==
                atp2.data.length &&
                atp2.data.indexOf("</ns3:FatturaElettronica>") !== -1)
            )
              //console.log("qui");
              atp2.data = atp2.data.substring(
                atp2.data.indexOf("<?xml version="),
                atp2.data.indexOf("</ns3:FatturaElettronica>") +
                  "</ns3:FatturaElettronica>".length
              );
            let base64Invoice = btoa(
              atp2.data.replace(/\uFFFD/g, "").replaceAll('"', "'")
            );
            temp[i].RawData =
              base64Invoice === undefined ||
              base64Invoice === null ||
              base64Invoice === ""
                ? ""
                : base64Invoice;
            //console.log(base64Invoice);
            //console.log(typeof atp2.data);

            if (
              atp2.data.includes("<FatturaElettronicaHeader") &&
              atp2.data.includes("/FatturaElettronicaHeader>")
            ) {
              let inizio = atp2.data.indexOf("<FatturaElettronicaHeader");
              let fine = atp2.data.indexOf("/FatturaElettronicaHeader>");
              atp2.data = atp2.data.substring(
                inizio,
                fine + "/FatturaElettronicaHeader>".length
              );
            }

            const xml = require("xml-parse");
            var xmlInvoice = new xml.DOM(
              xml.parse(
                atp2.data
                  .replace(/\uFFFD/g, "")
                  .replaceAll('"', "'")
                  .trim()
              )
            );
            /*
            var PaeseTrasmittente =
              xmlInvoice.document.getElementsByTagName("IdPaese")[0];
            var CodiceTrasmittente =
              xmlInvoice.document.getElementsByTagName("IdCodice")[0];
            var PaesePrestatore =
              xmlInvoice.document.getElementsByTagName("IdPaese")[1];
            var CodicePrestatore =
              xmlInvoice.document.getElementsByTagName("IdCodice")[1];

              var CedentePrestatore =
                xmlInvoice.document.getElementsByTagName("CedentePrestatore")[0].innerXML;
            var xmlInvoiceCedentePrestatore = new xml.DOM(xml.parse(CedentePrestatore));
            var DenominazionePrestatore =
              xmlInvoiceCedentePrestatore.document.getElementsByTagName("Denominazione")[0];

            var PaeseCommittente =
              xmlInvoice.document.getElementsByTagName("IdPaese")[2];
            var CodiceCommittente =
              xmlInvoice.document.getElementsByTagName("IdCodice")[2];
            */

            const DatiTrasmissione =
              xmlInvoice.document.getElementsByTagName("DatiTrasmissione")[0]
                .innerXML;
            var xmlInvoiceDatiTrasmissione = new xml.DOM(
              xml.parse(DatiTrasmissione)
            );
            var PaeseTrasmittente =
              xmlInvoiceDatiTrasmissione.document.getElementsByTagName(
                "IdPaese"
              )[0];
            var CodiceTrasmittente =
              xmlInvoiceDatiTrasmissione.document.getElementsByTagName(
                "IdCodice"
              )[0];
            //console.log(PaeseTrasmittente.childNodes[0].text);
            //console.log(CodiceTrasmittente.childNodes[0].text);

            const CedentePrestatore =
              xmlInvoice.document.getElementsByTagName("CedentePrestatore")[0]
                .innerXML;
            var xmlInvoiceCedentePrestatore = new xml.DOM(
              xml.parse(CedentePrestatore)
            );
            var PaesePrestatore =
              xmlInvoiceCedentePrestatore.document.getElementsByTagName(
                "IdPaese"
              )[0];
            var CodicePrestatore =
              xmlInvoiceCedentePrestatore.document.getElementsByTagName(
                "IdCodice"
              )[0];
            var DenominazionePrestatore =
              xmlInvoiceCedentePrestatore.document.getElementsByTagName(
                "Denominazione"
              )[0];
            //console.log(PaesePrestatore.childNodes[0].text);
            //console.log(CodicePrestatore.childNodes[0].text);
            //console.log(DenominazionePrestatore.childNodes[0].text);

            const Committente = xmlInvoice.document.getElementsByTagName(
              "CessionarioCommittente"
            )[0].innerXML;
            var xmlInvoiceCommittente = new xml.DOM(xml.parse(Committente));
            var PaeseCommittente =
              xmlInvoiceCommittente.document.getElementsByTagName("IdPaese")[0];
            var CodiceCommittente =
              xmlInvoiceCommittente.document.getElementsByTagName(
                "IdCodice"
              )[0];
            //console.log(PaeseCommittente.childNodes[0].text);
            //console.log(CodiceCommittente.childNodes[0].text);

            //console.log(PaeseTrasmittente.childNodes[0].text);
            temp[i].PaeseTrasmittente =
              PaeseTrasmittente === undefined
                ? ""
                : PaeseTrasmittente.childNodes[0].text;
            //console.log(CodiceTrasmittente.childNodes[0].text);
            temp[i].CodiceTrasmittente =
              CodiceTrasmittente === undefined
                ? ""
                : CodiceTrasmittente.childNodes[0].text;
            //console.log(PaesePrestatore.childNodes[0].text);
            temp[i].PaesePrestatore =
              PaesePrestatore === undefined
                ? ""
                : PaesePrestatore.childNodes[0].text;
            //console.log(CodicePrestatore.childNodes[0].text);
            temp[i].CodicePrestatore =
              CodicePrestatore === undefined
                ? ""
                : CodicePrestatore.childNodes[0].text;
            //console.log(DenominazionePrestatore.childNodes[0].text);
            temp[i].DenominazionePrestatore =
              DenominazionePrestatore === undefined
                ? ""
                : DenominazionePrestatore.childNodes[0].text.trim();
            //console.log(PaeseCommittente.childNodes[0].text);
            temp[i].PaeseCommittente =
              PaeseCommittente === undefined
                ? ""
                : PaeseCommittente.childNodes[0].text;
            //console.log(CodiceCommittente.childNodes[0].text);
            temp[i].CodiceCommittente =
              CodiceCommittente === undefined
                ? ""
                : CodiceCommittente.childNodes[0].text;
          }
        } catch (err) {
          var errorMessage2 = atp2.errorMessage;
          console.log("errorMessage2: " + errorMessage2);
          return res.send(doc.toString({ pretty: true }));
        }
      });
    }
  }
  for (let i = 0; i < temp.length; i++) {
    doc
      .ele("PassiveInvoice")
      .ele("ID")
      .txt(
        temp[i].id === undefined
          ? ""
          : temp[i].id.toString().replace("<![CDATA[", "").replace("]]>", "")
      )
      .up()
      .ele("Sdi_ID")
      .txt(
        temp[i].sdiID === undefined
          ? ""
          : temp[i].sdiID.toString().replace("<![CDATA[", "").replace("]]>", "")
      )
      .up()
      .ele("FileName")
      .txt(
        temp[i].fileName === undefined
          ? ""
          : temp[i].fileName
              .toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("DocumentDate")
      .txt(
        temp[i].documentDate === undefined
          ? ""
          : temp[i].documentDate
              .toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("DocumentNumber")
      .txt(
        temp[i].documentNumber === undefined
          ? ""
          : temp[i].documentNumber
              .toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("SenderCode")
      .txt(
        temp[i].codiceFiscaleMittente === undefined
          ? ""
          : temp[i].codiceFiscaleMittente
              .toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("SenderSurname")
      .txt(
        temp[i].cognomeMittente === undefined
          ? ""
          : temp[i].cognomeMittente
              .toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("SenderName")
      .txt(
        temp[i].nomeMittente === undefined
          ? ""
          : temp[i].nomeMittente
              .toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("DataRicezione")
      .txt(
        temp[i].dataRicezioneFattura === undefined
          ? ""
          : temp[i].dataRicezioneFattura
              .toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("InvoiceYear")
      .txt(
        temp[i].annoFattura === undefined
          ? ""
          : temp[i].annoFattura
              .toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("PaeseTrasmittente")
      .txt(
        temp[i].PaeseTrasmittente === undefined
          ? ""
          : temp[i].PaeseTrasmittente.toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("CodiceTrasmittente")
      .txt(
        temp[i].CodiceTrasmittente === undefined
          ? ""
          : temp[i].CodiceTrasmittente.toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("PaesePrestatore")
      .txt(
        temp[i].PaesePrestatore === undefined
          ? ""
          : temp[i].PaesePrestatore.toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("CodicePrestatore")
      .txt(
        temp[i].CodicePrestatore === undefined
          ? ""
          : temp[i].CodicePrestatore.toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("DenominazionePrestatore")
      .txt(
        temp[i].DenominazionePrestatore === undefined
          ? ""
          : temp[i].DenominazionePrestatore.toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("PaeseCommittente")
      .txt(
        temp[i].PaeseCommittente === undefined
          ? ""
          : temp[i].PaeseCommittente.toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("CodiceCommittente")
      .txt(
        temp[i].CodiceCommittente === undefined
          ? ""
          : temp[i].CodiceCommittente.toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("RawData")
      .txt(
        temp[i].RawData === undefined ||
          temp[i].RawData === null ||
          temp[i].RawData === ""
          ? ""
          : temp[i].RawData
      );
  }
  return res.send(doc.toString({ pretty: true }));
});

// Transforms with a stylesheet the xml of the active invoice into its pdf.
// Return an xml containing the base64 of the pdf invoice and its attributes (if valued)
// Input: Sync.ContentDocument of active invoice's class
app.post("/getActiveInvoicePDF", async (req, res) => {
  var basicAuth = req.header("authorization");
  const config = {
    headers: {
      Authorization: basicAuth,
    },
    maxRedirects: 21,
  };

  let FileName = "";
  let documentResource = "";
  let FileURL = "";
  let rawdata = "";
  let dataArea = "";
  let pid = "";
  try {
    rawdata = req.body;
    dataArea = rawdata.SyncContentDocument.DataArea[0].ContentDocument;
    pid = dataArea[0].DocumentID[0].ID[0]._;
    documentResource = dataArea[0].DocumentResource[0] ?? "";
    FileName = documentResource.FileName[0] ?? "";
    FileURL = documentResource.URL[0] ?? "";
    //console.log(dataArea[0].DocumentMetaData[0].Attribute);
  } catch (err) {
    //console.log(dataArea);
    console.log(err);
    FileName = "ERROR";
  }

  const builder = require("xmlbuilder");
  var doc = builder.create("ActiveInvoicePDF");
  if (FileName == "ERROR") return res.send(doc.toString({ pretty: true }));

  FileURL = FileURL.replace("&amp;", "&").trim();
  let getXMLError = false; //
  axios.get(FileURL, config).then((atp) => {
    try {
      let fattura = atp.data.replaceAll('"', "'"); // invoice xml (type: string)

      if (
        fattura.includes("LoginErrors()") ||
        (!fattura.includes("<") && !fattura.includes("</"))
      ) {
        return res.send(doc.toString({ pretty: true }));
      }

      // 2023-12-15 - Rimozione eventuale tag <?xml-stylesheet>
      if (
        fattura !== undefined &&
        fattura !== null &&
        typeof fattura === "string"
      ) {
        if (fattura.includes("<?xml-stylesheet")) {
          let start = fattura.indexOf("<?xml-stylesheet");
          let end = fattura.indexOf("?>", start);
          fattura = fattura.substring(0, start) + fattura.substring(end + 2);
        }
      }

      // 2023-12-15 - Aggiunta namespace tag root
      if (
        fattura !== undefined &&
        fattura !== null &&
        typeof fattura === "string"
      ) {
        if (
          fattura.includes("<FatturaElettronica ") &&
          fattura.includes("</FatturaElettronica>") &&
          (fattura.includes(
            "xmlns='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture"
          ) ||
            fattura.includes(
              'xmlns="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture'
            ))
        ) {
          fattura = fattura.replaceAll(
            "<FatturaElettronica ",
            "<p:FatturaElettronica "
          );
          fattura = fattura.replaceAll(
            "</FatturaElettronica>",
            "</p:FatturaElettronica>"
          );
          fattura = fattura.replaceAll(
            "xmlns='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture",
            "xmlns:p='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture"
          );
          fattura = fattura.replaceAll(
            'xmlns="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture',
            'xmlns:p="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture'
          );
        }
      }

      let pathXSL =
        "D:\\horsa_docLifeProxy\\Stylesheets\\FA_family-1001-PA-vFPR12.xsl"; // path to stylesheet
      const exec = require("child_process").exec;
      let resultString = "";
      const { v4: uuidv4 } = require("uuid");
      let fileName = uuidv4();
      const fs = require("fs");
      (async () => {
        await fs.writeFileSync(
          "invoices/" + fileName + ".xml",
          fattura,
          (err) => {
            getXMLError = true;
            if (err) throw err;
            console.log(err);
          }
        );
      })();

      if (getXMLError) {
        var errorMessage = atp.errorMessage;
        console.log("errorMessage: " + errorMessage);
        return res.send(doc.toString({ pretty: true }));
      }

      exec(
        "java XmlTransform " +
          pathXSL +
          " D:\\horsa_docLifeProxy\\invoices\\" +
          fileName +
          ".xml",
        function callback(error, stdout, stderr) {
          resultString = stdout;
          //console.log(resultString);
          var pdf = require("html-pdf");
          var html = resultString;
          var options = {
            format: "A4",
            orientation: "portrait",
            footer: {
              height: "1mm",
              contents: {
                first: "",
                2: "",
                default: "",
                last: "",
              },
            },
          };
          //console.log(html);
          try {
            pdf.create(html, options).toBuffer(function (err, buffer) {
              if (err) return console.log(err);
              let rawData = buffer.toString("base64");

              let i = 0;
              let attrs = {};

              while (
                dataArea[0].DocumentMetaData[0].Attribute[i] !== undefined
              ) {
                attrs[dataArea[0].DocumentMetaData[0].Attribute[i].$["id"]] =
                  dataArea[0].DocumentMetaData[0].Attribute[i]
                    .AttributeValue === undefined
                    ? ""
                    : dataArea[0].DocumentMetaData[0].Attribute[
                        i
                      ].AttributeValue[0]
                        .toString()
                        .trim();
                i++;
              }
              let nomeFatturaAttiva = "";
              for (var [key, value] of Object.entries(attrs)) {
                if (key === "FileName") {
                  value = value.replace(".xml", ".pdf");
                  nomeFatturaAttiva = value;
                }
                doc.ele(key).txt(value).up();
              }
              doc.ele("RawData").txt(rawData);

              WriteLogSync(
                "D:\\horsa_docLifeProxy\\log\\FattureAttive.txt",
                "Generato PDF fattura nome = " + nomeFatturaAttiva
              );

              return res.send(doc.toString({ pretty: true }));
            });
          } catch (err) {
            //console.log(err);
            var errorMessage = "Token scaduto";
            console.log("errorMessage: " + errorMessage);
            return res.send(doc.toString({ pretty: true }));
          }
        }
      );
    } catch (err) {
      //console.log(err);
      var errorMessage = atp.errorMessage;
      console.log("errorMessage: " + errorMessage);
      return res.send(doc.toString({ pretty: true }));
    }
  });
});

// Transforms with a stylesheet the xml of the passive invoice into its pdf.
// Return an xml containing the base64 of the pdf invoice and its attributes (if valued)
// Input: Sync.ContentDocument of passive invoice's class
app.post("/getPassiveInvoicePDF", async (req, res) => {
  var basicAuth = req.header("authorization");
  const config = {
    headers: {
      Authorization: basicAuth,
    },
    maxRedirects: 21,
  };

  const builder = require("xmlbuilder");
  var doc = builder.create("PassiveInvoicePDF");

  let rawdata = "";
  let dataArea = "";
  let pid = "";

  try {
    rawdata = req.body;
    dataArea = rawdata.SyncContentDocument.DataArea[0].ContentDocument;
    pid = dataArea[0].DocumentID[0].ID[0]._;
  } catch (err) {
    console.log(err);
    return res.send(doc.toString({ pretty: true }));
  }
  let FileName = "";
  let documentResource = "";
  let FileURL = "";

  let idFatturaSIME = "";
  let dataRicezione = "";
  let j = 0;
  while (dataArea[0].DocumentMetaData[0].Attribute[j] !== undefined) {
    if (
      dataArea[0].DocumentMetaData[0].Attribute[j].$["id"] ===
        "ID_FatturaSIME" &&
      dataArea[0].DocumentMetaData[0].Attribute[j].AttributeValue !== undefined
    ) {
      idFatturaSIME = dataArea[0].DocumentMetaData[0].Attribute[
        j
      ].AttributeValue[0]
        .toString()
        .trim();
    }

    if (
      dataArea[0].DocumentMetaData[0].Attribute[j].$["id"] ===
      "DataRicezioneFattura"
    ) {
      dataRicezione = dataArea[0].DocumentMetaData[0].Attribute[
        j
      ].AttributeValue[0]
        .toString()
        .trim();
    }
    j++;
  }
  if (dataRicezione !== "") {
    dataRicezione = dataRicezione.replaceAll("-", "");
    if (dataRicezione.indexOf("T") > -1) {
      dataRicezione =
        dataRicezione.substring(0, dataRicezione.indexOf("T")) +
        "  " +
        dataRicezione.substring(dataRicezione.indexOf("T"));
    }
  }

  try {
    documentResource = dataArea[0].DocumentResource[0] ?? "";
    FileName = documentResource.FileName[0] ?? "";
    FileURL = documentResource.URL[0] ?? "";
    //console.log(dataArea[0].DocumentMetaData[0].Attribute);
  } catch (err) {
    //console.log(dataArea);
    console.log(err);
    FileName = "ERROR";
    return res.send(doc.toString({ pretty: true }));
  }
  if (FileName == "ERROR") return res.send(doc.toString({ pretty: true }));

  FileURL = FileURL.replace("&amp;", "&").trim();
  let getXMLError = false;
  axios.get(FileURL, config).then((atp) => {
    try {
      let fattura = atp.data
        .replace(
          "</DatiTrasmissione>",
          "<IdSime>" +
            idFatturaSIME +
            "</IdSime><DataRicezione>" +
            dataRicezione +
            "</DataRicezione></DatiTrasmissione>"
        )
        .replaceAll('"', "'"); // invoice xml (type: string)

      if (
        fattura.includes("LoginErrors()") ||
        (!fattura.includes("<") && !fattura.includes("</"))
      ) {
        return res.send(doc.toString({ pretty: true }));
      }

      // 2023-12-15 - D. Bettero - rimozione eventuale tag <?xml-stylesheet>
      if (
        fattura !== undefined &&
        fattura !== null &&
        typeof fattura === "string"
      ) {
        if (fattura.includes("<?xml-stylesheet")) {
          let start = fattura.indexOf("<?xml-stylesheet");
          let end = fattura.indexOf("?>", start);
          fattura = fattura.substring(0, start) + fattura.substring(end + 2);
        }
      }

      // 2023-12-15 - Aggiunta namespace tag root
      if (
        fattura !== undefined &&
        fattura !== null &&
        typeof fattura === "string"
      ) {
        if (
          fattura.includes("<FatturaElettronica ") &&
          fattura.includes("</FatturaElettronica>") &&
          (fattura.includes(
            "xmlns='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture"
          ) ||
            fattura.includes(
              'xmlns="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture'
            ))
        ) {
          if (!fattura.includes("xmlns:p")) {
            fattura = fattura.replaceAll(
              "<FatturaElettronica ",
              "<p:FatturaElettronica "
            );
            fattura = fattura.replaceAll(
              "</FatturaElettronica>",
              "</p:FatturaElettronica>"
            );
            fattura = fattura.replaceAll(
              "xmlns='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture",
              "xmlns:p='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture"
            );
            fattura = fattura.replaceAll(
              'xmlns="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture',
              'xmlns:p="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture'
            );
          }

          if (!fattura.includes("xmlns:a")) {
            fattura = fattura.replaceAll(
              "<FatturaElettronica ",
              "<a:FatturaElettronica "
            );
            fattura = fattura.replaceAll(
              "</FatturaElettronica>",
              "</a:FatturaElettronica>"
            );
            fattura = fattura.replaceAll(
              "xmlns='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture",
              "xmlns:a='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture"
            );
            fattura = fattura.replaceAll(
              'xmlns="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture',
              'xmlns:a="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture'
            );
          }

          if (!fattura.includes("xmlns:d")) {
            fattura = fattura.replaceAll(
              "<FatturaElettronica ",
              "<d:FatturaElettronica "
            );
            fattura = fattura.replaceAll(
              "</FatturaElettronica>",
              "</d:FatturaElettronica>"
            );
            fattura = fattura.replaceAll(
              "xmlns='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture",
              "xmlns:d='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture"
            );
            fattura = fattura.replaceAll(
              'xmlns="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture',
              'xmlns:d="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture'
            );
          }

          if (!fattura.includes("xmlns:b")) {
            fattura = fattura.replaceAll(
              "<FatturaElettronica ",
              "<b:FatturaElettronica "
            );
            fattura = fattura.replaceAll(
              "</FatturaElettronica>",
              "</b:FatturaElettronica>"
            );
            fattura = fattura.replaceAll(
              "xmlns='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture",
              "xmlns:b='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture"
            );
            fattura = fattura.replaceAll(
              'xmlns="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture',
              'xmlns:b="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture'
            );
          }
        }
      }

      let pathXSL =
        "D:\\horsa_docLifeProxy\\Stylesheets\\FP_family-1005-PA-vFPR12.xsl"; // path to stylesheet
      const exec = require("child_process").exec;
      let resultString = "";
      const { v4: uuidv4 } = require("uuid");
      let fileName = uuidv4();
      const fs = require("fs");

      fs.writeFileSync("invoices/" + fileName + ".xml", fattura, (err) => {
        getXMLError = true;
        if (err) return res.send(doc.toString({ pretty: true }));
      });

      if (getXMLError) {
        var errorMessage = atp.errorMessage;
        console.log("error message: " + errorMessage);
        return res.send(doc.toString({ pretty: true }));
      }

      if (fs.existsSync("invoices/" + fileName + ".xml")) {
        exec(
          "java XmlTransform " +
            pathXSL +
            " D:\\horsa_docLifeProxy\\invoices\\" +
            fileName +
            ".xml",
          function callback(error, stdout, stderr) {
            resultString = stdout;
            var pdf = require("html-pdf");
            var html = resultString;
            console.log(html);
            var options = {
              format: "A4",
              orientation: "portrait",
              paginationOffset: 1,
              header: {
                height: "10mm",
                contents:
                  '<div style="text-align: center;">' +
                  "Id. SIME " +
                  idFatturaSIME +
                  "</div>",
              },
              footer: {
                height: "10mm",
                contents: {
                  default:
                    '<div style="text-align: center;"><span style="color: #444;">{{page}}</span>/<span>{{pages}}</span></div>',
                },
              },
            };
            try {
              pdf.create(html, options).toBuffer(function (err, buffer) {
                if (err) return res.send(doc.toString({ pretty: true }));
                let rawData = buffer.toString("base64");

                let i = 0;
                let attrs = {};

                while (
                  dataArea[0].DocumentMetaData[0].Attribute[i] !== undefined
                ) {
                  attrs[dataArea[0].DocumentMetaData[0].Attribute[i].$["id"]] =
                    dataArea[0].DocumentMetaData[0].Attribute[i]
                      .AttributeValue === undefined
                      ? ""
                      : dataArea[0].DocumentMetaData[0].Attribute[
                          i
                        ].AttributeValue[0]
                          .toString()
                          .trim();
                  i++;
                }
                for (var [key, value] of Object.entries(attrs)) {
                  if (key === "FileName") {
                    value = value.replace(".xml", ".pdf");
                    if (!value.includes(".pdf")) {
                      value = value + ".pdf";
                    }
                  }
                  doc.ele(key).txt(value).up();
                }
                doc.ele("RawData").txt(rawData);

                WriteLogSync(
                  "D:\\horsa_docLifeProxy\\log\\FatturePassive.txt",
                  "Generato PDF fattura idFatturaSIME = " + idFatturaSIME
                );

                return res.send(doc.toString({ pretty: true }));
              });
            } catch (err) {
              var errorMessage = "Token Scaduto";
              console.log("error message: " + errorMessage);
              return res.send(doc.toString({ pretty: true }));
            }
          }
        );
      } else {
        return res.send(doc.toString({ pretty: true }));
      }
    } catch (err) {
      var errorMessage = atp.errorMessage;
      console.log("errorMessage: " + errorMessage);
      return res.send(doc.toString({ pretty: true }));
    }
  });
});

// Get the attachments of the passive invoice, if present.
// Return an xml containing the base64 of the attachments of the pdf invoice and their attributes (if valued).
// Input: Sync.ContentDocument of passive invoice's class
app.post("/getPassiveInvoiceAttachment", async (req, res) => {
  var basicAuth = req.header("authorization");
  const config = {
    headers: {
      Authorization: basicAuth,
    },
    maxRedirects: 21,
  };

  const builder = require("xmlbuilder");
  var doc = builder.create("PassiveInvoiceAttachment");

  let FileName = "";
  let documentResource = "";
  let FileURL = "";
  let rawdata = "";
  let dataArea = "";
  let pid = "";
  try {
    rawdata = req.body;
    dataArea = rawdata.SyncContentDocument.DataArea[0].ContentDocument;
    pid = dataArea[0].DocumentID[0].ID[0]._;
    documentResource = dataArea[0].DocumentResource[0] ?? "";
    FileName = documentResource.FileName[0] ?? "";
    FileURL = documentResource.URL[0] ?? "";
    //console.log(dataArea[0].DocumentMetaData[0].Attribute);
  } catch (err) {
    //console.log(dataArea);
    console.log(err);
    FileName = "ERROR";
    return res.send(doc.toString({ pretty: true }));
  }
  if (FileName == "ERROR") return res.send(doc.toString({ pretty: true }));

  FileURL = FileURL.replace("&amp;", "&").trim();

  axios.get(FileURL, config).then((atp) => {
    try {
      let fattura = atp.data; // invoice xml (type: string)
      if (
        fattura.includes("LoginErrors()") ||
        (!fattura.includes("<") && !fattura.includes("</"))
      ) {
        return res.send(doc.toString({ pretty: true }));
      }

      let i = 0;
      let attrs = {};

      while (dataArea[0].DocumentMetaData[0].Attribute[i] !== undefined) {
        attrs[dataArea[0].DocumentMetaData[0].Attribute[i].$["id"]] =
          dataArea[0].DocumentMetaData[0].Attribute[i].AttributeValue ===
          undefined
            ? ""
            : dataArea[0].DocumentMetaData[0].Attribute[i].AttributeValue[0]
                .toString()
                .trim();
        i++;
      }
      let nomeAllegatoFatturaPassiva = "";
      for (var [key, value] of Object.entries(attrs)) {
        if (key === "FileName") {
          value = value.replace(".xml", ".pdf");
          nomeAllegatoFatturaPassiva = value;
        }
        doc.ele(key).txt(value).up();
      }

      // 2023-12-15 - Rimozione eventuale tag <?xml-stylesheet>
      if (
        fattura !== undefined &&
        fattura !== null &&
        typeof fattura === "string"
      ) {
        if (fattura.includes("<?xml-stylesheet")) {
          let start = fattura.indexOf("<?xml-stylesheet");
          let end = fattura.indexOf("?>", start);
          fattura = fattura.substring(0, start) + fattura.substring(end + 2);
        }
      }

      if (
        fattura.includes("Allegati") ||
        fattura.includes("NomeAttachment") ||
        fattura.includes("Attachment")
      ) {
        const xml = require("xml-parse");
        var xmlInvoice = new xml.DOM(
          xml.parse(fattura.replace(/\uFFFD/g, "").replaceAll('"', "'"))
        );

        i = 0;
        let attchs = doc.ele("Attachments");
        while (
          xmlInvoice.document.getElementsByTagName("NomeAttachment")[i] !==
            undefined &&
          xmlInvoice.document.getElementsByTagName("Attachment")[i] !==
            undefined
        ) {
          let nomeAttachment =
            xmlInvoice.document.getElementsByTagName("NomeAttachment")[i]
              .childNodes[0].text ?? "";

          nomeAttachment = nomeAttachment
            .replaceAll("<![CDATA[", "")
            .replaceAll("]]>", "");
          if (
            !nomeAttachment.includes(".pdf") &&
            !nomeAttachment.includes(".PDF") &&
            !nomeAttachment.includes(".xml") &&
            !nomeAttachment.includes(".XML") &&
            !nomeAttachment.includes(".xls") &&
            !nomeAttachment.includes(".XLS") &&
            !nomeAttachment.includes(".txt") &&
            !nomeAttachment.includes(".TXT") &&
            !nomeAttachment.includes(".md") &&
            !nomeAttachment.includes(".MD")
          ) {
            nomeAttachment = nomeAttachment + ".pdf";
          }

          let rawDataAttachment =
            xmlInvoice.document.getElementsByTagName("Attachment")[i]
              .childNodes[0].text ?? "";
          attchs
            .ele("Attachment")
            .ele("AttachmentFileName")
            .txt(nomeAttachment)
            .up()
            .ele("RawData")
            .txt(
              rawDataAttachment
                .toString()
                .trim()
                .replaceAll(" ", "")
                .replaceAll("\n", "")
                .replaceAll("&amp;#xA;", "")
                .replaceAll("&#xA;", "")
            )
            .up();

          i++;
        }

        WriteLogSync(
          "D:\\horsa_docLifeProxy\\log\\AllegatiFatturePassive.txt",
          "Generato PDF allegato/i fattura passiva nome = " +
            nomeAllegatoFatturaPassiva
        );
      }

      return res.send(doc.toString({ pretty: true }));
    } catch (err) {
      var errorMessage = atp.errorMessage;
      console.log("errorMessage: " + errorMessage);
      return res.send(doc.toString({ pretty: true }));
    }
  });
});

// Transforms with a stylesheet the xml of the active invoice receipt into its pdf.
// Return an xml containing the base64 of the pdf receipt and its attributes (if valued)
// Input: Sync.ContentDocument of receipt's class
app.post("/getActiveInvoiceReceiptPDF", async (req, res) => {
  var basicAuth = req.header("authorization");
  const config = {
    headers: {
      Authorization: basicAuth,
    },
    maxRedirects: 21,
  };

  const builder = require("xmlbuilder");
  var doc = builder.create("ActiveReceiptPDF");

  let rawdata = "";
  let dataArea = "";
  let pid = "";
  let FileName = "";
  let documentResource = "";
  let FileURL = "";
  try {
    rawdata = req.body;
    dataArea = rawdata.SyncContentDocument.DataArea[0].ContentDocument;
    pid = dataArea[0].DocumentID[0].ID[0]._;
    FileName = "";
    documentResource = "";
    FileURL = "";
    documentResource = dataArea[0].DocumentResource[0] ?? "";
    FileName = documentResource.FileName[0] ?? "";
    FileURL = documentResource.URL[0] ?? "";
    //console.log(dataArea[0].DocumentMetaData[0].Attribute);
  } catch (err) {
    //console.log(dataArea);
    console.log(err);
    FileName = "ERROR";
    return res.send(doc.toString({ pretty: true }));
  }
  if (FileName == "ERROR") return res.send(doc.toString({ pretty: true }));

  FileURL = FileURL.replace("&amp;", "&").trim();
  let getXMLError = false;
  axios.get(FileURL, config).then((atp) => {
    try {
      let fattura = atp.data; // receipt xml (type: string)

      if (
        fattura.includes("LoginErrors()") ||
        (!fattura.includes("<") && !fattura.includes("</"))
      ) {
        return res.send(doc.toString({ pretty: true }));
      }

      let pathXSL = "Stylesheets\\FA_Receipt_family-1003.xsl"; // path to stylesheet
      const exec = require("child_process").exec;
      let resultString = "";
      const { v4: uuidv4 } = require("uuid");
      let fileName = uuidv4();
      const fs = require("fs");
      (async () => {
        await fs.writeFileSync(
          "invoices/" + fileName + ".xml",
          fattura,
          (err) => {
            getXMLError = true;
            if (err) throw err;
          }
        );
      })();

      if (getXMLError) {
        var errorMessage = atp.errorMessage;
        console.log("error message: " + errorMessage);
        return res.send(doc.toString({ pretty: true }));
      }

      exec(
        "java XmlTransform " + pathXSL + " invoices\\" + fileName + ".xml",
        function callback(error, stdout, stderr) {
          resultString = stdout;
          var pdf = require("html-pdf");
          var html = resultString;
          var options = {
            format: "A4",
            orientation: "portrait",
            footer: {
              height: "1mm",
              contents: {
                first: "",
                2: "",
                default: "",
                last: "",
              },
            },
          };
          try {
            pdf.create(html, options).toBuffer(function (err, buffer) {
              if (err) return console.log(err);
              let rawData = buffer.toString("base64");

              let i = 0;
              let attrs = {};

              while (
                dataArea[0].DocumentMetaData[0].Attribute[i] !== undefined
              ) {
                attrs[dataArea[0].DocumentMetaData[0].Attribute[i].$["id"]] =
                  dataArea[0].DocumentMetaData[0].Attribute[i]
                    .AttributeValue === undefined
                    ? ""
                    : dataArea[0].DocumentMetaData[0].Attribute[
                        i
                      ].AttributeValue[0]
                        .toString()
                        .trim();
                i++;
              }
              let nomeRicevutaAttiva = "";
              for (var [key, value] of Object.entries(attrs)) {
                if (key === "NomeFile") {
                  value = value.replace(".xml", ".pdf");
                  if (!value.includes(".pdf")) {
                    value = value + ".pdf";
                  }
                  nomeRicevutaAttiva = value;
                }
                doc.ele(key).txt(value).up();
              }
              doc.ele("RawData").txt(rawData);

              WriteLogSync(
                "D:\\horsa_docLifeProxy\\log\\RicevuteFattureAttive.txt",
                "Generato PDF ricevuta attiva nome = " + nomeRicevutaAttiva
              );

              return res.send(doc.toString({ pretty: true }));
            });
          } catch (err) {
            var errorMessage = "Token Scaduto";
            console.log("error message: " + errorMessage);
            return res.send(doc.toString({ pretty: true }));
          }
        }
      );
    } catch (err) {
      var errorMessage = atp.errorMessage;
      console.log("errorMessage: " + errorMessage);
      return res.send(doc.toString({ pretty: true }));
    }
  });
});

// Call api/v1/cc/attivo/ricevute/listUnacknowledged and for each receipt call api/v1/cc/attivo/ricevute/{id}/download.
// Return an xml containing the base64 of receipts and their attributes (if valued)
app.get("/retrieveReceiptsActiveInvoices", async (req, res) => {
  var basicAuth = req.header("authorization");
  const config = {
    headers: {
      Authorization: basicAuth,
    },
    maxRedirects: 21,
  };

  var url =
    "https://console-fe.horsa.it/services/api/v1/cc/attivo/ricevute/listUnacknowledged";
  let temp = [];
  var builder = require("xmlbuilder");
  var doc = builder.create("ActiveReceipts");
  const result = await axios.get(url, config).then((atp) => {
    try {
      console.log(atp.data.result.length);

      for (let i = 0; i < atp.data.result.length; i++) {
        let receiptID = atp.data.result[i].id;
        let sdiID = atp.data.result[i].sdiId;
        let invoiceID = atp.data.result[i].idFattura;
        let invoiceName = atp.data.result[i].nomeFattura; // missing extension (.xml)

        let status = atp.data.result[i].tipoMessaggio;
        let esito = atp.data.result[i].dettaglio.esito;
        if (status === undefined || status === null) {
          status = "SCONOSCIUTO";
        } else {
          status = status.trim();
          switch (status) {
            case "AT":
              status = "NON RECAPITATA";
              break;
            case "RC":
              status = "CONSEGNATA";
              break;
            case "NS":
              status = "SCARTATA";
              break;
            case "MC":
              status = "MANCATA CONSEGNA";
              break;
            case "DT":
              status = "DECORRENZA TERMINI";
              break;
            case "NE":
              if (esito) {
                status = "ACCETTATA";
              } else {
                status = "RIFIUTATA";
              }
              break;
            default:
              status = "SCONOSCIUTO";
              break;
          }
        }

        let actual = {
          receiptID: receiptID,
          sdiID: sdiID,
          invoiceID: invoiceID,
          invoiceName: invoiceName + ".xml",
          status: status,
        };
        temp.push(actual);
        //console.log(actual);
      }
    } catch (err) {
      //console.log(err);
      var errorMessage = atp.data.errorMessage;
      console.log("errorMessage: " + errorMessage);
      return res.send(doc.toString({ pretty: true }));
    }
  });
  //console.log(temp.length);
  for (let i = 0; i < temp.length; i++) {
    //console.log(temp[i].id);
    if (
      temp[i].receiptID != null &&
      temp[i].receiptID != undefined &&
      temp[i].receiptID != ""
    ) {
      var url2 =
        "https://console-fe.horsa.it/services/api/v1/cc/attivo/ricevute/" +
        temp[i].receiptID +
        "/download";
      //console.log(url2);
      const result2 = await axios.get(url2, config).then((atp2) => {
        try {
          if (
            atp2 != undefined &&
            atp2 != null &&
            atp2.data != undefined &&
            atp2.data != null &&
            atp2.data !== ""
          ) {
            let base64Invoice = btoa(atp2.data.replace(/\uFFFD/g, ""));
            temp[i].RawData =
              base64Invoice === undefined ||
              base64Invoice === null ||
              base64Invoice === ""
                ? ""
                : base64Invoice;
            //console.log(base64Invoice);

            const xml = require("xml-parse");
            var xmlInvoice = new xml.DOM(
              xml.parse(atp2.data.replace(/\uFFFD/g, "").replaceAll('"', "'"))
            );

            var Hash = xmlInvoice.document.getElementsByTagName("Hash")[0];
            var DataOraRicezione =
              xmlInvoice.document.getElementsByTagName("DataOraRicezione")[0];
            var DataOraConsegna =
              xmlInvoice.document.getElementsByTagName("DataOraConsegna")[0];
            var CodiceDestinatario =
              xmlInvoice.document.getElementsByTagName("Codice")[0];
            var DescrizioneDestinatario =
              xmlInvoice.document.getElementsByTagName("Descrizione")[0];

            let SigningTime = "";
            if (
              atp2.data.includes("SigningTime>") &&
              atp2.data.indexOf("SigningTime>") !== -1 &&
              atp2.data.includes("</xades:SigningTime>") &&
              atp2.data.indexOf("</xades:SigningTime>") !== -1
            ) {
              SigningTime = atp2.data.substring(
                atp2.data.indexOf("SigningTime>") + "SigningTime>".length,
                atp2.data.indexOf("</xades:SigningTime>")
              );
            }

            temp[i].Hash = Hash === undefined ? "" : Hash.childNodes[0].text;
            temp[i].DataOraRicezione =
              DataOraRicezione === undefined
                ? ""
                : DataOraRicezione.childNodes[0].text;
            temp[i].DataOraConsegna =
              DataOraConsegna === undefined
                ? ""
                : DataOraConsegna.childNodes[0].text;
            temp[i].CodiceDestinatario =
              CodiceDestinatario === undefined
                ? ""
                : CodiceDestinatario.childNodes[0].text;
            temp[i].DescrizioneDestinatario =
              DescrizioneDestinatario === undefined
                ? ""
                : DescrizioneDestinatario.childNodes[0].text;
            temp[i].SigningTime = SigningTime;
          }
        } catch (err) {
          var errorMessage2 = atp2.errorMessage;
          console.log("errorMessage2: " + errorMessage2);
          return res.send(doc.toString({ pretty: true }));
        }
      });
    }
  }
  for (let i = 0; i < temp.length; i++) {
    doc
      .ele("Receipt")
      .ele("ReceiptID")
      .txt(
        temp[i].receiptID === undefined
          ? ""
          : temp[i].receiptID
              .toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("Sdi_ID")
      .txt(
        temp[i].sdiID === undefined
          ? ""
          : temp[i].sdiID.toString().replace("<![CDATA[", "").replace("]]>", "")
      )
      .up()
      .ele("InvoiceID")
      .txt(
        temp[i].invoiceID === undefined
          ? ""
          : temp[i].invoiceID
              .toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("InvoiceName")
      .txt(
        temp[i].invoiceName === undefined
          ? ""
          : temp[i].invoiceName
              .toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("Status")
      .txt(
        temp[i].status === undefined
          ? ""
          : temp[i].status
              .toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("Hash")
      .txt(
        temp[i].Hash === undefined
          ? ""
          : temp[i].Hash.toString().replace("<![CDATA[", "").replace("]]>", "")
      )
      .up()
      .ele("DataOraRicezione")
      .txt(
        temp[i].DataOraRicezione === undefined
          ? ""
          : temp[i].DataOraRicezione.toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("DataOraConsegna")
      .txt(
        temp[i].DataOraConsegna === undefined
          ? ""
          : temp[i].DataOraConsegna.toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("CodiceDestinatario")
      .txt(
        temp[i].CodiceDestinatario === undefined
          ? ""
          : temp[i].CodiceDestinatario.toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("DescrizioneDestinatario")
      .txt(
        temp[i].DescrizioneDestinatario === undefined
          ? ""
          : temp[i].DescrizioneDestinatario.toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("SigningTime")
      .txt(
        temp[i].SigningTime === undefined
          ? ""
          : temp[i].SigningTime.toString()
              .replace("<![CDATA[", "")
              .replace("]]>", "")
      )
      .up()
      .ele("RawData")
      .txt(
        temp[i].RawData === undefined ||
          temp[i].RawData === null ||
          temp[i].RawData === ""
          ? ""
          : temp[i].RawData
      );
  }
  return res.send(doc.toString({ pretty: true }));
});

// Get datas reading the active invoice's xml.
// Return an xml containing the datas (if valued)
// Input: Sync.ContentDocument of active invoice's class
app.post("/getActiveInvoiceDatas", async (req, res) => {
  var basicAuth = req.header("authorization");
  const config = {
    headers: {
      Authorization: basicAuth,
    },
    maxRedirects: 21,
  };

  let FileName = "";
  let documentResource = "";
  let FileURL = "";
  let rawdata = "";
  let dataArea = "";
  let pid = "";
  try {
    rawdata = req.body;
    dataArea = rawdata.SyncContentDocument.DataArea[0].ContentDocument;
    pid = dataArea[0].DocumentID[0].ID[0]._;
    documentResource = dataArea[0].DocumentResource[0] ?? "";
    FileName = documentResource.FileName[0] ?? "";
    FileURL = documentResource.URL[0] ?? "";
    //console.log(dataArea[0].DocumentMetaData[0].Attribute);
  } catch (err) {
    //console.log(dataArea);
    console.log(err);
    FileName = "ERROR";
  }

  const builder = require("xmlbuilder");
  var doc = builder.create("ActiveInvoiceDatas");
  if (FileName == "ERROR") return res.send(doc.toString({ pretty: true }));

  FileURL = FileURL.replace("&amp;", "&").trim();
  let getXMLError = false; //
  axios.get(FileURL, config).then((atp) => {
    try {
      let fattura = atp.data.replaceAll('"', "'"); // invoice xml (type: string)

      if (
        fattura.includes("LoginErrors()") ||
        (!fattura.includes("<") && !fattura.includes("</"))
      ) {
        return res.send(doc.toString({ pretty: true }));
      }

      // 2023-12-15 - Rimozione eventuale tag <?xml-stylesheet>
      if (
        fattura !== undefined &&
        fattura !== null &&
        typeof fattura === "string"
      ) {
        if (fattura.includes("<?xml-stylesheet")) {
          let start = fattura.indexOf("<?xml-stylesheet");
          let end = fattura.indexOf("?>", start);
          fattura = fattura.substring(0, start) + fattura.substring(end + 2);
        }
      }

      // 2023-12-15 - Aggiunta namespace tag root
      if (
        fattura !== undefined &&
        fattura !== null &&
        typeof fattura === "string"
      ) {
        if (
          fattura.includes("<FatturaElettronica ") &&
          fattura.includes("</FatturaElettronica>") &&
          (fattura.includes(
            "xmlns='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture"
          ) ||
            fattura.includes(
              'xmlns="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture'
            ))
        ) {
          fattura = fattura.replaceAll(
            "<FatturaElettronica ",
            "<p:FatturaElettronica "
          );
          fattura = fattura.replaceAll(
            "</FatturaElettronica>",
            "</p:FatturaElettronica>"
          );
          fattura = fattura.replaceAll(
            "xmlns='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture",
            "xmlns:p='http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture"
          );
          fattura = fattura.replaceAll(
            'xmlns="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture',
            'xmlns:p="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture'
          );
        }
      }

      const xml = require("xml-parse");
      var xmlInvoice = new xml.DOM(
        xml.parse(fattura.replace(/\uFFFD/g, "").trim())
      );

      const DatiGeneraliDocumento = xmlInvoice.document.getElementsByTagName(
        "DatiGeneraliDocumento"
      )[0].innerXML;
      var xmlDatiGeneraliDocumento = new xml.DOM(
        xml.parse(DatiGeneraliDocumento)
      );

      var NumeroFattura =
        xmlDatiGeneraliDocumento.document.getElementsByTagName("Numero")[0];
      NumeroFattura =
        NumeroFattura === undefined ? "" : NumeroFattura.childNodes[0].text;
      var DataFattura =
        xmlDatiGeneraliDocumento.document.getElementsByTagName("Data")[0];
      DataFattura =
        DataFattura === undefined ? "" : DataFattura.childNodes[0].text;
      let annoFattura = "";
      if (DataFattura !== undefined && DataFattura !== null) {
        annoFattura = DataFattura.toString()
          .replace("<![CDATA[", "")
          .replace("]]>", "");
        if (annoFattura !== "") {
          annoFattura = annoFattura.substring(0, 4);
        }
      }

      const CedentePrestatore =
        xmlInvoice.document.getElementsByTagName("CedentePrestatore")[0]
          .innerXML;
      var xmlCedentePrestatore = new xml.DOM(xml.parse(CedentePrestatore));
      var PartitaIVACedentePrestatore =
        xmlCedentePrestatore.document.getElementsByTagName("IdCodice")[0];
      PartitaIVACedentePrestatore =
        PartitaIVACedentePrestatore === undefined
          ? ""
          : PartitaIVACedentePrestatore.childNodes[0].text;

      let CodiceFiscaleEmittente = "";
      if (
        FileName !== undefined &&
        FileName !== null &&
        FileName !== "ERROR" &&
        FileName !== ""
      ) {
        CodiceFiscaleEmittente = FileName.toString().replaceAll("IT", "");
        let end = CodiceFiscaleEmittente.indexOf("_");
        CodiceFiscaleEmittente = CodiceFiscaleEmittente.substring(0, end);
      }

      doc
        .ele("NumeroFattura")
        .txt(
          NumeroFattura === undefined
            ? ""
            : NumeroFattura.toString()
                .replace("<![CDATA[", "")
                .replace("]]>", "")
        )
        .up()
        .ele("DataFattura")
        .txt(
          DataFattura === undefined
            ? ""
            : DataFattura.toString().replace("<![CDATA[", "").replace("]]>", "")
        )
        .up()
        .ele("AnnoFattura")
        .txt(
          annoFattura === undefined
            ? ""
            : annoFattura.toString().replace("<![CDATA[", "").replace("]]>", "")
        )
        .up()
        .ele("PartitaIVACedentePrestatore")
        .txt(
          PartitaIVACedentePrestatore === undefined
            ? ""
            : PartitaIVACedentePrestatore.toString()
                .replace("<![CDATA[", "")
                .replace("]]>", "")
        )
        .up()
        .ele("CodiceFiscaleEmittente")
        .txt(
          CodiceFiscaleEmittente === undefined
            ? ""
            : CodiceFiscaleEmittente.toString()
                .replace("<![CDATA[", "")
                .replace("]]>", "")
        )
        .up()
        .ele("pid")
        .txt(
          pid === undefined
            ? ""
            : pid.toString().replace("<![CDATA[", "").replace("]]>", "")
        );

      return res.send(doc.toString({ pretty: true }));
    } catch (err) {
      //console.log(err);
      var errorMessage = atp.errorMessage;
      console.log("errorMessage: " + errorMessage);
      return res.send(doc.toString({ pretty: true }));
    }
  });
});

function WriteLogSync(nameFile, newLine) {
  if (
    nameFile === undefined ||
    nameFile === null ||
    !nameFile ||
    !nameFile.includes(".txt") ||
    newLine === undefined ||
    newLine === null ||
    !newLine
  ) {
    return;
  }

  nameFile = nameFile.replaceAll(".txt", "");
  let currentdate = new Date();
  let datetime =
    currentdate.getDate() +
    "/" +
    (currentdate.getMonth() + 1) +
    "/" +
    currentdate.getFullYear() +
    "  " +
    currentdate.getHours().toString().padStart(2, "0") +
    ":" +
    currentdate.getMinutes().toString().padStart(2, "0") +
    ":" +
    currentdate.getSeconds().toString().padStart(2, "0");

  let yyyyMMdd =
    currentdate.getFullYear().toString() +
    (currentdate.getMonth() + 1).toString() +
    currentdate.getDate().toString();

  nameFile = nameFile + "_" + yyyyMMdd + ".txt";

  if (fs.existsSync(nameFile)) {
    let data = fs.readFileSync(nameFile, "utf-8");
    let newValue = datetime + "   -   " + newLine + "\n" + data;
    fs.writeFileSync(nameFile, newValue, "utf-8");
  } else {
    let newValue = datetime + "   -   " + newLine + "\n";
    fs.writeFileSync(nameFile, newValue, "utf-8");
  }
  return;
}

//var httpsServer = https.createServer(options, app);
//TODO: Change back to https
var httpsServer = http.createServer(app);
console.log("Started");
httpsServer.listen(3009);
