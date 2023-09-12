"use strict";

const express = require('express');
require("dotenv").config({ path: 'envdg' });
const axios = require('axios');
const FormData = require('form-data');
const request = require('request');
const form = new FormData();
var https = require("https");
var http = require("http");
var httpProxy = require("http-proxy");
const { createProxyMiddleware } = require('http-proxy-middleware');
var fs = require("fs");
var contentDisposition = require('content-disposition');
const { XMLParser, XMLBuilder, XMLValidator} = require("fast-xml-parser");

const config = require('./config.json');
console.log(config);

var key = fs.readFileSync(process.env.DG_KEY_URL);
var cert = fs.readFileSync(process.env.DG_CERT_URL);
var options = {
  key: key,
  cert: cert
};

var app = express();
var bodyParser = require('body-parser');
const { Console } = require('console');
require('body-parser-xml')(bodyParser);
app.use(bodyParser.xml({
  limit:'25MB',
  normalizeTags: false
}));


app.post("/postToHorsaFE", (req, res) => {
	//console.log(req);
  var rawdata=req.body;
  var folderID=req.query.folder;
  var overwrite=req.query.overwrite;
  var horsaFEUrl = req.header('targetURL');
  let dataArea = rawdata.SyncContentDocument.DataArea[0].ContentDocument;
  let documentID = dataArea[0].DocumentID[0].ID[0]._;
  let FileName =""; 
  let documentResource ="";
  let FileURL="";
  let returnDocument="";
  try{
     documentResource =  dataArea[0].DocumentResource[0] ?? '';
    FileName = documentResource.FileName[0] ?? '';
    FileURL = documentResource.URL[0] ?? '';
    console.log(dataArea[0].DocumentMetaData[0].Attribute);
  }
  catch(err){
    //console.log(dataArea);
    console.log(err);
    FileName = "ERROR";
  }
  if(FileName == 'ERROR')return;
 
  FileURL = FileURL.replace("&amp;","&");
  const request = axios.get(
    FileURL,
    {
      responseType: 'arraybuffer',
    }
    ).then(responseIDM => {
      //console.log(responseIDM.data)
      const form = new FormData();
      form.append('file', responseIDM.data, {
        filename: FileName,
      });
      console.log(FileName);
      console.log(horsaFEUrl);
      var callUrl = 'https://'+horsaFEUrl+'/services/api/v1/cc/attivo/upload';
      var basicAuth = req.header('authorization');
      console.log(callUrl);
      axios.post(callUrl, form, {
        headers: {
          Authorization: basicAuth,
          'Content-Type': 'multipart/form-data',
          'Accept' : '*/*'
        },
      }).then(function (resp){
        console.log(resp);
        const responseData = {
          id:documentID,
          esito:"ok",
          nodeRef:resp.data.id,
          stato:resp.data.stato,
          datafattura:resp.data.dataFattura,
          annofattura:resp.data.annoFattura,
          tipodocumento:resp.data.tipoDocumento,
          mittente:resp.data.mittente.denominazione,
          mittenteNome:resp.data.mittente.nome, 
          mittenteCognome:resp.data.mittente.cognome,
          mittentePIVA:resp.data.mittente.piva,
          destinatarioDenominazione:resp.data.destinatario.denominazione,
          destinatarioNome:resp.data.destinatario.nome, 
          destinatarioCognome:resp.data.destinatario.cognome,
          destinatarioPIVA:resp.data.destinatario.piva, 
      }
        res.setHeader('Content-Type', 'application/json');
        const jsonContent = JSON.stringify(responseData);
        return res.end(jsonContent);
      }).catch(function (error){
        //req.body.SyncContentDocument.DataArea[0].DocumentMetaData[0].Attribute[0].push({name: "Krishnan", salary: 5678});
        console.log(error);
        const responseData = {
          id:documentID,
          esito:error.response.data.message,
          nodeRef:error.data
      }
      res.setHeader('Content-Type', 'application/json');
      const jsonContent = JSON.stringify(responseData);
      return res.end(jsonContent);
      });
      
    }).catch(function (error) {
    });
  });


