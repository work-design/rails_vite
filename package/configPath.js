const { resolve } = require('path')

module.exports = process.env.RAILS_VITE_CONFIG || resolve('config', 'vite.yml')
