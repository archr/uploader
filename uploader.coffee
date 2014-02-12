async = require 'async'
mongoose = require 'mongoose'
moment = require 'moment'
colors = require 'colors'
config = require './config.json'
Image = require('./models/image')()
list = require './lib/list'
request = require './lib/request'

mongoose.connect config.db

start = moment()

total = 0
counter = 0
syncImages = []
localImages = list.images(config.directory)


isSyncImage = (image, done)->
  Image.isSync image, (err, sync) ->
    unless sync
      syncImages.push(image)
    done(err)


uploadImage = (image, done) ->
  start = moment()
  request.send "#{config.directory}/#{image}", config.url, (err, res) ->
    if err
      console.log "uploadImage err: #{err.message}".red
      return done()
    end = moment()
    counter++
    console.log "#{counter}/#{total} #{end.diff(start, 'seconds')} seconds #{res.body.message} #{image} ".cyan

    data =
      sync: res.body.success
      message: res.body.message

    Image.update {name: image}, data, upsert:true, done


queue = async.queue uploadImage, 512
queue.drain = ->
  end = moment()
  console.log "All images have been sent #{end.diff(start, 'minutes')} minutes".green
  process.exit(0)


async.each localImages, isSyncImage, ->
  total = syncImages.length
  console.log "sync #{total} images".green

  queue.push syncImages, (err)->
    console.log "Err image #{err}" if err