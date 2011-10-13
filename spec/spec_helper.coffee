main = require '../lib/index'

module.exports = 
  hook: null
  
  sourceText : "Hello world, foo bar!"

  uncompressed : "afile.txt"
  compressedGzip : "afile.txt.gz"
  compressedBz2 : "afile.txt.bz2"
    
  setup: (cb) ->
    @hook = new main.Gzbz2(name: 'gzbz2')

    @hook.start()
    cb null,@hook
    
  fixturePath: (fileName) ->
    "#{__dirname}/fixtures/#{fileName}"

  tmpPath: (fileName) ->
    "#{__dirname}/../tmp/#{fileName}"
    
