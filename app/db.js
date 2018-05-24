'use strict'

const AWS = require('aws-sdk')
AWS.config = new AWS.Config()
AWS.config.update({ region: process.env.region ? process.env.region : 'ap-southeast-2' })

const documentClient = new AWS.DynamoDB.DocumentClient()

const getAccounts = () => new Promise((resolve, reject) => {
  console.log('getAccounts')
  let params = { TableName: process.env.table ? process.env.table : "social_track" }

  documentClient.scan(params, (err, data) => {
    if (err) {
      reject(err)
    } else {
      resolve(data.Items)
    }
  })
})

const putAccount = (screen_name, since_id, exclude_replies) => new Promise((resolve, reject) => {
  console.log('putAccount')
  let params = {
    Item: {
      screen_name,
      since_id,
      exclude_replies
    },
    TableName: process.env.table ? process.env.table : "social_track"
  }

  documentClient.put(params, (err, data) => {
    if (err) {
      reject(err)
    } else {
      resolve(data)
    }
  })
})

module.exports = { getAccounts, putAccount }