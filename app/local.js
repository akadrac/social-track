'use strict'

require('dotenv').config()

// run this to test it locally
const social = require('./social')

try {
  social.main(null, (err, result) => err ? console.log('err', err) : console.log(result))
}
catch (e) {
  console.log(e)
}
