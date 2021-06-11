const baseConfig = require('./base')
const config = require('../config')
const devServer = config.server

const devConfig =  {
  mode: 'development',
  server: {
    ...devServer,
    strictPort: true // 禁止自动切换 port 的功能, rails 需要加载需要
  }
}

module.exports = {
  ...baseConfig,
  ...devConfig
}
