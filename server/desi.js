var express = require('express');
var fs = require('fs');
var dotenv = require('dotenv').config();
var ParseServer = require('parse-server').ParseServer;
var app = express();

var api = new ParseServer({
  databaseURI: process.env.DB_URI, // Connection string for your MongoDB database
  cloud: process.env.PATH_TO_CLOUD, // Absolute path to your Cloud Code
  appId: process.env.APP_ID,
  clientKey: process.env.CLIENT_KEY,
  dotNetKey: process.env.DOT_NET_KEY,
  javascriptKey: process.env.JAVASCRIPT_KEY,
  restAPIKey: process.env.REST_API_KEY,
  masterKey: process.env.MASTER_KEY, // Keep this key secret!
  fileKey: process.env.FILE_KEY,
  serverURL: process.env.API_URL // Don't forget to change to https if needed
});

// Serve the Parse API on the /parse URL prefix
app.use('/parse', api);

app.listen(1337, function() {
  console.log('Desi Server running on port 1337.');
});
