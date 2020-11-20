'use strict'

const db = require('./db')
const tw = require('./tw')
const discord = require('./discord')
const bigInt = require('big-integer')
const { unescape } = require('html-escaper')

const main = async (event, callback) => {
  try {

    await Promise.all((await db.getAccounts()).map(processTweets))

    callback(null, "finished!")
  } catch (e) {
    callback(e)
  }
}

const processTweets = async ({ screen_name, since_id, exclude_replies, webhook, }) => {
  try {
    const tweets = await tw.getTweets({ screen_name, since_id, exclude_replies })

    console.log(`processTweets: ${screen_name} has ${tweets.length} new tweets`)

    const messages = await Promise.all(tweets.reverse().map(await formatMessage))

    await Promise.all(messages.map(async obj => await discord.post({ ...obj, webhook })))

    if (tweets.length) {
      await db.putAccount({
        screen_name, exclude_replies, webhook,
        since_id: tweets.reduce((prev, cur) => bigInt(cur.id_str).value > bigInt(prev).value ? cur.id_str : prev, since_id),
      })
    }
  } catch (e) {
    console.log(e)
  }
}

const formatMessage = async (tweet) => {
  const id = tweet.retweeted_status ? tweet.retweeted_status.id_str : tweet.id_str
  const name = tweet.retweeted_status ? tweet.retweeted_status.user.screen_name : tweet.user.screen_name

  const text = tweet.retweeted_status ? `RT @ ${name}: ${tweet.retweeted_status.full_text ? tweet.retweeted_status.full_text : tweet.retweeted_status.text}` : tweet.full_text ? tweet.full_text : tweet.text

  const content = `${unescape(text)} | <https://twitter.com/${name}/status/${id}>`
  const username = tweet.user.name
  const avatar_url = tweet.user.profile_image_url

  return { content, username, avatar_url }

}

module.exports = { main }