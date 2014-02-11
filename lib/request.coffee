request = require 'superagent'

exports.send = (image, url, callback)->
  request
    .post(url)
    .attach("image", image)
    .end(callback)
