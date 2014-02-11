async = require 'async'
mongoose = require 'mongoose'
config = require './config.json'
Image = require('./models/image')()
list = require './lib/list'
request = require './lib/request'

mongoose.connect config.db

syncImages = []
localImages = list.images(config.directory)


isSyncImage = (image, done)->
  Image.isSync image, (err, sync) ->
    unless sync
      syncImages.push(image)
    done(err)


uploadImage = (image, done) ->
  request.send "#{config.directory}/#{image}", config.url, (err, res) ->
    return done(err) if err

    console.log res.body
    done()


async.waterfall [
  (done) ->
    async.each localImages, isSyncImage, done
  (done) ->
    async.each syncImages, uploadImage, done
], (err) ->
  console.log err
  console.log syncImages