// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  var Thumbnail, async, fs, glob, gm, path, should;

  Thumbnail = require('./');

  should = require('should');

  path = require('path');

  fs = require('fs');

  async = require('async');

  glob = require('glob');

  gm = require('gm');

  describe('Thumbnail', function() {
    beforeEach(function(done) {
      var folder;
      folder = path.join('asserts', 'destination', '*.jpeg');
      return glob(folder, function(err, file) {
        if (err) {
          done(err);
        }
        if (file && file.length === 0) {
          done();
        }
        return file.forEach(function(f, i) {
          fs.unlink(f);
          if (i === (file.length - 1)) {
            return done();
          }
        });
      });
    });
    it('should it work', function() {
      true.should.be.a["true"];
      return false.should.not.be["true"];
    });
    it('should have err', function(done) {
      var thumbnail;
      thumbnail = new Thumbnail();
      thumbnail.run(function(err) {
        should.exist(err);
        return err.should.an.match(/Can not find image source/i);
      });
      thumbnail.data.source = path.join('asserts', 'source', 'home_image.jpg');
      return thumbnail.run(function(err) {
        should.exist(err);
        err.should.an.match(/Not have folder for destination/i);
        return done();
      });
    });
    it('should not have err', function() {
      var thumbnail;
      thumbnail = new Thumbnail({
        source: path.join('asserts', 'source', 'home_image.jpg'),
        destination: path.join('asserts', 'destination')
      });
      return thumbnail.run(function(err) {
        return should.not.exist(err);
      });
    });
    it('copy origin to ', function(done) {
      var data, thumbnail;
      data = {
        source: path.join('asserts', 'source', 'home_image.jpg'),
        destination: path.join('asserts', 'destination'),
        thumbnails: [
          {
            name: 'xxxx.jpeg',
            resize: false
          }
        ]
      };
      thumbnail = new Thumbnail(data);
      return thumbnail.run(function(err) {
        var _path_image;
        should.not.exist(err);
        _path_image = path.join(data.destination, data.thumbnails[0].name);
        (fs.existsSync(_path_image)).should.be["true"];
        return done();
      });
    });
    it('resize image with width = 150px should be work', function(done) {
      var data, thumbnail;
      data = {
        source: path.join('asserts', 'source', 'home_image.jpg'),
        destination: path.join('asserts', 'destination'),
        thumbnails: [
          {
            name: 'width.jpeg',
            resize: true,
            width: 150,
            thumbnail: false
          }
        ]
      };
      thumbnail = new Thumbnail(data);
      return thumbnail.run(function(err) {
        var _path_image;
        should.not.exist(err);
        _path_image = path.join(data.destination, data.thumbnails[0].name);
        (fs.existsSync(_path_image)).should.be["true"];
        return gm(_path_image).size(function(err, value) {
          should.not.exist(err);
          value.should.be.instanceOf(Object);
          value.width.should.be.match(/150px/i);
          return done();
        });
      });
    });
    it('resize image with height = 150px should be ok', function(done) {
      var data, thumbnail;
      data = {
        source: path.join('asserts', 'source', 'home_image.jpg'),
        destination: path.join('asserts', 'destination'),
        thumbnails: [
          {
            name: 'height.jpeg',
            resize: true,
            height: 150,
            thumbnail: false
          }
        ]
      };
      thumbnail = new Thumbnail(data);
      return thumbnail.run(function(err) {
        var _path_image;
        should.not.exist(err);
        _path_image = path.join(data.destination, data.thumbnails[0].name);
        (fs.existsSync(_path_image)).should.be["true"];
        return gm(_path_image).size(function(err, value) {
          should.not.exist(err);
          value.should.be.instanceOf(Object);
          value.height.should.be.match(/150px/i);
          return done();
        });
      });
    });
    it('resize image to thumbnail should be ok', function(done) {
      var data, thumbnail;
      data = {
        source: path.join('asserts', 'source', 'home_image.jpg'),
        destination: path.join('asserts', 'destination'),
        thumbnails: [
          {
            name: 'height.jpeg',
            resize: true,
            height: 150,
            width: 150,
            thumbnail: true
          }
        ]
      };
      thumbnail = new Thumbnail(data);
      return thumbnail.run(function(err) {
        var _path_image;
        should.not.exist(err);
        _path_image = path.join(data.destination, data.thumbnails[0].name);
        (fs.existsSync(_path_image)).should.be["true"];
        return gm(_path_image).size(function(err, value) {
          should.not.exist(err);
          value.should.be.instanceOf(Object);
          value.height.should.be.match(/150px/i);
          value.width.should.be.match(/150px/i);
          return done();
        });
      });
    });
    it('unlink source should be remove', function(done) {
      var data;
      data = {
        source: path.join('asserts', 'source', 'home_image.jpg'),
        destination: path.join('asserts', 'destination'),
        deleteSource: true,
        thumbnails: [
          {
            name: 'unlink.jpeg',
            resize: true,
            width: 150,
            height: 100
          }
        ]
      };
      return async.waterfall([
        function(cb) {
          var _path;
          _path = path.join('asserts', 'source', 'unlink_image.jpg');
          return fs.readFile(data.source, function(err, data) {
            return fs.writeFile(_path, data, function(err) {
              if (err) {
                return cb(err);
              } else {
                return cb(null, _path);
              }
            });
          });
        }, function(source, cb) {
          var thumbnail;
          data.source = source;
          thumbnail = new Thumbnail(data);
          return thumbnail.run(function(err) {
            should.not.exist(err);
            (fs.existsSync(data.source)).should.be["false"];
            return cb(null);
          });
        }
      ], function(err) {
        return done();
      });
    });
    return it('resize thumbnail multi params should be ok', function(done) {
      var data, thumbnail;
      data = {
        source: path.join('asserts', 'source', 'home_image.jpg'),
        destination: path.join('asserts', 'destination'),
        deleteSource: false,
        thumbnails: [
          {
            name: 'height.jpg',
            resize: true,
            height: 150,
            thumbnail: false
          }, {
            name: 'origin.jpg',
            resize: false
          }, {
            name: 'thumbnail.jpg',
            resize: true,
            height: 150,
            width: 150,
            thumbnail: true
          }
        ]
      };
      thumbnail = new Thumbnail(data);
      return thumbnail.run(function(err) {
        should.not.exist(err);
        return async.concatSeries(data.thumbnails, function(row, cb) {
          var _path_image;
          _path_image = path.join(data.destination, row.name);
          (fs.existsSync(_path_image)).should.be["true"];
          return cb(null);
        }, function() {
          return done();
        });
      });
    });
  });

}).call(this);
