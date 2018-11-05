'use strict'

const db = require('./db')
const tw = require('./tw')
const discord = require('./discord')
const bigInt = require('big-integer')

const main = async (event, callback) => {
  try {
    let accounts = await db.getAccounts()

    for (let { screen_name, since_id, exclude_replies, webhook } of accounts) {
      let tweets = await tw.getTweets({ screen_name, since_id, exclude_replies })
      console.log('number of tweets:', tweets.length)

      // we want to process from oldest tweet to newest
      for (let tweet of tweets.reverse()) {
        if (bigInt(tweet.id_str) > bigInt(since_id)) {
          since_id = tweet.id_str
        }

        let id = tweet.retweeted_status ? tweet.retweeted_status.id_str : tweet.id_str
        let name = tweet.retweeted_status ? tweet.retweeted_status.user.screen_name : tweet.user.screen_name
        let text = ''
        if (tweet.retweeted_status) {
          text = `RT @ ${name}: ${tweet.retweeted_status.full_text ? tweet.retweeted_status.full_text : tweet.retweeted_status.text}`
        } else {
          text = tweet.full_text ? tweet.full_text : tweet.text
        }

        let content = `${text.replace(/&amp;/g, '&')} | <https://twitter.com/${name}/status/${id}>`
        let username = tweet.user.name
        let avatar_url = tweet.user.profile_image_url

        await discord.post({ content, username, avatar_url, webhook })
      }
      if (tweets.length) {
        await db.putAccount({ screen_name, since_id, exclude_replies, webhook })
      }
    }

    callback(null, "finished!")
  } catch (e) {
    console.log(e.message)
    callback(e)
  }
}

module.exports = { main }