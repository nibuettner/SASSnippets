// based on jquery-3.2.1.min.js
token = "";

function getToken(_callback) {
  // url used to get token
  var url = "http://sasserver.demo.sas.com/SASLogon/oauth/token";

  // base 64 encode "client-id:client-secret"
  var tokenCredentials = btoa('sas.ec:'); // client ID: 'sas.ec'; client secret: <null>

  var payload = {
    "grant_type": "password",
    "username": "<user>",
    "password": "<password>"
  };

  //console.log(JSON.stringify(payload));

  // ajax call to get token
  $.ajax(url, {
    type: "POST",
    contentType: "application/x-www-form-urlencoded",
    headers: {
      "Accept": "application/json",
      "Authorization": "Basic " + tokenCredentials,
      "Content-Type": "application/x-www-form-urlencoded"
    },
    data: payload,
    success: function(response) {
      console.log("getToken() SUCCESS");
      console.log(response);
      token = response.access_token;

      // callback is called only when we successfully got a token
      _callback();
    },
    error: function(response) {
      console.log("getToken() ERROR");
      console.log(response);
      console.log(response.responseText);
    }
  });
}

function getHeader(_callback) {
  var url = 'http://sasserver.demo.sas.com/treatmentDefinitions/definitions/<treatment-id>';

  var xhr = $.ajax(url, {
    type: 'HEAD',
    contentType: "application/json",
    headers: {
      "Authorization": "Bearer " + token,
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    },
    success: function(response, status, xhr) {
      console.log("HEAD SUCCESS");
      console.log(response);
      console.log(xhr.getAllResponseHeaders());
      console.log(xhr.getResponseHeader("ETag"));
      _callback();
    },
    error: function(response) {
      console.log("HEAD ERROR");
      console.log(response);
    },
    complete: function(xhr, status) {
      console.log("HEAD COMPLETE");
      console.log(xhr.getAllResponseHeaders());
      console.log(xhr.getResponseHeader("ETag"));
    }
  });
}

function putTreatment() {
  var url = 'http://sasserver.demo.sas.com/treatmentDefinitions/definitions/<treatment-id>';

  var raw = '{"creationTimeStamp":"2020-07-17T11:44:50.000Z","modifiedTimeStamp":"2020-07-22T08:56:49.469Z","createdBy":"sasdemo","modifiedBy":"sasdemo","id":"<treatment-id>","name":"<treatment-name>","majorRevision":1,"minorRevision":0,"locked":false,"attributes":[{"id":"<treatment-id>","name":"<attribute-name>","description":"<attribute-desc>","defaultValue":10,"valueConstraints":{"dataType":"number","format":"decimal","required":false,"readOnly":false,"multiple":false,"range":false}}],"links":[{"method":"GET","rel":"up","href":"/treatmentDefinitions/definitions","uri":"/treatmentDefinitions/definitions","type":"application/vnd.sas.collection"},{"method":"GET","rel":"self","href":"/treatmentDefinitions/definitions/<treatment-id>","uri":"/treatmentDefinitions/definitions/<treatment-id>","type":"application/vnd.sas.treatment.definition"},{"method":"GET","rel":"alternate","href":"/treatmentDefinitions/definitions/<treatment-id>","uri":"/treatmentDefinitions/definitions/<treatment-id>","type":"application/vnd.sas.summary"},{"method":"DELETE","rel":"delete","href":"/treatmentDefinitions/definitions/<treatment-id>","uri":"/treatmentDefinitions/definitions/<treatment-id>"},{"method":"PUT","rel":"update","href":"/treatmentDefinitions/definitions/<treatment-id>","uri":"/treatmentDefinitions/definitions/<treatment-id>","type":"application/vnd.sas.treatment.definition","responseType":"application/vnd.sas.treatment.definition"},{"method":"GET","rel":"revisions","href":"/treatmentDefinitions/definitions/2b9a94d1-d9d5-4274-9587-b9cc0eb7bd2c/revisions","uri":"/treatmentDefinitions/definitions/<treatment-id>/revisions","type":"application/vnd.sas.collection"}],"version":1,"status":"valid"}';

  xhr = $.ajax(url, {
    type: 'PUT',
    contentType: "application/json",
    headers: {
      "If-Match": "\"<ETag>\"",
      "Authorization": "Bearer " + token,
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    },
    data: raw,
    success: function(response, status, xhr) {
      console.log("PUT SUCCESS");
      console.log(response);
      console.log(xhr.getAllResponseHeaders());
    },
    error: function(response) {
      console.log("PUT ERROR");
      console.log(response);
    },
    complete: function(response, status) {
      console.log("PUT COMPLETE");
      console.log(response);
      console.log(xhr.getAllResponseHeaders());
    }
  });
}

function init() {
  console.log("init");

  getToken(function() {
    getHeader(function() {
      getTreatment();
      putTreatment();
    });
  });
}