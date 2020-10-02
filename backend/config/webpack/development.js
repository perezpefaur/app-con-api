process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const path = require("path")

environment.plugins.append(
  "CleanWebpackPlugin",
  new CleanWebpackPlugin({
    verbose: true
  })
)

module.exports = environment.toWebpackConfig()
