var express = require('express');
var fs = require('fs');
var dotenv = require('dotenv').config();
var http = require('http');
var https = require('https');
var ParseServer = require('parse-server').ParseServer;

var desiKey = fs.readFileSync('server.key');
var desiCert = fs.readFileSync('server.crt');
var HTTP_PORT = process.env.HTTP_PORT;
var HTTPS_PORT = process.env.HTTPS_PORT;

var options = {
  key: desiKey,
  cert: desiCert
};

var app = express();

var api = new ParseServer({
  databaseURI: process.env.DB_URI, // Connection string for your MongoDB database
  cloud: process.env.PATH_TO_CLOUD, // Absolute path to your Cloud Code
  appId: process.env.APP_ID,
  clientKey: process.env.CLIENT_KEY,
  //dotNetKey: process.env.DOT_NET_KEY,
  //javascriptKey: process.env.JAVASCRIPT_KEY,
  //restAPIKey: process.env.REST_API_KEY,
  masterKey: process.env.MASTER_KEY, // Keep this key secret!
  //fileKey: process.env.FILE_KEY,
  serverURL: process.env.SERVER_URL // Don't forget to change to https if needed
});

// routes
app.get('/hey', function(req, res) {
    res.send('HEY!');
});

// Serve the Parse API on the /parse URL prefix
app.use('/parse', api);

http.createServer(app).listen(HTTP_PORT, function(){
  console.log("Desi Server running HTTP");
});

https.createServer(options, app).listen(HTTPS_PORT, function(){
  console.log('Desi Server running HTTPS');
});



