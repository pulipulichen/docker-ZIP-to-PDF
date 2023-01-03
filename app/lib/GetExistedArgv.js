const fs = require('fs')
const path = require('path')

module.exports = function () {
  let args = process.argv
  if (args.length < 3) {
    return []
  }

  args = args.slice(2)
  args = args.filter(arg => {
    return fs.existsSync(arg)
  })
  return args
}