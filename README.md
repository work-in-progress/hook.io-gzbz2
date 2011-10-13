## About hook.io-gzbz2

A hook to compress and uncompress files. Operates synchronously for now

NOTE: Pull request making this asynchronous are very welcome as long as they work with huge (2+ gigabyte compressed) files.

![Gzbz2 Icon](http://github.com/scottyapp/hook.io-gzbz2/raw/master/assets/gzbz2114x114.png)

[![Build Status](https://secure.travis-ci.org/scottyapp/hook.io-gzbz2.png)](http://travis-ci.org/scottyapp/hook.io-gzbz2.png)


## Install

npm install -g hook.io-gzbz2

## Usage

	./bin/hookio-gzbz2 

This starts a hook and reads the local config.json. The files listed there will be compressed or uncompressed. A sample is provided in examples/example-config.json. The config
option is included for debugging and testing purposes, in general you will want to use messages and code.

### Messages

gzbz2::compress [in]

	source: the source file name. Required. This is the file that will be compressed.
	target: the target file name. Required.
	mode: 'gzip' or 'bzip2', defaults to 'gzip'

gzbz2::uncompress [in]

	source: the source file name. Required. This is the file that will be uncompressed.
	target: the target file name. Required.

gzbz2::error [out]

	code: code
	source:
	target:
	mode:

gzbz2::compress-complete [out]

	code: code
	source:
	target:
	mode:

gzbz2::uncompress-complete [out]

target : The target file name.

### Hook.io Schema support 

The package config contains experimental hook.io schema definitions. The definition is also exported as hook. Signatures will be served from a signature server (more to come).

### Coffeescript

	Gzbz2 = require("hook.io-gzbz2").Gzbz2
	hook = new Gzbz2(name: 'gzbz2')
 
### Javascript

	var Gzbz2 = require("hook.io-gzbz2").Gzbz2;
	var hook = new Gzbz2({ name: 'gzbz2' });

## Advertising :)

Check out http://freshfugu.com and http://scottyapp.com

Follow us on Twitter at @getscottyapp and @freshfugu and like us on Facebook please. Every mention is welcome and we follow back.

## Trivia

Listened to lots of M.I.A. and Soundgarden while writing this.

## Release Notes

### 0.0.1

* First version

## Internal Stuff

* npm run-script watch

# Publish new version

* Change version in package.json
* git tag -a v0.0.6 -m 'version 0.0.6'
* git push --tags
* npm publish

## Contributing to hook.io-gzbz2
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the package.json, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Martin Wawrusch. See LICENSE for
further details.


