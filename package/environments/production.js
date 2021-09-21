/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const baseConfig = require('./base')
const config = require('../config')
const getEntryObject = require('../utils')
const { join } = require('path')

const paths = () => {
  const result = {}

  baseConfig.entry_paths.forEach((entry_path) => {
    Object.assign(result, getEntryObject(entry_path))
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
        ...paths()
      }
    }
  }
}

module.exports = Object.assign(baseConfig, productionConfig)
