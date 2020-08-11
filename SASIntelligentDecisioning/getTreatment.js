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

function getTreatment() {
  var url = 'http://sasserver.demo.sas.com/treatmentDefinitions/definitions/<treatment-id>';

  xhr = $.ajax(url, {
    type: 'GET',
    contentType: "application/json",
    headers: {
      "Authorization": "Bearer " + token,
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    },
    success: function(response, status, xhr) {
      console.log("GET SUCCESS");
      console.log(response);
      console.log(xhr.getAllResponseHeaders());
    },
    error: function(response) {
      console.log("GET ERROR");
      console.log(response);
    },
    complete: function(response, status) {
      console.log("GET COMPLETE");
      console.log(response);
      console.log(xhr.getAllResponseHeaders());
    }
  });
}

function init() {
  console.log("init");

  getToken(function() {
    getTreatment();
  });
}