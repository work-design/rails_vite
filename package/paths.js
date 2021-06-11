const { basename, dirname, join, relative, resolve } = require('path')
const { sync: globSync } = require('glob')
const extname = require('path-complete-extname')

const getEntryObject = (rootPath) => {
  const entries = {}

  globSync(`${rootPath}/**/*.+(js|css|scss)`).forEach((path) => {
    const namespace = relative(join(rootPath), dirname(path))
    const name = join(namespace, basename(path, extname(path)))
    let assetPaths = resolve(path)

    let previousPaths = entries[name]
    if (previousPaths) {
      previousPaths = Array.isArray(previousPaths) ? previousPaths : [previousPaths]
      previousPaths.push(assetPaths)
      assetPaths = previousPaths
    }

    entries[name] = assetPaths
  })

  return entries
}

module.exports = getEntryObject
