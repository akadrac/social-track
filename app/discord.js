'use strict'

const request = require('request')

const post = ({ content, username, avatar_url, webhook }) => new Promise((resolve, reject) => {
  console.log(`postToDiscord: ${username}`)

  const message = {
    content,
    username,
    avatar_url
  }

  const options = {
    url: webhook,
    method: 'POST',
    json: message
  }

  request(options, (err, res, body) => err ? reject(err) : resolve(res.statusCode))
})

module.exports = { post }