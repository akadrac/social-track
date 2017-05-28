'use strict';

const fs = require('fs');
const AWS = require('aws-sdk');
AWS.config = new AWS.Config();
AWS.config.update({ region: process.env.region ? process.env.region : 'us-west-2' });
const kms = new AWS.KMS();
const s3 = new AWS.S3({signatureVersion: "v4"});

const getSecrets = () => {
  console.log('getSecrets')

  return new Promise((resolve, reject) => {
    getFile().then(data => {
      var params = {
        CiphertextBlob: data.Body
      };

      kms.decrypt(params, (err, data) => {
        if (err) reject(err);
        else resolve(JSON.parse(data.Plaintext.toString()));
      });
    }).catch(err => reject(err))
  })
}

const getFile = () => {
  console.log('getFile');

  let params = {
    Bucket: process.env.bucket ? process.env.bucket : "social-track",
    Key: process.env.secrets ? process.env.secrets : "encrypted-secrets"
  }
  return new Promise((resolve, reject) => {
    s3.getObject(params, (err, data) => {
      if (err) reject(err);
      else resolve(data);
    });
  })
}

module.exports = { getSecrets };