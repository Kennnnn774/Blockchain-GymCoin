require('dotenv').config()
const { setBearerToken } = require("./index");
const randomstring = require("randomstring");
const { AuthorizationCode } = require("simple-oauth2");
const crypto = require("crypto");
const base64url = require("base64url");

const code_verifier = randomstring.generate(128);
const base64Digest = crypto
  .createHash("sha256")
  .update(code_verifier)
  .digest("base64");
const code_challenge = base64url.fromBase64(base64Digest);

let accessToken;
let authCode;
let refreshToken;

const config = {
  client: {
    id: process.env.CLIENT_ID,
    secret: process.env.CLIENT_SECRET,
  },
  auth: {
    tokenHost: "https://api.fitbit.com",
    authorizeHost: "https://www.fitbit.com",
    tokenPath: "/oauth2/token",
    authorizePath: "/oauth2/authorize",
  },
};

const client = new AuthorizationCode(config);

const auth = async (req, res) => {
  //console.log("Code Verifier", code_verifier);
  //console.log("Code Challenge", code_challenge);
  //console.log("Getting authorization code.");

  const authorizationUri = client.authorizeURL({
    client_id: process.env.CLIENT_ID,
    response_type: "code",
    scope: "activity heartrate location nutrition profile settings sleep social weight",
    code_challenge: code_challenge,
    code_challenge_method: "S256"
  });
  res.redirect(authorizationUri);
  console.log(authorizationUri)
};

const cb = async (req, res) => {
  authCode = req.query.code;
  const tokenParams = {
    client_id: process.env.CLIENT_ID,
    code: authCode,
    code_verifier: code_verifier,
    grant_type: "authorization_code",
  };

  const httpOptions = {
    json: true,
    headers: {
      Authorization: 'Basic '+process.env.BASIC_TOKEN,
      'Content-Type': 'application/x-www-form-urlencoded'
    }
  };

  console.log("Authorization Code: ", tokenParams.code);
  try {
    accessToken = await client.getToken(tokenParams, httpOptions);
    refreshToken = accessToken.token.refresh_token;
    console.log("Access Token is: ", accessToken.token.access_token);
    console.log("Refresh Token is: ", accessToken.token.refresh_token);
    setBearerToken(accessToken.token.access_token);
  } catch (error) {
    console.log("Access Token Error", error);
    console.log("Access Token Error", error.message);
  }
};

const refreshAccessToken = async () => {
  if (accessToken.expired()) {
    try {
      const refreshParams = {
        grant_type: "refresh_token",
        refresh_token: refreshToken,
      };
      accessToken = await accessToken.refresh(refreshParams);
      console.log("Refreshed Access Token is: ", accessToken);
      refreshToken = accessToken.token.refresh_token;
      setBearerToken(accessToken.token.access_token);
    } catch (error) {
      console.log("Error refreshing access token: ", error.message);
    }
  } else {
    console.log("Access Token has not expired.");
  }
};

module.exports.auth = auth;
module.exports.cb = cb;
module.exports.refreshAccessToken = refreshAccessToken;
