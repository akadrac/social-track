'use strict';

const AWS = require('aws-sdk');
AWS.config = new AWS.Config();
AWS.config.update({ region: process.env.region ? process.env.region : 'ap-southeast-2' });

const getAccounts = () => {
  console.log('getAccounts')

  return new Promise((resolve, reject) => {
    let params = {
      TableName: process.env.table ? process.env.table : "social_track"
    };

    let documentClient = new AWS.DynamoDB.DocumentClient();

    documentClient.scan(params, (err, data) => {
      if (err) {
        reject(err);
      }
      else {
        resolve(data.Items);
      }
    })
  });
}

const putAccount = (screen_name, since_id, exclude_replies) => {
  console.log('putAccount')

  return new Promise((resolve, reject) => {
    let params = {
      Item: {
        "screen_name": screen_name,
        "since_id": since_id,
        "exclude_replies": exclude_replies
      },
      TableName: process.env.table ? process.env.table : "social_track"
    };

    let documentClient = new AWS.DynamoDB.DocumentClient();

    documentClient.put(params, (err, data) => {
      if (err) {
        reject(err);
      }
      else {
        resolve(data);
      }
    })
  });
}

module.exports = {getAccounts, putAccount};