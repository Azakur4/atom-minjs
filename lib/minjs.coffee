minjs = require 'uglify-js'
fs = require 'fs'

compile = () ->
  editor = atom.workspace.getEditor()

  if editor
    path = editor.getPath()

    if path.indexOf('.js') == path.length - 3 and path.indexOf('.min.js') < 0
      result = minjs.minify(editor.getText(), {fromString: true});
      new_name = path.replace('.js', '.min.js')

      fs.writeFile(new_name, result.code, (err) ->
          if err
            console.log("Couldn't minify js file!")
      )

module.exports =
  activate: (state) =>
    atom.workspaceView.command "core:save", => compile()
    atom.workspaceView.command "minjs:compile", => compile()
