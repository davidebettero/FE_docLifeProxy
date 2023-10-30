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
    .catch(function (error) {
      console.log(error);
    });
});

// D. Bettero - 2023-09-11 - call api/v1/cc/passivo/listUnacknowledged and for each invoice call api/v1/cc/passivo/{id}/download.
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
    "https://horsa-for.partner.horsafe.net/services/api/v1/cc/passivo/listUnacknowledged";
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

        let actual = {
          id: invoiceID,
          sdiID: sdiID,
          fileName: fileName + ".xml",
          documentDate: documentDate,
          documentNumber: documentNumber,
        };
        temp.push(actual);
        //console.log(actual);
      }
    } catch (err) {
      //console.log(err);
      var errorMessage = atp.data.errorMessage;
      console.log("errorMessage: " + errorMessage);
    }
  });
  //console.log(temp.length);
  for (let i = 0; i < temp.length; i++) {
    //console.log(temp[i].id);
    if (temp[i].id != null && temp[i].id != undefined && temp[i].id != "") {
      var url2 =
        "https://horsa-for.partner.horsafe.net/services/api/v1/cc/passivo/" +
        temp[i].id +
        "/download";

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
            let base64Invoice = btoa(atp2.data.replace(/\uFFFD/g, ""));
            temp[i].RawData =
              base64Invoice === undefined ||
              base64Invoice === null ||
              base64Invoice === ""
                ? ""
                : base64Invoice;
            //console.log(base64Invoice);
            //console.log(typeof atp2.data);

            const xml = require("xml-parse");
            var xmlInvoice = new xml.DOM(
              xml.parse(atp2.data.replace(/\uFFFD/g, ""))
            );
            var PaeseTrasmittente =
              xmlInvoice.document.getElementsByTagName("IdPaese")[0];
            var CodiceTrasmittente =
              xmlInvoice.document.getElementsByTagName("IdCodice")[0];
            var PaesePrestatore =
              xmlInvoice.document.getElementsByTagName("IdPaese")[1];
            var CodicePrestatore =
              xmlInvoice.document.getElementsByTagName("IdCodice")[1];
            var DenominazionePrestatore =
              xmlInvoice.document.getElementsByTagName("Denominazione")[0];
            var PaeseCommittente =
              xmlInvoice.document.getElementsByTagName("IdPaese")[2];
            var CodiceCommittente =
              xmlInvoice.document.getElementsByTagName("IdCodice")[2];

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
                : DenominazionePrestatore.childNodes[0].text;
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
        }
      });
    }
  }
  for (let i = 0; i < temp.length; i++) {
    doc
      .ele("PassiveInvoice")
      .ele("ID")
      .txt(temp[i].id ?? "")
      .up()
      .ele("Sdi_ID")
      .txt(temp[i].sdiID ?? "")
      .up()
      .ele("FileName")
      .txt(temp[i].fileName ?? "")
      .up()
      .ele("DocumentDate")
      .txt(temp[i].documentDate ?? "")
      .up()
      .ele("DocumentNumber")
      .txt(temp[i].documentNumber ?? "")
      .up()
      .ele("PaeseTrasmittente")
      .txt(temp[i].PaeseTrasmittente ?? "")
      .up()
      .ele("CodiceTrasmittente")
      .txt(temp[i].CodiceTrasmittente ?? "")
      .up()
      .ele("PaesePrestatore")
      .txt(temp[i].PaesePrestatore ?? "")
      .up()
      .ele("CodicePrestatore")
      .txt(temp[i].CodicePrestatore ?? "")
      .up()
      .ele("DenominazionePrestatore")
      .txt(temp[i].DenominazionePrestatore ?? "")
      .up()
      .ele("PaeseCommittente")
      .txt(temp[i].PaeseCommittente ?? "")
      .up()
      .ele("CodiceCommittente")
      .txt(temp[i].CodiceCommittente ?? "")
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

// 2023-09-12 - D. Bettero - call api/v1/cc/attivo/ricevute/listUnacknowledged and for each receipt call api/v1/cc/attivo/ricevute/{id}/download.
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
    "https://horsa-for.partner.horsafe.net/services/api/v1/cc/attivo/ricevute/listUnacknowledged";
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

        let actual = {
          receiptID: receiptID,
          sdiID: sdiID,
          invoiceID: invoiceID,
          invoiceName: invoiceName + ".xml",
        };
        temp.push(actual);
        //console.log(actual);
      }
    } catch (err) {
      //console.log(err);
      var errorMessage = atp.data.errorMessage;
      console.log("errorMessage: " + errorMessage);
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
        "https://horsa-for.partner.horsafe.net/services/api/v1/cc/attivo/ricevute/" +
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
              xml.parse(atp2.data.replace(/\uFFFD/g, ""))
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
        }
      });
    }
  }
  for (let i = 0; i < temp.length; i++) {
    doc
      .ele("Receipt")
      .ele("ReceiptID")
      .txt(temp[i].receiptID ?? "")
      .up()
      .ele("Sdi_ID")
      .txt(temp[i].sdiID ?? "")
      .up()
      .ele("InvoiceID")
      .txt(temp[i].invoiceID ?? "")
      .up()
      .ele("InvoiceName")
      .txt(temp[i].invoiceName ?? "")
      .up()
      .ele("Hash")
      .txt(temp[i].Hash ?? "")
      .up()
      .ele("DataOraRicezione")
      .txt(temp[i].DataOraRicezione ?? "")
      .up()
      .ele("DataOraConsegna")
      .txt(temp[i].DataOraConsegna ?? "")
      .up()
      .ele("CodiceDestinatario")
      .txt(temp[i].CodiceDestinatario ?? "")
      .up()
      .ele("DescrizioneDestinatario")
      .txt(temp[i].DescrizioneDestinatario ?? "")
      .up()
      .ele("SigningTime")
      .txt(temp[i].SigningTime ?? "")
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

// 2023-10-18 - D. Bettero - transforms with a stylesheet the xml of the active invoice into its pdf.
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

  var rawdata = req.body;
  let dataArea = rawdata.SyncContentDocument.DataArea[0].ContentDocument;
  let pid = dataArea[0].DocumentID[0].ID[0]._;
  let FileName = "";
  let documentResource = "";
  let FileURL = "";
  try {
    documentResource = dataArea[0].DocumentResource[0] ?? "";
    FileName = documentResource.FileName[0] ?? "";
    FileURL = documentResource.URL[0] ?? "";
    //console.log(dataArea[0].DocumentMetaData[0].Attribute);
  } catch (err) {
    //console.log(dataArea);
    console.log(err);
    FileName = "ERROR";
  }
  if (FileName == "ERROR") return;

  FileURL = FileURL.replace("&amp;", "&").trim();

  const builder = require("xmlbuilder");
  var doc = builder.create("ActiveInvoicePDF");

  axios.get(FileURL, config).then((atp) => {
    try {
      let fattura = atp.data; // invoice xml (type: string)

      let pathXSL = "Stylesheets/FA_family-1001-PA-vFPR12.xsl"; // path to stylesheet
      const exec = require("child_process").exec;
      const { v4: uuidv4 } = require("uuid");
      let fileName = uuidv4();
      const fs = require("fs");
      fs.writeFileSync("invoices/" + fileName + ".xml", fattura, (err) => {
        if (err) throw err;
      });

      exec(
        "java XmlTransform " + pathXSL + " invoices/" + fileName + ".xml",
        function callback(error, stdout, stderr) {
          var html = stdout;
          var pdf = require("html-pdf");
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
          pdf.create(html, options).toBuffer(function (err, buffer) {
            if (err) return console.log(err);
            let rawData = buffer.toString("base64");

            let i = 0;
            let attrs = {};

            while (dataArea[0].DocumentMetaData[0].Attribute[i] !== undefined) {
              attrs[dataArea[0].DocumentMetaData[0].Attribute[i].$["id"]] =
                dataArea[0].DocumentMetaData[0].Attribute[i].AttributeValue ===
                undefined
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
              }
              doc.ele(key).txt(value).up();
            }
            doc.ele("RawData").txt(rawData);

            return res.send(doc.toString({ pretty: true }));
          });
        }
      );
    } catch (err) {
      var errorMessage = atp.errorMessage;
      console.log("errorMessage: " + errorMessage);
      return res.send(doc.toString({ pretty: true }));
    }
  });
});

