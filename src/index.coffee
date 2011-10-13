Hook = require('hook.io').Hook
util = require 'util'
colors = require 'colors'
path = require 'path'
#gzbz2 = require 'gzbz2'
#sys = require 'sys'
fs = require "fs"
spawn = require("child_process").spawn

require('pkginfo')(module,'version','hook')
  
Gzbz2 = exports.Gzbz2 = (options) ->
  self = @
  Hook.call self, options
  
  self.on "hook::ready", ->  
  
    self.on "gzbz2::compress", (data)->
      self._compress(data)

    self.on "gzbz2::uncompress", (data)->
      self._uncompress(data)
      
    for compress in (self.compresss || [])
      self.emit "gzbz2::compress",
        source : compress.source
        target : compress.target
        mode : compress.mode

    for uncompress in (self.uncompresss || [])
      self.emit "gzbz2::uncompress",
        source : uncompress.source
        target : uncompress.target
    
util.inherits Gzbz2, Hook

Gzbz2.prototype._runCommand = (cmd,args,eventName,data) ->
  fd = fs.openSync data.target, "w", 0644

  zip = spawn(cmd,args)

  zip.stdout.on "data", (data) =>
    fs.writeSync fd, data, 0, data.length, null

  zip.stderr.on "data", (data) =>
    console.log "ERROR: #{data}"
  
  zip.on "exit", (code) =>
    fs.closeSync fd

    #console.log "EXIT #{code}"
    if code != 0  
     try
        fs.unlinkSync data.target  # cleanup
      catch ignore
      
      @emit "gzbz2::error", 
        source: data.source
        target: data.target
        mode: data.mode
        code: code
    else    
      @emit eventName, 
        source: data.source
        target: data.target
        mode: data.mode

Gzbz2.prototype._compress = (data) ->
  console.log "Compressing #{data.source} to #{data.target}".cyan

  data.mode = 'gzip' unless data.mode == 'bzip2'
  
  if data.target
    data.target = path.normalize data.target
    if data.mode == 'gzip'
      @_runCommand "gzip",[ "-c", data.source ],"gzbz2::compress-complete",data
    else
      @_runCommand "bzip2",[ "-c", data.source ],"gzbz2::compress-complete",data    
  else
    # NOT SUPPORTED YET
  
  
  ###


  xx = fs.readFileSync data.source,"utf-8"
  console.log "Read: #{xx.length}"

  fd = fs.openSync data.target, "w", 0644
  
  gzip = new gzbz2.Gzip
  # init also accepts level: [0-9]
  gzip.init 

  gzdata = gzip.deflate xx
  fs.writeSync fd, gzdata, 0, gzdata.length, null

  # Get the last bit
  gzlast = gzip.end()
  console.log "Compressed chunk size #{gzlast.length}"
  fs.writeSync fd, gzlast, 0, gzlast.length, null
  fs.closeSync fd
###

      

  
###
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
###

Gzbz2.prototype._uncompress = (data) ->
  console.log "Uncompress for #{data.source}".cyan
  @emit "gzbz2::uncompress-complete", {}
  
###  
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
###    