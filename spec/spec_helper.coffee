main = require '../lib/index'
fs = require "fs"

module.exports = 
  hook: null
  currentCb : null
  eatMe : 0
  sourceText : "Hello world, foo bar!"

  uncompressed : "afile.txt"
  compressedGzip : "afile.txt.gz"
  compressedBz2 : "afile.txt.bz2"
    
  setup: (cb) ->
    @createTemp()
    @hook = new main.Gzbz2(name: 'gzbz2')
    @hook.onAny (data) =>
      console.log "ANY #{@hook.event} EatMe: #{@eatMe} HasCurrentCb: #{@currentCb != null}"
      if @currentCb
        if @eatMe == 0
          @currentCb null,@hook.event, data
          @currentCb = null
        @eatMe = @eatMe - 1  
      
    @hook.start()
    cb null,@hook
    
  createTemp: ->
    try
      fs.mkdirSync "#{__dirname}/../tmp/",0755
    catch ignore
      console.log "Failed to create tmp folder #{ignore}"
    
  fixturePath: (fileName) ->
    "#{__dirname}/fixtures/#{fileName}"

  tmpPath: (fileName) ->
    "#{__dirname}/../tmp/#{fileName}"
  
  cleanTmpFiles: (fileNames) ->
    @createTemp()
    for file in fileNames
      try
        fs.unlinkSync @tmpPath(file)
      catch ignore
    
  # Invoke this in your topic and pass your callback.
  # The cb will be called with: null,event,data
  # we passing null for err as the first parameter to stay true to node.js
  # HookMeUp always eats the first message.
  hookMeUp: (cb) ->
    @currentCb = cb
    @eatMe = 1
