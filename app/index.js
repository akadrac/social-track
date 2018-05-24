'use strict'
console.log('Loading function')

const social = require('./social')

exports.handler = (event, context, callback) => {
  social.main(event, callback);
}
