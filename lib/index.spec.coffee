'use strict'

Thumbnail     = require './'
should        = require 'should'
path          = require 'path'
fs            = require 'fs'
async         = require 'async'
glob          = require 'glob'

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


  it 'should it ok', ->
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



  it 'resize image automatic should be work', (done)->
    data  =
      source : path.join 'asserts', 'source',  'home_image.jpg'
      destination: path.join 'asserts', 'destination'
      thumbnails: [
        {name: 'xxxx2.jpeg', resize: true, width: 150}
      ]


    thumbnail   = new Thumbnail data

    thumbnail.run (err)->
      should.not.exist err
      _path_image   = path.join data.destination, data.thumbnails[0].name
      (fs.existsSync _path_image).should.be.true

      done()


  it 'unlink source should be remove', (done)->

    data  =
      source : path.join 'asserts', 'source',  'home_image.jpg'
      destination: path.join 'asserts', 'destination'
      deleteSource: true
      thumbnails: [
        {name: 'xxxx2.jpeg', resize: true, width: 150}
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





