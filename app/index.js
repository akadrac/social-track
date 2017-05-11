'use strict';
console.log('Loading function');

const fs = require('fs');
const co = require('co');
const https = require('https');
const OAuth2 = require('oauth').OAuth2;
const Twitter = require('twitter');
const request = require('request');

const AWS = require('aws-sdk');
AWS.config = new AWS.Config();
AWS.config.update({ region: 'us-west-2' });
const dynamodb = new AWS.DynamoDB();
const kms = new AWS.KMS();

let SECRETS = {}

exports.handler = (event, context, callback) => {

  co(function* main() {
    try {
      SECRETS = yield getSecrets();

      let token = yield getOAuthToken();
      let accounts = yield getAccounts();

      for (let account of accounts) {
        let screen_name = account.screen_name.S;
        let since_id = account.since_id.S;
        let exclude_replies = account.exclude_replies.BOOL;

        let tweets = yield getTweets(token, screen_name, since_id, exclude_replies);
        console.log('number of tweets:', tweets.length);

        // we want to process from oldest tweet to newest
        for (let tweet of tweets.reverse()) {
          if (tweet.id_str > since_id) {
            since_id = tweet.id_str
          }
          yield postToDiscord(tweet);
        }
        if (tweets.length) {
          yield putAccount(screen_name, since_id, exclude_replies);
        }
      }

      callback(null, "finished!")
    }
    catch (e) {
      callback(e)
    }
  })

}

const getAccounts = () => {
  console.log('getAccounts')

  return new Promise((resolve, reject) => {
    let params = {
      TableName: "social_track"
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
        'screen_name': { S: screen_name },
        'since_id': { S: since_id },
        'exclude_replies': { BOOL: exclude_replies }
      },
      TableName: 'social_track'
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

const postToDiscord = (tweet) => {
  console.log('postToDiscord')

  let message = {
    content: tweet.text + ' | <https://twitter.com/' + tweet.user.screen_name + '/status/' + tweet.id_str + '>',
    username: tweet.user.screen_name,
    avatar_url: tweet.user.profile_image_url
  }

  return new Promise((resolve, reject) => {

    let options = {
      url: SECRETS.WEBHOOK,
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

const getTweets = (token, screen_name, since_id, exclude_replies) => {
  console.log('getTweets:', screen_name, since_id, exclude_replies);

  return new Promise((resolve, reject) => {
    var client = new Twitter({
      consumer_key: SECRETS.CONSUMER_KEY,
      consumer_secret: SECRETS.CONSUMER_SECRET,
      bearer_token: token
    });

    var params = {
      screen_name: screen_name,
      since_id: since_id,
      exclude_replies: exclude_replies
    }

    client.get('statuses/user_timeline', params, (error, tweets, response) => {
      if (error) {
        reject(error);
      }
      else {
        resolve(tweets);
      }
    });
  });
}

const getOAuthToken = () => {
  console.log('getOAuthToken');

  return new Promise((resolve, reject) => {
    let url = 'https://api.twitter.com/'
    let path = 'oauth2/token'

    let oauth2 = new OAuth2(SECRETS.CONSUMER_KEY, SECRETS.CONSUMER_SECRET, url, null, path, null);

    let data = {
      'grant_type': 'client_credentials'
    }

    oauth2.getOAuthAccessToken('', data, (e, token) => {
      if (e) {
        console.log(`Got error: ${e.message}`);
        reject(e);
      }
      else {
        resolve(token);
      }
    })
  });
}

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
