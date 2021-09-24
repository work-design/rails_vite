const { basename, dirname, join, relative, resolve } = require('path')
const { sync: globSync } = require('glob')
const extname = require('path-complete-extname')

const getEntryObject = (rootPath) => {
  const entries = {}

  globSync(`${rootPath}/**/*.+(js|ts)`).forEach((path) => {
    const namespace = relative(join(rootPath), dirname(path))
    const name = join(namespace, basename(path, extname(path)))

    entries[name] = resolve(path)
  })

  return entries
}

module.exports = getEntryObject
