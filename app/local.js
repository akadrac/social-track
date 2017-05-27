// run this to test it locally
const social = require('./social');

social.main(null, (err, result) => {
  err ? console.log('err', err) : console.log(result)
});