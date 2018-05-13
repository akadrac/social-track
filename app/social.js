'use strict';

const db = require('./db');
const tw = require('./tw');
const discord = require('./discord');

const main = async (event, callback) => {
  try {
    let accounts = await db.getAccounts();

    for (let account of accounts) {
      let screen_name = account.screen_name;
      let since_id = account.since_id;
      let exclude_replies = account.exclude_replies;

      let tweets = await tw.getTweets(screen_name, since_id, exclude_replies);
      console.log('number of tweets:', tweets.length);

      // we want to process from oldest tweet to newest
      for (let tweet of tweets.reverse()) {
        if (tweet.id_str > since_id) {
          since_id = tweet.id_str
        }
        await discord.post(tweet);
      }
      if (tweets.length) {
        await db.putAccount(screen_name, since_id, exclude_replies);
      }
    }

    callback(null, "finished!")
  } catch (e) {
    console.log(e.message);
    callback(e);
  }
}

module.exports = {
  main
};