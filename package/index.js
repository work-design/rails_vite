/* eslint global-require: 0 */
/* eslint import/no-dynamic-require: 0 */

const { resolve } = require('path')
const { existsSync } = require('fs')
const baseConfig = require('./environments/base')
const config = require('./config')
const { nodeEnv } = require('./env')

const webpackConfig = () => {
  const path = resolve(__dirname, 'environments', `${nodeEnv}.js`)
  const environmentConfig = existsSync(path) ? require(path) : baseConfig
  return environmentConfig
}

module.exports = {
  config,
  viteConfig: webpackConfig(),
  baseConfig
}
