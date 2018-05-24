'use strict'

const request = require('request')

const post = (content, username, avatar_url) => new Promise((resolve, reject) => {
  console.log('postToDiscord')

  let message = {
    content,
    username,
    avatar_url
  }

  let options = {
    url: process.env.webhook,
    method: 'POST',
    json: message
  }

  request(options, (err, res, body) => {
    if (err) {
      reject(err)
    } else {
      resolve(res.statusCode)
    }
  })
})

module.exports = { post }