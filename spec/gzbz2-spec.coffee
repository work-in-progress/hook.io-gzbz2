vows = require 'vows'
assert = require 'assert'

main = require '../lib/index'
specHelper = require './spec_helper'

vows.describe("integration_task")
  .addBatch
    "SETUP HOOK" :
      topic: () -> 
        specHelper.setup @callback
        return
      "THEN IT SHOULD SET UP :)": () ->
        assert.isTrue true
  .addBatch 
    "WHEN gzipping a file": 
      topic:  () ->
        specHelper.hookMeUp @callback

        specHelper.hook.emit "gzbz2::compress",
          source : specHelper.fixturePath(specHelper.uncompressed)
          target : specHelper.tmpPath("test1.gz")
          mode : 'gzip'
        return
      "THEN it must be complete": (err,event,data) ->
        assert.equal event,"gzbz2::compress-complete" 
  .addBatch 
    "WHEN bzipping a file": 
      topic:  () ->
        specHelper.hookMeUp @callback
        specHelper.hook.emit "gzbz2::compress",
          source : specHelper.fixturePath(specHelper.uncompressed)
          target : specHelper.tmpPath("test2.bz2")
          mode : 'bzip2'
        return
      "THEN it must be complete": (err,event,data) ->
        assert.equal event,"gzbz2::compress-complete" 
  .addBatch 
    "WHEN gunzipping a file": 
      topic:  () ->
        specHelper.hookMeUp @callback
        specHelper.hook.emit "gzbz2::uncompress",
          source : specHelper.fixturePath(specHelper.uncompressed)
          target : specHelper.tmpPath("test3.txt")
          mode : 'gzip'
        return
      "THEN it must be complete": (err,event,data) ->
        assert.equal event,"gzbz2::uncompress-complete" 
  .addBatch 
    "WHEN bunzipping a file": 
      topic:  () ->
        specHelper.hookMeUp @callback
        specHelper.hook.on "gzbz2::uncompress-complete", (data) =>
          @callback(null,data)
        specHelper.hook.emit "gzbz2::uncompress",
          source : specHelper.fixturePath(specHelper.uncompressed)
          target : specHelper.tmpPath("test4.txt")
          mode : 'bzip2'
        return
      "THEN it must be complete": (err,event,data) ->
        assert.equal event,"gzbz2::uncompress-complete" 
  .export module
