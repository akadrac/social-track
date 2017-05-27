'use strict';

const request = require('request');

const post = (tweet, webhook) => {
  console.log('postToDiscord')

  let message = {
    content: tweet.text + ' | <https://twitter.com/' + tweet.user.screen_name + '/status/' + tweet.id_str + '>',
    username: tweet.user.screen_name,
    avatar_url: tweet.user.profile_image_url
  }

  return new Promise((resolve, reject) => {

    let options = {
      url: webhook,
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