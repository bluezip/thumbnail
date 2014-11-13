'use strict'

Thumbnail     = require './'
should        = require 'should'
path          = require 'path'
fs            = require 'fs'
async         = require 'async'
glob          = require 'glob'
gm            = require 'gm'

describe 'Thumbnail', ->

  ## before each
  beforeEach (done)->
    folder  = path.join 'asserts','destination','*.jpeg'
    glob folder, (err, file)->
      if err then done(err);

      done() if file && file.length == 0

      file.forEach (f, i)->
        fs.unlink f

        if i == (file.length - 1)
          done()


  it 'should it work', ->
    true.should.be.a.true;
    false.should.not.be.true


  it 'should have err', (done)->

    thumbnail   = new Thumbnail();

    thumbnail.run (err)->
      should.exist err
      err.should.an.match  /Can not find image source/i

    thumbnail.data.source = path.join 'asserts', 'source',  'home_image.jpg'


    thumbnail.run (err)->
      should.exist err
      err.should.an.match /Not have folder for destination/i

      done();

  it 'should not have err', ->

    thumbnail   = new Thumbnail({
      source : path.join 'asserts', 'source',  'home_image.jpg'
      destination: path.join 'asserts', 'destination'
    });

    thumbnail.run (err)->
      should.not.exist err


  it 'copy origin to ', (done)->

    data  =
      source : path.join 'asserts', 'source',  'home_image.jpg'
      destination: path.join 'asserts', 'destination'
      thumbnails: [
        { name: 'xxxx.jpeg', resize: false }
      ]


    thumbnail   = new Thumbnail data

    thumbnail.run (err)->
      should.not.exist err
      _path_image   = path.join data.destination, data.thumbnails[0].name
      (fs.existsSync _path_image).should.be.true

      done()



  it 'resize image with width = 150px should be work', (done)->
    data  =
      source : path.join 'asserts', 'source',  'home_image.jpg'
      destination: path.join 'asserts', 'destination'
      thumbnails: [
        {name: 'width.jpeg', resize: true, width: 150, thumbnail: false}
      ]


    thumbnail   = new Thumbnail data

    thumbnail.run (err)->
      should.not.exist err
      _path_image   = path.join data.destination, data.thumbnails[0].name
      (fs.existsSync _path_image).should.be.true
      gm(_path_image).size (err,value)->
        should.not.exist err
        value.should.be.instanceOf(Object)
        value.width.should.be.match /150px/i
        done()

  it 'resize image with height = 150px should be ok', (done)->
    data  =
      source : path.join 'asserts', 'source',  'home_image.jpg'
      destination: path.join 'asserts', 'destination'
      thumbnails: [
        {name: 'height.jpeg', resize: true, height: 150, thumbnail: false}
      ]


    thumbnail   = new Thumbnail data

    thumbnail.run (err)->
      should.not.exist err
      _path_image   = path.join data.destination, data.thumbnails[0].name
      (fs.existsSync _path_image).should.be.true
      gm(_path_image).size (err,value)->
        should.not.exist err
        value.should.be.instanceOf(Object)
        value.height.should.be.match /150px/i
        done()

  it 'resize image to thumbnail should be ok', (done)->
    data  =
      source : path.join 'asserts', 'source',  'home_image.jpg'
      destination: path.join 'asserts', 'destination'
      thumbnails: [
        {name: 'height.jpeg', resize: true, height: 150, width: 150, thumbnail: true}
      ]


    thumbnail   = new Thumbnail data

    thumbnail.run (err)->
      should.not.exist err
      _path_image   = path.join data.destination, data.thumbnails[0].name
      (fs.existsSync _path_image).should.be.true
      gm(_path_image).size (err,value)->
        should.not.exist err
        value.should.be.instanceOf(Object)
        value.height.should.be.match /150px/i
        value.width.should.be.match /150px/i
        done()




  it 'unlink source should be remove', (done)->

    data  =
      source : path.join 'asserts', 'source',  'home_image.jpg'
      destination: path.join 'asserts', 'destination'
      deleteSource: true
      thumbnails: [
        {name: 'unlink.jpeg', resize: true, width: 150, height: 100}
      ]


    async.waterfall [

      (cb)->
        _path   = path.join 'asserts', 'source', 'unlink_image.jpg'
        fs.readFile data.source, (err,data) ->
          fs.writeFile _path,data,(err)->
            if err then cb err else cb null, _path


      (source ,cb)->

        data.source = source

        thumbnail   = new Thumbnail data

        thumbnail.run (err)->
          should.not.exist err
          (fs.existsSync data.source).should.be.false
          cb(null)


    ], (err)->

      done();



  it 'resize thumbnail multi params should be ok', (done)->

    data  =
      source : path.join 'asserts', 'source',  'home_image.jpg'
      destination: path.join 'asserts', 'destination'
      deleteSource: false
      thumbnails: [
        { name: 'height.jpg', resize: true, height: 150 ,thumbnail: false},
        { name: 'origin.jpg', resize: false},
        { name: 'thumbnail.jpg', resize: true, height: 150, width: 150, thumbnail: true},
      ]


    thumbnail   = new Thumbnail data

    thumbnail.run (err)->

      should.not.exist err

      async.concatSeries data.thumbnails

        ,(row, cb)->
          _path_image   = path.join data.destination, row.name
          (fs.existsSync(_path_image)).should.be.true
          cb(null);

        , ->
         done()
