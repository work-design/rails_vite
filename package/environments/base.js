/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { join } = require('path')
const config = require('../config')
const rootPath = join(config.root_path)
const getEntryObject = require('../utils')

const resolvedPath = (packageName) => {
  try {
    return require.resolve(packageName)
  } catch (e) {
    if (e.code !== 'MODULE_NOT_FOUND') {
      throw e
    }
    return null
  }
}

const getPlugins = () => {
  const plugins = []

  if (resolvedPath('vite-plugin-compression')) {
    const viteCompression = require('vite-plugin-compression')
    plugins.push(
      viteCompression()
    )
  }

  return plugins
}

module.exports = {
  root: join(process.cwd(), config.root_path),
  entry_paths: config.entry_paths,
  plugins: getPlugins(),
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
