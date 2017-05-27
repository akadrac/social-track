'use strict';

const co = require('co');
const kms = require('./kms');
const db = require('./db');
const tw = require('./tw');
const discord = require('./discord');

const main = (event, callback) => {
  co(function* () {
    try {
      let SECRETS = yield kms.getSecrets();

      let token = yield tw.getOAuthToken(SECRETS);
      let accounts = yield db.getAccounts();

      for (let account of accounts) {
        let screen_name = account.screen_name.S;
        let since_id = account.since_id.S;
        let exclude_replies = account.exclude_replies.BOOL;

        let tweets = yield tw.getTweets(token, screen_name, since_id, exclude_replies, SECRETS);
        console.log('number of tweets:', tweets.length);

        // we want to process from oldest tweet to newest
        for (let tweet of tweets.reverse()) {
          if (tweet.id_str > since_id) {
            since_id = tweet.id_str
          }
          yield discord.post(tweet, SECRETS.WEBHOOK);
        }
        if (tweets.length) {
          yield db.putAccount(screen_name, since_id, exclude_replies);
        }
      }

      callback(null, "finished!")
    }
    catch (e) {
      callback(e)
    }
  })
}

module.exports = { main };