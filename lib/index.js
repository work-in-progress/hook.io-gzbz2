(function() {
  var Gzbz2, Hook, colors, gzbz2, url, util;
  Hook = require('hook.io').Hook;
  util = require('util');
  colors = require('colors');
  gzbz2 = require('gzbz2');
  url = require('url');
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
  /*
  Gzbz2.prototype._buildRequestOptions = (data) ->
    options =
      url : data.source
  
    # Need to check if the extence op is really necessary. 
    options.uncompressers = if data.uncompressers? data.uncompressers else {}
    options.nogzip = data.nogzip if data.nogzip?
    options.proxy = data.proxy if data.proxy?
    options.redirects = data.redirects if data.redirects?
    
    # Hardcore auth fix
    parsed = url.parse(data.source)
    if parsed.auth
      auth64 = new Buffer("#{parsed.auth}","utf8").toString('base64')  
      options.uncompressers['Authorization'] = "Basic #{auth64}"
  
      options.source = url.format
        protocol : parsed.protocol
        hostname :parsed.hostname
        port : parsed.port
        pathname :parsed.pathname
        search :parsed.search
        fragment :parsed.fragment
        
      #console.log "PARSED #{options.source}"
    
    options
  */
  Gzbz2.prototype._compress = function(data) {
    console.log(("Compressing " + data.source + " to " + data.target).cyan);
    return this.emit("gzbz2::compress-complete", {});
  };
  /*
    options = @_buildRequestOptions data
    console.log options
    
    httpget.get options ,data.target, (err,result) =>
      if err
        console.error err
        @emit "gzbz2::error", 
          error : err
          uncompress : false
      else
        console.log result
        @emit "gzbz2::compress-complete", 
          code : result.code
          pathToFile : if result.file? then result.file else null
          #buffer : if result.buffer? result.buffer else null
          uncompressers : result.uncompressers
          requestedUrl : data.source
          result : result
  */
  Gzbz2.prototype._uncompress = function(data) {
    console.log(("Uncompress for " + data.source).cyan);
    return this.emit("gzbz2::uncompress-complete", {});
  };
  /*  
    options = @_buildRequestOptions data
    console.log options
    
    httpget.uncompress options , (err,result) =>
      if err
        console.error err
        @emit "gzbz2::error", 
          error : err
          uncompress : true
      else
        console.log result
        @emit "gzbz2::uncompress-complete", 
          code : result.code
          uncompressers : result.uncompressers
          requestedUrl : data.source
          compressedUrl : if result.source? then result.source else data.source 
          result : result
  */
}).call(this);
