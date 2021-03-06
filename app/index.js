// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  var async, fs, gm, path, thumbnail, _;

  fs = require('fs');

  path = require('path');

  gm = require('gm');

  async = require('async');

  _ = require('lodash');

  thumbnail = (function() {
    var option;

    option = {
      source: null,
      destination: null,
      unlink: true,
      deleteSource: false,
      thumbnails: []
    };

    function thumbnail(data) {
      this.data = data;
      this.data = _.merge(option, this.data);
    }

    thumbnail.prototype.run = function(callback) {
      var data;
      data = this.data;
      return async.series([
        function(cb) {
          if (fs.existsSync(data.source)) {
            return cb(null);
          } else {
            return cb(new Error('Can not find image source'));
          }
        }, function(cb) {
          if (fs.existsSync(data.destination)) {
            return cb(null);
          } else {
            return cb(new Error('Not have folder for destination'));
          }
        }, function(cb) {
          return async.concat(data.thumbnails, function(row, cb2) {
            var _path;
            if (row.resize === false) {
              _path = path.join(data.destination, row.name);
              fs.readFile(data.source, function(err, data) {
                return fs.writeFile(_path, data, function(err) {
                  if (err) {
                    return cb2(err);
                  } else {
                    return cb2(null);
                  }
                });
              });
            }
            if (row.resize === true) {
              _path = path.join(data.destination, row.name);
              if (row.thumbnail === true) {
                return gm(data.source).thumb(row.width, row.height, _path, 95, function(err) {
                  if (err) {
                    cb(err);
                  }
                  return cb(null);
                });
              } else {
                return gm(data.source).resize(row.width, row.height, "!").autoOrient().write(_path, function(err) {
                  if (err) {
                    return cb2(err);
                  } else {
                    return cb2(null);
                  }
                });
              }
            }
          }, function(err) {
            if (err) {
              return cb(err);
            } else {
              return cb(null);
            }
          });
        }, function(cb) {
          if (data.deleteSource === true) {
            return fs.unlink(data.source, cb);
          } else {
            return cb(null);
          }
        }
      ], function(err) {
        if (err) {
          return callback(err);
        } else {
          return callback(null);
        }
      });
    };

    return thumbnail;

  })();

  module.exports = thumbnail;

}).call(this);
