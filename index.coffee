module = require 'module'
path = require 'path'

# Determine which entry in Module._extensions we should use for a given file
findExtension = (filename) ->
  extension = null
  extensions = path.basename(filename).split '.'

  # Remove initial dot from dotfiles
  extensions.shift() if extensions[0] is ''

  # Start with the longest extension and work our way shortwards
  while extensions.shift()
    thisExtension = '.' + extensions.join '.'
    if module._extensions[thisExtension]
      extension = thisExtension
      break

  return extension || '.js'

module.prototype.load = (filename) ->
  @filename = filename
  @paths = module._nodeModulePaths(path.dirname(filename))

  extension = findExtension(filename)
  module._extensions[extension](this, filename)
  @loaded = true
