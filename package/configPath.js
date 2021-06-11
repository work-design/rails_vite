const { resolve } = require('path')

module.exports = process.env.VITER_CONFIG || resolve('config', 'viter.yml')
