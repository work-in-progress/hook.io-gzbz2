main = require '../lib/index'

module.exports = 
  hook: null
  currentCb : null
  eatMe : 0
  sourceText : "Hello world, foo bar!"

  uncompressed : "afile.txt"
  compressedGzip : "afile.txt.gz"
  compressedBz2 : "afile.txt.bz2"
    
  setup: (cb) ->
    @hook = new main.Gzbz2(name: 'gzbz2')
    @hook.onAny (data) =>
      if @callback
        if @eatMe == 0
          @callback null,@hook.event, data
          @callback = null
        @eatMe = @eatMe - 1  
      
    @hook.start()
    cb null,@hook
    
  fixturePath: (fileName) ->
    "#{__dirname}/fixtures/#{fileName}"

  tmpPath: (fileName) ->
    "#{__dirname}/../tmp/#{fileName}"
  
  # Invoke this in your topic and pass your callback.
  # The cb will be called with: null,event,data
  # we passing null for err as the first parameter to stay true to node.js
  # HookMeUp always eats the first message.
  hookMeUp: (cb) ->
    @currentCb = cb
    @eatMe = 0
