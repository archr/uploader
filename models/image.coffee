mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = ->
  ImageSchema = new Schema
    name: {type: String}
    sync: {type: Boolean, default: false}

  ImageSchema.statics.isSync = (name, callback) ->
    @find {name:name}, (err, foundImage) ->
      return callback(err) if err

      if not foundImage or not foundImage.sync
        return callback(null, false)

      callback(null, true)

  mongoose.model 'Image', ImageSchema