// 2023-10-18 - D. Bettero - transforms with a stylesheet the xml of the passive invoice into its pdf.
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

  var rawdata = req.body;
  let dataArea = rawdata.SyncContentDocument.DataArea[0].ContentDocument;
  let pid = dataArea[0].DocumentID[0].ID[0]._;
  let FileName = "";
  let documentResource = "";
  let FileURL = "";
  try {
    documentResource = dataArea[0].DocumentResource[0] ?? "";
    FileName = documentResource.FileName[0] ?? "";
    FileURL = documentResource.URL[0] ?? "";
    //console.log(dataArea[0].DocumentMetaData[0].Attribute);
  } catch (err) {
    //console.log(dataArea);
    console.log(err);
    FileName = "ERROR";
  }
  if (FileName == "ERROR") return;

  FileURL = FileURL.replace("&amp;", "&").trim();

  const builder = require("xmlbuilder");
  var doc = builder.create("PassiveInvoicePDF");

  axios.get(FileURL, config).then((atp) => {
    try {
      let fattura = atp.data; // invoice xml (type: string)

      let pathXSL = "Stylesheets/FP_family-1005-PA-vFPR12.xsl"; // path to stylesheet
      const exec = require("child_process").exec;
      const { v4: uuidv4 } = require("uuid");
      let fileName = uuidv4();
      const fs = require("fs");
      fs.writeFileSync("invoices/" + fileName + ".xml", fattura, (err) => {
        if (err) throw err;
      });

      exec(
        "java XmlTransform " + pathXSL + " invoices/" + fileName + ".xml",
        function callback(error, stdout, stderr) {
          var html = stdout;
          var pdf = require("html-pdf");
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
          pdf.create(html, options).toBuffer(function (err, buffer) {
            if (err) return console.log(err);
            let rawData = buffer.toString("base64");

            let i = 0;
            let attrs = {};

            while (dataArea[0].DocumentMetaData[0].Attribute[i] !== undefined) {
              attrs[dataArea[0].DocumentMetaData[0].Attribute[i].$["id"]] =
                dataArea[0].DocumentMetaData[0].Attribute[i].AttributeValue ===
                undefined
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
              }
              doc.ele(key).txt(value).up();
            }
            doc.ele("RawData").txt(rawData);

            return res.send(doc.toString({ pretty: true }));
          });
        }
      );
    } catch (err) {
      var errorMessage = atp.errorMessage;
      console.log("errorMessage: " + errorMessage);
      return res.send(doc.toString({ pretty: true }));
    }
  });
});

//var httpsServer = https.createServer(options, app);
//TODO: Change back to https
var httpsServer = http.createServer(app);
console.log("Started");
httpsServer.listen(3009);
