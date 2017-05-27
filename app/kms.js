'use strict';

const fs = require('fs');
const AWS = require('aws-sdk');
AWS.config = new AWS.Config();
AWS.config.update({ region: 'us-west-2' });
const kms = new AWS.KMS();

const getSecrets = () => {
  console.log('getSecrets')

  return new Promise((resolve, reject) => {
    var secretPath = './encrypted-secrets';
    var encryptedSecret = fs.readFileSync(secretPath);

    var params = {
      CiphertextBlob: encryptedSecret
    };

    kms.decrypt(params, (err, data) => {
      if (err) reject(err);
      else resolve(JSON.parse(data.Plaintext.toString()));
    });
  })
}

module.exports = { getSecrets };