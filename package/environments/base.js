/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { join } = require('path')
const config = require('../config')

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

  if (resolvedPath('vite-plugin-compress')) {
    const viteCompression = require('vite-plugin-compress').default
    plugins.push(
      viteCompression()
    )
  }

  if (resolvedPath('@vitejs/plugin-vue')) {
    const vue = require('@vitejs/plugin-vue').default
    plugins.push(
      vue()
    )
  }

  return plugins
}

module.exports = {
  base: config.base || '/',
  entry_paths: config.entry_paths,
  plugins: getPlugins(),
  resolve: {
    alias: config.alias
  },
  css: {
    postcss: join(process.cwd(), 'postcss.config.js')
  }
}
