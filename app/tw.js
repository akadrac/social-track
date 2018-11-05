'use strict'

const twitter = require('twitter')

const client = new twitter({
  consumer_key: process.env.consumer_key,
  consumer_secret: process.env.consumer_secret,
  access_token_key: process.env.access_token_key,
  access_token_secret: process.env.access_token_secret
})

const getTweets = ({screen_name, since_id, exclude_replies}) => new Promise((resolve, reject) => {
  console.log('getTweets:', screen_name, since_id, exclude_replies)

  let params = {
    screen_name,
    since_id,
    exclude_replies,
    tweet_mode: 'extended'
  }

  client.get('statuses/user_timeline', params, (error, tweets, response) => {
    if (error) {
      reject(error)
    } else {
      resolve(tweets)
    }
  })
})

module.exports = { getTweets }