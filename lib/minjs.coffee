minjs = require 'uglify-js'
fs = require 'fs'

module.exports =
	compile: ->
		editor = atom.workspace.getActiveEditor()
		path = editor.getPath()

		if !path or path.match(/\.min\.(js|css)$/gi) or !path.match(/\.(js|css)$/gi)
			@status "File not minifiable."
			return

		status "Working..."

		if path.indexOf('.js') == path.length - 3 and path.indexOf('.min.js') < 0
			result = minjs.minify(editor.getText(), {fromString: true});
			new_name = path.replace('.js', '.min.js')
			fs.writeFile(new_name, result.code, (err) ->
				if err
					status "Couldn't minify .js file!"
				else
					status "Minification succeeded!"
			)
		return
	activate: ->
		atom.workspaceView.command "minjs:compile", => @compile()
		atom.workspaceView.command "core:save", =>
		if atom.config.get('minjs.minifyOnSave')
			@compile()
		return

	configDefaults:
		minifyOnSave: false

statusTimeout = null
status = (text) ->
	clearTimeout statusTimeout

	if atom.workspaceView.statusBar.find('.minjs-status').length
		atom.workspaceView.statusBar.find('.minjs-status').text text
	else
		atom.workspaceView.statusBar.appendRight('<span class="minjs-status inline-block">' + text + '</span>')

	statusTimeout = setTimeout ->
			atom.workspaceView.statusBar.find('.minjs-status').remove()
		, 3000
