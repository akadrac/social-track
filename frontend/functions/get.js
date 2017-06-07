'use strict';
console.log('Loading function');

// const AWS = require('aws-sdk');
// AWS.config = new AWS.Config();
// AWS.config.update({ region: process.env.region ? process.env.region : 'us-west-2' });
// const dynamodb = new AWS.DynamoDB();

exports.handler = (event, context, callback) => {

  callback(null, {
    statusCode: 200,
    headers: { "Content-Type": "application/json" },
    body: "Hello World!"
  });

  // let params = {
  //   TableName: process.env.table ? process.env.table : "social_track"
  // };

  // dynamodb.scan(params, (err, data) => {
  //   if (err) {
  //     console.log(err);
  //     callback(null, {
  //       statusCode: 500
  //     });
  //   }
  //   else {
  //     callback(null, {
  //       statusCode: 200,
  //       headers: { "Content-Type": "application/json" },
  //       body: JSON.stringify(data.Items)
  //     });
  //   }
  // })

}
