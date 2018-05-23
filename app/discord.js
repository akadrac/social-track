'use strict';

const request = require('request');

const post = (message) => {
  console.log('postToDiscord')
  
  return new Promise((resolve, reject) => {

    let options = {
      url: process.env.webhook,
      method: 'POST',
      json: message
    };

    request(options, (err, res, body) => {
      if (err) {
        reject(err);
      }
      else {
        resolve(res.statusCode);
      }
    });
  });
}

module.exports = { post };