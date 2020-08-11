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

function callback() {
}

function init() {
  console.log("init");

  getToken(function() {
    callback();
  });
}