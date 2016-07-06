'use strict'

path = require 'path'
generator = require 'loopback-angular-sdk'

module.exports = (grunt) ->

  runTask = ->
    options = @options
      name: 'loopback.sdk'
      apiUrl: undefined

    appFile = options.input

    if !appFile
      grunt.fail.warn 'Missing mandatory option "input".'

    if !grunt.file.exists(appFile)
      grunt.fail.warn 'Input file ' + appFile + ' not found.'

    if !options.output
      grunt.fail.warn 'Missing mandatory option "output".'

    app = undefined

    try
      app = require(path.resolve(appFile))
      grunt.log.ok 'Loaded LoopBack app %j', appFile
    catch e
      err = new Error('Cannot load LoopBack app ' + appFile)
      err.origError = e
      grunt.fail.warn err

    options.apiUrl = options.apiUrl or app.get('restApiRoot') or '/api'

    grunt.log.writeln 'Generating %j for the API endpoint %j', options.ngModuleName, options.apiUrl

    script = generator app, options

    grunt.file.write options.output, script
    grunt.log.ok 'Generated Angular services file %j', options.output

    return

  grunt.registerMultiTask 'loopback', 'Grunt plugin for auto-generating Angular $resource services for LoopBack', runTask

  return
