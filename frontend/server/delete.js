'use strict';
console.log('Loading function');

exports.handler = (event, context, callback) => {

  callback(null, {
    statusCode: 200,
    headers: { "Content-Type": "application/json" },
    body: "Hello World! - delete"
  });

}
