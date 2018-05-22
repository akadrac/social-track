'use strict';

const request = require('request');

const post = (tweet) => {
  console.log('postToDiscord')

  let text = tweet.full_text ? tweet.full_text : tweet.text;
  if (tweet.retweeted_status) {
    text = tweet.retweeted_status.full_text ? tweet.retweeted_status.full_text : tweet.retweeted_status.text;
  }

  let content = tweet.retweeted_status ? 'RT @' + tweet.retweeted_status.user.screen_name + ': ' + text : text;

  let message = {
    content: content.replace(/&amp;/g, '&') + ' | <https://twitter.com/' + tweet.user.screen_name + '/status/' + tweet.id_str + '>',
    username: tweet.user.name,
    avatar_url: tweet.user.profile_image_url
  }

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