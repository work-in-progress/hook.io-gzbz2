(function() {
  var Gzbz2, Hook, colors, fs, path, spawn, util;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Hook = require('hook.io').Hook;
  util = require('util');
  colors = require('colors');
  path = require('path');
  fs = require("fs");
  spawn = require("child_process").spawn;
  require('pkginfo')(module, 'version', 'hook');
  Gzbz2 = exports.Gzbz2 = function(options) {
    var self;
    self = this;
    Hook.call(self, options);
    return self.on("hook::ready", function() {
      var compress, uncompress, _i, _j, _len, _len2, _ref, _ref2, _results;
      self.on("gzbz2::compress", function(data) {
        return self._compress(data);
      });
      self.on("gzbz2::uncompress", function(data) {
        return self._uncompress(data);
      });
      _ref = self.compresss || [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        compress = _ref[_i];
        self.emit("gzbz2::compress", {
          source: compress.source,
          target: compress.target,
          mode: compress.mode
        });
      }
      _ref2 = self.uncompresss || [];
      _results = [];
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        uncompress = _ref2[_j];
        _results.push(self.emit("gzbz2::uncompress", {
          source: uncompress.source,
          target: uncompress.target
        }));
      }
      return _results;
    });
  };
  util.inherits(Gzbz2, Hook);
  Gzbz2.prototype._runCommand = function(cmd, args, eventName, data) {
    var fd, zip;
    fd = fs.openSync(data.target, "w", 0644);
    zip = spawn(cmd, args);
    zip.stdout.on("data", __bind(function(data) {
      return fs.writeSync(fd, data, 0, data.length, null);
    }, this));
    zip.stderr.on("data", __bind(function(data) {
      return console.log("ERROR: " + data);
    }, this));
    return zip.on("exit", __bind(function(code) {
      fs.closeSync(fd);
      if (code !== 0) {
        try {
          fs.unlinkSync(data.target);
        } catch (ignore) {

        }
        return this.emit("gzbz2::error", {
          source: data.source,
          target: data.target,
          mode: data.mode,
          code: code
        });
      } else {
        return this.emit(eventName, {
          source: data.source,
          target: data.target,
          mode: data.mode
        });
      }
    }, this));
  };
  Gzbz2.prototype._compress = function(data) {
    console.log(("Compressing " + data.source + " to " + data.target).cyan);
    if (data.mode !== 'bzip2') {
      data.mode = 'gzip';
    }
    data.target = path.normalize(data.target);
    if (data.mode === 'gzip') {
      return this._runCommand("gzip", ["-c", data.source], "gzbz2::compress-complete", data);
    } else {
      return this._runCommand("bzip2", ["-c", data.source], "gzbz2::compress-complete", data);
    }
  };
  Gzbz2.prototype._uncompress = function(data) {
    console.log(("Uncompress for " + data.source).cyan);
    if (data.mode !== 'bzip2') {
      data.mode = 'gzip';
    }
    data.target = path.normalize(data.target);
    if (data.mode === 'gzip') {
      return this._runCommand("gunzip", ["-c", data.source], "gzbz2::uncompress-complete", data);
    } else {
      return this._runCommand("bzip2", ["-dc", data.source], "gzbz2::uncompress-complete", data);
    }
  };
}).call(this);
