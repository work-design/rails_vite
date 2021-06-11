/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { join } = require('path')
const config = require('../config')
const rootPath = join(config.root_path)
const getEntryObject = require('../paths')

module.exports = {
  root: join(process.cwd(), config.root_path),
  entry_paths: config.entry_paths,
  resolve: {
    alias: config.alias
  },
  css: {
    postcss: join(process.cwd(), 'postcss.config.js')
  },
  build: {
    rollupOptions: {
      input: getEntryObject(rootPath)
    }
  }
}
