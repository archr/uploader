_ = require 'underscore'
fs = require 'fs'
mime = require 'mime'

exports.images = (directory)->
  files = fs.readdirSync(directory)

  _.filter files, (file) ->
    typeFile = mime.lookup(file)
    typeFile is 'image/png' or typeFile is 'image/jpeg'