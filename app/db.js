'use strict';

const AWS = require('aws-sdk');
AWS.config = new AWS.Config();
AWS.config.update({ region: process.env.region ? process.env.region : 'us-west-2' });
const dynamodb = new AWS.DynamoDB();

const getAccounts = () => {
  console.log('getAccounts')

  return new Promise((resolve, reject) => {
    let params = {
      TableName: process.env.table ? process.env.table : "social_track"
    };

    dynamodb.scan(params, (err, data) => {
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
        "screen_name": { S: screen_name },
        "since_id": { S: since_id },
        "exclude_replies": { BOOL: exclude_replies }
      },
      TableName: process.env.table ? process.env.table : "social_track"
    };

    dynamodb.putItem(params, (err, data) => {
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