const { Requester, Validator } = require("@chainlink/external-adapter");

let bearerToken;

const setBearerToken = (token) => {
  bearerToken = token;
};

const customError = (data) => {
  if (data.Response === "Error") return true;
  return false;
};

// Define custom parameters to be used by the adapter.
// Extra parameters can be stated in the extra object,
// with a Boolean value indicating whether or not they
// should be required.
const customParams = {
  endpoint: ["endpoint"],
  beforeDate: ["beforeDate"],
  //afterDate: ["afterDate"],
  sort: ["sort"],
  offset: ["offset"],
  limit: ["limit"]
};

const createRequest = (input, callback) => {
  if (bearerToken == undefined) {
    console.log(
      "Bearer Token hasn't been set call /authorize on this adapter from browser"
    );
  }
  // The Validator helps you validate the Chainlink request data
  const validator = new Validator(callback, input, customParams);
  console.log(validator)
  const jobRunID = validator.validated.id;
  const endpoint = validator.validated.data.endpoint;
  const beforeDate = validator.validated.data.beforeDate;
  //const afterDate = validator.validated.data.afterDate;
  const sort = validator.validated.data.sort;
  const offset = validator.validated.data.offset;
  const limit = validator.validated.data.limit;
  const url = `https://api.fitbit.com${endpoint}`;

  const params = {
    beforeDate,
    //afterDate,
    sort,
    offset,
    limit
  };

  const headers = {
    Authorization: `Bearer ${bearerToken}`,
  };

  const config = {
    url,
    params,
    headers,
  };

  // The Requester allows API calls be retry in case of timeout
  // or connection failure
  Requester.request(config, customError)
    .then((response) => {
      // It's common practice to store the desired value at the top-level
      // result key. This allows different adapters to be compatible with
      // one another.
      console.log("RESPONSE", response.data)
      response.data.result = Requester.getResult(
        response.data,
        ["activities"]
      );
      callback(response.status, Requester.success(jobRunID, response));
    })
    .catch((error) => {
      callback(500, Requester.errored(jobRunID, error));
    });
};


//////////////////////////////////////////////////////////////////


// This is a wrapper to allow the function to work with
// GCP Functions
exports.gcpservice = (req, res) => {
  createRequest(req.body, (statusCode, data) => {
    res.status(statusCode).send(data);
  });
};

// This is a wrapper to allow the function to work with
// AWS Lambda
exports.handler = (event, context, callback) => {
  createRequest(event, (statusCode, data) => {
    callback(null, data);
  });
};

// This is a wrapper to allow the function to work with
// newer AWS Lambda implementations
exports.handlerv2 = (event, context, callback) => {
  createRequest(JSON.parse(event.body), (statusCode, data) => {
    callback(null, {
      statusCode: statusCode,
      body: JSON.stringify(data),
      isBase64Encoded: false,
    });
  });
};

// This allows the function to be exported for testing
// or for running in express
module.exports.createRequest = createRequest;
module.exports.setBearerToken = setBearerToken;
