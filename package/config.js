const { resolve } = require('path')
const yaml = require('js-yaml')
const { readFileSync } = require('fs')
const { railsEnv } = require('./env')
const configPath = require('./configPath')

const defaultConfigPath = require.resolve('../config/viter_default.yml')

const getDefaultConfig = () => {
  const defaultConfig = yaml.load(readFileSync(defaultConfigPath), 'utf8')
  return defaultConfig[railsEnv] || defaultConfig.production
}

const defaults = getDefaultConfig()
const app = yaml.load(readFileSync(configPath), 'utf8')[railsEnv]

const config = Object.assign(defaults, app)

// Ensure that the publicPath includes our asset host so dynamic imports
// (code-splitting chunks and static assets) load from the CDN instead of a relative path.
const getPublicPath = () => {
  const rootUrl = process.env.VITER_ASSET_HOST || '/'
  return `${rootUrl}${config.public_output_path}/`
}

config.publicPath = getPublicPath()
config.publicPathWithoutCDN = `/${config.public_output_path}/`

module.exports = config