app.post("/postToDocLife", (req, res) => {

  var rawdata=req.body;
  var folderID=req.query.folder;
  var overwrite=req.query.overwrite;
  var horsaFEUrl = req.header('targetURL');
  let dataArea = rawdata.SyncContentDocument.DataArea[0].ContentDocument;
  let documentID = dataArea[0].DocumentID[0].ID[0]._;
  let FileName =""; 
  let documentResource ="";
  let DocumentMetaData  ="";
  let Documenttype="";
  let FileURL="";
  let returnDocument="";
  try{
      documentResource =  dataArea[0].DocumentResource[0] ?? '';
      DocumentMetaData = dataArea[0].DocumentMetaData[0] ?? '';
      Documenttype = DocumentMetaData.DocumentTypeID[0] ?? '';
      FileName = documentResource.FileName[0] ?? '';
      FileURL = documentResource.URL[0] ?? '';
  }
  catch(err){
    console.log(Documenttype);
    console.log("error");
    FileName = "ERROR";
  }
  if(FileName == 'ERROR')return;
 
  FileURL = FileURL.replace("&amp;","&");
  const request = axios.get(
    FileURL,
    {
      responseType: 'arraybuffer',
    }
    ).then(responseIDM => {
      console.log(responseIDM.data)
      const form = new FormData();
      console.log(FileName);
      form.append('file', responseIDM.data, {
        filename: FileName,
      });
      var callUrl = 'https://'+horsaFEUrl+'/doclife/api/document/'+folderID+'/uploadornewversion';
      var basicAuth = req.header('authorization');
      console.log("DOCLIFE");
      axios.post(callUrl, form, {
        headers: {
          Authorization: basicAuth,
          'Content-Type': 'multipart/form-data'
        },
      }).then(function (resp){
        returnDocument=req.body;
        console.log(resp.data);
        let nodeRef=resp.data.noderef;
        //Set Document Type
        //const resSetDocumentType  = axios.put('https://'+horsaFEUrl+'/doclife/api/document/'+nodeRef+'/uploadornewversion';, { hello: 'world' });
        //Get Document Type Configuration
        var result=config.filter(obj=> obj.idmdocument == Documenttype);
        console.log(result[0].doclife);

        let docLifeAttributeNodeRef = result[0].doclife.doclifeNodeRef ?? '';
        let docLifeAttributeAspect = result[0].doclife.docLifeAspect  ?? '';
        let attributes = result[0].doclife.attributes  ?? '';

        const responseData = {
          id:documentID,
          esito:resp.data.esito,
          nodeRef:resp.data.noderef
        }
        let addAttributeUrl = 'https://'+horsaFEUrl+'/doclife/api/document/'+nodeRef;
        axios.put(addAttributeUrl, { 
          "objectType": "hdm:document",
           "nodeRef": nodeRef,
           "typology": [
            docLifeAttributeNodeRef
           ]
        },
        {
          headers: {
            Authorization: basicAuth
          },
        }).then(function (respAttribute) {
          console.log(respAttribute);
          res.setHeader('Content-Type', 'application/json');
          const jsonContent = JSON.stringify(responseData);
         return res.end(jsonContent);
        }
      ).catch(function (errorAttribute){
        console.log("erroreAttributo");
        console.log(errorAttribute);
        return res.send("error");
      });
      
      }).catch(function (error){
        console.log("qui");
        console.log(error);
        return res.send(error.response.data);
      });
      
    }).catch(function (error) {
    });
  });

  
    
    var httpsServer = https.createServer(options, app);
    //TODO: Change back to https
    //var httpsServer = http.createServer( app);
    console.log("Started");
    httpsServer.listen(3009);