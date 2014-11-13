'use strict'

fs        = require 'fs'
path      = require 'path'
gm        = require 'gm'
async     = require 'async'
_         = require 'lodash'


class thumbnail

  option =
    source : null
    destination: null
    unlink: true
    deleteSource: false
    thumbnails: [ ]



  constructor : (@data)->
    @data = _.merge option, @data




  run: (callback)->

    data  = @data

    async.series [

      (cb)->
        if fs.existsSync data.source
          cb(null)
        else
          cb(new Error('Can not find image source'));


      (cb) ->
        if fs.existsSync data.destination
          cb null
        else
          cb new Error 'Not have folder for destination'



      (cb) ->

        async.concat data.thumbnails,

          (row,cb2)->


            if row.resize == false
              _path   = path.join data.destination, row.name

              fs.readFile data.source, (err,data) ->
                fs.writeFile _path,data,(err)->
                  if err then cb2 err else cb2 null

            if row.resize == true
              _path   = path.join data.destination, row.name


              if row.thumbnail == true

                gm(data.source)
                .thumb row.width, row.height, _path, 95, (err)->
                  cb(err) if err
                  cb(null)
              else

                gm(data.source)
                .resize(row.width, row.height, "!")
                .autoOrient()
                .write _path, (err)->
                  if err then cb2 err else cb2 null

          ,(err)->
            if err then cb(err)
            else cb(null)


      # unlink source
      (cb) ->
        if data.deleteSource   == true

          fs.unlink(data.source,cb);

        else cb null



    ], (err)->
      if err then callback err
      else callback null



module.exports = thumbnail
