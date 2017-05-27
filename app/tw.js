'use strict';

const oauth2 = require('oauth').OAuth2;
const twitter = require('twitter');

const getTweets = (token, screen_name, since_id, exclude_replies, SECRETS) => {
  console.log('getTweets:', screen_name, since_id, exclude_replies);

  return new Promise((resolve, reject) => {
    var client = new twitter({
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

const getOAuthToken = (SECRETS) => {
  console.log('getOAuthToken');

  return new Promise((resolve, reject) => {
    let url = 'https://api.twitter.com/'
    let path = 'oauth2/token'
    let oauth = new oauth2(SECRETS.CONSUMER_KEY, SECRETS.CONSUMER_SECRET, url, null, path, null);

    let data = {
      'grant_type': 'client_credentials'
    }

    oauth.getOAuthAccessToken('', data, (e, token) => {
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

module.exports = { getTweets, getOAuthToken };