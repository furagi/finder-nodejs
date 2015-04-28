fs = require 'fs'

{print} = require 'sys'
{spawn} = require 'child_process'


sbuild = (opt, src, out, callback) ->
	console.log src, out
	options = ['-c', '-o', out, src]
	if opt then options.unshift opt
	coffee = spawn 'coffee', options
	coffee.stderr.on 'data', (data) ->
		process.stderr.write data.toString()
	coffee.stdout.on 'data', (data) ->
		print data.toString()
	coffee.on 'exit', (code) ->
		callback?() if code is 0





task 'sbuild', 'Build app', ->
	paths = [{
			opt: '-b'
			src: './coffee'
			out: './'
		}
		# , {
		# 	opt: '-b'
		# 	src: './worker/coffee'
		# 	out: './worker/'
		# }
	]
	for i in [0...paths.length]
		sbuild paths[i].opt, paths[i].src, paths[i].out
		console.log 'created'
