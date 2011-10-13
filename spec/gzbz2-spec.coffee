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
        specHelper.hook.on "gzbz2::compress-complete", (data) =>
          @callback(null,data)
        specHelper.hook.emit "gzbz2::compress",
          source : specHelper.fixturePath(specHelper.uncompressed)
          target : specHelper.tmpPath("test1.gz")
          mode : 'gzip'
        return
      "THEN it must not fail": (err,data) ->
        assert.isNull err
  .export module
