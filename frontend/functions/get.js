'use strict';
console.log('Loading function');

const AWS = require('aws-sdk');
AWS.config = new AWS.Config();
AWS.config.update({ region: process.env.region ? process.env.region : 'ap-southeast-2' });
const dynamodb = new AWS.DynamoDB();

exports.handler = (event, context, callback) => {

  let params = {
    TableName: process.env.table ? process.env.table : "social_track"
  };

  var documentClient = new AWS.DynamoDB.DocumentClient();

  documentClient.scan(params, (err, data) => {
    if (err) {
      console.log(err);
      callback(err, { "error": "delete failed" });
    }
    else {
      callback(null, { "data": data.Items });
    }
  })

}
