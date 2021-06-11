/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const baseConfig = require('./base')
const config = require('../config')
const getEntryObject = require('../paths')
const { join } = require('path')

const getPlugins = () => {
  const plugins = []

  plugins.push()

  return plugins
}

const paths = () => {
  const result = {}

  baseConfig.entry_paths.forEach((rootPath) => {
    Object.assign(result, getEntryObject(rootPath))
  })

  return result
}

const productionConfig = {
  build: {
    ...config.build,
    manifest: true,
    emptyOutDir: false,
    outDir: join(process.cwd(), config.public_root_path),
    rollupOptions: {
      input: {
        ...baseConfig.build.rollupOptions.input,
        ...paths()
      }
    }
  }
}

module.exports = Object.assign(baseConfig, productionConfig)
